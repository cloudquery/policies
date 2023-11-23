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

.PHONY: build-premium
build-premium:
	@echo "Building premium tier compliance pack"
	rm -rf ./build/aws_compliance_premium
	mkdir -p ./build/aws_compliance_premium
	mkdir ./build/aws_compliance_premium/macros
	mkdir ./build/aws_compliance_premium/models
	cp -r macros/free ./build/aws_compliance_premium/macros/.
	cp -r macros/pro ./build/aws_compliance_premium/macros/.
	cp -r macros/shared ./build/aws_compliance_premium/macros/.
	cp -r models/pro ./build/aws_compliance_premium/models/.
	cp -r models/shared ./build/aws_compliance_premium/models/.
	cp dbt_project.yml ./build/aws_compliance_premium/
	cp requirements.txt ./build/aws_compliance_premium/
	zip -r ./build/aws_compliance_premium.zip ./build/aws_compliance_premium