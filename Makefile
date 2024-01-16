.PHONY: gen-site
gen-site:
	# AWS asset-inventory-free
	dbt docs generate --static  --profiles-dir dbt-docs-site --project-dir transformations/aws/asset-inventory-free
	mkdir -p dbt-docs-site/public/aws-asset-inventory-free
	cp transformations/aws/asset-inventory-free/target/static_index.html dbt-docs-site/public/aws-asset-inventory-free/index.html
	# AWS compliance-free
	dbt docs generate --static  --profiles-dir dbt-docs-site --project-dir transformations/aws/compliance-free
	mkdir -p dbt-docs-site/public/aws-compliance-free
	cp transformations/aws/compliance-free/target/static_index.html dbt-docs-site/public/aws-compliance-free/index.html
	# AWS compliance-premium
	dbt docs generate --static  --profiles-dir dbt-docs-site --project-dir transformations/aws/compliance-premium
	mkdir -p dbt-docs-site/public/aws-compliance-premium
	cp transformations/aws/compliance-premium/target/static_index.html dbt-docs-site/public/aws-compliance-premium/index.html
	# AWS cost
	dbt docs generate --static  --profiles-dir dbt-docs-site --project-dir transformations/aws/cost
	mkdir -p dbt-docs-site/public/aws-cost
	cp transformations/aws/cost/target/static_index.html dbt-docs-site/public/aws-cost/index.html
	# AWS data-resilience
	dbt docs generate --static  --profiles-dir dbt-docs-site --project-dir transformations/aws/data-resilience
	mkdir -p dbt-docs-site/public/aws-data-resilience
	cp transformations/aws/data-resilience/target/static_index.html dbt-docs-site/public/aws-data-resilience/index.html
	# AWS encryption
	dbt docs generate --static  --profiles-dir dbt-docs-site --project-dir transformations/aws/encryption
	mkdir -p dbt-docs-site/public/aws-encryption
	cp transformations/aws/encryption/target/static_index.html dbt-docs-site/public/aws-encryption/index.html

	# Azure compliance-free
	dbt docs generate --static  --profiles-dir dbt-docs-site --project-dir transformations/azure/compliance-free
	mkdir -p dbt-docs-site/public/azure-compliance-free
	cp transformations/azure/compliance-free/target/static_index.html dbt-docs-site/public/azure-compliance-free/index.html
	# Azure compliance-premium
	dbt docs generate --static  --profiles-dir dbt-docs-site --project-dir transformations/azure/compliance-premium
	mkdir -p dbt-docs-site/public/azure-compliance-premium
	cp transformations/azure/compliance-premium/target/static_index.html dbt-docs-site/public/azure-compliance-premium/index.html

	# GCP compliance-free
	dbt docs generate --static  --profiles-dir dbt-docs-site --project-dir transformations/gcp/compliance-free
	mkdir -p dbt-docs-site/public/gcp-compliance-free
	cp transformations/gcp/compliance-free/target/static_index.html dbt-docs-site/public/gcp-compliance-free/index.html
	# GCP compliance-premium
	dbt docs generate --static  --profiles-dir dbt-docs-site --project-dir transformations/gcp/compliance-premium
	mkdir -p dbt-docs-site/public/gcp-compliance-premium
	cp transformations/gcp/compliance-premium/target/static_index.html dbt-docs-site/public/gcp-compliance-premium/index.html

	# Kubernetes compliance-free
	dbt docs generate --static  --profiles-dir dbt-docs-site --project-dir transformations/k8s/compliance-free
	mkdir -p dbt-docs-site/public/k8s-compliance-free
	cp transformations/k8s/compliance-free/target/static_index.html dbt-docs-site/public/k8s-compliance-free/index.html
	# Kubernetes compliance-premium
	dbt docs generate --static  --profiles-dir dbt-docs-site --project-dir transformations/k8s/compliance-premium
	mkdir -p dbt-docs-site/public/k8s-compliance-premium
	cp transformations/k8s/compliance-premium/target/static_index.html dbt-docs-site/public/k8s-compliance-premium/index.html
