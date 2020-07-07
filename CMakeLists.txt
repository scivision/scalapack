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
include(CTest)

set(cargs -DAdd_)

if(NOT arith)
  set(arith "s;d")
endif()

message(STATUS "Scalapack arith: ${arith}")

option(autobuild "auto-build Lapack if missing or broken" ON)

list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/CMAKE/Modules)

# typical projects set options too strict for MUMPS code style, so if
# being used as external project, locally override MUMPS compile options
if(CMAKE_SOURCE_DIR STREQUAL PROJECT_SOURCE_DIR)
# MUMPS is being compiled by itself or as ExternalProject
  if(CMAKE_Fortran_COMPILER_ID STREQUAL Intel)
    if(WIN32)
    add_compile_options(/arch:native)
      # /heap-arrays is necessary to avoid runtime errors in programs using this library
      string(APPEND CMAKE_Fortran_FLAGS " /warn:declarations /heap-arrays")
    else()
      add_compile_options(-march=native)
      string(APPEND CMAKE_Fortran_FLAGS " -warn declarations")
    endif()
  elseif(CMAKE_Fortran_COMPILER_ID STREQUAL GNU)
    add_compile_options(-mtune=native)
    # -std=legacy is for "Error: Rank mismatch between actual argument at (1) and actual argument at (2) (scalar and rank-1)"
    string(APPEND CMAKE_Fortran_FLAGS " -fimplicit-none -std=legacy")
  elseif(CMAKE_Fortran_COMPILER_ID STREQUAL PGI)
    string(APPEND CMAKE_Fortran_FLAGS " -Mdclchk")
    if(NOT (MPI_ROOT OR ENV{MPI_ROOT}))
      get_filename_component(_pgi_path ${CMAKE_Fortran_COMPILER} DIRECTORY)
      set(MPI_ROOT ${_pgi_path}/../mpi/openmpi-3.1.3)
    endif()
  endif()
else()
  # MUMPS is being compiled via FetchContent, override options to avoid tens of megabytes of warnings
  if(CMAKE_Fortran_COMPILER_ID STREQUAL Intel)
    if(WIN32)
      # /heap-arrays is necessary to avoid runtime errors in programs using this library
      set(CMAKE_Fortran_FLAGS "/nologo /fpp /libs:dll /threads /warn:declarations /heap-arrays")
    else()
      set(CMAKE_Fortran_FLAGS "-warn declarations")
    endif()
  elseif(CMAKE_Fortran_COMPILER_ID STREQUAL GNU)
    add_compile_options(-mtune=native)
    set(CMAKE_Fortran_FLAGS "-fimplicit-none -std=legacy")
  elseif(CMAKE_Fortran_COMPILER_ID STREQUAL PGI)
    set(CMAKE_Fortran_FLAGS "-Mdclchk")
    if(NOT (MPI_ROOT OR ENV{MPI_ROOT}))
      get_filename_component(_pgi_path ${CMAKE_Fortran_COMPILER} DIRECTORY)
      set(MPI_ROOT ${_pgi_path}/../mpi/openmpi-3.1.3)
    endif()
  endif()
endif()

if(CMAKE_SOURCE_DIR STREQUAL PROJECT_SOURCE_DIR)
  # problems with MPI can cause tests to hang forever, so set a default timeout [seconds]
  set(CTEST_TEST_TIMEOUT 15)
endif()

# --- MPI
include(${CMAKE_CURRENT_SOURCE_DIR}/CMAKE/mpi.cmake)

# --- BLACS

add_subdirectory(BLACS/SRC)

add_executable(test_blacs tests/blacs_helloworld.f90)
target_link_libraries(test_blacs SCALAPACK::BLACS MPI::MPI_Fortran)
add_test(NAME scalapack:BLACSbasic
  COMMAND ${MPIEXEC_EXECUTABLE} ${MPIEXEC_NUMPROC_FLAG} 2 $<TARGET_FILE:test_blacs>)
set_tests_properties(scalapack:BLACSbasic PROPERTIES TIMEOUT 15)

# --- LAPACK

find_package(LAPACK)
if(NOT LAPACK_FOUND)
  include(${CMAKE_CURRENT_SOURCE_DIR}/CMAKE/lapack_external.cmake)
endif()

# == SCALAPACK
# the add_subdirectory() use target_sources() to fill in scalapack.
add_library(scalapack)
target_link_libraries(scalapack PRIVATE SCALAPACK::BLACS LAPACK::LAPACK MPI::MPI_C MPI::MPI_Fortran)
target_compile_definitions(scalapack PRIVATE ${cargs})

# scalapack::scalapack is the target most users will link to.
add_library(SCALAPACK::SCALAPACK INTERFACE IMPORTED GLOBAL)
target_link_libraries(SCALAPACK::SCALAPACK INTERFACE scalapack SCALAPACK::BLACS)


add_subdirectory(TOOLS)  # tools files
add_subdirectory(PBLAS/SRC)  # pblas files
add_subdirectory(REDIST/SRC)  # redist files
add_subdirectory(SRC) # src files

add_subdirectory(TOOLS/LAPACK)

# --- Scalapack test

if("d" IN_LIST arith)
  add_executable(test_scalapack_d tests/test_scalapack_d.f90)
  target_link_libraries(test_scalapack_d SCALAPACK::SCALAPACK LAPACK::LAPACK MPI::MPI_Fortran)
  add_test(NAME scalapack:unit:real64
    COMMAND ${MPIEXEC_EXECUTABLE} ${MPIEXEC_NUMPROC_FLAG} 2 $<TARGET_FILE:test_scalapack_d>)
  set_tests_properties(scalapack:unit:real64 PROPERTIES TIMEOUT 15)
endif()

# --- install

install(TARGETS scalapack
EXPORT SCALAPACKTargets
ARCHIVE DESTINATION lib
LIBRARY DESTINATION lib
RUNTIME DESTINATION bin
INCLUDES DESTINATION include)
