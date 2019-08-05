[![Build Status](https://dev.azure.com/mhirsch0512/scalapack/_apis/build/status/scivision.scalapack?branchName=master)](https://dev.azure.com/mhirsch0512/scalapack/_build/latest?definitionId=9&branchName=master)

# Netlib Scalapack

Use the
[Meson build system](https://mesonbuild.com)
to build the
[unmodified Scalapack source code](http://www.netlib.org/scalapack/).

If `example1` fails to build or run, the Scalapack library is probably not built / linked correctly.


## Build

use the `--prefix` option to install Scalapack under a directory.
For example: `--prefix ~/mylibs` will install Scalapack under `~/mylibs/scalapack-2.0.2/`

```sh
meson setup build

meson test -C build

meson install -C build
```


## Notes

Original Scalapack [README](./README)

On Windows, you can alternatively get Scalapack with the
[Intel compilers](https://software.intel.com/en-us/qualify-for-free-software),
which already have Scalapack built-in to Intel MKL.
