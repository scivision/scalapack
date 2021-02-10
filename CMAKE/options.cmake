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
