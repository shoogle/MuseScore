function(rasterize_svg_sizes FILE_BASE)
  # any additional arguments are assumed to be integer sizes for exported PNGs
  foreach(SIZE ${ARGN})
    set(SVG_FILE_IN "${FILE_BASE}.svg")
    set(PNG_FILE_TMP "${FILE_BASE}-${SIZE}-raw.png")
    set(PNG_FILE_OUT "${FILE_BASE}-${SIZE}.png")
    rasterize_svg("${SVG_FILE_IN}" "${PNG_FILE_TMP}" "--export-width=${SIZE}" "--export-height=${SIZE}")
    optimize_png("${PNG_FILE_TMP}" "${PNG_FILE_OUT}")
    list(APPEND GENERATED_FILES "${PNG_FILE_OUT}")
  endforeach(SIZE)
  set(GENERATED_FILES "${GENERATED_FILES}" PARENT_SCOPE)
endfunction(rasterize_svg_sizes)

function(min_index # find the smallest value in a list of numbers
  MINV # minimum value returned in this variable
  IDXV # index of its first occurance returned in this variable
  # ARGN remaining arguments are items in the list
  )
  set(MIN_IDX 0) # assume first item in list is the smallest
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
    min_index(MIN IDX ${LIST})
    list(REMOVE_AT LIST ${IDX})
    sort_integer_list(LIST)
    set(${LISTV} ${MIN} ${LIST} PARENT_SCOPE)
  endif(LEN GREATER 1)
endfunction(sort_integer_list)