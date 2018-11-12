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

function(required_program VARIABLE COMMAND DESCRIPTION)
  if(BUILD_ASSETS)
    find_program("${VARIABLE}" "${COMMAND}" DOC "${DESCRIPTION}")
    if(NOT ${VARIABLE} OR NOT EXISTS "${${VARIABLE}}")
      set(MSG_TYPE FATAL_ERROR) # fail build due to missing dependency
      if(DOWNLOAD_ASSETS)
        set(MSG_TYPE WARNING) # don't fail the build
        set(BUILD_ASSETS OFF) # download assets instead of building them
      endif(DOWNLOAD_ASSETS)
      message("${MSG_TYPE}" "Not found: ${COMMAND} - ${DESCRIPTION}")
      message("A build dependency is missing so assets will be downloaded.")
    endif(NOT ${VARIABLE} OR NOT EXISTS "${${VARIABLE}}")
  endif(BUILD_ASSETS)
endfunction(required_program)

required_program(INKSCAPE "inkscape" "SVG vector graphics editing program")
required_program(XMLLINT "xmllint" "Tool for parsing XML files")

if(OPTIMIZE_SVGS)
  required_program(SVGO "svgo" "Tool for optimizing SVG vector graphics files")
endif(OPTIMIZE_SVGS)

if(OPTIMIZE_PNGS)
  required_program(PNGCRUSH "pngcrush" "Tool for optimizing PNG image files losslessly")
endif(OPTIMIZE_PNGS)

function(standalone_svg SVG_FILE_IN SVG_FILE_OUT)
  if(BUILD_ASSETS)
    make_path_absolute(SVG_FILE_IN) # absolute path needed for add_custom_command
    add_custom_command(
      OUTPUT "${SVG_FILE_OUT}"
      DEPENDS "${SVG_FILE_IN}" # absolute path required
      COMMAND xmllint "${SVG_FILE_IN}" --xinclude --pretty 1 --output "${SVG_FILE_OUT}"
      COMMAND inkscape "${SVG_FILE_OUT}" --verb=EditSelectAll --verb=EditUnlinkClone --verb=EditSelectAll --verb=org.ekips.filter.embedselectedimages --verb=FileSave --verb=FileQuit
      COMMAND inkscape -z "${SVG_FILE_OUT}" --export-text-to-path --vacuum-defs --export-plain-svg "${SVG_FILE_OUT}"
      VERBATIM
      )
  endif(BUILD_ASSETS)
endfunction(standalone_svg)

function(optimize_svg SVG_FILE_IN SVG_FILE_OUT)
  if(BUILD_ASSETS)
    if(OPTIMIZE_SVGS)
      make_path_absolute(SVG_FILE_IN) # absolute path needed for add_custom_command
      add_custom_command(
        OUTPUT "${SVG_FILE_OUT}"
        DEPENDS "${SVG_FILE_IN}" # absolute path required
        COMMAND svgo "${SVG_FILE_IN}" -o "${SVG_FILE_OUT}"
        VERBATIM
        )
    else(OPTIMIZE_SVGS)
      copy_during_build("${SVG_FILE_IN}" "${SVG_FILE_OUT}")
    endif(OPTIMIZE_SVGS)
  endif(BUILD_ASSETS)
endfunction(optimize_svg)

function(vectorize_svg SVG_FILE_IN SVG_FILE_OUT)
  if(BUILD_ASSETS)
    make_path_absolute(SVG_FILE_IN) # absolute path needed for add_custom_command
    add_custom_command(
      OUTPUT "${SVG_FILE_OUT}"
      DEPENDS "${SVG_FILE_IN}" # absolute path required
      COMMAND inkscape -z "${SVG_FILE_IN}" --export-text-to-path --vacuum-defs --export-plain-svg "${SVG_FILE_OUT}"
      VERBATIM
      )
  endif(BUILD_ASSETS)
endfunction(vectorize_svg)

function(rasterize_svg SVG_FILE_IN PNG_FILE_OUT)
  if(BUILD_ASSETS)
    # any additional arguments will be passed to inkscape (see ${ARGN})
    make_path_absolute(SVG_FILE_IN) # absolute path needed for add_custom_command
    add_custom_command(
      OUTPUT "${PNG_FILE_OUT}"
      DEPENDS "${SVG_FILE_IN}" # absolute path required
      COMMAND inkscape -z "${SVG_FILE_IN}" ${ARGN} --export-png "${PNG_FILE_OUT}"
      VERBATIM
      )
  endif(BUILD_ASSETS)
endfunction(rasterize_svg)

function(optimize_png PNG_FILE_IN PNG_FILE_OUT)
  if(BUILD_ASSETS)
    if(OPTIMIZE_PNGS)
      set(OPTS -rem allb)
      if (OPTIMIZE_PNGS_BRUTE)
        list(APPEND OPTS -brute)
      endif(OPTIMIZE_PNGS_BRUTE)
      make_path_absolute(PNG_FILE_IN) # absolute path needed for add_custom_command
      add_custom_command(
        OUTPUT "${PNG_FILE_OUT}"
        DEPENDS "${PNG_FILE_IN}" # absolute path required
        COMMAND pngcrush ${OPTS} "${PNG_FILE_IN}" "${PNG_FILE_OUT}"
        VERBATIM
        )
    else(OPTIMIZE_PNGS)
      copy_during_build("${PNG_FILE_IN}" "${PNG_FILE_OUT}")
    endif(OPTIMIZE_PNGS)
  endif(BUILD_ASSETS)
endfunction(optimize_png)

function(copy_during_build SOURCE_FILE DEST_FILE)
  if(BUILD_ASSETS)
    make_path_absolute(SOURCE_FILE) # absolute path needed for add_custom_command
    add_custom_command(
      OUTPUT "${DEST_FILE}"
      DEPENDS "${SOURCE_FILE}" # absolute path required
      COMMAND "${CMAKE_COMMAND}" -E copy_if_different "${SOURCE_FILE}" "${DEST_FILE}"
      VERBATIM
      )
  endif(BUILD_ASSETS)
endfunction(copy_during_build)