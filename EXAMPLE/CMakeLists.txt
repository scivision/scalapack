cmake_minimum_required(VERSION 3.13...3.20)
project(SCALAPACK_Examples
LANGUAGES C Fortran)

include(CTest)

list(APPEND CMAKE_MODULE_PATH ${PROJECT_SOURCE_DIR}/../CMAKE/Modules)

find_package(MPI COMPONENTS C Fortran REQUIRED)
find_package(LAPACK REQUIRED)
# not PREFER_CONFIG for Lapack because the user might be using system lapack with broken config

set(CMAKE_FIND_PACKAGE_PREFER_CONFIG true)
find_package(SCALAPACK REQUIRED)

include(CheckFortranFunctionExists)
set(CMAKE_REQUIRED_INCLUDES)
set(CMAKE_REQUIRED_LIBRARIES SCALAPACK::SCALAPACK LAPACK::LAPACK)

foreach(a s d c z)
  check_fortran_function_exists(p${a}lamch has_${a})
  if(NOT has_${a})
    continue()
  endif()

  add_executable(p${a}scaex p${a}scaex.f pdscaexinfo.f)
  target_link_libraries(p${a}scaex PRIVATE SCALAPACK::SCALAPACK MPI::MPI_Fortran MPI::MPI_C)

  if(MPIEXEC_MAX_NUMPROCS LESS 4)
    message(STATUS "SKIP: P${a}scaex as at least 4 CPUs are required")
    continue()
  endif()

  add_test(NAME P${a}scaex
    COMMAND ${MPIEXEC_EXECUTABLE} ${MPIEXEC_NUMPROC_FLAG} 4 $<TARGET_FILE:p${a}scaex>
    WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR})
  set_tests_properties(P${a}scaex PROPERTIES
    TIMEOUT 10
    RESOURCE_LOCK cpu_mpi)

endforeach()
