# Musescore Assets
This is where all  assets are stored as SVGs that are converted to pngs on build.

### Generating an Icon
1. Start with a Master SVG, which contains:
    - any text in the file stored as editable text, with attributes to describe how it should be rendered
    - font, font size, font style (bold/italics), colour, etc.
    - any raster images in the file stored as "xlinks" to external files
    - this saves room compared to embedding the image file in the SVG, and means that the image can be edited externally
2. Produce a standalone/optimised SVG, which contains:
    - any text converted to paths (i.e. the shape of the outline and a colour)
    - this ensures the text looks correct regardless of whether the user has the right font installed, but it also means that the text is no longer editable
    - any raster images embedded into the SVG in base64
    - this makes the icon more portable since there is only one file to move around
3. Raster images (PNG, ICO, ICNS) at required sizes are generated on build
