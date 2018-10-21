# The MuseScore version number.
SET(MUSESCORE_NAME "MuseScore")
SET(MUSESCORE_VERSION_MAJOR  "3")
SET(MUSESCORE_VERSION_MINOR  "0")
SET(MUSESCORE_VERSION_PATCH  "0")
SET(MUSESCORE_VERSION       "${MUSESCORE_VERSION_MAJOR}.${MUSESCORE_VERSION_MINOR}")
SET(MUSESCORE_NAME_VERSION "${MUSESCORE_NAME} ${MUSESCORE_VERSION_MAJOR}")
#
# Version schema x.x.x is hardcoded in source
#
SET(MUSESCORE_VERSION_FULL  "${MUSESCORE_VERSION}.${MUSESCORE_VERSION_PATCH}")

add_custom_target(
  splash
  ALL
  COMMAND echo "BUILD SVGs"
  VERBATIM
  )

# stable builds
configure_file(splash-stable.svg splash-stable.svg)
rasterize_svg(splash-stable.svg splash-stable.png)

# nightly builds
foreach(BUILD NIGHTLY DEVELOPMENT)
  string(TOLOWER ${BUILD} BUILD_LOWER)
  configure_file(splash-unstable.svg splash-${BUILD_LOWER}.svg)
  rasterize_svg(splash-${BUILD_LOWER}.svg splash-${BUILD_LOWER}.png)
endforeach(TYPE)
