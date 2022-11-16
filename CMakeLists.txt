cmake_minimum_required(VERSION 3.13...3.25)

get_property(is_multi_config GLOBAL PROPERTY GENERATOR_IS_MULTI_CONFIG)
if(NOT is_multi_config AND NOT (CMAKE_BUILD_TYPE OR DEFINED ENV{CMAKE_BUILD_TYPE}))
  set(CMAKE_BUILD_TYPE Release CACHE STRING "Release default")
endif()


project(SCALAPACK
LANGUAGES C Fortran
VERSION 2.2.1.3
HOMEPAGE_URL "http://netlib.org/scalapack"
)

enable_testing()
if(DEFINED BUILD_TESTING)
  set(${PROJECT_NAME}_BUILD_TESTING ${BUILD_TESTING})
else()
  set(${PROJECT_NAME}_BUILD_TESTING true)
endif()

include(cmake/options.cmake)
include(cmake/compilers.cmake)

find_package(MPI COMPONENTS C Fortran REQUIRED)

# --- get Scalapack source
include(cmake/scalapack_src.cmake)

# --- BLACS
configure_file(blacs/src/CMakeLists.txt ${scalapack_SOURCE_DIR}/BLACS/SRC/ COPYONLY)
add_subdirectory(${scalapack_SOURCE_DIR}/BLACS/SRC ${scalapack_BINARY_DIR}/BLACS/SRC)

find_package(LAPACK REQUIRED)

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

install(TARGETS scalapack EXPORT ${PROJECT_NAME}-targets
LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)

install(FILES
${CMAKE_CURRENT_SOURCE_DIR}/cmake/FindLAPACK.cmake
${CMAKE_CURRENT_SOURCE_DIR}/cmake/FindSCALAPACK.cmake
DESTINATION cmake
)

include(cmake/install.cmake)
