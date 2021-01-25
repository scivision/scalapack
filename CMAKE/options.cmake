option(autobuild "auto-build Lapack if missing or broken" true)
option(lapack_external "build Lapack instead of finding")

option(dev "Scalapack developer mode")

# --- Error if Visual Studio backend, as this does not work.
# https://software.intel.com/en-us/articles/configuring-visual-studio-for-mixed-language-applications
string(REGEX MATCH "^Visual Studio" vs_backend ${CMAKE_GENERATOR})
if(vs_backend)
  message(STATUS "Ninja is a small program available from:
   https://github.com/ninja-build/ninja/releases")
  message(FATAL_ERROR "Visual Studio does not work. Use Ninja backend 'cmake -G Ninja' instead.")
endif()

# --- other options

if(NOT DEFINED arith)
  set(arith "s;d")
endif()

if(dev)

else()
  set(FETCHCONTENT_UPDATES_DISCONNECTED_LAPACK true)
endif()
