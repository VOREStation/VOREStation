//
// Control computer for point defense batteries.
// Handles control UI, but also coordinates their fire to avoid overkill.
//

GLOBAL_LIST_BOILERPLATE(pointdefense_controllers, /obj/machinery/pointdefense_control)
<<<<<<< HEAD
GLOBAL_LIST_BOILERPLATE(pointdefense_turrets, /obj/machinery/power/pointdefense)
=======
GLOBAL_LIST_BOILERPLATE(pointdefense_turrets, /obj/machinery/pointdefense)
>>>>>>> 031f8a7... Merge pull request #7919 from Atermonera/point_defense_targeting

/obj/machinery/pointdefense_control
	name = "fire assist mainframe"
	desc = "A specialized computer designed to synchronize a variety of weapon systems and a vessel's astronav data."
<<<<<<< HEAD
=======
	description_info = "To connect the mainframe to turrets, use a multitool to set the ident tag to that of the turrets."
>>>>>>> 031f8a7... Merge pull request #7919 from Atermonera/point_defense_targeting
	icon = 'icons/obj/pointdefense.dmi'
	icon_state = "control"
	density = TRUE
	anchored = TRUE
	circuit = /obj/item/weapon/circuitboard/pointdefense_control
	var/list/targets = list()  // Targets being engaged by associated batteries
<<<<<<< HEAD
=======
	var/ui_template = "pointdefense_control.tmpl"
>>>>>>> 031f8a7... Merge pull request #7919 from Atermonera/point_defense_targeting
	var/id_tag = null

/obj/machinery/pointdefense_control/Initialize(mapload)
	. = ..()
	if(id_tag)
		//No more than 1 controller please.
		for(var/thing in pointdefense_controllers)
			var/obj/machinery/pointdefense_control/PC = thing
			if(PC != src && PC.id_tag == id_tag)
				warning("Two [src] with the same id_tag of [id_tag]")
				id_tag = null
	// TODO - Remove this bit once machines are converted to Initialize
	if(ispath(circuit))
		circuit = new circuit(src)
	default_apply_parts()

/obj/machinery/pointdefense_control/get_description_interaction()
	. = ..()
	if(!id_tag)
		. += "[desc_panel_image("multitool")]to set ident tag"

<<<<<<< HEAD
/obj/machinery/pointdefense_control/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "PointDefenseControl") // 400, 600
		ui.open()

/obj/machinery/pointdefense_control/attack_hand(mob/user)
	if(..())
		return TRUE
	tgui_interact(user)
	return TRUE

/obj/machinery/pointdefense_control/tgui_act(action, list/params, datum/tgui/ui, datum/tgui_state/state)
	if(..())
		return TRUE

	if(action == "toggle_active")
		var/obj/machinery/power/pointdefense/PD = locate(params["target"])
		if(!istype(PD))
			return FALSE

		//if(!lan || !lan.is_connected(PD))
		if(PD.id_tag != id_tag)
			return FALSE

		if(!(get_z(PD) in GetConnectedZlevels(get_z(src))))
			to_chat(usr, "<span class='warning'>[PD] is not within control range.</span>")
			return FALSE

		if(!PD.Activate()) //Activate() whilst the device is active will return false.
			PD.Deactivate()
		return TRUE

/obj/machinery/pointdefense_control/tgui_data(mob/user)
	var/list/data = list()
	data["id"] = id_tag
=======
/obj/machinery/pointdefense_control/ui_interact(var/mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)
	if(ui_template)
		var/list/data = build_ui_data()
		ui = SSnanoui.try_update_ui(user, src, ui_key, ui, data, force_open)
		if (!ui)
			ui = new(user, src, ui_key, ui_template, name, 400, 600)
			ui.set_initial_data(data)
			ui.open()
			ui.set_auto_update(1)

/obj/machinery/pointdefense_control/attack_hand(mob/user)
	if((. = ..()))
		return
	if(CanUseTopic(user, global.default_state) > STATUS_CLOSE)
		ui_interact(user)
		return TRUE

/obj/machinery/pointdefense_control/Topic(var/mob/user, var/href_list)
	if((. = ..()))
		return

	if(href_list["toggle_active"])
		var/obj/machinery/pointdefense/PD = locate(href_list["toggle_active"])
		if(!istype(PD))
			return TOPIC_NOACTION

		//if(!lan || !lan.is_connected(PD))
		if(PD.id_tag != id_tag)
			return TOPIC_NOACTION

		if(!(get_z(PD) in GetConnectedZlevels(get_z(src))))
			to_chat(user, "<span class='warning'>[PD] is not within control range.</span>")
			return TOPIC_NOACTION

		if(!PD.Activate()) //Activate() whilst the device is active will return false.
			PD.Deactivate()
		return TOPIC_REFRESH

/obj/machinery/pointdefense_control/proc/build_ui_data()
	var/list/data = list()
	data["id"] = id_tag
	data["name"] = name
>>>>>>> 031f8a7... Merge pull request #7919 from Atermonera/point_defense_targeting
	var/list/turrets = list()
	if(id_tag)
		var/list/connected_z_levels = GetConnectedZlevels(get_z(src))
		for(var/i = 1 to LAZYLEN(pointdefense_turrets))
<<<<<<< HEAD
			var/obj/machinery/power/pointdefense/PD = pointdefense_turrets[i]
=======
			var/obj/machinery/pointdefense/PD = pointdefense_turrets[i]
>>>>>>> 031f8a7... Merge pull request #7919 from Atermonera/point_defense_targeting
			if(!(PD.id_tag == id_tag && get_z(PD) in connected_z_levels))
				continue
			var/list/turret = list()
			turret["id"] =          "#[i]"
			turret["ref"] =         "\ref[PD]"
			turret["active"] =       PD.active
			turret["effective_range"] = PD.active ? "[PD.kill_range] meter\s" : "OFFLINE."
			turret["reaction_wheel_delay"] = PD.active ? "[(PD.rotation_speed / (1 SECONDS))] second\s" : "OFFLINE."
			turret["recharge_time"] = PD.active ? "[(PD.charge_cooldown / (1 SECONDS))] second\s" : "OFFLINE."

			turrets += list(turret)

	data["turrets"] = turrets
	return data

/obj/machinery/pointdefense_control/attackby(var/obj/item/W, var/mob/user)
	if(W?.is_multitool())
		var/new_ident = input(user, "Enter a new ident tag.", "[src]", id_tag) as null|text
<<<<<<< HEAD
		if(new_ident && new_ident != id_tag && user.Adjacent(src) && CanInteract(user, GLOB.tgui_physical_state))
=======
		if(new_ident && new_ident != id_tag && user.Adjacent(src) && CanInteract(user, physical_state))
>>>>>>> 031f8a7... Merge pull request #7919 from Atermonera/point_defense_targeting
			// Check for duplicate controllers with this ID
			for(var/thing in pointdefense_controllers)
				var/obj/machinery/pointdefense_control/PC = thing
				if(PC != src && PC.id_tag == id_tag)
					to_chat(user, "<span class='warning'>The [new_ident] network already has a controller.</span>")
					return
			to_chat(user, "<span class='notice'>You register [src] with the [new_ident] network.</span>")
			id_tag = new_ident
		return
	if(default_deconstruction_screwdriver(user, W))
		return
	if(default_deconstruction_crowbar(user, W))
		return
	if(default_part_replacement(user, W))
		return
	return ..()

//
// The acutal point defense battery
//

<<<<<<< HEAD
/obj/machinery/power/pointdefense
	name = "\improper point defense battery"
	icon = 'icons/obj/pointdefense.dmi'
	icon_state = "pointdefense2"
	desc = "A Kuiper pattern anti-meteor battery. Capable of destroying most threats in a single salvo."
	description_info = "Must have the same ident tag as a fire assist mainframe on the same facility."
=======
/obj/machinery/pointdefense
	name = "\improper point defense battery"
	icon = 'icons/obj/pointdefense.dmi'
	icon_state = "pointdefense"
	desc = "A Kuiper pattern anti-meteor battery. Capable of destroying most threats in a single salvo."
	description_info = "Must have the same ident tag as a fire assist mainframe on the same facility. Use a multitool to set the ident tag."
>>>>>>> 031f8a7... Merge pull request #7919 from Atermonera/point_defense_targeting
	density = TRUE
	anchored = TRUE
	circuit = /obj/item/weapon/circuitboard/pointdefense
	idle_power_usage = 0.1 KILOWATTS
<<<<<<< HEAD
	active_power_usage = 1 KILOWATTS
=======
>>>>>>> 031f8a7... Merge pull request #7919 from Atermonera/point_defense_targeting
	appearance_flags = PIXEL_SCALE
	var/active = TRUE
	var/charge_cooldown = 1 SECOND  //time between it can fire at different targets
	var/last_shot = 0
	var/kill_range = 18
	var/rotation_speed = 0.25 SECONDS  //How quickly we turn to face threats
<<<<<<< HEAD
	var/engaging = FALSE
	var/id_tag = null

/obj/machinery/power/pointdefense/Initialize()
=======
	var/weakref/engaging = null // The meteor we're shooting at
	var/id_tag = null

/obj/machinery/pointdefense/Initialize()
>>>>>>> 031f8a7... Merge pull request #7919 from Atermonera/point_defense_targeting
	. = ..()
	// TODO - Remove this bit once machines are converted to Initialize
	if(ispath(circuit))
		circuit = new circuit(src)
	default_apply_parts()
<<<<<<< HEAD
	if(anchored)
		connect_to_network()
	update_icon()
	var/image/I = image(icon, icon_state = "[icon_state]_under")
	I.appearance_flags |= RESET_TRANSFORM
	underlays += I

/obj/machinery/power/pointdefense/examine(mob/user)
	. = ..()
	if(powernet)
		. += "It is connected to a power cable below."

/obj/machinery/power/pointdefense/get_description_interaction()
=======
	update_icon()

/obj/machinery/pointdefense/get_description_interaction()
>>>>>>> 031f8a7... Merge pull request #7919 from Atermonera/point_defense_targeting
	. = ..()
	if(!id_tag)
		. += "[desc_panel_image("multitool")]to set ident tag and connect to a mainframe."

<<<<<<< HEAD
/obj/machinery/power/pointdefense/update_icon()
=======
/obj/machinery/pointdefense/update_icon()
>>>>>>> 031f8a7... Merge pull request #7919 from Atermonera/point_defense_targeting
	if(!active || !id_tag || inoperable())
		icon_state = "[initial(icon_state)]_off"
	else
		icon_state = initial(icon_state)

<<<<<<< HEAD
/obj/machinery/power/pointdefense/default_unfasten_wrench(var/mob/user, var/obj/item/weapon/W, var/time)
	if((. = ..()))
		src.transform = null // Reset rotation if we're anchored/unanchored

////////// This machine is willing to take power from cables OR APCs.  Handle NOPOWER stat specially here! ////////

/obj/machinery/power/pointdefense/connect_to_network()
	if((. = ..()))
		stat &= ~NOPOWER // We now ignore APC power
		update_icon()

/obj/machinery/power/pointdefense/disconnect_from_network()
	if((. = ..()))
		power_change() // We're back on APC power.

/obj/machinery/power/pointdefense/power_change()
	if(powernet)
		return // We don't care, we are cable powered anyway
=======
/obj/machinery/pointdefense/power_change()
>>>>>>> 031f8a7... Merge pull request #7919 from Atermonera/point_defense_targeting
	var/old_stat = stat
	..()
	if(old_stat != stat)
		update_icon()

<<<<<<< HEAD
// Decide where to get the power to fire from
/obj/machinery/power/pointdefense/use_power_oneoff(var/amount, var/chan = -1)
	if(powernet)
		return draw_power(amount)
	else if(powered(chan))
		use_power(amount, chan)
		return amount
	return 0

// Find controller with the same tag on connected z levels (if any)
/obj/machinery/power/pointdefense/proc/get_controller()
=======
// Find controller with the same tag on connected z levels (if any)
/obj/machinery/pointdefense/proc/get_controller()
>>>>>>> 031f8a7... Merge pull request #7919 from Atermonera/point_defense_targeting
	if(!id_tag)
		return null
	var/list/connected_z_levels = GetConnectedZlevels(get_z(src))
	for(var/thing in pointdefense_controllers)
		var/obj/machinery/pointdefense_control/PDC = thing
		if(PDC.id_tag == id_tag && (get_z(PDC) in connected_z_levels))
			return PDC

<<<<<<< HEAD
/obj/machinery/power/pointdefense/attackby(var/obj/item/W, var/mob/user)
	if(W?.is_multitool())
		var/new_ident = input(user, "Enter a new ident tag.", "[src]", id_tag) as null|text
		if(new_ident && new_ident != id_tag && user.Adjacent(src) && CanInteract(user, GLOB.tgui_physical_state))
=======
/obj/machinery/pointdefense/attackby(var/obj/item/W, var/mob/user)
	if(W?.is_multitool())
		var/new_ident = input(user, "Enter a new ident tag.", "[src]", id_tag) as null|text
		if(new_ident && new_ident != id_tag && user.Adjacent(src) && CanInteract(user, physical_state))
>>>>>>> 031f8a7... Merge pull request #7919 from Atermonera/point_defense_targeting
			to_chat(user, "<span class='notice'>You register [src] with the [new_ident] network.</span>")
			id_tag = new_ident
		return
	if(default_deconstruction_screwdriver(user, W))
		return
	if(default_deconstruction_crowbar(user, W))
		return
	if(default_part_replacement(user, W))
		return
<<<<<<< HEAD
	if(default_unfasten_wrench(user, W, 40))
		return
	return ..()

//Guns cannot shoot through hull or generally dense turfs.
/obj/machinery/power/pointdefense/proc/space_los(meteor)
=======
	return ..()

//Guns cannot shoot through hull or generally dense turfs.
/obj/machinery/pointdefense/proc/space_los(meteor)
>>>>>>> 031f8a7... Merge pull request #7919 from Atermonera/point_defense_targeting
	for(var/turf/T in getline(src,meteor))
		if(T.density)
			return FALSE
	return TRUE

<<<<<<< HEAD
/obj/machinery/power/pointdefense/proc/Shoot(var/weakref/target)
	var/obj/effect/meteor/M = target.resolve()
	if(!istype(M))
		return
	engaging = TRUE
=======
/obj/machinery/pointdefense/proc/Shoot(var/weakref/target)
	var/obj/effect/meteor/M = target.resolve()
	if(!istype(M))
		engaging = null
		return
	engaging = target
>>>>>>> 031f8a7... Merge pull request #7919 from Atermonera/point_defense_targeting
	var/Angle = round(Get_Angle(src,M))
	var/matrix/rot_matrix = matrix()
	rot_matrix.Turn(Angle)
	addtimer(CALLBACK(src, .proc/finish_shot, target), rotation_speed)
	animate(src, transform = rot_matrix, rotation_speed, easing = SINE_EASING)

	set_dir(ATAN2(transform.b, transform.a) > 0 ? NORTH : SOUTH)

<<<<<<< HEAD
/obj/machinery/power/pointdefense/proc/finish_shot(var/weakref/target)
	//Cleanup from list
	var/obj/machinery/pointdefense_control/PC = get_controller()
	if(istype(PC))
		PC.targets -= target

	engaging = FALSE
=======
/obj/machinery/pointdefense/proc/finish_shot(var/weakref/target)

	var/obj/machinery/pointdefense_control/PC = get_controller()
	engaging = null
	PC.targets -= target

>>>>>>> 031f8a7... Merge pull request #7919 from Atermonera/point_defense_targeting
	last_shot = world.time
	var/obj/effect/meteor/M = target.resolve()
	if(!istype(M))
		return
<<<<<<< HEAD
	if(use_power_oneoff(active_power_usage) < active_power_usage)
		var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
		s.set_up(5, 1, src)
		s.start()
		visible_message("[src] sputters as browns out while attempting to fire.")
		flick(src, "[initial(icon_state)]_off")
		return
	//We throw a laser but it doesnt have to hit for meteor to explode
	var/obj/item/projectile/beam/pointdefense/beam = new(get_turf(src))
	playsound(src, 'sound/weapons/mandalorian.ogg', 75, 1)
	beam.launch_projectile(target = M.loc, user = src)
	M.make_debris()
	qdel(M)

/obj/machinery/power/pointdefense/process()
	..()
	if(!anchored || stat & (NOPOWER|BROKEN))
		return
	if(!active)
		return
	/*
	var/desiredir = ATAN2(transform.b, transform.a) > 0 ? NORTH : SOUTH
	if(dir != desiredir)
		set_dir(desiredir)
	*/
	if(LAZYLEN(GLOB.meteor_list) > 0)
		find_and_shoot()

/obj/machinery/power/pointdefense/proc/find_and_shoot()
	if(LAZYLEN(GLOB.meteor_list) == 0)
		return
=======
	//We throw a laser but it doesnt have to hit for meteor to explode
	var/obj/item/projectile/beam/pointdefense/beam = new(get_turf(src))
	playsound(src, 'sound/weapons/mandalorian.ogg', 75, 1)
	use_power_oneoff(idle_power_usage * 10)
	beam.launch_projectile(target = M.loc, user = src)

/obj/machinery/pointdefense/process()
	..()
	if(stat & (NOPOWER|BROKEN))
		return
	if(!active)
		return
	var/desiredir = ATAN2(transform.b, transform.a) > 0 ? NORTH : SOUTH
	if(dir != desiredir)
		set_dir(desiredir)

	if(LAZYLEN(GLOB.meteor_list) > 0)
		find_and_shoot()

/obj/machinery/pointdefense/proc/find_and_shoot()
	// There ARE meteors to shoot
	if(LAZYLEN(GLOB.meteor_list) == 0)
		return
	// We can shoot
>>>>>>> 031f8a7... Merge pull request #7919 from Atermonera/point_defense_targeting
	if(engaging || ((world.time - last_shot) < charge_cooldown))
		return

	var/obj/machinery/pointdefense_control/PC = get_controller()
	if(!istype(PC))
		return
<<<<<<< HEAD

	var/list/connected_z_levels = GetConnectedZlevels(get_z(src))
	for(var/obj/effect/meteor/M in GLOB.meteor_list)
		var/already_targeted = FALSE
		for(var/weakref/WR in PC.targets)
			var/obj/effect/meteor/m = WR.resolve()
			if(m == M)
				already_targeted = TRUE
				break
			if(!istype(m))
				PC.targets -= WR

		if(already_targeted)
			continue

		if(!(M.z in connected_z_levels))
			continue
		if(get_dist(M, src) > kill_range)
			continue
		if(!emagged && space_los(M))
			var/weakref/target = weakref(M)
			PC.targets += target
			Shoot(target)
			return

/obj/machinery/power/pointdefense/RefreshParts()
=======
	
	// Compile list of known targets
	var/list/existing_targets = list()
	for(var/weakref/WR in PC.targets)
		var/obj/effect/meteor/M = WR.resolve()
		existing_targets += M

	// First, try and acquire new targets
	var/list/potential_targets = GLOB.meteor_list.Copy() - existing_targets
	for(var/obj/effect/meteor/M in potential_targets)
		if(targeting_check(M))
			var/weakref/target = weakref(M)
			PC.targets += target
			engaging = target
			Shoot(target)
			return

	// Then, focus fire on existing targets
	for(var/obj/effect/meteor/M in existing_targets)
		if(targeting_check(M))
			var/weakref/target = weakref(M)
			engaging = target
			Shoot(target)
			return
		
/obj/machinery/pointdefense/proc/targeting_check(var/obj/effect/meteor/M)
	// Target in range
	var/list/connected_z_levels = GetConnectedZlevels(get_z(src))
	if(!(M.z in connected_z_levels))
		return FALSE
	if(get_dist(M, src) > kill_range)
		return FALSE
	// If we can shoot it, then shoot
	if(emagged || !space_los(M))
		return FALSE
	
	return TRUE

/obj/machinery/pointdefense/RefreshParts()
>>>>>>> 031f8a7... Merge pull request #7919 from Atermonera/point_defense_targeting
	. = ..()
	// Calculates an average rating of components that affect shooting rate
	var/shootrate_divisor = total_component_rating_of_type(/obj/item/weapon/stock_parts/capacitor)

	charge_cooldown = 2 SECONDS / (shootrate_divisor ? shootrate_divisor : 1)

	//Calculate max shooting range
	var/killrange_multiplier = total_component_rating_of_type(/obj/item/weapon/stock_parts/capacitor)
	killrange_multiplier += 1.5 * total_component_rating_of_type(/obj/item/weapon/stock_parts/scanning_module)

	kill_range = 10 + 4 * killrange_multiplier

	var/rotation_divisor = total_component_rating_of_type(/obj/item/weapon/stock_parts/manipulator)
	rotation_speed = 0.5 SECONDS / (rotation_divisor ? rotation_divisor : 1)

<<<<<<< HEAD
/obj/machinery/power/pointdefense/proc/Activate()
=======
/obj/machinery/pointdefense/proc/Activate()
>>>>>>> 031f8a7... Merge pull request #7919 from Atermonera/point_defense_targeting
	if(active)
		return FALSE

	playsound(src, 'sound/weapons/flash.ogg', 100, 0)
	update_use_power(USE_POWER_IDLE)
	active = TRUE
	update_icon()
	return TRUE

<<<<<<< HEAD
/obj/machinery/power/pointdefense/proc/Deactivate()
=======
/obj/machinery/pointdefense/proc/Deactivate()
>>>>>>> 031f8a7... Merge pull request #7919 from Atermonera/point_defense_targeting
	if(!active)
		return FALSE
	playsound(src, 'sound/machines/apc_nopower.ogg', 50, 0)
	update_use_power(USE_POWER_OFF)
	active = FALSE
	update_icon()
	return TRUE
<<<<<<< HEAD

//
// Projectile Beam Definitions
//

/obj/item/projectile/beam/pointdefense
	name = "point defense salvo"
	icon_state = "laser"
	damage = 15
	damage_type = ELECTROCUTE //You should be safe inside a voidsuit
	sharp = FALSE //"Wide" spectrum beam
	light_color = COLOR_GOLD

	muzzle_type = /obj/effect/projectile/muzzle/pointdefense
	tracer_type = /obj/effect/projectile/tracer/pointdefense
	impact_type = /obj/effect/projectile/impact/pointdefense


/obj/effect/projectile/tracer/pointdefense
	icon = 'icons/obj/projectiles_vr.dmi'
	icon_state = "beam_pointdef"

/obj/effect/projectile/muzzle/pointdefense
	icon = 'icons/obj/projectiles_vr.dmi'
	icon_state = "muzzle_pointdef"

/obj/effect/projectile/impact/pointdefense
	icon = 'icons/obj/projectiles_vr.dmi'
	icon_state = "impact_pointdef"
=======
>>>>>>> 031f8a7... Merge pull request #7919 from Atermonera/point_defense_targeting
