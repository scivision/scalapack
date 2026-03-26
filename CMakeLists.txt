cmake_minimum_required(VERSION 3.21...4.3)

get_property(is_multi_config GLOBAL PROPERTY GENERATOR_IS_MULTI_CONFIG)
if(NOT is_multi_config AND NOT (CMAKE_BUILD_TYPE OR DEFINED ENV{CMAKE_BUILD_TYPE}))
  set(CMAKE_BUILD_TYPE Release CACHE STRING "Release default")
endif()

if(CMAKE_SOURCE_DIR STREQUAL CMAKE_BINARY_DIR)
  message(FATAL_ERROR "Please use out of source build like:
  cmake -Bbuild")
endif()

project(SCALAPACK
LANGUAGES C Fortran
VERSION 2.2.3.0
HOMEPAGE_URL "http://netlib.org/scalapack"
)

enable_testing()

include(GNUInstallDirs)
include(FetchContent)

include(options.cmake)
include(cmake/compilers.cmake)

if(DEFINED ENV{CONDA_PREFIX})
  list(APPEND CMAKE_IGNORE_PREFIX_PATH $ENV{CONDA_PREFIX})
  list(APPEND CMAKE_IGNORE_PATH $ENV{CONDA_PREFIX}/bin $ENV{CONDA_PREFIX}/lib $ENV{CONDA_PREFIX}/include)
  # need CMAKE_IGNORE_PATH to ensure env var PATH doesn't interfere
  # despite CMAKE_IGNORE_PREFIX_PATH
endif()

# --- RPATH handling for transitive dependencies
if(scalapack_ENABLE_RPATH AND NOT WIN32)
  set(CMAKE_INSTALL_RPATH "${CMAKE_INSTALL_FULL_LIBDIR}")
  set(CMAKE_BUILD_RPATH "${CMAKE_INSTALL_FULL_LIBDIR}")
endif()

message(STATUS "${PROJECT_NAME} ${PROJECT_VERSION}  CMake ${CMAKE_VERSION}  Toolchain ${CMAKE_TOOLCHAIN_FILE}
install prefix: ${CMAKE_INSTALL_PREFIX}")

find_package(MPI COMPONENTS C Fortran REQUIRED)

list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_LIST_DIR}/cmake)

include(cmake/lapack.cmake)

# --- Scalapack source
string(JSON scalapack_url GET "${_json}" "scalapack")
FetchContent_Populate(SCALAPACK_upstream
URL ${scalapack_url}
)

include(cmake/blacs.cmake)

# == SCALAPACK
add_library(scalapack)
set_property(TARGET scalapack PROPERTY VERSION ${SCALAPACK_VERSION})
set_property(TARGET scalapack PROPERTY EXPORT_NAME SCALAPACK)
target_link_libraries(scalapack PUBLIC blacs LAPACK::LAPACK MPI::MPI_Fortran MPI::MPI_C)
target_compile_definitions(scalapack PRIVATE ${cargs})

# target most users will link to.
add_library(SCALAPACK::SCALAPACK ALIAS scalapack)

include(cmake/src.cmake)
include(cmake/pblas.cmake)
include(cmake/pbblas.cmake)
include(cmake/ptools.cmake)
include(cmake/ptzblas.cmake)
include(cmake/redist.cmake)
include(cmake/tools.cmake)
include(cmake/tools_lapack.cmake)

if(SCALAPACK_BUILD_TESTING)
  add_subdirectory(test)
endif()

file(GENERATE OUTPUT .gitignore CONTENT "*")

# --- install

install(TARGETS scalapack EXPORT ${PROJECT_NAME}-targets)

install(FILES ${CMAKE_CURRENT_SOURCE_DIR}/cmake/FindLAPACK.cmake DESTINATION cmake)

include(cmake/install.cmake)


if(SCALAPACK_IS_TOP_LEVEL)

include(FeatureSummary)

add_feature_info(real32 BUILD_SINGLE "Build with single precision")
add_feature_info(real64 BUILD_DOUBLE "Build with double precision")
add_feature_info(complex32 BUILD_COMPLEX "Build with complex precision")
add_feature_info(complex64 BUILD_COMPLEX16 "Build with complex16 precision")
feature_summary(WHAT ENABLED_FEATURES DISABLED_FEATURES
DESCRIPTION "SCALAPACK enabled features:"
)

endif()
