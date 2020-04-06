# Netlib Scalapack

![Actions Status](https://github.com/scivision/scalapack/workflows/ci_linux/badge.svg)
![Actions Status](https://github.com/scivision/scalapack/workflows/ci_macos/badge.svg)

Scalapack with CMake enhancements to make Scalapack easier to use directly in other projects.
The Scalapack
[source code](http://www.netlib.org/scalapack/)
is unmodified.
MPI is required for Scalapack.
Scalapack 2.1 works with OpenMPI 4.x, while Scalapack 2.0 worked with OpenMPI &lt; 4.

## Prereq

* Linux: `apt install cmake gfortran libopenmpi-dev liblapack-dev`
* Mac: `brew install gcc cmake open-mpi lapack`

### Windows MSYS2

```sh
pacman -S mingw-w64-x86_64-gcc-fortran mingw-w64-x86_64-msmpi mingw-w64-x86_64-lapack
```

and install
[Microsoft MS-MPI](https://docs.microsoft.com/en-us/message-passing-interface/microsoft-mpi-release-notes)
to get mpiexec.exe

## Build

```sh
cmake -B build
cmake --build build

# optional
cd build
ctest -V
```

or use Meson

```sh
meson setup build

meson test -C build

meson install -C build
```

### options

The default precision is

```sh
cmake -Darith="s;d"

# or
meson "-Darith=[s,d]"
```
meaning real 32-bit and 64-bit floating precision.
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
