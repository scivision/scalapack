cmake_minimum_required(VERSION 3.14.0)
if(NOT CMAKE_BUILD_TYPE)
  set(CMAKE_BUILD_TYPE "Release" CACHE STRING "Debug or Release")
endif()
project(SCALAPACK
  LANGUAGES C Fortran
  VERSION 2.1.0
  HOMEPAGE_URL "http://netlib.org/scalapack"
  DESCRIPTION "University of Tennessee, Univ. of California Berkeley, Univ. of Colorado Denver and NAG Ltd")
enable_testing()

set(cargs -DAdd_)

if(NOT arith)
  set(arith "d")
endif()

cmake_policy(SET CMP0076 NEW)

list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/CMAKE/Modules)

# --- MPI
find_package(MPI REQUIRED COMPONENTS C Fortran)

# --- BLACS

add_subdirectory(BLACS/SRC)

add_executable(test_blacs tests/blacs_helloworld.f90)
target_link_libraries(test_blacs blacs MPI::MPI_Fortran)
add_test(NAME BLACSbasic COMMAND $<TARGET_FILE:test_blacs>)
set_tests_properties(BLACSbasic PROPERTIES TIMEOUT 15)

# --- LAPACK

find_package(LAPACK REQUIRED)

# == SCALAPACK
# the add_subdirectory() use target_sources() to fill in scalapack.
add_library(scalapack)
target_link_libraries(scalapack PRIVATE scalapack::blacs ${LAPACK_LIBRARIES} ${BLAS_LIBRARIES} MPI::MPI_C MPI::MPI_Fortran)
target_compile_definitions(scalapack PRIVATE ${cargs})

# scalapack::scalapack is the target most users will link to.
add_library(scalapack::scalapack INTERFACE IMPORTED GLOBAL)
set_property(TARGET scalapack::scalapack PROPERTY
  INTERFACE_LINK_LIBRARIES scalapack scalapack::blacs)


add_subdirectory(TOOLS)  # tools files
add_subdirectory(PBLAS/SRC)  # pblas files
add_subdirectory(REDIST/SRC)  # redist files
add_subdirectory(SRC) # src files

add_subdirectory(TOOLS/LAPACK)

# --- Scalapack test

if("d" IN_LIST arith)
add_executable(test_scalapack_d tests/test_scalapack_d.f90)
target_link_libraries(test_scalapack_d PRIVATE scalapack::scalapack ${LAPACK_LIBRARIES} ${BLAS_LIBRARIES} MPI::MPI_Fortran)
add_test(NAME Scalapack_d COMMAND $<TARGET_FILE:test_scalapack_d>)
set_tests_properties(Scalapack_d PROPERTIES TIMEOUT 15)
endif()