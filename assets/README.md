# Musescore Assets

This is where all assets are stored as SVGs

## Structure

- Icons: App icons
- Files: Document icons
- Splash: Boot splash screens
- Glyphs: UI Glyphs (Longer Term Goal)
- Resources: Assets that are only embedded in other assets


## Workflow

1. Start with a Master SVG, which contains:
    - Any text in the file stored as editable text, with attributes to describe how it should be rendered
    - Font, font size, font style (bold/italics), colour, etc.
    - Any images included in the file stored as "xlinks" to external files
2. Produce a standalone SVG, which contains:
    - Any text converted to paths to ensure correctness regardless of whether the user has the right font installed
    - Any raster images embedded into the SVG in base64 to make the file more portable since there is only one file to move around
    - For full instructions see [here](#Exporting-SVGs-From-Master-SVG)
3. The required raster images (PNG, ICO, ICNS) are generated on build

## Exporting SVGs From Master SVG

### Embed images in the standalone SVGs

This ensures that the text looks the same regardless of whether the file was moved from the original path.

Inside of Inkscape you can embed the images by right-clicking on each of them and selecting "Embed image", or do them all at once by going to the Extensions menu > Images > Embed Images.

Remember to only do this only for standalone SVGs; master SVG should contain linked images rather than embedded images.

**NOTE: You DON'T need to do this for the splash images** because the SVGs are only used to generate PNGs; we aren't going to distribute the splash images as SVGs.

### Convert text to paths in the standalone SVGs

This ensures that the text looks the same on everyone's computer regardless of whether they have the font installed. It must be done for all standalone SVGs, including SVGs that we will generate PNGs from, even if we will not be distributing the SVG itself.

Inside of Inkscape, select the text and go to Path menu > Object to Path.

Don't do this for the master SVGs as we will want to be able to edit the text later.

**NOTE: You DO need to do this for the splash images.**

## SVG Formating

### Why

- SVGs should be saved as 'plain'
- Plain SVGs allow for easy differentiation along with smaller file sizes
- It also helps maintain editor independence
- To save as a plain SVG inside of Inskscape, Go to File -> Save As -> choose "Plain SVG"

### Converting Existing SVGs to Plain

To convert an existing SVG to plain you can use [SVGO](https://github.com/svg/svgo)

Easy Ways To Use SVGO:
- [VSCode Extension](https://github.com/lishu/vscode-svg)
- [Web Tool](https://jakearchibald.github.io/svgomg/)
