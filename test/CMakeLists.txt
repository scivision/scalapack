set_directory_properties(PROPERTIES LABELS "scalapack;unit")
add_executable(test_blacs blacs_helloworld.f90)
target_link_libraries(test_blacs PRIVATE blacs MPI::MPI_Fortran)
add_test(NAME scalapack_blacs
COMMAND ${MPIEXEC_EXECUTABLE} ${MPIEXEC_NUMPROC_FLAG} 2 $<TARGET_FILE:test_blacs>
)
set_tests_properties(scalapack_blacs PROPERTIES
TIMEOUT 15
LABELS blacs
PROCESSORS 2
)

if("d" IN_LIST arith)
  add_executable(test_scalapack_d test_scalapack_d.f90)
  target_link_libraries(test_scalapack_d PRIVATE SCALAPACK::SCALAPACK)

  add_test(NAME scalapack_real64
  COMMAND ${MPIEXEC_EXECUTABLE} ${MPIEXEC_NUMPROC_FLAG} 2 $<TARGET_FILE:test_scalapack_d>
  )
  set_tests_properties(scalapack_real64 PROPERTIES
  TIMEOUT 15
  PROCESSORS 2
  )
endif()
