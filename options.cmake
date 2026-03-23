option(BUILD_SINGLE "Build single precision real" ON)
option(BUILD_DOUBLE "Build double precision real" ON)
option(BUILD_COMPLEX "Build single precision complex")
option(BUILD_COMPLEX16 "Build double precision complex")

# complex requires corresponding real
if(BUILD_COMPLEX)
  set(BUILD_SINGLE true)
endif()
if(BUILD_COMPLEX16)
  set(BUILD_DOUBLE true)
endif()

option(scalapack_find_lapack "find LAPACK" on)

option(scalapack_ENABLE_RPATH "Enable RPATH for installed shared libraries")

option(SCALAPACK_BUILD_TESTING "Build tests" ${SCALAPACK_IS_TOP_LEVEL})

# used with Git submodule to avoid rechecking each build for submodule changes
# for developers who switch submodule commits, need a fresh build of entire project.
set(FETCHCONTENT_UPDATES_DISCONNECTED ON)
set(FETCHCONTENT_QUIET OFF)
if(NOT scalapack_find_lapack)
  set(FETCHCONTENT_TRY_FIND_PACKAGE_MODE NEVER)
endif()

# Necessary for shared library with Visual Studio / Windows oneAPI
set(CMAKE_WINDOWS_EXPORT_ALL_SYMBOLS true)

# this is for convenience of those needing Lapack built
if(SCALAPACK_IS_TOP_LEVEL AND CMAKE_INSTALL_PREFIX_INITIALIZED_TO_DEFAULT)
  set_property(CACHE CMAKE_INSTALL_PREFIX PROPERTY VALUE "${PROJECT_BINARY_DIR}/local")
endif()
