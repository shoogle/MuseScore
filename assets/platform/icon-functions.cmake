function(rasterize_svg_sizes # convert an SVG to PNGs at at various sizes
  FILE_BASE # path to input SVG file minus the file extension
  # ARGN remaining arguments are integer sizes of exported PNGs
  )
  foreach(SIZE ${ARGN})
    set(SVG_FILE_IN "${FILE_BASE}.svg")
    set(PNG_UNOPTIMIZED "${FILE_BASE}-${SIZE}-big.png")
    set(PNG_FILE_OUT "${FILE_BASE}-${SIZE}.png")
    rasterize_svg("${SVG_FILE_IN}" "${PNG_UNOPTIMIZED}" "--export-width=${SIZE}" "--export-height=${SIZE}")
    optimize_png("${PNG_UNOPTIMIZED}" "${PNG_FILE_OUT}")
    list(APPEND GENERATED_FILES "${PNG_FILE_OUT}")
  endforeach(SIZE)
  set(GENERATED_FILES "${GENERATED_FILES}" PARENT_SCOPE)
endfunction(rasterize_svg_sizes)

function(create_icon_ico_sizes # create a Windows ICO icon file from PNGs
  FILE_BASE # name of input PNGs minus size and file extension
  # ARGN remaining arguments are integer sizes for input PNGs
  )
  if(BUILD_WINDOWS_ICONS)
    set(PNG_INPUT_FILES "") # empty list ("unset" exposes cached values)
    foreach(SIZE ${ARGN})
      list(APPEND PNG_INPUT_FILES "${FILE_BASE}-${SIZE}.png")
    endforeach(SIZE)
    create_icon_ico("${FILE_BASE}.ico" ${PNG_INPUT_FILES})
    list(APPEND GENERATED_FILES "${FILE_BASE}.ico")
    set(GENERATED_FILES "${GENERATED_FILES}" PARENT_SCOPE)
  endif(BUILD_WINDOWS_ICONS)
endfunction(create_icon_ico_sizes)

function(create_icon_icns_sizes # create a macOS ICNS icon file from PNGs
  FILE_BASE # name of input PNGs minus size and file extension
  # ARGN remaining arguments are integer sizes for input PNGs
  )
  if(BUILD_MACOS_ICONS)
    set(PNG_INPUT_FILES "") # empty list ("unset" exposes cached values)
    foreach(SIZE ${ARGN})
      list(APPEND PNG_INPUT_FILES "${FILE_BASE}-${SIZE}.png")
    endforeach(SIZE)
    create_icon_icns("${FILE_BASE}.icns" ${PNG_INPUT_FILES})
    list(APPEND GENERATED_FILES "${FILE_BASE}.icns")
    set(GENERATED_FILES "${GENERATED_FILES}" PARENT_SCOPE)
  endif(BUILD_MACOS_ICONS)
endfunction(create_icon_icns_sizes)

function(min_index # find the smallest value in a list of numbers
  MINV # minimum value returned in this variable
  IDXV # index of its first occurance returned in this variable
  # ARGN remaining arguments are items in the list
  )
  set(MIN_IDX 0) # start by assuming first item in list is the smallest
  list(GET ARGN ${MIN_IDX} MIN_VAL) # store its value for comparison
  set(IDX 0) # keep track of where we are in the list
  foreach(VAL ${ARGN})
    if(VAL LESS MIN_VAL)
      set(MIN_VAL ${VAL})
      set(MIN_IDX ${IDX})
    endif(VAL LESS MIN_VAL)
    math(EXPR IDX "${IDX}+1") # increment IDX
  endforeach(VAL)
  set("${MINV}" "${MIN_VAL}" PARENT_SCOPE)
  set("${IDXV}" "${MIN_IDX}" PARENT_SCOPE)
endfunction(min_index)

function(sort_integer_list # sort list into ascending order
  LISTV # list variable to be sorted
  )
  set(LIST "${${LISTV}}")
  list(LENGTH LIST LEN)
  if(LEN GREATER 1)
    min_index(MIN IDX ${LIST}) # find smallest value
    list(REMOVE_AT LIST ${IDX}) # remove smallest value
    sort_integer_list(LIST) # sort the list that remains (recursion)
    set(${LISTV} ${MIN} ${LIST} PARENT_SCOPE)
  endif(LEN GREATER 1)
endfunction(sort_integer_list)
