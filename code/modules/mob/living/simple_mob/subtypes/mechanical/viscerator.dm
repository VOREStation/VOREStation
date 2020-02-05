/*
	Viscerators are fragile and don't hit very hard, but fast, evasive, and rarely come alone.
	They also tend to dodge while in melee range.
	A weapon that can cleave is very effective against them.
*/

/datum/category_item/catalogue/technology/drone/viscerator
	name = "Drone - Viscerator"
	desc = "Viscerators are fairly simple machines that use very sharp blades as propellers, \
	which it uses both to fly and to attack enemy targets. Their simple construction generally \
	means that if one is found, a swarm of others are not too far away.\
	<br><br>\
	They are most effective against soft targets such as unarmored personnel, as the propeller \
	tends to get deflected after slicing into someone's flesh, and as such they tend to not cut deeply. \
	The simplistic AI inside compensates for this by using the tendency to bounce away after \
	slicing as an evasive tactic to avoid harm. This allows the viscerator to cut up the target, \
	fly to the side, and then repeat, potentially causing the target to die from many seperate wounds."
	value = CATALOGUER_REWARD_EASY

/mob/living/simple_mob/mechanical/viscerator
	name = "viscerator"
	desc = "A small, twin-bladed machine capable of inflicting very deadly lacerations."
	catalogue_data = list(/datum/category_item/catalogue/technology/drone/viscerator)

	icon = 'icons/mob/critter.dmi'
	icon_state = "viscerator_attack"
	icon_living = "viscerator_attack"
	hovering = TRUE // Won't trigger landmines.

	faction = "syndicate"
	maxHealth = 15
	health = 15
	movement_cooldown = 0

	pass_flags = PASSTABLE
	mob_swap_flags = 0
	mob_push_flags = 0

	melee_attack_delay = null // No attack delay, as their movement is functionally an attack.
	melee_damage_lower = 4 // Approx 8 DPS.
	melee_damage_upper = 4
	base_attack_cooldown = 5 // Two attacks a second or so.
	attack_sharp = 1
	attack_edge = 1
	attack_sound = 'sound/weapons/bladeslice.ogg'
	attacktext = list("cut", "sliced")

	ai_holder_type = /datum/ai_holder/simple_mob/melee/evasive

/mob/living/simple_mob/mechanical/viscerator/death()
	..(null,"is smashed into pieces!")
	qdel(src)

// Variant that is always loyal to mercenary antagonists.
// Used for a special grenade, to ensure they don't attack the wrong thing.
/mob/living/simple_mob/mechanical/viscerator/mercenary/IIsAlly(mob/living/L)
	. = ..()
	if(!.) // Not friendly, see if they're a baddie first.
		if(L.mind && mercs.is_antagonist(L.mind))
			return TRUE

// Similar to above but for raiders.
/mob/living/simple_mob/mechanical/viscerator/raider/IIsAlly(mob/living/L)
	. = ..()
	if(!.) // Not friendly, see if they're a baddie first.
		if(L.mind && raiders.is_antagonist(L.mind))
			return TRUE

// Variant that is neutral, and thus on the station's side. It checks records.
/mob/living/simple_mob/mechanical/viscerator/station
	icon_state = "viscerator_b_attack"
	icon_living = "viscerator_b_attack"

	faction = "station"
	maxHealth = 20
	health = 20

	melee_damage_lower = 2
	melee_damage_upper = 5
	base_attack_cooldown = 8

/mob/living/simple_mob/mechanical/viscerator/station/IIsAlly(mob/living/L)
	. = ..()
	if(!.)
		if(isrobot(L)) // They ignore synths.
			return TRUE
		if(istype(L, /mob/living/simple_mob/mechanical/ward/monitor/crew))	// Also ignore friendly monitor wards
			return TRUE
		return L.assess_perp(src, FALSE, FALSE, TRUE, FALSE) <= 3
