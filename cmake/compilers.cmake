include(CheckCompilerFlag)

# --- abi check

# check C and Fortran compiler ABI compatibility

if(NOT abi_ok)
  message(CHECK_START "checking that C and Fortran compilers can link")
  try_compile(abi_ok
  ${CMAKE_CURRENT_BINARY_DIR}/abi_check ${CMAKE_CURRENT_LIST_DIR}/abi_check
  abi_check
  OUTPUT_VARIABLE abi_log
  )
  if(abi_ok)
    message(CHECK_PASS "OK")
  else()
    message(FATAL_ERROR "ABI-incompatible compilers:
    C compiler ${CMAKE_C_COMPILER_ID} ${CMAKE_C_COMPILER_VERSION}
    Fortran compiler ${CMAKE_Fortran_COMPILER_ID} ${CMAKE_Fortran_COMPILER_VERSION}
    ${abi_log}
    "
    )
  endif()
endif()

# --- compiler check

set(cargs "$<$<COMPILE_LANGUAGE:C>:Add_>")
# "Add_" works for all modern compilers we tried.

if(CMAKE_C_COMPILER_ID MATCHES "^Intel")
  if(NOT CMAKE_CROSSCOMPILING)
    if(WIN32)
      add_compile_options($<$<COMPILE_LANGUAGE:C>:/QxHost>)
    else()
      add_compile_options($<$<COMPILE_LANGUAGE:C>:-xHost>)
    endif()
  endif()
endif()

if(CMAKE_Fortran_COMPILER_ID MATCHES "^Intel")

  if(NOT CMAKE_CROSSCOMPILING)
    if(WIN32)
      add_compile_options($<$<COMPILE_LANGUAGE:Fortran>:/QxHost>)
    else()
      add_compile_options($<$<COMPILE_LANGUAGE:Fortran>:-xHost>)
    endif()
  endif()
elseif(CMAKE_Fortran_COMPILER_ID STREQUAL "GNU")
  add_compile_options(
  $<$<COMPILE_LANGUAGE:Fortran>:-std=legacy>
  $<$<BOOL:${MINGW}>:-w>
  )
  # MS-MPI emits extreme amounts of nuisance warnings
  # pzheevd.f broken with -fimplicit-none

  if(NOT CMAKE_CROSSCOMPILING)
    add_compile_options(-mtune=native)
  endif()
endif()

# Clang errors without this
# test the non-no form, otherwise always succeeds
check_compiler_flag(C -Wimplicit-function-declaration HAS_IMPLICIT_FUNC_FLAG)
if(HAS_IMPLICIT_FUNC_FLAG)
  add_compile_options($<$<COMPILE_LANGUAGE:C>:-Wno-implicit-function-declaration>)
endif()

# fixes errors about needing -fPIC -- needed by targets linking to this
if(CMAKE_SYSTEM_NAME STREQUAL "Linux" AND BUILD_SHARED_LIBS)
  set(CMAKE_POSITION_INDEPENDENT_CODE true)
endif()
