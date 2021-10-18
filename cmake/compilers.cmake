include(CheckCompilerFlag)

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

if(CMAKE_Fortran_COMPILER_ID MATCHES Intel)
  add_compile_options(
  $<IF:$<BOOL:${WIN32}>,/QxHost,-xHost>
  "$<$<COMPILE_LANGUAGE:Fortran>:$<IF:$<BOOL:${WIN32}>,/heap-arrays,>>"
  )
elseif(CMAKE_Fortran_COMPILER_ID STREQUAL GNU)
  add_compile_options(-mtune=native
  $<$<COMPILE_LANGUAGE:Fortran>:-std=legacy>
  $<$<BOOL:${MINGW}>:-w>
  )
  # MS-MPI emits extreme amounts of nuisance warnings
  # pzheevd.f broken with -fimplicit-none
endif()

# Clang errors without this
# test the non-no form, otherwise always succeeds
check_compiler_flag(C -Wimplicit-function-declaration HAS_IMPLICIT_FUNC_FLAG)
if(HAS_IMPLICIT_FUNC_FLAG)
  add_compile_options($<$<COMPILE_LANGUAGE:C>:-Wno-implicit-function-declaration>)
endif()
