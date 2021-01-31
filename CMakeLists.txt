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
