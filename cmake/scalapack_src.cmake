include(FetchContent)

string(TOLOWER ${PROJECT_NAME}_src name)

if(local)

find_file(${name}_archive
NAMES ${name}.tar.bz2 ${name}.tar.gz ${name}.tar ${name}.zip ${name}.zstd ${name}.tar.xz
HINTS ${local}
NO_DEFAULT_PATH
)

if(NOT ${name}_archive)
message(FATAL_ERROR "Archive file for ${name} does not exist under ${local}")
endif()

message(STATUS "${name}: using source archive ${${name}_archive}")

FetchContent_Declare(scalapack_src
URL ${${name}_archive}
)

else()

include(${CMAKE_CURRENT_LIST_DIR}/GitSubmodule.cmake)
git_submodule("${PROJECT_SOURCE_DIR}/scalapack")

# needs to be URL as we are patching the source CMakeLists.txt, that way it copies into our build dir.
FetchContent_Declare(scalapack_src
URL ${PROJECT_SOURCE_DIR}/scalapack
)

endif()

FetchContent_GetProperties(scalapack_src)

if(NOT scalapack_src_POPULATED)
  FetchContent_Populate(scalapack_src)
endif()
