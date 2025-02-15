#define MECHA_OPERATING     0
#define MECHA_BOLTS_SECURED 1
#define MECHA_PANEL_LOOSE   2
#define MECHA_CELL_OPEN     3
#define MECHA_CELL_OUT      4

/obj/mecha
	name = "Mecha"
	desc = "Exosuit"
	description_info = "Alt click to strafe."
	icon = 'icons/mecha/mecha.dmi'
	density = TRUE							//Dense. To raise the heat.
	opacity = 1							//Opaque. Menacing.
	anchored = TRUE						//No pulling around.
	unacidable = TRUE						//And no deleting hoomans inside
	layer = MOB_LAYER					//Icon draw layer
	infra_luminosity = 15				//Byond implementation is bugged.
	var/initial_icon = null				//Mech type for resetting icon. Only used for reskinning kits (see custom items)
	var/can_move = 1
	var/mob/living/carbon/occupant = null

	var/step_in = 10					//Make a step in step_in/10 sec.
	var/encumbrance_gap = 1			//How many points of slowdown are negated from equipment? Added to the mech's base step_in.

	var/dir_in = 2						//What direction will the mech face when entered/powered on? Defaults to South.
	var/step_energy_drain = 10
	var/health = 300 					//Health is health
	var/maxhealth = 300 				//Maxhealth is maxhealth.
	var/deflect_chance = 10 			//Chance to deflect the incoming projectiles, hits, or lesser the effect of ex_act.

	var/damage_minimum = 10				//Incoming damage lower than this won't actually deal damage. Scrapes shouldn't be a real thing.
	var/minimum_penetration = 15		//Incoming damage won't be fully applied if you don't have at least 20. Almost all AP clears this.
	var/fail_penetration_value = 0.66	//By how much failing to penetrate reduces your shit. 66% by default. 100dmg = 66dmg if failed pen

	var/obj/item/cell/cell
	var/state = MECHA_OPERATING
	var/list/log = new
	var/last_message = 0
	var/add_req_access = 1
	var/maint_access = 1
	var/dna								//Dna-locking the mech
	var/list/proc_res = list() 			//Stores proc owners, like proc_res["functionname"] = owner reference
	var/datum/effect/effect/system/spark_spread/spark_system = new
	var/lights = 0
	var/lights_power = 6
	var/force = 0

	var/mech_faction = null
	var/firstactivation = 0 			//It's simple. If it's 0, no one entered it yet. Otherwise someone entered it at least once.

	var/stomp_sound = 'sound/mecha/mechstep.ogg'
	var/swivel_sound = 'sound/mecha/mechturn.ogg'

	//inner atmos
	var/use_internal_tank = 0
	var/internal_tank_valve = ONE_ATMOSPHERE
	var/obj/machinery/portable_atmospherics/canister/internal_tank
	var/datum/gas_mixture/cabin_air
	var/obj/machinery/atmospherics/portables_connector/connected_port = null

	var/obj/item/radio/radio = null

	var/max_temperature = 25000			//Kelvin values.
	var/internal_damage_threshold = 33	//Health percentage below which internal damage is possible
	var/internal_damage_minimum = 15	//At least this much damage to trigger some real bad hurt.
	var/internal_damage = 0 			//Contains bitflags

	var/list/operation_req_access = list()								//Required access level for mecha operation
	var/list/internals_req_access = list(access_engine,access_robotics)	//Required access level to open cell compartment

	var/wreckage

	var/list/equipment = new		//This lists holds what stuff you bolted onto your baby ride
	var/obj/item/mecha_parts/mecha_equipment/selected
	var/max_equip = 2

	// What direction to float in, if inertial movement is active.
	var/float_direction = 0
	// Process() iterator count.
	var/process_ticks = 0
	// These control what toggleable processes are executed within process().
	var/current_processes = MECHA_PROC_INT_TEMP

//mechaequipt2 stuffs
	var/list/hull_equipment = new
	var/list/weapon_equipment = new
	var/list/utility_equipment = new
	var/list/universal_equipment = new
	var/list/special_equipment = new
	var/max_hull_equip = 2
	var/max_weapon_equip = 2
	var/max_utility_equip = 2
	var/max_universal_equip = 2
	var/max_special_equip = 1

	var/list/starting_equipment = null	// List containing starting tools.

// Mech Components, similar to Cyborg, but Bigger.
	var/list/internal_components = list(
		MECH_HULL = null,
		MECH_ACTUATOR = null,
		MECH_ARMOR = null,
		MECH_GAS = null,
		MECH_ELECTRIC = null
		)
	var/list/starting_components = list(
		/obj/item/mecha_parts/component/hull,
		/obj/item/mecha_parts/component/actuator,
		/obj/item/mecha_parts/component/armor,
		/obj/item/mecha_parts/component/gas,
		/obj/item/mecha_parts/component/electrical
		)

//Working exosuit vars
	var/list/cargo = list()
	var/cargo_capacity = 3

	var/static/image/radial_image_eject = image(icon = 'icons/mob/radial.dmi', icon_state = "radial_eject")
	var/static/image/radial_image_airtoggle = image(icon= 'icons/mob/radial.dmi', icon_state = "radial_airtank")
	var/static/image/radial_image_lighttoggle = image(icon = 'icons/mob/radial.dmi', icon_state = "radial_light")
	var/static/image/radial_image_statpanel = image(icon = 'icons/mob/radial.dmi', icon_state = "radial_examine2")

//Mech actions
	var/datum/mini_hud/mech/minihud //VOREStation Edit
	var/strafing = 0 				//Are we strafing or not?

	var/defence_mode_possible = 0 	//Can we even use defence mode? This is used to assign it to mechs and check for verbs.
	var/defence_mode = 0 			//Are we in defence mode
	var/defence_deflect = 35		//How much it deflect

	var/overload_possible = 0 		//Same as above. Don't forget to GRANT the verb&actions if you want everything to work proper.
	var/overload = 0 				//Are our legs overloaded
	var/overload_coeff = 1			//How much extra energy you use when use the L E G

	var/zoom = 0
	var/zoom_possible = 0

	var/thrusters = 0
	var/thrusters_possible = 0

	var/phasing = 0					//Are we currently phasing
	var/phasing_possible = 0		//This is to allow phasing.
	var/can_phase = TRUE			//This is an internal check during the relevant procs.
	var/phasing_energy_drain = 200

	var/switch_dmg_type_possible = 0	//Can you switch damage type? It is mostly for the Phazon and its children.

	var/smoke_possible = 0
	var/smoke_reserve = 5			//How many shots you have. Might make a reload later on. MIGHT.
	var/smoke_ready = 1				//This is a check for the whether or not the cooldown is ongoing.
	var/smoke_cooldown = 100		//How long you have between uses.
	var/datum/effect/effect/system/smoke_spread/smoke_system = new

	var/cloak_possible = FALSE		// Can this exosuit innately cloak?

////All of those are for the HUD buttons in the top left. See Grant and Remove procs in mecha_actions.

	var/datum/action/innate/mecha/mech_eject/eject_action = new
	var/datum/action/innate/mecha/mech_toggle_internals/internals_action = new
	var/datum/action/innate/mecha/mech_toggle_lights/lights_action = new
	var/datum/action/innate/mecha/mech_view_stats/stats_action = new
	var/datum/action/innate/mecha/strafe/strafing_action = new

	var/datum/action/innate/mecha/mech_defence_mode/defence_action = new
	var/datum/action/innate/mecha/mech_overload_mode/overload_action = new
	var/datum/action/innate/mecha/mech_smoke/smoke_action = new
	var/datum/action/innate/mecha/mech_zoom/zoom_action = new
	var/datum/action/innate/mecha/mech_toggle_thrusters/thrusters_action = new
	var/datum/action/innate/mecha/mech_cycle_equip/cycle_action = new
	var/datum/action/innate/mecha/mech_switch_damtype/switch_damtype_action = new
	var/datum/action/innate/mecha/mech_toggle_phasing/phasing_action = new
	var/datum/action/innate/mecha/mech_toggle_cloaking/cloak_action = new

	var/weapons_only_cycle = FALSE	//So combat mechs don't switch to their equipment at times.

/obj/mecha/Initialize(mapload)
	. = ..()

	for(var/path in starting_components)
		var/obj/item/mecha_parts/component/C = new path(src)
		C.attach(src)

	if(starting_equipment && LAZYLEN(starting_equipment))
		for(var/path in starting_equipment)
			var/obj/item/mecha_parts/mecha_equipment/ME = new path(src)
			ME.attach(src)

	START_PROCESSING(SSobj, src)

	update_transform()

	icon_state += "-open"
	add_radio()
	add_cabin()
	if(!add_airtank()) //we check this here in case mecha does not have an internal tank available by default - WIP
		removeVerb(/obj/mecha/verb/connect_to_port)
		removeVerb(/obj/mecha/verb/toggle_internal_tank)

	spark_system.set_up(2, 0, src)
	spark_system.attach(src)

	if(smoke_possible)//I am pretty sure that's needed here.
		src.smoke_system.set_up(3, 0, src)
		src.smoke_system.attach(src)

	add_cell()
	removeVerb(/obj/mecha/verb/disconnect_from_port)
	log_message("[src.name] created.")
	loc.Entered(src)
	mechas_list += src //global mech list

/obj/mecha/drain_power(var/drain_check)

	if(drain_check)
		return 1

	if(!cell)
		return 0

	return cell.drain_power(drain_check)

/obj/mecha/Exit(atom/movable/O)
	if(O in cargo)
		return 0
	return ..()

/obj/mecha/Destroy()
	src.go_out()
	for(var/mob/M in src) //Be Extra Sure
		M.forceMove(get_turf(src))
		M.loc.Entered(M)
		if(M != src.occupant)
			step_rand(M)
	for(var/atom/movable/A in src.cargo)
		A.forceMove(get_turf(src))
		var/turf/T = get_turf(A)
		if(T)
			T.Entered(A)
		step_rand(A)

	if(loc)
		loc.Exited(src)

	if(prob(30))
		explosion(get_turf(loc), 0, 0, 1, 3)

	if(wreckage)
		var/obj/effect/decal/mecha_wreckage/WR = new wreckage(loc)
		hull_equipment.Cut()
		weapon_equipment.Cut()
		utility_equipment.Cut()
		universal_equipment.Cut()
		special_equipment.Cut()
		for(var/obj/item/mecha_parts/mecha_equipment/E in equipment)
			if(E.salvageable && prob(30))
				WR.crowbar_salvage += E
				E.forceMove(WR)
				E.equip_ready = TRUE
			else
				E.forceMove(loc)
				E.destroy()

		for(var/slot in internal_components)
			var/obj/item/mecha_parts/component/C = internal_components[slot]
			if(istype(C))
				C.damage_part(rand(10, 20))
				C.detach()
				WR.crowbar_salvage += C
				C.forceMove(WR)

		if(cell)
			WR.crowbar_salvage += cell
			cell.forceMove(WR)
			cell.charge = rand(0, cell.charge)
		if(internal_tank)
			WR.crowbar_salvage += internal_tank
			internal_tank.forceMove(WR)
	else
		for(var/obj/item/mecha_parts/mecha_equipment/E in equipment)
			E.detach(loc)
			E.destroy()
		for(var/slot in internal_components)
			var/obj/item/mecha_parts/component/C = internal_components[slot]
			if(istype(C))
				C.detach()
				qdel(C)
		if(cell)
			qdel(cell)
		if(internal_tank)
			qdel(internal_tank)
	equipment.Cut()
	cell = null
	internal_tank = null

	if(smoke_possible)	//Just making sure nothing is running.
		qdel(smoke_system)

	GLOB.mech_destroyed_roundstat++

	QDEL_NULL(spark_system)
	QDEL_NULL(minihud)

	STOP_PROCESSING(SSobj, src)

	mechas_list -= src //global mech list
	. = ..()

// The main process loop to replace the ancient global iterators.
// It's a bit hardcoded but I don't see anyone else adding stuff to
// mechas, and it's easy enough to modify.
/obj/mecha/process()
	var/static/max_ticks = 16

	if (current_processes & MECHA_PROC_MOVEMENT)
		process_inertial_movement()

	if ((current_processes & MECHA_PROC_DAMAGE) && !(process_ticks % 2))
		process_internal_damage()

	if ((current_processes & MECHA_PROC_INT_TEMP) && !(process_ticks % 4))
		process_preserve_temp()

	if (!(process_ticks % 3))
		process_tank_give_air()

	// Max value is 16. So we let it run between [0, 16] with this.
	process_ticks = (process_ticks + 1) % 17

// Normalizing cabin air temperature to 20 degrees celsius.
// Called every fourth process() tick (20 deciseconds).
/obj/mecha/proc/process_preserve_temp()
	if (cabin_air && cabin_air.volume > 0)
		var/delta = cabin_air.temperature - T20C
		cabin_air.temperature -= max(-10, min(10, round(delta/4,0.1)))

// Handles internal air tank action.
// Called every third process() tick (15 deciseconds).
/obj/mecha/proc/process_tank_give_air()
	if(internal_tank)
		var/datum/gas_mixture/tank_air = internal_tank.return_air()

		var/release_pressure = internal_tank_valve
		var/cabin_pressure = cabin_air.return_pressure()
		var/pressure_delta = min(release_pressure - cabin_pressure, (tank_air.return_pressure() - cabin_pressure)/2)
		var/transfer_moles = 0

		if(pressure_delta > 0) //cabin pressure lower than release pressure
			if(tank_air.temperature > 0)
				transfer_moles = pressure_delta*cabin_air.volume/(cabin_air.temperature * R_IDEAL_GAS_EQUATION)
				var/datum/gas_mixture/removed = tank_air.remove(transfer_moles)
				cabin_air.merge(removed)

		else if(pressure_delta < 0) //cabin pressure higher than release pressure
			var/datum/gas_mixture/t_air = get_turf_air()
			pressure_delta = cabin_pressure - release_pressure

			if(t_air)
				pressure_delta = min(cabin_pressure - t_air.return_pressure(), pressure_delta)
			if(pressure_delta > 0) //if location pressure is lower than cabin pressure
				transfer_moles = pressure_delta*cabin_air.volume/(cabin_air.temperature * R_IDEAL_GAS_EQUATION)

				var/datum/gas_mixture/removed = cabin_air.remove(transfer_moles)
				if(t_air)
					t_air.merge(removed)
				else //just delete the cabin gas, we're in space or some shit
					qdel(removed)

// Inertial movement in space.
// Called every process() tick (5 deciseconds).
/obj/mecha/proc/process_inertial_movement()
	if(float_direction)
		if(!step(src, float_direction) || check_for_support())
			stop_process(MECHA_PROC_MOVEMENT)
	else
		stop_process(MECHA_PROC_MOVEMENT)
	return

// Processes internal damage.
// Called every other process() tick (10 deciseconds).
/obj/mecha/proc/process_internal_damage()
	if(!hasInternalDamage())
		stop_process(MECHA_PROC_DAMAGE)
		return

	if(hasInternalDamage(MECHA_INT_FIRE))
		if(!hasInternalDamage(MECHA_INT_TEMP_CONTROL) && prob(5))
			clearInternalDamage(MECHA_INT_FIRE)
		if(internal_tank)
			if(internal_tank.return_pressure()>internal_tank.maximum_pressure && !(hasInternalDamage(MECHA_INT_TANK_BREACH)))
				setInternalDamage(MECHA_INT_TANK_BREACH)
			var/datum/gas_mixture/int_tank_air = internal_tank.return_air()
			if(int_tank_air && int_tank_air.volume>0) //heat the air_contents
				int_tank_air.temperature = min(6000+T0C, int_tank_air.temperature+rand(10,15))
		if(cabin_air && cabin_air.volume>0)
			cabin_air.temperature = min(6000+T0C, cabin_air.temperature+rand(10,15))
			if(cabin_air.temperature>max_temperature/2)
				take_damage(4/round(max_temperature/cabin_air.temperature,0.1),"fire")

	if(hasInternalDamage(MECHA_INT_TEMP_CONTROL))
		stop_process(MECHA_PROC_INT_TEMP)

	if(hasInternalDamage(MECHA_INT_TANK_BREACH)) //remove some air from internal tank
		if(internal_tank)
			var/datum/gas_mixture/int_tank_air = internal_tank.return_air()
			var/datum/gas_mixture/leaked_gas = int_tank_air.remove_ratio(0.10)
			if(istype(loc, /turf/simulated))
				loc.assume_air(leaked_gas)
			else
				qdel(leaked_gas)

	if(hasInternalDamage(MECHA_INT_SHORT_CIRCUIT))
		if(get_charge())
			spark_system.start()
			cell.charge -= min(20,cell.charge)
			cell.maxcharge -= min(20,cell.maxcharge)
	return

////////////////////////
////// Helpers /////////
////////////////////////

/obj/mecha/proc/removeVerb(verb_path)
	src.verbs -= verb_path

/obj/mecha/proc/addVerb(verb_path)
	src.verbs += verb_path

/obj/mecha/proc/add_airtank()
	internal_tank = new /obj/machinery/portable_atmospherics/canister/air(src)
	return internal_tank

/obj/mecha/proc/add_cell(var/obj/item/cell/C=null)
	if(C)
		C.forceMove(src)
		cell = C
		return
	cell = new /obj/item/cell/mech(src)

/obj/mecha/get_cell()
	return cell

/obj/mecha/proc/add_cabin()
	cabin_air = new
	cabin_air.temperature = T20C
	cabin_air.volume = 200
	cabin_air.adjust_multi(GAS_O2, O2STANDARD*cabin_air.volume/(R_IDEAL_GAS_EQUATION*cabin_air.temperature), GAS_N2, N2STANDARD*cabin_air.volume/(R_IDEAL_GAS_EQUATION*cabin_air.temperature))
	return cabin_air

/obj/mecha/proc/add_radio()
	radio = new(src)
	radio.name = "[src] radio"
	radio.icon = icon
	radio.icon_state = icon_state
	radio.subspace_transmission = 1

/obj/mecha/proc/do_after(delay as num)
	sleep(delay)
	if(src)
		return 1
	return 0

/obj/mecha/proc/enter_after(delay as num, var/mob/user as mob, var/numticks = 5)
	var/delayfraction = delay/numticks

	var/turf/T = user.loc

	for(var/i = 0, i<numticks, i++)
		sleep(delayfraction)
		if(!src || !user || !user.canmove || !(user.loc == T))
			return 0

	return 1



/obj/mecha/proc/check_for_support()
	var/list/things = orange(1, src)

	if(locate(/obj/structure/grille) in things || locate(/obj/structure/lattice) in things || locate(/turf/simulated) in things || locate(/turf/unsimulated) in things)
		return 1
	else
		return 0

/obj/mecha/examine(mob/user)
	. = ..()

	var/obj/item/mecha_parts/component/armor/AC = internal_components[MECH_ARMOR]

	var/obj/item/mecha_parts/component/hull/HC = internal_components[MECH_HULL]

	if(AC)
		. += "It has [AC] attached. [AC.get_efficiency()<0.5?"It is severely damaged.":""]"
	else
		. += "It has no armor plating."

	if(HC)
		if(!AC || AC.get_efficiency() < 0.7)
			. += "It has [HC] attached. [HC.get_efficiency()<0.5?"It is severely damaged.":""]"
		else
			. += "You cannot tell what type of hull it has."

	else
		. += "It does not seem to have a completed hull."


	var/integrity = health/initial(health)*100
	switch(integrity)
		if(85 to 100)
			. += "It's fully intact."
		if(65 to 85)
			. += "It's slightly damaged."
		if(45 to 65)
			. += span_notice("It's badly damaged.")
		if(25 to 45)
			. += span_warning("It's heavily damaged.")
		else
			. += span_warning(span_bold(" It's falling apart.") + " ")
	if(equipment?.len)
		. += "It's equipped with:"
		for(var/obj/item/mecha_parts/mecha_equipment/ME in equipment)
			. += "[icon2html(ME,user.client)] [ME]"

/obj/mecha/proc/drop_item()//Derpfix, but may be useful in future for engineering exosuits.
	return

/obj/mecha/hear_talk(mob/M, list/message_pieces, verb)
	if(M == occupant && radio.broadcasting)
		radio.talk_into(M, message_pieces)

/obj/mecha/proc/check_occupant_radial(var/mob/user)
	if(!user)
		return FALSE
	if(user.stat)
		return FALSE
	if(user != occupant)
		return FALSE
	if(user.incapacitated())
		return FALSE

	return TRUE

/obj/mecha/proc/show_radial_occupant(var/mob/user)
	var/list/choices = list(
		"Toggle Airtank" = radial_image_airtoggle,
		"Toggle Light" = radial_image_lighttoggle,
		"View Stats" = radial_image_statpanel
	)

	var/choice = show_radial_menu(user, src, choices, custom_check = CALLBACK(src, PROC_REF(check_occupant_radial), user), require_near = TRUE, tooltips = TRUE)
	if(!check_occupant_radial(user))
		return
	if(!choice)
		return
	switch(choice)
		if("Toggle Airtank")
			use_internal_tank = !use_internal_tank
			occupant_message("Now taking air from [use_internal_tank?"internal airtank":"environment"].")
			log_message("Now taking air from [use_internal_tank?"internal airtank":"environment"].")
		if("Toggle Light")
			lights = !lights
			if(lights)
				set_light(light_range + lights_power)
			else
				set_light(light_range - lights_power)
			occupant_message("Toggled lights [lights?"on":"off"].")
			log_message("Toggled lights [lights?"on":"off"].")
			playsound(src, 'sound/mecha/heavylightswitch.ogg', 50, 1)
		if("View Stats")
			occupant << browse(src.get_stats_html(), "window=exosuit")


////////////////////////////
///// Action processing ////
////////////////////////////
/*
/atom/DblClick(object,location,control,params)
	var/mob/M = src.mob
	if(M && M.in_contents_of(/obj/mecha))

		if(mech_click == world.time) return
		mech_click = world.time

		if(!istype(object, /atom)) return
		if(istype(object, /obj/screen))
			var/obj/screen/using = object
			if(using.screen_loc == ui_acti || using.screen_loc == ui_iarrowleft || using.screen_loc == ui_iarrowright)//ignore all HUD objects save 'intent' and its arrows
				return ..()
			else
				return
		var/obj/mecha/Mech = M.loc
		spawn() //this helps prevent clickspam fest.
			if (Mech)
				Mech.click_action(object,M)
//	else
//		return ..()
*/

/obj/mecha/proc/click_action(atom/target,mob/user, params)
	if(!src.occupant || src.occupant != user ) return
	if(user.stat) return
	if(target == src && user == occupant)
		show_radial_occupant(user)
		return
	if(state)
		occupant_message(span_red("Maintenance protocols in effect"))
		return

	if(phasing)//Phazon and other mechs with phasing.
		src.occupant_message("Unable to interact with objects while phasing")//Haha dumbass.
		return

	if(!get_charge()) return
	if(src == target) return
	var/dir_to_target = get_dir(src,target)
	if(dir_to_target && !(dir_to_target & src.dir))//wrong direction
		return
	if(hasInternalDamage(MECHA_INT_CONTROL_LOST))
		target = safepick(view(3,target))
		if(!target)
			return
	if(istype(target, /obj/machinery))
		if (src.interface_action(target))
			return
	if(!target.Adjacent(src))
		if(selected && selected.is_ranged())
			selected.action(target)
	else if(selected && selected.is_melee())
		selected.action(target, params)
	else
		src.melee_action(target)
	return

/obj/mecha/proc/interface_action(obj/machinery/target)
	if(istype(target, /obj/machinery/access_button))
		src.occupant_message(span_notice("Interfacing with [target]."))
		src.log_message("Interfaced with [target].")
		target.attack_hand(src.occupant)
		return 1
	if(istype(target, /obj/machinery/embedded_controller))
		target.tgui_interact(src.occupant)
		return 1
	return 0

/obj/mecha/contents_tgui_distance(var/src_object, var/mob/living/user)
	. = user.shared_living_tgui_distance(src_object) //allow them to interact with anything they can interact with normally.
	if(. != STATUS_INTERACTIVE)
		//Allow interaction with the mecha or anything that is part of the mecha
		if(src_object == src || (src_object in src))
			return STATUS_INTERACTIVE
		if(src.Adjacent(src_object))
			src.occupant_message(span_notice("Interfacing with [src_object]..."))
			src.log_message("Interfaced with [src_object].")
			return STATUS_INTERACTIVE
		if(src_object in view(2, src))
			return STATUS_UPDATE //if they're close enough, allow the occupant to see the screen through the viewport or whatever.

/obj/mecha/proc/melee_action(atom/target)
	return

/obj/mecha/proc/range_action(atom/target)
	return


//////////////////////////////////
////////  Movement procs  ////////
//////////////////////////////////

/obj/mecha/Moved(atom/old_loc, direction, forced = FALSE)
	. = ..()
	MoveAction()

/obj/mecha/proc/MoveAction() //Allows mech equipment to do an action once the mech moves
	if(!equipment.len)
		return

	for(var/obj/item/mecha_parts/mecha_equipment/ME in equipment)
		ME.MoveAction()

/obj/mecha/relaymove(mob/user,direction)
	if(user != src.occupant) //While not "realistic", this piece is player friendly.
		if(istype(user,/mob/living/carbon/brain))
			to_chat(user, span_warning("You try to move, but you are not the pilot! The exosuit doesn't respond."))
			return 0
		user.forceMove(get_turf(src))
		to_chat(user, "You climb out from [src]")
		return 0

	var/obj/item/mecha_parts/component/hull/HC = internal_components[MECH_HULL]
	if(!HC)
		occupant_message(span_notice("You can't operate an exosuit that doesn't have a hull!"))
		return

	if(connected_port)
		if(world.time - last_message > 20)
			src.occupant_message(span_warning("Unable to move while connected to the air system port"))
			last_message = world.time
		return 0
	if(state)
		occupant_message(span_warning("Maintenance protocols in effect"))
		return
/*
	if(zoom)
		if(world.time - last_message > 20)
			src.occupant_message("Unable to move while in zoom mode.")
			last_message = world.time
		return 0
*/
	return domove(direction)

/obj/mecha/proc/can_ztravel()
	for(var/obj/item/mecha_parts/mecha_equipment/tool/jetpack/jp in equipment)
		return jp.equip_ready
	return FALSE

/obj/mecha/proc/domove(direction)

	return call((proc_res["dyndomove"]||src), "dyndomove")(direction)

/obj/mecha/proc/get_step_delay()
	var/tally = 0

	if(LAZYLEN(equipment))
		for(var/obj/item/mecha_parts/mecha_equipment/ME in equipment)
			if(ME.get_step_delay())
				tally += ME.get_step_delay()

		if(tally <= encumbrance_gap)	// If the total is less than our encumbrance gap, ignore equipment weight.
			tally = 0
		else	// Otherwise, start the tally after cutting that gap out.
			tally -= encumbrance_gap

	for(var/slot in internal_components)
		var/obj/item/mecha_parts/component/C = internal_components[slot]
		if(C && C.get_step_delay())
			tally += C.get_step_delay()

	var/obj/item/mecha_parts/component/actuator/actuator = internal_components[MECH_ACTUATOR]

	if(!actuator)	// Relying purely on hydraulic pumps. You're going nowhere fast.
		tally = 2 SECONDS

		return tally

	tally += 0.5 SECONDS * (1 - actuator.get_efficiency())	// Damaged actuators run slower, slowing as damage increases beyond its threshold.

	if(strafing)
		tally = round(tally * actuator.strafing_multiplier)

	for(var/obj/item/mecha_parts/mecha_equipment/ME in equipment)
		if(istype(ME, /obj/item/mecha_parts/mecha_equipment/speedboost))
			var/obj/item/mecha_parts/mecha_equipment/speedboost/SB = ME
			for(var/path in ME.required_type)
				if(istype(src, path))
					tally = round(tally * SB.slowdown_multiplier)
					break
			break

	if(overload)	// At the end, because this would normally just make the mech *slower* since tally wasn't starting at 0.
		tally = min(1, round(tally/2))

	return max(1, round(tally, 0.1))	// Round the total to the nearest 10th. Can't go lower than 1 tick. Even humans have a delay longer than that.

/obj/mecha/proc/dyndomove(direction)
	if(!can_move)
		return 0
	if(current_processes & MECHA_PROC_MOVEMENT)
		return 0
	if(!has_charge(step_energy_drain))
		return 0

	//Can we even move, below is if yes.

	if(defence_mode)//Check if we are currently locked down
		if(world.time - last_message > 20)
			src.occupant_message(span_red("Unable to move while in defence mode"))
			last_message = world.time
		return 0

	if(zoom)//:eyes:
		if(world.time - last_message > 20)
			src.occupant_message("Unable to move while in zoom mode.")
			last_message = world.time
		return 0

	if(!thrusters && (current_processes & MECHA_PROC_MOVEMENT)) //I think this mean 'if you try to move in space without thruster, u no move'
		return 0

	if(overload)//Check if you have leg overload
		health--
		if(health < initial(health) - initial(health)/3)
			overload = 0
			step_energy_drain = initial(step_energy_drain)
			src.occupant_message(span_red("Leg actuators damage threshold exceded. Disabling overload."))


	var/move_result = 0

	if(hasInternalDamage(MECHA_INT_CONTROL_LOST))
		move_result = mechsteprand()
	//Up/down zmove
	else if(direction == UP || direction == DOWN)
		if(!can_ztravel())
			occupant_message(span_warning("Your vehicle lacks the capacity to move in that direction!"))
			return FALSE

		//We're using locs because some mecha are 2x2 turfs. So thicc!
		var/result = TRUE

		for(var/turf/T in locs)
			if(!T.CanZPass(src,direction))
				occupant_message(span_warning("You can't move that direction from here!"))
				result = FALSE
				break
			var/turf/dest = (direction == UP) ? GetAbove(src) : GetBelow(src)
			if(!dest)
				occupant_message(span_notice("There is nothing of interest in this direction."))
				result = FALSE
				break
			if(!dest.CanZPass(src,direction))
				occupant_message(span_warning("There's something blocking your movement in that direction!"))
				result = FALSE
				break
		if(result)
			move_result = mechstep(direction)

	//Turning

	else if(src.dir != direction)

		if(strafing)
			move_result = mechstep(direction)
		else
			move_result = mechturn(direction)

	//Stepping
	else
		move_result	= mechstep(direction)


	if(move_result)
		can_move = 0
		use_power(step_energy_drain)
		if(istype(src.loc, /turf/space))
			if(!src.check_for_support())
				float_direction = direction
				start_process(MECHA_PROC_MOVEMENT)
				src.log_message(span_warning("Movement control lost. Inertial movement started."))
		if(do_after(get_step_delay()))
			can_move = 1
		return 1
	return 0

/obj/mecha/proc/handle_equipment_movement()
	for(var/obj/item/mecha_parts/mecha_equipment/ME in equipment)
		if(ME.chassis == src) //Sanity
			ME.handle_movement_action()
	return

/obj/mecha/proc/mechturn(direction)
	set_dir(direction)
	if(swivel_sound)
		playsound(src,swivel_sound,40,1)
	return 1

/obj/mecha/proc/mechstep(direction)
	var/current_dir = dir	//For strafing
	var/result = get_step(src,direction)
	if(result && Move(result))
		if(stomp_sound)
			playsound(src,stomp_sound,40,1)
		handle_equipment_movement()
	if(strafing)	//Also for strafing
		set_dir(current_dir)
	return result


/obj/mecha/proc/mechsteprand()
	var/result = get_step_rand(src)
	if(result && Move(result))
		if(stomp_sound)
			playsound(src,stomp_sound,40,1)
		handle_equipment_movement()
	return result

/obj/mecha/Bump(var/atom/obstacle)
//	src.inertia_dir = null
	if(istype(obstacle, /mob))//First we check if it is a mob. Mechs mostly shouln't go through them, even while phasing.
		var/mob/M = obstacle
		M.Move(get_step(obstacle,src.dir))
	else if(phasing && get_charge()>=phasing_energy_drain)//Phazon check. This could use an improvement elsewhere.
		src.use_power(phasing_energy_drain)
		phase()
		. = ..(obstacle)
		return
	else if(istype(obstacle, /obj))//Then we check for regular obstacles.
		var/obj/O = obstacle
		if(istype(O, /obj/effect/portal))	//derpfix
			src.anchored = 0				// Portals can only move unanchored objects.
			O.Crossed(src)
			spawn(0)//countering portal teleport spawn(0), hurr
				src.anchored = 1
		if(O.anchored)
			obstacle.Bumped(src)
		else
			step(obstacle,src.dir)

	else//No idea when this triggers, so i won't touch it.
		. = ..(obstacle)
	return

/obj/mecha/proc/phase()	// Force the mecha to move forward by phasing.
	set waitfor = FALSE
	if(can_phase)
		can_phase = FALSE
		flick("[initial_icon]-phase", src)
		forceMove(get_step(src,src.dir))
		sleep(get_step_delay() * 3)
		can_phase = TRUE
		occupant_message("Phazed.")
		return TRUE	// In the event this is sequenced
	return FALSE

///////////////////////////////////
////////  Internal damage  ////////
///////////////////////////////////

//ATM, the ignore_threshold is literally only used for the pulse rifles beams used mostly by deathsquads.
/obj/mecha/proc/check_for_internal_damage(var/list/possible_int_damage,var/ignore_threshold=null)
	if(!islist(possible_int_damage) || isemptylist(possible_int_damage)) return
	if(prob(30))
		if(ignore_threshold || src.health*100/initial(src.health) < src.internal_damage_threshold)
			for(var/T in possible_int_damage)
				if(internal_damage & T)
					possible_int_damage -= T
			var/int_dam_flag = safepick(possible_int_damage)
			if(int_dam_flag)
				setInternalDamage(int_dam_flag)
			return	//It already hurts to get some, lets not get both.

	if(prob(10))
		if(ignore_threshold || src.health*100/initial(src.health) < src.internal_damage_threshold)
			var/obj/item/mecha_parts/mecha_equipment/destr = safepick(equipment)
			if(destr)
				destr.destroy()
	return

/obj/mecha/proc/hasInternalDamage(int_dam_flag=null)
	return int_dam_flag ? internal_damage&int_dam_flag : internal_damage


/obj/mecha/proc/setInternalDamage(int_dam_flag)
	internal_damage |= int_dam_flag
	start_process(MECHA_PROC_DAMAGE)
	log_append_to_last("Internal damage of type [int_dam_flag].",1)
	occupant << sound('sound/mecha/internaldmgalarm.ogg',volume=50) //Better sounding.
	return

/obj/mecha/proc/clearInternalDamage(int_dam_flag)
	internal_damage &= ~int_dam_flag
	switch(int_dam_flag)
		if(MECHA_INT_TEMP_CONTROL)
			occupant_message(span_infoplain(span_blue(span_bold("Life support system reactivated."))))
			start_process(MECHA_PROC_INT_TEMP)
		if(MECHA_INT_FIRE)
			occupant_message(span_infoplain(span_blue(span_bold("Internal fire extinquished."))))
		if(MECHA_INT_TANK_BREACH)
			occupant_message(span_infoplain(span_blue(span_bold("Damaged internal tank has been sealed."))))
	return


////////////////////////////////////////
////////  Health related procs  ////////
////////////////////////////////////////

/obj/mecha/take_damage(amount, type="brute")
	update_damage_alerts()
	if(amount)
		var/damage = absorbDamage(amount,type)

		damage = components_handle_damage(damage,type)

		health -= damage

		update_health()
		log_append_to_last("Took [damage] points of damage. Damage type: \"[type]\".",1)
	return

/obj/mecha/proc/components_handle_damage(var/damage, var/type = BRUTE)
	var/obj/item/mecha_parts/component/armor/AC = internal_components[MECH_ARMOR]

	if(AC)
		var/armor_efficiency = AC.get_efficiency()
		var/damage_change = armor_efficiency * (damage * 0.5) * AC.damage_absorption[type]
		AC.damage_part(damage_change, type)
		damage -= damage_change

	var/obj/item/mecha_parts/component/hull/HC = internal_components[MECH_HULL]

	if(HC)
		if(HC.integrity)
			var/hull_absorb = round(rand(5, 10) / 10, 0.1) * damage
			HC.damage_part(hull_absorb, type)
			damage -= hull_absorb

	for(var/obj/item/mecha_parts/component/C in (internal_components - list(MECH_HULL, MECH_ARMOR)))
		if(prob(C.relative_size))
			var/damage_part_amt = round(damage / 4, 0.1)
			C.damage_part(damage_part_amt)
			damage -= damage_part_amt

	return damage

/obj/mecha/proc/get_damage_absorption()
	var/obj/item/mecha_parts/component/armor/AC = internal_components[MECH_ARMOR]
	if(istype(AC) && AC.get_efficiency() > 0.25)
		return AC.damage_absorption

/obj/mecha/proc/absorbDamage(damage,damage_type)
	return call((proc_res["dynabsorbdamage"]||src), "dynabsorbdamage")(damage,damage_type)

/obj/mecha/proc/dynabsorbdamage(damage,damage_type)
	return damage*(listgetindex(get_damage_absorption(),damage_type) || 1)

/obj/mecha/airlock_crush(var/crush_damage)
	..()
	take_damage(crush_damage)
	if(prob(50))	//Try to avoid that.
		check_for_internal_damage(list(MECHA_INT_TEMP_CONTROL,MECHA_INT_TANK_BREACH,MECHA_INT_CONTROL_LOST))
	return 1

/obj/mecha/proc/update_health()
	if(src.health > 0)
		src.spark_system.start()
	else
		qdel(src)
	return

/obj/mecha/attack_hand(mob/user as mob)
	if(user == occupant)
		show_radial_occupant(user)
		return

	user.setClickCooldown(user.get_attack_speed())
	src.log_message("Attack by hand/paw. Attacker - [user].",1)

	var/obj/item/mecha_parts/component/armor/ArmC = internal_components[MECH_ARMOR]

	var/temp_deflect_chance = deflect_chance

	if(!ArmC)
		temp_deflect_chance = 1

	else
		temp_deflect_chance = round(ArmC.get_efficiency() * ArmC.deflect_chance + (defence_mode ? 25 : 0))

	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(H.species.can_shred(user))
			if(!prob(temp_deflect_chance))
				src.take_damage(15)	//The take_damage() proc handles armor values
				if(prob(25))	//Why would they get free internal damage. At least make it a bit RNG.
					src.check_for_internal_damage(list(MECHA_INT_TEMP_CONTROL,MECHA_INT_TANK_BREACH,MECHA_INT_CONTROL_LOST))
				playsound(src, 'sound/weapons/slash.ogg', 50, 1, -1)
				to_chat(user, span_danger("You slash at the armored suit!"))
				visible_message(span_danger("\The [user] slashes at [src.name]'s armor!"))
			else
				src.log_append_to_last("Armor saved.")
				playsound(src, 'sound/weapons/slash.ogg', 50, 1, -1)
				to_chat(user, span_danger("Your claws had no effect!"))
				src.occupant_message(span_notice("\The [user]'s claws are stopped by the armor."))
				visible_message(span_warning("\The [user] rebounds off [src.name]'s armor!"))
		else
			user.visible_message(span_danger("\The [user] hits \the [src]. Nothing happens."),span_danger("You hit \the [src] with no visible effect."))
			src.log_append_to_last("Armor saved.")
		return
	else if ((HULK in user.mutations) && !prob(temp_deflect_chance))
		src.take_damage(15)	//The take_damage() proc handles armor values
		if(prob(25))	//Hulks punch hard but lets not give them consistent internal damage.
			src.check_for_internal_damage(list(MECHA_INT_TEMP_CONTROL,MECHA_INT_TANK_BREACH,MECHA_INT_CONTROL_LOST))
		user.visible_message(span_warning(span_red(span_bold("[user] hits [src.name], doing some damage."))), span_warning(span_red(span_bold("You hit [src.name] with all your might. The metal creaks and bends."))))
	else
		user.visible_message(span_infoplain((span_red(span_bold("[user] hits [src.name]. Nothing happens.")))),span_infoplain(span_red(span_bold("You hit [src.name] with no visible effect."))))
		src.log_append_to_last("Armor saved.")
	return

/obj/mecha/hitby(atom/movable/A as mob|obj) //wrapper
	..()
	src.log_message("Hit by [A].",1)
	call((proc_res["dynhitby"]||src), "dynhitby")(A)
	return

//I think this is relative to throws.
/obj/mecha/proc/dynhitby(atom/movable/A)
	var/obj/item/mecha_parts/component/armor/ArmC = internal_components[MECH_ARMOR]

	var/temp_deflect_chance = deflect_chance
	var/temp_damage_minimum = damage_minimum
	var/temp_minimum_penetration = minimum_penetration
	var/temp_fail_penetration_value = fail_penetration_value

	if(!ArmC)
		temp_deflect_chance = 0
		temp_damage_minimum = 0
		temp_minimum_penetration = 0
		temp_fail_penetration_value = 1

	else
		temp_deflect_chance = round(ArmC.get_efficiency() * ArmC.deflect_chance + (defence_mode ? 25 : 0))
		temp_damage_minimum = round(ArmC.get_efficiency() * ArmC.damage_minimum)
		temp_minimum_penetration = round(ArmC.get_efficiency() * ArmC.minimum_penetration)
		temp_fail_penetration_value = round(ArmC.get_efficiency() * ArmC.fail_penetration_value)

	if(istype(A, /obj/item/mecha_parts/mecha_tracking))
		A.forceMove(src)
		src.visible_message("The [A] fastens firmly to [src].")
		return
	if(prob(temp_deflect_chance) || istype(A, /mob))
		src.occupant_message(span_notice("\The [A] bounces off the armor."))
		src.visible_message("\The [A] bounces off \the [src] armor")
		src.log_append_to_last("Armor saved.")
		if(isliving(A))
			var/mob/living/M = A
			M.take_organ_damage(10)
	else if(istype(A, /obj))
		var/obj/O = A
		if(O.throwforce)

			var/pass_damage = O.throwforce
			var/pass_damage_reduc_mod
			if(pass_damage <= temp_damage_minimum)//Too little to go through.
				src.occupant_message(span_notice("\The [A] bounces off the armor."))
				src.visible_message("\The [A] bounces off \the [src] armor")
				return

			else if(O.armor_penetration < temp_minimum_penetration)	//If you don't have enough pen, you won't do full damage
				src.occupant_message(span_notice("\The [A] struggles to bypass \the [src] armor."))
				src.visible_message("\The [A] struggles to bypass \the [src] armor")
				pass_damage_reduc_mod = temp_fail_penetration_value	//This will apply to reduce damage to 2/3 or 66% by default
			else
				src.occupant_message(span_notice("\The [A] manages to pierce \the [src] armor."))
//				src.visible_message("\The [A] manages to pierce \the [src] armor")
				pass_damage_reduc_mod = 1



			for(var/obj/item/mecha_parts/mecha_equipment/ME in equipment)
				pass_damage = ME.handle_ranged_contact(A, pass_damage)

			pass_damage = (pass_damage*pass_damage_reduc_mod)//Applying damage reduction
			src.take_damage(pass_damage)	//The take_damage() proc handles armor values
			if(pass_damage > internal_damage_minimum)	//Only decently painful attacks trigger a chance of mech damage.
				src.check_for_internal_damage(list(MECHA_INT_TEMP_CONTROL,MECHA_INT_TANK_BREACH,MECHA_INT_CONTROL_LOST))
	return


/obj/mecha/bullet_act(var/obj/item/projectile/Proj) //wrapper
	if(istype(Proj, /obj/item/projectile/test))
		var/obj/item/projectile/test/Test = Proj
		Test.hit |= occupant // Register a hit on the occupant, for things like turrets, or in simple-mob cases stopping friendly fire in firing line mode.
		return

	src.log_message("Hit by projectile. Type: [Proj.name]([Proj.check_armour]).",1)
	call((proc_res["dynbulletdamage"]||src), "dynbulletdamage")(Proj) //calls equipment
	..()
	return

/obj/mecha/proc/dynbulletdamage(var/obj/item/projectile/Proj)
	var/obj/item/mecha_parts/component/armor/ArmC = internal_components[MECH_ARMOR]

	var/temp_deflect_chance = deflect_chance
	var/temp_damage_minimum = damage_minimum
	var/temp_minimum_penetration = minimum_penetration
	var/temp_fail_penetration_value = fail_penetration_value

	if(!ArmC)
		temp_deflect_chance = 0
		temp_damage_minimum = 0
		temp_minimum_penetration = 0
		temp_fail_penetration_value = 1

	else
		temp_deflect_chance = round(ArmC.get_efficiency() * ArmC.deflect_chance + (defence_mode ? 25 : 0))
		temp_damage_minimum = round(ArmC.get_efficiency() * ArmC.damage_minimum)
		temp_minimum_penetration = round(ArmC.get_efficiency() * ArmC.minimum_penetration)
		temp_fail_penetration_value = round(ArmC.get_efficiency() * ArmC.fail_penetration_value)

	if(prob(temp_deflect_chance))
		src.occupant_message(span_notice("The armor deflects incoming projectile."))
		src.visible_message("The [src.name] armor deflects the projectile")
		src.log_append_to_last("Armor saved.")
		return

	if(Proj.damage_type == HALLOSS)
		use_power(Proj.agony * 5)

	if(!(Proj.nodamage))
		var/ignore_threshold
		if(istype(Proj, /obj/item/projectile/beam/pulse))	//ATM, this is literally only for the pulse rifles used mostly by deathsquads.
			ignore_threshold = 1

		var/pass_damage = Proj.damage
		var/pass_damage_reduc_mod
		for(var/obj/item/mecha_parts/mecha_equipment/ME in equipment)
			pass_damage = ME.handle_projectile_contact(Proj, pass_damage)

		if(pass_damage < temp_damage_minimum)//too pathetic to really damage you.
			src.occupant_message(span_notice("The armor deflects incoming projectile."))
			src.visible_message("The [src.name] armor deflects\the [Proj]")
			return

		else if(Proj.armor_penetration < temp_minimum_penetration)	//If you don't have enough pen, you won't do full damage
			src.occupant_message(span_notice("\The [Proj] struggles to pierce \the [src] armor."))
			src.visible_message("\The [Proj] struggles to pierce \the [src] armor")
			pass_damage_reduc_mod = temp_fail_penetration_value	//This will apply to reduce damage to 2/3 or 66% by default

		else	//You go through completely because you use AP. Nice.
			src.occupant_message(span_notice("\The [Proj] manages to pierce \the [src] armor."))
//			src.visible_message("\The [Proj] manages to pierce \the [src] armor")
			pass_damage_reduc_mod = 1

		pass_damage = (pass_damage_reduc_mod*pass_damage)//Apply damage reduction before usage.
		src.take_damage(pass_damage, Proj.check_armour)	//The take_damage() proc handles armor values
		if(prob(25))
			spark_system.start()
		if(pass_damage > internal_damage_minimum)	//Only decently painful attacks trigger a chance of mech damage.
			src.check_for_internal_damage(list(MECHA_INT_FIRE,MECHA_INT_TEMP_CONTROL,MECHA_INT_TANK_BREACH,MECHA_INT_CONTROL_LOST,MECHA_INT_SHORT_CIRCUIT),ignore_threshold)

		//AP projectiles have a chance to cause additional damage
		if(Proj.penetrating)
			var/distance = get_dist(Proj.starting, get_turf(loc))
			var/hit_occupant = 1 //only allow the occupant to be hit once
			for(var/i in 1 to min(Proj.penetrating, round(Proj.damage/15)))
				if(src.occupant && hit_occupant && prob(20))
					Proj.attack_mob(src.occupant, distance)
					hit_occupant = 0
				else
					if(pass_damage > internal_damage_minimum)	//Only decently painful attacks trigger a chance of mech damage.
						src.check_for_internal_damage(list(MECHA_INT_FIRE,MECHA_INT_TEMP_CONTROL,MECHA_INT_TANK_BREACH,MECHA_INT_CONTROL_LOST,MECHA_INT_SHORT_CIRCUIT), 1)

				Proj.penetrating--

				if(prob(15))
					break //give a chance to exit early

	Proj.on_hit(src) //on_hit just returns if it's argument is not a living mob so does this actually do anything?
	return

//This refer to whenever you are caught in an explosion.
/obj/mecha/ex_act(severity)
	var/obj/item/mecha_parts/component/armor/ArmC = internal_components[MECH_ARMOR]

	var/temp_deflect_chance = deflect_chance

	if(!ArmC)
		temp_deflect_chance = 0

	else
		temp_deflect_chance = round(ArmC.get_efficiency() * ArmC.deflect_chance + (defence_mode ? 25 : 0))

	src.log_message("Affected by explosion of severity: [severity].",1)
	if(prob(temp_deflect_chance))
		severity++
		src.log_append_to_last("Armor saved, changing severity to [severity].")
	switch(severity)
		if(1.0)
			src.take_damage(initial(src.health), "bomb")
		if(2.0)
			if (prob(30))
				src.take_damage(initial(src.health), "bomb")
			else
				src.take_damage(initial(src.health)/2, "bomb")
				src.check_for_internal_damage(list(MECHA_INT_FIRE,MECHA_INT_TEMP_CONTROL,MECHA_INT_TANK_BREACH,MECHA_INT_CONTROL_LOST,MECHA_INT_SHORT_CIRCUIT),1)
		if(3.0)
			if (prob(5))
				qdel(src)
			else
				src.take_damage(initial(src.health)/5, "bomb")
				src.check_for_internal_damage(list(MECHA_INT_FIRE,MECHA_INT_TEMP_CONTROL,MECHA_INT_TANK_BREACH,MECHA_INT_CONTROL_LOST,MECHA_INT_SHORT_CIRCUIT),1)
	return

/*Will fix later -Sieve
/obj/mecha/attack_blob(mob/user as mob)
	src.log_message("Attack by blob. Attacker - [user].",1)
	if(!prob(src.deflect_chance))
		src.take_damage(6)
		src.check_for_internal_damage(list(MECHA_INT_TEMP_CONTROL,MECHA_INT_TANK_BREACH,MECHA_INT_CONTROL_LOST))
		playsound(src, 'sound/effects/blobattack.ogg', 50, 1, -1)
		to_chat(user, span_danger("You smash at the armored suit!"))
		for (var/mob/V in viewers(src))
			if(V.client && !(V.blinded))
				V.show_message(span_danger("\The [user] smashes against [src.name]'s armor!"), 1)
	else
		src.log_append_to_last("Armor saved.")
		playsound(src, 'sound/effects/blobattack.ogg', 50, 1, -1)
		to_chat(user, span_warning("Your attack had no effect!"))
		src.occupant_message(span_warning("\The [user]'s attack is stopped by the armor."))
		for (var/mob/V in viewers(src))
			if(V.client && !(V.blinded))
				V.show_message(span_warning("\The [user] rebounds off the [src.name] armor!"), 1)
	return
*/

/obj/mecha/emp_act(severity)
	if(get_charge())
		use_power((cell.charge/2)/severity)
		take_damage(50 / severity,"energy")
	src.log_message("EMP detected",1)
	if(prob(80))
		check_for_internal_damage(list(MECHA_INT_FIRE,MECHA_INT_TEMP_CONTROL,MECHA_INT_CONTROL_LOST,MECHA_INT_SHORT_CIRCUIT),1)
	return

/obj/mecha/fire_act(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	if(exposed_temperature>src.max_temperature)
		src.log_message("Exposed to dangerous temperature.",1)
		src.take_damage(5,"fire")	//The take_damage() proc handles armor values
		src.check_for_internal_damage(list(MECHA_INT_FIRE, MECHA_INT_TEMP_CONTROL))
	return

/obj/mecha/proc/dynattackby(obj/item/W as obj, mob/user as mob)
	user.setClickCooldown(user.get_attack_speed(W))
	src.log_message("Attacked by [W]. Attacker - [user]")
	var/pass_damage_reduc_mod			//Modifer for failing to bring AP.

	var/obj/item/mecha_parts/component/armor/ArmC = internal_components[MECH_ARMOR]

	var/temp_deflect_chance = deflect_chance
	var/temp_damage_minimum = damage_minimum
	var/temp_minimum_penetration = minimum_penetration
	var/temp_fail_penetration_value = fail_penetration_value

	if(!ArmC)
		temp_deflect_chance = 0
		temp_damage_minimum = 0
		temp_minimum_penetration = 0
		temp_fail_penetration_value = 1

	else
		temp_deflect_chance = round(ArmC.get_efficiency() * ArmC.deflect_chance + (defence_mode ? 25 : 0))
		temp_damage_minimum = round(ArmC.get_efficiency() * ArmC.damage_minimum)
		temp_minimum_penetration = round(ArmC.get_efficiency() * ArmC.minimum_penetration)
		temp_fail_penetration_value = round(ArmC.get_efficiency() * ArmC.fail_penetration_value)

	if(prob(temp_deflect_chance))		//Does your attack get deflected outright.
		src.occupant_message(span_notice("\The [W] bounces off [src.name]."))
		to_chat(user, span_danger("\The [W] bounces off [src.name]."))
		src.log_append_to_last("Armor saved.")

	else if(W.force < temp_damage_minimum)	//Is your attack too PATHETIC to do anything. 3 damage to a person shouldn't do anything to a mech.
		src.occupant_message(span_notice("\The [W] bounces off the armor."))
		src.visible_message(span_infoplain("\The [W] bounces off \the [src] armor"))
		return

	else if(W.armor_penetration < temp_minimum_penetration)	//If you don't have enough pen, you won't do full damage
		src.occupant_message(span_notice("\The [W] struggles to bypass \the [src] armor."))
		src.visible_message(span_infoplain("\The [W] struggles to bypass \the [src] armor"))
		pass_damage_reduc_mod = temp_fail_penetration_value	//This will apply to reduce damage to 2/3 or 66% by default

	else
		pass_damage_reduc_mod = 1		//Just making sure.
		src.occupant_message(span_warning(span_red(span_bold("[user] hits [src] with [W]."))))
		user.visible_message(span_warning(span_red(span_bold("[user] hits [src] with [W]."))), span_danger(span_red(span_bold("You hit [src] with [W]."))))

		var/pass_damage = W.force
		pass_damage = (pass_damage*pass_damage_reduc_mod)	//Apply the reduction of damage from not having enough armor penetration. This is not regular armor values at play.
		for(var/obj/item/mecha_parts/mecha_equipment/ME in equipment)
			pass_damage = ME.handle_projectile_contact(W, user, pass_damage)
		src.take_damage(pass_damage,W.damtype)	//The take_damage() proc handles armor values
		if(pass_damage > internal_damage_minimum)	//Only decently painful attacks trigger a chance of mech damage.
			src.check_for_internal_damage(list(MECHA_INT_TEMP_CONTROL,MECHA_INT_TANK_BREACH,MECHA_INT_CONTROL_LOST))
	return

//////////////////////
////// AttackBy //////
//////////////////////

/obj/mecha/attackby(obj/item/W as obj, mob/user as mob)

	if(istype(W, /obj/item/mmi))
		if(mmi_move_inside(W,user))
			to_chat(user, "[src]-MMI interface initialized successfuly")
		else
			to_chat(user, "[src]-MMI interface initialization failed.")
		return

	if(istype(W, /obj/item/robotanalyzer))
		var/obj/item/robotanalyzer/RA = W
		RA.do_scan(src, user)
		return

	if(istype(W, /obj/item/mecha_parts/mecha_equipment))
		var/obj/item/mecha_parts/mecha_equipment/E = W
		spawn()
			if(E.can_attach(src))
				user.drop_item()
				E.attach(src)
				user.visible_message("[user] attaches [W] to [src]", "You attach [W] to [src]")
			else
				to_chat(user, "You were unable to attach [W] to [src]")
		return

	if(istype(W, /obj/item/mecha_parts/component) && state == MECHA_CELL_OUT)
		var/obj/item/mecha_parts/component/MC = W
		spawn()
			if(MC.attach(src))
				user.drop_item()
				MC.forceMove(src)
				user.visible_message("[user] installs \the [W] in \the [src]", "You install \the [W] in \the [src].")
		return

	if(istype(W, /obj/item/card/robot))
		var/obj/item/card/robot/RoC = W
		return attackby(RoC.dummy_card, user)

	if(istype(W, /obj/item/card/id)||istype(W, /obj/item/pda))
		if(add_req_access || maint_access)
			if(internals_access_allowed(user))
				var/obj/item/card/id/id_card
				if(istype(W, /obj/item/card/id))
					id_card = W
				else
					var/obj/item/pda/pda = W
					id_card = pda.id
				output_maintenance_dialog(id_card, user)
				return
			else
				to_chat(user, span_warning("Invalid ID: Access denied."))
		else
			to_chat(user, span_warning("Maintenance protocols disabled by operator."))
	else if(W.has_tool_quality(TOOL_WRENCH))
		if(state==MECHA_BOLTS_SECURED)
			state = MECHA_PANEL_LOOSE
			to_chat(user, "You undo the securing bolts.")
		else if(state==MECHA_PANEL_LOOSE)
			state = MECHA_BOLTS_SECURED
			to_chat(user, "You tighten the securing bolts.")
		return
	else if(W.has_tool_quality(TOOL_CROWBAR))
		if(state==MECHA_PANEL_LOOSE)
			state = MECHA_CELL_OPEN
			to_chat(user, "You open the hatch to the power unit")
		else if(state==MECHA_CELL_OPEN)
			state=MECHA_PANEL_LOOSE
			to_chat(user, "You close the hatch to the power unit")
		else if(state==MECHA_CELL_OUT)
			var/list/removable_components = list()
			for(var/slot in internal_components)
				var/obj/item/mecha_parts/component/MC = internal_components[slot]
				if(istype(MC))
					removable_components[MC.name] = MC
				else
					to_chat(user, span_notice("\The [src] appears to be missing \the [slot]."))

			var/remove = tgui_input_list(user, "Which component do you want to pry out?", "Remove Component", removable_components)
			if(!remove)
				return

			var/obj/item/mecha_parts/component/RmC = removable_components[remove]
			RmC.detach()

		return
	else if(istype(W, /obj/item/stack/cable_coil))
		if(state >= MECHA_CELL_OPEN && hasInternalDamage(MECHA_INT_SHORT_CIRCUIT))
			var/obj/item/stack/cable_coil/CC = W
			if(CC.use(2))
				clearInternalDamage(MECHA_INT_SHORT_CIRCUIT)
				to_chat(user, "You replace the fused wires.")
			else
				to_chat(user, "There's not enough wire to finish the task.")
		return
	else if(W.has_tool_quality(TOOL_SCREWDRIVER))
		if(hasInternalDamage(MECHA_INT_TEMP_CONTROL))
			clearInternalDamage(MECHA_INT_TEMP_CONTROL)
			to_chat(user, "You repair the damaged temperature controller.")
		else if(state==MECHA_CELL_OPEN && src.cell)
			src.cell.forceMove(src.loc)
			src.cell = null
			state = MECHA_CELL_OUT
			to_chat(user, "You unscrew and pry out the powercell.")
			src.log_message("Powercell removed")
		else if(state==MECHA_CELL_OUT && src.cell)
			state=MECHA_CELL_OPEN
			to_chat(user, "You screw the cell in place")
		return

	else if(istype(W, /obj/item/multitool))
		if(state>=MECHA_CELL_OPEN && src.occupant)
			to_chat(user, "You attempt to eject the pilot using the maintenance controls.")
			if(src.occupant.stat)
				src.go_out()
				src.log_message("[src.occupant] was ejected using the maintenance controls.")
			else
				to_chat(user, span_warning("Your attempt is rejected."))
				src.occupant_message(span_warning("An attempt to eject you was made using the maintenance controls."))
				src.log_message("Eject attempt made using maintenance controls - rejected.")
		return

	else if(istype(W, /obj/item/cell))
		if(state==MECHA_CELL_OUT)
			if(!src.cell)
				to_chat(user, "You install the powercell")
				user.drop_item()
				W.forceMove(src)
				src.cell = W
				src.log_message("Powercell installed")
			else
				to_chat(user, "There's already a powercell installed.")
		return

	else if(W.has_tool_quality(TOOL_WELDER) && user.a_intent != I_HURT)
		var/obj/item/weldingtool/WT = W.get_welder()
		var/obj/item/mecha_parts/component/hull/HC = internal_components[MECH_HULL]
		var/obj/item/mecha_parts/component/armor/AC = internal_components[MECH_ARMOR]
		if (WT.remove_fuel(0,user))
			if (hasInternalDamage(MECHA_INT_TANK_BREACH))
				clearInternalDamage(MECHA_INT_TANK_BREACH)
				to_chat(user, span_notice("You repair the damaged gas tank."))
		else
			return
		if((src.health<initial(src.health)) || (HC.integrity<HC.max_integrity) || (AC.integrity<AC.max_integrity))
			if(src.health<initial(src.health))
				to_chat(user, span_notice("You repair some damage to [src.name]."))
				src.health += min(10, initial(src.health)-src.health)
				update_damage_alerts()
			else	if(HC.integrity<HC.max_integrity)
				to_chat(user, span_notice("You repair some damage to [HC.name]."))
				HC.integrity += min(10, HC.max_integrity-HC.integrity)
				update_damage_alerts()
			else	if(AC.integrity<AC.max_integrity)
				to_chat(user, span_notice("You repair some damage to [AC.name]."))
				AC.integrity += min(10, AC.max_integrity-AC.integrity)
				update_damage_alerts()

		else
			to_chat(user, "The [src.name] is at full integrity")
		return

	else if(istype(W, /obj/item/mecha_parts/mecha_tracking))
		user.drop_from_inventory(W)
		W.forceMove(src)
		user.visible_message("[user] attaches [W] to [src].", "You attach [W] to [src]")
		return

	else if(istype(W,/obj/item/stack/nanopaste))
		if(state >= MECHA_PANEL_LOOSE)
			var/obj/item/stack/nanopaste/NP = W

			for(var/slot in internal_components)
				var/obj/item/mecha_parts/component/C = internal_components[slot]

				if(!C)
					to_chat(user, span_notice("There are no components installed!"))
					return

				if(C.integrity >= C.max_integrity)
					to_chat(user, span_notice("\The [C] does not require repairs."))

				else if(C.integrity < C.max_integrity)
					to_chat(user, span_notice("You start to repair damage to \the [C]."))
					while(C.integrity < C.max_integrity && NP)
						if(do_after(user, 1 SECOND, src))
							NP.use(1)
							C.adjust_integrity(NP.mech_repair)

							if(C.integrity >= C.max_integrity)
								to_chat(user, span_notice("You finish repairing \the [C]."))
								break

							else if(NP.amount == 0)
								to_chat(user, span_warning("Insufficient nanopaste to complete repairs!"))
								break
			return

		else
			to_chat(user, span_notice("You can't reach \the [src]'s internal components."))
			return

	else
		call((proc_res["dynattackby"]||src), "dynattackby")(W,user)
/*
		src.log_message("Attacked by [W]. Attacker - [user]")
		if(prob(src.deflect_chance))
			to_chat(user, span_warning("\The [W] bounces off [src.name] armor."))
			src.log_append_to_last("Armor saved.")
/*
			for (var/mob/V in viewers(src))
				if(V.client && !(V.blinded))
					V.show_message("The [W] bounces off [src.name] armor.", 1)
*/
		else
			src.occupant_message("<font color='red'><b>[user] hits [src] with [W].</b></font>")
			user.visible_message("<font color='red'><b>[user] hits [src] with [W].</b></font>", "<font color='red'><b>You hit [src] with [W].</b></font>")
			src.take_damage(W.force,W.damtype)
			src.check_for_internal_damage(list(MECHA_INT_TEMP_CONTROL,MECHA_INT_TANK_BREACH,MECHA_INT_CONTROL_LOST))
*/
	return



/*
/obj/mecha/attack_ai(var/mob/living/silicon/ai/user as mob)
	if(!isAI(user))
		return
	var/output = {"<b>Assume direct control over [src]?</b>
						<a href='byond://?src=\ref[src];ai_take_control=\ref[user];duration=3000'>Yes</a><br>
						"}
	user << browse("<html>[output]</html>", "window=mecha_attack_ai")
	return
*/

///////////////////////////////
////////  Brain Stuff  ////////
///////////////////////////////

/obj/mecha/proc/mmi_move_inside(var/obj/item/mmi/mmi_as_oc as obj,mob/user as mob)
	if(!mmi_as_oc.brainmob || !mmi_as_oc.brainmob.client)
		to_chat(user, "Consciousness matrix not detected.")
		return 0
	else if(mmi_as_oc.brainmob.stat)
		to_chat(user, "Brain activity below acceptable level.")
		return 0
	else if(occupant)
		to_chat(user, "Occupant detected.")
		return 0
	else if(dna && dna!=mmi_as_oc.brainmob.dna.unique_enzymes)
		to_chat(user, "Genetic sequence or serial number incompatible with locking mechanism.")
		return 0
	//Added a message here since people assume their first click failed or something./N
//	to_chat(user, "Installing MMI, please stand by.")

	visible_message(span_notice("[usr] starts to insert a brain into [src.name]"))

	if(enter_after(40,user))
		if(!occupant)
			return mmi_moved_inside(mmi_as_oc,user)
		else
			to_chat(user, "Occupant detected.")
	else
		to_chat(user, "You stop attempting to install the brain.")
	return 0

/obj/mecha/proc/mmi_moved_inside(var/obj/item/mmi/mmi_as_oc as obj,mob/user as mob)
	if(mmi_as_oc && (user in range(1)))
		if(!mmi_as_oc.brainmob || !mmi_as_oc.brainmob.client)
			to_chat(user, "Consciousness matrix not detected.")
			return 0
		else if(mmi_as_oc.brainmob.stat)
			to_chat(user, "Beta-rhythm below acceptable level.")
			return 0
		user.drop_from_inventory(mmi_as_oc)
		var/mob/brainmob = mmi_as_oc.brainmob
		brainmob.reset_view(src)
	/*
		brainmob.client.eye = src
		brainmob.client.perspective = EYE_PERSPECTIVE
	*/
		occupant = brainmob
		brainmob.loc = src //should allow relaymove
		brainmob.canmove = 1
		mmi_as_oc.loc = src
		mmi_as_oc.mecha = src
		src.verbs += /obj/mecha/verb/eject
		src.Entered(mmi_as_oc)
		src.Move(src.loc)
		update_icon()
		set_dir(dir_in)
		src.log_message("[mmi_as_oc] moved in as pilot.")
		if(!hasInternalDamage())
			src.occupant << sound('sound/mecha/nominal.ogg',volume=50)
		update_icon()
		return 1
	else
		return 0


/////////////////////////////////////
////////  Atmospheric stuff  ////////
/////////////////////////////////////

/obj/mecha/proc/get_turf_air()
	var/turf/T = get_turf(src)
	if(T)
		. = T.return_air()
	return

/obj/mecha/remove_air(amount)
	if(use_internal_tank)
		return cabin_air.remove(amount)
	else
		var/turf/T = get_turf(src)
		if(T)
			return T.remove_air(amount)
	return

/obj/mecha/return_air()
	var/obj/item/mecha_parts/component/gas/GC = internal_components[MECH_GAS]
	if(use_internal_tank && (GC && prob(GC.get_efficiency() * 100)))
		return cabin_air
	return get_turf_air()

/obj/mecha/proc/return_pressure()
	. = 0
	var/obj/item/mecha_parts/component/gas/GC = internal_components[MECH_GAS]
	if(use_internal_tank && (GC && prob(GC.get_efficiency() * 100)))
		. =  cabin_air.return_pressure()
	else
		var/datum/gas_mixture/t_air = get_turf_air()
		if(t_air)
			. = t_air.return_pressure()
	return

//skytodo: //No idea what you want me to do here, mate.
/obj/mecha/proc/return_temperature()
	. = 0
	var/obj/item/mecha_parts/component/gas/GC = internal_components[MECH_GAS]
	if(use_internal_tank && (GC && prob(GC.get_efficiency() * 100)))
		. = cabin_air.temperature
	else
		var/datum/gas_mixture/t_air = get_turf_air()
		if(t_air)
			. = t_air.temperature
	return

/obj/mecha/proc/connect(obj/machinery/atmospherics/portables_connector/new_port)
	//Make sure not already connected to something else
	if(connected_port || !new_port || new_port.connected_device)
		return 0

	//Make sure are close enough for a valid connection
	if(!(new_port.loc in locs))
		return 0

	//Perform the connection
	connected_port = new_port
	connected_port.connected_device = src

	//Actually enforce the air sharing
	var/datum/pipe_network/network = connected_port.return_network(src)
	if(network && !(internal_tank.return_air() in network.gases))
		network.gases += internal_tank.return_air()
		network.update = 1
	playsound(src, 'sound/mecha/gasconnected.ogg', 50, 1)
	log_message("Connected to gas port.")
	return 1

/obj/mecha/proc/disconnect()
	if(!connected_port)
		return 0

	var/datum/pipe_network/network = connected_port.return_network(src)
	if(network)
		network.gases -= internal_tank.return_air()

	connected_port.connected_device = null
	connected_port = null
	playsound(src, 'sound/mecha/gasdisconnected.ogg', 50, 1)
	src.log_message("Disconnected from gas port.")
	return 1


/////////////////////////
////////  Verbs  ////////
/////////////////////////


/obj/mecha/verb/connect_to_port()
	set name = "Connect to port"
	set category = "Exosuit Interface"
	set src = usr.loc
	set popup_menu = 0

	if(!occupant)
		return

	if(usr != occupant)
		return

	var/obj/item/mecha_parts/component/gas/GC = internal_components[MECH_GAS]
	if(!GC)
		return

	for(var/turf/T in locs)
		var/obj/machinery/atmospherics/portables_connector/possible_port = locate(/obj/machinery/atmospherics/portables_connector) in T
		if(possible_port)
			if(connect(possible_port))
				occupant_message(span_notice("\The [name] connects to the port."))
				verbs += /obj/mecha/verb/disconnect_from_port
				verbs -= /obj/mecha/verb/connect_to_port
				return
			else
				occupant_message(span_danger("\The [name] failed to connect to the port."))
				return
		else
			occupant_message("Nothing happens")


/obj/mecha/verb/disconnect_from_port()
	set name = "Disconnect from port"
	set category = "Exosuit Interface"
	set src = usr.loc
	set popup_menu = 0

	if(!occupant)
		return

	if(usr != occupant)
		return

	if(disconnect())
		occupant_message(span_notice("[name] disconnects from the port."))
		verbs -= /obj/mecha/verb/disconnect_from_port
		verbs += /obj/mecha/verb/connect_to_port
	else
		occupant_message(span_danger("[name] is not connected to the port at the moment."))

/obj/mecha/verb/toggle_lights()
	set name = "Toggle Lights"
	set category = "Exosuit Interface"
	set src = usr.loc
	set popup_menu = 0
	lights()

/obj/mecha/verb/lights()
	if(usr!=occupant)	return
	lights = !lights
	if(lights)	set_light(light_range + lights_power)
	else		set_light(light_range - lights_power)
	src.occupant_message("Toggled lights [lights?"on":"off"].")
	log_message("Toggled lights [lights?"on":"off"].")
	playsound(src, 'sound/mecha/heavylightswitch.ogg', 50, 1)
	return


/obj/mecha/verb/toggle_internal_tank()
	set name = "Toggle internal airtank usage"
	set category = "Exosuit Interface"
	set src = usr.loc
	set popup_menu = 0
	internal_tank()

/obj/mecha/proc/internal_tank()
	if(usr!=src.occupant)
		return

	var/obj/item/mecha_parts/component/gas/GC = internal_components[MECH_GAS]
	if(!GC)
		to_chat(occupant, span_warning("The life support systems don't seem to respond."))
		return

	if(!prob(GC.get_efficiency() * 100))
		to_chat(occupant, span_warning("\The [GC] shudders and barks, before returning to how it was before."))
		return

	use_internal_tank = !use_internal_tank
	src.occupant_message("Now taking air from [use_internal_tank?"internal airtank":"environment"].")
	src.log_message("Now taking air from [use_internal_tank?"internal airtank":"environment"].")
	playsound(src, 'sound/mecha/gasdisconnected.ogg', 30, 1)
	return


/obj/mecha/verb/toggle_strafing()
	set name = "Toggle strafing"
	set category = "Exosuit Interface"
	set src = usr.loc
	set popup_menu = 0
	strafing()

/obj/mecha/proc/strafing()
	if(usr!=src.occupant)
		return
	strafing = !strafing
	src.occupant_message("Toggled strafing mode [strafing?"on":"off"].")
	src.log_message("Toggled strafing mode [strafing?"on":"off"].")
	return

/obj/mecha/MouseDrop_T(mob/O, mob/user as mob)
	//Humans can pilot mechs.
	if(!ishuman(O))
		return

	//Can't put other people into mechs (can comment this out if you want that to be possible)
	if(O != user)
		return

	move_inside()

/obj/mecha/verb/enter()
	set category = "Object"
	set name = "Enter Exosuit"
	set src in oview(1)
	move_inside()

//returns an equipment object if we have one of that type, useful since is_type_in_list won't return the object
//since is_type_in_list uses caching, this is a slower operation, so only use it if needed
/obj/mecha/proc/get_equipment(var/equip_type)
	for(var/obj/item/mecha_parts/mecha_equipment/ME in equipment)
		if(istype(ME,equip_type))
			return ME
	return null

/obj/mecha/proc/move_inside()
	if (usr.stat || !ishuman(usr))
		return

	if (usr.buckled)
		to_chat(usr, span_warning("You can't climb into the exosuit while buckled!"))
		return

	src.log_message("[usr] tries to move in.")
	if(iscarbon(usr))
		var/mob/living/carbon/C = usr
		if(C.handcuffed)
			to_chat(usr, span_danger("Kinda hard to climb in while handcuffed don't you think?"))
			return
	if (src.occupant)
		to_chat(usr, span_danger("The [src.name] is already occupied!"))
		src.log_append_to_last("Permission denied.")
		return
/*
	if (usr.abiotic())
		to_chat(usr, span_notice("Subject cannot have abiotic items on."))
		return
*/
	var/passed
	if(src.dna)
		if(usr.dna.unique_enzymes==src.dna)
			passed = 1
	else if(src.operation_allowed(usr))
		passed = 1
	if(!passed)
		to_chat(usr, span_warning("Access denied"))
		src.log_append_to_last("Permission denied.")
		return
	if(isliving(usr))
		var/mob/living/L = usr
		if(L.has_buckled_mobs())
			to_chat(L, span_warning("You have other entities attached to yourself. Remove them first."))
			return

//	to_chat(usr, "You start climbing into [src.name]")
	if(get_equipment(/obj/item/mecha_parts/mecha_equipment/runningboard))
		visible_message(span_notice("\The [usr] is instantly lifted into [src.name] by the running board!"))
		moved_inside(usr)
		if(ishuman(occupant))
			GrantActions(occupant, 1)
	else
		visible_message(span_infoplain(span_bold("\The [usr]") + " starts to climb into [src.name]"))
		if(enter_after(40,usr))
			if(!src.occupant)
				moved_inside(usr)
				if(ishuman(occupant)) //Aeiou
					GrantActions(occupant, 1)
			else if(src.occupant!=usr)
				to_chat(usr, "[src.occupant] was faster. Try better next time, loser.")
		else
			to_chat(usr, "You stop entering the exosuit.")
	return

/obj/mecha/proc/moved_inside(var/mob/living/carbon/human/H as mob)
	if(H && H.client && (H in range(1)))
		H.reset_view(src)
		/*
		H.client.perspective = EYE_PERSPECTIVE
		H.client.eye = src
		*/
		H.stop_pulling()
		H.forceMove(src)
		src.occupant = H
		src.add_fingerprint(H)
		src.forceMove(src.loc)
		src.verbs += /obj/mecha/verb/eject
		src.log_append_to_last("[H] moved in as pilot.")
		update_icon()
		//VOREStation Edit Add
		if(occupant.hud_used)
			minihud = new (occupant.hud_used, src)
		//VOREStation Edit Add End

//This part removes all the verbs if you don't have them the _possible on your mech. This is a little clunky, but it lets you just add that to any mech.
//And it's not like this 10yo code wasn't clunky before.

		if(!smoke_possible)			//Can't use smoke? No verb for you.
			verbs -= /obj/mecha/verb/toggle_smoke
		if(!thrusters_possible)		//Can't use thrusters? No verb for you.
			verbs -= /obj/mecha/verb/toggle_thrusters
		if(!defence_mode_possible)	//Do i need to explain everything?
			verbs -= /obj/mecha/verb/toggle_defence_mode
		if(!overload_possible)
			verbs -= /obj/mecha/verb/toggle_overload
		if(!zoom_possible)
			verbs -= /obj/mecha/verb/toggle_zoom
		if(!phasing_possible)
			verbs -= /obj/mecha/verb/toggle_phasing
		if(!switch_dmg_type_possible)
			verbs -= /obj/mecha/verb/switch_damtype
		if(!cloak_possible)
			verbs -= /obj/mecha/verb/toggle_cloak

		occupant.in_enclosed_vehicle = 1	//Useful for when you need to know if someone is in a mecho.
		update_cell_alerts()
		update_damage_alerts()
		set_dir(dir_in)
		playsound(src, 'sound/machines/door/windowdoor.ogg', 50, 1)
		if(occupant.client && cloaked_selfimage)
			occupant.client.images += cloaked_selfimage
		play_entered_noise(occupant)
		return 1
	else
		return 0

/obj/mecha/proc/play_entered_noise(var/mob/who)
	if(!hasInternalDamage()) //Otherwise it's not nominal!
		switch(mech_faction)
			if(MECH_FACTION_NT)//The good guys category
				if(firstactivation)//First time = long activation sound
					firstactivation = 1
					who << sound('sound/mecha/LongNanoActivation.ogg',volume=50)
				else
					who << sound('sound/mecha/nominalnano.ogg',volume=50)
			if(MECH_FACTION_SYNDI)//Bad guys
				if(firstactivation)
					firstactivation = 1
					who << sound('sound/mecha/LongSyndiActivation.ogg',volume=50)
				else
					who << sound('sound/mecha/nominalsyndi.ogg',volume=50)
			else//Everyone else gets the normal noise
				who << sound('sound/mecha/nominal.ogg',volume=50)

/obj/mecha/AltClick(mob/living/user)
	if(user == occupant)
		strafing()

/obj/mecha/verb/view_stats()
	set name = "View Stats"
	set category = "Exosuit Interface"
	set src = usr.loc
	set popup_menu = 0
	if(usr!=src.occupant)
		return
	//pr_update_stats.start()
	src.occupant << browse(src.get_stats_html(), "window=exosuit")
	return

/*
/obj/mecha/verb/force_eject()
	set category = "Object"
	set name = "Force Eject"
	set src in view(5)
	src.go_out()
	return
*/

/obj/mecha/verb/eject()
	set name = "Eject"
	set category = "Exosuit Interface"
	set src = usr.loc
	set popup_menu = 0
	if(usr!=src.occupant)
		return
	src.go_out()
	add_fingerprint(usr)
	return


/obj/mecha/proc/go_out() //Eject/Exit the mech. Yes this is for easier searching.
	if(!src.occupant) return
	var/atom/movable/mob_container
	QDEL_NULL(minihud)
	if(ishuman(occupant))
		mob_container = src.occupant
		RemoveActions(occupant, human_occupant=1)//AEIOU
	else if(istype(occupant, /mob/living/carbon/brain))
		var/mob/living/carbon/brain/brain = occupant
		mob_container = brain.container
	else
		return
	if(mob_container.forceMove(src.loc))//ejecting mob container
		log_message("[mob_container] moved out.")
		occupant.reset_view()
		occupant << browse(null, "window=exosuit")
		if(occupant.client && cloaked_selfimage)
			occupant.client.images -= cloaked_selfimage
		if(istype(mob_container, /obj/item/mmi))
			var/obj/item/mmi/mmi = mob_container
			if(mmi.brainmob)
				occupant.loc = mmi
			mmi.mecha = null
			occupant.canmove = 0
		occupant.clear_alert("charge")
		occupant.clear_alert("mech damage")
		occupant.in_enclosed_vehicle = 0
		occupant = null
		update_icon()
		set_dir(dir_in)
		verbs -= /obj/mecha/verb/eject

		//src.zoom = 0

		// Doesn't seem needed.
		if(src.occupant && src.occupant.client)
			src.occupant.client.view = world.view
			src.zoom = 0

		strafing = 0
	return

/////////////////////////
////// Access stuff /////
/////////////////////////

/obj/mecha/proc/operation_allowed(mob/living/carbon/human/H)
	for(var/ID in list(H.get_active_hand(), H.wear_id, H.belt))
		if(src.check_access(ID,src.operation_req_access))
			return 1
	return 0


/obj/mecha/proc/internals_access_allowed(mob/living/carbon/human/H)
	if(istype(H))
		for(var/atom/ID in list(H.get_active_hand(), H.wear_id, H.belt))
			if(src.check_access(ID,src.internals_req_access))
				return 1
	else if(isrobot(H))
		var/mob/living/silicon/robot/R = H
		if(src.check_access(R.idcard,src.internals_req_access))
			return 1
	return 0


/obj/mecha/check_access(obj/item/card/id/I, list/access_list)
	if(!istype(access_list))
		return 1
	if(!access_list.len) //no requirements
		return 1
	if(istype(I, /obj/item/pda))
		var/obj/item/pda/pda = I
		I = pda.id
	if(!istype(I) || !I.GetAccess()) //not ID or no access
		return 0
	if(access_list==src.operation_req_access)
		for(var/req in access_list)
			if(!(req in I.GetAccess())) //doesn't have this access
				return 0
	else if(access_list==src.internals_req_access)
		for(var/req in access_list)
			if(req in I.GetAccess())
				return 1
	return 1


////////////////////////////////////
///// Rendering stats window ///////
////////////////////////////////////

/obj/mecha/proc/get_stats_html()
	var/output = {"<html>
						<head><title>[src.name] data</title>
						<style>
						body {color: #00ff00; background: #000000; font-family:"Lucida Console",monospace; font-size: 12px;}
						hr {border: 1px solid #0f0; color: #0f0; background-color: #0f0;}
						a {padding:2px 5px;;color:#0f0;}
						.wr {margin-bottom: 5px;}
						.header {cursor:pointer;}
						.open, .closed {background: #32CD32; color:#000; padding:1px 2px;}
						.links a {margin-bottom: 2px;padding-top:3px;}
						.visible {display: block;}
						.hidden {display: none;}
						</style>
						<script language='javascript' type='text/javascript'>
						[js_byjax]
						[js_dropdowns]
						function ticker() {
						    setInterval(function(){
						        window.location='byond://?src=\ref[src]&update_content=1';
						    }, 1000);
						}

						window.onload = function() {
							dropdowns();
							ticker();
						}
						</script>
						</head>
						<body>
						<div id='content'>
						[src.get_stats_part()]
						</div>
						<div id='eq_list'>
						[src.get_equipment_list()]
						</div>
						<hr>
						<div id='commands'>
						[src.get_commands()]
						</div>
						</body>
						</html>
					 "}
	return output


/obj/mecha/proc/report_internal_damage()
	var/output = null
	var/list/dam_reports = list(
										"[MECHA_INT_FIRE]" = "<font color='red'><b>INTERNAL FIRE</b></font>",
										"[MECHA_INT_TEMP_CONTROL]" = "<font color='red'><b>LIFE SUPPORT SYSTEM MALFUNCTION</b></font>",
										"[MECHA_INT_TANK_BREACH]" = "<font color='red'><b>GAS TANK BREACH</b></font>",
										"[MECHA_INT_CONTROL_LOST]" = "<font color='red'><b>COORDINATION SYSTEM CALIBRATION FAILURE</b></font> - <a href='byond://?src=\ref[src];repair_int_control_lost=1'>Recalibrate</a>",
										"[MECHA_INT_SHORT_CIRCUIT]" = "<font color='red'><b>SHORT CIRCUIT</b></font>"
										)
	for(var/tflag in dam_reports)
		var/intdamflag = text2num(tflag)
		if(hasInternalDamage(intdamflag))
			output += dam_reports[tflag]
			output += "<br />"
	if(return_pressure() > WARNING_HIGH_PRESSURE)
		output += "<font color='red'><b>DANGEROUSLY HIGH CABIN PRESSURE</b></font><br />"
	return output


/obj/mecha/proc/get_stats_part()
	var/integrity = health/initial(health)*100
	var/cell_charge = get_charge()
	var/tank_pressure = internal_tank ? round(internal_tank.return_pressure(),0.01) : "None"
	var/tank_temperature = internal_tank ? internal_tank.return_temperature() : "Unknown"
	var/cabin_pressure = round(return_pressure(),0.01)

	var/obj/item/mecha_parts/component/hull/HC = internal_components[MECH_HULL]
	var/obj/item/mecha_parts/component/armor/AC = internal_components[MECH_ARMOR]

	var/output = {"[report_internal_damage()]
						<b>Armor Integrity: </b>[AC?"[round(AC.integrity / AC.max_integrity * 100, 0.1)]%":span_warning("ARMOR MISSING")]<br>
						<b>Hull Integrity: </b>[HC?"[round(HC.integrity / HC.max_integrity * 100, 0.1)]%":span_warning("HULL MISSING")]<br>
						[integrity<30?"<font color='red'><b>DAMAGE LEVEL CRITICAL</b></font><br>":null]
						<b>Chassis Integrity: </b> [integrity]%<br>
						<b>Powercell charge: </b>[isnull(cell_charge)?"No powercell installed":"[cell.percent()]%"]<br>
						<b>Air source: </b>[use_internal_tank?"Internal Airtank":"Environment"]<br>
						<b>Airtank pressure: </b>[tank_pressure]kPa<br>
						<b>Airtank temperature: </b>[tank_temperature]K|[tank_temperature - T0C]&deg;C<br>
						<b>Cabin pressure: </b>[cabin_pressure>WARNING_HIGH_PRESSURE ? "<font color='red'>[cabin_pressure]</font>": cabin_pressure]kPa<br>
						<b>Cabin temperature: </b> [return_temperature()]K|[return_temperature() - T0C]&deg;C<br>
						<b>Lights: </b>[lights?"on":"off"]<br>
						[src.dna?"<b>DNA-locked:</b><br> <span style='font-size:10px;letter-spacing:-1px;'>[src.dna]</span> \[<a href='byond://?src=\ref[src];reset_dna=1'>Reset</a>\]<br>":null]
					"}


	if(defence_mode_possible)
		output += span_bold("Defence mode: [defence_mode?"on":"off"]") + "<br>"
	if(overload_possible)
		output += span_bold("Leg actuators overload: [overload?"on":"off"]") + "<br>"
	if(smoke_possible)
		output += span_bold("Smoke:") + " [smoke_reserve]<br>"
	if(thrusters_possible)
		output += span_bold("Thrusters:") + " [thrusters?"on":"off"]<br>"

//Cargo components. Keep this last otherwise it does weird alignment issues.
	output += span_bold("Cargo Compartment Contents:") + "<div style=\"margin-left: 15px;\">"
	if(src.cargo.len)
		for(var/obj/O in src.cargo)
			output += "<a href='byond://?src=\ref[src];drop_from_cargo=\ref[O]'>Unload</a> : [O]<br>"
	else
		output += "Nothing"
	output += "</div>"
	return output

/obj/mecha/proc/get_commands()
	var/output = {"<div class='wr'>
						<div class='header'>Electronics</div>
						<div class='links'>
						<a href='byond://?src=\ref[src];toggle_lights=1'>Toggle Lights</a><br>
						<b>Radio settings:</b><br>
						Microphone: <a href='byond://?src=\ref[src];rmictoggle=1'><span id="rmicstate">[radio.broadcasting?"Engaged":"Disengaged"]</span></a><br>
						Speaker: <a href='byond://?src=\ref[src];rspktoggle=1'><span id="rspkstate">[radio.listening?"Engaged":"Disengaged"]</span></a><br>
						Frequency:
						<a href='byond://?src=\ref[src];rfreq=-10'>-</a>
						<a href='byond://?src=\ref[src];rfreq=-2'>-</a>
						<span id="rfreq">[format_frequency(radio.frequency)]</span>
						<a href='byond://?src=\ref[src];rfreq=2'>+</a>
						<a href='byond://?src=\ref[src];rfreq=10'>+</a><br>
						</div>
						</div>
						<div class='wr'>
						<div class='header'>Airtank</div>
						<div class='links'>
						<a href='byond://?src=\ref[src];toggle_airtank=1'>Toggle Internal Airtank Usage</a><br>
						[(/obj/mecha/verb/disconnect_from_port in src.verbs)?"<a href='byond://?src=\ref[src];port_disconnect=1'>Disconnect from port</a><br>":null]
						[(/obj/mecha/verb/connect_to_port in src.verbs)?"<a href='byond://?src=\ref[src];port_connect=1'>Connect to port</a><br>":null]
						</div>
						</div>
						<div class='wr'>
						<div class='header'>Permissions & Logging</div>
						<div class='links'>
						<a href='byond://?src=\ref[src];toggle_id_upload=1'><span id='t_id_upload'>[add_req_access?"L":"Unl"]ock ID upload panel</span></a><br>
						<a href='byond://?src=\ref[src];toggle_maint_access=1'><span id='t_maint_access'>[maint_access?"Forbid":"Permit"] maintenance protocols</span></a><br>
						<a href='byond://?src=\ref[src];dna_lock=1'>DNA-lock</a><br>
						<a href='byond://?src=\ref[src];view_log=1'>View internal log</a><br>
						<a href='byond://?src=\ref[src];change_name=1'>Change exosuit name</a><br>
						</div>
						</div>
						<div id='equipment_menu'>[get_equipment_menu()]</div>
						<hr>
						[(/obj/mecha/verb/eject in src.verbs)?"<a href='byond://?src=\ref[src];eject=1'>Eject</a><br>":null]
						"}
	return output

/obj/mecha/proc/get_equipment_menu() //outputs mecha html equipment menu
	var/output
	if(equipment.len)
		output += {"<div class='wr'>
						<div class='header'>Equipment</div>
						<div class='links'>"}
		for(var/obj/item/mecha_parts/mecha_equipment/W in hull_equipment)
			output += "Hull Module: [W.name] <a href='byond://?src=\ref[W];detach=1'>Detach</a><br>"
		for(var/obj/item/mecha_parts/mecha_equipment/W in weapon_equipment)
			output += "Weapon Module: [W.name] <a href='byond://?src=\ref[W];detach=1'>Detach</a><br>"
		for(var/obj/item/mecha_parts/mecha_equipment/W in utility_equipment)
			output += "Utility Module: [W.name] <a href='byond://?src=\ref[W];detach=1'>Detach</a><br>"
		for(var/obj/item/mecha_parts/mecha_equipment/W in universal_equipment)
			output += "Universal Module: [W.name] <a href='byond://?src=\ref[W];detach=1'>Detach</a><br>"
		for(var/obj/item/mecha_parts/mecha_equipment/W in special_equipment)
			output += "Special Module: [W.name] <a href='byond://?src=\ref[W];detach=1'>Detach</a><br>"
		for(var/obj/item/mecha_parts/mecha_equipment/W in micro_utility_equipment) // VOREstation Edit -  Adds micro equipent to the menu
			output += "Micro Utility Module: [W.name] <a href='byond://?src=\ref[W];detach=1'>Detach</a><br>"
		for(var/obj/item/mecha_parts/mecha_equipment/W in micro_weapon_equipment)
			output += "Micro Weapon Module: [W.name] <a href='byond://?src=\ref[W];detach=1'>Detach</a><br>"
	output += {"<b>Available hull slots:</b> [max_hull_equip-hull_equipment.len]<br>
	 <b>Available weapon slots:</b> [max_weapon_equip-weapon_equipment.len]<br>
	 <b>Available micro weapon slots:</b> [max_micro_weapon_equip-micro_weapon_equipment.len]<br>
	 <b>Available utility slots:</b> [max_utility_equip-utility_equipment.len]<br>
	 <b>Available micro utility slots:</b> [max_micro_utility_equip-micro_utility_equipment.len]<br>
	 <b>Available universal slots:</b> [max_universal_equip-universal_equipment.len]<br>
	 <b>Available special slots:</b> [max_special_equip-special_equipment.len]<br>
	 </div></div>
	 "}
	return output

/obj/mecha/proc/get_equipment_list() //outputs mecha equipment list in html
	if(!equipment.len)
		return
	var/output = span_bold("Equipment:") + "<div style=\"margin-left: 15px;\">"
	for(var/obj/item/mecha_parts/mecha_equipment/MT in equipment)
		output += "<div id='\ref[MT]'>[MT.get_equip_info()]</div>"
	output += "</div>"
	return output


/obj/mecha/proc/get_log_html()
	var/output = "<html><head><title>[src.name] Log</title></head><body style='font: 13px 'Courier', monospace;'>"
	for(var/list/entry in log)
		output += {"<div style='font-weight: bold;'>[time2text(entry["time"],"DDD MMM DD hh:mm:ss")] [game_year]</div>
						<div style='margin-left:15px; margin-bottom:10px;'>[entry["message"]]</div>
						"}
	output += "</body></html>"
	return output

/obj/mecha/proc/get_log_tgui()
	var/list/data = list()
	for(var/list/entry in log)
		data.Add(list(list(
			"time" = time2text(entry["time"], "DDD MMM DD hh:mm:ss"),
			"year" = game_year,
			"message" = entry["message"],
		)))
	return data


/obj/mecha/proc/output_access_dialog(obj/item/card/id/id_card, mob/user)
	if(!id_card || !user) return
	var/output = {"<html>
						<head><style>
						h1 {font-size:15px;margin-bottom:4px;}
						body {color: #00ff00; background: #000000; font-family:"Courier New", Courier, monospace; font-size: 12px;}
						a {color:#0f0;}
						</style>
						</head>
						<body>
						<h1>Following keycodes are present in this system:</h1>"}
	for(var/a in operation_req_access)
		output += "[get_access_desc(a)] - <a href='byond://?src=\ref[src];del_req_access=[a];user=\ref[user];id_card=\ref[id_card]'>Delete</a><br>"
	output += "<hr><h1>Following keycodes were detected on portable device:</h1>"
	for(var/a in id_card.GetAccess())
		if(a in operation_req_access) continue
		var/a_name = get_access_desc(a)
		if(!a_name) continue //there's some strange access without a name
		output += "[a_name] - <a href='byond://?src=\ref[src];add_req_access=[a];user=\ref[user];id_card=\ref[id_card]'>Add</a><br>"
	output += "<hr><a href='byond://?src=\ref[src];finish_req_access=1;user=\ref[user]'>Finish</a> <font color='red'>(Warning! The ID upload panel will be locked. It can be unlocked only through Exosuit Interface.)</font>"
	output += "</body></html>"
	user << browse(output, "window=exosuit_add_access")
	onclose(user, "exosuit_add_access")
	return

/obj/mecha/proc/output_maintenance_dialog(obj/item/card/id/id_card,mob/user)
	if(!id_card || !user) return

	var/maint_options = "<a href='byond://?src=\ref[src];set_internal_tank_valve=1;user=\ref[user]'>Set Cabin Air Pressure</a>"
	if (locate(/obj/item/mecha_parts/mecha_equipment/tool/passenger) in contents)
		maint_options += "<a href='byond://?src=\ref[src];remove_passenger=1;user=\ref[user]'>Remove Passenger</a>"

	var/output = {"<html>
						<head>
						<style>
						body {color: #00ff00; background: #000000; font-family:"Courier New", Courier, monospace; font-size: 12px;}
						a {padding:2px 5px; background:#32CD32;color:#000;display:block;margin:2px;text-align:center;text-decoration:none;}
						</style>
						</head>
						<body>
						[add_req_access?"<a href='byond://?src=\ref[src];req_access=1;id_card=\ref[id_card];user=\ref[user]'>Edit operation keycodes</a>":null]
						[maint_access?"<a href='byond://?src=\ref[src];maint_access=1;id_card=\ref[id_card];user=\ref[user]'>Initiate maintenance protocol</a>":null]
						[(state>0) ? maint_options : ""]
						</body>
						</html>"}
	user << browse(output, "window=exosuit_maint_console")
	onclose(user, "exosuit_maint_console")
	return


////////////////////////////////
/////// Messages and Log ///////
////////////////////////////////

/obj/mecha/proc/occupant_message(message as text)
	if(message)
		if(src.occupant && src.occupant.client)
			to_chat(src.occupant, "[icon2html(src, src.occupant.client)] [message]")
	return

/obj/mecha/proc/log_message(message as text,red=null)
	log.len++
	log[log.len] = list("time"=world.timeofday,"message"="[red?"<font color='red'>":null][message][red?"</font>":null]")
	return log.len

/obj/mecha/proc/log_append_to_last(message as text,red=null)
	var/list/last_entry = src.log[src.log.len]
	last_entry["message"] += "<br>[red?"<font color='red'>":null][message][red?"</font>":null]"
	return


/////////////////
///// Topic /////
/////////////////

/obj/mecha/Topic(href, href_list)
	..()
	if(href_list["update_content"])
		if(usr != src.occupant)	return
		send_byjax(src.occupant,"exosuit.browser","content",src.get_stats_part())
		return
	if(href_list["close"])
		return
	if(usr.stat > 0)
		return
	var/datum/topic_input/top_filter = new /datum/topic_input(href,href_list)
	if(href_list["select_equip"])
		if(usr != src.occupant)	return
		var/obj/item/mecha_parts/mecha_equipment/equip = top_filter.getObj("select_equip")
		if(equip)
			src.selected = equip
			src.occupant_message("You switch to [equip].")
			src.visible_message("[src] raises [equip].")
			send_byjax(src.occupant,"exosuit.browser","eq_list",src.get_equipment_list())
		return
	if(href_list["eject"])
		if(usr != src.occupant)	return
		src.eject()
		return
	if(href_list["toggle_lights"])
		if(usr != src.occupant)	return
		src.lights()
		return
/*
	if(href_list["toggle_strafing"])
		if(usr != src.occupant)	return
		src.strafing()
		return*/

	if(href_list["toggle_airtank"])
		if(usr != src.occupant)	return
		src.internal_tank()
		return
	if (href_list["toggle_thrusters"])
		src.toggle_thrusters()
	if (href_list["smoke"])
		src.smoke()
	if (href_list["toggle_zoom"])
		src.zoom()
	if(href_list["toggle_defence_mode"])
		src.defence_mode()
	if(href_list["switch_damtype"])
		src.switch_damtype()
	if(href_list["phasing"])
		src.phasing()

	if(href_list["rmictoggle"])
		if(usr != src.occupant)	return
		radio.broadcasting = !radio.broadcasting
		send_byjax(src.occupant,"exosuit.browser","rmicstate",(radio.broadcasting?"Engaged":"Disengaged"))
		return
	if(href_list["rspktoggle"])
		if(usr != src.occupant)	return
		radio.listening = !radio.listening
		send_byjax(src.occupant,"exosuit.browser","rspkstate",(radio.listening?"Engaged":"Disengaged"))
		return
	if(href_list["rfreq"])
		if(usr != src.occupant)	return
		var/new_frequency = (radio.frequency + top_filter.getNum("rfreq"))
		if ((radio.frequency < PUBLIC_LOW_FREQ || radio.frequency > PUBLIC_HIGH_FREQ))
			new_frequency = sanitize_frequency(new_frequency)
		radio.set_frequency(new_frequency)
		send_byjax(src.occupant,"exosuit.browser","rfreq","[format_frequency(radio.frequency)]")
		return
	if(href_list["port_disconnect"])
		if(usr != src.occupant)	return
		src.disconnect_from_port()
		return
	if (href_list["port_connect"])
		if(usr != src.occupant)	return
		src.connect_to_port()
		return
	if (href_list["view_log"])
		if(usr != src.occupant)	return
		src.occupant << browse(src.get_log_html(), "window=exosuit_log")
		onclose(occupant, "exosuit_log")
		return
	if (href_list["change_name"])
		if(usr != src.occupant)	return
		var/newname = sanitizeSafe(tgui_input_text(occupant,"Choose new exosuit name","Rename exosuit",initial(name), MAX_NAME_LEN), MAX_NAME_LEN)
		if(newname)
			name = newname
		else
			tgui_alert_async(occupant, "nope.avi")
		return
	if (href_list["toggle_id_upload"])
		if(usr != src.occupant)	return
		add_req_access = !add_req_access
		send_byjax(src.occupant,"exosuit.browser","t_id_upload","[add_req_access?"L":"Unl"]ock ID upload panel")
		return
	if(href_list["toggle_maint_access"])
		if(usr != src.occupant)	return
		if(state)
			occupant_message(span_red("Maintenance protocols in effect"))
			return
		maint_access = !maint_access
		send_byjax(src.occupant,"exosuit.browser","t_maint_access","[maint_access?"Forbid":"Permit"] maintenance protocols")
		return
	if(href_list["req_access"] && add_req_access)
		if(!in_range(src, usr))	return
		output_access_dialog(top_filter.getObj("id_card"),top_filter.getMob("user"))
		return
	if(href_list["maint_access"] && maint_access)
		if(!in_range(src, usr))	return
		var/mob/user = top_filter.getMob("user")
		if(user)
			if(state==MECHA_OPERATING)
				state = MECHA_BOLTS_SECURED
				to_chat(user, "The securing bolts are now exposed.")
			else if(state==MECHA_BOLTS_SECURED)
				state = MECHA_OPERATING
				to_chat(user, "The securing bolts are now hidden.")
			output_maintenance_dialog(top_filter.getObj("id_card"),user)
		return
	if(href_list["set_internal_tank_valve"] && state >=MECHA_BOLTS_SECURED)
		if(!in_range(src, usr))	return
		var/mob/user = top_filter.getMob("user")
		if(user)
			var/new_pressure = tgui_input_number(user,"Input new output pressure","Pressure setting",internal_tank_valve, round_value=FALSE)
			if(new_pressure)
				internal_tank_valve = new_pressure
				to_chat(user, "The internal pressure valve has been set to [internal_tank_valve]kPa.")
	if(href_list["remove_passenger"] && state >= MECHA_BOLTS_SECURED)
		var/mob/user = top_filter.getMob("user")
		var/list/passengers = list()
		for (var/obj/item/mecha_parts/mecha_equipment/tool/passenger/P in contents)
			if (P.occupant)
				passengers["[P.occupant]"] = P

		if (!passengers)
			to_chat(user, span_warning("There are no passengers to remove."))
			return

		var/pname = tgui_input_list(user, "Choose a passenger to forcibly remove.", "Forcibly Remove Passenger", passengers)

		if (!pname)
			return

		var/obj/item/mecha_parts/mecha_equipment/tool/passenger/P = passengers[pname]
		var/mob/occupant = P.occupant

		user.visible_message(span_infoplain(span_bold("\The [user]") + " begins opening the hatch on \the [P]..."), span_notice("You begin opening the hatch on \the [P]..."))
		if (!do_after(user, 40))
			return

		user.visible_message(span_infoplain(span_bold("\The [user]") + " opens the hatch on \the [P] and removes [occupant]!"), span_notice("You open the hatch on \the [P] and remove [occupant]!"))
		P.go_out()
		P.log_message("[occupant] was removed.")
		return
	if(href_list["add_req_access"] && add_req_access && top_filter.getObj("id_card"))
		if(!in_range(src, usr))	return
		operation_req_access += top_filter.getNum("add_req_access")
		output_access_dialog(top_filter.getObj("id_card"),top_filter.getMob("user"))
		return
	if(href_list["del_req_access"] && add_req_access && top_filter.getObj("id_card"))
		if(!in_range(src, usr))	return
		operation_req_access -= top_filter.getNum("del_req_access")
		output_access_dialog(top_filter.getObj("id_card"),top_filter.getMob("user"))
		return
	if(href_list["finish_req_access"])
		if(!in_range(src, usr))	return
		add_req_access = 0
		var/mob/user = top_filter.getMob("user")
		user << browse(null,"window=exosuit_add_access")
		return
	if(href_list["dna_lock"])
		if(usr != src.occupant)	return
		if(istype(occupant, /mob/living/carbon/brain))
			occupant_message("You are a brain. No.")
			return
		if(src.occupant)
			src.dna = src.occupant.dna.unique_enzymes
			src.occupant_message("You feel a prick as the needle takes your DNA sample.")
		return
	if(href_list["reset_dna"])
		if(usr != src.occupant)	return
		src.dna = null
	if(href_list["repair_int_control_lost"])
		if(usr != src.occupant)	return
		src.occupant_message("Recalibrating coordination system.")
		src.log_message("Recalibration of coordination system started.")
		var/T = src.loc
		if(do_after(100))
			if(T == src.loc)
				src.clearInternalDamage(MECHA_INT_CONTROL_LOST)
				src.occupant_message(span_blue("Recalibration successful."))
				src.log_message("Recalibration of coordination system finished with 0 errors.")
			else
				src.occupant_message(span_red("Recalibration failed."))
				src.log_message("Recalibration of coordination system failed with 1 error.",1)
	if(href_list["drop_from_cargo"])
		var/obj/O = locate(href_list["drop_from_cargo"])
		if(O && (O in src.cargo))
			src.occupant_message(span_notice("You unload [O]."))
			O.forceMove(get_turf(src))
			src.cargo -= O
			var/turf/T = get_turf(O)
			if(T)
				T.Entered(O)
			src.log_message("Unloaded [O]. Cargo compartment capacity: [cargo_capacity - src.cargo.len]")
	return

	//debug
	/*
	if(href_list["debug"])
		if(href_list["set_i_dam"])
			setInternalDamage(top_filter.getNum("set_i_dam"))
		if(href_list["clear_i_dam"])
			clearInternalDamage(top_filter.getNum("clear_i_dam"))
		return
	*/



/*

	if (href_list["ai_take_control"])
		var/mob/living/silicon/ai/AI = locate(href_list["ai_take_control"])
		var/duration = text2num(href_list["duration"])
		var/mob/living/silicon/ai/O = new /mob/living/silicon/ai(src)
		var/cur_occupant = src.occupant
		O.invisibility = 0
		O.canmove = 1
		O.name = AI.name
		O.real_name = AI.real_name
		O.anchored = TRUE
		O.aiRestorePowerRoutine = 0
		O.control_disabled = 1 // Can't control things remotely if you're stuck in a card!
		O.laws = AI.laws
		O.set_stat(AI.stat)
		O.oxyloss = AI.getOxyLoss()
		O.fireloss = AI.getFireLoss()
		O.bruteloss = AI.getBruteLoss()
		O.toxloss = AI.toxloss
		O.updatehealth()
		src.occupant = O
		if(AI.mind)
			AI.mind.transfer_to(O)
		AI.name = "Inactive AI"
		AI.real_name = "Inactive AI"
		AI.icon_state = "ai-empty"
		spawn(duration)
			AI.name = O.name
			AI.real_name = O.real_name
			if(O.mind)
				O.mind.transfer_to(AI)
			AI.control_disabled = 0
			AI.laws = O.laws
			AI.oxyloss = O.getOxyLoss()
			AI.fireloss = O.getFireLoss()
			AI.bruteloss = O.getBruteLoss()
			AI.toxloss = O.toxloss
			AI.updatehealth()
			qdel(O)
			if (!AI.stat)
				AI.icon_state = "ai"
			else
				AI.icon_state = "ai-crash"
			src.occupant = cur_occupant
*/

///////////////////////
///// Power stuff /////
///////////////////////

/obj/mecha/proc/has_charge(amount)
	return (get_charge()>=amount)

/obj/mecha/proc/get_charge()
	return call((proc_res["dyngetcharge"]||src), "dyngetcharge")()

/obj/mecha/proc/dyngetcharge()//returns null if no powercell, else returns cell.charge
	if(!src.cell) return
	return max(0, src.cell.charge)

/obj/mecha/proc/use_power(amount)
	return call((proc_res["dynusepower"]||src), "dynusepower")(amount)

/obj/mecha/proc/dynusepower(amount)
	update_cell_alerts()
	var/obj/item/mecha_parts/component/electrical/EC = internal_components[MECH_ELECTRIC]

	if(EC)
		amount = amount * (2 - EC.get_efficiency()) * EC.charge_cost_mod
	else
		amount *= 5

	if(get_charge())
		cell.use(amount)
		return 1
	return 0

/obj/mecha/proc/give_power(amount)
	update_cell_alerts()
	var/obj/item/mecha_parts/component/electrical/EC = internal_components[MECH_ELECTRIC]

	if(!EC)
		amount /= 4
	else
		amount *= EC.get_efficiency()

	if(!isnull(get_charge()))
		cell.give(amount)
		return 1
	return 0

//This is for mobs mostly.
/obj/mecha/attack_generic(var/mob/user, var/damage, var/attack_message)

	var/obj/item/mecha_parts/component/armor/ArmC = internal_components[MECH_ARMOR]

	var/temp_deflect_chance = deflect_chance
	var/temp_damage_minimum = damage_minimum

	if(!ArmC)
		temp_deflect_chance = 1
		temp_damage_minimum = 0

	else
		temp_deflect_chance = round(ArmC.get_efficiency() * ArmC.deflect_chance + (defence_mode ? 25 : 0))
		temp_damage_minimum = round(ArmC.get_efficiency() * ArmC.damage_minimum)

	user.setClickCooldown(user.get_attack_speed())
	if(!damage)
		return 0

	src.log_message("Attacked. Attacker - [user].",1)
	user.do_attack_animation(src)

	if(prob(temp_deflect_chance))//Deflected
		src.log_append_to_last("Armor saved.")
		src.occupant_message(span_notice("\The [user]'s attack is stopped by the armor."))
		visible_message(span_infoplain(span_bold("\The [user]") + " rebounds off [src.name]'s armor!"))
		user.attack_log += text("\[[time_stamp()]\] [span_red("attacked [src.name]")]")
		playsound(src, 'sound/weapons/slash.ogg', 50, 1, -1)

	else if(damage < temp_damage_minimum)//Pathetic damage levels just don't harm MECH.
		src.occupant_message(span_notice("\The [user]'s doesn't dent \the [src] paint."))
		src.visible_message("\The [user]'s attack doesn't dent \the [src] armor")
		src.log_append_to_last("Armor saved.")
		playsound(src, 'sound/effects/Glasshit.ogg', 50, 1)
		return

	else
		src.take_damage(damage)	//Apply damage - The take_damage() proc handles armor values
		if(damage > internal_damage_minimum)	//Only decently painful attacks trigger a chance of mech damage.
			src.check_for_internal_damage(list(MECHA_INT_TEMP_CONTROL,MECHA_INT_TANK_BREACH,MECHA_INT_CONTROL_LOST))
		visible_message(span_danger("[user] [attack_message] [src]!"))
		user.attack_log += text("\[[time_stamp()]\] [span_red("attacked [src.name]")]")

	return 1


/////////////////////////////////////////
//////// Mecha process() helpers ////////
/////////////////////////////////////////
/obj/mecha/proc/stop_process(process)
	current_processes &= ~process

/obj/mecha/proc/start_process(process)
	current_processes |= process


/////////////
/obj/mecha/cloak()
	. = ..()
	if(occupant && occupant.client && cloaked_selfimage)
		occupant.client.images += cloaked_selfimage

/obj/mecha/uncloak()
	if(occupant && occupant.client && cloaked_selfimage)
		occupant.client.images -= cloaked_selfimage
	return ..()


//debug
/*
/obj/mecha/verb/test_int_damage()
	set name = "Test internal damage"
	set category = "Exosuit Interface"
	set src in view(0)
	if(!occupant) return
	if(usr!=occupant)
		return
	var/output = {"<html>
						<head>
						</head>
						<body>
						<h3>Set:</h3>
						<a href='byond://?src=\ref[src];debug=1;set_i_dam=[MECHA_INT_FIRE]'>MECHA_INT_FIRE</a><br />
						<a href='byond://?src=\ref[src];debug=1;set_i_dam=[MECHA_INT_TEMP_CONTROL]'>MECHA_INT_TEMP_CONTROL</a><br />
						<a href='byond://?src=\ref[src];debug=1;set_i_dam=[MECHA_INT_SHORT_CIRCUIT]'>MECHA_INT_SHORT_CIRCUIT</a><br />
						<a href='byond://?src=\ref[src];debug=1;set_i_dam=[MECHA_INT_TANK_BREACH]'>MECHA_INT_TANK_BREACH</a><br />
						<a href='byond://?src=\ref[src];debug=1;set_i_dam=[MECHA_INT_CONTROL_LOST]'>MECHA_INT_CONTROL_LOST</a><br />
						<hr />
						<h3>Clear:</h3>
						<a href='byond://?src=\ref[src];debug=1;clear_i_dam=[MECHA_INT_FIRE]'>MECHA_INT_FIRE</a><br />
						<a href='byond://?src=\ref[src];debug=1;clear_i_dam=[MECHA_INT_TEMP_CONTROL]'>MECHA_INT_TEMP_CONTROL</a><br />
						<a href='byond://?src=\ref[src];debug=1;clear_i_dam=[MECHA_INT_SHORT_CIRCUIT]'>MECHA_INT_SHORT_CIRCUIT</a><br />
						<a href='byond://?src=\ref[src];debug=1;clear_i_dam=[MECHA_INT_TANK_BREACH]'>MECHA_INT_TANK_BREACH</a><br />
						<a href='byond://?src=\ref[src];debug=1;clear_i_dam=[MECHA_INT_CONTROL_LOST]'>MECHA_INT_CONTROL_LOST</a><br />
 					   </body>
						</html>"}

	occupant << browse(output, "window=ex_debug")
	//src.health = initial(src.health)/2.2
	//src.check_for_internal_damage(list(MECHA_INT_FIRE,MECHA_INT_TEMP_CONTROL,MECHA_INT_TANK_BREACH,MECHA_INT_CONTROL_LOST))
	return
*/

/obj/mecha/proc/update_cell_alerts()
	if(occupant && cell)
		var/cellcharge = cell.charge/cell.maxcharge
		switch(cellcharge)
			if(0.75 to INFINITY)
				occupant.clear_alert("charge")
			if(0.5 to 0.75)
				occupant.throw_alert("charge", /obj/screen/alert/lowcell, 1)
			if(0.25 to 0.5)
				occupant.throw_alert("charge", /obj/screen/alert/lowcell, 2)
			if(0.01 to 0.25)
				occupant.throw_alert("charge", /obj/screen/alert/lowcell, 3)
			else
				occupant.throw_alert("charge", /obj/screen/alert/emptycell)

/obj/mecha/proc/update_damage_alerts()
	if(occupant)
		var/integrity = health/initial(health)*100
		switch(integrity)
			if(30 to 45)
				occupant.throw_alert("mech damage", /obj/screen/alert/low_mech_integrity, 1)
			if(15 to 35)
				occupant.throw_alert("mech damage", /obj/screen/alert/low_mech_integrity, 2)
			if(-INFINITY to 15)
				occupant.throw_alert("mech damage", /obj/screen/alert/low_mech_integrity, 3)
			else
				occupant.clear_alert("mech damage")

/obj/mecha/blob_act(var/obj/structure/blob/B)
	var/datum/blob_type/blob = B?.overmind?.blob_type
	if(!istype(blob))
		return FALSE

	var/damage = rand(blob.damage_lower, blob.damage_upper)
	src.take_damage(damage, blob.damage_type)
	visible_message(span_danger("\The [B] [blob.attack_verb] \the [src]!"), span_danger("[blob.attack_message_synth]!"))
	playsound(src, 'sound/effects/attackblob.ogg', 50, 1)

	return ..()

#undef MECHA_OPERATING
#undef MECHA_BOLTS_SECURED
#undef MECHA_PANEL_LOOSE
#undef MECHA_CELL_OPEN
#undef MECHA_CELL_OUT
