/datum/technomancer/spell/reflect
	name = "Reflect"
	desc = "Emits a protective shield fron your hand in front of you, which will reflect one attack back at the attacker."
	cost = 120
	obj_path = /obj/item/weapon/spell/reflect

/obj/item/weapon/spell/reflect
	name = "\proper reflect shield"
	icon_state = "shield"
	desc = "A very protective combat shield that'll reflect the next attack at the unfortunate person who tried to shoot you."
	aspect = ASPECT_FORCE
	toggled = 1
	var/damage_to_energy_multiplier = 60.0 //Determines how much energy to charge for blocking, e.g. 20 damage attack = 1200 energy cost
	var/datum/effect/effect/system/spark_spread/spark_system = null

/obj/item/weapon/spell/reflect/New()
	..()
	set_light(3, 2, l_color = "#006AFF")
	spark_system = PoolOrNew(/datum/effect/effect/system/spark_spread)
	spark_system.set_up(5, 0, src)
	owner << "<span class='notice'>Your shield will expire in 20 seconds.</span>"
	spawn(20 SECONDS)
		if(src)
			owner << "<span class='danger'>Your shield expires!</span>"
			qdel(src)

/obj/item/weapon/spell/reflect/Destroy()
	spark_system = null
	..()

/obj/item/weapon/spell/reflect/handle_shield(mob/user, var/damage, atom/damage_source = null, mob/attacker = null, var/def_zone = null, var/attack_text = "the attack")
	if(user.incapacitated())
		return 0

	var/damage_to_energy_cost = (damage_to_energy_multiplier * damage)

	if(!pay_energy(damage_to_energy_cost))
		owner << "<span class='danger'>Your shield fades due to lack of energy!</span>"
		qdel(src)
		return 0

	//block as long as they are not directly behind us
	var/bad_arc = reverse_direction(user.dir) //arc of directions from which we cannot block
	if(check_shield_arc(user, bad_arc, damage_source, attacker))

		if(istype(damage_source, /obj/item/projectile))
			var/obj/item/projectile/P = damage_source

			if(P.starting)
				visible_message("<span class='danger'>\The [user]'s [src.name] reflects [attack_text]!</span>")

				var/turf/curloc = get_turf(user)

				// redirect the projectile
				P.redirect(P.starting.x, P.starting.y, curloc, user)

				spark_system.start()
				playsound(user.loc, 'sound/weapons/blade1.ogg', 50, 1)

				spawn(1 SECOND) //To ensure that most or all of a burst fire cycle is reflected.
					owner << "<span class='danger'>Your shield fades due being used up!</span>"
					qdel(src)

				return PROJECTILE_CONTINUE // complete projectile permutation


		return 1
	return 0

/*
/obj/item/clothing/suit/armor/laserproof/handle_shield(mob/user, var/damage, atom/damage_source = null, mob/attacker = null, var/def_zone = null, var/attack_text = "the attack")
	if(istype(damage_source, /obj/item/projectile/energy) || istype(damage_source, /obj/item/projectile/beam))
		var/obj/item/projectile/P = damage_source

		var/reflectchance = 40 - round(damage/3)
		if(!(def_zone in list(BP_TORSO, BP_GROIN)))
			reflectchance /= 2
		if(P.starting && prob(reflectchance))
			visible_message("<span class='danger'>\The [user]'s [src.name] reflects [attack_text]!</span>")

			// Find a turf near or on the original location to bounce to
			var/new_x = P.starting.x + pick(0, 0, 0, 0, 0, -1, 1, -2, 2)
			var/new_y = P.starting.y + pick(0, 0, 0, 0, 0, -1, 1, -2, 2)
			var/turf/curloc = get_turf(user)

			// redirect the projectile
			P.redirect(new_x, new_y, curloc, user)

			return PROJECTILE_CONTINUE // complete projectile permutation
*/
