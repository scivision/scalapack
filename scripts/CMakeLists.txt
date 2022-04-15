cmake_minimum_required(VERSION 3.19...3.23)

project(BuildLAPACK
LANGUAGES Fortran
)

if(NOT DEFINED arith)
  set(arith "s;d")
endif()

include(ExternalProject)

set(lapack_cmake_args
-DCMAKE_INSTALL_PREFIX:PATH=${CMAKE_INSTALL_PREFIX}
-DBUILD_SHARED_LIBS:BOOL=${BUILD_SHARED_LIBS}
-DCMAKE_BUILD_TYPE=Release
-DBUILD_TESTING:BOOL=false
)

file(READ ${CMAKE_CURRENT_SOURCE_DIR}/../cmake/libraries.json json)
string(JSON lapack_url GET ${json} lapack git)
string(JSON lapack_tag GET ${json} lapack tag)

ExternalProject_Add(LAPACK
GIT_REPOSITORY ${lapack_url}
GIT_TAG ${lapack_tag}
CMAKE_ARGS ${lapack_cmake_args}
CMAKE_CACHE_ARGS -Darith:STRING=${arith}
INACTIVITY_TIMEOUT 15
)
