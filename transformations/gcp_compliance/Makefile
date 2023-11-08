.PHONY: build-free
build-free:
	@echo "Building free tier compliance pack"
	rm -rf ./build/gcp_compliance_free
	mkdir -p ./build/gcp_compliance_free
	mkdir ./build/gcp_compliance_free/macros
	mkdir ./build/gcp_compliance_free/models
	cp -r macros/free ./build/gcp_compliance_free/macros/.
	cp -r macros/shared ./build/gcp_compliance_free/macros/.
	cp -r models/free ./build/gcp_compliance_free/models/.
	cp dbt_project.yml ./build/gcp_compliance_free/
	zip -r ./build/gcp_compliance_free.zip ./build/gcp_compliance_free

.PHONY: publish-free
publish-free: build-free
	@echo "Publishing free tier compliance pack"
	cloudquery addon publish ./manifest-free.json v1.0.0 --finalize