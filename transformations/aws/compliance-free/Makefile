.PHONY: gen-docs
gen-docs:
	node ../../../scripts/dbt-pack/index.js dbt-docs --project-dir .
.PHONY: gen-site
gen-site:
	mkdir -p docs-site
	echo "aws compliance site" > docs-site/index.html