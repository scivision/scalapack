option(autobuild "auto-build Lapack if needed")

message(STATUS "Scalpaack ${PROJECT_VERSION}  CMake ${CMAKE_VERSION}")

# default build all
if(NOT DEFINED arith)
  set(arith "s;d")
endif()

# complex arith requires corresponding real arith
if(c IN_LIST arith AND NOT s IN_LIST arith)
  list(APPEND arith s)
endif()
if(z IN_LIST arith AND NOT d IN_LIST arith)
  list(APPEND arith d)
endif()

set(CMAKE_TLS_VERIFY true)

set(FETCHCONTENT_UPDATES_DISCONNECTED_SCALAPACK true)

set_directory_properties(PROPERTIES EP_UPDATE_DISCONNECTED true)

set(CMAKE_MODULE_PATH ${CMAKE_CURRENT_LIST_DIR}/Modules)

if(CMAKE_GENERATOR STREQUAL "Ninja Multi-Config")
  set(EXTPROJ_GENERATOR "Ninja")
else()
  set(EXTPROJ_GENERATOR ${CMAKE_GENERATOR})
endif()

# Rpath options necessary for shared library install to work correctly in user projects
set(CMAKE_INSTALL_NAME_DIR ${CMAKE_INSTALL_PREFIX}/lib)
set(CMAKE_INSTALL_RPATH ${CMAKE_INSTALL_PREFIX}/lib)
set(CMAKE_INSTALL_RPATH_USE_LINK_PATH true)

# Necessary for shared library with Visual Studio / Windows oneAPI
set(CMAKE_WINDOWS_EXPORT_ALL_SYMBOLS true)


if(CMAKE_INSTALL_PREFIX_INITIALIZED_TO_DEFAULT)
  # will not take effect without FORCE
  # CMAKE_BINARY_DIR for use from FetchContent
  set(CMAKE_INSTALL_PREFIX ${CMAKE_BINARY_DIR} CACHE PATH "Install top-level directory" FORCE)
endif()

# --- auto-ignore build directory
if(NOT EXISTS ${PROJECT_BINARY_DIR}/.gitignore)
  file(WRITE ${PROJECT_BINARY_DIR}/.gitignore "*")
endif()
