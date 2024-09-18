/*
	Wards are a specific type of mechanical simplemob that generally fill a support role for their faction or for a specific mob.
	Generally they are helpless by themselves and are fragile, but can do very useful things if protected. This makes them a high priority target.
*/

/mob/living/simple_mob/mechanical/ward
	name = "ward"
	desc = "A small floating machine. This one seems rather useless..."
	icon = 'icons/mob/critter.dmi'
	icon_state = "ward"
	icon_living = "ward"
	hovering = TRUE // Won't trigger landmines.
	response_help   = "pets"
	response_disarm = "swats away"
	response_harm   = "punches"
	faction = FACTION_WARDS // Needed as most human mobs are in neutral faction. The owner is generally except from any ward hostility regardless.

	organ_names = /decl/mob_organ_names/ward

	maxHealth = 15
	health = 15
	movement_cooldown = -1
	hovering = TRUE

	mob_bump_flag = 0

	melee_damage_lower = 0
	melee_damage_upper = 0

	ai_holder_type = null
	var/mob/living/owner = null // The mob that made the ward, if any. Used to ensure the ward does not interfere with its creator.

/mob/living/simple_mob/mechanical/ward/death()
	..(null,"is smashed into pieces!")
	qdel(src)

/mob/living/simple_mob/mechanical/ward/Destroy()
	owner = null
	return ..()

/mob/living/simple_mob/mechanical/ward/IIsAlly(mob/living/L)
	if(owner == L)
		return TRUE
	return ..()

/decl/mob_organ_names/ward
	hit_zones = list("chassis", "sensor array", "hover thruster")
