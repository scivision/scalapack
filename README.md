# Netlib Scalapack

![Actions Status](https://github.com/scivision/scalapack/workflows/ci/badge.svg)

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

# optional self-tests
ctest --test-dir build
```

If Lapack is needed:

```sh
cmake -S scripts -B scripts/build -DCMAKE_INSTALL_PREFIX=~/mylibs
cmake --build scripts/build

cmake -B build -DLAPACK_ROOT=~/mylibs
cmake --build build
```

### options

The default is to build real32, real64.
The build-time parameter `-Darith=d` may be optionally specified:

```sh
-Darith=s  # real32
-Darith=d  # real64
-Darith=c  # complex64
-Darith=z  # complex128
```

## Notes

Scalapack is included with
[Intel oneAPI](https://software.intel.com/content/www/us/en/develop/articles/free-intel-software-developer-tools.html),
for Windows as well.
