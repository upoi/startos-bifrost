# =============================================================================
# Family AI Gateway - StartOS Package Build System
# =============================================================================

# Package metadata
PACKAGE_ID := bifrost
PACKAGE_VERSION := 0.1.0.0
# The image tag MUST match what is in your manifest.yaml
IMAGE_TAG := start9/$(PACKAGE_ID)/main:$(PACKAGE_VERSION)

# StartOS SDK tools
START_SDK := start-sdk

.PHONY: all build clean validate package

all: package

# 1. Validate manifest and required files
validate:
	@echo "Validating package files..."
	@test -f manifest.yaml || (echo "ERROR: manifest.yaml not found" && exit 1)
	@test -f Dockerfile || (echo "ERROR: Dockerfile not found" && exit 1)
	@test -f icon.png || (echo "ERROR: icon.png not found" && exit 1)
	@test -f instructions.md || (echo "ERROR: instructions.md not found" && exit 1)
	@echo "Validation passed!"

# 2. Build the Docker image and export to the format the SDK expects
docker-images/x86_64.tar: Dockerfile docker_entrypoint.sh
	@mkdir -p docker-images
	@echo "Building Docker image for x86_64..."
	docker buildx build \
		--tag $(IMAGE_TAG) \
		--platform linux/amd64 \
		--file Dockerfile \
		-o type=docker,dest=docker-images/x86_64.tar .

# 3. Alias for the docker build
build: docker-images/x86_64.tar

# 4. Package for StartOS
package: validate build
	@echo "Creating s9pk package..."
	$(START_SDK) pack
	@echo "Done! Your package is ready."

# Clean build artifacts
clean:
	@echo "Cleaning..."
	@rm -rf docker-images
	@rm -f $(PACKAGE_ID).s9pk
	@echo "Clean complete!"