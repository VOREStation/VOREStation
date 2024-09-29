/mob/living/carbon/human
	name = "unknown"
	real_name = "unknown"
	voice_name = "unknown"
	icon = 'icons/effects/effects.dmi'	//We have an ultra-complex update icons that overlays everything, don't load some stupid random male human
	icon_state = "nothing"

	has_huds = TRUE 					//We do have HUDs (like health, wanted, status, not inventory slots)


	var/vore_capacity = 3
	var/vore_capacity_ex = list("stomach" = 3, "taur belly" = 3)
	var/vore_fullness_ex = list("stomach" = 0, "taur belly" = 0)
	var/vore_icon_bellies = list("stomach", "taur belly")
	var/struggle_anim_stomach = FALSE
	var/struggle_anim_taur = FALSE
	var/vore_sprite_color = list("stomach" = "#FFFFFF", "taur belly" = "#FFFFFF")
	var/vore_sprite_multiply = list("stomach" = TRUE, "taur belly" = TRUE)
	var/vore_fullness = 0

	var/embedded_flag					//To check if we've need to roll for damage on movement while an item is imbedded in us.
	var/obj/item/rig/wearing_rig // This is very not good, but it's much much better than calling get_rig() every update_canmove() call.
	var/last_push_time					//For human_attackhand.dm, keeps track of the last use of disarm

	var/spitting = 0 					//Spitting and spitting related things. Any human based ranged attacks, be it innate or added abilities.
	var/spit_projectile = null			//Projectile type.
	var/spit_name = null 				//String
	var/last_spit = 0 					//Timestamp.

	var/can_defib = 1					//Horrible damage (like beheadings) will prevent defibbing organics.
	var/active_regen = FALSE //Used for the regenerate proc in human_powers.dm
	var/active_regen_delay = 300
	var/list/teleporters = list() //Used for lleill abilities

	var/rest_dir = 0					//To lay down in a specific direction

/mob/living/carbon/human/Initialize(mapload, var/new_species = null)
	if(!dna)
		dna = new /datum/dna(null)
		// Species name is handled by set_species()

	if(!species)
		if(new_species)
			set_species(new_species,1)
		else
			set_species()

	if(species)
		real_name = species.get_random_name(gender)
		name = real_name
		if(mind)
			mind.name = real_name

	nutrition = rand(200,400)

	human_mob_list |= src

	. = ..()

	hide_underwear.Cut()
	for(var/category in global_underwear.categories_by_name)
		hide_underwear[category] = FALSE

	if(dna)
		dna.ready_dna(src)
		dna.real_name = real_name
		sync_organ_dna()

	//verbs |= /mob/living/proc/toggle_selfsurgery //VOREStation Removal
	AddComponent(/datum/component/personal_crafting)

/mob/living/carbon/human/Destroy()
	human_mob_list -= src
	/* //Chomp REMOVE - this is done on mob/living/Destroy
	for(var/organ in organs)
		qdel(organ)
	*/
	if(nif)
		QDEL_NULL(nif)	//VOREStation Add
	worn_clothing.Cut()


	if(vessel)
		QDEL_NULL(vessel)
	return ..()

/mob/living/carbon/human/Stat()
	..()
	if(statpanel("Status"))
		stat("Intent:", "[a_intent]")
		stat("Move Mode:", "[m_intent]")
		if(emergency_shuttle)
			var/eta_status = emergency_shuttle.get_status_panel_eta()
			if(eta_status)
				stat(null, eta_status)

		if (internal)
			if (!internal.air_contents)
				qdel(internal)
			else
				stat("Internal Atmosphere Info", internal.name)
				stat("Tank Pressure", internal.air_contents.return_pressure())
				stat("Distribution Pressure", internal.distribute_pressure)

		var/obj/item/organ/internal/xenos/plasmavessel/P = internal_organs_by_name[O_PLASMA] //Xenomorphs. Mech.
		if(P)
			stat(null, "Phoron Stored: [P.stored_plasma]/[P.max_plasma]")


		if(back && istype(back,/obj/item/rig))
			var/obj/item/rig/suit = back
			var/cell_status = "ERROR"
			if(suit.cell) cell_status = "[suit.cell.charge]/[suit.cell.maxcharge]"
			stat(null, "Suit charge: [cell_status]")

		if(mind)
			if(mind.changeling)
				stat("Chemical Storage", mind.changeling.chem_charges)
				stat("Genetic Damage Time", mind.changeling.geneticdamage)
				stat("Re-Adaptations", "[mind.changeling.readapts]/[mind.changeling.max_readapts]")
	if(species)
		species.Stat(src)

/mob/living/carbon/human/ex_act(severity)
	if(!blinded)
		flash_eyes()

	for(var/datum/modifier/M in modifiers)
		if(!isnull(M.explosion_modifier))
			severity = CLAMP(severity + M.explosion_modifier, 1, 4)

	severity = round(severity)

	if(severity > 3)
		return

	var/shielded = 0
	var/b_loss = null
	var/f_loss = null
	switch (severity)
		if (1.0)
			b_loss += 500
			if (!prob(getarmor(null, "bomb")))
				gib()
				return
			else
				var/atom/target = get_edge_target_turf(src, get_dir(src, get_step_away(src, src)))
				throw_at(target, 200, 4)
			//return
//				var/atom/target = get_edge_target_turf(user, get_dir(src, get_step_away(user, src)))
				//user.throw_at(target, 200, 4)

		if (2.0)
			if (!shielded)
				b_loss += 60

			f_loss += 60

			if (prob(getarmor(null, "bomb")))
				b_loss = b_loss/1.5
				f_loss = f_loss/1.5

			if (!get_ear_protection() >= 2)
				ear_damage += 30
				ear_deaf += 120
			if (prob(70) && !shielded)
				Paralyse(10)

		if(3.0)
			b_loss += 30
			if (prob(getarmor(null, "bomb")))
				b_loss = b_loss/2
			if (!get_ear_protection() >= 2)
				ear_damage += 15
				ear_deaf += 60
			if (prob(50) && !shielded)
				Paralyse(10)

	var/blastsoak = getsoak(null, "bomb")

	b_loss = max(1, b_loss - blastsoak)
	f_loss = max(1, f_loss - blastsoak)

	var/update = 0

	// focus most of the blast on one organ
	var/obj/item/organ/external/take_blast = pick(organs)
	update |= take_blast.take_damage(b_loss * 0.9, f_loss * 0.9, used_weapon = "Explosive blast")

	// distribute the remaining 10% on all limbs equally
	b_loss *= 0.1
	f_loss *= 0.1

	var/weapon_message = "Explosive Blast"

	for(var/obj/item/organ/external/temp in organs)
		switch(temp.organ_tag)
			if(BP_HEAD)
				update |= temp.take_damage(b_loss * 0.2, f_loss * 0.2, used_weapon = weapon_message)
			if(BP_TORSO)
				update |= temp.take_damage(b_loss * 0.4, f_loss * 0.4, used_weapon = weapon_message)
			else
				update |= temp.take_damage(b_loss * 0.05, f_loss * 0.05, used_weapon = weapon_message)
	if(update)	UpdateDamageIcon()

/mob/living/carbon/human/proc/implant_loyalty(override = FALSE) // Won't override by default.
	if(!config.use_loyalty_implants && !override) return // Nuh-uh.

	var/obj/item/implant/loyalty/L = new/obj/item/implant/loyalty(src)
	if(L.handle_implant(src, BP_HEAD))
		L.post_implant(src)

/mob/living/carbon/human/proc/is_loyalty_implanted()
	for(var/L in src.contents)
		if(istype(L, /obj/item/implant/loyalty))
			for(var/obj/item/organ/external/O in src.organs)
				if(L in O.implants)
					return 1
	return 0

/mob/living/carbon/human/restrained()
	if (handcuffed)
		return 1
	if (istype(wear_suit, /obj/item/clothing/suit/straight_jacket))
		return 1
	return 0

/mob/living/carbon/human/var/co2overloadtime = null
/mob/living/carbon/human/var/temperature_resistance = T0C+75

// called when something steps onto a human
// this handles mobs on fire - mulebot and vehicle code has been relocated to /mob/living/Crossed()
/mob/living/carbon/human/Crossed(var/atom/movable/AM)
	if(AM.is_incorporeal())
		return

	spread_fire(AM)

	..() // call parent because we moved behavior to parent

// Get rank from ID, ID inside PDA, PDA, ID in wallet, etc.
/mob/living/carbon/human/proc/get_authentification_rank(var/if_no_id = "No id", var/if_no_job = "No job")
	var/obj/item/pda/pda = wear_id
	if (istype(pda))
		if (pda.id)
			return pda.id.rank ? pda.id.rank : if_no_job
		else
			return pda.ownrank ? pda.ownrank : if_no_job
	else
		var/obj/item/card/id/id = get_idcard()
		if(id)
			return id.rank ? id.rank : if_no_job
		else
			return if_no_id

//gets assignment from ID or ID inside PDA or PDA itself
//Useful when player do something with computers
/mob/living/carbon/human/proc/get_assignment(var/if_no_id = "No id", var/if_no_job = "No job")
	var/obj/item/pda/pda = wear_id
	if (istype(pda))
		if (pda.id)
			return pda.id.assignment
		else
			return pda.ownjob ? pda.ownjob : if_no_job
	else
		var/obj/item/card/id/id = get_idcard()
		if(id)
			return id.assignment ? id.assignment : if_no_job
		else
			return if_no_id

//gets name from ID or ID inside PDA or PDA itself
//Useful when player do something with computers
/mob/living/carbon/human/proc/get_authentification_name(var/if_no_id = "Unknown")
	var/obj/item/pda/pda = wear_id
	if (istype(pda))
		if (pda.id)
			return pda.id.registered_name
		else
			return pda.owner ? pda.owner : if_no_id
	else
		var/obj/item/card/id/id = get_idcard()
		if(id)
			return id.registered_name
		else
			return if_no_id

//repurposed proc. Now it combines get_id_name() and get_face_name() to determine a mob's name variable. Made into a seperate proc as it'll be useful elsewhere
/mob/living/carbon/human/proc/get_visible_name()
	if(ability_flags & AB_PHASE_SHIFTED)
		return "Something"	// Something
	if( wear_mask && (wear_mask.flags_inv&HIDEFACE) )	//Wearing a mask which hides our face, use id-name if possible
		return get_id_name("Unknown")
	if( head && (head.flags_inv&HIDEFACE) )
		return get_id_name("Unknown")		//Likewise for hats
	var/face_name = get_face_name()
	var/id_name = get_id_name("")
	if((face_name == "Unknown") && id_name && (id_name != face_name))
		return "[face_name] (as [id_name])"
	return face_name

//Returns "Unknown" if facially disfigured and real_name if not. Useful for setting name when polyacided or when updating a human's name variable
/mob/living/carbon/human/proc/get_face_name()
	var/obj/item/organ/external/head = get_organ(BP_HEAD)
	if(!head || head.disfigured || head.is_stump() || !real_name || (HUSK in mutations) )	//disfigured. use id-name if possible
		return "Unknown"
	return real_name

//gets name from ID or PDA itself, ID inside PDA doesn't matter
//Useful when player is being seen by other mobs
/mob/living/carbon/human/proc/get_id_name(var/if_no_id = "Unknown")
	. = if_no_id
	if(istype(wear_id,/obj/item/pda))
		var/obj/item/pda/P = wear_id
		return P.owner ? P.owner : if_no_id
	if(wear_id)
		var/obj/item/card/id/I = wear_id.GetID()
		if(I)
			return I.registered_name
	return

//gets ID card object from special clothes slot or null.
/mob/living/carbon/human/proc/get_idcard()
	if(wear_id)
		return wear_id.GetID()

//Removed the horrible safety parameter. It was only being used by ninja code anyways.
//Now checks siemens_coefficient of the affected area by default
/mob/living/carbon/human/electrocute_act(var/shock_damage, var/obj/source, var/base_siemens_coeff = 1.0, var/def_zone = null)

	if(status_flags & GODMODE)	return 0	//godmode

	if (!def_zone)
		def_zone = pick("l_hand", "r_hand")

	if(species.siemens_coefficient == -1)
		if(stored_shock_by_ref["\ref[src]"])
			stored_shock_by_ref["\ref[src]"] += shock_damage
		else
			stored_shock_by_ref["\ref[src]"] = shock_damage
		return

	var/obj/item/organ/external/affected_organ = get_organ(check_zone(def_zone))
	var/siemens_coeff = base_siemens_coeff * get_siemens_coefficient_organ(affected_organ)
	if(fire_stacks < 0) // Water makes you more conductive.
		siemens_coeff *= 1.5

	return ..(shock_damage, source, siemens_coeff, def_zone)


/mob/living/carbon/human/Topic(href, href_list)
	if (href_list["mach_close"]) // This is horrible.
		var/t1 = text("window=[]", href_list["mach_close"])
		unset_machine()
		src << browse(null, t1)

	if(href_list["item"])
		log_runtime(EXCEPTION("Warning: human/Topic was called with item [href_list["item"]], but the item Topic is deprecated!"))
		// handle_strip(href_list["item"],usr)

	if (href_list["criminal"])
		if(hasHUD(usr,"security"))

			var/modified = 0
			var/perpname = "wot"
			var/obj/item/card/id/I = GetIdCard()
			if(I)
				perpname = I.registered_name
			else
				perpname = name

			if(perpname)
				for (var/datum/data/record/E in data_core.general)
					if (E.fields["name"] == perpname)
						for (var/datum/data/record/R in data_core.security)
							if (R.fields["id"] == E.fields["id"])

								var/setcriminal = tgui_input_list(usr, "Specify a new criminal status for this person.", "Security HUD", list("None", "*Arrest*", "Incarcerated", "Parolled", "Released", "Cancel"))

								if(hasHUD(usr, "security"))
									if(setcriminal != "Cancel")
										R.fields["criminal"] = setcriminal
										modified = 1

										spawn()
											BITSET(hud_updateflag, WANTED_HUD)
											if(istype(usr,/mob/living/carbon/human))
												var/mob/living/carbon/human/U = usr
												U.handle_hud_list()
											if(istype(usr,/mob/living/silicon/robot))
												var/mob/living/silicon/robot/U = usr
												U.handle_regular_hud_updates()

			if(!modified)
				to_chat(usr, "<span class='filter_notice'>[span_red("Unable to locate a data core entry for this person.")]</span>")

	if (href_list["secrecord"])
		if(hasHUD(usr,"security"))
			var/perpname = "wot"
			var/read = 0

			var/obj/item/card/id/I = GetIdCard()
			if(I)
				perpname = I.registered_name
			else
				perpname = name
			for (var/datum/data/record/E in data_core.general)
				if (E.fields["name"] == perpname)
					for (var/datum/data/record/R in data_core.security)
						if (R.fields["id"] == E.fields["id"])
							if(hasHUD(usr,"security"))
								var/list/security_hud_text = list()
								security_hud_text += "<b>Name:</b> [R.fields["name"]]	<b>Criminal Status:</b> [R.fields["criminal"]]"
								security_hud_text += "<b>Species:</b> [R.fields["species"]]"
								security_hud_text += "<b>Minor Crimes:</b> [R.fields["mi_crim"]]"
								security_hud_text += "<b>Details:</b> [R.fields["mi_crim_d"]]"
								security_hud_text += "<b>Major Crimes:</b> [R.fields["ma_crim"]]"
								security_hud_text += "<b>Details:</b> [R.fields["ma_crim_d"]]"
								security_hud_text += "<b>Notes:</b> [R.fields["notes"]]"
								security_hud_text += "<a href='?src=\ref[src];secrecordComment=`'>\[View Comment Log\]</a>"
								to_chat(usr, "<span class='filter_notice'>[jointext(security_hud_text, "<br>")]</span>")
								read = 1

			if(!read)
				to_chat(usr, "<span class='filter_notice'>[span_red("Unable to locate a data core entry for this person.")]</span>")

	if (href_list["secrecordComment"])
		if(hasHUD(usr,"security"))
			var/perpname = "wot"
			var/read = 0

			var/obj/item/card/id/I = GetIdCard()
			if(I)
				perpname = I.registered_name
			else
				perpname = name
			for (var/datum/data/record/E in data_core.general)
				if (E.fields["name"] == perpname)
					for (var/datum/data/record/R in data_core.security)
						if (R.fields["id"] == E.fields["id"])
							if(hasHUD(usr,"security"))
								read = 1
								var/counter = 1
								while(R.fields[text("com_[]", counter)])
									to_chat(usr, "[R.fields[text("com_[]", counter)]]")
									counter++
								if (counter == 1)
									to_chat(usr, "<span class='filter_notice'>No comment found.</span>")
								to_chat(usr, "<span class='filter_notice'><a href='?src=\ref[src];secrecordadd=`'>\[Add comment\]</a></span>")

			if(!read)
				to_chat(usr, "<span class='filter_notice'>[span_red("Unable to locate a data core entry for this person.")]</span>")

	if (href_list["secrecordadd"])
		if(hasHUD(usr,"security"))
			var/perpname = "wot"
			var/obj/item/card/id/I = GetIdCard()
			if(I)
				perpname = I.registered_name
			else
				perpname = name
			for (var/datum/data/record/E in data_core.general)
				if (E.fields["name"] == perpname)
					for (var/datum/data/record/R in data_core.security)
						if (R.fields["id"] == E.fields["id"])
							if(hasHUD(usr,"security"))
								var/t1 = sanitize(tgui_input_text(usr, "Add Comment:", "Sec. records", null, null, multiline = TRUE, prevent_enter = TRUE))
								if ( !(t1) || usr.stat || usr.restrained() || !(hasHUD(usr,"security")) )
									return
								var/counter = 1
								while(R.fields[text("com_[]", counter)])
									counter++
								if(istype(usr,/mob/living/carbon/human))
									var/mob/living/carbon/human/U = usr
									R.fields[text("com_[counter]")] = text("Made by [U.get_authentification_name()] ([U.get_assignment()]) on [time2text(world.realtime, "DDD MMM DD hh:mm:ss")], [game_year]<BR>[t1]")
								if(istype(usr,/mob/living/silicon/robot))
									var/mob/living/silicon/robot/U = usr
									R.fields[text("com_[counter]")] = text("Made by [U.name] ([U.modtype] [U.braintype]) on [time2text(world.realtime, "DDD MMM DD hh:mm:ss")], [game_year]<BR>[t1]")

	if (href_list["medical"])
		if(hasHUD(usr,"medical"))
			var/perpname = "wot"
			var/modified = 0

			var/obj/item/card/id/I = GetIdCard()
			if(I)
				perpname = I.registered_name
			else
				perpname = name

			for (var/datum/data/record/E in data_core.general)
				if (E.fields["name"] == perpname)
					for (var/datum/data/record/R in data_core.general)
						if (R.fields["id"] == E.fields["id"])

							var/setmedical = tgui_input_list(usr, "Specify a new medical status for this person.", "Medical HUD", list("*SSD*", "*Deceased*", "Physically Unfit", "Active", "Disabled", "Cancel"))

							if(hasHUD(usr,"medical"))
								if(setmedical != "Cancel")
									R.fields["p_stat"] = setmedical
									modified = 1
									if(PDA_Manifest.len)
										PDA_Manifest.Cut()

									spawn()
										if(istype(usr,/mob/living/carbon/human))
											var/mob/living/carbon/human/U = usr
											U.handle_regular_hud_updates()
										if(istype(usr,/mob/living/silicon/robot))
											var/mob/living/silicon/robot/U = usr
											U.handle_regular_hud_updates()

			if(!modified)
				to_chat(usr, "<span class='filter_notice'>[span_red("Unable to locate a data core entry for this person.")]</span>")

	if (href_list["medrecord"])
		if(hasHUD(usr,"medical"))
			var/perpname = "wot"
			var/read = 0

			var/obj/item/card/id/I = GetIdCard()
			if(I)
				perpname = I.registered_name
			else
				perpname = name
			for (var/datum/data/record/E in data_core.general)
				if (E.fields["name"] == perpname)
					for (var/datum/data/record/R in data_core.medical)
						if (R.fields["id"] == E.fields["id"])
							if(hasHUD(usr,"medical"))
								var/list/medical_hud_text = list()
								medical_hud_text += "<b>Name:</b> [R.fields["name"]]	<b>Blood Type:</b> [R.fields["b_type"]]	<b>Blood Basis:</b> [R.fields["blood_reagent"]]"
								medical_hud_text += "<b>Species:</b> [R.fields["species"]]"
								medical_hud_text += "<b>DNA:</b> [R.fields["b_dna"]]"
								medical_hud_text += "<b>Minor Disabilities:</b> [R.fields["mi_dis"]]"
								medical_hud_text += "<b>Details:</b> [R.fields["mi_dis_d"]]"
								medical_hud_text += "<b>Major Disabilities:</b> [R.fields["ma_dis"]]"
								medical_hud_text += "<b>Details:</b> [R.fields["ma_dis_d"]]"
								medical_hud_text += "<b>Notes:</b> [R.fields["notes"]]"
								medical_hud_text += "<a href='?src=\ref[src];medrecordComment=`'>\[View Comment Log\]</a>"
								to_chat(usr, "<span class='filter_notice'>[jointext(medical_hud_text, "<br>")]</span>")
								read = 1

			if(!read)
				to_chat(usr, "<span class='filter_notice'>[span_red("Unable to locate a data core entry for this person.")]</span>")

	if (href_list["medrecordComment"])
		if(hasHUD(usr,"medical"))
			var/perpname = "wot"
			var/read = 0

			var/obj/item/card/id/I = GetIdCard()
			if(I)
				perpname = I.registered_name
			else
				perpname = name
			for (var/datum/data/record/E in data_core.general)
				if (E.fields["name"] == perpname)
					for (var/datum/data/record/R in data_core.medical)
						if (R.fields["id"] == E.fields["id"])
							if(hasHUD(usr,"medical"))
								read = 1
								var/counter = 1
								while(R.fields[text("com_[]", counter)])
									to_chat(usr, "[R.fields[text("com_[]", counter)]]")
									counter++
								if (counter == 1)
									to_chat(usr, "<span class='filter_notice'>No comment found.</span>")
								to_chat(usr, "<span class='filter_notice'><a href='?src=\ref[src];medrecordadd=`'>\[Add comment\]</a></span>")

			if(!read)
				to_chat(usr, "<span class='filter_notice'>[span_red("Unable to locate a data core entry for this person.")]</span>")

	if (href_list["medrecordadd"])
		if(hasHUD(usr,"medical"))
			var/perpname = "wot"
			var/obj/item/card/id/I = GetIdCard()
			if(I)
				perpname = I.registered_name
			else
				perpname = name
			for (var/datum/data/record/E in data_core.general)
				if (E.fields["name"] == perpname)
					for (var/datum/data/record/R in data_core.medical)
						if (R.fields["id"] == E.fields["id"])
							if(hasHUD(usr,"medical"))
								var/t1 = sanitize(tgui_input_text(usr, "Add Comment:", "Med. records", null, null, multiline = TRUE, prevent_enter = TRUE))
								if ( !(t1) || usr.stat || usr.restrained() || !(hasHUD(usr,"medical")) )
									return
								var/counter = 1
								while(R.fields[text("com_[]", counter)])
									counter++
								if(istype(usr,/mob/living/carbon/human))
									var/mob/living/carbon/human/U = usr
									R.fields[text("com_[counter]")] = text("Made by [U.get_authentification_name()] ([U.get_assignment()]) on [time2text(world.realtime, "DDD MMM DD hh:mm:ss")], [game_year]<BR>[t1]")
								if(istype(usr,/mob/living/silicon/robot))
									var/mob/living/silicon/robot/U = usr
									R.fields[text("com_[counter]")] = text("Made by [U.name] ([U.modtype] [U.braintype]) on [time2text(world.realtime, "DDD MMM DD hh:mm:ss")], [game_year]<BR>[t1]")

	if (href_list["emprecord"])
		if(hasHUD(usr,"best"))
			var/perpname = "wot"
			var/read = 0

			var/obj/item/card/id/I = GetIdCard()
			if(I)
				perpname = I.registered_name
			else
				perpname = name
			for (var/datum/data/record/E in data_core.general)
				if (E.fields["name"] == perpname)
					for (var/datum/data/record/R in data_core.general)
						if (R.fields["id"] == E.fields["id"])
							if(hasHUD(usr,"best"))
								var/list/emp_hud_text = list()
								emp_hud_text += "<b>Name:</b> [R.fields["name"]]"
								emp_hud_text += "<b>Species:</b> [R.fields["species"]]"
								emp_hud_text += "<b>Assignment:</b> [R.fields["real_rank"]] ([R.fields["rank"]])"
								emp_hud_text += "<b>Home System:</b> [R.fields["home_system"]]"
								emp_hud_text += "<b>Birthplace:</b> [R.fields["birthplace"]]"
								emp_hud_text += "<b>Citizenship:</b> [R.fields["citizenship"]]"
								emp_hud_text += "<b>Primary Employer:</b> [R.fields["personal_faction"]]"
								emp_hud_text += "<b>Religious Beliefs:</b> [R.fields["religion"]]"
								emp_hud_text += "<b>Known Languages:</b> [R.fields["languages"]]"
								emp_hud_text += "<b>Notes:</b> [R.fields["notes"]]"
								emp_hud_text += "<a href='?src=\ref[src];emprecordComment=`'>\[View Comment Log\]</a>"
								to_chat(usr, "<span class='filter_notice'>[jointext(emp_hud_text, "<br>")]</span>")
								read = 1

			if(!read)
				to_chat(usr, "<span class='filter_notice'>[span_red("Unable to locate a data core entry for this person.")]</span>")

	if (href_list["emprecordComment"])
		if(hasHUD(usr,"best"))
			var/perpname = "wot"
			var/read = 0

			var/obj/item/card/id/I = GetIdCard()
			if(I)
				perpname = I.registered_name
			else
				perpname = name
			for (var/datum/data/record/E in data_core.general)
				if (E.fields["name"] == perpname)
					for (var/datum/data/record/R in data_core.general)
						if (R.fields["id"] == E.fields["id"])
							if(hasHUD(usr,"best"))
								read = 1
								var/counter = 1
								while(R.fields[text("com_[]", counter)])
									to_chat(usr, "[R.fields[text("com_[]", counter)]]")
									counter++
								if (counter == 1)
									to_chat(usr, "<span class='filter_notice'>No comment found.</span>")
								to_chat(usr, "<span class='filter_notice'><a href='?src=\ref[src];emprecordadd=`'>\[Add comment\]</a></span>")

			if(!read)
				to_chat(usr, "<span class='filter_notice'>[span_red("Unable to locate a data core entry for this person.")]</span>")

	if (href_list["emprecordadd"])
		if(hasHUD(usr,"best"))
			var/perpname = "wot"
			var/obj/item/card/id/I = GetIdCard()
			if(I)
				perpname = I.registered_name
			else
				perpname = name
			for (var/datum/data/record/E in data_core.general)
				if (E.fields["name"] == perpname)
					for (var/datum/data/record/R in data_core.general)
						if (R.fields["id"] == E.fields["id"])
							if(hasHUD(usr,"best"))
								var/t1 = sanitize(tgui_input_text(usr, "Add Comment:", "Emp. records", null, null, multiline = TRUE, prevent_enter = TRUE))
								if ( !(t1) || usr.stat || usr.restrained() || !(hasHUD(usr,"best")) )
									return
								var/counter = 1
								while(R.fields[text("com_[]", counter)])
									counter++
								if(istype(usr,/mob/living/carbon/human))
									var/mob/living/carbon/human/U = usr
									R.fields[text("com_[counter]")] = text("Made by [U.get_authentification_name()] ([U.get_assignment()]) on [time2text(world.realtime, "DDD MMM DD hh:mm:ss")], [game_year]<BR>[t1]")
								if(istype(usr,/mob/living/silicon/robot))
									var/mob/living/silicon/robot/U = usr
									R.fields[text("com_[counter]")] = text("Made by [U.name] ([U.modtype] [U.braintype]) on [time2text(world.realtime, "DDD MMM DD hh:mm:ss")], [game_year]<BR>[t1]")

	if (href_list["lookitem"])
		var/obj/item/I = locate(href_list["lookitem"])
		src.examinate(I)

	if (href_list["lookitem_desc_only"])
		var/obj/item/I = locate(href_list["lookitem_desc_only"])
		if(!I)
			return
		usr.examinate(I, 1)

	if (href_list["lookmob"])
		var/mob/M = locate(href_list["lookmob"])
		src.examinate(M)

	if (href_list["clickitem"])
		var/obj/item/I = locate(href_list["clickitem"])
		if(src.client)
			src.ClickOn(I)

	if (href_list["flavor_change"])
		switch(href_list["flavor_change"])
			if("done")
				src << browse(null, "window=flavor_changes")
				return
			if("general")
				var/msg = strip_html_simple(tgui_input_text(usr,"Update the general description of your character. This will be shown regardless of clothing.","Flavor Text",html_decode(flavor_texts[href_list["flavor_change"]]), multiline = TRUE, prevent_enter = TRUE))	//VOREStation Edit: separating out OOC notes
				if(msg)
					flavor_texts[href_list["flavor_change"]] = msg
					set_flavor()
				return
			else
				var/msg = strip_html_simple(tgui_input_text(usr,"Update the flavor text for your [href_list["flavor_change"]].","Flavor Text",html_decode(flavor_texts[href_list["flavor_change"]]), multiline = TRUE, prevent_enter = TRUE))
				if(msg)
					flavor_texts[href_list["flavor_change"]] = msg
					set_flavor()
				return
	..()
	return

///eyecheck()
///Returns a number between -1 to 2
/mob/living/carbon/human/eyecheck()

	var/obj/item/organ/internal/eyes/I

	if(internal_organs_by_name[O_EYES]) // Eyes are fucked, not a 'weak point'.
		I = internal_organs_by_name[O_EYES]
		if(I.is_broken())
			return FLASH_PROTECTION_MAJOR
	else if(!species.dispersed_eyes) // They can't be flashed if they don't have eyes, or widespread sensing surfaces.
		return FLASH_PROTECTION_MAJOR

	var/number = get_equipment_flash_protection()
	if(I)
		number = I.get_total_protection(number)
		I.additional_flash_effects(number)
	return number

/mob/living/carbon/human/flash_eyes(var/intensity = FLASH_PROTECTION_MODERATE, override_blindness_check = FALSE, affect_silicon = FALSE, visual = FALSE, type = /obj/screen/fullscreen/flash)
	if(internal_organs_by_name[O_EYES]) // Eyes are fucked, not a 'weak point'.
		var/obj/item/organ/internal/eyes/I = internal_organs_by_name[O_EYES]
		I.additional_flash_effects(intensity)
	return ..()

#define add_clothing_protection(A)	\
	var/obj/item/clothing/C = A; \
	flash_protection += C.flash_protection; \

/mob/living/carbon/human/proc/get_equipment_flash_protection()
	var/flash_protection = 0

	if(istype(src.head, /obj/item/clothing/head))
		add_clothing_protection(head)
	if(istype(src.glasses, /obj/item/clothing/glasses))
		add_clothing_protection(glasses)
	if(istype(src.wear_mask, /obj/item/clothing/mask))
		add_clothing_protection(wear_mask)

	return flash_protection

#undef add_clothing_protection

//Used by various things that knock people out by applying blunt trauma to the head.
//Checks that the species has a "head" (brain containing organ) and that hit_zone refers to it.
/mob/living/carbon/human/proc/headcheck(var/target_zone, var/brain_tag = "brain")

	var/obj/item/organ/affecting = internal_organs_by_name[brain_tag]

	target_zone = check_zone(target_zone)
	if(!affecting || affecting.parent_organ != target_zone)
		return 0

	//if the parent organ is significantly larger than the brain organ, then hitting it is not guaranteed
	var/obj/item/organ/parent = get_organ(target_zone)
	if(!parent)
		return 0

	if(parent.w_class > affecting.w_class + 1)
		return prob(100 / 2**(parent.w_class - affecting.w_class - 1))

	return 1

/mob/living/carbon/human/IsAdvancedToolUser(var/silent)
	// VOREstation start
	if(feral)
		to_chat(src, "<span class='warning'>Your primitive mind can't grasp the concept of that thing.</span>")
		return 0
	// VOREstation end
	if(species.has_fine_manipulation)
		return 1
	if(!silent)
		to_chat(src, "<span class='warning'>You don't have the dexterity to use that!</span>")
	return 0

/mob/living/carbon/human/abiotic(var/full_body = 0)
	if(full_body && ((src.l_hand && !( src.l_hand.abstract )) || (src.r_hand && !( src.r_hand.abstract )) || (src.back || src.wear_mask || src.head || src.shoes || src.w_uniform || src.wear_suit || src.glasses || src.l_ear || src.r_ear || src.gloves)))
		return 1

	if( (src.l_hand && !src.l_hand.abstract) || (src.r_hand && !src.r_hand.abstract) )
		return 1

	return 0


/mob/living/carbon/human/proc/check_dna()
	dna.check_integrity(src)
	return

/mob/living/carbon/human/get_species()
	if(!species)
		set_species()
	return species.name

/mob/living/carbon/human/proc/play_xylophone()
	if(!src.xylophone)
		var/datum/gender/T = gender_datums[get_visible_gender()]
		visible_message("<span class='filter_notice'>[span_red("\The [src] begins playing [T.his] ribcage like a xylophone. It's quite spooky.")]</span>","<span class='notice'>You begin to play a spooky refrain on your ribcage.</span>","<span class='filter_notice'>[span_red("You hear a spooky xylophone melody.")]</span>")
		var/song = pick('sound/effects/xylophone1.ogg','sound/effects/xylophone2.ogg','sound/effects/xylophone3.ogg')
		playsound(src, song, 50, 1, -1)
		xylophone = 1
		spawn(1200)
			xylophone=0
	return

/mob/living/proc/check_has_mouth()
	return 1

/mob/living/carbon/human/check_has_mouth()
	// Todo, check stomach organ when implemented.
	var/obj/item/organ/external/head/H = get_organ(BP_HEAD)
	if(!H || !H.can_intake_reagents)
		return 0
	return 1

/mob/living/carbon/human/proc/morph()
	set name = "Morph"
	set category = "Superpower"

	if(stat!=CONSCIOUS)
		reset_view(0)
		remoteview_target = null
		return

	if(!(mMorph in mutations))
		src.verbs -= /mob/living/carbon/human/proc/morph
		return

	var/new_facial = input(usr, "Please select facial hair color.", "Character Generation",rgb(r_facial,g_facial,b_facial)) as color
	if(new_facial)
		r_facial = hex2num(copytext(new_facial, 2, 4))
		g_facial = hex2num(copytext(new_facial, 4, 6))
		b_facial = hex2num(copytext(new_facial, 6, 8))

	var/new_hair = input(usr, "Please select hair color.", "Character Generation",rgb(r_hair,g_hair,b_hair)) as color
	if(new_facial)
		r_hair = hex2num(copytext(new_hair, 2, 4))
		g_hair = hex2num(copytext(new_hair, 4, 6))
		b_hair = hex2num(copytext(new_hair, 6, 8))

	var/new_eyes = input(usr, "Please select eye color.", "Character Generation",rgb(r_eyes,g_eyes,b_eyes)) as color
	if(new_eyes)
		r_eyes = hex2num(copytext(new_eyes, 2, 4))
		g_eyes = hex2num(copytext(new_eyes, 4, 6))
		b_eyes = hex2num(copytext(new_eyes, 6, 8))
		update_eyes()

	// hair
	var/list/all_hairs = subtypesof(/datum/sprite_accessory/hair)
	var/list/hairs = list()

	// loop through potential hairs
	for(var/x in all_hairs)
		var/datum/sprite_accessory/hair/H = new x // create new hair datum based on type x
		hairs.Add(H.name) // add hair name to hairs
		qdel(H) // delete the hair after it's all done

	var/new_style = tgui_input_list(usr, "Please select hair style", "Character Generation", hairs)

	// if new style selected (not cancel)
	if (new_style)
		h_style = new_style

	// facial hair
	var/list/all_fhairs = subtypesof(/datum/sprite_accessory/facial_hair)
	var/list/fhairs = list()

	for(var/x in all_fhairs)
		var/datum/sprite_accessory/facial_hair/H = new x
		fhairs.Add(H.name)
		qdel(H)

	new_style = tgui_input_list(usr, "Please select facial style", "Character Generation", fhairs)

	if(new_style)
		f_style = new_style

	var/new_gender = tgui_alert(usr, "Please select gender.", "Character Generation", list("Male", "Female", "Neutral"))
	if (new_gender)
		if(new_gender == "Male")
			gender = MALE
		else if(new_gender == "Female")
			gender = FEMALE
		else
			gender = NEUTER
	regenerate_icons()
	check_dna()
	var/datum/gender/T = gender_datums[get_visible_gender()]
	visible_message("<span class='notice'>\The [src] morphs and changes [T.his] appearance!</span>", "<span class='notice'>You change your appearance!</span>", "<span class='filter_notice'>[span_red("Oh, god!  What the hell was that?  It sounded like flesh getting squished and bone ground into a different shape!")]</span>")

/mob/living/carbon/human/proc/remotesay()
	set name = "Project mind"
	set category = "Superpower"

	if(stat!=CONSCIOUS)
		reset_view(0)
		remoteview_target = null
		return

	if(!(mRemotetalk in src.mutations))
		src.verbs -= /mob/living/carbon/human/proc/remotesay
		return
	var/list/creatures = list()
	for(var/mob/living/carbon/h in mob_list)
		creatures += h
	var/mob/target = tgui_input_list(usr, "Who do you want to project your mind to?", "Project Mind", creatures)
	if (isnull(target))
		return

	var/say = sanitize(tgui_input_text(usr, "What do you wish to say?"))
	if(mRemotetalk in target.mutations)
		target.show_message("<span class='filter_say'>[span_blue("You hear [src.real_name]'s voice: [say]")]</span>")
	else
		target.show_message("<span class='filter_say'>[span_blue("You hear a voice that seems to echo around the room: [say]")]</span>")
	usr.show_message("<span class='filter_say'>[span_blue("You project your mind into [target.real_name]: [say]")]</span>")
	log_say("(TPATH to [key_name(target)]) [say]",src)
	for(var/mob/observer/dead/G in mob_list)
		G.show_message("<span class='filter_say'><i>Telepathic message from <b>[src]</b> to <b>[target]</b>: [say]</i></span>")

/mob/living/carbon/human/proc/remoteobserve()
	set name = "Remote View"
	set category = "Superpower"

	if(stat!=CONSCIOUS)
		remoteview_target = null
		reset_view(0)
		return

	if(!(mRemote in src.mutations))
		remoteview_target = null
		reset_view(0)
		src.verbs -= /mob/living/carbon/human/proc/remoteobserve
		return

	if(client.eye != client.mob)
		remoteview_target = null
		reset_view(0)
		return

	var/list/mob/creatures = list()

	for(var/mob/living/carbon/h in mob_list)
		var/turf/temp_turf = get_turf(h)
		if((temp_turf.z != 1 && temp_turf.z != 5) || h.stat!=CONSCIOUS) //Not on mining or the station. Or dead
			continue
		creatures += h

	var/mob/target = input ("Who do you want to project your mind to?") as mob in creatures

	if (target)
		remoteview_target = target
		reset_view(target)
	else
		remoteview_target = null
		reset_view(0)

/mob/living/carbon/human/get_visible_gender(mob/user, force)
	switch(force)
		if(VISIBLE_GENDER_FORCE_PLURAL)
			return PLURAL
		if(VISIBLE_GENDER_FORCE_IDENTIFYING)
			return get_gender()
		if(VISIBLE_GENDER_FORCE_BIOLOGICAL)
			return gender
		else
			if(((wear_mask?.flags_inv & HIDEFACE) || (head?.flags_inv & HIDEMASK) || (head?.flags_inv & HIDEFACE)) && (wear_suit?.flags_inv & HIDEJUMPSUIT))
				return PLURAL
			if(species?.ambiguous_genders && user)
				if(ishuman(user))
					var/mob/living/carbon/human/human = user
					if(!istype(human.species, species))
						return PLURAL
				else if(!isobserver(user) && !issilicon(user))
					return PLURAL
			return get_gender()

/mob/living/carbon/human/proc/increase_germ_level(n)
	if(gloves)
		gloves.germ_level += n
	else
		germ_level += n

/mob/living/carbon/human/revive()

	if(should_have_organ(O_HEART))
		vessel.add_reagent("blood",species.blood_volume-vessel.total_volume)
		fixblood()

	species.create_organs(src) // Reset our organs/limbs.
	restore_all_organs()       // Reapply robotics/amputated status from preferences.

	if(!client || !key) //Don't boot out anyone already in the mob.
		for (var/obj/item/organ/internal/brain/H in all_brain_organs)
			if(H.brainmob)
				if(H.brainmob.real_name == src.real_name)
					if(H.brainmob.mind)
						H.brainmob.mind.transfer_to(src)
						qdel(H)

	// Vorestation Addition - reapply markings/appearance from prefs for player mobs
	if(client) //just to be sure
		client.prefs.copy_to(src)
		if(dna)
			dna.ResetUIFrom(src)
			sync_organ_dna()
	// end vorestation addition

	for (var/ID in virus2)
		var/datum/disease2/disease/V = virus2[ID]
		V.cure(src)

	losebreath = 0

	..()

/mob/living/carbon/human/proc/is_lung_ruptured()
	var/obj/item/organ/internal/lungs/L = internal_organs_by_name[O_LUNGS]
	return L && L.is_bruised()

/mob/living/carbon/human/proc/rupture_lung()
	var/obj/item/organ/internal/lungs/L = internal_organs_by_name[O_LUNGS]

	if(L)
		L.rupture()

/*
/mob/living/carbon/human/verb/simulate()
	set name = "sim"
	set background = 1

	var/damage = input(usr, "Wound damage","Wound damage") as num

	var/germs = 0
	var/tdamage = 0
	var/ticks = 0
	while (germs < 2501 && ticks < 100000 && round(damage/10)*20)
		log_misc("VIRUS TESTING: [ticks] : germs [germs] tdamage [tdamage] prob [round(damage/10)*20]")
		ticks++
		if (prob(round(damage/10)*20))
			germs++
		if (germs == 100)
			to_world("Reached stage 1 in [ticks] ticks")
		if (germs > 100)
			if (prob(10))
				damage++
				germs++
		if (germs == 1000)
			to_world("Reached stage 2 in [ticks] ticks")
		if (germs > 1000)
			damage++
			germs++
		if (germs == 2500)
			to_world("Reached stage 3 in [ticks] ticks")
	to_world("Mob took [tdamage] tox damage")
*/
//returns 1 if made bloody, returns 0 otherwise

/mob/living/carbon/human/add_blood(mob/living/carbon/human/M as mob)
	if (!..())
		return 0
	//if this blood isn't already in the list, add it
	if(istype(M))
		if(!blood_DNA[M.dna.unique_enzymes])
			blood_DNA[M.dna.unique_enzymes] = M.dna.b_type
	hand_blood_color = blood_color
	update_bloodied()
	verbs += /mob/living/carbon/human/proc/bloody_doodle
	return 1 //we applied blood to the item

/mob/living/carbon/human/proc/get_full_print()
	if(!dna ||!dna.uni_identity)
		return
	return md5(dna.uni_identity)

/mob/living/carbon/human/clean_blood(var/washshoes)
	. = ..()

	gunshot_residue = null

	//Always do hands (or whatever's on our hands)
	if(gloves)
		gloves.clean_blood()
		update_inv_gloves()
		gloves.germ_level = 0
	else
		bloody_hands = 0
		germ_level = 0

	//Sometimes do shoes if asked (or feet if no shoes)
	if(washshoes && shoes)
		shoes.clean_blood()
		update_inv_shoes()
		shoes.germ_level = 0
	else if(washshoes && (feet_blood_color || LAZYLEN(feet_blood_DNA)))
		LAZYCLEARLIST(feet_blood_DNA)
		feet_blood_DNA = null
		feet_blood_color = null

	update_bloodied()

/mob/living/carbon/human/get_visible_implants(var/class = 0)

	var/list/visible_implants = list()
	for(var/obj/item/organ/external/organ in src.organs)
		for(var/obj/item/O in organ.implants)
			if(!istype(O,/obj/item/implant) && (O.w_class > class) && !istype(O,/obj/item/material/shard/shrapnel))
				visible_implants += O

	return(visible_implants)

/mob/living/carbon/human/embedded_needs_process()
	for(var/obj/item/organ/external/organ in src.organs)
		for(var/obj/item/O in organ.implants)
			if(!istype(O, /obj/item/implant)) //implant type items do not cause embedding effects, see handle_embedded_objects()
				return 1
	return 0

/mob/living/carbon/human/proc/handle_embedded_objects()

	for(var/obj/item/organ/external/organ in src.organs)
		if(organ.splinted) //Splints prevent movement.
			continue
		for(var/obj/item/O in organ.implants)
			if(!istype(O,/obj/item/implant) && prob(5)) //Moving with things stuck in you could be bad.
				// All kinds of embedded objects cause bleeding.
				if(!can_feel_pain(organ.organ_tag))
					to_chat(src, "<span class='warning'>You feel [O] moving inside your [organ.name].</span>")
				else
					var/msg = pick( \
						"<span class='warning'>A spike of pain jolts your [organ.name] as you bump [O] inside.</span>", \
						"<span class='warning'>Your movement jostles [O] in your [organ.name] painfully.</span>", \
						"<span class='warning'>Your movement jostles [O] in your [organ.name] painfully.</span>")
					custom_pain(msg, 40)

				organ.take_damage(rand(1,3), 0, 0)
				if(!(organ.robotic >= ORGAN_ROBOT) && (should_have_organ(O_HEART))) //There is no blood in protheses.
					organ.status |= ORGAN_BLEEDING

/mob/living/carbon/human/verb/check_pulse()
	set category = "Object"
	set name = "Check pulse"
	set desc = "Approximately count somebody's pulse. Requires you to stand still at least 6 seconds."
	set src in view(1)
	var/self = 0

	if(usr.stat || usr.restrained() || !isliving(usr)) return

	var/datum/gender/TU = gender_datums[usr.get_visible_gender()]
	var/datum/gender/T = gender_datums[get_visible_gender()]

	if(usr == src)
		self = 1
	if(!self)
		usr.visible_message("<span class='notice'>[usr] kneels down, puts [TU.his] hand on [src]'s wrist and begins counting [T.his] pulse.</span>",\
		"<span class='filter_notice'>You begin counting [src]'s pulse.</span>")
	else
		usr.visible_message("<span class='notice'>[usr] begins counting [T.his] pulse.</span>",\
		"<span class='filter_notice'>You begin counting your pulse.</span>")

	if(src.pulse)
		to_chat(usr, "<span class='notice'>[self ? "You have a" : "[src] has a"] pulse! Counting...</span>")
	else
		to_chat(usr, "<span class='danger'>[src] has no pulse!</span>")	//it is REALLY UNLIKELY that a dead person would check his own pulse
		return

	to_chat(usr, "<span class='filter_notice'>You must[self ? "" : " both"] remain still until counting is finished.</span>")
	if(do_mob(usr, src, 60))
		var/message = "<span class='notice'>[self ? "Your" : "[src]'s"] pulse is [src.get_pulse(GETPULSE_HAND)].</span>"
		to_chat(usr,message)
	else
		to_chat(usr, "<span class='warning'>You failed to check the pulse. Try again.</span>")

/mob/living/carbon/human/proc/set_species(var/new_species, var/default_colour, var/regen_icons = TRUE, var/mob/living/carbon/human/example = null)	//VOREStation Edit - send an example

	if(!dna)
		if(!new_species)
			new_species = SPECIES_HUMAN
	else
		if(!new_species)
			new_species = dna.species
		else
			dna.species = new_species

	// No more invisible screaming wheelchairs because of set_species() typos.
	if(!GLOB.all_species[new_species])
		new_species = SPECIES_HUMAN

	if(species)

		if(species.name && species.name == new_species && species.name != "Custom Species") //VOREStation Edit
			return
		if(species.language)
			remove_language(species.language)
		if(species.default_language)
			remove_language(species.default_language)
		for(var/datum/language/L in species.assisted_langs)
			remove_language(L)
		// Clear out their species abilities.
		species.remove_inherent_verbs(src)
		holder_type = null
		hunger_rate = initial(hunger_rate) //VOREStation Add

	species = GLOB.all_species[new_species]

	if(species.language)
		add_language(species.language)

	if(species.default_language)
		add_language(species.default_language)

	if(species.icon_scale_x != DEFAULT_ICON_SCALE_X || species.icon_scale_y != DEFAULT_ICON_SCALE_Y)
		update_transform()

	if(example)						//VOREStation Edit begin
		if(!(example == src))
			r_skin = example.r_skin
			g_skin = example.g_skin
			b_skin = example.b_skin
	else if(species.base_color)	//VOREStation Edit end
		//Apply colour.
		r_skin = hex2num(copytext(species.base_color,2,4))
		g_skin = hex2num(copytext(species.base_color,4,6))
		b_skin = hex2num(copytext(species.base_color,6,8))
	else
		r_skin = 0
		g_skin = 0
		b_skin = 0

	if(species.holder_type)
		holder_type = species.holder_type

	if(!(gender in species.genders))
		gender = species.genders[1]

	//icon_state = lowertext(species.name) //Necessary?

	//VOREStation Edit start: swap places of those two procs
	species.handle_post_spawn(src)

	species.create_organs(src)
	//VOREStation Edit end: swap places of those two procs


	maxHealth = species.total_health
	hunger_rate = species.hunger_factor //VOREStation Add

	center_offset = species.center_offset

	if(LAZYLEN(descriptors))
		descriptors = null

	if(LAZYLEN(species.descriptors))
		descriptors = list()
		for(var/desctype in species.descriptors)
			var/datum/mob_descriptor/descriptor = species.descriptors[desctype]
			descriptors[desctype] = descriptor.default_value

	spawn(0)
		if(regen_icons) regenerate_icons()
		make_blood()
		if(vessel.total_volume < species.blood_volume)
			vessel.maximum_volume = species.blood_volume
			vessel.add_reagent("blood", species.blood_volume - vessel.total_volume)
		else if(vessel.total_volume > species.blood_volume)
			vessel.remove_reagent("blood",vessel.total_volume - species.blood_volume) //This one should stay remove_reagent to work even lack of a O_heart
			vessel.maximum_volume = species.blood_volume
		fixblood()
		species.update_attack_types() //VOREStation Edit - Required for any trait that updates unarmed_types in setup.
		species.update_vore_belly_def_variant()

	// Rebuild the HUD. If they aren't logged in then login() should reinstantiate it for them.
	update_hud()

	//A slew of bits that may be affected by our species change
	regenerate_icons()

	if(species)
		//if(mind) //VOREStation Removal
			//apply_traits() //VOREStation Removal
		return 1
	else
		return 0

/mob/living/carbon/human/proc/bloody_doodle()
	set category = "IC"
	set name = "Write in blood"
	set desc = "Use blood on your hands to write a short message on the floor or a wall, murder mystery style."

	if (src.stat)
		return

	if (usr != src)
		return 0 //something is terribly wrong

	if (!bloody_hands)
		verbs -= /mob/living/carbon/human/proc/bloody_doodle

	if (src.gloves)
		to_chat(src, "<span class='warning'>Your [src.gloves] are getting in the way.</span>")
		return

	var/turf/simulated/T = src.loc
	if (!istype(T)) //to prevent doodling out of mechs and lockers
		to_chat(src, "<span class='warning'>You cannot reach the floor.</span>")
		return

	var/direction = tgui_input_list(src,"Which way?","Tile selection", list("Here","North","South","East","West"))
	if (direction != "Here")
		T = get_step(T,text2dir(direction))
	if (!istype(T))
		to_chat(src, "<span class='warning'>You cannot doodle there.</span>")
		return

	var/num_doodles = 0
	for (var/obj/effect/decal/cleanable/blood/writing/W in T)
		num_doodles++
	if (num_doodles > 4)
		to_chat(src, "<span class='warning'>There is no space to write on!</span>")
		return

	var/max_length = bloody_hands * 30 //tweeter style

	var/message = sanitize(tgui_input_text(usr, "Write a message. It cannot be longer than [max_length] characters.","Blood writing", ""))

	if (message)
		var/used_blood_amount = round(length(message) / 30, 1)
		bloody_hands = max(0, bloody_hands - used_blood_amount) //use up some blood

		if (length(message) > max_length)
			message += "-"
			to_chat(src, "<span class='warning'>You ran out of blood to write with!</span>")

		var/obj/effect/decal/cleanable/blood/writing/W = new(T)
		W.basecolor = (hand_blood_color) ? hand_blood_color : "#A10808"
		W.update_icon()
		W.message = message
		W.add_fingerprint(src)

/mob/living/carbon/human/can_inject(var/mob/user, var/error_msg, var/target_zone, var/ignore_thickness = FALSE)
	. = 1

	if(!target_zone)
		if(!user)
			target_zone = pick(BP_TORSO,BP_TORSO,BP_TORSO,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_HEAD)
		else
			target_zone = user.zone_sel.selecting

	var/obj/item/organ/external/affecting = get_organ(target_zone)
	var/fail_msg
	if(!affecting)
		. = 0
		fail_msg = "They are missing that limb."
	else if (affecting.robotic == ORGAN_ROBOT)
		. = 0
		fail_msg = "That limb is robotic."
	else if (affecting.robotic >= ORGAN_LIFELIKE)
		. = 0
		fail_msg = "Your needle refuses to penetrate more than a short distance..."
	else if (affecting.thick_skin && prob(70 - round(affecting.brute_dam + affecting.burn_dam / 2)))	// Allows transplanted limbs with thick skin to maintain their resistance.
		. = 0
		fail_msg = "Your needle fails to penetrate \the [affecting]'s thick hide..."
	else
		switch(target_zone)
			if(BP_HEAD)
				if(head && (head.item_flags & THICKMATERIAL) && !ignore_thickness)
					. = 0
			else
				if(wear_suit && (wear_suit.item_flags & THICKMATERIAL) && !ignore_thickness)
					. = 0
	if(!. && error_msg && user)
		if(!fail_msg)
			fail_msg = "There is no exposed flesh or thin material [target_zone == BP_HEAD ? "on their head" : "on their body"] to inject into."
		to_chat(user, "<span class='alert'>[fail_msg]</span>")

/mob/living/carbon/human/print_flavor_text(var/shrink = 1)
	var/list/equipment = list(src.head,src.wear_mask,src.glasses,src.w_uniform,src.wear_suit,src.gloves,src.shoes)
	var/head_exposed = 1
	var/face_exposed = 1
	var/eyes_exposed = 1
	var/torso_exposed = 1
	var/arms_exposed = 1
	var/legs_exposed = 1
	var/hands_exposed = 1
	var/feet_exposed = 1

	for(var/obj/item/clothing/C in equipment)
		if(C.body_parts_covered & HEAD)
			head_exposed = 0
		if(C.body_parts_covered & FACE)
			face_exposed = 0
		if(C.body_parts_covered & EYES)
			eyes_exposed = 0
		if(C.body_parts_covered & UPPER_TORSO)
			torso_exposed = 0
		if(C.body_parts_covered & ARMS)
			arms_exposed = 0
		if(C.body_parts_covered & HANDS)
			hands_exposed = 0
		if(C.body_parts_covered & LEGS)
			legs_exposed = 0
		if(C.body_parts_covered & FEET)
			feet_exposed = 0

	flavor_text = ""
	for (var/T in flavor_texts)
		if(flavor_texts[T] && flavor_texts[T] != "")
			if((T == "general") || (T == "head" && head_exposed) || (T == "face" && face_exposed) || (T == "eyes" && eyes_exposed) || (T == "torso" && torso_exposed) || (T == "arms" && arms_exposed) || (T == "hands" && hands_exposed) || (T == "legs" && legs_exposed) || (T == "feet" && feet_exposed))
				flavor_text += flavor_texts[T]
				flavor_text += "\n\n"
	if(!shrink)
		return flavor_text
	else
		return ..()

/mob/living/carbon/human/getDNA()
	if(species.flags & NO_SCAN)
		return null
	if(isSynthetic())
		return
	..()

/mob/living/carbon/human/setDNA()
	if(species.flags & NO_SCAN)
		return
	if(isSynthetic())
		return
	..()

/mob/living/carbon/human/has_brain()
	if(internal_organs_by_name[O_BRAIN])
		var/obj/item/organ/brain = internal_organs_by_name[O_BRAIN]
		if(brain && istype(brain))
			return 1
	return 0

/mob/living/carbon/human/has_eyes()
	if(internal_organs_by_name[O_EYES])
		var/obj/item/organ/eyes = internal_organs_by_name[O_EYES]
		if(eyes && istype(eyes) && !(eyes.status & ORGAN_CUT_AWAY))
			return 1
	return 0

/mob/living/carbon/human/slip(var/slipped_on, stun_duration=8)
	var/list/equipment = list(src.w_uniform,src.wear_suit,src.shoes)
	var/footcoverage_check = FALSE
	for(var/obj/item/clothing/C in equipment)
		if(C.body_parts_covered & FEET)
			footcoverage_check = TRUE
			break
	if((species.flags & NO_SLIP && !footcoverage_check) || (shoes && (shoes.item_flags & NOSLIP))) //Footwear negates a species' natural traction.
		return 0
	if(..(slipped_on,stun_duration))
		return 1

/mob/living/carbon/human/proc/relocate()
	set category = "Object"
	set name = "Relocate Joint"
	set desc = "Pop a joint back into place. Extremely painful."
	set src in view(1)

	if(!isliving(usr) || !usr.checkClickCooldown())
		return

	usr.setClickCooldown(20)

	if(usr.stat > 0)
		to_chat(usr, "<span class='filter_notice'>You are unconcious and cannot do that!</span>")
		return

	if(usr.restrained())
		to_chat(usr, "<span class='filter_notice'>You are restrained and cannot do that!</span>")
		return

	var/mob/S = src
	var/mob/U = usr
	var/self = null
	if(S == U)
		self = 1 // Removing object from yourself.

	var/list/limbs = list()
	for(var/limb in organs_by_name)
		var/obj/item/organ/external/current_limb = organs_by_name[limb]
		if(current_limb && current_limb.dislocated > 0 && !current_limb.is_parent_dislocated()) //if the parent is also dislocated you will have to relocate that first
			limbs |= current_limb
	var/obj/item/organ/external/current_limb = tgui_input_list(usr, "Which joint do you wish to relocate?", "Joint Choice", limbs)

	if(!current_limb)
		return

	if(self)
		to_chat(src, "<span class='warning'>You brace yourself to relocate your [current_limb.joint]...</span>")
	else
		to_chat(U, "<span class='warning'>You begin to relocate [S]'s [current_limb.joint]...</span>")

	if(!do_after(U, 30))
		return
	if(!current_limb || !S || !U)
		return

	if(self)
		to_chat(src, "<span class='danger'>You pop your [current_limb.joint] back in!</span>")
	else
		to_chat(U, "<span class='danger'>You pop [S]'s [current_limb.joint] back in!</span>")
		to_chat(S, "<span class='danger'>[U] pops your [current_limb.joint] back in!</span>")
	current_limb.relocate()

/mob/living/carbon/human/drop_from_inventory(var/obj/item/W, var/atom/target = null)
	return !(W in organs) && ..()

/mob/living/carbon/human/reset_view(atom/A, update_hud = 1)
	..()
	if(update_hud)
		handle_regular_hud_updates()

/mob/living/carbon/human/Check_Shoegrip()
	if(shoes && (shoes.item_flags & NOSLIP) && istype(shoes, /obj/item/clothing/shoes/magboots))  //magboots + dense_object = no floating
		return 1
	if(flying) //VOREStation Edit. Checks to see if they have wings and are flying.
		return 1 //VOREStation Edit.
	return 0

//Puts the item into our active hand if possible. returns 1 on success.
/mob/living/carbon/human/put_in_active_hand(var/obj/item/W)
	return (hand ? put_in_l_hand(W) : put_in_r_hand(W))

//Puts the item into our inactive hand if possible. returns 1 on success.
/mob/living/carbon/human/put_in_inactive_hand(var/obj/item/W)
	return (hand ? put_in_r_hand(W) : put_in_l_hand(W))

/mob/living/carbon/human/put_in_hands(var/obj/item/W)
	if(!W)
		return 0
	if(put_in_active_hand(W))
		update_inv_l_hand()
		update_inv_r_hand()
		return 1
	else if(put_in_inactive_hand(W))
		update_inv_l_hand()
		update_inv_r_hand()
		return 1
	else
		return ..()

/mob/living/carbon/human/put_in_l_hand(var/obj/item/W)
	if(!..() || l_hand)
		return 0
	W.forceMove(src)
	l_hand = W
	W.equipped(src,slot_l_hand)
	W.add_fingerprint(src)
	update_inv_l_hand()
	return 1

/mob/living/carbon/human/put_in_r_hand(var/obj/item/W)
	if(!..() || r_hand)
		return 0
	W.forceMove(src)
	r_hand = W
	W.equipped(src,slot_r_hand)
	W.add_fingerprint(src)
	update_inv_r_hand()
	return 1

/mob/living/carbon/human/can_stand_overridden()
	if(wearing_rig && wearing_rig.ai_can_move_suit(check_for_ai = 1))
		// Actually missing a leg will screw you up. Everything else can be compensated for.
		for(var/limbcheck in list("l_leg","r_leg"))
			var/obj/item/organ/affecting = get_organ(limbcheck)
			if(!affecting)
				return 0
		return 1
	return 0

/mob/living/carbon/human/verb/toggle_underwear()
	set name = "Toggle Underwear"
	set desc = "Shows/hides selected parts of your underwear."
	set category = "Object"

	if(stat) return
	var/datum/category_group/underwear/UWC = tgui_input_list(usr, "Choose underwear:", "Show/hide underwear", global_underwear.categories)
	if(!UWC) return
	var/datum/category_item/underwear/UWI = all_underwear[UWC.name]
	if(!UWI || UWI.name == "None")
		to_chat(src, "<span class='notice'>You do not have [UWC.gender==PLURAL ? "[UWC.display_name]" : "a [UWC.display_name]"].</span>")
		return
	hide_underwear[UWC.name] = !hide_underwear[UWC.name]
	update_underwear(1)
	to_chat(src, "<span class='notice'>You [hide_underwear[UWC.name] ? "take off" : "put on"] your [UWC.display_name].</span>")
	return

/mob/living/carbon/human/verb/pull_punches()
	set name = "Pull Punches"
	set desc = "Try not to hurt them."
	set category = "IC"

	if(stat) return
	pulling_punches = !pulling_punches
	to_chat(src, "<span class='notice'>You are now [pulling_punches ? "pulling your punches" : "not pulling your punches"].</span>")
	return

/mob/living/carbon/human/should_have_organ(var/organ_check)

	var/obj/item/organ/external/affecting
	if(organ_check in list(O_HEART, O_LUNGS))
		affecting = organs_by_name[BP_TORSO]
	else if(organ_check in list(O_LIVER, O_KIDNEYS))
		affecting = organs_by_name[BP_GROIN]

	if(affecting && (affecting.robotic >= ORGAN_ROBOT))
		return 0
	return (species && species.has_organ[organ_check])

/mob/living/carbon/human/can_feel_pain(var/obj/item/organ/check_organ)
	if(isSynthetic())
		return 0
	//RS ADD START
	if(!digest_pain && (isbelly(src.loc) || istype(src.loc, /turf/simulated/floor/water/digestive_enzymes)))
		var/obj/belly/b = src.loc
		if(b.digest_mode == DM_DIGEST || b.digest_mode == DM_SELECT)
			return FALSE
	//RS ADD END
	for(var/datum/modifier/M in modifiers)
		if(M.pain_immunity == TRUE)
			return 0
	if(check_organ)
		if(!istype(check_organ))
			return 0
		return check_organ.organ_can_feel_pain()
	return !(species.flags & NO_PAIN)

/mob/living/carbon/human/is_sentient()
	if(get_FBP_type() == FBP_DRONE)
		return FALSE
	return ..()

/mob/living/carbon/human/is_muzzled()
	return (wear_mask && (istype(wear_mask, /obj/item/clothing/mask/muzzle) || istype(src.wear_mask, /obj/item/grenade)))

/mob/living/carbon/human/get_fire_icon_state()
	return species.fire_icon_state

// Called by job_controller.  Makes drones start with a permit, might be useful for other people later too.
/mob/living/carbon/human/equip_post_job()
	var/braintype = get_FBP_type()
	if(braintype == FBP_DRONE)
		var/turf/T = get_turf(src)
		var/obj/item/clothing/accessory/permit/drone/permit = new(T)
		permit.set_name(real_name)
		equip_to_appropriate_slot(permit) // If for some reason it can't find room, it'll still be on the floor.

/mob/living/carbon/human/proc/update_icon_special() //For things such as teshari hiding and whatnot.
	if(status_flags & HIDING) // Hiding? Carry on.
		if(stat == DEAD || paralysis || weakened || stunned || restrained() || buckled || LAZYLEN(grabbed_by) || has_buckled_mobs()) //stunned/knocked down by something that isn't the rest verb? Note: This was tried with INCAPACITATION_STUNNED, but that refused to work. //VORE EDIT: Check for has_buckled_mobs() (taur riding)
			reveal(null)
		else
			layer = HIDING_LAYER

/mob/living/carbon/human/examine_icon()
	var/icon/I = get_cached_examine_icon(src)
	if(!I)
		I = getFlatIcon(src, defdir = SOUTH, no_anim = TRUE)
		set_cached_examine_icon(src, I, 50 SECONDS)
	return I

/mob/living/carbon/human/proc/get_display_species()
	//Shows species in tooltip
	if(src.custom_species) //VOREStation Add
		return custom_species //VOREStation Add
	//Beepboops get special text if obviously beepboop
	if(looksSynthetic())
		if(gender == MALE)
			return "Android"
		else if(gender == FEMALE)
			return "Gynoid"
		else
			return "Synthetic"
	//Else species name
	if(species)
		return species.get_examine_name()
	//Else CRITICAL FAILURE!
	return ""

/mob/living/carbon/human/get_nametag_name(mob/user)
	return name //Could do fancy stuff here?

/mob/living/carbon/human/get_nametag_desc(mob/user)
	var/msg = ""
	if(hasHUD(user,"security"))
		//Try to find their name
		var/perpname
		var/obj/item/card/id/I = GetIdCard()
		if(I)
			perpname = I.registered_name
		else
			perpname = name
		//Try to find their record
		var/criminal = "None"
		if(perpname)
			var/datum/data/record/G = find_general_record("name", perpname)
			if(G)
				var/datum/data/record/S = find_security_record("id", G.fields["id"])
				if(S)
					criminal = S.fields["criminal"]
		//If it's interesting, append
		if(criminal != "None")
			msg += "([criminal]) "

	if(hasHUD(user,"medical"))
		msg += "(Health: [round((health/getMaxHealth())*100)]%) "

	msg += get_display_species()
	return msg

/mob/living/carbon/human/reduce_cuff_time()
	if(istype(gloves, /obj/item/clothing/gloves/gauntlets/rig))
		return 2
	return ..()

/mob/living/carbon/human/pull_damage()
	if(((health - halloss) <= config.health_threshold_softcrit))
		for(var/name in organs_by_name)
			var/obj/item/organ/external/e = organs_by_name[name]
			if(!e)
				continue
			if((e.status & ORGAN_BROKEN && (!e.splinted || (e.splinted in e.contents && prob(30))) || e.status & ORGAN_BLEEDING) && (getBruteLoss() + getFireLoss() >= 100))
				return 1
	else
		return ..()

// Drag damage is handled in a parent
/mob/living/carbon/human/dragged(var/mob/living/dragger, var/oldloc)
	var/area/A = get_area(src)
	if(lying && !buckled && A.has_gravity() && prob(getBruteLoss() * 200 / maxHealth))
		var/bloodtrail = 1
		if(species?.flags & NO_BLOOD)
			bloodtrail = 0
		else
			var/blood_volume = vessel.get_reagent_amount("blood")
			if(blood_volume < species?.blood_volume*species?.blood_level_fatal)
				bloodtrail = 0	//Most of it's gone already, just leave it be
			else
				remove_blood(1)
		if(bloodtrail)
			if(istype(loc, /turf/simulated))
				var/turf/T = loc
				T.add_blood(src)
	. = ..()

// Tries to turn off item-based things that let you see through walls, like mesons.
// Certain stuff like genetic xray vision is allowed to be kept on.
/mob/living/carbon/human/disable_spoiler_vision()
	// Glasses.
	if(istype(glasses, /obj/item/clothing/glasses))
		var/obj/item/clothing/glasses/goggles = glasses
		if(goggles.active && (goggles.vision_flags & (SEE_TURFS|SEE_OBJS)))
			goggles.toggle_active(src)
			to_chat(src, span("warning", "Your [goggles.name] have suddenly turned off!"))

	// RIGs.
	var/obj/item/rig/rig = get_rig()
	if(istype(rig) && rig.visor?.active && rig.visor.vision?.glasses)
		var/obj/item/clothing/glasses/rig_goggles = rig.visor.vision.glasses
		if(rig_goggles.vision_flags & (SEE_TURFS|SEE_OBJS))
			rig.visor.deactivate()
			to_chat(src, span("warning", "\The [rig]'s visor has shuddenly deactivated!"))

	..()

/mob/living/carbon/human/get_mob_riding_slots()
	return list(back, head, wear_suit)

/mob/living/carbon/human/proc/update_fullness()
	var/list/new_fullness = list()
	vore_fullness = 0
	for(var/belly_class in vore_icon_bellies)
		new_fullness[belly_class] = 0
	for(var/obj/belly/B as anything in vore_organs)
		new_fullness[B.belly_sprite_to_affect] += B.GetFullnessFromBelly()
	for(var/belly_class in vore_icon_bellies)
		new_fullness[belly_class] /= size_multiplier //Divided by pred's size so a macro mob won't get macro belly from a regular prey.
		new_fullness[belly_class] = round(new_fullness[belly_class], 1) // Because intervals of 0.25 are going to make sprite artists cry.
		vore_fullness_ex[belly_class] = min(vore_capacity_ex[belly_class], new_fullness[belly_class])
		vore_fullness += new_fullness[belly_class]
	vore_fullness = min(vore_capacity, vore_fullness)
	update_vore_belly_sprite()
	update_vore_tail_sprite()

/mob/living/carbon/human/verb/lay_down_left()
	set name = "Rest-Left"

	rest_dir = -1
	resting = !resting
	to_chat(src, "<span class='notice'>You are now [resting ? "resting" : "getting up"].</span>")
	update_canmove()

/mob/living/carbon/human/verb/lay_down_right()
	set name = "Rest-Right"

	rest_dir = 1
	resting = !resting
	to_chat(src, "<span class='notice'>You are now [resting ? "resting" : "getting up"].</span>")
	update_canmove()
