set(TARGET "${TARGET}_splash")
add_custom_target("${TARGET}")

function(splash SVG_FILE_IN BUILD)
  string(TOLOWER "${BUILD}" BUILD_LOWER)
  set(FILE_OUT "splash-${BUILD_LOWER}")
  configure_file("${SVG_FILE_IN}" "${FILE_OUT}-raw.svg") # substitute @BUILD@
  standalone_svg("${FILE_OUT}-raw.svg" "${FILE_OUT}-standalone.svg")
  optimize_svg("${FILE_OUT}-standalone.svg" "${FILE_OUT}.svg")
  add_custom_target("${TARGET}_${FILE_OUT}.svg" DEPENDS "${FILE_OUT}.svg")
  add_dependencies("${TARGET}_${FILE_OUT}.svg" "assets_icons_app_musescore-icon-round.svg")
  add_dependencies("${TARGET}" "${TARGET}_${FILE_OUT}.svg")
  add_to_assets_archive("${FILE_OUT}.svg")
endfunction(splash)

splash(splash-stable.svg STABLE)
splash(splash-unstable.svg NIGHTLY)
splash(splash-unstable.svg DEVELOPMENT)

propagate_assets_list()