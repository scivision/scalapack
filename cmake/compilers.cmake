# --- abi check

# check C and Fortran compiler ABI compatibility

if(NOT abi_ok)
  message(CHECK_START "checking that C and Fortran compilers can link")
  try_compile(abi_ok ${CMAKE_CURRENT_BINARY_DIR}/abi_check ${CMAKE_CURRENT_LIST_DIR}/abi_check abi_check)
  if(abi_ok)
    message(CHECK_PASS "OK")
  else()
    message(FATAL_ERROR "ABI-incompatible: C compiler ${CMAKE_C_COMPILER_ID} ${CMAKE_C_COMPILER_VERSION} and Fortran compiler ${CMAKE_Fortran_COMPILER_ID} ${CMAKE_Fortran_COMPILER_VERSION}")
  endif()
endif()

# --- compiler check

set(cargs "Add_")
# "Add_" works for all modern compilers we tried.

if(CMAKE_Fortran_COMPILER_ID STREQUAL Intel)
  if(WIN32)
    add_compile_options(/QxHost)
    # /heap-arrays is necessary to avoid runtime errors in programs using this library
    string(APPEND CMAKE_Fortran_FLAGS " /heap-arrays")
  else()
    add_compile_options(-xHost)
  endif()
elseif(CMAKE_Fortran_COMPILER_ID STREQUAL GNU)
  add_compile_options(-mtune=native)
  # -std=legacy is for "Error: Rank mismatch between actual argument at (1) and actual argument at (2) (scalar and rank-1)"
  string(APPEND CMAKE_Fortran_FLAGS " -std=legacy")
  if(MINGW)
    # presumably using MS-MPI, which emits extreme amounts of nuisance warnings
    string(APPEND CMAKE_Fortran_FLAGS " -w")
  endif(MINGW)
endif()
