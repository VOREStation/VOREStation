var/global/list/human_icon_cache = list()

/mob/living/carbon/human
	var/list/overlays_standing[TOTAL_LAYERS]
	var/previous_damage_appearance // store what the body last looked like, so we only have to update it if something changed
	var/icon/skeleton
	var/list/cached_standing_overlays = list() // List of everything currently in a human's actual overlays


//MARKINGS OVERLAY
/mob/living/carbon/human/proc/update_markings(var/update_icons=1)
	//Reset our markings.
	overlays_standing[MARKINGS_LAYER]	= null

	//Base icon.
	var/icon/markings_standing	= new/icon('icons/mob/body_accessory_vr.dmi',"accessory_none_s")

	//Body markings.
	var/obj/item/organ/external/chest/chest_organ = get_organ("chest")
	if(chest_organ && !chest_organ.is_stump() && !(chest_organ.status & ORGAN_DESTROYED) && m_styles["body"])
		var/body_marking = m_styles["body"]
		var/datum/sprite_accessory/body_marking_style = marking_styles_list[body_marking]
		if(body_marking_style && body_marking_style.species_allowed && (species.name in body_marking_style.species_allowed))
			var/icon/b_marking_s = new/icon("icon" = body_marking_style.icon, "icon_state" = "[body_marking_style.icon_state]_s")
			if(body_marking_style.do_colouration)
				b_marking_s.Blend(m_colours["body"], ICON_ADD)
			markings_standing.Blend(b_marking_s, ICON_OVERLAY)
	//Head markings.
	var/obj/item/organ/external/head/head_organ = get_organ("head")
	if(head_organ && !head_organ.is_stump() && !(head_organ.status & ORGAN_DESTROYED) && m_styles["head"]) //If the head is destroyed, forget the head markings. This prevents floating optical markings on decapitated IPCs, for example.
		var/head_marking = m_styles["head"]
		var/datum/sprite_accessory/head_marking_style = marking_styles_list[head_marking]
		if(head_marking_style && head_marking_style.species_allowed && (head_organ.species.name in head_marking_style.species_allowed))
			var/icon/h_marking_s = new/icon("icon" = head_marking_style.icon, "icon_state" = "[head_marking_style.icon_state]_s")
			if(head_marking_style.do_colouration)
				h_marking_s.Blend(m_colours["head"], ICON_ADD)
			markings_standing.Blend(h_marking_s, ICON_OVERLAY)

	overlays_standing[MARKINGS_LAYER]	= image(markings_standing)

	if(update_icons)   update_icons()

//HEAD ACCESSORY OVERLAY
/mob/living/carbon/human/proc/update_head_accessory(var/update_icons=1)
	//Reset our head accessory
	overlays_standing[HEAD_ACCESSORY_LAYER]	= null
	overlays_standing[HEAD_ACC_OVER_LAYER]	= null

	var/obj/item/organ/external/head/head_organ = get_organ("head")
	if(!head_organ || head_organ.is_stump() || (head_organ.status & ORGAN_DESTROYED) )
		if(update_icons)   update_icons()
		return

	//masks and helmets can obscure our head accessory
	if((head && (head.flags & BLOCKHAIR)) || (wear_mask && (wear_mask.flags & BLOCKHAIR)))
		if(update_icons)   update_icons()
		return

	//base icons
	var/icon/head_accessory_standing	= new /icon('icons/mob/body_accessory_vr.dmi',"accessory_none_s")
	if(head_organ.ha_style && (head_organ.species.bodyflags & HAS_HEAD_ACCESSORY))
		var/datum/sprite_accessory/head_accessory/head_accessory_style = head_accessory_styles_list[head_organ.ha_style]
		if(head_accessory_style && head_accessory_style.species_allowed)
			if(head_organ.species.name in head_accessory_style.species_allowed)
				var/icon/head_accessory_s = new/icon("icon" = head_accessory_style.icon, "icon_state" = "[head_accessory_style.icon_state]_s")
				if(head_accessory_style.do_colouration)
					head_accessory_s.Blend(rgb(head_organ.r_headacc, head_organ.g_headacc, head_organ.b_headacc), ICON_ADD)
				head_accessory_standing = head_accessory_s //head_accessory_standing.Blend(head_accessory_s, ICON_OVERLAY)
														   //Having it this way preserves animations. Useful for animated antennae.

				if(head_accessory_style.over_hair) //Select which layer to use based on the properties of the head accessory style.
					overlays_standing[HEAD_ACC_OVER_LAYER]	= image(head_accessory_standing)
				else
					overlays_standing[HEAD_ACCESSORY_LAYER] = image(head_accessory_standing)
		else
			//warning("Invalid ha_style for [species.name]: [ha_style]")

	if(update_icons)   update_icons()


/mob/living/carbon/human/proc/update_tail_layer(var/update_icons=1)
	overlays_standing[TAIL_UNDERLIMBS_LAYER] = null // SEW direction icons, overlayed by LIMBS_LAYER.
	overlays_standing[TAIL_LAYER] = null /* This will be one of two things:
											If the species' tail is overlapped by limbs, this will be only the N direction icon so tails can still appear on the outside of uniforms and such.
											Otherwise, since the user's tail isn't overlapped by limbs, it will be a full icon with all directions. */

	var/icon/tail_marking_icon
	var/datum/sprite_accessory/body_markings/tail/tail_marking_style
	if(m_styles["tail"] != "None" && (species.bodyflags & HAS_TAIL_MARKINGS))
		var/tail_marking = m_styles["tail"]
		tail_marking_style = marking_styles_list[tail_marking]
		tail_marking_icon = new/icon("icon" = tail_marking_style.icon, "icon_state" = "[tail_marking_style.icon_state]_s")
		tail_marking_icon.Blend(m_colours["tail"], ICON_ADD)

	if(body_accessory)
		if(body_accessory.try_restrictions(src))
			var/icon/accessory_s = new/icon("icon" = body_accessory.icon, "icon_state" = body_accessory.icon_state)
			if(species.bodyflags & HAS_SKIN_COLOR)
				accessory_s.Blend(rgb(r_skin, g_skin, b_skin), body_accessory.blend_mode)
			if(tail_marking_icon && (body_accessory.name in tail_marking_style.tails_allowed))
				accessory_s.Blend(tail_marking_icon, ICON_OVERLAY)
			if((!body_accessory || istype(body_accessory, /datum/body_accessory/tail)) && species.bodyflags & TAIL_OVERLAPPED) // If the player has a species whose tail is overlapped by limbs... (having a non-tail body accessory like the snake body will override this)
				// Gives the underlimbs layer SEW direction icons since it's overlayed by limbs and just about everything else anyway.
				var/icon/under = new/icon("icon" = 'icons/mob/body_accessory_vr.dmi', "icon_state" = "accessory_none_s")
				under.Insert(new/icon(accessory_s, dir=SOUTH), dir=SOUTH)
				under.Insert(new/icon(accessory_s, dir=EAST), dir=EAST)
				under.Insert(new/icon(accessory_s, dir=WEST), dir=WEST)

				overlays_standing[TAIL_UNDERLIMBS_LAYER] = image(under, "pixel_x" = body_accessory.pixel_x_offset, "pixel_y" = body_accessory.pixel_y_offset)

				// Creates a blank icon, and copies accessory_s' north direction sprite into it
				// before passing that to the tail layer that overlays uniforms and such.
				var/icon/over = new/icon("icon" = 'icons/mob/body_accessory_vr.dmi', "icon_state" = "accessory_none_s")
				over.Insert(new/icon(accessory_s, dir=NORTH), dir=NORTH)

				overlays_standing[TAIL_LAYER] = image(over, "pixel_x" = body_accessory.pixel_x_offset, "pixel_y" = body_accessory.pixel_y_offset)
			else // Otherwise, since the user's tail isn't overlapped by limbs, go ahead and use default icon generation.
				overlays_standing[TAIL_LAYER] = image(accessory_s, "pixel_x" = body_accessory.pixel_x_offset, "pixel_y" = body_accessory.pixel_y_offset)

	else if(species.tail && species.bodyflags & HAS_TAIL) //no tailless tajaran
		if(!wear_suit || !(wear_suit.flags_inv & HIDETAIL) && !istype(wear_suit, /obj/item/clothing/suit/space))
			var/icon/tail_s = new/icon("icon" = 'icons/effects/speciestail_vr.dmi', "icon_state" = "[species.tail]_s")
			if(species.bodyflags & HAS_SKIN_COLOR)
				tail_s.Blend(rgb(r_skin, g_skin, b_skin), ICON_ADD)
			if(tail_marking_icon)
				tail_s.Blend(tail_marking_icon, ICON_OVERLAY)
			if((!body_accessory || istype(body_accessory, /datum/body_accessory/tail)) && species.bodyflags & TAIL_OVERLAPPED) // If the player has a species whose tail is overlapped by limbs... (having a non-tail body accessory like the snake body will override this)
				// Gives the underlimbs layer SEW direction icons since it's overlayed by limbs and just about everything else anyway.
				var/icon/under = new/icon("icon" = 'icons/effects/speciestail_vr.dmi', "icon_state" = "blank")
				under.Insert(new/icon(tail_s, dir=SOUTH), dir=SOUTH)
				under.Insert(new/icon(tail_s, dir=EAST), dir=EAST)
				under.Insert(new/icon(tail_s, dir=WEST), dir=WEST)

				overlays_standing[TAIL_UNDERLIMBS_LAYER] = image(under)

				// Creates a blank icon, and copies accessory_s' north direction sprite into it before passing that to the tail layer that overlays uniforms and such.
				var/icon/over = new/icon("icon" = 'icons/effects/speciestail_vr.dmi', "icon_state" = "blank")
				over.Insert(new/icon(tail_s, dir=NORTH), dir=NORTH)

				overlays_standing[TAIL_LAYER] = image(over)
			else // Otherwise, since the user's tail isn't overlapped by limbs, go ahead and use default icon generation.
				overlays_standing[TAIL_LAYER] = image(tail_s)

	if(update_icons)
		update_icons()


/mob/living/carbon/human/proc/start_tail_wagging(var/update_icons=1)
	overlays_standing[TAIL_UNDERLIMBS_LAYER] = null // SEW direction icons, overlayed by LIMBS_LAYER.
	overlays_standing[TAIL_LAYER] = null /* This will be one of two things:
											If the species' tail is overlapped by limbs, this will be only the N direction icon so tails can still appear on the outside of uniforms and such.
											Otherwise, since the user's tail isn't overlapped by limbs, it will be a full icon with all directions. */

	var/icon/tail_marking_icon
	var/datum/sprite_accessory/body_markings/tail/tail_marking_style
	if(m_styles["tail"] != "None" && (species.bodyflags & HAS_TAIL_MARKINGS))
		var/tail_marking = m_styles["tail"]
		tail_marking_style = marking_styles_list[tail_marking]
		tail_marking_icon = new/icon("icon" = tail_marking_style.icon, "icon_state" = "[tail_marking_style.icon_state]w_s")
		tail_marking_icon.Blend(m_colours["tail"], ICON_ADD)

	if(body_accessory)
		var/icon/accessory_s = new/icon("icon" = body_accessory.get_animated_icon(), "icon_state" = body_accessory.get_animated_icon_state())
		if(species.bodyflags & HAS_SKIN_COLOR)
			accessory_s.Blend(rgb(r_skin, g_skin, b_skin), body_accessory.blend_mode)
		if(tail_marking_icon && (body_accessory.name in tail_marking_style.tails_allowed))
			accessory_s.Blend(tail_marking_icon, ICON_OVERLAY)
		if((!body_accessory || istype(body_accessory, /datum/body_accessory/tail)) && species.bodyflags & TAIL_OVERLAPPED) // If the player has a species whose tail is overlapped by limbs... (having a non-tail body accessory like the snake body will override this)
			// Gives the underlimbs layer SEW direction icons since it's overlayed by limbs and just about everything else anyway.
			var/icon/under = new/icon("icon" = 'icons/effects/speciestail_vr.dmi', "icon_state" = "Vulpkanin_tail_delay")
			if(body_accessory.allowed_species && (species.name in body_accessory.allowed_species))
				under = new/icon("icon" = 'icons/effects/speciestail_vr.dmi', "icon_state" = "[species.name]_tail_delay")
			under.Insert(new/icon(accessory_s, dir=SOUTH), dir=SOUTH)
			under.Insert(new/icon(accessory_s, dir=EAST), dir=EAST)
			under.Insert(new/icon(accessory_s, dir=WEST), dir=WEST)

			overlays_standing[TAIL_UNDERLIMBS_LAYER] = image(under, "pixel_x" = body_accessory.pixel_x_offset, "pixel_y" = body_accessory.pixel_y_offset)

			// Creates a blank icon, and copies accessory_s' north direction sprite into it before passing that to the tail layer that overlays uniforms and such.
			var/icon/over = new/icon("icon" = 'icons/effects/speciestail_vr.dmi', "icon_state" = "Vulpkanin_tail_delay")
			if(body_accessory.allowed_species && (species.name in body_accessory.allowed_species)) // If the user's species is in the list of allowed species for the currently selected body accessory, use the appropriate animation timing blank
				over = new/icon("icon" = 'icons/effects/speciestail_vr.dmi', "icon_state" = "[species.name]_tail_delay")
			over.Insert(new/icon(accessory_s, dir=NORTH), dir=NORTH)

			overlays_standing[TAIL_LAYER] = image(over, "pixel_x" = body_accessory.pixel_x_offset, "pixel_y" = body_accessory.pixel_y_offset)
		else // Otherwise, since the user's tail isn't overlapped by limbs, go ahead and use default icon generation.
			overlays_standing[TAIL_LAYER] = image(accessory_s, "pixel_x" = body_accessory.pixel_x_offset, "pixel_y" = body_accessory.pixel_y_offset)

	else if(species.tail && species.bodyflags & HAS_TAIL)
		var/icon/tailw_s = new/icon("icon" = 'icons/effects/speciestail_vr.dmi', "icon_state" = "[species.tail]w_s")
		if(species.bodyflags & HAS_SKIN_COLOR)
			tailw_s.Blend(rgb(r_skin, g_skin, b_skin), ICON_ADD)
		if(tail_marking_icon)
			tailw_s.Blend(tail_marking_icon, ICON_OVERLAY)
		if((!body_accessory || istype(body_accessory, /datum/body_accessory/tail)) && species.bodyflags & TAIL_OVERLAPPED) // If the player has a species whose tail is overlapped by limbs... (having a non-tail body accessory like the snake body will override this)
			// Gives the underlimbs layer SEW direction icons since it's overlayed by limbs and just about everything else anyway.
			var/icon/under = new/icon("icon" = 'icons/effects/speciestail_vr.dmi', "icon_state" = "[species.name]_tail_delay")
			under.Insert(new/icon(tailw_s, dir=SOUTH), dir=SOUTH)
			under.Insert(new/icon(tailw_s, dir=EAST), dir=EAST)
			under.Insert(new/icon(tailw_s, dir=WEST), dir=WEST)

			overlays_standing[TAIL_UNDERLIMBS_LAYER] = image(under)

			// Creates a blank icon, and copies accessory_s' north direction sprite into it before passing that to the tail layer that overlays uniforms and such.
			var/icon/over = new/icon("icon" = 'icons/effects/speciestail_vr.dmi', "icon_state" = "[species.name]_tail_delay")
			over.Insert(new/icon(tailw_s, dir=NORTH), dir=NORTH)

			overlays_standing[TAIL_LAYER] = image(over)
		else // Otherwise, since the user's tail isn't overlapped by limbs, go ahead and use default icon generation.
			overlays_standing[TAIL_LAYER] = image(tailw_s)

	if(update_icons)
		update_icons()

/mob/living/carbon/human/proc/stop_tail_wagging(var/update_icons=1)
	overlays_standing[TAIL_UNDERLIMBS_LAYER] = null
	overlays_standing[TAIL_LAYER] = null

	update_tail_layer(update_icons) //just trigger a full update for normal stationary sprites

/mob/living/carbon/human/handle_transform_change()
	..()
	update_tail_layer()