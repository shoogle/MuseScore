project("MuseScore assets"
  DESCRIPTION "Build MuseScore's icons and resources from SVG source files"
  LANGUAGES NONE
  )

cmake_minimum_required(VERSION 3.0.0)

include("svg-functions.cmake")

add_custom_target("assets")
add_custom_target("assets_zip" DEPENDS MuseScore_assets.zip)

function(zip_archive ARCHIVE)
  # any additional arguments will be passed to the zip utility (see ${ARGN})
  add_custom_command(
    OUTPUT "${ARCHIVE}"
    DEPENDS assets # is a target, not a file, so no issue with relative paths
    COMMAND "${CMAKE_COMMAND}" -E tar "cfv" "${ARCHIVE}" --format=zip ${ARGN}
    VERBATIM
  )
endfunction(zip_archive)

# Mark a file for inclusion in the assets ZIP archive
macro(add_to_assets_archive FILE)
  if(IS_ABSOLUTE "${FILE}")
    list(APPEND _ASSETS_LIST "${FILE}")
  else(IS_ABSOLUTE "${FILE}")
    list(APPEND _ASSETS_LIST "${CMAKE_CURRENT_BINARY_DIR}/${FILE}")
  endif(IS_ABSOLUTE "${FILE_PATH}")
  set(_ASSETS_LIST "${_ASSETS_LIST}" PARENT_SCOPE)
endmacro(add_to_assets_archive)

# Make changes to the assets list visible in the parent directory. Must be the
# last thing called in any subdirectory where assets are added to the archive.
macro(propagate_assets_list)
  set(_ASSETS_LIST "${_ASSETS_LIST}" PARENT_SCOPE)
endmacro(propagate_assets_list)

add_subdirectory(icons)
add_subdirectory(files)
add_subdirectory(splash)
add_subdirectory(resources)

message("Assets: ${_ASSETS_LIST}")
zip_archive(MuseScore_assets.zip ${_ASSETS_LIST})
