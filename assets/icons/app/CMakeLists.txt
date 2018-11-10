set(TARGET "${TARGET}_app")
add_custom_target("${TARGET}")

foreach(FILE musescore-icon-round musescore-icon-square)
  add_custom_target("${TARGET}_${FILE}.svg" DEPENDS "${FILE}.svg")
  add_dependencies("${TARGET}" "${TARGET}_${FILE}.svg")
  standalone_svg("${CMAKE_CURRENT_SOURCE_DIR}/${FILE}.svg" "${FILE}-standalone.svg")
  optimize_svg("${FILE}-standalone.svg" "${FILE}.svg")
  add_to_assets_archive("${FILE}.svg")
  rasterize_svg_sizes("${FILE}" ${ALL_ICON_SIZES})
endforeach(FILE)

propagate_assets_list()