.PHONY: gen-site
gen-site:
ifeq ($(shard),1)
	make transformation_dir=aws/asset-inventory-free output_file_name=aws-asset-inventory-free gen-single-site
endif
ifeq ($(shard),2)
	make transformation_dir=aws/compliance-free output_file_name=aws-compliance-free gen-single-site
endif
ifeq ($(shard),3)
	make transformation_dir=aws/cost output_file_name=aws-cost gen-single-site
endif
ifeq ($(shard),4)
	make transformation_dir=aws/data-resilience output_file_name=aws-data-resilience gen-single-site
endif
ifeq ($(shard),5)
	make transformation_dir=aws/encryption output_file_name=aws-encryption gen-single-site
endif

ifeq ($(shard),6)
	make transformation_dir=azure/compliance-free output_file_name=azure-compliance-free gen-single-site
endif

ifeq ($(shard),7)
	make transformation_dir=gcp/compliance-premium output_file_name=gcp-compliance gen-single-site
endif

ifeq ($(shard),8)
	make transformation_dir=k8s/compliance-premium output_file_name=k8s-compliance gen-single-site
endif

ifeq ($(shard),9)
	make transformation_dir=gcp/asset-inventory-free output_file_name=gcp-asset-inventory-free gen-single-site
endif

ifeq ($(shard),10)
	make transformation_dir=azure/asset-inventory-free output_file_name=azure-asset-inventory-free gen-single-site
endif

.PHONY: gen-single-site
gen-single-site:
	cloudquery migrate transformations/$(transformation_dir)/tests/postgres.yml
	dbt seed --target dev-pg --profiles-dir transformations/$(transformation_dir)/tests --project-dir transformations/$(transformation_dir)
	dbt run --target dev-pg --profiles-dir transformations/$(transformation_dir)/tests --project-dir transformations/$(transformation_dir)
	dbt docs generate --target dev-pg --static --profiles-dir transformations/$(transformation_dir)/tests --project-dir transformations/$(transformation_dir)
	cp transformations/$(transformation_dir)/target/static_index.html $(output_file_name).html