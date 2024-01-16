.PHONY: gen-docs
gen-docs:
	node ../../../scripts/dbt-pack/index.js dbt-docs --project-dir .
.PHONY: gen-site
gen-site:
	dbt docs generate