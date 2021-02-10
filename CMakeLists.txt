cmake_minimum_required(VERSION 3.13)

include(CMAKE/policy.cmake)
include(CMAKE/compiler_find.cmake)
find_c_fortran()

project(SCALAPACK
  LANGUAGES C Fortran
  VERSION 2.1.0
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
target_link_libraries(test_blacs SCALAPACK::BLACS MPI::MPI_Fortran)
add_test(NAME scalapack:BLACSbasic
  COMMAND ${MPIEXEC_EXECUTABLE} ${MPIEXEC_NUMPROC_FLAG} 2 $<TARGET_FILE:test_blacs>)
set_tests_properties(scalapack:BLACSbasic PROPERTIES TIMEOUT 15)

# --- LAPACK

include(CMAKE/lapack.cmake)

# == SCALAPACK
add_library(scalapack)
target_link_libraries(scalapack PRIVATE SCALAPACK::BLACS LAPACK::LAPACK MPI::MPI_C MPI::MPI_Fortran)
target_compile_definitions(scalapack PRIVATE ${cargs})

# target most users will link to.
add_library(SCALAPACK::SCALAPACK ALIAS scalapack)

add_subdirectory(TOOLS)  # tools files
add_subdirectory(PBLAS/SRC)  # pblas files
add_subdirectory(REDIST/SRC)  # redist files
add_subdirectory(SRC) # src files

add_subdirectory(TOOLS/LAPACK)

if(${PROJECT_NAME}_BUILD_TESTING)
  add_subdirectory(tests)
endif()


# --- install

install(TARGETS scalapack
EXPORT SCALAPACKTargets
ARCHIVE DESTINATION lib
LIBRARY DESTINATION lib
RUNTIME DESTINATION bin
INCLUDES DESTINATION include)

include(CMAKE/install.cmake)
