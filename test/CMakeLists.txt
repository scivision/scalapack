set_property(DIRECTORY PROPERTY LABELS "scalapack;unit")

add_executable(scalapack_blacs blacs_helloworld.f90)
target_link_libraries(scalapack_blacs PRIVATE blacs MPI::MPI_Fortran)
add_test(NAME scalapack_blacs COMMAND scalapack_blacs)
set_property(TEST scalapack_blacs PROPERTY LABELS blacs)

if(BUILD_DOUBLE)
  add_executable(scalapack_real64 test_scalapack_d.f90)
  target_link_libraries(scalapack_real64 PRIVATE SCALAPACK::SCALAPACK)

  add_test(NAME scalapack_real64 COMMAND scalapack_real64)
endif()

cmake_host_system_information(RESULT Ncpu QUERY NUMBER_OF_PHYSICAL_CORES)

get_property(test_names DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR} PROPERTY TESTS)

set(_p ${MPIEXEC_EXECUTABLE} ${MPIEXEC_NUMPROC_FLAG} ${Ncpu})

foreach(t IN LISTS test_names)

  if(CMAKE_VERSION VERSION_GREATER_EQUAL 3.29)
    set_property(TARGET ${t} PROPERTY TEST_LAUNCHER ${_p})
  else()
    set_property(TARGET ${t} PROPERTY CROSSCOMPILING_EMULATOR ${_p})
  endif()

  set_property(TEST ${t} PROPERTY PROCESSORS ${Ncpu})
endforeach()

set_tests_properties(${test_names} PROPERTIES TIMEOUT 15)
