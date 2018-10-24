# icons for MuseScore files
foreach(TYPE "MSCX" "MSCZ")
  string(TOLOWER "${TYPE}" TYPE_LOWER)
  configure_file(musescore-file.svg "${TYPE_LOWER}.svg") # substitute @TYPE@ in file
  vectorize_svg("${TYPE_LOWER}.svg" "${TYPE_LOWER}2.svg")
  optimize_svg("${TYPE_LOWER}2.svg" "${TYPE_LOWER}3.svg")
endforeach(TYPE)

# icons for MusicXML files
foreach(TYPE "XML" "MXL")
  string(TOLOWER "${TYPE}" TYPE_LOWER)
  configure_file(musicxml-file.svg "${TYPE_LOWER}.svg") # substitute @TYPE@ in file
endforeach(TYPE)
