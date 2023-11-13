.PHONY: build-free
build-free:
	@echo "Building free tier compliance pack"
	rm -rf ./build/k8s_compliance_free
	mkdir -p ./build/k8s_compliance_free
	mkdir ./build/k8s_compliance_free/macros
	mkdir ./build/k8s_compliance_free/models
	cp -r macros/free ./build/k8s_compliance_free/macros/.
	cp -r macros/shared ./build/k8s_compliance_free/macros/.
	cp -r models/free ./build/k8s_compliance_free/models/.
	cp dbt_project.yml ./build/k8s_compliance_free/
	zip -r ./build/k8s_compliance_free.zip ./build/k8s_compliance_free

.PHONY: publish-free
publish-free: build-free
	@echo "Publishing free tier compliance pack"
	cloudquery addon publish ./manifest-free.json v1.0.0 --finalize