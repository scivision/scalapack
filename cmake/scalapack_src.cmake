include(FetchContent)

file(READ ${CMAKE_CURRENT_LIST_DIR}/libraries.json json)

if(CMAKE_VERSION VERSION_LESS 3.19)
  include(${CMAKE_CURRENT_LIST_DIR}/Modules/JsonParse.cmake)
  sbeParseJson(meta json)
  set(scalapack_url ${meta.scalapack.url})
  set(scalapack_tag ${meta.scalapack.tag})
else()
  string(JSON scalapack_url GET ${json} scalapack url)
  string(JSON scalapack_tag GET ${json} scalapack tag)
endif()

set(FETCHCONTENT_QUIET no)

FetchContent_Declare(SCALAPACK
GIT_REPOSITORY ${scalapack_url}
GIT_TAG ${scalapack_tag}
GIT_SHALLOW true
INACTIVITY_TIMEOUT 60
TLS_VERIFY true
)

FetchContent_Populate(SCALAPACK)
