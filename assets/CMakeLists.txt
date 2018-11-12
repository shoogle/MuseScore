project("MuseScore assets"
  DESCRIPTION "Build MuseScore's icons and resources from SVG source files"
  LANGUAGES NONE
  )

cmake_minimum_required(VERSION 3.0)

option(BUILD_ASSETS "Build MuseScore's icons and resources from SVG source files" ON)
option(DOWNLOAD_ASSETS "Download pre-built assets if they cannot be built due to missing dependencies, or if BUILD_ASSETS is disabled." OFF)
option(OPTIMIZE_SVGS "Optimize SVG file size using SVGO." ON)
option(OPTIMIZE_PNGS "Optimize PNG file size using PNGCRUSH." ON)
option(OPTIMIZE_PNGS_BRUTE "Try all PNG compression methods to ensure smallest possible size (takes time)." OFF)
option(BUILD_ICO "Build ICO icon files for use on Windows" ON)
option(BUILD_ICNS "Build ICNS icon files for use on MacOS" ON)

if(NOT BUILD_ASSETS AND NOT DOWNLOAD_ASSETS)
  message(FATAL_ERROR "Options BUILD_ASSETS and DOWNLOAD_ASSETS can't both be disabled.")
endif(NOT BUILD_ASSETS AND NOT DOWNLOAD_ASSETS)

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

set(ASSETS_MANIFEST "assets-manifest.txt")
file(WRITE "${PROJECT_BINARY_DIR}/${ASSETS_MANIFEST}" "") # create empty file

function(add_to_manifest)
  foreach(FILE ${ARGN})
    file(RELATIVE_PATH PATH "${PROJECT_BINARY_DIR}" "${CMAKE_CURRENT_BINARY_DIR}/${FILE}")
    file(APPEND "${PROJECT_BINARY_DIR}/${ASSETS_MANIFEST}" "${PATH}\n")
  endforeach(FILE)
endfunction(add_to_manifest)

add_custom_target("assets" ALL)

if(BUILD_ASSETS)
  add_subdirectory(resources)
  add_subdirectory(brand)
  add_subdirectory(icons)
  add_subdirectory(splash)

  # optional target to create a compressed ZIP archive containing all assets
  add_custom_target("assets_archive" DEPENDS "${ASSETS_ARCHIVE_NAME}")
  add_custom_command(
    OUTPUT "${ASSETS_ARCHIVE_NAME}"
    DEPENDS "assets"
    COMMAND "${CMAKE_COMMAND}" -E tar "cfv" "${ASSETS_ARCHIVE_NAME}" --format=zip "--files-from=${ASSETS_MANIFEST}"
    VERBATIM
  )
else(BUILD_ASSETS)
  # Download pre-built assets archive during configure and extract during build
  # file(DOWNLOAD)
  add_custom_command( # TODO don't extract if already done so
    TARGET "assets" POST_BUILD
    COMMAND "${CMAKE_COMMAND}" -E tar "xfv" "${ASSETS_ARCHIVE_NAME}"
    VERBATIM
  )
endif(BUILD_ASSETS)