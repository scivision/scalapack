cmake_minimum_required(VERSION 3.13)
project(SCALAPACK_Examples
LANGUAGES C Fortran)

include(CTest)

list(APPEND CMAKE_MODULE_PATH ${PROJECT_SOURCE_DIR}/../CMAKE/Modules)

if(SCALAPACK_ROOT OR DEFINED ENV{SCALAPACK_ROOT})
  # lots of botched Scalapack config out there, even Scalapack 2.1.0
  # so we restrict this to what we assume is "our" new CMake approach.
  find_package(SCALAPACK CONFIG)
endif()

if(SCALAPACK_FOUND)
  include(${SCALAPACK_DIR}/SCALAPACKTargets.cmake)
  # Not ALIAS for CMAKE_REQUIRED_LIBRARIES
  add_library(SCALAPACK::SCALAPACK INTERFACE IMPORTED)
  target_link_libraries(SCALAPACK::SCALAPACK INTERFACE SCALAPACK::scalapack)
else()
  find_package(SCALAPACK REQUIRED)
endif()

# include(${PROJECT_SOURCE_DIR}/../../cmakeutils/echo_target_properties.cmake)
# echo_target_properties(SCALAPACK::SCALAPACK)
# echo_target_properties(SCALAPACK::scalapack)

find_package(LAPACK REQUIRED)
find_package(MPI COMPONENTS C Fortran REQUIRED)

include(CheckFortranFunctionExists)
set(CMAKE_REQUIRED_INCLUDES)
set(CMAKE_REQUIRED_LIBRARIES SCALAPACK::SCALAPACK)

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
