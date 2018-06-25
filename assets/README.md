# Musescore Assets

This is where all  assets are stored as SVGs that are converted to pngs on build.

## Workflow

1. Start with a Master SVG, which contains:
    - Any text in the file stored as editable text, with attributes to describe how it should be rendered
    - Font, font size, font style (bold/italics), colour, etc.
    - Any images included in the file stored as "xlinks" to external files
2. Produce a standalone/optimised SVG, which contains:
    - Any text converted to paths to ensure correctness regardless of whether the user has the right font installed
    - Any raster images embedded into the SVG in base64 to make the file more portable since there is only one file to move around
    - For full instructions see [here](#Export-SVGs-From-Master-SVG)
3. The required raster images (PNG, ICO, ICNS) are generated on build

## Export SVGs From Master SVG

### Embed images in the standalone SVGs

You can embed the images by right-clicking on each of them and selecting "Embed image", or do them all at once by going to the Extensions menu > Images > Embed Images.

Remember to only do this only for standalone SVGs; master SVG should contain linked images rather than embedded images.

In the case of the splash images, we do not need images to be embedded (linked is fine) because we are only going to use the SVGs to generate PNGs; we aren't going to distribute the splash images as SVGs.

**NOTE: You DON'T need to do this for the splash images.**

### Convert text to paths in the standalone SVGs

Select the text and go to Path menu > Object to Path.

This ensures that the text looks the same on everyone's computer regardless of whether they have the font installed. It must be done for all standalone SVGs, including SVGs that we will generate PNGs from, even if we will not be distributing the SVG itself.

Obviously don't do this for the master SVGs as we will want to be able to edit the text later.

**NOTE: You DO need to do this for the splash images.**

### Saving SVGs in Inkscape

- Convert text to paths
- Embed sub-images, or leave them as linked if appropriate
- Go to File -> Save As -> choose "Plain SVG" or "Optimised SVG"
- Use Plain SVG for the splash images since we will only be generating PNGs from them
- Use [Optimised SVG](#Optimised-SVGs-in-Inkscape) for the other icons since we will be distributing the SVGs

Experiment with the options for Optimised SVGs to find the values that produce the smallest file, while still maintaining acceptable levels of quality and cross-platform compatibility, or see below for my recommended settings.

### Optimised SVGs in Inkscape

- Options:
  - No. significant digits for coordinates: 5
  - Shorten colour values: Yes
  - Convert CSS attributes to XML attributes: Yes
  - Collapse groups: Yes
  - Create groups for similar attributes: Yes
  - Keep editor data: No
  - Keep unreferenced definitions: No
  - Work around renderer bugs: Yes
- SVG Output
  - Document Options
    - Remove XML declaration: Yes
    - Remove metadata: Yes
    - Remove comments: Yes
    - Embed raster images: Yes (unless there's a good reason not to)
    - Enable viewboxing: Yes
  - Pretty Printing
    - Format output with line-breaks and indentation: No (but if enabled use spaces of depth 1)
    - Strip the "xml:space" attribute: Yes
- IDs
  - Remove unused IDs: Yes
  - Shorten IDs: Yes
  - Prefix shortened IDs with: `<blank>`
  - Preserve manually created IDs: No
  - Preserve the following IDs: `<blank>`
  - Preserve the IDs starting with: `<blank>`

### Plain SVGs

To convert a SVG to plain you can use [SVGO](https://github.com/svg/svgo)

Easy Ways To Use SVGO:
- [VSCode Extension](https://github.com/lishu/vscode-svg)
- [Web Tool](https://jakearchibald.github.io/svgomg/)
