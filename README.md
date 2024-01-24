# Premium Policies

Premium policies for CloudQuery plugins.

Policies are split by plugin and then by policy type. Each policy can have multiple ports for different databases (for example Snowflake and BigQuery).

## Deploying docs for a new policy

Policy documentation is automatically deployed to Vercel via a [GitHub Action workflow](.github/workflows/transformations_docs_deploy.yml).

The GitHub Actions are sharded so that the documentation generation can happen in parallel. Under the hood the
GitHub Actions call the Makefile with an integer `shard` argument. The sharding is done manually in the Makefile.

## Adding a new policy

If you want to add a new policy to be documented then please add a new shard (in the Makefile and in the GitHub Action).