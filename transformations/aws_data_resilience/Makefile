.PHONY: build
build:
	@echo "Building free tier compliance pack"
	rm -rf ./build/aws_data_resilience
	mkdir -p ./build/aws_data_resilience
	cp -r macros models README.md dbt_project.yml ./build/aws_data_resilience
	zip -r ./build/aws_data_resilience.zip ./build/aws_data_resilience

.PHONY: publish
publish: publish
	@echo "Publishing pack"
	cloudquery addon publish ./manifest.json v1.0.0 --finalize