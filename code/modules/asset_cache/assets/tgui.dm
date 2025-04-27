/datum/asset/simple/tgui
	keep_local_name = TRUE
	assets = list(
		"tgui.bundle.js" = file("tgui/public/tgui.bundle.js"),
		"tgui.bundle.css" = file("tgui/public/tgui.bundle.css"),
	)

/datum/asset/simple/tgui_panel
	keep_local_name = TRUE
	assets = list(
		"tgui-panel.bundle.js" = file("tgui/public/tgui-panel.bundle.js"),
		"tgui-panel.bundle.css" = file("tgui/public/tgui-panel.bundle.css"),
	)

// Let TGUI use all of our custom fonts
/datum/asset/simple/tgui_extra_fonts
	keep_local_name = TRUE
	assets = list(
		"Grand9K_Pixel.ttf" = file("interface/fonts/Grand9K_Pixel.ttf"),
		"Pixellari.ttf" = file("interface/fonts/Pixellari.ttf"),
		"TinyUnicode.ttf" = file("interface/fonts/TinyUnicode.ttf"),
		"VCR_OSD_Mono.ttf" = file("interface/fonts/VCR_OSD_Mono.ttf"),
	)
