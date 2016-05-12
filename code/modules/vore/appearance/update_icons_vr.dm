
#define isTaurTail(A)	istype(A, /datum/sprite_accessory/tail/taur)

/mob/living/carbon/human/proc/get_ears_overlay()
	if(ear_style && !(head && (head.flags_inv & BLOCKHEADHAIR)) && (src.species.get_bodytype() in ear_style.species_allowed))
		var/icon/ears_s = new/icon("icon" = ear_style.icon, "icon_state" = ear_style.icon_state)
		if(ear_style.do_colouration)
			ears_s.Blend(rgb(src.r_hair, src.g_hair, src.b_hair), ear_style.do_colouration)
		if(ear_style.extra_overlay)
			var/icon/overlay = new/icon("icon" = ear_style.icon, "icon_state" = ear_style.extra_overlay)
			ears_s.Blend(overlay, ICON_OVERLAY)
		return ears_s
	return null


/mob/living/carbon/human/proc/get_tail_image()
	if(tail_style && !(wear_suit && wear_suit.flags_inv & HIDETAIL && !isTaurTail(tail_style)))
		var/icon/tail_s = new/icon("icon" = tail_style.icon, "icon_state" = tail_style.icon_state)
		if(tail_style.do_colouration)
			tail_s.Blend(rgb(src.r_tail, src.g_tail, src.b_tail), tail_style.do_colouration)
		if(tail_style.extra_overlay)
			var/icon/overlay = new/icon("icon" = tail_style.icon, "icon_state" = tail_style.extra_overlay)
			tail_s.Blend(overlay, ICON_OVERLAY)
			qdel(overlay)

		if(isTaurTail(tail_style))
			return image(tail_s, "pixel_x" = -16)
		else
			return image(tail_s)
	return null
