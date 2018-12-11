set(SOURCE_FILES
  mscore-logo.svg
  )

assert_alphabetical(SOURCE_FILES) # keep list ordered for easier maintenance

set(GENERATED_FILES "") # create empty list

foreach(FILENAME ${SOURCE_FILES})
  get_filename_component(FILENAME ${FILENAME} NAME_WE) # strip file extension
  standalone_svg("${CMAKE_CURRENT_SOURCE_DIR}/${FILENAME}.svg" "${FILENAME}-standalone.svg")
  optimize_svg("${FILENAME}-standalone.svg" "${FILENAME}.svg")
  list(APPEND GENERATED_FILES "${FILENAME}.svg")
endforeach(FILENAME)

add_custom_target("assets_brand" DEPENDS ${GENERATED_FILES})
add_dependencies("assets" "assets_brand")
add_to_manifest(${GENERATED_FILES})
