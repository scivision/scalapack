cmake_minimum_required(VERSION 3.19)

project(ScalapackExamples LANGUAGES C Fortran)

enable_testing()

set(CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/../cmake)

file(GENERATE OUTPUT .gitignore CONTENT "*")

find_package(SCALAPACK CONFIG REQUIRED)

include(CheckSourceCompiles)

set(CMAKE_REQUIRED_LIBRARIES SCALAPACK::SCALAPACK LAPACK::LAPACK MPI::MPI_Fortran)

check_source_compiles(Fortran
"program test
use, intrinsic :: iso_fortran_env, only : real64
implicit none (type, external)
real(real64), external :: pdlamch
integer :: ictxt
print *, pdlamch(ictxt, 'E')
end program"
scalapack_d
)

check_source_compiles(Fortran
"program test
use, intrinsic :: iso_fortran_env, only : real32
implicit none (type, external)
real(real32), external :: pslamch
integer :: ictxt
print *, pslamch(ictxt, 'E')
end program"
scalapack_s
)

cmake_host_system_information(RESULT Ncpu QUERY NUMBER_OF_PHYSICAL_CORES)
if(Ncpu LESS 6)
  set(less6 true)
endif()
if(Ncpu LESS 4)
  set(less4 true)
endif()
if(Ncpu LESS 2)
  set(less2 true)
endif()

message(STATUS "Number of physical cores: ${Ncpu}")


if(scalapack_d)
  add_executable(test_pdgesv test_pdgesv.f)
  target_link_libraries(test_pdgesv PRIVATE SCALAPACK::SCALAPACK LAPACK::LAPACK MPI::MPI_Fortran)
  add_test(NAME PDGESV
  COMMAND ${MPIEXEC_EXECUTABLE} ${MPIEXEC_NUMPROC_FLAG} 6 $<TARGET_FILE:test_pdgesv>
  )
  set_property(TEST PDGESV PROPERTY PROCESSORS 6)
  set_property(TEST PDGESV PROPERTY DISABLED $<BOOL:${less6}>)

  add_executable(test_pdsyev test_pdsyev.f)
  target_link_libraries(test_pdsyev PRIVATE SCALAPACK::SCALAPACK LAPACK::LAPACK MPI::MPI_Fortran)
  add_test(NAME PDSYEV
  COMMAND ${MPIEXEC_EXECUTABLE} ${MPIEXEC_NUMPROC_FLAG} 4 $<TARGET_FILE:test_pdsyev>
  )
  set_property(TEST PDSYEV PROPERTY PROCESSORS 4)
  set_property(TEST PDSYEV PROPERTY DISABLED $<BOOL:${less4}>)

  add_executable(test_scalapack_d ${PROJECT_SOURCE_DIR}/../test/test_scalapack_d.f90)
  target_link_libraries(test_scalapack_d PRIVATE SCALAPACK::SCALAPACK)

  add_test(NAME ScalapackReal64
  COMMAND ${MPIEXEC_EXECUTABLE} ${MPIEXEC_NUMPROC_FLAG} 2 $<TARGET_FILE:test_scalapack_d>
  )
  set_property(TEST ScalapackReal64 PROPERTY DISABLED $<BOOL:${less2}>)
endif()

if(scalapack_s)
  add_executable(test_pssyev test_pssyev.f)
  target_link_libraries(test_pssyev PRIVATE SCALAPACK::SCALAPACK LAPACK::LAPACK MPI::MPI_Fortran)
  add_test(NAME PSSYEV
  COMMAND ${MPIEXEC_EXECUTABLE} ${MPIEXEC_NUMPROC_FLAG} 4 $<TARGET_FILE:test_pssyev>
  )
  set_property(TEST PSSYEV PROPERTY PROCESSORS 4)
  set_property(TEST PSSYEV PROPERTY DISABLED $<BOOL:${less4}>)
endif()

get_property(test_names DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR} PROPERTY TESTS)

set_property(TEST ${test_names} PROPERTY TIMEOUT 15)
