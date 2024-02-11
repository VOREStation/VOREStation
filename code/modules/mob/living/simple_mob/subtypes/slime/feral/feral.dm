// These slimes lack certain xenobio features but get more combat-oriented goodies. Generally these are more oriented towards Explorers than Xenobiologists.

/mob/living/simple_mob/slime/feral
	name = "feral slime"
	desc = "The result of slimes escaping containment from some xenobiology lab. \
	Having the means to successfully escape their lab, as well as having to survive on a harsh, cold world has made these \
	creatures rival the ferocity of other apex predators in this region of Sif. It is considered to be a very invasive species."
	description_info = "Note that processing this large slime will give six cores."

	cores = 6 // Xenobio will love getting their hands on these.

	icon_state = "slime adult"
	icon_living = "slime adult"
	icon_dead = "slime adult dead"
	glow_range = 5
	glow_intensity = 4
	icon_scale_x = 2 // Twice as big as the xenobio variant.
	icon_scale_y = 2
	pixel_y = -10 // Since the base sprite isn't centered properly, the pixel auto-adjustment needs some help.
	default_pixel_y = -10 // To prevent resetting above var.

	maxHealth = 300
	movement_cooldown = -3
	melee_attack_delay = 0.5 SECONDS

	ai_holder_type = /datum/ai_holder/simple_mob/ranged/pointblank


// Slimebatoning/xenotasing it just makes it mad at you (which can be good if you're heavily armored and your friends aren't).
/mob/living/simple_mob/slime/feral/slimebatoned(mob/living/user, amount)
	taunt(user, TRUE)


// ***********
// *Dark Blue*
// ***********

// Dark Blue feral slimes can fire a strong icicle projectile every few seconds. The icicle hits hard and has some armor penetration.
// They also have a similar aura as their xenobio counterparts, which inflicts cold damage. It also chills non-resistant mobs.

/mob/living/simple_mob/slime/feral/dark_blue
	name = "dark blue feral slime"
	color = "#2398FF"
	glow_toggle = TRUE
	slime_color = "dark blue"
	coretype = /obj/item/slime_extract/dark_blue
	cold_resist = 1 // Complete immunity.
	minbodytemp = 0
	cold_damage_per_tick = 0

	projectiletype = /obj/item/projectile/icicle
	base_attack_cooldown = 2 SECONDS
	ranged_attack_delay = 1 SECOND

	player_msg = "You can fire an icicle projectile every two seconds. It hits hard, and armor has a hard time resisting it.<br>\
	You are also immune to the cold, and you cause enemies around you to suffer periodic harm from the cold, if unprotected.<br>\
	Unprotected enemies are also Chilled, making them slower and less evasive, and disabling effects last longer."

/obj/item/projectile/icicle
	name = "icicle"
	icon_state = "ice_2"
	damage = 40
	damage_type = BRUTE
	check_armour = "melee"
	armor_penetration = 30
	speed = 2
	icon_scale_x = 2 // It hits like a truck.
	icon_scale_y = 2
	sharp = TRUE

/obj/item/projectile/icicle/on_impact(atom/A)
	playsound(A, "shatter", 70, 1)
	return ..()

/obj/item/projectile/icicle/get_structure_damage()
	return damage / 2 // They're really deadly against mobs, but less effective against solid things.

/mob/living/simple_mob/slime/feral/dark_blue/handle_special()
	if(stat != DEAD)
		cold_aura()
	..()

/mob/living/simple_mob/slime/feral/dark_blue/proc/cold_aura()
	for(var/mob/living/L in view(3, src))
		if(L == src)
			continue
		chill(L)

/mob/living/simple_mob/slime/feral/dark_blue/proc/chill(mob/living/L)
	L.inflict_cold_damage(10)
	if(L.get_cold_protection() < 1)
		L.add_modifier(/datum/modifier/chilled, 5 SECONDS, src)

	if(L.has_AI()) // Other AIs should react to hostile auras.
		L.ai_holder.react_to_attack(src)
