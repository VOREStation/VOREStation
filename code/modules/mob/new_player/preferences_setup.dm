/datum/preferences
	//The mob should have a gender you want before running this proc. Will run fine without H
/datum/preferences/proc/randomize_appearance_and_body_for(var/mob/living/carbon/human/H)
	var/datum/species/current_species = all_species[species ? species : "Human"]
	set_biological_gender(pick(current_species.genders))

	h_style = random_hair_style(biological_gender, species)
	f_style = random_facial_hair_style(biological_gender, species)
	if(current_species)
		if(current_species.appearance_flags & HAS_SKIN_TONE)
			s_tone = random_skin_tone()
		if(current_species.appearance_flags & HAS_SKIN_COLOR)
			r_skin = rand (0,255)
			g_skin = rand (0,255)
			b_skin = rand (0,255)
		if(current_species.appearance_flags & HAS_EYE_COLOR)
			randomize_eyes_color()
		if(current_species.appearance_flags & HAS_HAIR_COLOR)
			randomize_hair_color("hair")
			randomize_hair_color("facial")
		if(current_species.appearance_flags & HAS_SKIN_COLOR)
			r_skin = rand (0,255)
			g_skin = rand (0,255)
			b_skin = rand (0,255)
	if(current_species.appearance_flags & HAS_UNDERWEAR)
		all_underwear.Cut()
		for(var/datum/category_group/underwear/WRC in global_underwear.categories)
			var/datum/category_item/underwear/WRI = pick(WRC.items)
			all_underwear[WRC.name] = WRI.name


	backbag = rand(1,4)
	pdachoice = rand(1,3)
	age = rand(current_species.min_age, current_species.max_age)
	b_type = RANDOM_BLOOD_TYPE
	if(H)
		copy_to(H,1)


/datum/preferences/proc/randomize_hair_color(var/target = "hair")
	if(prob (75) && target == "facial") // Chance to inherit hair color
		r_facial = r_hair
		g_facial = g_hair
		b_facial = b_hair
		return

	var/red
	var/green
	var/blue

	var/col = pick ("blonde", "black", "chestnut", "copper", "brown", "wheat", "old", "punk")
	switch(col)
		if("blonde")
			red = 255
			green = 255
			blue = 0
		if("black")
			red = 0
			green = 0
			blue = 0
		if("chestnut")
			red = 153
			green = 102
			blue = 51
		if("copper")
			red = 255
			green = 153
			blue = 0
		if("brown")
			red = 102
			green = 51
			blue = 0
		if("wheat")
			red = 255
			green = 255
			blue = 153
		if("old")
			red = rand (100, 255)
			green = red
			blue = red
		if("punk")
			red = rand (0, 255)
			green = rand (0, 255)
			blue = rand (0, 255)

	red = max(min(red + rand (-25, 25), 255), 0)
	green = max(min(green + rand (-25, 25), 255), 0)
	blue = max(min(blue + rand (-25, 25), 255), 0)

	switch(target)
		if("hair")
			r_hair = red
			g_hair = green
			b_hair = blue
		if("facial")
			r_facial = red
			g_facial = green
			b_facial = blue

/datum/preferences/proc/randomize_eyes_color()
	var/red
	var/green
	var/blue

	var/col = pick ("black", "grey", "brown", "chestnut", "blue", "lightblue", "green", "albino")
	switch(col)
		if("black")
			red = 0
			green = 0
			blue = 0
		if("grey")
			red = rand (100, 200)
			green = red
			blue = red
		if("brown")
			red = 102
			green = 51
			blue = 0
		if("chestnut")
			red = 153
			green = 102
			blue = 0
		if("blue")
			red = 51
			green = 102
			blue = 204
		if("lightblue")
			red = 102
			green = 204
			blue = 255
		if("green")
			red = 0
			green = 102
			blue = 0
		if("albino")
			red = rand (200, 255)
			green = rand (0, 150)
			blue = rand (0, 150)

	red = max(min(red + rand (-25, 25), 255), 0)
	green = max(min(green + rand (-25, 25), 255), 0)
	blue = max(min(blue + rand (-25, 25), 255), 0)

	r_eyes = red
	g_eyes = green
	b_eyes = blue

/datum/preferences/proc/randomize_skin_color()
	var/red
	var/green
	var/blue

	var/col = pick ("black", "grey", "brown", "chestnut", "blue", "lightblue", "green", "albino")
	switch(col)
		if("black")
			red = 0
			green = 0
			blue = 0
		if("grey")
			red = rand (100, 200)
			green = red
			blue = red
		if("brown")
			red = 102
			green = 51
			blue = 0
		if("chestnut")
			red = 153
			green = 102
			blue = 0
		if("blue")
			red = 51
			green = 102
			blue = 204
		if("lightblue")
			red = 102
			green = 204
			blue = 255
		if("green")
			red = 0
			green = 102
			blue = 0
		if("albino")
			red = rand (200, 255)
			green = rand (0, 150)
			blue = rand (0, 150)

	red = max(min(red + rand (-25, 25), 255), 0)
	green = max(min(green + rand (-25, 25), 255), 0)
	blue = max(min(blue + rand (-25, 25), 255), 0)

	r_skin = red
	g_skin = green
	b_skin = blue

/datum/preferences/proc/dress_preview_mob(var/mob/living/carbon/human/mannequin)
	copy_to(mannequin)
	if(!dress_mob)
		return

	// Determine what job is marked as 'High' priority, and dress them up as such.
	var/datum/job/previewJob
	if(job_civilian_low & ASSISTANT)
		previewJob = job_master.GetJob("Assistant")
	else
		for(var/datum/job/job in job_master.occupations)
			var/job_flag
			switch(job.department_flag)
				if(CIVILIAN)
					job_flag = job_civilian_high
				if(MEDSCI)
					job_flag = job_medsci_high
				if(ENGSEC)
					job_flag = job_engsec_high
			if(job.flag == job_flag)
				previewJob = job
				break

	if(previewJob)
		mannequin.job = previewJob.title
		previewJob.equip_preview(mannequin, player_alt_titles[previewJob.title])
		var/list/equipped_slots = list() //If more than one item takes the same slot only spawn the first
		for(var/thing in gear)
			var/datum/gear/G = gear_datums[thing]
			if(G)
				var/permitted = 0
				if(G.allowed_roles)
					for(var/job_name in G.allowed_roles)
						if(previewJob.title == job_name)
							permitted = 1
				else
					permitted = 1
		icobase = 'icons/mob/human_races/r_human.dmi'

	preview_icon = new /icon(icobase, "")
	for(var/name in BP_ALL)
		if(organ_data[name] == "amputated")
			continue
		if(organ_data[name] == "cyborg")
			var/datum/robolimb/R
			if(rlimb_data[name]) R = all_robolimbs[rlimb_data[name]]
			if(!R) R = basic_robolimb
			if(name in list(BP_TORSO, BP_GROIN, BP_HEAD))
				preview_icon.Blend(icon(R.icon, "[name]_[g]"), ICON_OVERLAY)
			else
				preview_icon.Blend(icon(R.icon, "[name]"), ICON_OVERLAY)
			continue
		var/icon/limb_icon
		if(name in list(BP_TORSO, BP_GROIN, BP_HEAD))
			limb_icon = new /icon(icobase, "[name]_[g]")
		else
			limb_icon = new /icon(icobase, "[name]")
		// Skin color
		if(current_species && (current_species.appearance_flags & HAS_SKIN_COLOR))
			//VOREStation Code Start
			if(current_species.color_mult)
				limb_icon.Blend(rgb(r_skin, g_skin, b_skin), ICON_MULTIPLY)
			else
				limb_icon.Blend(rgb(r_skin, g_skin, b_skin), ICON_ADD)
			//VOREstation Code End
		// Skin tone
		if(current_species && (current_species.appearance_flags & HAS_SKIN_TONE))
			if (s_tone >= 0)
				limb_icon.Blend(rgb(s_tone, s_tone, s_tone), ICON_ADD)
			else
				limb_icon.Blend(rgb(-s_tone,  -s_tone,  -s_tone), ICON_SUBTRACT)
		preview_icon.Blend(limb_icon, ICON_OVERLAY)

	// VoreStation Edit - Start
	// Body Markings
	if(src.body_markings && body_markings_styles_list[src.body_markings_style])
		var/datum/sprite_accessory/body_markings/body_markings_meta = body_markings_styles_list[src.body_markings_style]
		var/icon/body_markings_s = new/icon("icon" = body_markings_meta.icon, "icon_state" = body_markings_meta.icon_state)
		if(body_markings_meta.do_colouration)
			body_markings_s.Blend(rgb(src.r_markings, src.g_markings, src.b_markings), body_markings_meta.color_blend_mode)
	// Vore Station Edit - End

	//Tails

	// VoreStation Edit - Start
	var/show_species_tail = 1
	if(src.tail_style && tail_styles_list[src.tail_style])
		var/datum/sprite_accessory/tail/tail_meta = tail_styles_list[src.tail_style]
		var/icon/tail_s = new/icon("icon" = tail_meta.icon, "icon_state" = tail_meta.icon_state)
		if(tail_meta.do_colouration)
			tail_s.Blend(rgb(src.r_tail, src.g_tail, src.b_tail), tail_meta.color_blend_mode)
		if(tail_meta.extra_overlay)
			var/icon/overlay = new/icon("icon" = tail_meta.icon, "icon_state" = tail_meta.extra_overlay)
			tail_s.Blend(overlay, ICON_OVERLAY)
			qdel(overlay)

		show_species_tail = tail_meta.show_species_tail
		if(istype(tail_meta, /datum/sprite_accessory/tail/taur))
			preview_icon.Blend(tail_s, ICON_OVERLAY, -16)
		else
			preview_icon.Blend(tail_s, ICON_OVERLAY)
	// VoreStation Edit - End

	if(show_species_tail && current_species && (current_species.tail))
		var/icon/temp = new/icon(
			"icon" = (current_species.icobase_tail ? current_species.icobase : 'icons/effects/species.dmi'),
			"icon_state" = "[current_species.tail]_s")
		if(current_species && (current_species.appearance_flags & HAS_SKIN_COLOR))
			//VOREStation Code Start
			if(current_species.color_mult)
				temp.Blend(rgb(r_skin, g_skin, b_skin), ICON_MULTIPLY)
			else
				temp.Blend(rgb(r_skin, g_skin, b_skin), ICON_ADD)
			//VOREStation Code End
		if(current_species && (current_species.appearance_flags & HAS_SKIN_TONE))
			if (s_tone >= 0)
				temp.Blend(rgb(s_tone, s_tone, s_tone), ICON_ADD)
			else
				temp.Blend(rgb(-s_tone,  -s_tone,  -s_tone), ICON_SUBTRACT)
		preview_icon.Blend(temp, ICON_OVERLAY)

	// This is absolute garbage but whatever. It will do until this entire file can be rewritten without crashes.
	var/use_eye_icon = "eyes_s"
	var/list/use_eye_data = current_species.has_limbs[BP_HEAD]
	if(islist(use_eye_data))
		var/use_eye_path = use_eye_data["path"]
		var/obj/item/organ/external/head/temp_head = new use_eye_path ()
		if(istype(temp_head))
			use_eye_icon = temp_head.eye_icon
		qdel(temp_head)

	var/icon/eyes_s = new/icon("icon" = 'icons/mob/human_face.dmi', "icon_state" = use_eye_icon)
	if ((current_species && (current_species.appearance_flags & HAS_EYE_COLOR)))
		eyes_s.Blend(rgb(r_eyes, g_eyes, b_eyes), ICON_ADD)

	var/datum/sprite_accessory/hair_style = hair_styles_list[h_style]
	if(hair_style)
		var/icon/hair_s = new/icon("icon" = hair_style.icon, "icon_state" = "[hair_style.icon_state]_s")
		hair_s.Blend(rgb(r_hair, g_hair, b_hair), ICON_ADD)
		eyes_s.Blend(hair_s, ICON_OVERLAY)

	var/datum/sprite_accessory/facial_hair_style = facial_hair_styles_list[f_style]
	if(facial_hair_style)
		var/icon/facial_s = new/icon("icon" = facial_hair_style.icon, "icon_state" = "[facial_hair_style.icon_state]_s")
		facial_s.Blend(rgb(r_facial, g_facial, b_facial), ICON_ADD)
		eyes_s.Blend(facial_s, ICON_OVERLAY)

	// VoreStation Edit - Start
	// Ear Items
	var/datum/sprite_accessory/ears/ears_meta = ear_styles_list[src.ear_style]
	if(ears_meta)
		var/icon/ears_s = icon("icon" = ears_meta.icon, "icon_state" = ears_meta.icon_state)
		if(ears_meta.do_colouration)
			ears_s.Blend(rgb(src.r_hair, src.g_hair, src.b_hair), ears_meta.color_blend_mode)
		if(ears_meta.extra_overlay)
			var/icon/overlay = new/icon("icon" = ears_meta.icon, "icon_state" = ears_meta.extra_overlay)
			ears_s.Blend(overlay, ICON_OVERLAY)
		eyes_s.Blend(ears_s, ICON_OVERLAY)
	// Vore Station Edit - End

	var/icon/underwear_top_s = null
	if(underwear_top && current_species.appearance_flags & HAS_UNDERWEAR)
		underwear_top_s = new/icon("icon" = 'icons/mob/human.dmi', "icon_state" = underwear_top)
	var/icon/underwear_bottom_s = null
	if(underwear_bottom && current_species.appearance_flags & HAS_UNDERWEAR)
		underwear_bottom_s = new/icon("icon" = 'icons/mob/human.dmi', "icon_state" = underwear_bottom)

	var/icon/undershirt_s = null
	if(undershirt && current_species.appearance_flags & HAS_UNDERWEAR)
		undershirt_s = new/icon("icon" = 'icons/mob/human.dmi', "icon_state" = undershirt)

				if(G.whitelisted && (G.whitelisted != mannequin.species.name))
					permitted = 0

				if(!permitted)
					continue

				if(G.slot && !(G.slot in equipped_slots))
					equipped_slots += G.slot
					var/metadata = gear[G.display_name]
					mannequin.equip_to_slot_or_del(G.spawn_item(mannequin, metadata), G.slot)
		mannequin.update_icons()

/datum/preferences/proc/update_preview_icon()
	var/mob/living/carbon/human/dummy/mannequin/mannequin = get_mannequin(client_ckey)
	mannequin.delete_inventory(TRUE)
	dress_preview_mob(mannequin)

	preview_icon = icon('icons/effects/effects.dmi', "nothing")
	preview_icon.Scale(48+32, 16+32)

	mannequin.dir = NORTH
	var/icon/stamp = getFlatIcon(mannequin)
	preview_icon.Blend(stamp, ICON_OVERLAY, 25, 17)

	mannequin.dir = WEST
	stamp = getFlatIcon(mannequin)
	preview_icon.Blend(stamp, ICON_OVERLAY, 1, 9)

	mannequin.dir = SOUTH
	stamp = getFlatIcon(mannequin)
	preview_icon.Blend(stamp, ICON_OVERLAY, 49, 1)

	preview_icon.Scale(preview_icon.Width() * 2, preview_icon.Height() * 2) // Scaling here to prevent blurring in the browser.