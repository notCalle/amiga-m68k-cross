PREFIX ?= $(HOME)/.local/amiga-m68k-cross
TARGET ?= m68k-amiga-elf

.PHONY: install
install: install-binutils install-clang install-ld-gcc

# LLVM is funny that way, it requires ld to be named gcc
.PHONY: install-ld-gcc
install-gcc: $(PREFIX)/bin/gcc

$(PREFIX)/bin/gcc:
	ln -fs $(TARGET)-ld $@

.PHONY: install-binutils
install-binutils: build/binutils/Makefile
	make -C build/binutils all-host install-strip-host

build/binutils/Makefile: build/binutils
	cd build/binutils && \
	../../deps/binutils-gdb/configure \
		--prefix=$(PREFIX) \
		--target=$(TARGET)

build/binutils:
	mkdir -p $@

.PHONY: install-clang
install-clang: build/llvm/build.ninja
	ninja -C build/llvm install-clang-stripped

build/llvm/build.ninja: build/llvm
	cmake -G Ninja -B build/llvm -S deps/M680x0-mono-repo/llvm \
		-DCMAKE_BUILD_TYPE=Release \
		-DCMAKE_INSTALL_PREFIX=$(PREFIX) \
		-DLLVM_ENABLE_PROJECTS='clang;clang-tools-extra' \
		-DLLVM_EXPERIMENTAL_TARGETS_TO_BUILD='M680x0' \
		-DLLVM_TARGETS_TO_BUILD='' \

build/llvm:
	mkdir -p $@

clean:
	rm -rf build
