/obj/item/mecha_parts/mecha_equipment/weapon
	name = "mecha weapon"
	range = RANGED
	origin_tech = list(TECH_MATERIAL = 3, TECH_COMBAT = 3)
	matter = list(MAT_STEEL = 6000, MAT_GLASS = 3000)
	var/projectile //Type of projectile fired.
	var/projectiles = 1 //Amount of projectiles loaded.
	var/projectiles_per_shot = 1 //Amount of projectiles fired per single shot.
	var/deviation = 0 //Inaccuracy of shots.
	var/fire_cooldown = 0 //Duration of sleep between firing projectiles in single shot.
	var/fire_sound //Sound played while firing.
	var/fire_volume = 50 //How loud it is played.
	var/auto_rearm = 0 //Does the weapon reload itself after each shot?
	required_type = list(/obj/mecha/combat, /obj/mecha/working/hoverpod/combatpod)

	step_delay = 0.1

	equip_type = EQUIP_WEAPON

/obj/item/mecha_parts/mecha_equipment/weapon/action_checks(atom/target)
	if(projectiles <= 0)
		return 0
	return ..()

/obj/item/mecha_parts/mecha_equipment/weapon/action(atom/target, params)
	if(!action_checks(target))
		return
	var/turf/curloc = chassis.loc
	var/turf/targloc = get_turf(target)
	if(!curloc || !targloc)
		return
	chassis.use_power(energy_drain)
	chassis.visible_message("<span class='warning'>[chassis] fires [src]!</span>")
	occupant_message("<span class='warning'>You fire [src]!</span>")
	log_message("Fired from [src], targeting [target].")
	var/target_for_log = "unknown"
	if(ismob(target))
		target_for_log = target
	else if(target)
		target_for_log = "[target.name]"
	add_attack_logs(chassis.occupant,target_for_log,"Fired exosuit weapon [src.name] (MANUAL)")

	for(var/i = 1 to min(projectiles, projectiles_per_shot))
		var/turf/aimloc = targloc
		if(deviation)
			aimloc = locate(targloc.x+GaussRandRound(deviation,1),targloc.y+GaussRandRound(deviation,1),targloc.z)
		if(!aimloc || aimloc == curloc || (locs && (aimloc in locs)))
			break
		playsound(src, fire_sound, fire_volume, 1)
		projectiles--
		var/turf/projectile_turf
		if(chassis.locs && chassis.locs.len)	// Multi tile.
			for(var/turf/Tloc in chassis.locs)
				if(get_dist(Tloc, aimloc) < get_dist(loc, aimloc))
					projectile_turf = get_turf(Tloc)
		if(!projectile_turf)
			projectile_turf = get_turf(curloc)
		var/P = new projectile(projectile_turf)
		Fire(P, target, params)
		if(i == 1)
			set_ready_state(FALSE)
		if(fire_cooldown)
			sleep(fire_cooldown)
	if(auto_rearm)
		projectiles = projectiles_per_shot
//	set_ready_state(FALSE)

	do_after_cooldown()

	return

/obj/item/mecha_parts/mecha_equipment/weapon/proc/Fire(atom/A, atom/target, params)
	if(istype(A, /obj/item/projectile))	// Sanity.
		var/obj/item/projectile/P = A
		P.dispersion = deviation
		process_accuracy(P, chassis.occupant, target)
		P.launch_projectile_from_turf(target, chassis.get_pilot_zone_sel(), chassis.occupant, params)
	else if(istype(A, /atom/movable))
		var/atom/movable/AM = A
		AM.throw_at(target, 7, 1, chassis, 16)

/obj/item/mecha_parts/mecha_equipment/weapon/proc/process_accuracy(obj/projectile, mob/living/user, atom/target)
	var/obj/item/projectile/P = projectile
	if(!istype(P))
		return

	P.accuracy -= user.get_accuracy_penalty()

	// Some modifiers make it harder or easier to hit things.
	for(var/datum/modifier/M in user.modifiers)
		if(!isnull(M.accuracy))
			P.accuracy += M.accuracy
		if(!isnull(M.accuracy_dispersion))
			P.dispersion = max(P.dispersion + M.accuracy_dispersion, 0)
<<<<<<< HEAD

	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(H.species)
			P.accuracy += H.species.gun_accuracy_mod
			P.dispersion = max(P.dispersion + H.species.gun_accuracy_dispersion_mod, 0)
=======
>>>>>>> 7b018e32811... Upkeep on Mech & Cliff code. (#8946)
