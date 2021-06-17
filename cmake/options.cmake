option(autobuild "auto-build Lapack if missing or broken" true)
option(lapack_external "build Lapack instead of finding")

option(dev "Scalapack developer mode")

# --- other options

# default build all
if(NOT DEFINED arith)
  set(arith "s;d;c;z")
endif()

set(CMAKE_TLS_VERIFY true)

set(FETCHCONTENT_UPDATES_DISCONNECTED_SCALAPACK true)

if(dev)

else()
  set_directory_properties(PROPERTIES EP_UPDATE_DISCONNECTED true)
endif()

if(CMAKE_INSTALL_PREFIX_INITIALIZED_TO_DEFAULT)
  set(CMAKE_INSTALL_PREFIX ${PROJECT_BINARY_DIR} CACHE PATH "default install dir" FORCE)
endif()


set(CMAKE_EXPORT_COMPILE_COMMANDS on)

# --- auto-ignore build directory
if(NOT EXISTS ${PROJECT_BINARY_DIR}/.gitignore)
  file(WRITE ${PROJECT_BINARY_DIR}/.gitignore "*")
endif()
