# Overlay contribution

This is a short guide and ruleset for contributing new overlays.

## Table of contents

- [Rules](#rules)
- [Assets](#assets)
- [Code](#code)
- [Example](#example)
- [Notes](#notes)

## Rules

To contribute new overlays, you need to be either the artist or the owner of the images, with written permission from the artist in the latter case.
The artist must explicitly allow the usage of those assets under a **CC BY-SA 3.0** or **CC BY-NC-SA 3.0** license.

> **No derivatives (ND) licenses are not accepted.**

This policy applies to all VBO assets added from **February 2026 onward**.

## Assets

For assets to be included, the following will be required:

| Requirement      | Notes                                                                            |
| ---------------- | -------------------------------------------------------------------------------- |
| Overlay images   | PNG format                                                                       |
| Resolution       | 480x480 and 120x120                                                              |
| Layers           | The image can consist of up to 4 layers; each layer needs to be its own PNG file |
| License          | Must be **CC BY-SA 3.0** or **CC BY-NC-SA 3.0**                                  |
| Artist credit    | Required                                                                         |
| Permission proof | Required if not the artist                                                       |

## Code

For assets to be loaded into the game, the following steps need to be followed:

- The 480x480 resolution PNG files need to be moved into their own DMI file, with a file name `VBO_xxxxxxx.dmi`.
  Each layer needs to be named the same as the file; for layers 2–4, the layer number is added after a dash (`-n`).

- The 120x120 resolution PNG files need to be moved into the corresponding lists:
  `screen_full_vore_list_base.dmi`,
  `screen_full_vore_list_layer1.dmi`,
  `screen_full_vore_list_layer2.dmi`,
  `screen_full_vore_list_layer3.dmi`.
  Across all files, the name needs to match the `VBO_xxxxxxx` name exactly.

- Inside the `code/modules/asset_cache/assets/belly_assets.dm` file, a new asset datum needs to be created.
  The name must match the `vbo_xxxxxxx` name exactly, but entirely lowercase.

## Example

The following is a quick example demonstration for `VBO_maw13`:

- The asset itself consists of four layers, all contained within the main 480x480 asset file:
  `icons/mob/vore_fullscreens/VBO_maw13.dmi`

- Inside the four lists, each layer from the 120x120 file is stored under the `VBO_maw13` name:
  `screen_full_vore_list_base.dmi`,
  `screen_full_vore_list_layer1.dmi`,
  `screen_full_vore_list_layer2.dmi`,
  `screen_full_vore_list_layer3.dmi`.

- The asset datum used to load the file into the game, located in
  `code/modules/asset_cache/assets/belly_assets.dm`, looks like this:

```text
/datum/belly_overlays/vbo_maw13
	belly_icon = 'icons/mob/vore_fullscreens/VBO_maw13.dmi'
```

## Notes

Violations of licensing will result in a repo ban.
