option(autobuild "auto-build Lapack if missing or broken" true)
option(lapack_external "build Lapack instead of finding")

option(dev "Scalapack developer mode")

# --- other options

# default build all
if(NOT DEFINED arith)
  set(arith "s;d;c;z")
endif()

if(dev)

else()
  set(FETCHCONTENT_UPDATES_DISCONNECTED_LAPACK true)
endif()


set(CMAKE_EXPORT_COMPILE_COMMANDS on)

# --- auto-ignore build directory
if(NOT EXISTS ${PROJECT_BINARY_DIR}/.gitignore)
  file(WRITE ${PROJECT_BINARY_DIR}/.gitignore "*")
endif()
