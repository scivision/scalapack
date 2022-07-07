include(FetchContent)

file(READ ${CMAKE_CURRENT_LIST_DIR}/libraries.json json)

string(JSON scalapack_url GET ${json} scalapack url)
string(JSON scalapack_tag GET ${json} scalapack tag)

set(FETCHCONTENT_QUIET no)

FetchContent_Declare(SCALAPACK
GIT_REPOSITORY ${scalapack_url}
GIT_TAG ${scalapack_tag}
GIT_SHALLOW true
INACTIVITY_TIMEOUT 60
TLS_VERIFY true
)

FetchContent_Populate(SCALAPACK)
