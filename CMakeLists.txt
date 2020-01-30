cmake_minimum_required(VERSION 3.14.0)
project(SCALAPACK
  LANGUAGES C Fortran
  VERSION 2.0.2
  HOMEPAGE_URL "http://netlib.org/scalapack"
  DESCRIPTION "University of Tennessee, Univ. of California Berkeley, Univ. of Colorado Denver and NAG Ltd")
enable_testing()

set(cargs -DAdd_)

if(NOT arith)
  set(arith "s;d")
endif()

set(quietargs "-w ")

cmake_policy(SET CMP0076 NEW)

# --- MPI
find_package(MPI REQUIRED COMPONENTS C Fortran)

# --- BLACS

add_subdirectory(BLACS/SRC)

add_executable(test_blacs tests/blacs_helloworld.f90)
target_link_libraries(test_blacs blacs MPI::MPI_Fortran)
add_test(NAME BLACSbasic COMMAND ${MPIEXEC_EXECUTABLE} ${MPIEXEC_NUMPROC_FLAG} 1 $<TARGET_FILE:test_blacs>)
set_tests_properties(BLACSbasic PROPERTIES TIMEOUT 15)

# --- LAPACK

find_package(BLAS REQUIRED)

# == SCALAPACK
# the add_subdirectory() use target_sources() to fill in scalapack.
add_library(scalapack)
target_link_libraries(scalapack PRIVATE blacs lapack ${BLAS_LIBRARIES} MPI::MPI_C MPI::MPI_Fortran)

add_subdirectory(TOOLS)  # tools files
add_subdirectory(PBLAS/SRC)  # pblas files
add_subdirectory(REDIST/SRC)  # redist files
add_subdirectory(SRC) # src files

add_subdirectory(TOOLS/LAPACK)
target_compile_definitions(scalapack PRIVATE ${cargs})

# --- Scalapack test
add_executable(test_scalapack tests/example1.f)
target_link_libraries(test_scalapack PRIVATE scalapack lapack ${BLAS_LIBRARIES} MPI::MPI_Fortran)
add_test(NAME ScalapackBasic COMMAND ${MPIEXEC_EXECUTABLE} ${MPIEXEC_NUMPROC_FLAG} 6 --oversubscript $<TARGET_FILE:test_scalapack>)
set_tests_properties(ScalapackBasic PROPERTIES TIMEOUT 60)
