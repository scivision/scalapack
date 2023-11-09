if(local)
  get_filename_component(local ${local} ABSOLUTE)

  if(NOT IS_DIRECTORY ${local})
    message(FATAL_ERROR "Local directory ${local} does not exist")
  endif()
endif()

# --- other options

option(BUILD_SINGLE "Build single precision real" ON)
option(BUILD_DOUBLE "Build double precision real" ON)
option(BUILD_COMPLEX "Build single precision complex")
option(BUILD_COMPLEX16 "Build double precision complex")

# complex requires corresponding real
if(BUILD_COMPLEX)
  set(BUILD_SINGLE true)
endif()
if(BUILD_COMPLEX16)
  set(BUILD_DOUBLE true)
endif()

option(find_lapack "find LAPACK" on)

# used with Git submodule to avoid rechecking each build for submodule changes
# for developers who switch submodule commits, need a fresh build of entire project.
set(FETCHCONTENT_UPDATES_DISCONNECTED true)
set_property(DIRECTORY PROPERTY EP_UPDATE_DISCONNECTED true)

list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_LIST_DIR}/cmake)

# Necessary for shared library with Visual Studio / Windows oneAPI
set(CMAKE_WINDOWS_EXPORT_ALL_SYMBOLS true)

if(CMAKE_INSTALL_PREFIX_INITIALIZED_TO_DEFAULT AND PROJECT_IS_TOP_LEVEL)
  set(CMAKE_INSTALL_PREFIX ${PROJECT_BINARY_DIR}/local CACHE PATH "Install path" FORCE)
endif()
