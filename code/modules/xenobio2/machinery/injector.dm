/*
	This file contains:

	Manual Injector:
	Manually injects chemicals into a xenobiological creature from a linked machine.

*/
/obj/machinery/xenobio2/manualinjector
	name = "biological injector"
	desc = "Injects biological organisms that are inserted with the contents of an inserted beaker at the command of a remote computer."
	density = TRUE
	anchored = TRUE
	use_power = USE_POWER_IDLE
	icon = 'icons/obj/biogenerator.dmi'
	icon_state = "biogen-work"
	var/mob/living/occupant
	var/obj/item/reagent_containers/glass/beaker
	var/obj/machinery/computer/xenobio2/computer

	circuit = /obj/item/circuitboard/xenobioinjectormachine

/obj/machinery/xenobio2/manualinjector/Initialize()
	. = ..()
	var/datum/reagents/R = new/datum/reagents(1000)
	reagents = R
	R.my_atom = src
	beaker = new /obj/item/reagent_containers/glass/beaker(src)
	default_apply_parts()

/obj/machinery/xenobio2/manualinjector/update_icon()
	if(beaker)
		if(occupant)
			icon_state = "biogen-stand"
		else
			icon_state = "biogen-work"
	else
		icon_state = "biogen-empty"

/obj/machinery/xenobio2/manualinjector/MouseDrop_T(mob/target, mob/user)
	if(user.stat || user.restrained())
		return
	move_into_injector(user,target)

/obj/machinery/xenobio2/manualinjector/proc/move_into_injector(var/mob/user,var/mob/living/victim)
	if(src.occupant)
		to_chat(user, span_danger("The injector is full, empty it first!"))
		return

	if(!(istype(victim, /mob/living/simple_mob/xeno)) && !emagged)
		to_chat(user, span_danger("This is not a suitable subject for the injector!"))
		return

	user.visible_message(span_danger("[user] starts to put [victim] into the injector!"))
	src.add_fingerprint(user)
	if(do_after(user, 30) && victim.Adjacent(src) && user.Adjacent(src) && victim.Adjacent(user) && !occupant)
		user.visible_message(span_danger("[user] stuffs [victim] into the injector!"))
		if(victim.client)
			victim.client.perspective = EYE_PERSPECTIVE
			victim.client.eye = src
		victim.forceMove(src)
		src.occupant = victim

/obj/machinery/xenobio2/manualinjector/proc/eject_contents()
	eject_xeno()
	eject_beaker()
	return

/obj/machinery/xenobio2/manualinjector/proc/eject_xeno()
	if(occupant)
		occupant.forceMove(loc)
		occupant = null

/obj/machinery/xenobio2/manualinjector/proc/eject_beaker()
	if(beaker)
		var/obj/item/reagent_containers/glass/beaker/B = beaker
		B.loc = loc
		beaker = null

/obj/machinery/xenobio2/manualinjector/proc/inject_reagents()
	if(!occupant)
		return
	if(isxeno(occupant))
		var/mob/living/simple_mob/xeno/X = occupant
		beaker.reagents.trans_to_holder(X.reagents, computer.transfer_amount, 1, 0)
	else
		beaker.reagents.trans_to_mob(occupant, computer.transfer_amount)

/obj/machinery/xenobio2/manualinjector/attackby(var/obj/item/W, var/mob/user)

	//Let's try to deconstruct first.
	if(W.has_tool_quality(TOOL_SCREWDRIVER))
		default_deconstruction_screwdriver(user, W)
		return

	if(W.has_tool_quality(TOOL_CROWBAR) && !occupant)
		default_deconstruction_crowbar(user, W)
		return

	//are you smashing a beaker in me? Well then insert that shit!
	if(istype(W, /obj/item/reagent_containers/glass/beaker))
		beaker = W
		user.drop_from_inventory(W)
		W.loc = src
		return

	//Did you want to link it?
	if(istype(W, /obj/item/multitool))
		var/obj/item/multitool/P = W
		if(P.connectable)
			if(istype(P.connectable, /obj/machinery/computer/xenobio2))
				var/obj/machinery/computer/xenobio2/C = P.connectable
				computer = C
				C.injector = src
				to_chat(user, span_warning(" You link the [src] to the [P.connectable]!"))
		else
			to_chat(user, span_warning(" You store the [src] in the [P]'s buffer!"))
			P.connectable = src
		return

	if(panel_open)
		to_chat(user, span_warning("Close the panel first!"))

	var/obj/item/grab/G = W

	if(!istype(G))
		return ..()

	if(G.state < 2)
		to_chat(user, span_danger("You need a better grip to do that!"))
		return

	move_into_injector(user,G.affecting)


/obj/item/circuitboard/xenobioinjectormachine
	name = T_BOARD("biological injector")
	build_path = /obj/machinery/xenobio2/manualinjector
	board_type = /datum/frame/frame_types/machine
	origin_tech = list()	//To be filled,
	req_components = list()	//To be filled,
