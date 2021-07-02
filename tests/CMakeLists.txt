add_executable(test_blacs blacs_helloworld.f90)
target_link_libraries(test_blacs blacs MPI::MPI_Fortran)
add_test(NAME scalapack:BLACSbasic
  COMMAND ${MPIEXEC_EXECUTABLE} ${MPIEXEC_NUMPROC_FLAG} 2 $<TARGET_FILE:test_blacs>)
set_tests_properties(scalapack:BLACSbasic PROPERTIES
  TIMEOUT 15
  LABELS blacs)

if("d" IN_LIST arith)
  add_executable(test_scalapack_d test_scalapack_d.f90)
  target_link_libraries(test_scalapack_d SCALAPACK::SCALAPACK LAPACK::LAPACK MPI::MPI_Fortran)

  add_test(NAME scalapack:unit:real64
    COMMAND ${MPIEXEC_EXECUTABLE} ${MPIEXEC_NUMPROC_FLAG} 2 $<TARGET_FILE:test_scalapack_d>)
  set_tests_properties(scalapack:unit:real64 PROPERTIES
    TIMEOUT 15
    LABELS scalapack)

  # TODO: make this a running test too.
  add_executable(test_pdgetrf test_pdgetrf.f90)
  target_link_libraries(test_pdgetrf PRIVATE SCALAPACK::SCALAPACK)
  # add_test(NAME scalapack:unit:pdgetrf
  #   COMMAND ${MPIEXEC_EXECUTABLE} ${MPIEXEC_NUMPROC_FLAG} 2 $<TARGET_FILE:test_pdgetrf>)
  # set_tests_properties(scalapack:unit:pdgetrf PROPERTIES
  #   TIMEOUT 15
  #   LABELS scalapack)
endif()
