/// Produces a mutable appearance glued to the [EMISSIVE_PLANE] dyed to be the [EMISSIVE_COLOR].
/proc/emissive_appearance(icon, icon_state = "", layer = FLOAT_LAYER, alpha = 255, appearance_flags = NONE)
	var/mutable_appearance/appearance = mutable_appearance(icon, icon_state, layer, PLANE_EMISSIVE, alpha, appearance_flags)
	appearance.color = GLOB.emissive_color
	return appearance

/proc/em_block_image_generic(var/image/I)
	var/mutable_appearance/em_overlay = mutable_appearance(I.icon, I.icon_state, plane = PLANE_EMISSIVE, alpha = I.alpha, appearance_flags = KEEP_APART)
	em_overlay.color = GLOB.em_block_color
	return em_overlay
