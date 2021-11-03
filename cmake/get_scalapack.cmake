include(FetchContent)

file(READ ${CMAKE_CURRENT_LIST_DIR}/libraries.json json)

set(scalapack_urls)
set(scalapack_sha256)

string(JSON N LENGTH ${json} scalapack urls)
math(EXPR N "${N}-1")
foreach(i RANGE ${N})
  string(JSON _u GET ${json} scalapack urls ${i})
  list(APPEND scalapack_urls ${_u})
endforeach()

string(JSON scalapack_sha256 GET ${json} scalapack sha256)

set(FETCHCONTENT_QUIET no)


FetchContent_Declare(scalapack
URL ${scalapack_urls}
URL_HASH SHA256=${scalapack_sha256})

if(NOT scalapack_POPULATED)
  FetchContent_Populate(scalapack)
endif()
