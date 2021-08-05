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

##
## CONTAINERS
##
.PHONY: clean-binutils
clean-binutils:
	-rm -rf build/binutils

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
