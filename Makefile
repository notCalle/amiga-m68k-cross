PREFIX ?= $(HOME)/.local/amiga-m68k-cross
TARGET ?= m68k-amiga-elf
IMAGE_TAG_PREFIX ?= docker.pkg.github.com/notcalle/amiga-m68k-cross

.PHONY: build
build: build-binutils build-llvm build-vbcc

.PHONY: clean
clean: clean-binutils clean-llvm clean-vbcc
	-rmdir build

.PHONY: install
install: install-binutils install-ld-hack install-llvm install-vbcc

##
## BINUTILS
##

# LLVM is funny that way, it requires ld to be named gcc
.PHONY: install-ld-hack
install-ld-hack: $(PREFIX)/bin/gcc

$(PREFIX)/bin/gcc: install-binutils
	ln -fs $(TARGET)-ld $@

.PHONY: install-binutils
install-binutils: build-binutils
	make -C build/binutils install-strip-host

.PHONY: build-binutils
build-binutils: build/binutils/Makefile
	make -C build/binutils all-host

build/binutils/Makefile: build/binutils
	cd build/binutils && \
	../../deps/binutils-gdb/configure \
		--prefix=$(PREFIX) \
		--target=$(TARGET)

build/binutils:
	mkdir -p $@

.PHONY: clean-binutils
clean-binutils:
	-rm -rf build/binutils

##
## LLVM / CLANG
##
.PHONY: install-llvm
install-llvm: install-clang

.PHONY: install-clang
install-clang: build-clang
	ninja $(NINJA_FLAGS) -C build/llvm install-clang-stripped

.PHONY: build-llvm
build-llvm: build-clang

.PHONY: build-clang
build-clang: build/llvm/build.ninja
	ninja $(NINJA_FLAGS) -C build/llvm clang

build/llvm/build.ninja: build/llvm
	cmake -G Ninja -B build/llvm -S deps/M680x0-mono-repo/llvm \
		-DCMAKE_BUILD_TYPE=Release \
		-DCMAKE_INSTALL_PREFIX=$(PREFIX) \
		-DLLVM_ENABLE_PROJECTS='clang;clang-tools-extra' \
		-DLLVM_EXPERIMENTAL_TARGETS_TO_BUILD='M680x0' \
		-DLLVM_TARGETS_TO_BUILD='' \

build/llvm:
	mkdir -p $@

.PHONY: clean-llvm
clean-llvm:
	-rm -rf build/llvm

##
## VBCC XDK
##
.PHONY: install-vbcc
install-vbcc:
	make -C container/vbcc PREFIX=$(PREFIX) install

.PHONY: build-vbcc
build-vbcc:
	make -C container/vbcc PREFIX=$(PREFIX) all

.PHONY: clean-vbcc
clean-vbcc:
	make -C container/vbcc clean

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


.PHONY: binutils-container
binutils-container:
	docker build \
		--file container/binutils/Dockerfile \
		--build-arg IMAGE_TAG_PREFIX=$(IMAGE_TAG_PREFIX) \
		--tag $(IMAGE_TAG_PREFIX)/binutils:latest \
		.

.PHONY: push-binutils-container
push-binutils-container:
	docker push $(IMAGE_TAG_PREFIX)/binutils:latest

.PHONY: llvm-container
llvm-container:
	docker build \
		--file container/llvm/Dockerfile \
		--build-arg IMAGE_TAG_PREFIX=$(IMAGE_TAG_PREFIX) \
		--build-arg NINJA_FLAGS="$(NINJA_FLAGS)" \
		--tag $(IMAGE_TAG_PREFIX)/llvm:latest \
		.

.PHONY: push-llvm-container
push-llvm-container:
	docker push $(IMAGE_TAG_PREFIX)/llvm:latest

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

.PHONY: vbcc-xdk-container
vbcc-xdk-container:
	docker build \
		--file container/vbcc/Dockerfile \
		--build-arg IMAGE_TAG_PREFIX=$(IMAGE_TAG_PREFIX) \
		--tag $(IMAGE_TAG_PREFIX)/vbcc-xdk:latest \
		container/vbcc

.PHONY: push-vbcc-xdk-container
push-vbcc-xdk-container:
	docker push $(IMAGE_TAG_PREFIX)/vbcc-xdk:latest
