// the SMES
// stores power

GLOBAL_LIST_EMPTY(smeses)

//# define SMESMAXCHARGELEVEL 250000 Unused
//# define SMESMAXOUTPUT 250000 Unused

/obj/machinery/power/smes
	name = "power storage unit"
	desc = "A high-capacity superconducting magnetic energy storage (SMES) unit."
	icon_state = "smes"
	density = TRUE
	anchored = TRUE
	unacidable = TRUE
	use_power = USE_POWER_OFF
	circuit = /obj/item/circuitboard/smes
	clicksound = "switch"

	var/capacity = 5e6 // maximum charge
	var/charge = 1e6 // actual charge

	var/input_attempt = 0 			// 1 = attempting to charge, 0 = not attempting to charge
	var/inputting = 0 				// 1 = actually inputting, 0 = not inputting
	var/input_level = 50000 		// amount of power the SMES attempts to charge by
	var/input_level_max = 200000 	// cap on input_level
	var/input_available = 0 		// amount of charge available from input last tick

	var/output_attempt = 1 			// 1 = attempting to output, 0 = not attempting to output
	var/outputting = 0 				// 1 = actually outputting, 0 = not outputting
	var/output_level = 50000		// amount of power the SMES attempts to output
	var/output_level_max = 200000	// cap on output_level
	var/output_used = 0				// amount of power actually outputted. may be less than output_level if the powernet returns excess power

	//Holders for powerout event.
	var/last_output_attempt	= 0
	var/last_input_attempt	= 0
	var/last_charge			= 0

	//For icon overlay updates
	var/last_disp
	var/last_chrg
	var/last_onln

	var/damage = 0
	var/maxdamage = 500 // Relatively resilient, given how expensive it is, but once destroyed produces small explosion.

	var/input_cut = 0
	var/input_pulsed = 0
	var/output_cut = 0
	var/output_pulsed = 0
	var/target_load = 0

	var/name_tag = null
	var/building_terminal = 0 //Suggestions about how to avoid clickspam building several terminals accepted!
	var/list/terminals = list()
	var/should_be_mapped = 0 // If this is set to 0 it will send out warning on New()
	var/grid_check = FALSE // If true, suspends all I/O.

/obj/machinery/power/smes/drain_power(var/drain_check, var/surge, var/amount = 0)

	if(drain_check)
		return 1

	var/smes_amt = min((amount * SMESRATE), charge)
	charge -= smes_amt
	return smes_amt / SMESRATE

/obj/machinery/power/smes/Initialize()
	. = ..()
	GLOB.smeses += src
	add_nearby_terminals()
	if(!check_terminals())
		stat |= BROKEN
		return
	update_icon()
	if(!powernet)
		connect_to_network()
	if(!should_be_mapped)
		warning("Non-buildable or Non-magical SMES at [src.x]X [src.y]Y [src.z]Z")

/obj/machinery/power/smes/Destroy()
	for(var/obj/machinery/power/terminal/T in terminals)
		T.master = null
	terminals = null
	GLOB.smeses -= src
	return ..()

/obj/machinery/power/smes/proc/add_nearby_terminals()
	for(var/d in GLOB.cardinal)
		var/turf/T = get_step(src, d)
		for(var/obj/machinery/power/terminal/term in T)
			if(term && term.dir == turn(d, 180) && !term.master)
				terminals |= term
				term.master = src
				term.connect_to_network()

/obj/machinery/power/smes/proc/check_terminals()
	if(!terminals.len)
		return FALSE
	return TRUE

/obj/machinery/power/smes/add_avail(var/amount)
	if(..(amount))
		powernet.smes_newavail += amount
		return 1
	return 0

/obj/machinery/power/smes/disconnect_terminal(var/obj/machinery/power/terminal/term)
	terminals -= term
	term.master = null

/obj/machinery/power/smes/update_icon()
	cut_overlays()
	if(stat & BROKEN)	return

	add_overlay("smes-op[outputting]")

	if(inputting == 2)
		add_overlay("smes-oc2")
	else if (inputting == 1)
		add_overlay("smes-oc1")
	else
		if(input_attempt)
			add_overlay("smes-oc0")

	var/clevel = chargedisplay()
	if(clevel>0)
		add_overlay("smes-og[clevel]")
	return


/obj/machinery/power/smes/proc/chargedisplay()
	return round(5.5*charge/(capacity ? capacity : 5e6))

/obj/machinery/power/smes/proc/input_power(var/percentage, var/obj/machinery/power/terminal/term)
	var/to_input = target_load * (percentage/100)
	to_input = between(0, to_input, target_load)
	if(percentage == 100)
		inputting = 2
	else if(percentage)
		inputting = 1
	// else inputting = 0, as set in process()

	var/inputted = term.powernet.draw_power(min(to_input, input_level - input_available))
	add_charge(inputted)
	input_available += inputted

// Mostly in place due to child types that may store power in other way (PSUs)
/obj/machinery/power/smes/proc/add_charge(var/amount)
	charge += amount*SMESRATE

/obj/machinery/power/smes/proc/remove_charge(var/amount)
	charge -= amount*SMESRATE

/obj/machinery/power/smes/process()
	if(stat & BROKEN)	return

	// only update icon if state changed
	if(last_disp != chargedisplay() || last_chrg != inputting || last_onln != outputting)
		update_icon()
	//store machine state to see if we need to update the icon overlays
	last_disp = chargedisplay()
	last_chrg = inputting
	last_onln = outputting
	input_available = 0

	//inputting
	if(input_attempt && (!input_pulsed && !input_cut) && !grid_check)
		target_load = CLAMP((capacity-charge)/SMESRATE, 0, input_level)	// Amount we will request from the powernet.
		var/input_available = FALSE
		for(var/obj/machinery/power/terminal/term in terminals)
			if(!term.powernet)
				continue
			input_available = TRUE
			term.powernet.smes_demand += target_load
			term.powernet.inputting.Add(term)
		if(!input_available)
			target_load = 0 // We won't input any power without powernet connection.
		inputting = 0

	output_used = 0
	//outputting
	if(output_attempt && (!output_pulsed && !output_cut) && powernet && charge && !grid_check)
		output_used = min( charge/SMESRATE, output_level)		//limit output to that stored
		remove_charge(output_used)			// reduce the storage (may be recovered in /restore() if excessive)
		add_avail(output_used)				// add output to powernet (smes side)
		outputting = 2
	else if(!powernet || !charge)
		outputting = 1
	else
		output_used = 0

// called after all power processes are finished
// restores charge level to smes if there was excess this ptick
/obj/machinery/power/smes/proc/restore(var/percent_load)
	if(stat & BROKEN)
		return

	if(!outputting)
		output_used = 0
		return

	var/total_restore = output_used * (percent_load / 100) // First calculate amount of power used from our output
	total_restore = between(0, total_restore, output_used) // Now clamp the value between 0 and actual output, just for clarity.
	total_restore = output_used - total_restore			   // And, at last, subtract used power from outputted power, to get amount of power we will give back to the SMES.

	// now recharge this amount
	var/clev = chargedisplay()

	add_charge(total_restore)				// restore unused power
	powernet.netexcess -= total_restore		// remove the excess from the powernet, so later SMESes don't try to use it

	output_used -= total_restore

	if(clev != chargedisplay() ) //if needed updates the icons overlay
		update_icon()
	return

//Will return 1 on failure
/obj/machinery/power/smes/proc/make_terminal(const/mob/user)
	if (user.loc == loc)
		to_chat(user, span_filter_notice(span_warning("You must not be on the same tile as the [src].")))
		return 1

	//Direction the terminal will face to
	var/tempDir = get_dir(user, src)
	switch(tempDir)
		if (NORTHEAST, SOUTHEAST)
			tempDir = EAST
		if (NORTHWEST, SOUTHWEST)
			tempDir = WEST
	var/turf/tempLoc = get_step(src, reverse_direction(tempDir))
	if (istype(tempLoc, /turf/space))
		to_chat(user, span_filter_notice(span_warning("You can't build a terminal on space.")))
		return 1
	else if (istype(tempLoc))
		if(!tempLoc.is_plating())
			to_chat(user, span_filter_notice(span_warning("You must remove the floor plating first.")))
			return 1
	if(check_terminal_exists(tempLoc, user, tempDir))
		return 1
	to_chat(user, span_filter_notice(span_notice("You start adding cable to the [src].")))
	if(do_after(user, 50))
		if(check_terminal_exists(tempLoc, user, tempDir))
			return 1
		var/obj/machinery/power/terminal/term = new/obj/machinery/power/terminal(tempLoc)
		term.set_dir(tempDir)
		term.master = src
		term.connect_to_network()
		terminals |= term
		return 0
	return 1

/obj/machinery/power/smes/proc/check_terminal_exists(var/turf/location, var/mob/user, var/direction)
	for(var/obj/machinery/power/terminal/term in location)
		if(term.dir == direction)
			to_chat(user, span_filter_notice(span_notice("There is already a terminal here.")))
			return 1
	return 0

/obj/machinery/power/smes/draw_power(var/amount)
	var/drained = 0
	for(var/obj/machinery/power/terminal/term in terminals)
		if(!term.powernet)
			continue
		if((amount - drained) <= 0)
			return 0
		drained += term.powernet.draw_power(amount - drained)
	return drained


/obj/machinery/power/smes/attack_ai(mob/user)
	add_hiddenprint(user)
	tgui_interact(user)

/obj/machinery/power/smes/attack_hand(mob/user)
	add_fingerprint(user)
	tgui_interact(user)


/obj/machinery/power/smes/attackby(var/obj/item/W as obj, var/mob/user as mob)
	if(default_deconstruction_screwdriver(user, W))
		return FALSE

	if (!panel_open)
		to_chat(user, span_filter_notice(span_warning("You need to open access hatch on [src] first!")))
		return FALSE

	if(W.has_tool_quality(TOOL_WELDER))
		var/obj/item/weldingtool/WT = W.get_welder()
		if(!WT.isOn())
			to_chat(user, span_filter_notice("Turn on \the [WT] first!"))
			return FALSE
		if(!damage)
			to_chat(user, span_filter_notice("\The [src] is already fully repaired."))
			return FALSE
		if(WT.remove_fuel(0,user) && do_after(user, damage, src))
			to_chat(user, span_filter_notice("You repair all structural damage to \the [src]"))
			damage = 0
		return FALSE
	else if(istype(W, /obj/item/stack/cable_coil) && !building_terminal)
		building_terminal = 1
		var/obj/item/stack/cable_coil/CC = W
		if (CC.get_amount() < 10)
			to_chat(user, span_filter_notice(span_warning("You need more cables.")))
			building_terminal = 0
			return FALSE
		if (make_terminal(user))
			building_terminal = 0
			return FALSE
		building_terminal = 0
		CC.use(10)
		user.visible_message(\
				span_filter_notice(span_notice("[user.name] has added cables to the [src].")),\
				span_filter_notice(span_notice("You added cables to the [src].")))
		stat = 0
		if(!powernet)
			connect_to_network()
		return FALSE

	else if(W.has_tool_quality(TOOL_WIRECUTTER) && !building_terminal)
		building_terminal = TRUE
		var/obj/machinery/power/terminal/term
		for(var/obj/machinery/power/terminal/T in get_turf(user))
			if(T.master == src)
				term = T
				break
		if(!term)
			to_chat(user, span_filter_notice(span_warning("There is no terminal on this tile.")))
			building_terminal = FALSE
			return FALSE
		var/turf/tempTDir = get_turf(term)
		if (istype(tempTDir))
			if(!tempTDir.is_plating())
				to_chat(user, span_filter_notice(span_warning("You must remove the floor plating first.")))
			else
				to_chat(user, span_filter_notice(span_notice("You begin to cut the cables...")))
				playsound(src, 'sound/items/Deconstruct.ogg', 50, 1)
				if(do_after(user, 50 * W.toolspeed))
					if (prob(50) && electrocute_mob(usr, term.powernet, term))
						var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
						s.set_up(5, 1, src)
						s.start()
						building_terminal = FALSE
						if(usr.stunned)
							return FALSE
					new /obj/item/stack/cable_coil(loc,10)
					user.visible_message(\
						span_filter_notice(span_notice("[user.name] cut the cables and dismantled the power terminal.")),\
						span_filter_notice(span_notice("You cut the cables and dismantle the power terminal.")))
					terminals -= term
					qdel(term)
		building_terminal = FALSE
		return FALSE
	return TRUE

/obj/machinery/power/smes/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "Smes", name)
		ui.open()

/obj/machinery/power/smes/tgui_data()
	var/list/data = list(
		"capacity" = capacity,
		"capacityPercent" = round(100*charge/capacity, 0.1),
		"charge" = charge,
		"inputAttempt" = input_attempt,
		"inputting" = inputting,
		"inputLevel" = input_level,
		"inputLevel_text" = DisplayPower(input_level),
		"inputLevelMax" = input_level_max,
		"inputAvailable" = input_available,
		"outputAttempt" = output_attempt,
		"outputting" = outputting,
		"outputLevel" = output_level,
		"outputLevel_text" = DisplayPower(output_level),
		"outputLevelMax" = output_level_max,
		"outputUsed" = output_used,
	)
	return data

/obj/machinery/power/smes/proc/Percentage()
	if(!capacity)
		return 0
	return round(100.0*charge/capacity, 0.1)

/obj/machinery/power/smes/tgui_act(action, params)
	if(..())
		return TRUE
	switch(action)
		if("tryinput")
			inputting(!input_attempt)
			update_icon()
			. = TRUE
		if("tryoutput")
			outputting(!output_attempt)
			update_icon()
			. = TRUE
		if("input")
			tgui_set_io(SMES_TGUI_INPUT, params["target"], text2num(params["adjust"]))
		if("output")
			tgui_set_io(SMES_TGUI_OUTPUT, params["target"], text2num(params["adjust"]))

/obj/machinery/power/smes/proc/tgui_set_io(io, target, adjust)
	if(target == "min")
		target = 0
		. = TRUE
	else if(target == "max")
		target = output_level_max
		. = TRUE
	else if(adjust)
		target = output_level + adjust
		. = TRUE
	else if(text2num(target) != null)
		target = text2num(target)
		. = TRUE
	if(.)
		switch(io)
			if(SMES_TGUI_INPUT)
				set_input(target)
			if(SMES_TGUI_OUTPUT)
				set_output(target)


/obj/machinery/power/smes/proc/inputting(var/do_input)
	input_attempt = do_input
	if(!input_attempt)
		inputting = 0

/obj/machinery/power/smes/proc/outputting(var/do_output)
	output_attempt = do_output
	if(!output_attempt)
		outputting = 0

/obj/machinery/power/smes/take_damage(var/amount)
	amount = max(0, round(amount))
	damage += amount
	if(damage > maxdamage)
		visible_message(span_filter_notice(span_danger("\The [src] explodes in large shower of sparks and smoke!")))
		// Depending on stored charge percentage cause damage.
		switch(Percentage())
			if(75 to INFINITY)
				explosion(get_turf(src), 1, 2, 4)
			if(40 to 74)
				explosion(get_turf(src), 0, 2, 3)
			if(5 to 39)
				explosion(get_turf(src), 0, 1, 2)
		qdel(src) // Either way we want to ensure the SMES is deleted.

/obj/machinery/power/smes/emp_act(severity)
	inputting(rand(0,1))
	outputting(rand(0,1))
	output_level = rand(0, output_level_max)
	input_level = rand(0, input_level_max)
	charge -= 1e6/severity
	if (charge < 0)
		charge = 0
	update_icon()
	..()

/obj/machinery/power/smes/bullet_act(var/obj/item/projectile/Proj)
	take_damage(Proj.get_structure_damage())

/obj/machinery/power/smes/ex_act(var/severity)
	// Two strong explosions will destroy a SMES.
	// Given the SMES creates another explosion on it's destruction it sounds fairly reasonable.
	take_damage(250 / severity)

/obj/machinery/power/smes/examine(var/mob/user)
	. = ..()
	. += span_filter_notice("The service hatch is [panel_open ? "open" : "closed"].")
	if(!damage)
		return
	var/damage_percentage = round((damage / maxdamage) * 100)
	switch(damage_percentage)
		if(75 to INFINITY)
			. += span_filter_notice(span_danger("It's casing is severely damaged, and sparking circuitry may be seen through the holes!"))
		if(50 to 74)
			. += span_filter_notice(span_notice("It's casing is considerably damaged, and some of the internal circuits appear to be exposed!"))
		if(25 to 49)
			. += span_filter_notice(span_notice("It's casing is quite seriously damaged."))
		if(0 to 24)
			. += span_filter_notice("It's casing has some minor damage.")


// Proc: toggle_input()
// Parameters: None
// Description: Switches the input on/off depending on previous setting
/obj/machinery/power/smes/proc/toggle_input()
	inputting(!input_attempt)
	update_icon()

// Proc: toggle_output()
// Parameters: None
// Description: Switches the output on/off depending on previous setting
/obj/machinery/power/smes/proc/toggle_output()
	outputting(!output_attempt)
	update_icon()

// Proc: set_input()
// Parameters: 1 (new_input - New input value in Watts)
// Description: Sets input setting on this SMES. Trims it if limits are exceeded.
/obj/machinery/power/smes/proc/set_input(var/new_input = 0)
	input_level = between(0, new_input, input_level_max)
	update_icon()

// Proc: set_output()
// Parameters: 1 (new_output - New output value in Watts)
// Description: Sets output setting on this SMES. Trims it if limits are exceeded.
/obj/machinery/power/smes/proc/set_output(var/new_output = 0)
	output_level = between(0, new_output, output_level_max)
	update_icon()
