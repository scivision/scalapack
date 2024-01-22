# For dev testing, to ease testing of shared libraries, which
# may not show run path problems until executables are run.
include(${CMAKE_CURRENT_LIST_DIR}/tempdir.cmake)

if(NOT bindir)
  get_temp_dir(bindir)
endif()
if(NOT prefix)
  get_temp_dir(prefix)
endif()

message(STATUS "binary_dir: ${bindir}
prefix: ${prefix}")

execute_process(
COMMAND ${CMAKE_COMMAND}
  -B${bindir} -S${CMAKE_CURRENT_LIST_DIR}/..
  -DCMAKE_INSTALL_PREFIX:PATH=${prefix}
  -DBUILD_SHARED_LIBS:BOOL=true
  -DCMAKE_BUILD_TYPE:STRING=Release
  -DCMAKE_PREFIX_PATH:PATH=${CMAKE_PREFIX_PATH}
COMMAND_ERROR_IS_FATAL ANY)

execute_process(COMMAND ${CMAKE_COMMAND} --build ${bindir}
COMMAND_ERROR_IS_FATAL ANY)

execute_process(COMMAND ${CMAKE_COMMAND} --install ${bindir}
COMMAND_ERROR_IS_FATAL ANY)

# example
get_temp_dir(example_bin)
execute_process(
COMMAND ${CMAKE_COMMAND}
  -B${example_bin} -S${CMAKE_CURRENT_LIST_DIR}/../example
  -DCMAKE_INSTALL_PREFIX:PATH=${prefix}
  -DBUILD_SHARED_LIBS:BOOL=true
  -DCMAKE_PREFIX_PATH:PATH=${CMAKE_PREFIX_PATH}
  -DMUMPS_ROOT:PATH=${prefix}
COMMAND_ERROR_IS_FATAL ANY)

execute_process(COMMAND ${CMAKE_COMMAND} --build ${example_bin}
COMMAND_ERROR_IS_FATAL ANY)

execute_process(COMMAND ${CMAKE_CTEST_COMMAND} --test-dir ${example_bin} -V
COMMAND_ERROR_IS_FATAL ANY)
