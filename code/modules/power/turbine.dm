// TURBINE v2 AKA rev4407 Engine reborn!

// How to use it? - Mappers
//
// This is a very good power generating mechanism. All you need is a blast furnace with soaring flames and output.
// Not everything is included yet so the turbine can run out of fuel quiet quickly. The best thing about the turbine is that even
// though something is on fire that passes through it, it won't be on fire as it passes out of it. So the exhaust fumes can still
// containt unreacted fuel - plasma and oxygen that needs to be filtered out and re-routed back. This of course requires smart piping
// For a computer to work with the turbine the compressor requires a comp_id matching with the turbine computer's id. This will be
// subjected to a change in the near future mind you. Right now this method of generating power is a good backup but don't expect it
// become a main power source unless some work is done. Have fun. At 50k RPM it generates 60k power. So more than one turbine is needed!
//
// - Numbers
//
// Example setup	 S - sparker
//					 B - Blast doors into space for venting
// *BBB****BBB*		 C - Compressor
// S    CT    *		 T - Turbine
// * ^ *  * V *		 D - Doors with firedoor
// **|***D**|**      ^ - Fuel feed (Not vent, but a gas outlet)
//   |      |        V - Suction vent (Like the ones in atmos
//

/obj/machinery/compressor
	name = "compressor"
	desc = "The compressor stage of a gas turbine generator."
	icon = 'icons/obj/pipes.dmi'
	icon_state = "compressor"
	anchored = TRUE
	density = TRUE
	can_atmos_pass = ATMOS_PASS_PROC
	circuit = /obj/item/weapon/circuitboard/machine/power_compressor
	var/obj/machinery/power/turbine/turbine
	var/datum/gas_mixture/gas_contained
	var/turf/simulated/inturf
	var/starter = 0
	var/rpm = 0
	var/rpmtarget = 0
	var/capacity = 1e6
	var/comp_id = 0
	var/efficiency

/obj/machinery/power/turbine
	name = "gas turbine generator"
	desc = "A gas turbine used for backup power generation."
	icon = 'icons/obj/pipes.dmi'
	icon_state = "turbine"
	anchored = TRUE
	density = TRUE
	circuit = /obj/item/weapon/circuitboard/machine/power_turbine
	var/obj/machinery/compressor/compressor
	var/turf/simulated/outturf
	var/lastgen
	var/productivity = 1

/obj/machinery/computer/turbine_computer
	name = "gas turbine control computer"
	desc = "A computer to remotely control a gas turbine."
	icon_keyboard = "tech_key"
	icon_screen = "turbinecomp"
	circuit = /obj/item/weapon/circuitboard/turbine_control
	var/obj/machinery/compressor/compressor
	var/list/obj/machinery/door/blast/doors
	var/id = 0
	var/door_status = 0

/obj/item/weapon/circuitboard/machine/power_compressor
	name = T_BOARD("power compressor")
	build_path = /obj/machinery/compressor
	board_type = new /datum/frame/frame_types/machine
	origin_tech = list(TECH_MATERIAL = 4, TECH_POWER = 2)
	req_components = list(/obj/item/stack/cable_coil = 5, /obj/item/weapon/stock_parts/manipulator = 6)

/obj/item/weapon/circuitboard/machine/power_turbine
	name = T_BOARD("power turbine")
	build_path = /obj/machinery/power/turbine
	board_type = new /datum/frame/frame_types/machine
	origin_tech = list(TECH_ENGINEERING = 2, TECH_POWER = 4)
	req_components = list(/obj/item/stack/cable_coil = 5, /obj/item/weapon/stock_parts/capacitor = 6)

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Compressor
// the inlet stage of the gas turbine electricity generator
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

#define COMPFRICTION 5e5
#define COMPSTARTERLOAD 2800

/obj/machinery/compressor/Initialize()
	. = ..()
	default_apply_parts()
	gas_contained = new()
	inturf = get_step(src, dir)
	locate_machinery()
	if(!turbine)
		stat |= BROKEN

// When anchored, don't let air past us.
/obj/machinery/compressor/CanZASPass(turf/T, is_zone)
	return !anchored

/obj/machinery/compressor/proc/locate_machinery()
	if(turbine)
		return
	turbine = locate() in get_step(src, get_dir(inturf, src))
	if(turbine)
		turbine.locate_machinery()

/obj/machinery/compressor/RefreshParts()
	var/E = 0
	for(var/obj/item/weapon/stock_parts/manipulator/M in component_parts)
		E += M.rating
	efficiency = E / 6

/obj/machinery/compressor/attackby(obj/item/W, mob/user)
	src.add_fingerprint(user)

	if(default_deconstruction_screwdriver(user, W))
		return
	if(default_part_replacement(user, W))
		return
	if(default_unfasten_wrench(user, W))
		return
	if(default_deconstruction_crowbar(user, W))
		return
	if(istype(W, /obj/item/device/multitool))
		var/new_ident = tgui_input_text(usr, "Enter a new ident tag.", name, comp_id)
		if(new_ident && user.Adjacent(src))
			comp_id = new_ident
		return
	return ..()

/obj/machinery/compressor/default_unfasten_wrench(var/mob/user, var/obj/item/weapon/W, var/time = 20)
	if((. = ..()))
		turbine = null
		if(anchored)
			inturf = get_step(src, dir)
			locate_machinery()
			if(turbine)
				to_chat(user, "<span class='notice'>Turbine connected.</span>")
				stat &= ~BROKEN
			else
				to_chat(user, "<span class='alert'>Turbine not connected.</span>")
				stat |= BROKEN

/obj/machinery/compressor/process()
	if(!turbine)
		stat = BROKEN
	if(stat & BROKEN || panel_open)
		return
	if(!starter)
		return
	cut_overlays()

	rpm = 0.9* rpm + 0.1 * rpmtarget
	var/datum/gas_mixture/environment = inturf.return_air()

	// It's a simplified version taking only 1/10 of the moles from the turf nearby. It should be later changed into a better version
	var/transfer_moles = environment.total_moles / 10
	var/datum/gas_mixture/removed = inturf.remove_air(transfer_moles)
	gas_contained.merge(removed)

	// RPM function to include compression friction - be advised that too low/high of a compfriction value can make things screwy
	rpm = max(0, rpm - (rpm*rpm)/(COMPFRICTION*efficiency))

	if(starter && !(stat & NOPOWER))
		use_power(2800)
		if(rpm<1000)
			rpmtarget = 1000
	else
		if(rpm<1000)
			rpmtarget = 0

	if(rpm>50000)
		add_overlay(image('icons/obj/pipes.dmi', "comp-o4", FLY_LAYER))
	else if(rpm>10000)
		add_overlay(image('icons/obj/pipes.dmi', "comp-o3", FLY_LAYER))
	else if(rpm>2000)
		add_overlay(image('icons/obj/pipes.dmi', "comp-o2", FLY_LAYER))
	else if(rpm>500)
		add_overlay(image('icons/obj/pipes.dmi', "comp-o1", FLY_LAYER))
	 //TODO: DEFERRED


/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Turbine
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// These are crucial to working of a turbine - the stats modify the power output. TurbGenQ modifies how much raw energy can you get from
// rpms, TurbGenG modifies the shape of the curve - the lower the value the less straight the curve is.

#define TURBPRES 9000000
#define TURBGENQ 100000
#define TURBGENG 0.8

/obj/machinery/power/turbine/Initialize()
	. = ..()
	default_apply_parts()
	// The outlet is pointed at the direction of the turbine component
	outturf = get_step(src, dir)
	locate_machinery()
	if(!compressor)
		stat |= BROKEN

/obj/machinery/power/turbine/RefreshParts()
	var/P = 0
	for(var/obj/item/weapon/stock_parts/capacitor/C in component_parts)
		P += C.rating
	productivity = P / 6

/obj/machinery/power/turbine/proc/locate_machinery()
	if(compressor)
		return
	compressor = locate() in get_step(src, get_dir(outturf, src))
	if(compressor)
		compressor.locate_machinery()

/obj/machinery/power/turbine/attackby(obj/item/W, mob/user)
	src.add_fingerprint(user)

	if(default_deconstruction_screwdriver(user, W))
		return
	if(default_part_replacement(user, W))
		return
	if(default_unfasten_wrench(user, W))
		return
	if(default_deconstruction_crowbar(user, W))
		return
	return ..()

/obj/machinery/power/turbine/default_unfasten_wrench(var/mob/user, var/obj/item/weapon/W, var/time = 20)
	if((. = ..()))
		compressor = null
		if(anchored)
			outturf = get_step(src, dir)
			locate_machinery()
			if(compressor)
				to_chat(user, "<span class='notice'>Compressor connected.</span>")
				stat &= ~BROKEN
			else
				to_chat(user, "<span class='alert'>Compressor not connected.</span>")
				stat |= BROKEN

/obj/machinery/power/turbine/process()
	if(!compressor)
		stat = BROKEN
	if((stat & BROKEN) || panel_open)
		return
	if(!compressor.starter)
		return
	cut_overlays()

	// This is the power generation function. If anything is needed it's good to plot it in EXCEL before modifying
	// the TURBGENQ and TURBGENG values
	lastgen = ((compressor.rpm / TURBGENQ)**TURBGENG) * TURBGENQ * productivity

	add_avail(lastgen)

	// Weird function but it works. Should be something else...
	var/newrpm = ((compressor.gas_contained.temperature) * compressor.gas_contained.total_moles)/4

	newrpm = max(0, newrpm)

	if(!compressor.starter || newrpm > 1000)
		compressor.rpmtarget = newrpm

	if(compressor.gas_contained.total_moles>0)
		var/oamount = min(compressor.gas_contained.total_moles, (compressor.rpm+100)/35000*compressor.capacity)
		var/datum/gas_mixture/removed = compressor.gas_contained.remove(oamount)
		outturf.assume_air(removed)

	// If it works, put an overlay that it works!
	if(lastgen > 100)
		add_overlay(image('icons/obj/pipes.dmi', "turb-o", FLY_LAYER))

	updateDialog()

/obj/machinery/power/turbine/attack_hand(var/mob/user as mob)
	if((. = ..()))
		return
	src.interact(user)

/obj/machinery/power/turbine/interact(mob/user)
	if(!Adjacent(user)  || (stat & (NOPOWER|BROKEN)) && !issilicon(user))
		user.unset_machine(src)
		user << browse(null, "window=turbine")
		return
	user.set_machine(src)

	var/t = "<TT><B>Gas Turbine Generator</B><HR><PRE>"
	t += "Generated power : [DisplayPower(lastgen)]<BR><BR>"
	t += "Turbine: [round(compressor.rpm)] RPM<BR>"
	t += "Starter: [ compressor.starter ? "<A href='?src=\ref[src];str=1'>Off</A> <B>On</B>" : "<B>Off</B> <A href='?src=\ref[src];str=1'>On</A>"]"
	t += "</PRE><HR><A href='?src=\ref[src];close=1'>Close</A>"
	t += "</TT>"
	var/datum/browser/popup = new(user, "turbine", name, 700, 500, src)
	popup.set_content(t)
	popup.open()

	return

/obj/machinery/power/turbine/Topic(href, href_list)
	if(..())
		return

	if(href_list["close"])
		usr << browse(null, "window=turbine")
		usr.unset_machine(src)
		return
	else if(href_list["str"])
		if(compressor)
			compressor.starter = !compressor.starter
	updateDialog()


/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Turbine Computer
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/obj/machinery/computer/turbine_computer/Initialize()
	..()
	return INITIALIZE_HINT_LATELOAD

/obj/machinery/computer/turbine_computer/LateInitialize()
	locate_machinery()

/obj/machinery/computer/turbine_computer/proc/locate_machinery()
	if(!id)
		return
	for(var/obj/machinery/compressor/C in machines)
		if(C.comp_id == id)
			compressor = C
	LAZYINITLIST(doors)
	for(var/obj/machinery/door/blast/P in machines)
		if(P.id == id)
			doors += P

/obj/machinery/computer/turbine_computer/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/device/multitool))
		var/new_ident = tgui_input_text(usr, "Enter a new ident tag.", name, id)
		if(new_ident && user.Adjacent(src))
			id = new_ident
		return

/obj/machinery/computer/turbine_computer/attack_hand(var/mob/user as mob)
	if((. = ..()))
		return
	tgui_interact(user)

/obj/machinery/computer/turbine_computer/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "TurbineControl", name)
		ui.open()

/obj/machinery/computer/turbine_computer/tgui_data(mob/user, datum/tgui/ui, datum/tgui_state/state)
	var/list/data = list()
	data["connected"] = (compressor && compressor.turbine) ? TRUE : FALSE
	data["compressor_broke"] = (!compressor || (compressor.stat & BROKEN)) ? TRUE : FALSE
	data["turbine_broke"] = (!compressor || !compressor.turbine || (compressor.turbine.stat & BROKEN)) ? TRUE : FALSE
	data["broken"] = (data["compressor_broke"] || data["turbine_broke"])
	data["door_status"] = door_status ? TRUE : FALSE

	data["online"] = FALSE
	data["power"] = 0
	data["rpm"] = 0
	data["temp"] = 0

	if(compressor && compressor.turbine)
		data["online"] = compressor.starter
		data["power"] = compressor.turbine.lastgen // DisplayPower
		data["rpm"] = compressor.rpm
		data["temp"] = compressor.gas_contained.temperature

	return data

/obj/machinery/computer/turbine_computer/tgui_act(action, list/params, datum/tgui/ui, datum/tgui_state/state)
	if(..())
		return TRUE

	switch(action)
		if("power-on")
			if(compressor && compressor.turbine)
				compressor.starter = TRUE
				. = TRUE
		if("power-off")
			if(compressor && compressor.turbine)
				compressor.starter = FALSE
				. = TRUE
		if("reconnect")
			locate_machinery()
			. = TRUE
		if("doors")
			door_status = !door_status
			for(var/obj/machinery/door/blast/D in src.doors)
				if (door_status)
					spawn(0) D.close()
				else
					spawn(0)D.open()
			. = TRUE

#undef COMPFRICTION
#undef COMPSTARTERLOAD
#undef TURBPRES
#undef TURBGENQ
#undef TURBGENG
