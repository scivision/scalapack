cmake_minimum_required(VERSION 3.19)

project(BuildLAPACK
LANGUAGES Fortran
)

include(ExternalProject)

option(BUILD_SINGLE "Build single precision real" ON)
option(BUILD_DOUBLE "Build double precision real" ON)
option(BUILD_COMPLEX "Build single precision complex")
option(BUILD_COMPLEX16 "Build double precision complex")

set(lapack_cmake_args
-DCMAKE_INSTALL_PREFIX:PATH=${CMAKE_INSTALL_PREFIX}
-DBUILD_SHARED_LIBS:BOOL=${BUILD_SHARED_LIBS}
-DCMAKE_BUILD_TYPE=Release
-DBUILD_TESTING:BOOL=false
-DBUILD_SINGLE:BOOL=${BUILD_SINGLE}
-DBUILD_DOUBLE:BOOL=${BUILD_DOUBLE}
-DBUILD_COMPLEX:BOOL=${BUILD_COMPLEX}
-DBUILD_COMPLEX16:BOOL=${BUILD_COMPLEX16}
)

include(${PROJECT_SOURCE_DIR}/../cmake/GitSubmodule.cmake)
git_submodule("${PROJECT_SOURCE_DIR}/../lapack")

ExternalProject_Add(LAPACK
URL ${PROJECT_SOURCE_DIR}/../lapack
CMAKE_ARGS ${lapack_cmake_args}
)
