project("MuseScore assets"
  DESCRIPTION "Build MuseScore's icons and resources from SVG source files"
  LANGUAGES NONE
  )

cmake_minimum_required(VERSION 3.0.0)

option(BUILD_ASSETS "Build application icons and resources from SVG source files." ON)

if(NOT DEFINED MUSESCORE_NAME)
  set(MUSESCORE_NAME "MuseScore")
endif(NOT DEFINED MUSESCORE_NAME)

if(NOT DEFINED MUSESCORE_VERSION)
  set(MUSESCORE_VERSION "X.Y")
  set(MUSESCORE_VERSION_FULL "X.Y.Z")
endif(NOT DEFINED MUSESCORE_VERSION)

set(ASSETS_ARCHIVE_NAME "${MUSESCORE_NAME}-assets-${MUSESCORE_VERSION_FULL}.zip")

include("svg-functions.cmake")
include("archive-functions.cmake")

# Mark a file for inclusion in the assets ZIP archive
macro(add_to_assets_archive FILE)
  if(IS_ABSOLUTE "${FILE}")
    list(APPEND _ASSETS_LIST "${FILE}")
  else(IS_ABSOLUTE "${FILE}")
    list(APPEND _ASSETS_LIST "${CMAKE_CURRENT_BINARY_DIR}/${FILE}")
  endif(IS_ABSOLUTE "${FILE}")
  set(_ASSETS_LIST "${_ASSETS_LIST}" PARENT_SCOPE)
endmacro(add_to_assets_archive)

# Make changes to the assets list visible in the parent directory. Must be the
# last thing called in any subdirectory where assets are added to the archive.
macro(propagate_assets_list)
  set(_ASSETS_LIST "${_ASSETS_LIST}" PARENT_SCOPE)
endmacro(propagate_assets_list)

function(add_directory_target DIRECTORY)
  add_subdirectory("${DIRECTORY}")
  add_dependencies("${TARGET}" "${TARGET}_${DIRECTORY}")
  propagate_assets_list() # propagate outside function scope
endfunction(add_directory_target)

set(TARGET "assets")

add_custom_target("${TARGET}")

add_subdirectory(resources)

add_directory_target(brand)
add_directory_target(icons)
add_directory_target(splash)

message("Assets: ${_ASSETS_LIST}")

add_custom_target("assets_zip" ALL DEPENDS "${ASSETS_ARCHIVE_NAME}")

zip_archive("${ASSETS_ARCHIVE_NAME}" ${_ASSETS_LIST})
unzip_archive("${ASSETS_ARCHIVE_NAME}" ${_ASSETS_LIST})
