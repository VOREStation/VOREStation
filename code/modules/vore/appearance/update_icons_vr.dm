var/global/list/wing_icon_cache = list()

/mob/living/carbon/human/proc/get_ears_overlay()
	if(ear_style && !(head && (head.flags_inv & BLOCKHEADHAIR)))
		var/icon/ears_s = new/icon("icon" = ear_style.icon, "icon_state" = ear_style.icon_state)
		if(ear_style.do_colouration)
			ears_s.Blend(rgb(src.r_ears, src.g_ears, src.b_ears), ear_style.color_blend_mode)

		if(ear_style.extra_overlay)
			var/icon/overlay = new/icon("icon" = ear_style.icon, "icon_state" = ear_style.extra_overlay)
			overlay.Blend(rgb(src.r_ears2, src.g_ears2, src.b_ears2), ear_style.color_blend_mode)
			ears_s.Blend(overlay, ICON_OVERLAY)
			qdel(overlay)

		if(ear_style.extra_overlay2) //MORE COLOURS IS BETTERER
			var/icon/overlay = new/icon("icon" = ear_style.icon, "icon_state" = ear_style.extra_overlay2)
			overlay.Blend(rgb(src.r_ears3, src.g_ears3, src.b_ears3), ear_style.color_blend_mode)
			ears_s.Blend(overlay, ICON_OVERLAY)
			qdel(overlay)
		return ears_s
	return null

/mob/living/carbon/human/proc/get_hair_accessory_overlay()
	if(hair_accessory_style && !(head && (head.flags_inv & BLOCKHEADHAIR)))
		var/icon/hair_acc_s = icon(hair_accessory_style.icon, hair_accessory_style.icon_state)
		if(hair_accessory_style.do_colouration)
			hair_acc_s.Blend(rgb(src.r_ears, src.g_ears, src.b_ears), hair_accessory_style.color_blend_mode)

		return hair_acc_s
	return null


/mob/living/carbon/human/proc/get_tail_image()
	//If you are FBP with tail style and didn't set a custom one
	var/datum/robolimb/model = isSynthetic()
	if(istype(model) && model.includes_tail && !tail_style)
		var/icon/tail_s = new/icon("icon" = synthetic.icon, "icon_state" = "tail")
		tail_s.Blend(rgb(src.r_skin, src.g_skin, src.b_skin), species.color_mult ? ICON_MULTIPLY : ICON_ADD)
		return image(tail_s)

	//If you have a custom tail selected
	if(tail_style && !(wear_suit && wear_suit.flags_inv & HIDETAIL && !isTaurTail(tail_style)))
		var/icon/tail_s = new/icon("icon" = tail_style.icon, "icon_state" = wagging && tail_style.ani_state ? tail_style.ani_state : tail_style.icon_state)
		if(tail_style.do_colouration)
			tail_s.Blend(rgb(src.r_tail, src.g_tail, src.b_tail), tail_style.color_blend_mode)
		if(tail_style.extra_overlay)
			var/icon/overlay = new/icon("icon" = tail_style.icon, "icon_state" = tail_style.extra_overlay)
			if(wagging && tail_style.ani_state)
				overlay = new/icon("icon" = tail_style.icon, "icon_state" = tail_style.extra_overlay_w)
				overlay.Blend(rgb(src.r_tail2, src.g_tail2, src.b_tail2), tail_style.color_blend_mode)
				tail_s.Blend(overlay, ICON_OVERLAY)
				qdel(overlay)
			else
				overlay.Blend(rgb(src.r_tail2, src.g_tail2, src.b_tail2), tail_style.color_blend_mode)
				tail_s.Blend(overlay, ICON_OVERLAY)
				qdel(overlay)

		if(tail_style.extra_overlay2)
			var/icon/overlay = new/icon("icon" = tail_style.icon, "icon_state" = tail_style.extra_overlay2)
			if(wagging && tail_style.ani_state)
				overlay = new/icon("icon" = tail_style.icon, "icon_state" = tail_style.extra_overlay2_w)
				overlay.Blend(rgb(src.r_tail3, src.g_tail3, src.b_tail3), tail_style.color_blend_mode)
				tail_s.Blend(overlay, ICON_OVERLAY)
				qdel(overlay)
			else
				overlay.Blend(rgb(src.r_tail3, src.g_tail3, src.b_tail3), tail_style.color_blend_mode)
				tail_s.Blend(overlay, ICON_OVERLAY)
				qdel(overlay)

		if(isTaurTail(tail_style))
			var/datum/sprite_accessory/tail/taur/taurtype = tail_style
			if(taurtype.can_ride && !riding_datum)
				riding_datum = new /datum/riding/taur(src)
				verbs |= /mob/living/carbon/human/proc/taur_mount
				verbs |= /mob/living/proc/toggle_rider_reins
			return image(tail_s, "pixel_x" = -16)
		else
			return image(tail_s)
	return null

/mob/living/carbon/human/proc/get_wing_image()
	if(QDESTROYING(src))
		return

	//If you are FBP with wing style and didn't set a custom one
	if((synthetic && synthetic.includes_wing && !wing_style) && !wings_hidden)
		var/icon/wing_s = new/icon("icon" = synthetic.icon, "icon_state" = "wing") //I dunno. If synths have some custom wing?
		wing_s.Blend(rgb(src.r_skin, src.g_skin, src.b_skin), species.color_mult ? ICON_MULTIPLY : ICON_ADD)
		return image(wing_s)

	//If you have custom wings selected
	if((wing_style && !(wear_suit && wear_suit.flags_inv & HIDETAIL)) && !wings_hidden)
		var/icon/wing_s = new/icon("icon" = wing_style.icon, "icon_state" = flapping && wing_style.ani_state ? wing_style.ani_state : wing_style.icon_state)
		if(wing_style.do_colouration)
			wing_s.Blend(rgb(src.r_wing, src.g_wing, src.b_wing), wing_style.color_blend_mode)
		if(wing_style.extra_overlay)
			var/icon/overlay = new/icon("icon" = wing_style.icon, "icon_state" = wing_style.extra_overlay)
			overlay.Blend(rgb(src.r_wing2, src.g_wing2, src.b_wing2), wing_style.color_blend_mode)
			wing_s.Blend(overlay, ICON_OVERLAY)
			qdel(overlay)

		if(wing_style.extra_overlay2)
			var/icon/overlay = new/icon("icon" = wing_style.icon, "icon_state" = wing_style.extra_overlay2)
			if(wing_style.ani_state)
				overlay = new/icon("icon" = wing_style.icon, "icon_state" = wing_style.extra_overlay2_w)
				overlay.Blend(rgb(src.r_wing3, src.g_wing3, src.b_wing3), wing_style.color_blend_mode)
				wing_s.Blend(overlay, ICON_OVERLAY)
				qdel(overlay)
			else
				overlay.Blend(rgb(src.r_wing3, src.g_wing3, src.b_wing3), wing_style.color_blend_mode)
				wing_s.Blend(overlay, ICON_OVERLAY)
				qdel(overlay)

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