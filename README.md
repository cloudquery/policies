# Premium Policies

Premium policies for CloudQuery plugins.

Policies are split by plugin and then by policy type. Each policy can have multiple ports for different databases (for example Snowflake and BigQuery).

## Deploying docs for a new policy

Policy documentation is automatically deployed to Vercel using the following two Github Actions:

* [transformations_docs_preview.yml](.github/workflows/transformations_docs_preview.yml) deploys the policies to the preview environment
* [transformations_docs_deploy.yml](.github/workflows/transformations_docs_deploy.yml) deploys the policies to the production environment

The Github Actions are sharded so that the documentation generation can happen in parallel. Under the hood the
Github Actions call the Makefile with an integer `shard` argument. The sharding is done manually in the Makefile.

## Adding a new policy
If you want to add a new policy to be documented then please add a new shard (in the Makefile and **both** Github Actions).