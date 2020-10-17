![oci-image](https://github.com/notCalle/amiga-m68k-cross/workflows/oci-image/badge.svg)

# Amiga M680x0 Cross Compiler Tool Chain

## Cross Compiling Amiga M680x0 Code

The tool chain consists of `binutils` for the target `m68k-amiga-elf`, and `clang` from the not yet merged [LLVM M680x0] fork.

### Container Image

The toolchain is installed under the `/opt/amiga` prefix, which is also the home directory of the `amiga` user that is the default user.

```shell
% docker run -it --rm -v `pwd`:/opt/amiga/mnt \
    docker.pkg.github.com/notcalle/amiga-m68k-cross/toolchain
```

[LLVM M680x0]: https://github.com/M680x0/M680x0-mono-repo
