include(FetchContent)
set(scalapack_urls
https://github.com/Reference-ScaLAPACK/scalapack/archive/refs/tags/v2.1.0.tar.gz
http://www.netlib.org/scalapack/scalapack-2.1.0.tgz)
set(scalapack_sha256 f03fda720a152030b582a237f8387014da878b84cbd43c568390e9f05d24617f)

FetchContent_Declare(scalapack
URL ${scalapack_urls}
URL_HASH SHA256=${scalapack_sha256})

if(NOT scalapack_POPULATED)
  FetchContent_Populate(scalapack)
endif()
