// Space carp show up as a random event to wreck hapless people in space or near windows.
// They generally fit the archetype of 'fast but fragile'.
// This is compensated by being in groups (usually).
/mob/living/simple_mob/animal/space/carp
	name = "space carp"
	desc = "A ferocious, fang-bearing creature that resembles a fish."
	icon_state = "carp"
	icon_living = "carp"
	icon_dead = "carp_dead"
	icon_gib = "carp_gib"

	faction = "carp"
	maxHealth = 25
	health = 25
	movement_cooldown = 0 // Carp go fast
	hovering = TRUE.

	response_help = "pets the"
	response_disarm = "gently pushes aside the"
	response_harm = "hits the"

	melee_damage_lower = 7 // About 14 DPS.
	melee_damage_upper = 7
	base_attack_cooldown = 10 // One attack a second.
	attack_sharp = TRUE
	attack_sound = 'sound/weapons/bite.ogg'
	attacktext = list("bitten")

	meat_amount = 1
	meat_type = /obj/item/weapon/reagent_containers/food/snacks/carpmeat

	ai_holder_type = /datum/ai_holder/simple_mob/melee

	var/knockdown_chance = 15

/mob/living/simple_mob/animal/space/carp/Process_Spacemove(var/check_drift = 0)
	return TRUE //No drifting in space for space carp!	//original comments do not steal	// stolen.

/mob/living/simple_mob/animal/space/carp/apply_melee_effects(var/atom/A)
	if(isliving(A))
		var/mob/living/L = A
		if(prob(knockdown_chance))
			L.Weaken(3)
			L.visible_message(span("danger", "\The [src] knocks down \the [L]!"))


// Subtypes.
/mob/living/simple_mob/animal/space/carp/large
	name = "elder carp"
	desc = "An older, more matured carp. Few survive to this age due to their aggressiveness."
	icon = 'icons/mob/64x32.dmi'
	icon_state = "shark"
	icon_living = "shark"
	icon_dead = "shark_dead"

	maxHealth = 50
	health = 50
	movement_cooldown = 5 // Slower than the younger carp.
	mob_size = MOB_LARGE

	pixel_x = -16
	old_x = -16

	meat_amount = 3


/mob/living/simple_mob/animal/space/carp/large/huge
	name = "great white carp"
	desc = "A very rare breed of carp- and a very aggressive one."
	icon = 'icons/mob/64x64.dmi'
	icon_dead = "megacarp_dead"
	icon_living = "megacarp"
	icon_state = "megacarp"

	maxHealth = 230
	health = 230
	movement_cooldown = 10

	melee_damage_lower = 15 // About 20 DPS.
	melee_damage_upper = 25

	old_y = -16
	pixel_y = -16

	meat_amount = 10


/mob/living/simple_mob/animal/space/carp/holographic
	name = "holographic carp"
	desc = "An obviously holographic, but still ferocious looking carp."
	// Might be worth using a filter similar to AI holograms in the future.
	icon = 'icons/mob/AI.dmi'
	icon_state = "holo4"
	icon_living = "holo4"
	icon_dead = "holo4"
	alpha = 127
	icon_gib = null
	meat_amount = 0
	meat_type = null

	mob_class = MOB_CLASS_PHOTONIC // Xeno-taser won't work on this as its not a 'real' carp.

/mob/living/simple_mob/animal/space/carp/holographic/initialize()
	set_light(2) // Hologram lighting.
	return ..()

// Presumably the holodeck emag code requires this.
// Pass TRUE to make safe. Pass FALSE to make unsafe.
/mob/living/simple_mob/animal/space/carp/holographic/proc/set_safety(safe)
	if(!isnull(get_AI_stance())) // Will return null if lacking an AI holder or a player is controlling it w/o autopilot var.
		ai_holder.hostile = !safe // Inverted so safe = TRUE means hostility = FALSE.
		ai_holder.forget_everything() // Reset state so it'll stop chewing on its target.

// Called on death.
/mob/living/simple_mob/animal/space/carp/holographic/proc/derez()
	visible_message(span("notice", "\The [src] fades away!"))
	qdel(src)

/mob/living/simple_mob/animal/space/carp/holographic/gib()
	derez() // Holograms can't gib.

/mob/living/simple_mob/animal/space/carp/holographic/death()
	..()
	derez()


