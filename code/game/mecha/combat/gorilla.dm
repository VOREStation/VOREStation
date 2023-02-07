
/obj/mecha/combat/gorilla
	name = "Gorilla"
	desc = "<b>Blitzkrieg!</b>" //stop using all caps in item descs i will fight you. its redundant with the bold.
	icon = 'icons/mecha/mecha64x64.dmi'
	icon_state = "pzrmech"
	initial_icon = "pzrmech"
	pixel_x = -16
	step_in = 10
	health = 5000
	maxhealth = 5000
	opacity = 0 // Because there's big tall legs to look through. Also it looks fucky if this is set to 1.
	deflect_chance = 50
	max_temperature = 35000 //Just a bit better than the Durand.
	infra_luminosity = 3
	wreckage = /obj/effect/decal/mecha_wreckage/gorilla
	add_req_access = 0
	internal_damage_threshold = 25
	force = 60
	max_equip = 5
//This will (Should) never be in the hands of players. If it is, the one who inflicted this monster upon the server can edit these vars to not be insane.
	max_hull_equip = 5
	max_weapon_equip = 5
	max_utility_equip = 5
	max_universal_equip = 5
	max_special_equip = 2

	smoke_possible = 1
	zoom_possible = 1
	thrusters_possible = 1

/obj/mecha/combat/gorilla/Initialize()
	. = ..()
	var/obj/item/mecha_parts/mecha_equipment/ME = new /obj/item/mecha_parts/mecha_equipment/tesla_energy_relay(src) // This thing basically cannot function without an external power supply.
	ME.attach(src)
	ME = new /obj/item/mecha_parts/mecha_equipment/weapon/ballistic/cannon(src)
	ME.attach(src)
	ME = new /obj/item/mecha_parts/mecha_equipment/weapon/ballistic/cannon/weak(src) //Saves energy, I suppose. Anti-infantry.
	ME.attach(src)
	ME = new /obj/item/mecha_parts/mecha_equipment/weapon/ballistic/missile_rack/explosive(src)
	ME.attach(src)
	ME = new /obj/item/mecha_parts/mecha_equipment/weapon/ballistic/lmg(src)
	ME.attach(src)
	return

/obj/mecha/combat/gorilla/mechstep(direction)
	var/result = step(src,direction)
	playsound(src,"mechstep",40,1)
	return result

/obj/mecha/combat/gorilla/mechturn(direction)
	dir = direction
	playsound(src,"mechstep",40,1)


/obj/mecha/combat/gorilla/relaymove(mob/user,direction)
	if(user != src.occupant)
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
		can_move = 0
		spawn(tmp_step_in) can_move = 1
		use_power(tmp_step_energy_drain)
		return 1
	return 0


/obj/mecha/combat/gorilla/get_stats_part()
	var/output = ..()
	output += {"<b>Smoke:</b> [smoke_reserve]"}
	return output


/obj/mecha/combat/gorilla/get_commands()
	var/output = {"<div class='wr'>
						<div class='header'>Special</div>
						<div class='links'>
						<a href='?src=\ref[src];toggle_zoom=1'>Toggle zoom mode</a><br>
						<a href='?src=\ref[src];smoke=1'>Smoke</a>
						</div>
						</div>
						"}
	output += ..()
	return output

/obj/item/mecha_parts/mecha_equipment/weapon/ballistic/cannon
	name = "8.8cm KwK 47"
	desc = "<i>Precision German engineering!</i>" // Why would you ever take this off the mech, anyway?
	icon_state = "mecha_uac2"
	equip_cooldown = 60 // 6 seconds
	projectile = /obj/item/projectile/bullet/cannon
	fire_sound = 'sound/weapons/Gunshot_cannon.ogg'
	projectiles = 1
	projectile_energy_cost = 1000
	salvageable = 0 // We don't want players ripping this off a dead mech. Could potentially be a prize for beating it if Devs bless me and someone offers a nerf idea.

/obj/item/projectile/bullet/cannon
	name ="armor-piercing shell"
	icon = 'icons/obj/projectiles.dmi'
	icon_state = "shell"
	damage = 1000 // In order to 1-hit any other mech and royally fuck anyone unfortunate enough to get in the way.

/obj/item/projectile/bullet/cannon/on_hit(var/atom/target, var/blocked = 0)
	explosion(target, 0, 0, 2, 4)
	return 1

/obj/item/mecha_parts/mecha_equipment/weapon/ballistic/cannon/weak
	name = "8.8 cm KwK 36"
	equip_cooldown = 120 // 12 seconds.
	projectile = /obj/item/projectile/bullet/cannon/weak
	projectile_energy_cost = 400
	salvageable = 1

/obj/item/projectile/bullet/cannon/weak
	name ="canister shell"
	icon_state = "canister"
	damage = 120 //Do not get fucking shot.

/* // GLITCHY UND LAGGY. Will later look into fixing.
/obj/item/mecha_parts/mecha_equipment/weapon/ballistic/mg42
	name = "Maschinengewehr 60"
	icon_state = "mecha_uac2"
	equip_cooldown = 10
	projectile = /obj/item/projectile/bullet/midbullet2
	fire_sound = 'sound/weapons/mg42.ogg'
	projectiles = 1000
	projectiles_per_shot = 5
	deviation = 0.3
	projectile_energy_cost = 20
	fire_cooldown = 1
	salvageable = 0 // We don't want players ripping this off a dead mech.
*/

/obj/effect/decal/mecha_wreckage/gorilla
	name = "Gorilla wreckage"
	desc = "... Blitzkrieg?"
	icon = 'icons/mecha/mecha64x64.dmi'
	icon_state = "pzrwreck"
	plane = MOB_PLANE
	pixel_x = -16
	anchored = TRUE // It's fucking huge. You aren't moving it.
