if(NOT DEFINED MUSESCORE_NAME)
  set(MUSESCORE_NAME "MuseScore")
endif(NOT DEFINED MUSESCORE_NAME)

if(NOT DEFINED MUSESCORE_VERSION)
  set(MUSESCORE_VERSION "X.Y")
  set(MUSESCORE_VERSION_FULL "X.Y.Z")
endif(NOT DEFINED MUSESCORE_VERSION)

add_custom_target(splash)
add_dependencies(assets splash)

# stable builds
configure_file(splash-stable.svg splash-stable.svg)
rasterize_svg(splash-stable.svg splash-stable.png)
add_custom_target(splash-stable DEPENDS splash-stable.png)
add_dependencies(splash splash-stable)
add_to_assets_archive("splash-stable.png")

# nightly builds
foreach(BUILD NIGHTLY DEVELOPMENT)
  string(TOLOWER ${BUILD} BUILD_LOWER)
  configure_file(splash-unstable.svg splash-${BUILD_LOWER}.svg)
  rasterize_svg(splash-${BUILD_LOWER}.svg splash-${BUILD_LOWER}.png)
  add_custom_target(splash-${BUILD_LOWER} DEPENDS splash-${BUILD_LOWER}.png)
  add_dependencies(splash splash-${BUILD_LOWER})
  add_to_assets_archive("splash-${BUILD_LOWER}.png")
endforeach(BUILD)
