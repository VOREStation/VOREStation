/obj/machinery/sleep_console
	name = "Sleeper Console"
	icon = 'icons/obj/Cryogenic2.dmi'
	icon_state = "sleeperconsole"
	var/obj/machinery/sleeper/sleeper
	anchored = 1 //About time someone fixed this.
	density = 0
	dir = 8
	use_power = 1
	idle_power_usage = 40
	interact_offline = 1
	circuit = /obj/item/weapon/circuitboard/sleeper_console

/obj/machinery/sleep_console/New()
	..()
	findsleeper()

/obj/machinery/sleep_console/proc/findsleeper()
	spawn(5)
		var/obj/machinery/sleeper/sleepernew = null
		for(dir in list(NORTH, EAST, SOUTH, WEST)) // Loop through every direction
			sleepernew = locate(/obj/machinery/sleeper, get_step(src, dir)) // Try to find a scanner in that direction
		if(sleepernew)
			sleeper = sleepernew
			sleepernew.console = src
		return

/obj/machinery/sleep_console/attack_ai(var/mob/user)
	return attack_hand(user)

/obj/machinery/sleep_console/attack_hand(var/mob/user)
	if(..())
		return 1

	if(sleeper.panel_open)
		user << "<span class='notice'>Close the maintenance panel first.</span>"
		return

	if(!sleeper)
		findsleeper()
		if(sleeper)
			return sleeper.ui_interact(user)
	else if(sleeper)
		return sleeper.ui_interact(user)
	else
		user << "<span class='warning'>Sleeper not found!</span>"

/obj/machinery/sleep_console/attackby(var/obj/item/I, var/mob/user)
	if(computer_deconstruction_screwdriver(user, I))
		return
	else
		return attack_hand(user)

/obj/machinery/sleep_console/power_change()
	..()
	if(stat & (NOPOWER|BROKEN))
		icon_state = "sleeperconsole-p"
	else
		icon_state = initial(icon_state)

/obj/machinery/sleeper
	name = "sleeper"
	desc = "A fancy bed with built-in injectors, a dialysis machine, and a limited health scanner."
	icon = 'icons/obj/Cryogenic2.dmi'
	icon_state = "sleeper_0"
	density = 1
	anchored = 1
	circuit = /obj/item/weapon/circuitboard/sleeper
	var/mob/living/carbon/human/occupant = null
	var/list/available_chemicals = list("inaprovaline" = "Inaprovaline", "stoxin" = "Soporific", "paracetamol" = "Paracetamol", "anti_toxin" = "Dylovene", "dexalin" = "Dexalin")
	var/obj/item/weapon/reagent_containers/glass/beaker = null
	var/filtering = 0
	var/obj/machinery/sleep_console/console

	use_power = 1
	idle_power_usage = 15
	active_power_usage = 200 //builtin health analyzer, dialysis machine, injectors.

/obj/machinery/sleeper/New()
	..()
	beaker = new /obj/item/weapon/reagent_containers/glass/beaker/large(src)
	component_parts = list()
	component_parts += new /obj/item/weapon/stock_parts/scanning_module(src)
	component_parts += new /obj/item/weapon/reagent_containers/glass/beaker(src)
	component_parts += new /obj/item/weapon/reagent_containers/glass/beaker(src)
	component_parts += new /obj/item/weapon/reagent_containers/glass/beaker(src)
	component_parts += new /obj/item/weapon/reagent_containers/syringe(src)
	component_parts += new /obj/item/weapon/reagent_containers/syringe(src)
	component_parts += new /obj/item/weapon/reagent_containers/syringe(src)
	component_parts += new /obj/item/stack/material/glass/reinforced(src, 2)

	RefreshParts()

/obj/machinery/sleeper/initialize()
	update_icon()

/obj/machinery/sleeper/process()
	if(stat & (NOPOWER|BROKEN))
		return

	if(filtering > 0)
		if(beaker)
			if(beaker.reagents.total_volume < beaker.reagents.maximum_volume)
				var/pumped = 0
				for(var/datum/reagent/x in occupant.reagents.reagent_list)
					occupant.reagents.trans_to_obj(beaker, 3)
					pumped++
				if(ishuman(occupant))
					occupant.vessel.trans_to_obj(beaker, pumped + 1)
		else
			toggle_filter()

/obj/machinery/sleeper/update_icon()
	icon_state = "sleeper_[occupant ? "1" : "0"]"

/obj/machinery/sleeper/ui_interact(var/mob/user, var/ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1, var/datum/topic_state/state = outside_state)
	var/data[0]

	data["power"] = stat & (NOPOWER|BROKEN) ? 0 : 1

	var/list/reagents = list()
	for(var/T in available_chemicals)
		var/list/reagent = list()
		reagent["id"] = T
		reagent["name"] = available_chemicals[T]
		if(occupant)
			reagent["amount"] = occupant.reagents.get_reagent_amount(T)
		reagents += list(reagent)
	data["reagents"] = reagents.Copy()

	if(occupant)
		data["occupant"] = 1
		switch(occupant.stat)
			if(CONSCIOUS)
				data["stat"] = "Conscious"
			if(UNCONSCIOUS)
				data["stat"] = "Unconscious"
			if(DEAD)
				data["stat"] = "<font color='red'>Dead</font>"
		data["health"] = occupant.health
		if(iscarbon(occupant))
			var/mob/living/carbon/C = occupant
			data["pulse"] = C.get_pulse(GETPULSE_TOOL)
		data["brute"] = occupant.getBruteLoss()
		data["burn"] = occupant.getFireLoss()
		data["oxy"] = occupant.getOxyLoss()
		data["tox"] = occupant.getToxLoss()
	else
		data["occupant"] = 0
	if(beaker)
		data["beaker"] = beaker.reagents.get_free_space()
	else
		data["beaker"] = -1
	data["filtering"] = filtering

	ui = nanomanager.try_update_ui(user, src, ui_key, ui, data, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "sleeper.tmpl", "Sleeper UI", 600, 600, state = state)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)

/obj/machinery/sleeper/Topic(href, href_list)
	if(..())
		return 1

	if(usr == occupant)
		usr << "<span class='warning'>You can't reach the controls from the inside.</span>"
		return

	add_fingerprint(usr)

	if(href_list["eject"])
		go_out()
	if(href_list["beaker"])
		remove_beaker()
	if(href_list["filter"])
		if(filtering != text2num(href_list["filter"]))
			toggle_filter()
	if(href_list["chemical"] && href_list["amount"])
		if(occupant && occupant.stat != DEAD)
			if(href_list["chemical"] in available_chemicals) // Your hacks are bad and you should feel bad
				inject_chemical(usr, href_list["chemical"], text2num(href_list["amount"]))

	return 1

/obj/machinery/sleeper/attackby(var/obj/item/I, var/mob/user)
	add_fingerprint(user)
	if(default_deconstruction_screwdriver(user, I))
		return
	else if(default_deconstruction_crowbar(user, I))
		return
	else if(istype(I, /obj/item/weapon/reagent_containers/glass))
		if(!beaker)
			beaker = I
			user.drop_item()
			I.loc = src
			user.visible_message("<span class='notice'>\The [user] adds \a [I] to \the [src].</span>", "<span class='notice'>You add \a [I] to \the [src].</span>")
		else
			user << "<span class='warning'>\The [src] has a beaker already.</span>"
		return

/obj/machinery/sleeper/MouseDrop_T(var/mob/target, var/mob/user)
	if(user.stat || user.lying || !Adjacent(user) || !target.Adjacent(user)|| !ishuman(target))
		return
	go_in(target, user)

/obj/machinery/sleeper/relaymove(var/mob/user)
	..()
	go_out()

/obj/machinery/sleeper/emp_act(var/severity)
	if(filtering)
		toggle_filter()

	if(stat & (BROKEN|NOPOWER))
		..(severity)
		return

	if(occupant)
		go_out()

	..(severity)
/obj/machinery/sleeper/proc/toggle_filter()
	if(!occupant || !beaker)
		filtering = 0
		return
	filtering = !filtering

/obj/machinery/sleeper/proc/go_in(var/mob/M, var/mob/user)
	if(!M)
		return
	if(stat & (BROKEN|NOPOWER))
		return
	if(occupant)
		user << "<span class='warning'>\The [src] is already occupied.</span>"
		return

	if(M == user)
		visible_message("\The [user] starts climbing into \the [src].")
	else
		visible_message("\The [user] starts putting [M] into \the [src].")

	if(do_after(user, 20))
		if(occupant)
			user << "<span class='warning'>\The [src] is already occupied.</span>"
			return
		M.stop_pulling()
		if(M.client)
			M.client.perspective = EYE_PERSPECTIVE
			M.client.eye = src
		M.loc = src
		update_use_power(2)
		occupant = M
		update_icon()

/obj/machinery/sleeper/proc/go_out()
	if(!occupant)
		return
	if(occupant.client)
		occupant.client.eye = occupant.client.mob
		occupant.client.perspective = MOB_PERSPECTIVE
	occupant.loc = src.loc
	occupant = null
	for(var/atom/movable/A in src) // In case an object was dropped inside or something
		if(A == beaker || A == circuit)
			continue
		if(A in component_parts)
			continue
		A.loc = src.loc
	update_use_power(1)
	update_icon()
	toggle_filter()

/obj/machinery/sleeper/proc/remove_beaker()
	if(beaker)
		beaker.loc = src.loc
		beaker = null
		toggle_filter()

/obj/machinery/sleeper/proc/inject_chemical(var/mob/living/user, var/chemical, var/amount)
	if(stat & (BROKEN|NOPOWER))
		return

	if(occupant && occupant.reagents)
		if(occupant.reagents.get_reagent_amount(chemical) + amount <= 20)
			use_power(amount * CHEM_SYNTH_ENERGY)
			occupant.reagents.add_reagent(chemical, amount)
			user << "Occupant now has [occupant.reagents.get_reagent_amount(chemical)] units of [available_chemicals[chemical]] in their bloodstream."
		else
			user << "The subject has too many chemicals."
	else
		user << "There's no suitable occupant in \the [src]."
