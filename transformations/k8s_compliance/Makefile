.PHONY: build-free
build-free:
	@echo "Building free tier compliance pack"
	rm -rf ./build/k8s_compliance_free
	mkdir -p ./build/k8s_compliance_free
	mkdir ./build/k8s_compliance_free/macros
	mkdir ./build/k8s_compliance_free/models
	cp -r macros/free ./build/k8s_compliance_free/macros/.
	cp -r models/free ./build/k8s_compliance_free/models/.
	cp dbt_project.yml ./build/k8s_compliance_free/
	zip -r ./build/k8s_compliance_free.zip ./build/k8s_compliance_free

.PHONY: build-premium
build-premium:
	@echo "Building premium tier compliance pack"
	rm -rf ./build/k8s_compliance_premium
	mkdir -p ./build/k8s_compliance_premium
	mkdir ./build/k8s_compliance_premium/macros
	mkdir ./build/k8s_compliance_premium/models
	cp -r macros/pro ./build/k8s_compliance_premium/macros/.
	cp -r models/pro ./build/k8s_compliance_premium/models/.
	cp dbt_project.yml ./build/k8s_compliance_premium/
	cp requirements.txt ./build/k8s_compliance_premium/
	zip -r ./build/k8s_compliance_premium.zip ./build/k8s_compliance_premium