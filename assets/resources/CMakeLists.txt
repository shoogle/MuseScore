# Only copy resources into build directory that are linked to from other SVGs.
# Usually this is only raster images, as vector images would be embedded.
file(COPY splash-background.jpg DESTINATION .)
