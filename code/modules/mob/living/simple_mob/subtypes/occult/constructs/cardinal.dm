////////////////////////////
//	Purity Construct - Cardinal
////////////////////////////

/mob/living/simple_mob/construct/cardinal
	name = "Cardinal"
	real_name = "Cardinal"
	construct_type = "Cardinal"
	faction = "purity"
	desc = "A large sized construct of the purity worshippers mechanical followers, one of their most advanced, it is the left hand of purification, tasked with the ultimate protection and ultimately defense of all under its charge, it will stop at nothing to protect its flock from harm."
	icon_state = "cardinal"
	icon_living = "cardinal"
	ui_icons = 'icons/mob/screen1_purity.dmi'
	maxHealth = 300
	health = 300
	response_harm = "harmlessly punches"
	harm_intent_damage = 0
	melee_damage_lower = 20
	melee_damage_upper = 30
	attack_armor_pen = 50 //fist of iron and stone will smash through most things
	attacktext = list("smashed their armoured gauntlet into")
	friendly = list("pats")
	organ_names = /decl/mob_organ_names/juggernaut
	mob_size = MOB_HUGE
	attack_sound = 'sound/weapons/heavysmash.ogg'
	status_flags = 0
	resistance = 10
	construct_spells = list(/spell/targeted/fortify,
							/spell/targeted/construct_advanced/slam,
							/spell/targeted/construct_advanced/mend_purity,
							/spell/targeted/purity_repair_aura
							)

	ai_holder_type = /datum/ai_holder/simple_mob/retaliate/cooperative

	armor = list(
				"melee" = 70,
				"bullet" = 30,
				"laser" = 30,
				"energy" = 30,
				"bomb" = 10,
				"bio" = 100,
				"rad" = 100)

/mob/living/simple_mob/construct/cardinal/Life()
	SetWeakened(0)
	..()

/mob/living/simple_mob/construct/cardinal/bullet_act(var/obj/item/projectile/P)
	var/reflectchance = 100 - round(P.damage)
	if(prob(reflectchance))
		var/damage_mod = rand(2,4)
		var/projectile_dam_type = P.damage_type
		var/incoming_damage = (round(P.damage / damage_mod) - (round((P.damage / damage_mod) * 0.3)))
		var/armorcheck = run_armor_check(null, P.check_armour)
		var/soakedcheck = get_armor_soak(null, P.check_armour)
		if(!(istype(P, /obj/item/projectile/energy) || istype(P, /obj/item/projectile/beam)))
			visible_message(span_danger("The [P.name] bounces off of [src]'s shell!"), \
						span_userdanger("The [P.name] bounces off of [src]'s shell!"))
			new /obj/item/material/shard/shrapnel(src.loc)
			if(!(P.damage_type == BRUTE || P.damage_type == BURN))
				projectile_dam_type = BRUTE
				incoming_damage = round(incoming_damage / 4) //Damage from strange sources is converted to brute for physical projectiles, though severely decreased.
			apply_damage(incoming_damage, projectile_dam_type, null, armorcheck, soakedcheck, is_sharp(P), has_edge(P), P)
			return -1 //Doesn't reflect non-beams or non-energy projectiles. They just smack and drop with little to no effect.
		else
			visible_message(span_danger("The [P.name] gets reflected by [src]'s shell!"), \
						span_userdanger("The [P.name] gets reflected by [src]'s shell!"))
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

/decl/mob_organ_names/juggernaut
	hit_zones = list("body", "left pauldron", "right pauldron", "left arm", "right arm", "eye", "head", "crystaline spike")
