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
	anchored = 1 // It's fucking huge. You aren't moving it.

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
	damage_absorption = list("brute"=0.1,"fire"=0.8,"bullet"=0.1,"laser"=0.6,"energy"=0.7,"bomb"=0.7) //values show how much damage will pass through, not how much will be absorbed.
	max_temperature = 35000 //Just a bit better than the Durand.
	infra_luminosity = 3
	var/zoom = 0
	var/smoke = 5
	var/smoke_ready = 1
	var/smoke_cooldown = 100
	var/datum/effect/effect/system/smoke_spread/smoke_system = new
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

/obj/mecha/combat/gorilla/Initialize()
	..()
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
	src.smoke_system.set_up(3, 0, src)
	src.smoke_system.attach(src)
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
				src.pr_inertial_movement.start(list(src,direction))
		can_move = 0
		spawn(tmp_step_in) can_move = 1
		use_power(tmp_step_energy_drain)
		return 1
	return 0

/obj/mecha/combat/gorilla/verb/smoke()
	set category = "Exosuit Interface"
	set name = "Smoke"
	set src = usr.loc
	set popup_menu = 0
	if(usr!=src.occupant)
		return
	if(smoke_ready && smoke>0)
		src.smoke_system.start()
		smoke--
		smoke_ready = 0
		spawn(smoke_cooldown)
			smoke_ready = 1
	return

/obj/mecha/combat/gorilla/verb/zoom()
	set category = "Exosuit Interface"
	set name = "Zoom"
	set src = usr.loc
	set popup_menu = 0
	if(usr!=src.occupant)
		return
	if(src.occupant.client)
		src.zoom = !src.zoom
		src.log_message("Toggled zoom mode.")
		src.occupant_message("<font color='[src.zoom?"blue":"red"]'>Zoom mode [zoom?"en":"dis"]abled.</font>")
		if(zoom)
			src.occupant.set_viewsize(12)
			playsound(src.occupant, 'sound/mecha/imag_enh.ogg',50)
		else
			src.occupant.set_viewsize() // Reset to default
	return


/obj/mecha/combat/gorilla/go_out()
	if(src.occupant && src.occupant.client)
		src.occupant.client.view = world.view
		src.zoom = 0
	..()
	return


/obj/mecha/combat/gorilla/get_stats_part()
	var/output = ..()
	output += {"<b>Smoke:</b> [smoke]"}
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

/obj/mecha/combat/gorilla/Topic(href, href_list)
	..()
	if (href_list["smoke"])
		src.smoke()
	if (href_list["toggle_zoom"])
		src.zoom()
	return