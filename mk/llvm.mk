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
	cmake -G Ninja -B build/llvm -S deps/llvm-project/llvm \
		-DCMAKE_BUILD_TYPE=Release \
		-DCMAKE_INSTALL_PREFIX=$(PREFIX) \
		-DLLVM_ENABLE_PROJECTS='clang;clang-tools-extra' \
		-DLLVM_EXPERIMENTAL_TARGETS_TO_BUILD='M68k' \
		-DLLVM_TARGETS_TO_BUILD='' \

build/llvm:
	mkdir -p $@

.PHONY: clean-llvm
clean-llvm:
	-rm -rf build/llvm

##
## CONTAINERS
##
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
