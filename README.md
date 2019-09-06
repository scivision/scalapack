[![Actions Status](https://github.com/scivision/mumps/workflows/ci/badge.svg)](https://github.com/scivision/mumps/actions)

# Netlib Scalapack

Use the
[Meson build system](https://mesonbuild.com)
to build the
[unmodified Scalapack source code](http://www.netlib.org/scalapack/).

If `example1` fails to build or run, the Scalapack library is probably not built / linked correctly.


## Build


```sh
meson setup build

meson test -C build

meson install -C build
```

### options

The default precision is `d` meaning real float64.
The build-time parameter `-Darith=d` may be optionally specified:

```sh
-Darith=s  # real32
-Darith=d  # real64
-Darith=c  # complex64
-Darith=z  # complex128
```

---

use the `--prefix` option to install Scalapack under a directory.
For example: `--prefix ~/mylibs` will install Scalapack under `~/mylibs/scalapack-2.0.2/`

---

If you need to specify MPI compiler wrappers, do like:

```sh
FC=~/lib_gcc/openmpi-3.1.4/bin/mpif90 CC=~/lib_gcc/openmpi-3.1.4/bin/mpicc meson build
```

## Notes

Original Scalapack [README](./README)

On Windows, you can alternatively get Scalapack with the
[Intel compilers](https://software.intel.com/en-us/qualify-for-free-software),
which already have Scalapack built-in to Intel MKL.
