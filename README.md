# Netlib Scalapack

[![Actions Status](https://github.com/scivision/scalapack/workflows/ci_linux/badge.svg)](https://github.com/scivision/scalapack/actions)
[![Actions Status](https://github.com/scivision/scalapack/workflows/ci_macos/badge.svg)](https://github.com/scivision/scalapack/actions)

Scalapack with CMake and Meson enhancements to make Scalapack easier to use directly in other projects.
The Scalapack
[source code](http://www.netlib.org/scalapack/) is unmodified.
MPI is required for Scalapack.
Scalapack 2.1 works with OpenMPI 4.x, while Scalapack 2.0 worked with OpenMPI &lt; 4.

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

## Notes

Original Scalapack [README](./README)

Scalapack is included with the
[Intel Parallel Studio](https://software.intel.com/en-us/qualify-for-free-software),
for Windows as well.
