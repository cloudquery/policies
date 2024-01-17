.PHONY: gen-site
gen-site:
	# AWS asset-inventory-free
	dbt docs generate --static  --profiles-dir dbt-docs-site --project-dir transformations/aws/asset-inventory-free
	cp transformations/aws/asset-inventory-free/target/static_index.html dbt-docs-site/aws-asset-inventory-free.html
	# AWS compliance-free
	dbt docs generate --static  --profiles-dir dbt-docs-site --project-dir transformations/aws/compliance-free
	cp transformations/aws/compliance-free/target/static_index.html dbt-docs-site/aws-compliance-free.html
	# AWS compliance-premium
	dbt docs generate --static  --profiles-dir dbt-docs-site --project-dir transformations/aws/compliance-premium
	cp transformations/aws/compliance-premium/target/static_index.html dbt-docs-site/aws-compliance-premium.html
	# AWS cost
	dbt docs generate --static  --profiles-dir dbt-docs-site --project-dir transformations/aws/cost
	cp transformations/aws/cost/target/static_index.html dbt-docs-site/aws-cost.html
	# AWS data-resilience
	dbt docs generate --static  --profiles-dir dbt-docs-site --project-dir transformations/aws/data-resilience
	cp transformations/aws/data-resilience/target/static_index.html dbt-docs-site/aws-data-resilience.html
	# AWS encryption
	dbt docs generate --static  --profiles-dir dbt-docs-site --project-dir transformations/aws/encryption
	cp transformations/aws/encryption/target/static_index.html dbt-docs-site/aws-encryption.html

	# Azure compliance-free
	dbt docs generate --static  --profiles-dir dbt-docs-site --project-dir transformations/azure/compliance-free
	cp transformations/azure/compliance-free/target/static_index.html dbt-docs-site/azure-compliance-free.html
	# Azure compliance-premium
	dbt docs generate --static  --profiles-dir dbt-docs-site --project-dir transformations/azure/compliance-premium
	cp transformations/azure/compliance-premium/target/static_index.html dbt-docs-site/azure-compliance-premium.html

	# GCP compliance-free
	dbt docs generate --static  --profiles-dir dbt-docs-site --project-dir transformations/gcp/compliance-free
	cp transformations/gcp/compliance-free/target/static_index.html dbt-docs-site/gcp-compliance-free.html
	# GCP compliance-premium
	dbt docs generate --static  --profiles-dir dbt-docs-site --project-dir transformations/gcp/compliance-premium
	cp transformations/gcp/compliance-premium/target/static_index.html dbt-docs-site/gcp-compliance-premium.html

	# Kubernetes compliance-free
	dbt docs generate --static  --profiles-dir dbt-docs-site --project-dir transformations/k8s/compliance-free
	cp transformations/k8s/compliance-free/target/static_index.html dbt-docs-site/k8s-compliance-free.html
	# Kubernetes compliance-premium
	dbt docs generate --static  --profiles-dir dbt-docs-site --project-dir transformations/k8s/compliance-premium
	cp transformations/k8s/compliance-premium/target/static_index.html dbt-docs-site/k8s-compliance-premium.html
