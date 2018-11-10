set(TARGET "${TARGET}_icons")
add_custom_target("${TARGET}")

set(WINDOWS_ICO_SIZES 16 24 32 48 64 256) # https://docs.microsoft.com/en-gb/windows/desktop/uxguide/vis-icons
set(MACOS_ICNS_SIZES 16 32 48 128 256 512 1024) # https://en.wikipedia.org/wiki/Apple_Icon_Image_format
set(FREEDESKTOP_COMMON_SIZES 16 22 24 32 48 128 256 512)

set(ALL_ICON_SIZES ${WINDOWS_ICO_SIZES} ${MACOS_ICNS_SIZES} ${FREEDESKTOP_COMMON_SIZES})

list(REMOVE_DUPLICATES ALL_ICON_SIZES)

include("icon-functions.cmake")

add_directory_target(app)
add_directory_target(file)

propagate_assets_list()