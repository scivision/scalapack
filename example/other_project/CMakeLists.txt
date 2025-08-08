# test this project used as an archive in other projects
# if broken, the CMake configure step fails

cmake_minimum_required(VERSION 3.20...4.0)

project(otherProject LANGUAGES C Fortran)

include(FetchContent)

FetchContent_Declare(scalapack
  URL https://github.com/scivision/scalapack/archive/refs/heads/main.zip
)

FetchContent_MakeAvailable(scalapack)
