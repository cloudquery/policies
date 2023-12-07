import path from "node:path";
import fs from "node:fs/promises";
import { pathExists } from "path-exists";
import { execa } from "execa";
import { temporaryDirectoryTask } from "tempy";
import { parse, stringify } from "yaml";

const validateProjectDirectory = async (dbtProjectDirectory) => {
  if (!(await pathExists(dbtProjectDirectory))) {
    throw new Error(
      `dbt project directory '${dbtProjectDirectory}' does not exist`,
    );
  }
  if (!(await pathExists(`${dbtProjectDirectory}/dbt_project.yml`))) {
    throw new Error(
      `dbt project directory '${dbtProjectDirectory}' does not contain a dbt_project.yml file`,
    );
  }
  if (!(await pathExists(`${dbtProjectDirectory}/requirements.txt`))) {
    throw new Error(
      `dbt project directory '${dbtProjectDirectory}' does not contain a requirements.txt file`,
    );
  }
  if (!(await pathExists(`${dbtProjectDirectory}/manifest.json`))) {
    throw new Error(
      `dbt project directory '${dbtProjectDirectory}' does not contain a manifest.json file`,
    );
  }
};

const compileDbtProject = async (dbtProjectDirectory, dbtArguments) => {
  const profilesFile = `${dbtProjectDirectory}/tests/profiles.yml`;
  const profiles = parse(await fs.readFile(profilesFile, "utf8"));
  const profileName = Object.keys(profiles)[0];
  const targets = Object.keys(profiles[profileName].outputs);
  const fullProjectDirectory = path.resolve(dbtProjectDirectory);
  for (const target of targets) {
    console.log(
      `Compiling dbt project in ${fullProjectDirectory} with target: '${target}'`,
    );
    await execa(
      "dbt",
      [
        "compile",
        "--target",
        target,
        "--profiles-dir",
        "tests",
        "--target-path",
        `target/${target}`,
        ...dbtArguments,
      ],
      {
        cwd: fullProjectDirectory,
        stdout: "inherit",
        stderr: "inherit",
      },
    );
    console.log(`Done compiling dbt project in ${fullProjectDirectory}`);
  }

  const targetDirectories = targets.map(
    (target) => `${fullProjectDirectory}/target/${target}`,
  );
  return targetDirectories;
};

const addDependencies = (node, allNodes, allMacros, filesToPack) => {
  if (node.unique_id.startsWith("macro.dbt.")) {
    // Skip dbt internal macros
    return;
  }
  filesToPack.add(node.original_file_path);
  const dependsOnNodes = node.depends_on?.nodes ?? [];
  for (const dependency of dependsOnNodes) {
    addDependencies(allNodes[dependency], allNodes, allMacros, filesToPack);
  }
  const dependsOnMacros = node.depends_on?.macros ?? [];
  for (const macro of dependsOnMacros) {
    addDependencies(allMacros[macro], allNodes, allMacros, filesToPack);
  }
};

const analyzeManifestFiles = async (targetDirectories) => {
  const filesToPack = new Set();
  for (const targetDirectory of targetDirectories) {
    const manifestFile = `${targetDirectory}/manifest.json`;
    console.log(`Analyzing manifest file ${manifestFile}`);
    const manifest = JSON.parse(await fs.readFile(manifestFile, "utf8"));
    const { nodes: allNodes, macros: allMacros } = manifest;

    for (const node of Object.values(allNodes)) {
      addDependencies(node, allNodes, allMacros, filesToPack);
    }
  }

  return [...filesToPack];
};

const getZipPath = (file) => {
  const indexOfModels = file.indexOf("models/");
  if (indexOfModels >= 0) {
    return file.slice(indexOfModels);
  }
  const indexOfMacros = file.indexOf("macros/");
  return file.slice(indexOfMacros);
};

const updateProjectConfig = async (configFile) => {
  const config = parse(await fs.readFile(configFile, "utf8"));
  config["model-paths"] = ["models"];
  config["macro-paths"] = ["macros"];
  await fs.writeFile(configFile, stringify(config));
};

const zipProject = async (dbtProjectDirectory, filesToPack) => {
  const projectManifest = JSON.parse(
    await fs.readFile(`${dbtProjectDirectory}/manifest.json`, "utf8"),
  );
  const outputFile = path.resolve(dbtProjectDirectory, projectManifest.path);
  const withZipPaths = filesToPack.map((file) => {
    const copyFrom = path.resolve(dbtProjectDirectory, file);
    const copyTo = getZipPath(file);
    return { copyFrom, copyTo };
  });
  const withProjectFiles = [
    ...withZipPaths,
    {
      copyFrom: path.resolve(dbtProjectDirectory, "dbt_project.yml"),
      copyTo: "dbt_project.yml",
    },
    {
      copyFrom: path.resolve(dbtProjectDirectory, "requirements.txt"),
      copyTo: "requirements.txt",
    },
  ];
  console.log(`Packing ${withProjectFiles.length} files`);
  await temporaryDirectoryTask(async (temporaryDirectory) => {
    for (const { copyFrom, copyTo } of withProjectFiles) {
      const copyToPath = path.resolve(temporaryDirectory, copyTo);
      await fs.mkdir(path.dirname(copyToPath), { recursive: true });
      await fs.copyFile(copyFrom, copyToPath);
    }
    await updateProjectConfig(`${temporaryDirectory}/dbt_project.yml`);
    await fs.mkdir(path.dirname(outputFile), { recursive: true });
    await execa("zip", ["-r", outputFile, "."], {
      cwd: temporaryDirectory,
      stdout: "inherit",
      stderr: "inherit",
    });
    console.log(`Done packing to ${outputFile}`);
  });
};

export const pack = async ({ projectDir, dbtArgs }) => {
  await validateProjectDirectory(projectDir);
  const targetDirectories = await compileDbtProject(projectDir, dbtArgs);
  const filesToPack = await analyzeManifestFiles(targetDirectories);
  await zipProject(projectDir, filesToPack);
};
