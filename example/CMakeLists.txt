cmake_minimum_required(VERSION 3.13...3.25)

project(ScalapackExamples LANGUAGES C Fortran)

enable_testing()

set(CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/../cmake)

file(GENERATE OUTPUT .gitignore CONTENT "*")

find_package(SCALAPACK CONFIG REQUIRED)

include(CheckFortranSourceCompiles)

set(CMAKE_REQUIRED_LIBRARIES SCALAPACK::SCALAPACK LAPACK::LAPACK MPI::MPI_Fortran)

check_fortran_source_compiles(
"program test
use, intrinsic :: iso_fortran_env, only : real64
implicit none (type, external)
real(real64), external :: pdlamch
integer :: ictxt
print *, pdlamch(ictxt, 'E')
end program"
scalapack_d
SRC_EXT f90
)

check_fortran_source_compiles(
"program test
use, intrinsic :: iso_fortran_env, only : real32
implicit none (type, external)
real(real32), external :: pslamch
integer :: ictxt
print *, pslamch(ictxt, 'E')
end program"
scalapack_s
SRC_EXT f90
)


if(scalapack_d)
  add_executable(test_pdgesv test_pdgesv.f)
  target_link_libraries(test_pdgesv PRIVATE SCALAPACK::SCALAPACK LAPACK::LAPACK MPI::MPI_Fortran)
  add_test(NAME PDGESV
  COMMAND ${MPIEXEC_EXECUTABLE} ${MPIEXEC_NUMPROC_FLAG} 6 $<TARGET_FILE:test_pdgesv>
  )
  set_property(TEST PDGESV PROPERTY PROCESSORS 6)

  add_executable(test_pdsyev test_pdsyev.f)
  target_link_libraries(test_pdsyev PRIVATE SCALAPACK::SCALAPACK LAPACK::LAPACK MPI::MPI_Fortran)
  add_test(NAME PDSYEV
  COMMAND ${MPIEXEC_EXECUTABLE} ${MPIEXEC_NUMPROC_FLAG} 4 $<TARGET_FILE:test_pdsyev>
  )
  set_property(TEST PDSYEV PROPERTY PROCESSORS 4)
endif()

if(scalapack_s)
  add_executable(test_pssyev test_pssyev.f)
  target_link_libraries(test_pssyev PRIVATE SCALAPACK::SCALAPACK LAPACK::LAPACK MPI::MPI_Fortran)
  add_test(NAME PSSYEV
  COMMAND ${MPIEXEC_EXECUTABLE} ${MPIEXEC_NUMPROC_FLAG} 4 $<TARGET_FILE:test_pssyev>
  )
  set_property(TEST PSSYEV PROPERTY PROCESSORS 4)
endif()

get_property(test_names DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR} PROPERTY TESTS)

set_property(TEST ${test_names} PROPERTY TIMEOUT 15)
