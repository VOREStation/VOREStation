/obj/machinery/protean_reconstitutor
	name = "protean reconstitutor"
	desc = "A complex machine that is most definitely <i>not</i> just a large tub into which one pours a large amount of untethered nanites, then adds a protean positronic brain and orchestrator, in order to reconstitute a disintegrated protean... it's complicated, really!"
	description_info = "Use a protean positronic brain, orchestrator, optionally a refactory, and nanopaste to \'fill\' the machine, then interact with it once it's ready. Protean components can be retrieved using a wrench, but any nanopaste inserted will be converted and cannot be reclaimed!"
	icon = 'icons/obj/protean_recon.dmi'
	icon_state = "recon-nopower"
	var/state_base = "recon"
	anchored = TRUE
	density = TRUE
	power_channel = EQUIP
	use_power = USE_POWER_IDLE
	idle_power_usage = 10
	active_power_usage = 1000
	clicksound = 'sound/machines/buttonbeep.ogg'
	var/dingsound = 'sound/machines/kitchen/microwave/microwave-end.ogg'

	//vars for basic functionality
	var/obj/item/device/mmi/digital/posibrain/nano/protean_brain = null	//only allow protean brains
	var/obj/item/organ/internal/nano/orchestrator/protean_orchestrator = null
	var/obj/item/organ/internal/nano/refactory/protean_refactory = null //not essential, but nice to have; lets us transfer stored materials
	var/nanomass_reserve = 0		//starting reserve
	var/nanotank_max = 300			//how much we can store at once, todo: upgradable
	var/nanomass_required = 60		//how much we need in order to make a new body, base
	var/nanomass_efficiency = 1		//multiplier to nanomass required, todo: upgradable
	var/paste_inefficiency = 5		//divisor to mech_repair value of paste added; higher = less effective

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
	if(nanomass_reserve >= nanomass_required * nanomass_efficiency)
		add_overlay("[state_base]-tank_full")

/obj/machinery/protean_reconstitutor/examine()
	. = ..()
	if(protean_refactory)
		. += "A protean refactory appears to be present."
	if(protean_brain && !protean_orchestrator)
		. += "It currently has a protean positronic brain ready, but still needs an orchestrator."
	else if(protean_orchestrator && !protean_brain)
		. += "It currently has an orchestrator ready, but lacks a protean positronic brain."
	else if(protean_orchestrator && protean_brain)
		. += "It currently has both a positronic brain and orchestrator ready!"
	else
		. += "It currently lacks both a positronic brain and orchestrator."
	. += "The readout shows that it has [nanomass_reserve] units of nanites ready for use. It requires [nanomass_required * nanomass_efficiency] per \'revive\' process, and has a maximum capacity of [nanotank_max] units."

/obj/machinery/protean_reconstitutor/attackby(obj/item/W as obj, mob/user as mob)
	src.add_fingerprint(user)

	if(istype(W,/obj/item/device/mmi/digital/posibrain/nano))
		var/obj/item/device/mmi/digital/posibrain/nano/NB = W
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
	return ..()

/obj/machinery/protean_reconstitutor/attack_hand(mob/user as mob)
	if(!protean_brain || !protean_orchestrator || (nanomass_reserve < (nanomass_required * nanomass_efficiency)))
		to_chat(user,"<span class='warning'>Essential components missing, or insufficient materials available!</span>")
		update_icon()
		return
	else if(protean_brain && protean_orchestrator && (nanomass_reserve > (nanomass_required * nanomass_efficiency)))
		//we're good, let's get recombobulating!
		src.visible_message("<span class='notice'>[user] initializes \the [src]. It chirps, \"Please stand by, synchronizing components... estimated time to completion: 1 minute.\"</span>")
		power_change()
		if(prob(2))
			playsound(src, 'sound/machines/blender.ogg', 50, 1)
		nanomass_reserve -= nanomass_required * nanomass_efficiency
		sleep(20 SECONDS)	//1 minute default, testing placeholder
		var/mob/living/carbon/human/protean/P = new /mob/living/carbon/human/protean
		var/mats_cached
		var/list/materials_cache
		P.loc = src
		for(var/organ in P.internal_organs_by_name)
			var/obj/item/O = P.internal_organs_by_name[organ]
			if(istype(O,/obj/item/organ/internal/nano/refactory))
				if(protean_refactory)	//if we have a refactory present, install it, otherwise they get a free replacement (for now; perhaps no free replacement but they can be made printable at the prosfab?)
					src.visible_message("<span class='notice>\The [src] chirps, \"Reinitializing refactory...\"</span>")
					P.internal_organs_by_name.Remove(O)
					P.contents.Remove(O)
					qdel(O)
					P.internal_organs_by_name.Add(list(O_FACT = protean_refactory))
					P.internal_organs.Add(protean_refactory)
					materials_cache = protean_refactory.materials.Copy()
					mats_cached = TRUE
					protean_refactory.loc = P
					protean_refactory = null
					src.visible_message("<span class='notice>\The [src] chirps, \"Refactory reboot complete...\"</span>")
				else
					src.visible_message("<span class='notice>\The [src] chirps, \"No refactory detected in storage, fabricating replacement...\"</span>")
					continue
			if(istype(O,/obj/item/organ/internal/nano/orchestrator))
				src.visible_message("<span class='notice>\The [src] chirps, \"Linking nanoswarm to orchestrator...\"</span>")
				P.internal_organs_by_name.Remove(O)
				P.internal_organs.Remove(O)
				P.contents.Remove(O)
				qdel(O)
				P.internal_organs_by_name.Add(list(O_ORCH = protean_orchestrator))
				P.internal_organs.Add(protean_orchestrator)
				protean_orchestrator.loc = P
				protean_orchestrator = null
				src.visible_message("<span class='notice>\The [src] chirps, \"Secure nanoswarm network established...\"</span>")
			if(istype(O,/obj/item/organ/internal/mmi_holder/posibrain/nano))
				src.visible_message("<span class='notice>\The [src] chirps, \"Synchronizing positronic neural architecture...\"</span>")
				var/obj/item/organ/internal/mmi_holder/posibrain/nano/BR = O
				BR.stored_mmi = null	//toss the dummy...
				BR.contents.Cut()
				BR.stored_mmi = protean_brain	//...and implant the salvaged mmi in its place
				BR.contents.Add(protean_brain)
				P.ckey = protean_brain.brainmob.ckey
				P.mind = protean_brain.brainmob.mind
				P.client = protean_brain.brainmob.client
				protean_brain.loc = BR
				protean_brain = null
				src.visible_message("<span class='notice>\The [src] chirps, \"Neural architecture [BR.stored_mmi.brainmob.name] synchronized to network...\"</span>")
		//run a little revive and boot a new NIF on them for the finishing touches and cleanup...
		P.revive()
		if(mats_cached == TRUE)
			for(var/organ in P.internal_organs_by_name)
				var/obj/item/O = P.internal_organs_by_name[organ]
				if(istype(O,/obj/item/organ/internal/nano/refactory))
					var/obj/item/organ/internal/nano/refactory/RF = O
					src.visible_message("<span class='notice>\The [src] chirps, \"Refactory storage indexing complete...\"</span>")
					RF.materials = materials_cache.Copy()
					materials_cache.Cut()
					mats_cached = FALSE
		var/obj/item/device/nif/protean/new_nif = new()
		new_nif.quick_implant(P)
		//finally... drop them in front of the machine!
		sleep(1 SECOND)
		src.visible_message("<span class='notice>\The [src] chirps, \"Protean reconstitution cycle complete!\"</span>")
		playsound(src, dingsound, 100, 1, -1)	//soup's on!
		P.loc = src.loc
		update_icon()
	update_icon()
