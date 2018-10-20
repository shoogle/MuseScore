subdirs(icons)

macro(rasterize SVG_FILE)
  add_custom_command(OUTPUT "${SVG_FILE}"
                     COMMAND inkscape ARGS -z "${SVG_FILE}" --export-text-to-path --export-plain-svg tmp.svg
                     COMMAND scour ARGS tmp.svg "${SVG_FILE}"
                     MAIN_DEPENDENCY "${SVG_FILE}"
                     BYPRODUCTS tmp.svg
                     COMMENT "Do foo"
                     VERBATIM)
endmacro(<name>)
