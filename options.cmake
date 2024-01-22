if(DEFINED SCALAPACK_IS_TOP)
  set(SCALAPACK_IS_TOP_LEVEL ${SCALAPACK_IS_TOP})
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

option(${PROJECT_NAME}_BUILD_TESTING "Build tests" ${SCALAPACK_IS_TOP_LEVEL})

# used with Git submodule to avoid rechecking each build for submodule changes
# for developers who switch submodule commits, need a fresh build of entire project.
set(FETCHCONTENT_UPDATES_DISCONNECTED true)
set_property(DIRECTORY PROPERTY EP_UPDATE_DISCONNECTED true)

# Necessary for shared library with Visual Studio / Windows oneAPI
set(CMAKE_WINDOWS_EXPORT_ALL_SYMBOLS true)

if(CMAKE_INSTALL_PREFIX_INITIALIZED_TO_DEFAULT AND SCALAPACK_IS_TOP_LEVEL)
  set(CMAKE_INSTALL_PREFIX ${PROJECT_BINARY_DIR}/local CACHE PATH "Install path" FORCE)
endif()
