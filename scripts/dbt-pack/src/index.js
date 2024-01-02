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
  const requiredFiles = [
    "dbt_project.yml",
    "requirements.txt",
    "manifest.json",
    "README.md",
  ];
  for (const requiredFile of requiredFiles) {
    if (!(await pathExists(`${dbtProjectDirectory}/${requiredFile}`))) {
      throw new Error(
        `dbt project directory '${dbtProjectDirectory}' does not contain a ${requiredFile} file`,
      );
    }
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
  if (node.resource_type !== "model" && node.resource_type !== "macro") {
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

const getModels = async (dbtProjectDirectory) => {
  const dirents = await fs.readdir(`${dbtProjectDirectory}/models`, {
    withFileTypes: true,
  });
  const models = dirents
    .filter((dirent) => dirent.isFile() && dirent.name.endsWith(".sql"))
    .map((dirent) => dirent.name);
  const withContent = await Promise.all(
    models.map(async (model) =>
      fs.readFile(`${dbtProjectDirectory}/models/${model}`, "utf8"),
    ),
  );
  return withContent;
};

const getChecksByFramework = async (models) => {
  const pattern = /\({{\s?(.*?)\(["'](.*?)["'].+?["'](.*?)["']\)\s?}}\)/g;
  const queries = models.flatMap((model) => {
    const matches = [...model.matchAll(pattern)];
    if (matches.length > 0) {
      return matches
        .map((match) => {
          const [, checkName, framework, checkId] = match;
          return { checkName, framework, checkId };
        })
        .sort((a, b) =>
          a.checkId.localeCompare(b.checkId, undefined, { numeric: true }),
        );
    }
    return [];
  });
  // eslint-disable-next-line unicorn/no-array-reduce
  return queries.reduce((accumulator, { checkName, framework, checkId }) => {
    if (!accumulator[framework]) {
      accumulator[framework] = [];
    }
    accumulator[framework].push({ checkName, checkId });
    return accumulator;
  }, {});
};

const updateReadme = async (dbtProjectDirectory, checksByFramework) => {
  const readmeFile = `${dbtProjectDirectory}/README.md`;
  const readme = await fs.readFile(readmeFile, "utf8");
  const pattern =
    /<!-- AUTO-GENERATED-INCLUDED-CHECKS-START -->[\S\s]*<!-- AUTO-GENERATED-INCLUDED-CHECKS-END -->/;
  const includedChecks = Object.entries(checksByFramework)
    .map(([framework, checks]) => {
      const listItems = checks
        .map(
          ({ checkName, checkId }) => `- ✅ \`${checkId}\`: \`${checkName}\``,
        )
        .join("\n");
      return `\n\n##### \`${framework}\`\n\n${listItems}`;
    })
    .join("");
  const updatedReadme = readme.replace(
    pattern,
    `<!-- AUTO-GENERATED-INCLUDED-CHECKS-START -->
#### Included Checks${includedChecks}
<!-- AUTO-GENERATED-INCLUDED-CHECKS-END -->`,
  );
  await fs.writeFile(readmeFile, updatedReadme);
};

export const appendQueries = async ({ projectDir }) => {
  await validateProjectDirectory(projectDir);
  const models = await getModels(projectDir);
  const checksByFramework = await getChecksByFramework(models);
  await updateReadme(projectDir, checksByFramework);
};
