subdirs(files icons resources splash)

function(optimize_svg SVG_FILE_IN SVG_FILE_OUT)
  get_filename_component(BASENAME "${SVG_FILE_OUT}" NAME)
  add_custom_command(
    OUTPUT "${SVG_FILE_OUT}"
    COMMAND scour "${SVG_FILE_IN}" "${SVG_FILE_OUT}"
    VERBATIM
    )
  add_custom_target(
    "${BASENAME} (optimized)"
    ALL
    DEPENDS "${SVG_FILE_OUT}"
    )
endfunction(optimize_svg)

function(vectorize_svg SVG_FILE_IN SVG_FILE_OUT)
  get_filename_component(BASENAME "${SVG_FILE_OUT}" NAME)
  add_custom_command(
    OUTPUT "${SVG_FILE_OUT}"
    COMMAND inkscape -z "${SVG_FILE_IN}" --vacuum-defs --export-text-to-path --export-plain-svg "${SVG_FILE_OUT}"
    VERBATIM
    )
  add_custom_target(
    "${BASENAME} (vectorized)"
    ALL
    DEPENDS "${SVG_FILE_OUT}"
    VERBATIM
    )
endfunction(vectorize_svg)

function(rasterize_svg SVG_FILE_IN PNG_FILE_OUT)
  # any additional arguments will be passed to inkscape (see ${ARGN})
  get_filename_component(BASENAME "${PNG_FILE_OUT}" NAME)
  add_custom_command(
    OUTPUT "${PNG_FILE_OUT}"
    COMMAND inkscape -z "${SVG_FILE_IN}" ${ARGN} --export-png "${PNG_FILE_OUT}"
    VERBATIM
    )
  add_custom_target(
    "${BASENAME} (rasterized)"
    ALL
    DEPENDS "${PNG_FILE_OUT}"
    VERBATIM
    )
endfunction(vectorize_svg)
