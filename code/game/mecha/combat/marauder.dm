/obj/mecha/combat/marauder
	desc = "Heavy-duty, combat exosuit, developed after the Durand model. Rarely found among civilian populations."
	name = "Marauder"
	catalogue_data = list(/datum/category_item/catalogue/technology/marauder)
	icon_state = "marauder"
	initial_icon = "marauder"
	step_in = 5
	health = 350
	maxhealth = 350		//Don't forget to update the /old variant if  you change this number.
	deflect_chance = 25
	max_temperature = 60000
	infra_luminosity = 3
	operation_req_access = list(access_cent_specops)
	wreckage = /obj/effect/decal/mecha_wreckage/marauder
	add_req_access = 0
	internal_damage_threshold = 25
	force = 45
	max_equip = 4
	mech_faction = MECH_FACTION_NT

	max_hull_equip = 3
	max_weapon_equip = 3
	max_utility_equip = 3
	max_universal_equip = 1
	max_special_equip = 1

	smoke_possible = 1
	zoom_possible = 1
	thrusters_possible = 1

	starting_components = list(
		/obj/item/mecha_parts/component/hull/durable,
		/obj/item/mecha_parts/component/actuator,
		/obj/item/mecha_parts/component/armor/military,
		/obj/item/mecha_parts/component/gas,
		/obj/item/mecha_parts/component/electrical
		)

	starting_equipment = list(
		/obj/item/mecha_parts/mecha_equipment/weapon/energy/pulse,
		/obj/item/mecha_parts/mecha_equipment/weapon/ballistic/missile_rack/explosive,
		/obj/item/mecha_parts/mecha_equipment/tesla_energy_relay,
		/obj/item/mecha_parts/mecha_equipment/antiproj_armor_booster
		)

	icon_scale_x = 1.5
	icon_scale_y = 1.5

/obj/mecha/combat/marauder/seraph
	desc = "Heavy-duty, command-type exosuit. This is a custom model, utilized only by high-ranking military personnel."
	name = "Seraph"
	catalogue_data = list(/datum/category_item/catalogue/technology/seraph)
	icon_state = "seraph"
	initial_icon = "seraph"
	operation_req_access = list(access_cent_creed)
	step_in = 3
	health = 450
	wreckage = /obj/effect/decal/mecha_wreckage/seraph
	internal_damage_threshold = 20
	force = 55
	max_equip = 5

	starting_equipment = list(
		/obj/item/mecha_parts/mecha_equipment/weapon/ballistic/scattershot,
		/obj/item/mecha_parts/mecha_equipment/weapon/ballistic/missile_rack/explosive,
		/obj/item/mecha_parts/mecha_equipment/tesla_energy_relay,
		/obj/item/mecha_parts/mecha_equipment/antiproj_armor_booster,
		/obj/item/mecha_parts/mecha_equipment/teleporter
		)

//Note that is the Mauler
/obj/mecha/combat/marauder/mauler
	desc = "Heavy-duty, combat exosuit, developed off of the existing Marauder model."
	name = "Mauler"
	icon_state = "mauler"
	initial_icon = "mauler"
	operation_req_access = list(access_syndicate)
	wreckage = /obj/effect/decal/mecha_wreckage/mauler
	mech_faction = MECH_FACTION_SYNDI

//I'll break this down later
/obj/mecha/combat/marauder/relaymove(mob/user,direction)
	if(user != src.occupant) //While not "realistic", this piece is player friendly.
		user.loc = get_turf(src)
		to_chat(user, "You climb out from [src]")
		return 0
	if(!can_move)
		return 0
	if(zoom)
		if(world.time - last_message > 20)
			src.occupant_message("Unable to move while in zoom mode.")
			last_message = world.time
		return 0
	if(connected_port)
		if(world.time - last_message > 20)
			src.occupant_message("Unable to move while connected to the air system port")
			last_message = world.time
		return 0
	if(!thrusters && (current_processes & MECHA_PROC_MOVEMENT))
		return 0
	if(state || !has_charge(step_energy_drain))
		return 0
	var/tmp_step_in = step_in
	var/tmp_step_energy_drain = step_energy_drain
	var/move_result = 0
	if(internal_damage&MECHA_INT_CONTROL_LOST)
		move_result = mechsteprand()
	else if(src.dir!=direction)
		move_result = mechturn(direction)
	else
		move_result	= mechstep(direction)
	if(move_result)
		if(istype(src.loc, /turf/space))
			if(!src.check_for_support())
				float_direction = direction
				start_process(MECHA_PROC_MOVEMENT)
				if(thrusters)
					tmp_step_energy_drain = step_energy_drain*2

		can_move = 0
		spawn(tmp_step_in) can_move = 1
		use_power(tmp_step_energy_drain)
		return 1
	return 0

//To be kill ltr
/obj/mecha/combat/marauder/get_commands()
	var/output = {"<div class='wr'>
						<div class='header'>Special</div>
						<div class='links'>
						<a href='byond://?src=\ref[src];toggle_thrusters=1'>Toggle thrusters</a><br>
						<a href='byond://?src=\ref[src];toggle_zoom=1'>Toggle zoom mode</a><br>
						<a href='byond://?src=\ref[src];smoke=1'>Smoke</a>
						</div>
						</div>
						"}
	output += ..()
	return output

//Meant for random spawns.
/obj/mecha/combat/marauder/old
	desc = "Heavy-duty, combat exosuit, developed after the Durand model. Rarely found among civilian populations. This one is particularly worn looking and likely isn't as sturdy."

	starting_equipment = null

/obj/mecha/combat/marauder/old/New()
	..()
	health = 25
	maxhealth = 300	//Just slightly worse.
	cell.charge = rand(0, (cell.charge/2))
