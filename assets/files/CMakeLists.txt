add_custom_target("files")
add_dependencies(assets files)

# icons for MuseScore files
foreach(TYPE "MSCX" "MSCZ")
  string(TOLOWER "${TYPE}" TYPE_LOWER)
  add_custom_target("${TYPE_LOWER}" DEPENDS "${TYPE_LOWER}.svg")
  add_dependencies(files "${TYPE_LOWER}")
  configure_file(musescore-file.svg "${TYPE_LOWER}-raw.svg") # substitute @TYPE@ in file
  vectorize_svg("${TYPE_LOWER}-raw.svg" "${TYPE_LOWER}-vector.svg")
  optimize_svg("${TYPE_LOWER}-vector.svg" "${TYPE_LOWER}.svg")
  add_to_assets_archive("${TYPE_LOWER}.svg")
endforeach(TYPE)

# icons for MusicXML files
foreach(TYPE "XML" "MXL")
  string(TOLOWER "${TYPE}" TYPE_LOWER)
  configure_file(musicxml-file.svg "${TYPE_LOWER}.svg") # substitute @TYPE@ in file
  add_to_assets_archive("${TYPE_LOWER}.svg")
endforeach(TYPE)

set(assets "${assets}" PARENT_SCOPE)
