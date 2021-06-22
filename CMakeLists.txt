cmake_minimum_required(VERSION 3.19...3.21)

file(STRINGS ${CMAKE_CURRENT_SOURCE_DIR}/VERSION PROJECT_VERSION
  REGEX "^([0-9]+\.[0-9]+\.[0-9]+)" LIMIT_INPUT 16 LENGTH_MAXIMUM 16 LIMIT_COUNT 1)

project(SCALAPACK
  LANGUAGES C Fortran
  VERSION ${PROJECT_VERSION}
  HOMEPAGE_URL "http://netlib.org/scalapack"
  DESCRIPTION "University of Tennessee, Univ. of California Berkeley, Univ. of Colorado Denver and NAG Ltd")

include(CTest)

if(NOT DEFINED ${PROJECT_NAME}_BUILD_TESTING)
  set(${PROJECT_NAME}_BUILD_TESTING ${BUILD_TESTING})
endif()

include(cmake/options.cmake)
include(cmake/libraries.cmake)

list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/cmake/Modules)

include(cmake/compilers.cmake)

find_package(MPI COMPONENTS C Fortran REQUIRED)

# --- get Scalapack source
include(cmake/get_scalapack.cmake)

# --- BLACS
configure_file(blacs/src/CMakeLists.txt ${scalapack_SOURCE_DIR}/BLACS/SRC/ COPYONLY)
add_subdirectory(${scalapack_SOURCE_DIR}/BLACS/SRC ${scalapack_BINARY_DIR}/BLACS/SRC)

add_executable(test_blacs tests/blacs_helloworld.f90)
target_link_libraries(test_blacs blacs MPI::MPI_Fortran)
add_test(NAME scalapack:BLACSbasic
  COMMAND ${MPIEXEC_EXECUTABLE} ${MPIEXEC_NUMPROC_FLAG} 2 $<TARGET_FILE:test_blacs>)
set_tests_properties(scalapack:BLACSbasic PROPERTIES TIMEOUT 15)

# --- LAPACK
include(cmake/lapack.cmake)

# == SCALAPACK
add_library(scalapack)
set_target_properties(scalapack PROPERTIES
  VERSION ${SCALAPACK_VERSION}
  EXPORT_NAME SCALAPACK)
target_link_libraries(scalapack PRIVATE blacs LAPACK::LAPACK MPI::MPI_C MPI::MPI_Fortran)
target_compile_definitions(scalapack PRIVATE ${cargs})

# target most users will link to.
# this must NOT be an ALIAS or linking in other packages breaks.
add_library(SCALAPACK::SCALAPACK INTERFACE IMPORTED GLOBAL)
target_link_libraries(SCALAPACK::SCALAPACK INTERFACE scalapack blacs)

foreach(d src/ pblas/src/ pblas/src/pbblas/ pblas/src/ptools/ pblas/src/ptzblas/ redist/src/ tools/ tools/lapack/)
  string(TOUPPER ${d} D)

  configure_file(${d}CMakeLists.txt ${scalapack_SOURCE_DIR}/${D} COPYONLY)
  add_subdirectory(${scalapack_SOURCE_DIR}/${D} ${scalapack_BINARY_DIR}/${D})
endforeach()

if(${PROJECT_NAME}_BUILD_TESTING)
  add_subdirectory(tests)
endif()


# --- install

install(TARGETS scalapack EXPORT ${PROJECT_NAME}Targets)

install(FILES
  ${CMAKE_CURRENT_SOURCE_DIR}/cmake/Modules/FindLAPACK.cmake
  ${CMAKE_CURRENT_SOURCE_DIR}/cmake/Modules/FindSCALAPACK.cmake
  ${CMAKE_CURRENT_SOURCE_DIR}/cmake/Modules/FindBLACS.cmake
  DESTINATION lib/cmake/${PROJECT_NAME}/Modules)

include(cmake/install.cmake)

include(FeatureSummary)
add_feature_info(BuildLAPACK lapack_external "Build LAPACK")
