set(GENERATED_FILES "") # empty list

foreach(FILE musescore-icon-round musescore-icon-square)
  standalone_svg("${CMAKE_CURRENT_SOURCE_DIR}/${FILE}.svg" "${FILE}-standalone.svg")
  optimize_svg("${FILE}-standalone.svg" "${FILE}.svg")
  list(APPEND GENERATED_FILES "${FILE}.svg")
  rasterize_svg_sizes("${FILE}" ${ALL_ICON_SIZES})
endforeach(FILE)

add_custom_target("assets_icons_app" DEPENDS ${GENERATED_FILES})
add_dependencies("assets" "assets_icons_app")
add_to_manifest(${GENERATED_FILES})