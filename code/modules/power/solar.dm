//#define SOLAR_MAX_DIST 40		//VOREStation Removal
#define SOLAR_AUTO_START_NO     0 // Will never start itself.
#define SOLAR_AUTO_START_YES    1 // Will always start itself.
#define SOLAR_AUTO_START_CONFIG 2 // Will start itself if config allows it (default is no).

GLOBAL_VAR_INIT(solar_gen_rate, 1500)
GLOBAL_LIST_EMPTY(solars_list)

/obj/machinery/power/solar
	name = "solar panel"
	desc = "A solar electrical generator."
	icon = 'icons/obj/power.dmi'
	icon_state = "sp_base"
	anchored = TRUE
	density = TRUE
	unacidable = TRUE
	use_power = USE_POWER_OFF
	idle_power_usage = 0
	active_power_usage = 0
	var/id = 0
	var/health = 10
	var/obscured = 0
	var/sunfrac = 0
	var/adir = SOUTH // actual dir
	var/ndir = SOUTH // target dir
	var/turn_angle = 0
	var/obj/machinery/power/solar_control/control = null
	var/glass_type = /obj/item/stack/material/glass
	var/SOLAR_MAX_DIST = 40		//VOREStation Addition

/obj/machinery/power/solar/drain_power()
	return -1

/obj/machinery/power/solar/Initialize(mapload, glass_type)
	. = ..()
	if(glass_type == /obj/item/stack/material/glass/reinforced) //if the panel is in reinforced glass
		health *= 2
	update_icon()
	connect_to_network()

/obj/machinery/power/solar/Destroy()
	unset_control() //remove from control computer
	. = ..()

//set the control of the panel to a given computer if closer than SOLAR_MAX_DIST
/obj/machinery/power/solar/proc/set_control(var/obj/machinery/power/solar_control/SC)
	ASSERT(!control)
	if(SC && (get_dist(src, SC) > SOLAR_MAX_DIST))
		return 0
	control = SC
	return 1

//set the control of the panel to null and removes it from the control list of the previous control computer if needed
/obj/machinery/power/solar/proc/unset_control()
	if(control)
		control.remove_panel(src)
	control = null

/obj/machinery/power/solar/attackby(obj/item/weapon/W, mob/user)

	if(W.has_tool_quality(TOOL_CROWBAR))
		playsound(src, 'sound/machines/click.ogg', 50, 1)
		user.visible_message("<span class='notice'>[user] begins to take the glass off the solar panel.</span>")
		if(do_after(user, 50))
			var/obj/item/solar_assembly/S = new(loc)
			S.anchored = TRUE
			new glass_type(loc, 2)
			playsound(src, 'sound/items/Deconstruct.ogg', 50, 1)
			user.visible_message("<span class='notice'>[user] takes the glass off the solar panel.</span>")
			qdel(src)
		return
	else if (W)
		src.add_fingerprint(user)
		src.health -= W.force
		src.healthcheck()
	..()


/obj/machinery/power/solar/proc/healthcheck()
	if (src.health <= 0)
		if(!(stat & BROKEN))
			broken()
		else
			new /obj/item/weapon/material/shard(src.loc)
			new /obj/item/weapon/material/shard(src.loc)
			qdel(src)
			return
	return


/obj/machinery/power/solar/update_icon()
	..()
	cut_overlays()
	if(stat & BROKEN)
		add_overlay("solar_panel-b")
	else
		add_overlay("solar_panel")
		src.set_dir(angle2dir(adir))
	return

//calculates the fraction of the SSsun.sunlight that the panel recieves
/obj/machinery/power/solar/proc/update_solar_exposure()
	if(!SSsun.sun)
		return
	if(obscured)
		sunfrac = 0
		return

	//find the smaller angle between the direction the panel is facing and the direction of the SSsun.sun (the sign is not important here)
	var/p_angle = min(abs(adir - SSsun.sun.angle), 360 - abs(adir - SSsun.sun.angle))

	if(p_angle > 90)			// if facing more than 90deg from SSsun.sun, zero output
		sunfrac = 0
		return

	sunfrac = cos(p_angle) ** 2
	//isn't the power recieved from the incoming light proportionnal to cos(p_angle) (Lambert's cosine law) rather than cos(p_angle)^2 ?

/obj/machinery/power/solar/proc/get_power_supplied()
	if(stat & BROKEN)
		return 0
	if(!SSsun.sun || !control)
		return 0  //if there's no SSsun.sun or the panel is not linked to a solar control computer, no need to proceed
	if(!powernet || powernet != control.powernet)
		return 0 // We aren't connected to the controller
	if(obscured)
		return 0 //get no light from the SSsun.sun, so don't generate power
	return GLOB.solar_gen_rate * sunfrac

/obj/machinery/power/solar/proc/broken()
	stat |= BROKEN
	unset_control()
	update_icon()
	return


/obj/machinery/power/solar/ex_act(severity)
	switch(severity)
		if(1.0)
			if(prob(15))
				new /obj/item/weapon/material/shard( src.loc )
			qdel(src)
			return

		if(2.0)
			if (prob(25))
				new /obj/item/weapon/material/shard( src.loc )
				qdel(src)
				return

			if (prob(50))
				broken()

		if(3.0)
			if (prob(25))
				broken()
	return

//trace towards SSsun.sun to see if we're in shadow
/obj/machinery/power/solar/proc/occlusion()

	var/ax = x		// start at the solar panel
	var/ay = y
	var/turf/T = null

	for(var/i = 1 to 20)		// 20 steps is enough
		ax += SSsun.sun.dx	// do step
		ay += SSsun.sun.dy

		T = locate( round(ax,0.5),round(ay,0.5),z)

		if(!T || T.x == 1 || T.x==world.maxx || T.y==1 || T.y==world.maxy)		// not obscured if we reach the edge
			break

		if(T.opacity)			// if we hit a solid turf, panel is obscured
			obscured = 1
			return

	obscured = 0		// if hit the edge or stepped 20 times, not obscured
	update_solar_exposure()

/// Looks nice but doesn't generate power.
/obj/machinery/power/solar/fake

/obj/machinery/power/solar/fake/get_power_supplied()
	return 0

//
// Solar Assembly - For construction of solar arrays.
//

/obj/item/solar_assembly
	name = "solar panel assembly"
	desc = "A solar panel assembly kit, allows constructions of a solar panel, or with a tracking circuit board, a solar tracker"
	icon = 'icons/obj/power.dmi'
	icon_state = "sp_base"
	item_state = "camera"
	w_class = ITEMSIZE_LARGE // Pretty big!
	anchored = FALSE
	var/tracker = 0

/obj/item/solar_assembly/attack_hand(var/mob/user)
	if(!anchored || !isturf(loc)) // You can't pick it up
		..()

/obj/item/solar_assembly/attackby(var/obj/item/weapon/W, var/mob/user)
	if (!isturf(loc))
		return 0
	if(!anchored)
		if(W.has_tool_quality(TOOL_WRENCH))
			anchored = TRUE
			user.visible_message("<span class='notice'>[user] wrenches the solar assembly into place.</span>")
			playsound(src, W.usesound, 75, 1)
			return 1
	else
		if(W.has_tool_quality(TOOL_WRENCH))
			anchored = FALSE
			user.visible_message("<span class='notice'>[user] unwrenches the solar assembly from it's place.</span>")
			playsound(src, W.usesound, 75, 1)
			return 1

		if(istype(W, /obj/item/stack/material) && (W.get_material_name() == "glass" || W.get_material_name() == "rglass"))
			var/obj/item/stack/material/S = W
			if(S.use(2))
				playsound(src, 'sound/machines/click.ogg', 50, 1)
				user.visible_message("<span class='notice'>[user] places the glass on the solar assembly.</span>")
				if(tracker)
					new /obj/machinery/power/tracker(get_turf(src), W.type)
				else
					new /obj/machinery/power/solar(get_turf(src), W.type)
				qdel(src)
			else
				to_chat(user, "<span class='warning'>You need two sheets of glass to put them into a solar panel.</span>")
				return
			return 1

	if(!tracker)
		if(istype(W, /obj/item/weapon/tracker_electronics))
			tracker = 1
			user.drop_item()
			qdel(W)
			user.visible_message("<span class='notice'>[user] inserts the electronics into the solar assembly.</span>")
			return 1
	else
		if(W.has_tool_quality(TOOL_CROWBAR))
			new /obj/item/weapon/tracker_electronics(src.loc)
			tracker = 0
			user.visible_message("<span class='notice'>[user] takes out the electronics from the solar assembly.</span>")
			return 1
	..()

//
// Solar Control Computer
//

/obj/machinery/power/solar_control
	name = "solar panel control"
	desc = "A controller for solar panel arrays."
	icon = 'icons/obj/computer.dmi'
	icon_state = "solar"
	anchored = TRUE
	density = TRUE
	use_power = USE_POWER_IDLE
	idle_power_usage = 250
	var/id = 0
	var/cdir = 0
	var/targetdir = 0		// target angle in manual tracking (since it updates every game minute)
	var/track = 0			// 0= off  1=timed  2=auto (tracker)
	var/trackrate = 600		// 300-900 seconds
	var/nexttime = 0		// time for a panel to rotate of 1� in manual tracking
	var/obj/machinery/power/tracker/connected_tracker = null
	var/needs_panel_check	// Powernet has been updated, need to check if panels are still connected.
	var/connected_power		// Sum of power supplied by connected panels.
	VAR_PRIVATE/list/connected_panels = list()
	var/auto_start = SOLAR_AUTO_START_NO

// Used for mapping in solar arrays which automatically start itself.
// Generally intended for far away and remote locations, where player intervention is rare.
// In the interest of backwards compatability, this isn't named auto_start, as doing so might break downstream maps.
/obj/machinery/power/solar_control/autostart
	auto_start = SOLAR_AUTO_START_YES

// Similar to above but controlled by the configuration file.
// Intended to be used for the main solar arrays, so individual servers can choose to have them start automatically or require manual intervention.
/obj/machinery/power/solar_control/config_start
	auto_start = SOLAR_AUTO_START_CONFIG

/obj/machinery/power/solar_control/Initialize()
	. = ..()
	connect_to_network()
	set_panels(cdir)

/obj/machinery/power/solar_control/Destroy()
	for(var/obj/machinery/power/solar/M in connected_panels)
		M.unset_control()
	if(connected_tracker)
		connected_tracker.unset_control()
	return ..()

/obj/machinery/power/solar_control/proc/auto_start(forced = FALSE)
	// Automatically sets the solars, if allowed.
	if(forced || auto_start == SOLAR_AUTO_START_YES || (auto_start == SOLAR_AUTO_START_CONFIG && config.autostart_solars) )
		track = 2 // Auto tracking mode.
		search_for_connected()
		if(connected_tracker)
			connected_tracker.set_angle(SSsun.sun.angle)
		set_panels(cdir)

// This would use LateInitialize(), however the powernet does not appear to exist during that time.
/hook/roundstart/proc/auto_start_solars()
	for(var/obj/machinery/power/solar_control/SC as anything in GLOB.solars_list)
		SC.auto_start()
	return TRUE

/obj/machinery/power/solar_control/proc/add_panel(var/obj/machinery/power/solar/P)
	var/sgen = P.get_power_supplied()
	connected_power -= connected_panels[P] // Just in case it was already in there
	connected_panels[P] = sgen
	connected_power += sgen

/obj/machinery/power/solar_control/proc/remove_panel(var/obj/machinery/power/solar/P)
	connected_power -= connected_panels[P]
	connected_panels.Remove(P)

/obj/machinery/power/solar_control/drain_power()
	return -1

/obj/machinery/power/solar_control/disconnect_from_network()
	. = ..()
	GLOB.solars_list.Remove(src)
	needs_panel_check = TRUE

/obj/machinery/power/solar_control/connect_to_network()
	var/to_return = ..()
	if(powernet) //if connected and not already in solar_list...
		GLOB.solars_list |= src //... add it
		needs_panel_check = TRUE
	return to_return

//search for unconnected panels and trackers in the computer powernet and connect them
/obj/machinery/power/solar_control/proc/search_for_connected()
	if(powernet)
		for(var/obj/machinery/power/M in powernet.nodes)
			if(istype(M, /obj/machinery/power/solar))
				var/obj/machinery/power/solar/S = M
				if(!S.control && S.set_control(src)) //i.e unconnected
					add_panel(S)
			else if(istype(M, /obj/machinery/power/tracker))
				if(!connected_tracker) //if there's already a tracker connected to the computer don't add another
					var/obj/machinery/power/tracker/T = M
					if(!T.control) //i.e unconnected
						connected_tracker = T
						T.set_control(src)

//called by the SSsun.sun controller, update the facing angle (either manually or via tracking) and rotates the panels accordingly
/obj/machinery/power/solar_control/proc/update()
	if(stat & (NOPOWER | BROKEN))
		return

	switch(track)
		if(1)
			if(trackrate) //we're manual tracking. If we set a rotation speed...
				cdir = targetdir //...the current direction is the targetted one (and rotates panels to it)
		if(2) // auto-tracking
			if(connected_tracker)
				connected_tracker.set_angle(SSsun.sun.angle)

	set_panels(cdir)
	updateDialog()

/obj/machinery/power/solar_control/update_icon()
	if(stat & BROKEN)
		icon_state = "broken"
		cut_overlays()
		return
	if(stat & NOPOWER)
		icon_state = "c_unpowered"
		cut_overlays()
		return
	icon_state = "solar"
	cut_overlays()
	if(cdir > -1)
		add_overlay(image('icons/obj/computer.dmi', "solcon-o", FLY_LAYER, angle2dir(cdir)))
	return

/obj/machinery/power/solar_control/attack_hand(mob/user)
	if(..())
		return TRUE
	tgui_interact(user)

/obj/machinery/power/solar_control/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "SolarControl", name)
		ui.open()

/obj/machinery/power/solar_control/tgui_data()
	var/data = list()

	data["generated"] = round(connected_power)
	data["generated_ratio"] = data["generated"] / round(max(connected_panels.len, 1) * GLOB.solar_gen_rate)

	data["sun_angle"] = SSsun.sun.angle
	data["array_angle"] = cdir
	data["rotation_rate"] = trackrate
	data["max_rotation_rate"] = 7200
	data["tracking_state"] = track

	data["connected_panels"] = connected_panels.len
	data["connected_tracker"] = (connected_tracker ? TRUE : FALSE)

	return data

/obj/machinery/power/solar_control/attackby(obj/item/I, user as mob)
	if(I.has_tool_quality(TOOL_SCREWDRIVER))
		playsound(src, I.usesound, 50, 1)
		if(do_after(user, 20))
			if (src.stat & BROKEN)
				to_chat(user, "<font color='blue'>The broken glass falls out.</font>")
				var/obj/structure/frame/A = new /obj/structure/frame/computer( src.loc )
				new /obj/item/weapon/material/shard( src.loc )
				var/obj/item/weapon/circuitboard/solar_control/M = new /obj/item/weapon/circuitboard/solar_control( A )
				for (var/obj/C in src)
					C.loc = src.loc
				A.circuit = M
				A.state = 3
				A.icon_state = "computer_3"
				A.anchored = TRUE
				qdel(src)
			else
				to_chat(user, "<font color='blue'>You disconnect the monitor.</font>")
				var/obj/structure/frame/A = new /obj/structure/frame/computer( src.loc )
				var/obj/item/weapon/circuitboard/solar_control/M = new /obj/item/weapon/circuitboard/solar_control( A )
				for (var/obj/C in src)
					C.loc = src.loc
				A.circuit = M
				A.state = 4
				A.icon_state = "computer_4"
				A.anchored = TRUE
				qdel(src)
	else
		src.attack_hand(user)
	return

/obj/machinery/power/solar_control/process()
	if(stat & (NOPOWER | BROKEN))
		return

	if(connected_tracker) //NOTE : handled here so that we don't add trackers to the processing list
		if(connected_tracker.powernet != powernet)
			connected_tracker.unset_control()

	if(track==1 && trackrate) //manual tracking and set a rotation speed
		if(nexttime <= world.time) //every time we need to increase/decrease the angle by 1�...
			targetdir = (targetdir + trackrate/abs(trackrate) + 360) % 360 	//... do it
			nexttime += 36000/abs(trackrate) //reset the counter for the next 1�

	if(needs_panel_check)
		for(var/obj/machinery/power/solar/S in connected_panels)
			if (S.powernet != powernet)
				S.unset_control()
	if(powernet)
		add_avail(connected_power)

	updateDialog()

/obj/machinery/power/solar_control/tgui_act(action, params)
	if(..())
		return TRUE

	switch(action)
		if("azimuth")
			var/adjust = text2num(params["adjust"])
			var/value = text2num(params["value"])
			if(adjust)
				value = cdir + adjust
			if(value != null)
				cdir = value
				set_panels(cdir)
				return TRUE
			return FALSE
		if("azimuth_rate")
			var/adjust = text2num(params["adjust"])
			var/value = text2num(params["value"])
			if(adjust)
				value = trackrate + adjust
			if(value != null)
				trackrate = round(clamp(value, -7200, 7200), 0.01)
				if(trackrate)
					nexttime = world.time + 36000 / abs(trackrate)
				return TRUE
			return TRUE
		if("tracking")
			var/mode = text2num(params["mode"])
			track = mode
			if(track == 2)
				if(connected_tracker)
					connected_tracker.set_angle(SSsun.sun.angle)
					set_panels(cdir)
			else if(track == 1) //begin manual tracking
				targetdir = cdir
				if(trackrate)
					nexttime = world.time + 36000/abs(trackrate)
				set_panels(targetdir)
			return TRUE

		if("refresh")
			search_for_connected()
			return TRUE

//rotates the panel to the passed angle
/obj/machinery/power/solar_control/proc/set_panels(var/cdir)
	var/sum = 0
	for(var/obj/machinery/power/solar/S in connected_panels)
		S.adir = cdir //instantly rotates the panel
		S.occlusion()//and
		S.update_icon() //update it
		var/sgen = S.get_power_supplied()
		connected_panels[S] = sgen
		sum += sgen
	connected_power = sum
	update_icon()

/obj/machinery/power/solar_control/power_change()
	if((. = ..()))
		update_icon()


/obj/machinery/power/solar_control/proc/broken()
	stat |= BROKEN
	update_icon()


/obj/machinery/power/solar_control/ex_act(severity)
	switch(severity)
		if(1.0)
			//SN = null
			qdel(src)
			return
		if(2.0)
			if (prob(50))
				broken()
		if(3.0)
			if (prob(25))
				broken()
	return

//
// MISC
//

/obj/item/weapon/paper/solar
	name = "paper- 'Going green! Setup your own solar array instructions.'"
	info = "<h1>Welcome</h1><p>At greencorps we love the environment, and space. With this package you are able to help mother nature and produce energy without any usage of fossil fuel or phoron! Singularity energy is dangerous while solar energy is safe, which is why it's better. Now here is how you setup your own solar array.</p><p>You can make a solar panel by wrenching the solar assembly onto a cable node. Adding a glass panel, reinforced or regular glass will do, will finish the construction of your solar panel. It is that easy!</p><p>Now after setting up 19 more of these solar panels you will want to create a solar tracker to keep track of our mother nature's gift, the SSsun.sun. These are the same steps as before except you insert the tracker equipment circuit into the assembly before performing the final step of adding the glass. You now have a tracker! Now the last step is to add a computer to calculate the SSsun.sun's movements and to send commands to the solar panels to change direction with the SSsun.sun. Setting up the solar computer is the same as setting up any computer, so you should have no trouble in doing that. You do need to put a wire node under the computer, and the wire needs to be connected to the tracker.</p><p>Congratulations, you should have a working solar array. If you are having trouble, here are some tips. Make sure all solar equipment are on a cable node, even the computer. You can always deconstruct your creations if you make a mistake.</p><p>That's all to it, be safe, be green!</p>"
