# list of resource files that are linked to from other SVGs (alphabetical)
set(RESOURCES
  cymbals.svg
  folded-page.svg
  mscore.svg
  musicxml-logo.svg
  splash-background.jpg
  )

assert_alphabetical(RESOURCES) # easier to maintain if we keep lists ordered

# copy into build directory so that links can be resolved at build time
foreach(FILE ${RESOURCES})
  file(COPY "${FILE}" DESTINATION .)
endforeach(FILE)
