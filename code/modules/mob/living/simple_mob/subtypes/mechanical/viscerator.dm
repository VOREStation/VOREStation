/*
	Viscerators are fragile and don't hit very hard, but fast, evasive, and rarely come alone.
	They also tend to dodge while in melee range.
	A weapon that can cleave is very effective against them.
*/

/mob/living/simple_mob/mechanical/viscerator
	name = "viscerator"
	desc = "A small, twin-bladed machine capable of inflicting very deadly lacerations."
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