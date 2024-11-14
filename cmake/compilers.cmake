include(CheckCompilerFlag)
include(CheckPIESupported)
# --- compiler check

set(cargs "$<$<COMPILE_LANGUAGE:C>:Add_>")
# "Add_" works for all modern compilers we tried.

if(CMAKE_Fortran_COMPILER_ID STREQUAL "GNU")
  add_compile_options(
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

# fixes errors about needing -fPIC -- needed by targets linking to this
if(CMAKE_SYSTEM_NAME STREQUAL "Linux" AND BUILD_SHARED_LIBS)
  check_pie_supported()
  set(CMAKE_POSITION_INDEPENDENT_CODE true)
endif()
