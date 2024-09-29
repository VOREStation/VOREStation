/obj/machinery/protean_reconstitutor
	name = "protean reconstitutor"
	desc = "A complex machine that is most definitely <i>not</i> just a large tub into which one pours a large amount of untethered nanites, then adds a protean positronic brain and orchestrator, in order to reconstitute a disintegrated protean... it's complicated, really!"
	description_info = "Use a protean positronic brain, orchestrator, refactory, and nanopaste to \'fill\' the machine, then interact with it once it's ready. Protean components can be retrieved using a wrench, but any nanopaste inserted will be converted, cannot be reclaimed, and will be lost if the machine is disassembled!"
	icon = 'icons/obj/protean_recon.dmi'
	icon_state = "recon-nopower"
	var/state_base = "recon"
	anchored = TRUE
	density = TRUE
	power_channel = EQUIP
	use_power = USE_POWER_IDLE
	idle_power_usage = 10
	active_power_usage = 1000
	var/processing_revive = FALSE
	clicksound = 'sound/machines/buttonbeep.ogg'	//standard initialization sound
	var/dingsound = 'sound/machines/kitchen/microwave/microwave-end.ogg'	//sound to play when the process is complete
	var/buzzsound = 'sound/items/nif_tone_bad.ogg'	//sound to play when we have to abort due to loss of posibrain client

	//vars for basic functionality
	var/obj/item/mmi/digital/posibrain/nano/protean_brain = null	//only allow protean brains, no midround upgrades to bypass the whitelist!
	var/obj/item/organ/internal/nano/orchestrator/protean_orchestrator = null	//essential
	var/obj/item/organ/internal/nano/refactory/protean_refactory = null	//not essential, but nice to have; lets us transfer stored materials
	var/nanomass_reserve = 0		//starting reserve - will be wiped if it's deconstructed!
	var/nanotank_max = 300			//how much we can store at once, higher = better
	var/nanomass_required = 150		//how much we need in order to make a new body, non-adjustable
	var/paste_inefficiency = 5		//divisor to mech_repair value of paste added; higher = less effective; adv paste is +40 reserve at base, or +200 at max!

	//time vars
	var/base_cook_time = 150 SECONDS	//how long to initially delay before starting the overall cooking cycle
	var/per_organ_delay = 5 SECONDS	//how long to delay the cycle per organ and per synch step (multiply by three to get time for all three organs), then add base cook time for total time
	var/finalize_time = 135 SECONDS	//finally, how long we need before popping them out of the tank

	//component vars
	circuit = /obj/item/circuitboard/protean_reconstitutor

/obj/machinery/protean_reconstitutor/Initialize()
	component_parts = list()
	component_parts += new /obj/item/stock_parts/matter_bin(src)
	component_parts += new /obj/item/stock_parts/manipulator(src)
	component_parts += new /obj/item/stock_parts/console_screen(src)
	component_parts += new /obj/item/stack/cable_coil(src, 5)
	RefreshParts()
	. = ..()

/obj/machinery/protean_reconstitutor/RefreshParts()
	//total paste storage cap (300 * the rating, straightforward)
	var/store_rating = initial(nanotank_max)
	for(var/obj/item/stock_parts/matter_bin/MB in component_parts)
		store_rating = store_rating * MB.rating
	nanotank_max = store_rating

	//inefficiency of adding paste (amount of uses * (mech_repair / inefficiency)); most complex, good way to get good bang for your buck tho
	var/paste_rating = initial(paste_inefficiency)
	for(var/obj/item/stock_parts/manipulator/M in component_parts)
		paste_rating = paste_rating - (M.rating - 1)
	paste_inefficiency = paste_rating
	..()

/obj/machinery/protean_reconstitutor/update_icon()
	cut_overlays()
	if(stat & (NOPOWER|BROKEN) || !anchored)
		if(stat & BROKEN)
			icon_state = "[state_base]-broken"
		else
			icon_state = "[state_base]-nopower"
		return
	icon_state = state_base
	if(protean_brain)
		add_overlay("[state_base]-brain")
	if(protean_orchestrator)
		add_overlay("[state_base]-orchestrator")
	if(protean_refactory)
		add_overlay("[state_base]-refactory")
	if(nanomass_reserve >= nanomass_required)
		add_overlay("[state_base]-tank_full")

/obj/machinery/protean_reconstitutor/examine()
	. = ..()
	if(protean_refactory)
		. += "A protean refactory is present."
	if(protean_orchestrator)
		. += "A protean orchestrator is present."
	if(protean_brain)
		. += "It currently has a protean positronic brain."
		if(!protean_brain.brainmob.client)
			. += "<span class='warning'>The positronic brain appears to be inactive!</span>"
	. += "The readout shows that it has [nanomass_reserve] units of nanites ready for use. It requires [nanomass_required] per \'revive\' process, and has a maximum capacity of [nanotank_max] units."

/obj/machinery/protean_reconstitutor/attackby(obj/item/W as obj, mob/user as mob)
	src.add_fingerprint(user)
	if(processing_revive)
		to_chat(user, "<span class='notice'>\The [src] is busy. Please wait for completion of previous operation.</span>")
		playsound(src, buzzsound, 100, 1, -1)
		return

	if(default_deconstruction_screwdriver(user, W))
		return
	if(default_deconstruction_crowbar(user, W))
		return
	if(default_part_replacement(user, W))
		return

	if(istype(W,/obj/item/mmi/digital/posibrain/nano))
		var/obj/item/mmi/digital/posibrain/nano/NB = W
		if(!NB.brainmob.client)
			to_chat(user,"<span class='warning'>You cannot use an inactive positronic brain for this process.</span>")
			return
		to_chat(user,"<span class='notice'>You slot \the [NB] into \the [src].</span>")
		user.drop_from_inventory(NB)
		NB.loc = src
		protean_brain = NB

	if(istype(W,/obj/item/organ/internal/nano/orchestrator))
		to_chat(user,"<span class='notice'>You slot \the [W] into \the [src].</span>")
		user.drop_from_inventory(W)
		W.loc = src
		protean_orchestrator = W

	if(istype(W,/obj/item/organ/internal/nano/refactory))
		to_chat(user,"<span class='notice'>You slot \the [W] into \the [src].</span>")
		user.drop_from_inventory(W)
		W.loc = src
		protean_refactory = W

	if(istype(W,/obj/item/stack/nanopaste))
		var/obj/item/stack/nanopaste/NP = W
		if(nanomass_reserve >= nanotank_max)
			to_chat(user,"<span class='notice'>The tank is full!</span>")
			return
		nanomass_reserve += NP.amount * max(1,NP.mech_repair / paste_inefficiency)
		if(nanomass_reserve > nanotank_max)
			nanomass_reserve = nanotank_max
		to_chat(user,"<span class='notice'>You fill \the [src] with paste from \the [NP]. The display now reads [nanomass_reserve]/[nanotank_max] units.</span>")
		qdel(NP)

	if(W.has_tool_quality(TOOL_WRENCH))
		if(protean_brain || protean_orchestrator || protean_refactory)
			var/choice = tgui_input_list(usr, "What component would you like to remove?", "Remove Component", list(protean_brain,protean_orchestrator,protean_refactory))
			if(!choice) return

			if(choice == protean_brain)
				to_chat(user, "You fish \the [protean_brain] out of \the [src].")
				protean_brain.forceMove(get_turf(src))
				playsound(src, W.usesound, 50, 1)
				src.protean_brain = null
			if(choice == protean_refactory)
				to_chat(user, "You fish \the [protean_refactory] out of \the [src].")
				protean_refactory.forceMove(get_turf(src))
				playsound(src, W.usesound, 50, 1)
				src.protean_refactory = null
			else if(choice == protean_orchestrator)
				to_chat(user, "You fish \the [protean_orchestrator] out of \the [src].")
				protean_orchestrator.forceMove(get_turf(src))
				playsound(src, W.usesound, 50, 1)
				src.protean_orchestrator = null
		else
			to_chat(user, "\The [src] does not have any protean components you can retrieve.")

	update_icon()
	..()

/obj/machinery/protean_reconstitutor/attack_hand(mob/user as mob)
	if(!protean_brain || !protean_orchestrator || !protean_refactory || (nanomass_reserve < nanomass_required))
		//no brain, no orchestrator, and/or not enough goo
		to_chat(user,"<span class='warning'>Essential components missing, or insufficient materials available!</span>")
		playsound(src, buzzsound, 100, 1, -1)
		update_icon()
		return
	if(processing_revive)
		//we're currently processing a patient, chill out!
		src.visible_message("<span class='notice'>\The [src] chirps, \"Reconstitution cycle currently in progress, please wait!\"</span>")
		playsound(src, buzzsound, 100, 1, -1)
		return
	if(!protean_brain.brainmob.client)
		src.visible_message("<span class='warning'>\The [src] chirps, \"Warning, no positronic neural network activity detected! Recommend removing inactive core.\"</span>")
		return
	else if(!processing_revive && protean_brain && protean_orchestrator && protean_refactory && (nanomass_reserve >= nanomass_required))
		//we're good, let's get recombobulating!
		src.visible_message("<span class='notice'>[user] initializes \the [src]. It chirps, \"Please stand by, synchronizing components... estimated time to completion: five minutes.\"</span>")
		processing_revive = TRUE
		power_change()
		if(prob(2))
			playsound(src, 'sound/machines/blender.ogg', 50, 1)
		else
			playsound(src, clicksound, 50, 1)
		nanomass_reserve -= nanomass_required
		sleep(base_cook_time)
		var/mob/living/carbon/human/protean/P = new /mob/living/carbon/human/protean
		var/mats_cached
		var/list/materials_cache
		P.loc = src
		P.name = "Unfinished Protean"
		P.real_name = "Unfinished Protean"
		for(var/organ in P.internal_organs_by_name)
			sleep(per_organ_delay)
			var/obj/item/O = P.internal_organs_by_name[organ]
			if(istype(O,/obj/item/organ/internal/nano/refactory))
				src.visible_message("<span class='notice'>\The [src] chirps, \"Initializing refactory...\"</span>")
				P.internal_organs_by_name.Remove(O)
				P.contents.Remove(O)
				qdel(O)
				P.internal_organs_by_name.Add(list(O_FACT = protean_refactory))
				P.internal_organs.Add(protean_refactory)
				//cache our mats otherwise they get wiped by the revive
				materials_cache = protean_refactory.materials.Copy()
				mats_cached = TRUE
				protean_refactory.loc = P
			if(istype(O,/obj/item/organ/internal/nano/orchestrator))
				src.visible_message("<span class='notice'>\The [src] chirps, \"Linking nanoswarm to orchestrator...\"</span>")
				P.internal_organs_by_name.Remove(O)
				P.internal_organs.Remove(O)
				P.contents.Remove(O)
				qdel(O)
				P.internal_organs_by_name.Add(list(O_ORCH = protean_orchestrator))
				P.internal_organs.Add(protean_orchestrator)
				protean_orchestrator.loc = P
			if(istype(O,/obj/item/organ/internal/mmi_holder/posibrain/nano))
				src.visible_message("<span class='notice'>\The [src] chirps, \"Synchronizing positronic neural architecture...\"</span>")
				//on the offchance our client blipped before getting to this step, abort, schloop the organs back into the machine, dissolve the body, and refund the nanos
				if(!protean_brain.brainmob.client)
					src.visible_message("<span class='warning'>\The [src] buzzes, \"No positronic neural activity detected! Aborting cycle!\"</span>")
					playsound(src, buzzsound, 100, 1, -1)
					processing_revive = FALSE
					qdel(P)
					nanomass_reserve += nanomass_required
					update_icon()
					return
				var/obj/item/organ/internal/mmi_holder/posibrain/nano/BR = O
				BR.stored_mmi = null	//toss the dummy...
				BR.contents.Cut()
				BR.stored_mmi = protean_brain	//...and implant the salvaged mmi in its place
				BR.contents.Add(protean_brain)
				var/client/posibrain_client = protean_brain.brainmob.client
				var/picked_ckey = posibrain_client.ckey
				var/picked_slot = posibrain_client.prefs.default_slot
				var/charjob
				var/datum/data/record/record_found
				record_found = find_general_record("name",posibrain_client.prefs.real_name)
				if(record_found)
					charjob = record_found.fields["real_rank"]
				else
					return
				if(P.dna)
					P.dna.ResetUIFrom(P)
					P.sync_organ_dna()

				if(P.mind)
					P.mind.loaded_from_ckey = picked_ckey
					P.mind.loaded_from_slot = picked_slot
					var/datum/antagonist/antag_data = get_antag_data(P.mind.special_role)
					if(antag_data)
						antag_data.add_antagonist(P.mind)
						antag_data.place_mob(P)
					P.mind.assigned_role = charjob
					P.mind.role_alt_title = job_master.GetPlayerAltTitle(P, charjob)

				//no need to be particularly thorough about language handover, we can safely assume that they were allowed to have it if they had it to begin with
				P.languages.Cut()
				P.languages = protean_brain.brainmob.languages.Copy()

				for(var/key in posibrain_client.prefs.language_custom_keys)
					if(posibrain_client.prefs.language_custom_keys[key])
						var/datum/language/keylang = GLOB.all_languages[posibrain_client.prefs.language_custom_keys[key]]
						if(keylang)
							P.language_keys[key] = keylang

				if(posibrain_client.prefs.preferred_language)
					var/datum/language/def_lang = GLOB.all_languages[posibrain_client.prefs.preferred_language]
					if(def_lang)
						P.default_language = def_lang

				protean_brain.brainmob.mind.transfer_to(P)
				protean_brain.loc = BR
		protean_refactory = null
		protean_brain = null
		protean_orchestrator = null
		sleep(finalize_time)	//let 'em cook a tiny bit longer
		P.revive()
		P.apply_vore_prefs()
		//run a little revive, load their prefs, and boot a new NIF on them for the finishing touches and cleanup... (yes, we need to initialize a new NIF, they don't get one from the revive process)
		//using revive is honestly a bit overkill since it kinda deletes-and-replaces most of the guts anyway (hence the cache and restore of refactory contents; otherwise they get wiped!), but it also ensures the new protean comes out in their "base form" as well as hopefully cleaning up any loose ends in the resurrection process
		var/obj/item/nif/protean/new_nif = new()
		new_nif.quick_implant(P)
		//revive complete, now restore the cached mats (if we had any)
		if(mats_cached == TRUE)
			src.visible_message("<span class='notice'>\The [src] chirps, \"Reindexing archived refactory materials storage.\"</span>")
			for(var/organ in P.internal_organs_by_name)
				var/obj/item/O = P.internal_organs_by_name[organ]
				if(istype(O,/obj/item/organ/internal/nano/refactory))
					var/obj/item/organ/internal/nano/refactory/RF = O
					RF.materials = materials_cache.Copy()
					materials_cache.Cut()
					mats_cached = FALSE
		//finally... drop them in front of the machine
		src.visible_message("<span class='notice'>\The [src] chirps, \"Protean reconstitution cycle complete!\"</span>")
		to_chat(P,"<span class='notice'>You feel your sense of self expanding, spreading out to inhabit your new \'body\'. You feel... <i><b>ALIVE!</b></i></span>")
		playsound(src, dingsound, 100, 1, -1)	//soup's on!
		P.loc = src.loc
		processing_revive = FALSE
		update_icon()
	update_icon()
