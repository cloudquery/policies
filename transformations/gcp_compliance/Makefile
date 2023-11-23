.PHONY: build-free
build-free:
	@echo "Building free tier compliance pack"
	rm -rf ./build/gcp_compliance_free
	mkdir -p ./build/gcp_compliance_free
	mkdir ./build/gcp_compliance_free/macros
	mkdir ./build/gcp_compliance_free/models
	cp -r macros/free ./build/gcp_compliance_free/macros/.
	cp -r models/free ./build/gcp_compliance_free/models/.
	cp dbt_project.yml ./build/gcp_compliance_free/
	zip -r ./build/gcp_compliance_free.zip ./build/gcp_compliance_free

.PHONY: build-premium
build-premium:
	@echo "Building premium tier compliance pack"
	rm -rf ./build/gcp_compliance_premium
	mkdir -p ./build/gcp_compliance_premium
	mkdir ./build/gcp_compliance_premium/macros
	mkdir ./build/gcp_compliance_premium/models
	cp -r macros/free ./build/gcp_compliance_premium/macros/.
	cp -r macros/pro ./build/gcp_compliance_premium/macros/.
	cp -r models/pro ./build/gcp_compliance_premium/models/.
	cp dbt_project.yml ./build/gcp_compliance_premium/
	cp requirements.txt ./build/gcp_compliance_premium/
	zip -r ./build/gcp_compliance_premium.zip ./build/gcp_compliance_premium