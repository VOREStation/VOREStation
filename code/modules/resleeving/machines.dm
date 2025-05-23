////////////////////////////////
//// Machines required for body printing
//// and decanting into bodies
////////////////////////////////

/////// Grower Pod ///////
/obj/machinery/clonepod/transhuman
	name = "grower pod"
	catalogue_data = list(/datum/category_item/catalogue/technology/resleeving)
	circuit = /obj/item/circuitboard/transhuman_clonepod

//A full version of the pod
/obj/machinery/clonepod/transhuman/full/Initialize(mapload)
	. = ..()
	for(var/i = 1 to container_limit)
		containers += new /obj/item/reagent_containers/glass/bottle/biomass(src)

/obj/machinery/clonepod/transhuman/growclone(var/datum/transhuman/body_record/current_project)
	//Manage machine-specific stuff.
	if(mess || attempting)
		return 0
	attempting = 1 //One at a time!!
	locked = 1
	eject_wait = 1
	spawn(30)
		eject_wait = 0

	// Remove biomass when the cloning is started, rather than when the guy pops out
	remove_biomass(CLONE_BIOMASS)

	//Get the DNA and generate a new mob
	var/datum/dna2/record/R = current_project.mydna
	var/mob/living/carbon/human/H = new /mob/living/carbon/human(src, R.dna.species)
	if(current_project.locked)
		if(current_project.ckey)
			H.resleeve_lock = current_project.ckey
		else
			// Ensure even body scans without an attached ckey respect locking
			H.resleeve_lock = "@badckey"

	//Fix the external organs
	for(var/part in current_project.limb_data)

		var/status = current_project.limb_data[part]
		if(status == null) continue //Species doesn't have limb? Child of amputated limb?

		var/obj/item/organ/external/O = H.organs_by_name[part]
		if(!O) continue //Not an organ. Perhaps another amputation removed it already.

		if(status == 1) //Normal limbs
			continue
		else if(status == 0) //Missing limbs
			O.remove_rejuv()
		else if(status) //Anything else is a manufacturer
			O.remove_rejuv() //Don't robotize them, leave them removed so robotics can attach a part.

	//Look, this machine can do this because [reasons] okay?!
	for(var/part in current_project.organ_data)

		var/status = current_project.organ_data[part]
		if(status == null) continue //Species doesn't have organ? Child of missing part?

		var/obj/item/organ/I = H.internal_organs_by_name[part]
		if(!I) continue//Not an organ. Perhaps external conversion changed it already?

		if(status == 0) //Normal organ
			continue
		else if(status == 1) //Assisted organ
			I.mechassist()
		else if(status == 2) //Mechanical organ
			I.robotize()
		else if(status == 3) //Digital organ
			I.digitize()


	occupant = H

	//Set the name or generate one
	if(!R.dna.real_name)
		R.dna.real_name = "clone ([rand(0,999)])"
	H.real_name = R.dna.real_name

	//Apply DNA
	qdel_swap(H.dna, R.dna.Clone())
	H.original_player = current_project.ckey

	//Apply genetic modifiers
	for(var/modifier_type in R.genetic_modifiers)
		H.add_modifier(modifier_type)

	//Apply legs
	H.digitigrade = R.dna.digitigrade // ensure clone mob has digitigrade var set appropriately
	if(H.dna.digitigrade <> R.dna.digitigrade)
		H.dna.digitigrade = R.dna.digitigrade // ensure cloned DNA is set appropriately from record??? for some reason it doesn't get set right despite the override to datum/dna/Clone()

	//Apply damage
	H.adjustCloneLoss((H.getMaxHealth() - CONFIG_GET(number/health_threshold_dead))*-0.75)
	H.Paralyse(4)
	H.updatehealth()

	//Update appearance, remake icons
	H.UpdateAppearance()
	H.sync_dna_traits(FALSE) // Traitgenes Sync traits to genetics if needed
	H.sync_organ_dna()
	H.regenerate_icons()
	H.initialize_vessel()

	// Traitgenes Moved breathing equipment to AFTER the genes set it
	//Give breathing equipment if needed
	if(current_project.breath_type != null && current_project.breath_type != GAS_O2)
		H.equip_to_slot_or_del(new /obj/item/clothing/mask/breath(H), slot_wear_mask)
		var/obj/item/tank/tankpath
		if(current_project.breath_type == GAS_PHORON)
			tankpath = /obj/item/tank/vox
		else
			tankpath = text2path("/obj/item/tank/" + current_project.breath_type)

		if(tankpath)
			H.equip_to_slot_or_del(new tankpath(H), slot_back)
			H.internal = H.back
			if(istype(H.internal,/obj/item/tank) && H.internals)
				H.internals.icon_state = "internal1"

	//Basically all the VORE stuff
	H.ooc_notes = current_project.body_oocnotes
	H.ooc_notes_likes = current_project.body_ooclikes
	H.ooc_notes_dislikes = current_project.body_oocdislikes
	H.flavor_texts = current_project.mydna.flavor.Copy()
	H.resize(current_project.sizemult, FALSE)
	H.appearance_flags = current_project.aflags
	H.weight = current_project.weight
	if(current_project.speciesname)
		H.custom_species = current_project.speciesname

	//Suiciding var
	H.suiciding = 0

	//Making double-sure this is not set
	H.mind = null

	//Machine specific stuff at the end
	update_icon()
	attempting = 0
	return 1

/obj/machinery/clonepod/transhuman/process()
	if(stat & NOPOWER)
		if(occupant)
			locked = 0
			go_out()
		return

	if((occupant) && (occupant.loc == src))
		if(occupant.stat == DEAD)
			locked = 0
			go_out()
			connected_message("Clone Rejected: Deceased.")
			return

		else if(occupant.health < heal_level && occupant.getCloneLoss() > 0)

			 //Slowly get that clone healed and finished.
			occupant.adjustCloneLoss(-3 * heal_rate)

			//Premature clones may have brain damage.
			occupant.adjustBrainLoss(-(CEILING((0.5*heal_rate), 1)))

			//So clones don't die of oxyloss in a running pod.
			if(occupant.reagents.get_reagent_amount(REAGENT_ID_INAPROVALINE) < 30)
				occupant.reagents.add_reagent(REAGENT_ID_INAPROVALINE, 60)

			//Also heal some oxyloss ourselves because inaprovaline is so bad at preventing it!!
			occupant.adjustOxyLoss(-4)

			use_power(7500) //This might need tweaking.
			return

		else if(((occupant.health == occupant.maxHealth)) && (!eject_wait))
			playsound(src, 'sound/machines/ding.ogg', 50, 1)
			audible_message("\The [src] signals that the growing process is complete.", runemessage = "ding")
			connected_message("Growing Process Complete.")
			locked = 0
			go_out()
			return

	else if((!occupant) || (occupant.loc != src))
		occupant = null
		if(locked)
			locked = 0
		update_icon()
		return

	return

/obj/machinery/clonepod/transhuman/get_completion()
	if(occupant)
		return 100 * ((occupant.health + abs(CONFIG_GET(number/health_threshold_dead))) / (occupant.maxHealth + abs(CONFIG_GET(number/health_threshold_dead))))
	return 0

/obj/machinery/clonepod/transhuman/examine(mob/user, infix, suffix)
	. = ..()
	if(occupant)
		var/completion = get_completion()
		. += "Progress: [round(completion)]% [chat_progress_bar(round(completion), TRUE)]"

//Synthetic version
/obj/machinery/transhuman/synthprinter
	name = "SynthFab 3000"
	desc = "A rapid fabricator for synthetic bodies."
	catalogue_data = list(/datum/category_item/catalogue/technology/resleeving)
	icon = 'icons/obj/machines/synthpod.dmi'
	icon_state = "pod_0"
	circuit = /obj/item/circuitboard/transhuman_synthprinter
	density = TRUE
	anchored = TRUE

	var/list/stored_material =  list(MAT_STEEL = 30000, MAT_GLASS = 30000)
	var/connected      //What console it's done up with
	var/busy = 0       //Busy cloning
	var/body_cost = 15000  //Cost of a cloned body (metal and glass ea.)
	var/max_res_amount = 30000 //Max the thing can hold
	var/datum/transhuman/body_record/current_project
	var/broken = 0
	var/burn_value = 0 //Setting these to 0, if resleeving as organic with unupgraded sleevers gives them no damage, resleeving synths with unupgraded synthfabs should not give them potentially 105 damage.
	var/brute_value = 0

/obj/machinery/transhuman/synthprinter/Initialize(mapload)
	. = ..()
	component_parts = list()
	component_parts += new /obj/item/stock_parts/matter_bin(src)
	component_parts += new /obj/item/stock_parts/scanning_module(src)
	component_parts += new /obj/item/stock_parts/manipulator(src)
	component_parts += new /obj/item/stock_parts/manipulator(src)
	component_parts += new /obj/item/stack/cable_coil(src, 2)
	RefreshParts()
	update_icon()

/obj/machinery/transhuman/synthprinter/RefreshParts()

	//Scanning modules reduce burn rating by 15 each
	var/burn_rating = initial(burn_value)
	for(var/obj/item/stock_parts/scanning_module/SM in component_parts)
		burn_rating = burn_rating - (SM.rating*15)
	burn_value = burn_rating

	//Manipulators reduce brute by 10 each
	var/brute_rating = initial(burn_value)
	for(var/obj/item/stock_parts/manipulator/M in component_parts)
		brute_rating = brute_rating - (M.rating*10)
	brute_value = brute_rating

	//Matter bins multiply the storage amount by their rating.
	var/store_rating = initial(max_res_amount)
	for(var/obj/item/stock_parts/matter_bin/MB in component_parts)
		store_rating = store_rating * MB.rating
	max_res_amount = store_rating

/obj/machinery/transhuman/synthprinter/process()
	if(stat & NOPOWER)
		if(busy)
			busy = 0
			current_project = null
		update_icon()
		return

	if(busy > 0 && busy <= 95)
		busy += 5

	if(busy >= 100)
		make_body()

	return

/obj/machinery/transhuman/synthprinter/proc/print(var/datum/transhuman/body_record/BR)
	if(!istype(BR) || busy)
		return 0

	if(stored_material[MAT_STEEL] < body_cost || stored_material[MAT_GLASS] < body_cost)
		return 0

	current_project = BR
	busy = 5
	update_icon()

	return 1

/obj/machinery/transhuman/synthprinter/proc/make_body()
	//Manage machine-specific stuff
	if(!current_project)
		busy = 0
		update_icon()
		return

	//Get the DNA and generate a new mob
	var/datum/dna2/record/R = current_project.mydna
	var/mob/living/carbon/human/H = new /mob/living/carbon/human(src, R.dna.species)
	if(current_project.locked)
		if(current_project.ckey)
			H.resleeve_lock = current_project.ckey
		else
			// Ensure even body scans without an attached ckey respect locking
			H.resleeve_lock = "@badckey"

	//Fix the external organs
	for(var/part in current_project.limb_data)

		var/status = current_project.limb_data[part]
		if(status == null) continue //Species doesn't have limb? Child of amputated limb?

		var/obj/item/organ/external/O = H.organs_by_name[part]
		if(!O) continue //Not an organ. Perhaps another amputation removed it already.

		if(status == 1) //Normal limbs
			continue
		else if(status == 0) //Missing limbs
			O.remove_rejuv()
		else if(status) //Anything else is a manufacturer
			O.robotize(status)

	//Then the internal organs
	for(var/part in current_project.organ_data)

		var/status = current_project.organ_data[part]
		if(status == null) continue //Species doesn't have organ? Child of missing part?

		var/obj/item/organ/I = H.internal_organs_by_name[part]
		if(!I) continue//Not an organ. Perhaps external conversion changed it already?

		if(status == 0) //Normal organ
			continue
		else if(status == 1) //Assisted organ
			I.mechassist()
		else if(status == 2) //Mechanical organ
			I.robotize()
		else if(status == 3) //Digital organ
			I.digitize()

	//Set the name or generate one
	if(!R.dna.real_name)
		R.dna.real_name = "synth ([rand(0,999)])"
	H.real_name = R.dna.real_name

	//Apply DNA
	qdel_swap(H.dna, R.dna.Clone())
	H.original_player = current_project.ckey

	//Apply legs
	H.digitigrade = R.dna.digitigrade // ensure clone mob has digitigrade var set appropriately
	if(H.dna.digitigrade <> R.dna.digitigrade)
		H.dna.digitigrade = R.dna.digitigrade // ensure cloned DNA is set appropriately from record??? for some reason it doesn't get set right despite the override to datum/dna/Clone()

	//Apply damage
	H.adjustBruteLoss(brute_value)
	H.adjustFireLoss(burn_value)
	H.updatehealth()

	//Update appearance, remake icons
	H.UpdateAppearance()
	H.sync_dna_traits(FALSE) // Traitgenes Sync traits to genetics if needed
	H.sync_organ_dna()
	H.regenerate_icons()
	H.initialize_vessel()

	//Basically all the VORE stuff
	H.ooc_notes = current_project.body_oocnotes
	H.ooc_notes_likes = current_project.body_ooclikes
	H.ooc_notes_dislikes = current_project.body_oocdislikes
	H.flavor_texts = current_project.mydna.flavor.Copy()
	H.resize(current_project.sizemult)
	H.appearance_flags = current_project.aflags
	H.weight = current_project.weight
	if(current_project.speciesname)
		H.custom_species = current_project.speciesname

	//Suiciding var
	H.suiciding = 0

	//Making double-sure this is not set
	H.mind = null

	//Plonk them here.
	H.regenerate_icons()
	H.loc = get_turf(src)

	//Machine specific stuff at the end
	stored_material[MAT_STEEL] -= body_cost
	stored_material[MAT_GLASS] -= body_cost
	busy = 0
	update_icon()

	return 1

/obj/machinery/transhuman/synthprinter/attack_hand(mob/user)
	if((busy == 0) || (stat & NOPOWER))
		return
	to_chat(user, "Current print cycle is [busy]% complete.")
	return

/obj/machinery/transhuman/synthprinter/attackby(obj/item/W, mob/user)
	src.add_fingerprint(user)
	if(busy)
		to_chat(user, span_notice("\The [src] is busy. Please wait for completion of previous operation."))
		return
	if(default_deconstruction_screwdriver(user, W))
		return
	if(default_deconstruction_crowbar(user, W))
		return
	if(default_part_replacement(user, W))
		return
	if(panel_open)
		to_chat(user, span_notice("You can't load \the [src] while it's opened."))
		return
	if(!istype(W, /obj/item/stack/material))
		to_chat(user, span_notice("You cannot insert this item into \the [src]!"))
		return

	var/obj/item/stack/material/S = W
	if(!(S.material.name in stored_material))
		to_chat(user, span_warning("\The [src] doesn't accept [S.material]!"))
		return

	var/amnt = S.perunit
	if(stored_material[S.material.name] + amnt <= max_res_amount)
		if(S && S.get_amount() >= 1)
			var/count = 0
			while(stored_material[S.material.name] + amnt <= max_res_amount && S.get_amount() >= 1)
				stored_material[S.material.name] += amnt
				S.use(1)
				count++
			to_chat(user, "You insert [count] [S.name] into \the [src].")
	else
		to_chat(user, "\the [src] cannot hold more [S.name].")

	updateUsrDialog(user)
	return

/obj/machinery/transhuman/synthprinter/update_icon()
	..()
	icon_state = "pod_0"
	if(busy && !(stat & NOPOWER))
		icon_state = "pod_1"
	else if(broken)
		icon_state = "pod_g"

/////// Resleever Pod ///////
/obj/machinery/transhuman/resleever
	name = "resleeving pod"
	desc = "Used to combine mind and body into one unit."
	catalogue_data = list(/datum/category_item/catalogue/technology/resleeving)
	icon = 'icons/obj/machines/implantchair.dmi'
	icon_state = "implantchair"
	circuit = /obj/item/circuitboard/transhuman_resleever
	density = TRUE
	opacity = 0
	anchored = TRUE
	var/blur_amount
	var/confuse_amount

	var/mob/living/carbon/human/occupant = null
	var/connected = null

	var/sleevecards = 2

/obj/machinery/transhuman/resleever/Initialize(mapload)
	. = ..()
	component_parts = list()
	component_parts += new /obj/item/stock_parts/scanning_module(src)
	component_parts += new /obj/item/stock_parts/scanning_module(src)
	component_parts += new /obj/item/stock_parts/manipulator(src)
	component_parts += new /obj/item/stock_parts/manipulator(src)
	component_parts += new /obj/item/stock_parts/console_screen(src)
	component_parts += new /obj/item/stack/cable_coil(src, 2)
	RefreshParts()
	update_icon()

/obj/machinery/transhuman/resleever/RefreshParts()
	var/scan_rating = 0
	for(var/obj/item/stock_parts/scanning_module/SM in component_parts)
		scan_rating += SM.rating
	confuse_amount = (48 - scan_rating * 8)

	var/manip_rating = 0
	for(var/obj/item/stock_parts/manipulator/M in component_parts)
		manip_rating += M.rating
	blur_amount = (48 - manip_rating * 8)

/obj/machinery/transhuman/resleever/attack_hand(mob/user as mob)
	tgui_interact(user)

/obj/machinery/transhuman/resleever/tgui_interact(mob/user, datum/tgui/ui = null)
	if(stat & (NOPOWER|BROKEN))
		return

	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "ResleevingPod", "Resleever")
		ui.open()

/obj/machinery/transhuman/resleever/tgui_data(mob/user)
	var/list/data = list()

	data["occupied"] = !!occupant
	if(occupant)
		data["name"] = occupant.name
		data["health"] = occupant.health
		data["maxHealth"] = occupant.maxHealth
		data["stat"] = occupant.stat
		data["mindStatus"] = !!occupant.mind
		data["mindName"] = occupant.mind?.name
	return data

/obj/machinery/transhuman/resleever/attackby(obj/item/W, mob/user)
	src.add_fingerprint(user)
	if(default_deconstruction_screwdriver(user, W))
		return
	if(default_deconstruction_crowbar(user, W))
		return
	if(default_part_replacement(user, W))
		return
	if(istype(W, /obj/item/grab))
		var/obj/item/grab/G = W
		if(!ismob(G.affecting))
			return
		var/mob/M = G.affecting
		if(put_mob(M))
			qdel(G)
			src.updateUsrDialog(user)
			return //Don't call up else we'll get attack messsages
	if(istype(W, /obj/item/paicard/sleevecard))
		var/obj/item/paicard/sleevecard/C = W
		user.unEquip(C)
		C.removePersonality()
		qdel(C)
		sleevecards++
		to_chat(user, span_notice("You store \the [C] in \the [src]."))
		return

	return ..()

/obj/machinery/transhuman/resleever/MouseDrop_T(mob/living/carbon/O, mob/user)
	if(!istype(O))
		return 0 //not a mob
	if(user.incapacitated())
		return 0 //user shouldn't be doing things
	if(O.anchored)
		return 0 //mob is anchored???
	if(get_dist(user, src) > 1 || get_dist(user, O) > 1)
		return 0 //doesn't use adjacent() to allow for non-cardinal (fuck my life)
	if(!ishuman(user) && !isrobot(user))
		return 0 //not a borg or human
	if(panel_open)
		to_chat(user, span_notice("Close the maintenance panel first."))
		return 0 //panel open

	if(O.buckled)
		return 0
	if(O.has_buckled_mobs())
		to_chat(user, span_warning("\The [O] has other entities attached to it. Remove them first."))
		return

	if(put_mob(O))
		if(O == user)
			updateUsrDialog(user)
			visible_message("[user] climbs into \the [src].")
		else
			updateUsrDialog(user)
			visible_message("[user] puts [O] into \the [src].")

	add_fingerprint(user)

/obj/machinery/transhuman/resleever/proc/putmind(var/datum/transhuman/mind_record/MR, mode = 1, var/mob/living/carbon/human/override = null, var/db_key)
	if((!occupant || !istype(occupant) || occupant.stat >= DEAD) && mode == 1)
		return 0

	if(mode == 2 && sleevecards) //Card sleeving
		var/obj/item/paicard/sleevecard/card = new /obj/item/paicard/sleevecard(get_turf(src))
		card.sleeveInto(MR, db_key = db_key)
		sleevecards--
		return 1

	//If we're sleeving a subtarget, briefly swap them to not need to duplicate tons of code.
	var/mob/living/carbon/human/original_occupant
	if(override)
		original_occupant = occupant
		occupant = override

	//In case they already had a mind!
	if(occupant && occupant.mind)
		to_chat(occupant, span_warning("You feel your mind being overwritten..."))
		log_and_message_admins("was resleeve-wiped from their body.",occupant.mind)
		occupant.ghostize()

	//Attach as much stuff as possible to the mob.
	for(var/datum/language/L in MR.languages)
		occupant.add_language(L.name)
	MR.mind_ref.active = 1 //Well, it's about to be.
	MR.mind_ref.transfer_to(occupant) //Does mind+ckey+client.
	occupant.identifying_gender = MR.id_gender
	occupant.ooc_notes = MR.mind_oocnotes
	occupant.ooc_notes_likes = MR.mind_ooclikes
	occupant.ooc_notes_dislikes = MR.mind_oocdislikes

	occupant.apply_vore_prefs() //Cheap hack for now to give them SOME bellies.
	if(MR.one_time)
		var/how_long = round((world.time - MR.last_update)/10/60)
		to_chat(occupant, span_danger("Your mind backup was a 'one-time' backup. \
		You will not be able to remember anything since the backup, [how_long] minutes ago."))

	//Re-supply a NIF if one was backed up with them.
	if(MR.nif_path)
		var/obj/item/nif/nif = new MR.nif_path(occupant,null,MR.nif_savedata)
		spawn(0)			//Delay to not install software before NIF is fully installed
			for(var/path in MR.nif_software)
				new path(nif)
		nif.durability = MR.nif_durability //Restore backed up durability after restoring the softs.

	// If it was a custom sleeve (not owned by anyone), update namification sequences
	if(!occupant.original_player)
		occupant.real_name = occupant.mind.name
		occupant.name = occupant.real_name
		occupant.dna.real_name = occupant.real_name

	//Give them a backup implant
	var/obj/item/implant/backup/new_imp = new()
	if(new_imp.handle_implant(occupant, BP_HEAD))
		new_imp.post_implant(occupant)

	//Inform them and make them a little dizzy.
	if(confuse_amount + blur_amount <= 16)
		to_chat(occupant, span_notice("You feel a small pain in your head as you're given a new backup implant. Your new body feels comfortable already, however."))
	else
		to_chat(occupant, span_warning("You feel a small pain in your head as you're given a new backup implant. Oh, and a new body. It's disorienting, to say the least."))

	occupant.confused = max(occupant.confused, confuse_amount)									// Apply immedeate effects
	occupant.eye_blurry = max(occupant.eye_blurry, blur_amount)

	// Vore deaths get a fake modifier labeled as such
	if(!occupant.mind)
		log_debug("[occupant] didn't have a mind to check for vore_death, which may be problematic.")

	if(occupant.mind && occupant.original_player && ckey(occupant.mind.key) != occupant.original_player)
		log_and_message_admins("is now a cross-sleeved character. Body originally belonged to [occupant.real_name]. Mind is now [occupant.mind.name].",occupant)

	if(original_occupant)
		occupant = original_occupant

	playsound(src, 'sound/machines/medbayscanner1.ogg', 100, 1) // Play our sound at the end of the mind injection!
	return 1

/obj/machinery/transhuman/resleever/proc/go_out(var/mob/M)
	if(!( src.occupant ))
		return
	if (src.occupant.client)
		src.occupant.client.eye = src.occupant.client.mob
		src.occupant.client.perspective = MOB_PERSPECTIVE
	src.occupant.loc = src.loc
	src.occupant = null
	icon_state = "implantchair"
	return

/obj/machinery/transhuman/resleever/proc/put_mob(mob/living/carbon/human/M)
	if(!ishuman(M))
		to_chat(usr, span_warning("\The [src] cannot hold this!"))
		return
	if(src.occupant)
		to_chat(usr, span_warning("\The [src] is already occupied!"))
		return
	if(M.client)
		M.client.perspective = EYE_PERSPECTIVE
		M.client.eye = src
	M.stop_pulling()
	M.loc = src
	src.occupant = M
	src.add_fingerprint(usr)
	icon_state = "implantchair_on"
	return 1

/obj/machinery/transhuman/resleever/verb/get_out()
	set name = "EJECT Occupant"
	set category = "Object"
	set src in oview(1)
	if(usr.stat != 0)
		return
	src.go_out(usr)
	add_fingerprint(usr)
	return

/obj/machinery/transhuman/resleever/verb/move_inside()
	set name = "Move INSIDE"
	set category = "Object"
	set src in oview(1)
	if(usr.stat != 0 || stat & (NOPOWER|BROKEN))
		return
	put_mob(usr)
	return
