.PHONY: build-free
build-free:
	@echo "Building free tier compliance pack"
	rm -rf ./build/azure_compliance_free
	mkdir -p ./build/azure_compliance_free
	mkdir ./build/azure_compliance_free/macros
	mkdir ./build/azure_compliance_free/models
	cp -r macros/free ./build/azure_compliance_free/macros/.
	cp -r macros/shared ./build/azure_compliance_free/macros/.
	cp -r models/free ./build/azure_compliance_free/models/.
	cp dbt_project.yml ./build/azure_compliance_free/
	zip -r ./build/azure_compliance_free.zip ./build/azure_compliance_free

.PHONY: build-premium
build-premium:
	@echo "Building premium tier compliance pack"
	rm -rf ./build/azure_compliance_premium
	mkdir -p ./build/azure_compliance_premium
	mkdir ./build/azure_compliance_premium/macros
	mkdir ./build/azure_compliance_premium/models
	cp -r macros/pro ./build/azure_compliance_premium/macros/.
	cp -r macros/shared ./build/azure_compliance_free/macros/.
	cp -r models/pro ./build/azure_compliance_premium/models/.
	cp dbt_project.yml ./build/azure_compliance_premium/
	cp requirements.txt ./build/azure_compliance_premium/
	zip -r ./build/azure_compliance_premium.zip ./build/azure_compliance_premium