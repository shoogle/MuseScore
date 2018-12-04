# Create a new CMake project for the assets to allow them to be generated
# independently of MuseScore's build.
project("MuseScore assets"
  DESCRIPTION "Build MuseScore's icons and resources from SVG source files"
  LANGUAGES NONE
  )

cmake_minimum_required(VERSION 3.0)

if(WIN32)
  set(WIN_NOT_AVAIL "Not available on Windows")
  option(BUILD_MACOS_ICONS "${WIN_NOT_AVAIL}" OFF)
endif(WIN32)

# The following options are enabled/disabled as appropriate for somebody
# building the assets alone. If MuseScore requires different settings then
# these should be made in MuseScore's top-level CMakeLists.txt. Options with
# the same name in MuseScore's CMakeLists.txt will override the ones here.
option(CHECK_FONTS "Fail build if required fonts are not installed (disable to allow build to proceed using a fallback font)" ON)
option(BUILD_WINDOWS_ICONS "Build ICO icons for Windows and associated PNG sizes." ON)
option(BUILD_MACOS_ICONS "Build ICNS icons for macOS and associated PNG sizes." ON)
option(BUILD_FREEDESKTOP_ICONS "Build PNG icons at sizes commonly used on Linux and other systems that obey the FreeDesktop.org standards." ON)
option(OPTIMIZE_SVGS "Optimize SVG file size using SVGO." ON)
option(OPTIMIZE_PNGS "Optimize PNG file size using PNGCRUSH." ON)
option(OPTIMIZE_PNGS_BRUTE "Try all PNG compression methods to ensure smallest possible size (takes time)." OFF)

# Some assets depend on variables defined in MuseScore's CMakeLists.txt, so we
# set default values here to allow independent building of the assets.
if(NOT DEFINED MUSESCORE_NAME)
  set(MUSESCORE_NAME "MuseScore")
endif(NOT DEFINED MUSESCORE_NAME)

if(NOT DEFINED MUSESCORE_VERSION_FULL)
  set(MUSESCORE_VERSION_FULL "X.Y.Z")
endif(NOT DEFINED MUSESCORE_VERSION_FULL)

# Optionally pack assets into a ZIP file for easy distribution.
if(NOT DEFINED ASSETS_ARCHIVE_NAME)
  set(ASSETS_ARCHIVE_NAME "${MUSESCORE_NAME}-assets-${MUSESCORE_VERSION_FULL}.zip")
endif(NOT DEFINED ASSETS_ARCHIVE_NAME)

# Store a list of all assets generated as part of the build.
set(ASSETS_MANIFEST "assets-manifest.txt") # used for archiving and CI tests.
# As a basic CI test, a reference copy of this file is checked into the repo
# and compared to the one generated during the build to ensure they match.
# This will catch simple errors, but assets must still be compared visually.

file(WRITE "${PROJECT_BINARY_DIR}/${ASSETS_MANIFEST}" "") # empty file to append to

function(add_to_manifest # add assets to the manifest file
  ASSET # name of asset file to be added to manifest
  # ARGN optionally specify more asset files as additional arguments
  )
  foreach(FILE "${ASSET}" ${ARGN})
    # expand path to asset file to make it relative to the build directory
    file(RELATIVE_PATH PATH "${PROJECT_BINARY_DIR}" "${CMAKE_CURRENT_BINARY_DIR}/${FILE}")
    file(APPEND "${PROJECT_BINARY_DIR}/${ASSETS_MANIFEST}" "${PATH}\n")
  endforeach(FILE)
endfunction(add_to_manifest)

# Load CMake code stored in other files (modular programming)
include("image-functions.cmake")
if(CHECK_FONTS)
  include("font-dependencies.cmake")
endif(CHECK_FONTS)

add_custom_target("assets" ALL) # main target to build all assets

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
