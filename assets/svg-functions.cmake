# TLDR: CMakes's add_custom_command() gives unexpected results if relative
# paths are used for its DEPENDS argument, hence we must use absolute paths.
#
# All path arguments to add_custom_command() are relative to the current
# binary dir, except for some reason DEPENDS is relative to the source dir.
# However, if the named dependency was generated as OUTPUT to a previous
# add_custom_command() then DEPENDS becomes relative to the binary dir again!
function(make_path_absolute VAR_NAME)
  set(FILE_PATH "${${VAR_NAME}}")
  if(NOT IS_ABSOLUTE "${FILE_PATH}")
    set("${VAR_NAME}" "${CMAKE_CURRENT_BINARY_DIR}/${FILE_PATH}" PARENT_SCOPE)
  endif(NOT IS_ABSOLUTE "${FILE_PATH}")
endfunction(make_path_absolute)

function(standalone_svg SVG_FILE_IN SVG_FILE_OUT)
  make_path_absolute(SVG_FILE_IN) # absolute path needed for add_custom_command
  add_custom_command(
    OUTPUT "${SVG_FILE_OUT}"
    DEPENDS "${SVG_FILE_IN}" # absolute path required
    COMMAND xmllint "${SVG_FILE_IN}" --xinclude --pretty 1 --output "${SVG_FILE_OUT}"
    COMMAND inkscape "${SVG_FILE_OUT}" --verb=EditSelectAll --verb=EditUnlinkClone --verb=EditSelectAll --verb=org.ekips.filter.embedselectedimages --verb=FileSave --verb=FileQuit
    COMMAND inkscape -z "${SVG_FILE_OUT}" --export-text-to-path --vacuum-defs --export-plain-svg "${SVG_FILE_OUT}"
    VERBATIM
    )
endfunction(standalone_svg)

function(optimize_svg SVG_FILE_IN SVG_FILE_OUT)
  make_path_absolute(SVG_FILE_IN) # absolute path needed for add_custom_command
  add_custom_command(
    OUTPUT "${SVG_FILE_OUT}"
    DEPENDS "${SVG_FILE_IN}" # absolute path required
    COMMAND svgo "${SVG_FILE_IN}" -o "${SVG_FILE_OUT}"
    VERBATIM
    )
endfunction(optimize_svg)

function(vectorize_svg SVG_FILE_IN SVG_FILE_OUT)
  make_path_absolute(SVG_FILE_IN) # absolute path needed for add_custom_command
  add_custom_command(
    OUTPUT "${SVG_FILE_OUT}"
    DEPENDS "${SVG_FILE_IN}" # absolute path required
    COMMAND inkscape -z "${SVG_FILE_IN}" --export-text-to-path --vacuum-defs --export-plain-svg "${SVG_FILE_OUT}"
    VERBATIM
    )
endfunction(vectorize_svg)

function(rasterize_svg SVG_FILE_IN PNG_FILE_OUT)
  # any additional arguments will be passed to inkscape (see ${ARGN})
  make_path_absolute(SVG_FILE_IN) # absolute path needed for add_custom_command
  add_custom_command(
    OUTPUT "${PNG_FILE_OUT}"
    DEPENDS "${SVG_FILE_IN}" # absolute path required
    COMMAND inkscape -z "${SVG_FILE_IN}" ${ARGN} --export-png "${PNG_FILE_OUT}"
    VERBATIM
    )
endfunction(rasterize_svg)
