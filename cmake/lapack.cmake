include(ExternalProject)

find_package(LAPACK)

if(LAPACK_FOUND)
  return()
endif()


set(lapack_cmake_args
-DBUILD_SINGLE:BOOL=${BUILD_SINGLE}
-DBUILD_DOUBLE:BOOL=${BUILD_DOUBLE}
-DBUILD_COMPLEX:BOOL=${BUILD_COMPLEX}
-DBUILD_COMPLEX16:BOOL=${BUILD_COMPLEX16}
-DBUILD_SHARED_LIBS:BOOL=${BUILD_SHARED_LIBS}
-DCMAKE_INSTALL_PREFIX:PATH=${CMAKE_INSTALL_PREFIX}
-DCMAKE_C_COMPILER:PATH=${CMAKE_C_COMPILER}
-DCMAKE_Fortran_COMPILER:PATH=${CMAKE_Fortran_COMPILER}
-DBUILD_TESTING:BOOL=off
-DCMAKE_BUILD_TYPE:STRING=Release
)

file(READ ${CMAKE_CURRENT_LIST_DIR}/libraries.json json)

string(JSON lapack_url GET ${json} lapack git)
string(JSON lapack_tag GET ${json} lapack tag)

set(LAPACK_INCLUDE_DIRS ${CMAKE_INSTALL_FULL_INCLUDEDIR})
file(MAKE_DIRECTORY ${LAPACK_INCLUDE_DIRS})
if(NOT IS_DIRECTORY ${LAPACK_INCLUDE_DIRS})
  message(FATAL_ERROR "Could not create directory: ${LAPACK_INCLUDE_DIRS}")
endif()

if(BUILD_SHARED_LIBS)
  set(LAPACK_LIBRARIES ${CMAKE_INSTALL_FULL_LIBDIR}/${CMAKE_SHARED_LIBRARY_PREFIX}lapack${CMAKE_SHARED_LIBRARY_SUFFIX})
else()
  set(LAPACK_LIBRARIES ${CMAKE_INSTALL_FULL_LIBDIR}/${CMAKE_STATIC_LIBRARY_PREFIX}lapack${CMAKE_STATIC_LIBRARY_SUFFIX})
endif()

ExternalProject_Add(lapack
GIT_REPOSITORY ${lapack_url}
GIT_TAG ${lapack_tag}
GIT_SHALLOW true
CMAKE_ARGS ${lapack_cmake_args}
TEST_COMMAND ""
INACTIVITY_TIMEOUT 60
BUILD_BYPRODUCTS ${LAPACK_LIBRARIES}
CONFIGURE_HANDLED_BY_BUILD true
USES_TERMINAL_DOWNLOAD true
USES_TERMINAL_UPDATE true
USES_TERMINAL_PATCH true
USES_TERMINAL_CONFIGURE true
USES_TERMINAL_BUILD true
USES_TERMINAL_INSTALL true
USES_TERMINAL_TEST true
)

add_library(LAPACK::LAPACK INTERFACE IMPORTED GLOBAL)
target_include_directories(LAPACK::LAPACK INTERFACE ${LAPACK_INCLUDE_DIRS})
target_link_libraries(LAPACK::LAPACK INTERFACE ${LAPACK_LIBRARIES})

add_dependencies(LAPACK::LAPACK lapack)
