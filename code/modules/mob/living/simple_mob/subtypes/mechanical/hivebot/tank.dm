// These hivebots are harder to kill than normal, and are meant to protect their squad by
// distracting their enemies. This is done by being seen as very threatening.
// Their melee attacks weaken whatever they hit.

/mob/living/simple_mob/mechanical/hivebot/tank
	attacktext = list("prodded")
	projectiletype = null // To force the AI to melee.
	movement_cooldown = 3
	melee_damage_lower = 3
	melee_damage_upper = 3
	attack_sound = 'sound/weapons/Egloves.ogg'
	organ_names = /decl/mob_organ_names/hivebottank


// All tank hivebots apply a modifier to their target, and force them to attack them if they're AI controlled.
/mob/living/simple_mob/mechanical/hivebot/tank/apply_melee_effects(atom/A)
	if(isliving(A))
		var/mob/living/L = A
		L.taunt(src, TRUE)
		L.add_modifier(/datum/modifier/hivebot_weaken, 3 SECONDS)

// Modifier applied to whatever a tank hivebot hits, intended to make the target do even less damage.
/datum/modifier/hivebot_weaken
	name = "Shocked"
	desc = "You feel less able to exert yourself after being prodded."
	on_created_text = span_warning("You feel weak...")
	on_expired_text = span_notice("You feel better.")
	stacks = MODIFIER_STACK_EXTEND
	mob_overlay_state = "electricity"

	attack_speed_percent = 0.6
	outgoing_melee_damage_percent = 0.7
	accuracy = -40
	accuracy_dispersion = 1
	slowdown = 1
	evasion = -20

// This one is tanky by having a massive amount of health.
/mob/living/simple_mob/mechanical/hivebot/tank/meatshield
	name = "bulky hivebot"
	desc = "A large robot."
	maxHealth = 10 LASERS_TO_KILL // 300 health
	health = 10 LASERS_TO_KILL
	icon_scale_x = 2
	icon_scale_y = 2
	player_msg = "You have a very large amount of health."


// This one is tanky by having armor.
/mob/living/simple_mob/mechanical/hivebot/tank/armored
	name = "armored hivebot"
	desc = "A robot clad in heavy armor."
	maxHealth = 5 LASERS_TO_KILL // 150 health.
	health = 5 LASERS_TO_KILL
	icon_scale_x = 1.5
	icon_scale_y = 1.5
	player_msg = "You are heavily armored."
	// Note that armor effectively makes lasers do about 9 damage instead of 30,
	// so it has an effective health of ~16.6 LASERS_TO_KILL if regular lasers are used.
	// Xrays will do much better against this.
	armor = list(
				"melee"		= 40,
				"bullet"	= 40,
				"laser"		= 40,
				"energy"	= 30,
				"bomb"		= 30,
				"bio"		= 100,
				"rad"		= 100
				)
	armor_soak = list(
				"melee"		= 15,
				"bullet"	= 10,
				"laser"		= 15,
				"energy"	= 0,
				"bomb"		= 0,
				"bio"		= 0,
				"rad"		= 0
				)

/mob/living/simple_mob/mechanical/hivebot/tank/armored/anti_melee
	name = "riot hivebot"
	desc = "A robot specialized in close quarters combat."
	player_msg = "You are heavily armored against close quarters combat."
	armor = list(
				"melee"		= 70,
				"bullet"	= 0,
				"laser"		= 0,
				"energy"	= 0,
				"bomb"		= 0,
				"bio"		= 100,
				"rad"		= 100
				)
	armor_soak = list(
				"melee"		= 20,
				"bullet"	= 0,
				"laser"		= 0,
				"energy"	= 0,
				"bomb"		= 0,
				"bio"		= 0,
				"rad"		= 0
				)

/mob/living/simple_mob/mechanical/hivebot/tank/armored/anti_bullet
	name = "bulletproof hivebot"
	desc = "A robot specialized in ballistic defense."
	player_msg = "You are heavily armored against ballistic weapons."
	armor = list(
				"melee"		= 0,
				"bullet"	= 70,
				"laser"		= 0,
				"energy"	= 0,
				"bomb"		= 0,
				"bio"		= 100,
				"rad"		= 100
				)
	armor_soak = list(
				"melee"		= 0,
				"bullet"	= 20,
				"laser"		= 0,
				"energy"	= 0,
				"bomb"		= 0,
				"bio"		= 0,
				"rad"		= 0
				)

/mob/living/simple_mob/mechanical/hivebot/tank/armored/anti_laser
	name = "ablative hivebot"
	desc = "A robot specialized in photonic defense."
	player_msg = "You are heavily armored against laser weapons."
	armor = list(
				"melee"		= 0,
				"bullet"	= 0,
				"laser"		= 70,
				"energy"	= 0,
				"bomb"		= 0,
				"bio"		= 100,
				"rad"		= 100
				)
	armor_soak = list(
				"melee"		= 0,
				"bullet"	= 0,
				"laser"		= 20,
				"energy"	= 0,
				"bomb"		= 0,
				"bio"		= 0,
				"rad"		= 0
				)
	var/reflect_chance = 40 // Same as regular ablative.

// Ablative Hivebots can reflect lasers just like humans.
/mob/living/simple_mob/mechanical/hivebot/tank/armored/anti_laser/bullet_act(obj/item/projectile/P)
	if(istype(P, /obj/item/projectile/energy) || istype(P, /obj/item/projectile/beam))
		var/reflect_prob = reflect_chance - round(P.damage/3)
		if(prob(reflect_prob))
			visible_message(span_danger("The [P.name] gets reflected by [src]'s armor!"), \
							span_userdanger("The [P.name] gets reflected by [src]'s armor!"))

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

/decl/mob_organ_names/hivebottank
	hit_zones = list("central chassis", "armor plating", "component shielding", "positioning servo", "head", "sensor suite", "heavy manipulator arm", "shoulder weapon mount", "weapons array", "front right leg", "front left leg", "rear left leg", "rear right leg")
