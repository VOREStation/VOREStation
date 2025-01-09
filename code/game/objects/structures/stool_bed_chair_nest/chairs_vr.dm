/obj/structure/bed/chair/modern_chair
	name = "modern chair"
	desc = "It's like sitting in an egg."
	icon_state = "modern_chair"
	color = null
	base_icon = "modern_chair"
	applies_material_colour = 0

/obj/structure/bed/chair/modern_chair/Initialize(var/newloc, var/new_material, var/new_padding_material)
	. = ..()
	var/image/I = image(icon, "[base_icon]_over")
	I.layer = ABOVE_MOB_LAYER
	I.plane = MOB_PLANE
	add_overlay(I)

/obj/structure/bed/chair/bar_stool
	name = "bar stool"
	desc = "How vibrant!"
	icon_state = "modern_stool"
	color = null
	base_icon = "modern_stool"
	applies_material_colour = 0

/obj/structure/bed/chair/backed_grey
	name = "grey chair"
	desc = "Also available in red."
	icon_state = "onestar_chair_grey"
	color = null
	base_icon = "onestar_chair_grey"
	applies_material_colour = 0

/obj/structure/bed/chair/backed_red
	name = "red chair"
	desc = "Also available in grey."
	icon_state = "onestar_chair_red"
	color = null
	base_icon = "onestar_chair_red"
	applies_material_colour = 0

// Baystation12 chairs with their larger update_icons proc
/obj/structure/bed/chair/bay/update_icon()
	// Strings.
	desc = initial(desc)
	if(padding_material)
		name = "[padding_material.display_name] [initial(name)]" //this is not perfect but it will do for now.
		desc += " It's made of [material.use_name] and covered with [padding_material.use_name]."
	else
		name = "[material.display_name] [initial(name)]"
		desc += " It's made of [material.use_name]."

	// Prep icon.
	icon_state = ""
	cut_overlays()

	// Base icon (base material color)
	var/cache_key = "[base_icon]-[material.name]"
	if(isnull(GLOB.stool_cache[cache_key]))
		var/image/I = image(icon, base_icon)
		if(applies_material_colour)
			I.color = material.icon_colour
		GLOB.stool_cache[cache_key] = I
	add_overlay(GLOB.stool_cache[cache_key])

	// Padding ('_padding') (padding material color)
	if(padding_material)
		var/padding_cache_key = "[base_icon]-padding-[padding_material.name]"
		if(isnull(GLOB.stool_cache[padding_cache_key]))
			var/image/I =  image(icon, "[base_icon]_padding")
			I.color = padding_material.icon_colour
			GLOB.stool_cache[padding_cache_key] = I
		add_overlay(GLOB.stool_cache[padding_cache_key])

	// Over ('_over') (base material color)
	cache_key = "[base_icon]-[material.name]-over"
	if(isnull(GLOB.stool_cache[cache_key]))
		var/image/I = image(icon, "[base_icon]_over")
		I.plane = MOB_PLANE
		I.layer = ABOVE_MOB_LAYER
		if(applies_material_colour)
			I.color = material.icon_colour
		GLOB.stool_cache[cache_key] = I
	add_overlay(GLOB.stool_cache[cache_key])

	// Padding Over ('_padding_over') (padding material color)
	if(padding_material)
		var/padding_cache_key = "[base_icon]-padding-[padding_material.name]-over"
		if(isnull(GLOB.stool_cache[padding_cache_key]))
			var/image/I =  image(icon, "[base_icon]_padding_over")
			I.color = padding_material.icon_colour
			I.plane = MOB_PLANE
			I.layer = ABOVE_MOB_LAYER
			GLOB.stool_cache[padding_cache_key] = I
		add_overlay(GLOB.stool_cache[padding_cache_key])

	if(has_buckled_mobs())
		if(padding_material)
			cache_key = "[base_icon]-armrest-[padding_material.name]"
		// Armrest ('_armrest') (base material color)
		if(isnull(GLOB.stool_cache[cache_key]))
			var/image/I = image(icon, "[base_icon]_armrest")
			I.plane = MOB_PLANE
			I.layer = ABOVE_MOB_LAYER
			if(applies_material_colour)
				I.color = material.icon_colour
			GLOB.stool_cache[cache_key] = I
		add_overlay(GLOB.stool_cache[cache_key])
		if(padding_material)
			cache_key = "[base_icon]-padding-armrest-[padding_material.name]"
			// Padding Armrest ('_padding_armrest') (padding material color)
			if(isnull(GLOB.stool_cache[cache_key]))
				var/image/I = image(icon, "[base_icon]_padding_armrest")
				I.plane = MOB_PLANE
				I.layer = ABOVE_MOB_LAYER
				I.color = padding_material.icon_colour
				GLOB.stool_cache[cache_key] = I
			add_overlay(GLOB.stool_cache[cache_key])

/obj/structure/bed/chair/bay/chair
	name = "mounted chair"
	desc = "Like a normal chair, but more stationary."
	icon_state = "bay_chair_preview"
	base_icon = "bay_chair"
	buckle_movable = 1

/obj/structure/bed/chair/bay/chair/padded/red/Initialize(var/newloc, var/new_material, var/new_padding_material)
	. = ..(newloc, new_material, MAT_CARPET)

/obj/structure/bed/chair/bay/chair/padded/brown/Initialize(var/newloc, var/new_material, var/new_padding_material)
	. = ..(newloc, new_material, MAT_LEATHER)

/obj/structure/bed/chair/bay/chair/padded/teal/Initialize(var/newloc, var/new_material, var/new_padding_material)
	. = ..(newloc, new_material, MAT_CLOTH_TEAL)

/obj/structure/bed/chair/bay/chair/padded/black/Initialize(var/newloc, var/new_material, var/new_padding_material)
	. = ..(newloc, new_material, MAT_CLOTH_BLACK)

/obj/structure/bed/chair/bay/chair/padded/green/Initialize(var/newloc, var/new_material, var/new_padding_material)
	. = ..(newloc, new_material, MAT_CLOTH_GREEN)

/obj/structure/bed/chair/bay/chair/padded/purple/Initialize(var/newloc, var/new_material, var/new_padding_material)
	. = ..(newloc, new_material, MAT_CLOTH_PURPLE)

/obj/structure/bed/chair/bay/chair/padded/blue/Initialize(var/newloc, var/new_material, var/new_padding_material)
	. = ..(newloc, new_material, MAT_CLOTH_BLUE)

/obj/structure/bed/chair/bay/chair/padded/beige/Initialize(var/newloc, var/new_material, var/new_padding_material)
	. = ..(newloc, new_material, MAT_CLOTH_BEIGE)

/obj/structure/bed/chair/bay/chair/padded/lime/Initialize(var/newloc, var/new_material, var/new_padding_material)
	. = ..(newloc, new_material, MAT_CLOTH_LIME)

/obj/structure/bed/chair/bay/chair/padded/yellow/Initialize(var/newloc, var/new_material, var/new_padding_material)
	. = ..(newloc, new_material, MAT_CLOTH_YELLOW)

/obj/structure/bed/chair/bay/comfy
	name = "comfy mounted chair"
	desc = "Like a normal chair, but more stationary, and with more padding."
	icon_state = "bay_comfychair_preview"
	base_icon = "bay_comfychair"

/obj/structure/bed/chair/bay/comfy/red/Initialize(var/newloc, var/new_material, var/new_padding_material)
	. = ..(newloc, new_material, MAT_CARPET)

/obj/structure/bed/chair/bay/comfy/brown/Initialize(var/newloc, var/new_material, var/new_padding_material)
	. = ..(newloc, new_material, MAT_LEATHER)

/obj/structure/bed/chair/bay/comfy/teal/Initialize(var/newloc, var/new_material, var/new_padding_material)
	. = ..(newloc, new_material, MAT_CLOTH_TEAL)

/obj/structure/bed/chair/bay/comfy/black/Initialize(var/newloc, var/new_material, var/new_padding_material)
	. = ..(newloc, new_material, MAT_CLOTH_BLACK)

/obj/structure/bed/chair/bay/comfy/green/Initialize(var/newloc, var/new_material, var/new_padding_material)
	. = ..(newloc, new_material, MAT_CLOTH_GREEN)

/obj/structure/bed/chair/bay/comfy/purple/Initialize(var/newloc, var/new_material, var/new_padding_material)
	. = ..(newloc, new_material, MAT_CLOTH_PURPLE)

/obj/structure/bed/chair/bay/comfy/blue/Initialize(var/newloc, var/new_material, var/new_padding_material)
	. = ..(newloc, new_material, MAT_CLOTH_BLUE)

/obj/structure/bed/chair/bay/comfy/beige/Initialize(var/newloc, var/new_material, var/new_padding_material)
	. = ..(newloc, new_material, MAT_CLOTH_BEIGE)

/obj/structure/bed/chair/bay/comfy/lime/Initialize(var/newloc, var/new_material, var/new_padding_material)
	. = ..(newloc, new_material, MAT_CLOTH_LIME)

/obj/structure/bed/chair/bay/comfy/yellow/Initialize(var/newloc, var/new_material, var/new_padding_material)
	. = ..(newloc, new_material, MAT_CLOTH_YELLOW)

/obj/structure/bed/chair/bay/comfy/captain
	name = "captain chair"
	desc = "It's a chair. Only for the highest ranked asses."
	icon_state = "capchair_preview"
	base_icon = "capchair"

/obj/structure/bed/chair/bay/comfy/captain/update_icon()
	..()
	var/image/I = image(icon, "[base_icon]_special")
	I.plane = MOB_PLANE
	I.layer = ABOVE_MOB_LAYER
	add_overlay(I)

/obj/structure/bed/chair/bay/comfy/captain/Initialize(var/newloc, var/new_material, var/new_padding_material)
	. = ..(newloc, MAT_STEEL, MAT_CLOTH_BLUE)

/obj/structure/bed/chair/bay/shuttle
	name = "shuttle seat"
	desc = "A comfortable, secure seat. It has a sturdy-looking buckling system for smoother flights."
	base_icon = "shuttle_chair"
	icon_state = "shuttle_chair_preview"
	buckle_movable = 0
	var/buckling_sound = 'sound/effects/metal_close.ogg'
	var/padding = MAT_CLOTH_BLUE

/obj/structure/bed/chair/bay/shuttle/Initialize(var/newloc, var/new_material, var/new_padding_material)
	. = ..(newloc, MAT_STEEL, padding)

/obj/structure/bed/chair/bay/shuttle/post_buckle_mob()
	playsound(src,buckling_sound,75,1)
	if(has_buckled_mobs())
		base_icon = "shuttle_chair-b"
	else
		base_icon = "shuttle_chair"
	..()

/obj/structure/bed/chair/bay/shuttle/update_icon()
	..()
	if(!has_buckled_mobs())
		var/image/I = image(icon, "[base_icon]_special")
		I.plane = MOB_PLANE
		I.layer = ABOVE_MOB_LAYER
		if(applies_material_colour)
			I.color = material.icon_colour
		add_overlay(I)

/obj/structure/bed/chair/bay/chair/padded/red/smallnest
	name = "teshari nest"
	desc = "Smells like cleaning products."
	icon_state = "nest_chair"
	base_icon = "nest_chair"

/obj/structure/bed/chair/bay/chair/padded/red/bignest
	name = "large teshari nest"
	icon_state = "nest_chair_large"
	base_icon = "nest_chair_large"
