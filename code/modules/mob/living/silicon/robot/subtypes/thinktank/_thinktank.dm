// Spawner landmarks are used because platforms that are mapped during
// SSatoms init try to Initialize() twice. I have no idea why and I am 
// not paid enough to spend more time trying to debug it.
/obj/effect/landmark/robot_platform
	name = "recon platform spawner"
	icon = 'icons/mob/screen1.dmi'
	icon_state = "x3"
	delete_me = TRUE
	var/platform_type

/obj/effect/landmark/robot_platform/Initialize()
	if(platform_type)
		new platform_type(get_turf(src))
	return ..()

/mob/living/silicon/robot/platform
	name = "support platform"
	desc = "A large quadrupedal AI platform, colloquially known as a 'think-tank' due to the flexible onboard intelligence."
	icon = 'icons/mob/robots_thinktank.dmi'
	icon_state = "tachi"
	color = "#68a2f2"

	cell =        /obj/item/cell/mech
	idcard_type = /obj/item/card/id/platform
	module =      /obj/item/robot_module/robot/platform

	lawupdate = FALSE
	modtype = "Standard"
	speak_statement = "chirps"

	mob_bump_flag =   HEAVY
	mob_swap_flags = ~HEAVY
	mob_push_flags =  HEAVY
	mob_size =        MOB_LARGE

	var/has_had_player = FALSE
	var/const/platform_respawn_time = 3 MINUTES

	var/tmp/last_recharge_state =     FALSE
	var/tmp/recharge_complete =       FALSE
	var/tmp/recharger_charge_amount = 10 KILOWATTS
	var/tmp/recharger_tick_cost =     80 KILOWATTS
	var/weakref/recharging

	var/list/stored_atoms
	var/max_stored_atoms = 1
	var/static/list/can_store_types = list(
		/mob/living,
		/obj/item,
		/obj/structure,
		/obj/machinery
	)
	// Currently set to prevent tonks hauling a deliaminating SM into the middle of the station.
	var/static/list/cannot_store_types = list(
		/obj/machinery/power/supermatter
	)

/mob/living/silicon/robot/platform/Login()
	. = ..()
	has_had_player = TRUE

/mob/living/silicon/robot/platform/SetName(pickedName)
	. = ..()
	if(mind)
		mind.name = real_name

/mob/living/silicon/robot/platform/Initialize(var/mapload)
	. = ..()
	if(!mmi)
		mmi = new /obj/item/mmi/digital/robot(src)
	SetName("inactive [initial(name)]")
	updateicon()

// Copypasting from root proc to avoid calling ..() and accidentally creating duplicate armour etc.
/mob/living/silicon/robot/platform/initialize_components()
	components["actuator"] =       new /datum/robot_component/actuator(src)
	components["radio"] =          new /datum/robot_component/radio(src)
	components["power cell"] =     new /datum/robot_component/cell(src)
	components["diagnosis unit"] = new /datum/robot_component/diagnosis_unit(src)
	components["camera"] =         new /datum/robot_component/camera(src)
	components["comms"] =          new /datum/robot_component/binary_communication(src)
	components["armour"] =         new /datum/robot_component/armour/platform(src)

/mob/living/silicon/robot/platform/Destroy()
	for(var/weakref/drop_ref in stored_atoms)
		var/atom/movable/drop_atom = drop_ref.resolve()
		if(istype(drop_atom) && !QDELETED(drop_atom) && drop_atom.loc == src)
			drop_atom.dropInto(loc)
	stored_atoms = null
	if(recharging)
		var/obj/item/recharging_atom = recharging.resolve()
		if(istype(recharging_atom) && recharging_atom.loc == src)
			recharging_atom.dropInto(loc)
		recharging = null
	. = ..()

/mob/living/silicon/robot/platform/examine(mob/user, distance)
	. = ..()
	if(distance <= 3)

		if(recharging)
			var/obj/item/cell/recharging_atom = recharging.resolve()
			if(istype(recharging_atom) && !QDELETED(recharging_atom))
				. += "It has \a [recharging_atom] slotted into its recharging port."
				. += "The cell readout shows [round(recharging_atom.percent(),1)]% charge."
			else
				. += "Its recharging port is empty."
		else
			. += "Its recharging port is empty."

		if(length(stored_atoms))
			var/list/atom_names = list()
			for(var/weakref/stored_ref in stored_atoms)
				var/atom/movable/AM = stored_ref.resolve()
				if(istype(AM))
					atom_names += "\a [AM]"
			if(length(atom_names))
				. += "It has [english_list(atom_names)] loaded into its transport bay."
		else
			. += "Its cargo bay is empty."

/mob/living/silicon/robot/platform/update_braintype()
	braintype = BORG_BRAINTYPE_PLATFORM

/mob/living/silicon/robot/platform/init()
	. = ..()
	if(ispath(module, /obj/item/robot_module))
		module = new module(src)

/mob/living/silicon/robot/platform/module_reset()
	return FALSE

/mob/living/silicon/robot/platform/use_power()
	. = ..()

	if(stat != DEAD && cell)

		// TODO generalize solar occlusion to charge from the actual sun.
		var/turf/T = get_turf(src)
		var/new_recharge_state = T?.is_outdoors() || isspace(T)
		if(new_recharge_state != last_recharge_state)
			last_recharge_state = new_recharge_state
			if(last_recharge_state)
				to_chat(src, SPAN_NOTICE("<b>Your integrated solar panels begin recharging your battery.</b>"))
			else
				to_chat(src, SPAN_DANGER("Your integrated solar panels cease recharging your battery."))

		if(last_recharge_state)
			var/charge_amt = recharger_charge_amount * CELLRATE
			cell.give(charge_amt)
			used_power_this_tick -= (charge_amt)
			module.respawn_consumable(src, (charge_amt / 250)) // magic number copied from borg charger.

		if(recharging)

			var/obj/item/cell/recharging_atom = recharging.resolve()
			if(!istype(recharging_atom) || QDELETED(recharging_atom) || recharging_atom.loc != src)
				recharging = null
				return

			if(recharging_atom.percent() < 100)
				var/charge_amount = recharger_tick_cost * CELLRATE
				if(cell.check_charge(charge_amount * 1.5) && cell.checked_use(charge_amount)) // Don't kill ourselves recharging the battery.
					recharging_atom.give(charge_amount)
					used_power_this_tick += charge_amount

			if(!recharge_complete && recharging_atom.percent() >= 100)
				recharge_complete = TRUE
				visible_message("<b>\The [src]</b> beeps and flashes a green light above \his recharging port.")
