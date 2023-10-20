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

string(JSON url GET ${json} ${name} url)
string(JSON tag GET ${json} ${name} tag)

set(FETCHCONTENT_QUIET no)

FetchContent_Declare(${PROJECT_NAME}
GIT_REPOSITORY ${url}
GIT_TAG ${tag}
GIT_SHALLOW true
GIT_REMOTE_UPDATE_STRATEGY "CHECKOUT"
INACTIVITY_TIMEOUT 60
)

endif()

FetchContent_Populate(${PROJECT_NAME})
