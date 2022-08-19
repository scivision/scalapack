include(FetchContent)

string(TOLOWER ${PROJECT_NAME}_src name)

file(READ ${CMAKE_CURRENT_LIST_DIR}/libraries.json json)

if(local)

find_file(${name}_archive
NAMES ${name}.tar.bz2 ${name}.tar.gz ${name}.tar ${name}.zip ${name}.zstd ${name}.tar.xz
HINTS ${local}
NO_DEFAULT_PATH
)

if(NOT ${name}_archive)
message(FATAL_ERROR "Archive file for ${name} does not exist under ${local}")
endif()

message(STATUS "${name}: using source archive ${${name}_archive}")

FetchContent_Declare(${PROJECT_NAME}
URL ${${name}_archive}
)

else()

if(CMAKE_VERSION VERSION_LESS 3.19)
  include(${CMAKE_CURRENT_LIST_DIR}/Modules/JsonParse.cmake)
  sbeParseJson(meta json)
  set(url ${meta.${name}.url})
  set(tag ${meta.${name}.tag})
else()
  string(JSON url GET ${json} ${name} url)
  string(JSON tag GET ${json} ${name} tag)
endif()

set(FETCHCONTENT_QUIET no)

FetchContent_Declare(${PROJECT_NAME}
GIT_REPOSITORY ${url}
GIT_TAG ${tag}
GIT_SHALLOW true
INACTIVITY_TIMEOUT 60
TLS_VERIFY true
)

endif()

FetchContent_Populate(${PROJECT_NAME})
