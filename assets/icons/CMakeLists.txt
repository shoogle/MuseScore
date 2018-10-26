# These SVGs already optimized, so just copy to build folder
foreach(FILE musescore-icon-round.svg musescore-icon-square.svg)
  file(COPY "${FILE}" DESTINATION .)
  add_to_assets_archive("${FILE}")
endforeach(FILE)
