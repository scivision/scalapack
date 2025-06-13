set(_p ${PROJECT_SOURCE_DIR}/scalapack/REDIST/SRC/)

set(ALLAUX ${_p}pgemraux.c)

set(IMRSRC ${_p}pigemr.c ${_p}pigemr2.c ${_p}pitrmr.c ${_p}pitrmr2.c)

set(mrsrc)

if(BUILD_SINGLE)
  list(APPEND mrsrc ${_p}psgemr.c ${_p}psgemr2.c ${_p}pstrmr.c ${_p}pstrmr2.c)
endif()

if(BUILD_COMPLEX)
  list(APPEND mrsrc ${_p}pcgemr.c ${_p}pcgemr2.c ${_p}pctrmr.c ${_p}pctrmr2.c)
endif()

if(BUILD_DOUBLE)
  list(APPEND mrsrc ${_p}pdgemr.c ${_p}pdgemr2.c ${_p}pdtrmr.c ${_p}pdtrmr2.c)
endif()

if(BUILD_COMPLEX16)
  list(APPEND mrsrc ${_p}pzgemr.c ${_p}pzgemr2.c ${_p}pztrmr.c ${_p}pztrmr2.c)
endif()

string(REPLACE "-DNDEBUG" "" CMAKE_C_FLAGS_RELEASE "${CMAKE_C_FLAGS_RELEASE}")
string(REPLACE "-DNDEBUG" "" CMAKE_C_FLAGS_RELWITHDEBINFO "${CMAKE_C_FLAGS_RELWITHDEBINFO}")
string(REPLACE "-DNDEBUG" "" CMAKE_C_FLAGS_MINSIZEREL "${CMAKE_C_FLAGS_MINSIZEREL}")
# remove_definitions(-DNDEBUG) # Did not work because -DNDEBUG is set internal to CMake
# the files in this directory have unwanted NDEBUG definitions

add_library(scalapack_redist OBJECT ${ALLAUX} ${IMRSRC} ${mrsrc})
target_compile_definitions(scalapack_redist PRIVATE ${cargs})

target_sources(scalapack PRIVATE $<TARGET_OBJECTS:scalapack_redist>)
