
#define isTaurTail(A)	istype(A, /datum/sprite_accessory/tail/taur)

/mob/living/carbon/human/proc/get_ears_overlay()
	if(ear_style && !(head && (head.flags_inv & BLOCKHEADHAIR)))
		var/icon/ears_s = new/icon("icon" = ear_style.icon, "icon_state" = ear_style.icon_state)
		if(ear_style.do_colouration)
			ears_s.Blend(rgb(src.r_hair, src.g_hair, src.b_hair), ear_style.color_blend_mode)
		if(ear_style.extra_overlay)
			var/icon/overlay = new/icon("icon" = ear_style.icon, "icon_state" = ear_style.extra_overlay)
			ears_s.Blend(overlay, ICON_OVERLAY)
		return ears_s
	return null


/mob/living/carbon/human/proc/get_tail_image()
	//If you are FBP with tail style
	if(full_prosthetic && ("groin" in organs_by_name) && organs_by_name["groin"])
		var/obj/item/organ/external/groin/G = organs_by_name["groin"]
		var/datum/robolimb/R = all_robolimbs[G.model]
		if(R.includes_tail)
			var/icon/tail_s = new/icon("icon" = R.icon, "icon_state" = "tail")
			return image(tail_s)

	//If you have a custom tail selected
	if(tail_style && !(wear_suit && wear_suit.flags_inv & HIDETAIL && !isTaurTail(tail_style)))
		var/icon/tail_s = new/icon("icon" = tail_style.icon, "icon_state" = tail_style.icon_state)
		if(tail_style.do_colouration)
			tail_s.Blend(rgb(src.r_tail, src.g_tail, src.b_tail), tail_style.color_blend_mode)
		if(tail_style.extra_overlay)
			var/icon/overlay = new/icon("icon" = tail_style.icon, "icon_state" = tail_style.extra_overlay)
			tail_s.Blend(overlay, ICON_OVERLAY)
			qdel(overlay)

		if(isTaurTail(tail_style))
			return image(tail_s, "pixel_x" = -16)
		else
			return image(tail_s)
	return null

/mob/living/carbon/human/proc/get_body_markings_overlay()
	if(body_markings_style && !(head && (head.flags_inv & BLOCKHEADHAIR)))
		var/icon/body_markings_s = new/icon("icon" = body_markings_style.icon, "icon_state" = body_markings_style.icon_state)
		if(body_markings_style.do_colouration)
			body_markings_s.Blend(rgb(src.r_markings, src.g_markings, src.b_markings), body_markings_style.color_blend_mode)
		if(body_markings_style.extra_overlay)
			var/icon/overlay = new/icon("icon" = body_markings_style.icon, "icon_state" = body_markings_style.extra_overlay)
			body_markings_s.Blend(overlay, ICON_OVERLAY)
		return body_markings_s
	return null
