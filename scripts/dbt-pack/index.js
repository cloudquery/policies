#!/usr/bin/env node
import path from "node:path";
import yargs from "yargs";
import { hideBin } from "yargs/helpers";
import { pack } from "./src/index.js";

yargs(hideBin(process.argv))
  .command(
    "dbt-pack",
    "Package dbt project into a single zip",
    () => {},
    async ({ projectDir, dbtArg }) => {
      await pack({
        projectDir: path.resolve(projectDir),
        dbtArgs: dbtArg || [],
      });
    },
  )
  .option("project-dir", {
    alias: "p",
    type: "string",
    description: "Path to dbt project directory",
    demandOption: true,
  })
  .option("dbt-arg", {
    type: "array",
    description: "Array of dbt arguments to pass to dbt compile command",
  })
  .demandCommand(1)
  .strict()
  .parse();
