// WARNING - UNUSED PROC
/mob/living/carbon/human/proc/get_wing_icon()
	if(QDESTROYING(src))
		return

	var/icon_key = "[species.get_race_key(src)][r_skin][g_skin][b_skin][r_hair][g_hair][b_hair]"
	var/icon/wing_icon = wing_icon_cache[icon_key]
	if(!wing_icon)
		//generate a new one
		var/species_wing_anim = species.get_wing_animation(src)
		if(species.icobase_wing) species_wing_anim = species.icobase
		if(!species_wing_anim) species_wing_anim = 'icons/effects/species.dmi'
		wing_icon = new/icon(species_wing_anim)
		if(species.color_mult)
			wing_icon.Blend(rgb(r_skin, g_skin, b_skin), ICON_MULTIPLY)
		else
			wing_icon.Blend(rgb(r_skin, g_skin, b_skin), ICON_ADD)
		// The following will not work with animated wings.
		var/use_species_wing = species.get_wing_hair(src)
		if(use_species_wing)
			var/icon/hair_icon = icon('icons/effects/species.dmi', "[species.get_wing(src)]_[use_species_wing]")
			hair_icon.Blend(rgb(r_hair, g_hair, b_hair), ICON_ADD)
			wing_icon.Blend(hair_icon, ICON_OVERLAY)
		wing_icon_cache[icon_key] = wing_icon

	return wing_icon

// WARNING - UNUSED PROC
/mob/living/carbon/human/proc/set_wing_state(var/t_state)
	if(QDESTROYING(src))
		return

	var/image/wing_overlay = overlays_standing[WING_LAYER]

	if(wing_overlay && species.get_wing_animation(src))
		wing_overlay.icon_state = t_state
		return wing_overlay
	return null

// WARNING - UNUSED PROC
/mob/living/carbon/human/proc/animate_wing_reset(var/update_icons=1)
	if(stat != DEAD)
		set_wing_state("[species.get_wing(src)]_idle[rand(0,9)]")
	else
		set_wing_state("[species.get_wing(src)]_static")
		toggle_wing_vr(FALSE)

/mob/living/carbon/human/proc/get_wing_image()
	if(QDESTROYING(src))
		return

	//If you are FBP with wing style and didn't set a custom one
	if(synthetic && synthetic.includes_wing && !wing_style)
		var/icon/wing_s = new/icon("icon" = synthetic.icon, "icon_state" = "wing") //I dunno. If synths have some custom wing?
		wing_s.Blend(rgb(src.r_skin, src.g_skin, src.b_skin), species.color_mult ? ICON_MULTIPLY : ICON_ADD)
		return image(wing_s)

	//If you have custom wings selected
	if(wing_style && !(wear_suit && wear_suit.flags_inv & HIDETAIL))
		var/icon/wing_s = new/icon("icon" = wing_style.icon, "icon_state" = flapping && wing_style.ani_state ? wing_style.ani_state : wing_style.icon_state)
		if(wing_style.do_colouration)
			wing_s.Blend(rgb(src.r_wing, src.g_wing, src.b_wing), wing_style.color_blend_mode)
		return image(wing_s)

// TODO - Move this to where it should go ~Leshana
/mob/proc/stop_flying()
	if(QDESTROYING(src))
		return
	flying = FALSE
	return 1

/mob/living/carbon/human/stop_flying()
	if((. = ..()))
		update_wing_showing()
