PACKAGE_ID := bifrost
PACKAGE_VERSION := 0.1.0.0
IMAGE_TAG := start9/$(PACKAGE_ID)/main:$(PACKAGE_VERSION)

# New Script Variables
EMBASSY_JS := scripts/embassy.js
EMBASSY_TS := scripts/embassy.ts
TS_FILES := $(shell find scripts -name "*.ts")

.PHONY: all build clean validate package scripts

all: package

# 1. Validate
validate:
	@echo "Validating package files..."
	@test -f manifest.yaml || (echo "ERROR: manifest.yaml not found" && exit 1)
	@test -f Dockerfile || (echo "ERROR: Dockerfile not found" && exit 1)

# 2. Bundle TypeScript into embassy.js
scripts: $(EMBASSY_JS)

$(EMBASSY_JS): $(TS_FILES)
	@echo "Bundling scripts..."
	deno bundle scripts/embassy.ts scripts/embassy.js

# 3. Build Docker Image
docker-images/x86_64.tar: Dockerfile docker_entrypoint.sh
	@mkdir -p docker-images
	@echo "Building Docker image..."
	docker buildx build \
		--tag $(IMAGE_TAG) \
		--platform linux/amd64 \
		--file Dockerfile \
		-o type=docker,dest=docker-images/x86_64.tar .

# 4. Package for StartOS (Now depends on scripts)
package: validate docker-images/x86_64.tar $(EMBASSY_JS)
	@echo "Creating s9pk package..."
	start-sdk pack
	@echo "Done! Package is ready."

clean:
	@rm -rf docker-images
	@rm -f $(PACKAGE_ID).s9pk
	@rm -f $(EMBASSY_JS)