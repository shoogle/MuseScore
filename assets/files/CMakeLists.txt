# icons for MuseScore files
foreach(TYPE MSCX MSCZ)
  string(TOLOWER ${TYPE} TYPE_LOWER)
  configure_file(msc-master.svg ${TYPE_LOWER}.svg) # substitutes @TYPE@ in file
endforeach(TYPE)

# icons for MusicXML files
foreach(TYPE XML MXL)
  string(TOLOWER ${TYPE} TYPE_LOWER)
  configure_file(musicxml-master.svg ${TYPE_LOWER}.svg) # substitutes @TYPE@ in file
endforeach(TYPE)
