////////////////////////////
//		Juggernaut
////////////////////////////

/mob/living/simple_mob/construct/juggernaut
	name = "Juggernaut"
	real_name = "Juggernaut"
	construct_type = "juggernaut"
	desc = "A possessed suit of armour driven by the will of the restless dead."
	icon = 'icons/mob/mob.dmi'
	icon_state = "behemoth"
	icon_living = "behemoth"
	maxHealth = 300
	health = 300
	response_harm   = "harmlessly punches"
	harm_intent_damage = 0
	melee_damage_lower = 30
	melee_damage_upper = 40
	attack_armor_pen = 60 //Being punched by a living, floating statue.
	attacktext = list("smashed their armoured gauntlet into")
	friendly = list("pats")
	organ_names = /decl/mob_organ_names/juggernaut
	mob_size = MOB_HUGE


	movement_cooldown = 6 //Not super fast, but it might catch up to someone in armor who got punched once or twice.

//	environment_smash = 2	// Whatever this gets renamed to, Juggernauts need to break things


	attack_sound = 'sound/weapons/heavysmash.ogg'
	status_flags = 0
	resistance = 10
	construct_spells = list(/spell/aoe_turf/conjure/forcewall/lesser,
							/spell/targeted/fortify,
							/spell/targeted/construct_advanced/slam
							)

	armor = list(
				"melee" = 70,
				"bullet" = 30,
				"laser" = 30,
				"energy" = 30,
				"bomb" = 10,
				"bio" = 100,
				"rad" = 100)

/mob/living/simple_mob/construct/juggernaut/Life()
	SetWeakened(0)
	..()

/mob/living/simple_mob/construct/juggernaut/bullet_act(var/obj/item/projectile/P)
	var/reflectchance = 80 - round(P.damage/3)
	if(prob(reflectchance))
		var/damage_mod = rand(2,4)
		var/projectile_dam_type = P.damage_type
		var/incoming_damage = (round(P.damage / damage_mod) - (round((P.damage / damage_mod) * 0.3)))
		var/armorcheck = run_armor_check(null, P.check_armour)
		var/soakedcheck = get_armor_soak(null, P.check_armour)
		if(!(istype(P, /obj/item/projectile/energy) || istype(P, /obj/item/projectile/beam)))
			visible_message("<span class='danger'>The [P.name] bounces off of [src]'s shell!</span>", \
						"<span class='userdanger'>The [P.name] bounces off of [src]'s shell!</span>")
			new /obj/item/weapon/material/shard/shrapnel(src.loc)
			if(!(P.damage_type == BRUTE || P.damage_type == BURN))
				projectile_dam_type = BRUTE
				incoming_damage = round(incoming_damage / 4) //Damage from strange sources is converted to brute for physical projectiles, though severely decreased.
			apply_damage(incoming_damage, projectile_dam_type, null, armorcheck, soakedcheck, is_sharp(P), has_edge(P), P)
			return -1 //Doesn't reflect non-beams or non-energy projectiles. They just smack and drop with little to no effect.
		else
			visible_message("<span class='danger'>The [P.name] gets reflected by [src]'s shell!</span>", \
						"<span class='userdanger'>The [P.name] gets reflected by [src]'s shell!</span>")
			damage_mod = rand(3,5)
			incoming_damage = (round(P.damage / damage_mod) - (round((P.damage / damage_mod) * 0.3)))
			if(!(P.damage_type == BRUTE || P.damage_type == BURN))
				projectile_dam_type = BURN
				incoming_damage = round(incoming_damage / 4) //Damage from strange sources is converted to burn for energy-type projectiles, though severely decreased.
			apply_damage(incoming_damage, P.damage_type, null, armorcheck, soakedcheck, is_sharp(P), has_edge(P), P)

		// Find a turf near or on the original location to bounce to
		if(P.starting)
			var/new_x = P.starting.x + pick(0, 0, -1, 1, -2, 2, -2, 2, -2, 2, -3, 3, -3, 3)
			var/new_y = P.starting.y + pick(0, 0, -1, 1, -2, 2, -2, 2, -2, 2, -3, 3, -3, 3)
			var/turf/curloc = get_turf(src)

			// redirect the projectile
			P.redirect(new_x, new_y, curloc, src)
			P.reflected = 1

		return -1 // complete projectile permutation

	return (..(P))

/*
 * The Behemoth. Admin-allowance only, still try to keep it in some guideline of 'Balanced', even if it means Security has to be fully geared to be so.
 */

/mob/living/simple_mob/construct/juggernaut/behemoth
	name = "Behemoth"
	real_name = "Behemoth"
	desc = "The pinnacle of occult technology, Behemoths are nothing shy of both an Immovable Object, and Unstoppable Force."
	maxHealth = 750
	health = 750
	speak_emote = list("rumbles")
	melee_damage_lower = 50
	melee_damage_upper = 50
	attacktext = list("brutally crushed")
	friendly = list("pokes") //Anything nice the Behemoth would do would still Kill the Human. Leave it at poke.
	attack_sound = 'sound/weapons/heavysmash.ogg'
	resistance = 10
	icon_scale_x = 2
	icon_scale_y = 2
	var/energy = 0
	var/max_energy = 1000
	armor = list(
				"melee" = 60,
				"bullet" = 60,
				"laser" = 60,
				"energy" = 30,
				"bomb" = 10,
				"bio" = 100,
				"rad" = 100)
	construct_spells = list(/spell/aoe_turf/conjure/forcewall/lesser,
							/spell/targeted/fortify,
							/spell/targeted/construct_advanced/slam
							)

/mob/living/simple_mob/construct/juggernaut/behemoth/bullet_act(var/obj/item/projectile/P)
	var/reflectchance = 80 - round(P.damage/3)
	if(prob(reflectchance))
		visible_message("<span class='danger'>The [P.name] gets reflected by [src]'s shell!</span>", \
						"<span class='userdanger'>The [P.name] gets reflected by [src]'s shell!</span>")

		// Find a turf near or on the original location to bounce to
		if(P.starting)
			var/new_x = P.starting.x + pick(0, 0, -1, 1, -2, 2, -2, 2, -2, 2, -3, 3, -3, 3)
			var/new_y = P.starting.y + pick(0, 0, -1, 1, -2, 2, -2, 2, -2, 2, -3, 3, -3, 3)
			var/turf/curloc = get_turf(src)

			// redirect the projectile
			P.redirect(new_x, new_y, curloc, src)
			P.reflected = 1

		return -1 // complete projectile permutation

	return (..(P))

/decl/mob_organ_names/juggernaut
	hit_zones = list("body", "left pauldron", "right pauldron", "left arm", "right arm", "eye", "head", "crystaline spike")
