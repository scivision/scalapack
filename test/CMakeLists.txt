set_property(DIRECTORY PROPERTY LABELS "scalapack;unit")

add_executable(test_blacs blacs_helloworld.f90)
target_link_libraries(test_blacs PRIVATE blacs MPI::MPI_Fortran)
add_test(NAME scalapack_blacs
COMMAND ${MPIEXEC_EXECUTABLE} ${MPIEXEC_NUMPROC_FLAG} 2 $<TARGET_FILE:test_blacs>
)
set_property(TEST scalapack_blacs PROPERTY LABELS blacs)

if(BUILD_DOUBLE)
  add_executable(test_scalapack_d test_scalapack_d.f90)
  target_link_libraries(test_scalapack_d PRIVATE SCALAPACK::SCALAPACK)

  add_test(NAME scalapack_real64
  COMMAND ${MPIEXEC_EXECUTABLE} ${MPIEXEC_NUMPROC_FLAG} 2 $<TARGET_FILE:test_scalapack_d>
  )
endif()

get_property(test_names DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR} PROPERTY TESTS)

set_property(TEST ${test_names} PROPERTY TIMEOUT 15)
set_property(TEST ${test_names} PROPERTY PROCESSORS 2)
