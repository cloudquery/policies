.PHONY: gen-site
gen-site:
	make plugin_dir=aws/asset-inventory-free output_file_name=aws-asset-inventory-free gen-single-site
	make plugin_dir=aws/compliance-free output_file_name=aws-compliance-free gen-single-site
	make plugin_dir=aws/compliance-premium output_file_name=aws-compliance-premium gen-single-site
	make plugin_dir=aws/cost output_file_name=aws-cost gen-single-site
	make plugin_dir=aws/data-resilience output_file_name=aws-data-resilience gen-single-site
	make plugin_dir=aws/encryption output_file_name=aws-encryption gen-single-site

	make plugin_dir=azure/compliance-free output_file_name=azure-compliance-free gen-single-site
	make plugin_dir=azure/compliance-premium output_file_name=azure-compliance-premium gen-single-site

	make plugin_dir=gcp/compliance-free output_file_name=gcp-compliance-free gen-single-site
	make plugin_dir=gcp/compliance-premium output_file_name=gcp-compliance-premium gen-single-site

	make plugin_dir=k8s/compliance-free output_file_name=k8s-compliance-free gen-single-site
	make plugin_dir=k8s/compliance-premium output_file_name=k8s-compliance-premium gen-single-site

.PHONY: gen-single-site
gen-single-site:
	cloudquery migrate transformations/$(plugin_dir)/tests/postgres.yml
	dbt seed --target dev-pg --profiles-dir transformations/$(plugin_dir)/tests --project-dir transformations/$(plugin_dir)
	dbt run --profiles-dir dbt-docs-site --project-dir transformations/$(plugin_dir)
	dbt docs generate --static --profiles-dir dbt-docs-site --project-dir transformations/$(plugin_dir)
	cp transformations/$(plugin_dir)/target/static_index.html dbt-docs-site/$(output_file_name).html