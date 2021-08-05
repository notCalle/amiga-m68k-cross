![oci-image](https://github.com/notCalle/amiga-m68k-cross/workflows/oci-image/badge.svg)

# Amiga M680x0 Cross Compiler Tool Chain

## Cross Compiling Amiga M680x0 Code

The tool chain consists of `binutils` for the target `m68k-amiga-elf`, and `clang` from [LLVM 13].

### Container Image

The toolchain is installed under the `/opt/amiga` prefix, which is also the home directory of the `amiga` user that is the default user.

```shell
% docker run -it --rm -v `pwd`:/opt/amiga/mnt \
    docker.pkg.github.com/notcalle/amiga-m68k-cross/toolchain
```

[LLVM 13]: https://github.com/llvm/llvm-project/tree/release/13.x
