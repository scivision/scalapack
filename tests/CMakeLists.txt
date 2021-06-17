if("d" IN_LIST arith)
  add_executable(test_scalapack_d test_scalapack_d.f90)
  target_link_libraries(test_scalapack_d SCALAPACK::SCALAPACK LAPACK::LAPACK MPI::MPI_Fortran)

  add_test(NAME scalapack:unit:real64
    COMMAND ${MPIEXEC_EXECUTABLE} ${MPIEXEC_NUMPROC_FLAG} 2 $<TARGET_FILE:test_scalapack_d>)
  set_tests_properties(scalapack:unit:real64 PROPERTIES TIMEOUT 15)
endif()
