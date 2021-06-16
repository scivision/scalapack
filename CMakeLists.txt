cmake_minimum_required(VERSION 3.14...3.20)

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

include(CMAKE/options.cmake)
include(CMAKE/libraries.cmake)

list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/CMAKE/Modules)

include(CMAKE/compilers.cmake)

# --- MPI
include(CMAKE/mpi.cmake)

# --- BLACS
add_subdirectory(BLACS/SRC)

add_executable(test_blacs tests/blacs_helloworld.f90)
target_link_libraries(test_blacs blacs MPI::MPI_Fortran)
add_test(NAME scalapack:BLACSbasic
  COMMAND ${MPIEXEC_EXECUTABLE} ${MPIEXEC_NUMPROC_FLAG} 2 $<TARGET_FILE:test_blacs>)
set_tests_properties(scalapack:BLACSbasic PROPERTIES TIMEOUT 15)

# --- LAPACK
include(CMAKE/lapack.cmake)

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

add_subdirectory(TOOLS)  # tools files
add_subdirectory(PBLAS/SRC)  # pblas files
add_subdirectory(REDIST/SRC)  # redist files
add_subdirectory(SRC) # src files

add_subdirectory(TOOLS/LAPACK)

if(${PROJECT_NAME}_BUILD_TESTING)
  add_subdirectory(tests)
endif()


# --- install

install(TARGETS scalapack EXPORT ${PROJECT_NAME}Targets)

install(FILES
  ${CMAKE_CURRENT_SOURCE_DIR}/CMAKE/Modules/FindLAPACK.cmake
  ${CMAKE_CURRENT_SOURCE_DIR}/CMAKE/Modules/FindSCALAPACK.cmake
  ${CMAKE_CURRENT_SOURCE_DIR}/CMAKE/Modules/FindBLACS.cmake
  DESTINATION lib/cmake/${PROJECT_NAME}/Modules)

include(CMAKE/install.cmake)

include(FeatureSummary)
add_feature_info(BuildLAPACK lapack_external "Build LAPACK")
