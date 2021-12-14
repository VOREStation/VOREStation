// Space carp show up as a random event to wreck hapless people in space or near windows.
// They generally fit the archetype of 'fast but fragile'.
// This is compensated by being in groups (usually).

/datum/category_item/catalogue/fauna/carp
	name = "Voidborne Fauna - Space Carp"
	desc = "A strange descendant of some form of voidborne life, they are the most \
	common naturally void-faring lifeform found in human territory. They've been named \
	'Space Carp' by various groups of spacers due to resembling the fish from Earth.\
	<br><br>\
	Their lifecycle begins as a fungus-like growth, sometimes found on the walls of spacecraft \
	and space stations, before growing into a form which allows for independent travel. Even \
	when fully grown, they can sometimes be found to stow away on the hulls of spaceborne objects, \
	which might explain how they became widespread across many star systems.\
	<br><br>\
	Carp have a special gas bladder inside of them, which they utilize as a means of movement in \
	space by stategically releasing the gas to propel themselves in a process that resembles \
	thrusters on a spacecraft. The gas contained inside the carp also allows them \
	to float when inside an atmosphere. The carp might also spray 'spores' using a similar method.\
	<br><br>\
	They are hypercarnivorous to the point of cannibalism, consuming their own dead in order to \
	sustain themselves during hard times, which are rather frequent due to their prey being \
	vastly technologically advanced. For human habitats that are well secured, carp are generally \
	an annoyance. For those unable to adequately protect themselves, however, they can be \
	rather dangerous, especially if a mass migration of carp arrives."
	value = CATALOGUER_REWARD_EASY

/mob/living/simple_mob/animal/space/carp
	name = "space carp"
	desc = "A ferocious, fang-bearing creature that resembles a fish."
	catalogue_data = list(/datum/category_item/catalogue/fauna/carp)
	icon_state = "carp"
	icon_living = "carp"
	icon_dead = "carp_dead"
	icon_gib = "carp_gib"

	faction = "carp"
	maxHealth = 25
	health = 25
	movement_cooldown = 0 // Carp go fast
	hovering = TRUE

	response_help = "pets the"
	response_disarm = "gently pushes aside the"
	response_harm = "hits the"

	melee_damage_lower = 7 // About 14 DPS.
	melee_damage_upper = 7
	base_attack_cooldown = 10 // One attack a second.
	attack_sharp = TRUE
	attack_sound = 'sound/weapons/bite.ogg'
	attacktext = list("bitten")

	organ_names = /decl/mob_organ_names/fish

	meat_amount = 5
	meat_type = /obj/item/weapon/reagent_containers/food/snacks/carpmeat

	ai_holder_type = /datum/ai_holder/simple_mob/melee

	var/knockdown_chance = 15

/mob/living/simple_mob/animal/space/carp/apply_melee_effects(var/atom/A)
	if(isliving(A))
		var/mob/living/L = A
		if(prob(knockdown_chance))
			L.Weaken(3)
			L.visible_message(span("danger", "\The [src] knocks down \the [L]!"))

// Subtypes.

// Won't wander away.
/mob/living/simple_mob/animal/space/carp/event
	ai_holder_type = /datum/ai_holder/simple_mob/event


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
	default_pixel_x = -16
	icon_expected_width = 64
	icon_expected_height = 32

	meat_amount = 7


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

	pixel_y = -16
	default_pixel_y = -16
	icon_expected_width = 64
	icon_expected_height = 64

	meat_amount = 15


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

/mob/living/simple_mob/animal/space/carp/holographic/Initialize()
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


