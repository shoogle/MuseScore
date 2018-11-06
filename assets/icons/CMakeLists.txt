# These SVGs already optimized, so just copy to build folder
# foreach(FILE musescore-icon-round.svg musescore-icon-square.svg)
#   file(COPY "${FILE}" DESTINATION .)
#   add_to_assets_archive("${FILE}")
# endforeach(FILE)

set(TARGET "assets_icons")
add_custom_target("${TARGET}")
add_dependencies(assets "${TARGET}")

foreach(FILE musescore-icon-round musescore-icon-square)
  add_custom_target("${FILE}" DEPENDS "${FILE}.svg")
  add_dependencies("${TARGET}" "${FILE}")
  standalone_svg("${CMAKE_CURRENT_SOURCE_DIR}/${FILE}.svg" "${FILE}-standalone.svg")
  optimize_svg("${FILE}-standalone.svg" "${FILE}.svg")
  add_to_assets_archive("${FILE}.svg")
endforeach(FILE)