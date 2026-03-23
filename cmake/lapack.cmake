include(FetchContent)

set(BUILD_TESTING off)
set(BUILD_INDEX64_EXT_API off)

set(_lapack_fc_args)
if(CMAKE_VERSION VERSION_GREATER_EQUAL 3.24)
  set(_lapack_fc_args FIND_PACKAGE_ARGS)
elseif(NOT TARGET LAPACK::LAPACK AND scalapack_find_lapack)
  find_package(LAPACK REQUIRED)
  if(TARGET LAPACK::LAPACK)
    return()
  endif()
endif()

file(READ ${CMAKE_CURRENT_LIST_DIR}/libraries.json _json)

string(JSON lapack_url GET "${_json}" "lapack")


FetchContent_Declare(LAPACK
URL ${lapack_url}
SOURCE_DIR ${PROJECT_SOURCE_DIR}/lapack
${_lapack_fc_args}
)

FetchContent_MakeAvailable(LAPACK)

if(NOT TARGET LAPACK::LAPACK)
  add_library(LAPACK::LAPACK ALIAS lapack)
endif()
