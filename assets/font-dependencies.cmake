set(BUILT_IN_MSG "This tool should be built-in. Check your PATH environment variable.")
if(WIN32)
  required_program(REG "Query Windows Registry - ${BUILT_IN_MSG}" "reg")
  required_program(FINDSTR "Search for matching strings - ${BUILT_IN_MSG}" "findstr")
elseif(APPLE)

elseif(UNIX)
  required_program(FC_LIST "List available fonts - ${BUILT_IN_MSG}" "fc-list")
  required_program(GREP "Search for matching strings - ${BUILT_IN_MSG}" "grep")
endif(WIN32)

function(required_font # ensure that a font dependency is installed
  FONT_NAME # the name of the font (e.g. "Roboto")
  DESCRIPTION # build fails with this error message if font is missing
  )
  if(WIN32)
    execute_process(
      COMMAND "${REG}" query "HKLM\\SOFTWARE\\Microsoft\\Windows NT\\CurrentVersion\\Fonts"
      COMMAND "${FINDSTR}" /r "/c:^ *${FONT_NAME} (OpenType)" "/c:^ *${FONT_NAME} (TrueType)"
      RESULT_VARIABLE RET_VAL
      )
  elseif(APPLE)
    set(RET_VAL "1")
  elseif(UNIX) # Linux and friends
    execute_process(
      COMMAND "${FC_LIST}"
      COMMAND "${GREP}" -E "^[^:]+\\.(ttf|otf): ${FONT_NAME}:style="
      RESULT_VARIABLE RET_VAL
      )
  endif(WIN32)
  if(NOT RET_VAL STREQUAL "0") # string compare as RET_VAL not always number
    message(FATAL_ERROR "Font not found: ${FONT_NAME} - ${DESCRIPTION}")
  endif(NOT RET_VAL STREQUAL "0")
endfunction(required_font)

# Keep this list up-to-date. Run "grep -r font-family ." from the assets
# source directory to list fonts used in SVGs anywhere in the project.
required_font("Roboto" "https://fonts.google.com/specimen/Roboto")
required_font("Raleway" "https://fonts.google.com/specimen/Raleway")
