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
