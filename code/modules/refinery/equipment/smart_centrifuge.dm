/obj/machinery/smart_centrifuge
	name = "smart centrifuge"
	desc = "Isolates various compounds and stores them in chemical cartridges."
	icon = 'icons/obj/hydroponics_machines_vr.dmi'
	icon_state = "sextractor"
	density = TRUE
	anchored = TRUE
	circuit = /obj/item/circuitboard/smart_centrifuge

	var/working = FALSE

/obj/machinery/smart_centrifuge/Initialize(mapload)
	. = ..()
	create_reagents(CARGOTANKER_VOLUME)
	flags |= OPENCONTAINER
	default_apply_parts()

/obj/machinery/smart_centrifuge/attackby(var/obj/item/O as obj, var/mob/user as mob)
	if(in_use)
		to_chat(user, "<span class='notice'>\The [src] is still spinning.</span>")
		return
	if(default_deconstruction_screwdriver(user, O))
		update_icon()
		return

	if(default_deconstruction_crowbar(user, O))
		return

	if(default_unfasten_wrench(user, O, 20))
		return

	return ..()

/obj/machinery/smart_centrifuge/attack_hand(mob/user)
	spin_reagents(user,FALSE)

/obj/machinery/smart_centrifuge/verb/isolate_reagents()
	set name = "Isolate Reagents Automatically"
	set category = "Object"
	set src in view(1)
	spin_reagents(usr,FALSE,FALSE)

/obj/machinery/smart_centrifuge/verb/isolate_reagents_bottle()
	set name = "Isolate Reagents To Bottles"
	set category = "Object"
	set src in view(1)
	spin_reagents(usr,TRUE,FALSE)

/obj/machinery/smart_centrifuge/verb/isolate_reagents_canisters()
	set name = "Isolate Reagents To Canisters"
	set category = "Object"
	set src in view(1)
	spin_reagents(usr,FALSE,TRUE)

/obj/machinery/smart_centrifuge/proc/spin_reagents(mob/user, var/force_bottle, var/force_canister)
	if(working)
		to_chat(user, "<span class='notice'>\The [src] is still spinning.</span>")
		return
	else if(reagents.reagent_list.len == 0)
		to_chat(user, "<span class='notice'>\The [src] is empty.</span>")
		return
	else
		playsound(src, 'sound/machines/buttonbeep.ogg', 50, 1)
		playsound(src, 'sound/machines/airpumpidle.ogg', 100, 1)
		to_chat(user, "<span class='notice'>You activate \the [src].</span>")
		working = TRUE
		flags ^= OPENCONTAINER
	addtimer(CALLBACK(src, PROC_REF(internal_reagent_seperate),force_canister,force_bottle), 10 SECONDS, TIMER_DELETE_ME)

/obj/machinery/smart_centrifuge/proc/internal_reagent_seperate(var/force_canister,var/force_bottle)
	if(reagents.reagent_list.len <= 0)
		visible_message("\The [src] finishes processing.")
		playsound(src, 'sound/machines/biogenerator_end.ogg', 50, 1)
		playsound(src, 'sound/machines/buttonbeep.ogg', 50, 1)
		working = FALSE
		flags |= OPENCONTAINER
		return

	// Seperate out reagents
	for(var/datum/reagent/RL in reagents.reagent_list)
		// Handle special bottle types
		if(!RL.volume)
			continue
		var/obj/item/reagent_containers/CD
		if(force_canister || (RL.volume >= 500 && !force_bottle))
			CD = new /obj/item/reagent_containers/chem_canister(src)
			var/obj/item/reagent_containers/chem_canister/CHEM = CD
			CHEM.set_canister(RL.name,RL.id)
		else
			CD = new /obj/item/reagent_containers/glass/bottle(src)
			CD.name = "[RL.name] bottle"
			CD.icon_state = "bottle-1"
		// Transfer if possible
		playsound(src, 'sound/machines/reagent_dispense.ogg', 25, 1)
		reagents.trans_id_to( CD, RL.id, min(RL.volume,CD.reagents.maximum_volume), TRUE)
		CD.update_icon()
		CD.forceMove(loc) // Drop it outside
		CD.pixel_x = rand(-7, 7) // random position
		CD.pixel_y = rand(-7, 7)
		break
	addtimer(CALLBACK(src, PROC_REF(internal_reagent_seperate),force_canister,force_bottle), 1 SECOND, TIMER_DELETE_ME)

/obj/machinery/smart_centrifuge/MouseDrop_T(var/atom/movable/C, mob/user as mob)
	if(user.buckled || user.stat || user.restrained() || !Adjacent(user) || !user.Adjacent(C) || !istype(C) || (user == C && !user.canmove))
		return
	if(istype(C,/obj/vehicle/train/trolley_tank))
		// Drain it!
		C.reagents.trans_to_holder( src.reagents, src.reagents.maximum_volume)
		visible_message("\The [user] drains \the [C] into \the [src].")
		return
	. = ..()

/obj/machinery/smart_centrifuge/examine(mob/user, infix, suffix)
	. = ..()
	. += "The meter shows [reagents.total_volume]u / [reagents.maximum_volume]u."
	for(var/datum/reagent/RL in reagents.reagent_list)
		. += "[RL.name]: [RL.volume]u."
