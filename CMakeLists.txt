cmake_minimum_required(VERSION 3.19...3.28)

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
VERSION 2.2.1.6
HOMEPAGE_URL "http://netlib.org/scalapack"
)

enable_testing()
if(DEFINED BUILD_TESTING)
  set(${PROJECT_NAME}_BUILD_TESTING ${BUILD_TESTING})
else()
  set(${PROJECT_NAME}_BUILD_TESTING true)
endif()

include(options.cmake)
include(cmake/compilers.cmake)

message(STATUS "${PROJECT_NAME} ${PROJECT_VERSION}  CMake ${CMAKE_VERSION}  Toolchain ${CMAKE_TOOLCHAIN_FILE}
install prefix: ${CMAKE_INSTALL_PREFIX}")

find_package(MPI COMPONENTS C Fortran REQUIRED)

include(cmake/lapack.cmake)

# --- get Scalapack source
include(cmake/scalapack_src.cmake)

# --- BLACS
configure_file(blacs/src/CMakeLists.txt ${scalapack_SOURCE_DIR}/BLACS/SRC/ COPYONLY)
add_subdirectory(${scalapack_SOURCE_DIR}/BLACS/SRC ${scalapack_BINARY_DIR}/BLACS/SRC)


# == SCALAPACK
add_library(scalapack)
set_property(TARGET scalapack PROPERTY VERSION ${SCALAPACK_VERSION})
set_property(TARGET scalapack PROPERTY EXPORT_NAME SCALAPACK)
target_link_libraries(scalapack PUBLIC blacs LAPACK::LAPACK MPI::MPI_Fortran MPI::MPI_C)
target_compile_definitions(scalapack PRIVATE ${cargs})

# target most users will link to.
# this must NOT be an ALIAS or linking in other packages breaks.
add_library(SCALAPACK::SCALAPACK INTERFACE IMPORTED GLOBAL)
target_link_libraries(SCALAPACK::SCALAPACK INTERFACE scalapack)

foreach(d src/ pblas/src/ pblas/src/pbblas/ pblas/src/ptools/ pblas/src/ptzblas/ redist/src/ tools/ tools/lapack/)
  string(TOUPPER ${d} D)

  configure_file(${d}CMakeLists.txt ${scalapack_SOURCE_DIR}/${D} COPYONLY)
  add_subdirectory(${scalapack_SOURCE_DIR}/${D} ${scalapack_BINARY_DIR}/${D})
endforeach()

if(${PROJECT_NAME}_BUILD_TESTING)
  add_subdirectory(test)
endif()

# --- install

install(TARGETS scalapack EXPORT ${PROJECT_NAME}-targets)

install(FILES ${CMAKE_CURRENT_SOURCE_DIR}/cmake/FindLAPACK.cmake DESTINATION cmake)

include(cmake/install.cmake)


include(FeatureSummary)

add_feature_info(real32 ${BUILD_SINGLE} "Build with single precision")
add_feature_info(real64 ${BUILD_DOUBLE} "Build with double precision")
add_feature_info(complex32 ${BUILD_COMPLEX} "Build with complex precision")
add_feature_info(complex64 ${BUILD_COMPLEX16} "Build with complex16 precision")
feature_summary(WHAT ALL)
