PREFIX ?= $(HOME)/.local/amiga-m68k-cross
TARGET ?= m68k-amiga-elf
IMAGE_TAG_PREFIX ?= docker.pkg.github.com/notcalle/amiga-m68k-cross

include mk/binutils.mk
include mk/llvm.mk
include mk/vbcc.mk

.PHONY: build
build: build-binutils build-llvm build-vbcc

.PHONY: clean
clean: clean-binutils clean-llvm clean-vbcc
	-rmdir build

.PHONY: install
install: install-binutils install-ld-hack install-llvm install-vbcc

##
## CONTAINERS
##
.PHONY: builder-container
builder-container:
	docker build \
		--file container/builder/Dockerfile \
		--tag $(IMAGE_TAG_PREFIX)/builder:latest \
		.

.PHONY: push-builder-container
push-builder-container:
	docker push $(IMAGE_TAG_PREFIX)/builder:latest


.PHONY: toolchain-container
toolchain-container:
	docker build \
		--file container/toolchain/Dockerfile \
		--build-arg IMAGE_TAG_PREFIX=$(IMAGE_TAG_PREFIX) \
		--tag $(IMAGE_TAG_PREFIX)/toolchain:latest \
		.

.PHONY: push-toolchain-container
push-toolchain-container:
	docker push $(IMAGE_TAG_PREFIX)/toolchain:latest
