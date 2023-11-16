.PHONY: build
build:
	rm -rf ./build/aws_compliance
	mkdir -p ./build/aws_compliance
	cp -r grafana README.md ./build/aws_compliance
	zip -r ./build/aws_compliance.zip ./build/aws_compliance

.PHONY: publish
publish: publish
	cloudquery addon publish ./manifest.json v1.0.0 --finalize