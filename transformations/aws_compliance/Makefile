.PHONY: build-free
build-free:
	@echo "Building free tier compliance pack"
	rm -rf ./build/aws_compliance_free
	mkdir -p ./build/aws_compliance_free
	mkdir ./build/aws_compliance_free/macros
	mkdir ./build/aws_compliance_free/models
	cp -r macros/free ./build/aws_compliance_free/macros/.
	cp -r macros/shared ./build/aws_compliance_free/macros/.
	cp -r models/free ./build/aws_compliance_free/models/.
	cp dbt_project.yml ./build/aws_compliance_free/
	cp requirements.txt ./build/aws_compliance_free/
	zip -r ./build/aws_compliance_free.zip ./build/aws_compliance_free
	