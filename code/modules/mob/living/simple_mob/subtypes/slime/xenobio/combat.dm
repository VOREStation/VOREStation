// Code for slimes attacking other things.

// Slime attacks change based on intent.
/mob/living/simple_mob/slime/xenobio/apply_attack(mob/living/L, damage_to_do)
	if(istype(L))
		switch(a_intent)
			if(I_HELP) // This shouldn't happen but just in case.
				return FALSE

			if(I_DISARM)
				var/stun_power = between(0, power_charge + rand(0, 3), 10)

				if(ishuman(L))
					var/mob/living/carbon/human/H = L
					stun_power *= max(H.species.siemens_coefficient, 0)

				if(prob(stun_power * 10)) // Try an electric shock.
					power_charge = max(0, power_charge - 3)
					L.visible_message(
						span_danger("\The [src] has shocked \the [L]!"),
						span_danger("\The [src] has shocked you!")
						)
					playsound(src, 'sound/weapons/Egloves.ogg', 75, 1)
					L.Weaken(4)
					L.Stun(4)
					do_attack_animation(L)
					if(L.buckled)
						L.buckled.unbuckle_mob() // To prevent an exploit where being buckled prevents slimes from jumping on you.
					L.stuttering = max(L.stuttering, stun_power)

					var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
					s.set_up(5, 1, L)
					s.start()

					if(prob(stun_power * 10) && stun_power >= 8)
						L.adjustFireLoss(power_charge * rand(1, 2))
					return FALSE

				else if(prob(20)) // Try to do a regular disarm attack.
					L.visible_message(
						span_danger("\The [src] has pounced at \the [L]!"),
						span_danger("\The [src] has pounced at you!")
						)
					playsound(src, 'sound/weapons/thudswoosh.ogg', 75, 1)
					L.Weaken(2)
					do_attack_animation(L)
					if(L.buckled)
						L.buckled.unbuckle_mob() // To prevent an exploit where being buckled prevents slimes from jumping on you.
					return FALSE

				else // Failed to do anything this time.
					L.visible_message(
						span_warning("\The [src] has tried to pounce at \the [L]!"),
						span_warning("\The [src] has tried to pounce at you!")
						)
					playsound(src, 'sound/weapons/punchmiss.ogg', 75, 1)
					do_attack_animation(L)
					return FALSE

			if(I_GRAB)
				start_consuming(L)
				return FALSE

			if(I_HURT)
				return ..() // Regular stuff.
	else
		return ..() // Do the regular stuff if we're hitting a window/mech/etc.

/mob/living/simple_mob/slime/xenobio/apply_melee_effects(mob/living/L)
	if(istype(L) && a_intent == I_HURT)
		// Pump them full of toxins, if able.
		if(L.reagents && L.can_inject() && reagent_injected)
			L.reagents.add_reagent(reagent_injected, injection_amount)

		// Feed off of their flesh, if able.
		consume(L, 5)


/mob/living/simple_mob/slime/xenobio/AltClickOn(atom/movable/A)
	if(isliving(A) && Adjacent(A))
		animal_nom(A)
	else
		..()
