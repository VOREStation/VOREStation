Get the woff2 and all.min.css from: https://cdnjs.com/libraries/font-awesome

Due to the fact browse_rsc can't create subdirectories, every time you update font-awesome you'll need to ensure the relative webfont references in all.min.css
are correct eg ../webfonts/fa-regular-400.woff2 => fa-regular-400.woff2 (or whatever you call it in asset datum)

Finally, removing brand, v4 compat related css and `-moz-osx-font-smoothing:grayscale;`. You can do this by formatting the css, removing them manually (or some regex?) and then minifying it.
