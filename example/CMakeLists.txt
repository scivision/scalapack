cmake_minimum_required(VERSION 3.19)

project(ScalapackExamples LANGUAGES C Fortran)

enable_testing()

find_package(SCALAPACK CONFIG REQUIRED)

include(CheckSourceCompiles)

set(CMAKE_REQUIRED_LIBRARIES SCALAPACK::SCALAPACK)

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


if(scalapack_d)
  add_executable(test_pdgesv test_pdgesv.f)
  target_link_libraries(test_pdgesv PRIVATE SCALAPACK::SCALAPACK)
  add_test(NAME PDGESV
  COMMAND ${MPIEXEC_EXECUTABLE} ${MPIEXEC_NUMPROC_FLAG} 6 $<TARGET_FILE:test_pdgesv>
  )
  set_tests_properties(PDGESV PROPERTIES
  TIMEOUT 15
  PROCESSORS 6
  )

  add_executable(test_pdsyev test_pdsyev.f)
  target_link_libraries(test_pdsyev PRIVATE SCALAPACK::SCALAPACK)
  add_test(NAME PDSYEV
  COMMAND ${MPIEXEC_EXECUTABLE} ${MPIEXEC_NUMPROC_FLAG} 4 $<TARGET_FILE:test_pdsyev>
  )
  set_tests_properties(PDSYEV PROPERTIES
  TIMEOUT 15
  PROCESSORS 4
  )
endif()

if(scalapack_s)
  add_executable(test_pssyev test_pssyev.f)
  target_link_libraries(test_pssyev PRIVATE SCALAPACK::SCALAPACK)
  add_test(NAME PSSYEV
  COMMAND ${MPIEXEC_EXECUTABLE} ${MPIEXEC_NUMPROC_FLAG} 4 $<TARGET_FILE:test_pssyev>
  )
  set_tests_properties(PSSYEV PROPERTIES
  TIMEOUT 15
  PROCESSORS 4
  )
endif()
