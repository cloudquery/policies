.PHONY: gen-site
gen-site:
ifeq ($(shard),1/12)
	make plugin_dir=aws/asset-inventory-free output_file_name=aws-asset-inventory-free gen-single-site
endif
ifeq ($(shard),2/12)
	make plugin_dir=aws/compliance-free output_file_name=aws-compliance-free gen-single-site
endif
ifeq ($(shard),3/12)
	make plugin_dir=aws/compliance-premium output_file_name=aws-compliance-premium gen-single-site
endif
ifeq ($(shard),4/12)
	make plugin_dir=aws/cost output_file_name=aws-cost gen-single-site
endif
ifeq ($(shard),5/12)
	make plugin_dir=aws/data-resilience output_file_name=aws-data-resilience gen-single-site
endif
ifeq ($(shard),6/12)
	make plugin_dir=aws/encryption output_file_name=aws-encryption gen-single-site
endif

ifeq ($(shard),7/12)
	make plugin_dir=azure/compliance-free output_file_name=azure-compliance-free gen-single-site
endif
ifeq ($(shard),8/12)
	make plugin_dir=azure/compliance-premium output_file_name=azure-compliance-premium gen-single-site
endif

ifeq ($(shard),9/12)
	make plugin_dir=gcp/compliance-free output_file_name=gcp-compliance-free gen-single-site
endif
ifeq ($(shard),10/12)
	make plugin_dir=gcp/compliance-premium output_file_name=gcp-compliance-premium gen-single-site
endif

ifeq ($(shard),11/12)
	make plugin_dir=k8s/compliance-free output_file_name=k8s-compliance-free gen-single-site
endif
ifeq ($(shard),12/12)
	make plugin_dir=k8s/compliance-premium output_file_name=k8s-compliance-premium gen-single-site
endif

.PHONY: gen-single-site
gen-single-site:
	cloudquery migrate transformations/$(plugin_dir)/tests/postgres.yml
	dbt seed --target dev-pg --profiles-dir transformations/$(plugin_dir)/tests --project-dir transformations/$(plugin_dir)
	dbt run --profiles-dir dbt-docs-site --project-dir transformations/$(plugin_dir)
	dbt docs generate --static --profiles-dir dbt-docs-site --project-dir transformations/$(plugin_dir)
	cp transformations/$(plugin_dir)/target/static_index.html dbt-docs-site/$(output_file_name).html