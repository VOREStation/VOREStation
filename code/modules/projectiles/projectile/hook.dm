/*
 * File containing special 'hook' projectiles. Function is dictated by the launcher's intent.
 */

/obj/item/projectile/energy/hook
	name = "graviton sphere"
	icon_state = "bluespace"

	var/beam_state = "b_beam"

	damage = 5
	speed = 2
	damage_type = BURN
	check_armour = "energy"
	armor_penetration = 15

	var/impact_sound = 'sound/effects/uncloak.ogg'
	var/crack_sound = 'sound/effects/teleport.ogg'
	fire_sound = 'sound/effects/zzzt.ogg'

	var/target_distance = null	// Shamelessly stolen from arcing projectiles.
	var/my_tracking_beam = null	// Beam made by the launcher. Tracked here to destroy it in time with the impact.
	var/launcher_intent = null	// Stores the launcher's intent.

	var/disarm_chance = 60		// Chance for a successful disarm hit. The inverse is a throw away from the firer.

	var/list/help_messages = list("slaps", "pokes", "nudges", "bumps", "pinches")
	var/done_mob_unique = FALSE	// Has the projectile already done something to a mob?

/obj/item/projectile/energy/hook/launch_projectile(atom/target, target_zone, mob/user, params, angle_override, forced_spread = 0)
	var/expected_distance = get_dist(target, loc)
	range = expected_distance // So the hook hits the ground if no mob is hit.
	target_distance = expected_distance
	if(firer)	// Needed to ensure later checks in impact and on hit function.
		launcher_intent = firer.a_intent
		firer.Beam(src,icon_state=beam_state,icon='icons/effects/beam.dmi',time=60, maxdistance=10,beam_type=/obj/effect/ebeam,beam_sleep_time=1)

	if(launcher_intent)
		switch(launcher_intent)
			if(I_HURT)
				check_armour = "bullet"
				damage *= 3
				sharp = 1
				agony = 20
			if(I_GRAB)
				check_armour = "melee"
				damage_type = HALLOSS
			if(I_DISARM)
				check_armour = "melee"
				if(prob(30))	// A chance for a successful hit to either knock someone down, or cause minor disorientation.
					weaken = 1
				else
					stun = 2
					eyeblur = 3
			if(I_HELP)
				silenced = 1
				damage_type = HALLOSS

	..() // Does the regular launching stuff.

/obj/item/projectile/energy/hook/on_hit(var/atom/target, var/blocked = 0, var/def_zone = null)
	if(..())
		perform_intent_unique(target)

/obj/item/projectile/energy/hook/on_impact(var/atom/A)
	perform_intent_unique(get_turf(A))

/obj/item/projectile/energy/hook/proc/ranged_disarm(var/mob/living/carbon/human/H)
	if(istype(H))
		var/list/holding = list(H.get_active_hand() = 60, H.get_inactive_hand() = 40)

		for(var/obj/item/weapon/gun/W in holding)	// Guns are complex devices, both of a mechanical and electronic nature. A weird gravity ball or other type of object trying to pull or grab it is likely not safe.
			if(W && prob(holding[W]))
				var/list/turfs = list()
				for(var/turf/T in view())
					turfs += T
				if(turfs.len)
					var/turf/target = pick(turfs)
					visible_message("<span class='danger'>[H]'s [W] goes off due to \the [src]!</span>")
					return W.afterattack(target,H)

		if(!(H.species.flags & NO_SLIP) && prob(50))
			var/armor_check = H.run_armor_check(def_zone, "melee")
			H.apply_effect(3, WEAKEN, armor_check)
			playsound(loc, 'sound/weapons/thudswoosh.ogg', 50, 1, -1)
			if(armor_check < 60)
				visible_message("<span class='danger'>\The [src] has pushed [H]!</span>")
			else
				visible_message("<span class='warning'>\The [src] attempted to push [H]!</span>")
			return

		else
			if(H.break_all_grabs(firer))
				playsound(loc, 'sound/weapons/thudswoosh.ogg', 50, 1, -1)
				return

			for(var/obj/item/I in holding)
				if(I)
					H.drop_from_inventory(I)
					visible_message("<span class='danger'>\The [src] has disarmed [H]!</span>")
					playsound(loc, 'sound/weapons/thudswoosh.ogg', 50, 1, -1)
					return


/obj/item/projectile/energy/hook/proc/perform_intent_unique(atom/target)
	playsound(src.loc, impact_sound, 40, 1)
	var/success = FALSE
	if(istype(target,/turf))
		if(launcher_intent)
			if(launcher_intent != I_HELP && !done_mob_unique)
				var/target_mob = pick(/mob/living in target.contents)

				if(!target_mob)
					return

				if(Bump(target_mob, forced=1))	//If we hit a turf, try to force an interaction with a mob on the turf.
					done_mob_unique = TRUE
				success = TRUE
			else if(firer)
				var/obj/T

				if(original in target.contents && istype(original, /obj))
					T = original

				var/list/possible_targets = list()
				for(var/obj/item/I in target.contents)
					if(!I.anchored)
						possible_targets += I
				for(var/obj/structure/S in target.contents)
					if(!S.anchored)
						possible_targets += S

				if(!T)
					if(!possible_targets || !possible_targets.len)
						return
					T = pick(possible_targets)

				spawn(2)
					playsound(target, crack_sound, 40, 1)
				visible_message("<span class='notice'>\The [T] is snatched by \the [src]!</span>")
				T.throw_at(get_turf(firer), 7, 1, src)
				success = TRUE
	else if(isliving(target) && !done_mob_unique)
		var/mob/living/L = target
		if(launcher_intent)
			switch(launcher_intent)
				if(I_HELP)
					var/message = pick(help_messages)
					if(message == "slaps")
						spawn(1)
							playsound(loc, 'sound/effects/snap.ogg', 50, 1)
					visible_message("<span class='notice'>\The [src] [message] [target].</span>")
					done_mob_unique = TRUE
					success = TRUE
				if(I_HURT)
					if(prob(10) && istype(L, /mob/living/carbon/human))
						to_chat(L, "<span class='warning'>\The [src] rips at your hands!</span>")
						ranged_disarm(L)
					success = TRUE
					done_mob_unique = TRUE
				if(I_DISARM)
					if(prob(disarm_chance) && istype(L, /mob/living/carbon/human))
						ranged_disarm(L)
					else
						L.visible_message("<span class='danger'>\The [src] sends \the [L] stumbling backwards.</span>")
						L.throw_at(get_turf(get_step(L,get_dir(firer,L))), 1, 1, src)
					done_mob_unique = TRUE
					success = TRUE
				if(I_GRAB)
					var/turf/STurf = get_turf(L)
					spawn(2)
						playsound(STurf, crack_sound, 60, 1)
					L.visible_message("<span class='critical'>\The [src] rips [L] towards \the [firer]!</span>")
					L.throw_at(get_turf(get_step(firer,get_dir(firer,L))), 6, 1, src)
					done_mob_unique = TRUE
					success = TRUE
	else if(istype(target, /obj/structure))
		var/obj/structure/S = target
		if(!S.anchored)
			S.throw_at(get_turf(get_step(firer,get_dir(firer,S))), 4, 1, src)
			success = TRUE
	qdel(my_tracking_beam)
	return success

/*
 * Hook subtypes.
 */

/obj/item/projectile/energy/hook/ring
	name = "green orb"
	icon_state = "green_laser"
	beam_state = "n_beam"
	damage = 3
