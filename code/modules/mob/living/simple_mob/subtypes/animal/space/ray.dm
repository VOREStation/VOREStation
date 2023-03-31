// Space carp show up as a random event to wreck hapless people in space or near windows.
// They generally fit the archetype of 'fast but fragile'.
// This is compensated by being in groups (usually).

/datum/category_item/catalogue/fauna/ray
	name = "Voidborne Fauna - Space Ray"
	desc = "Believed to be a distant relative of the more numerous 'space carp' \
	the 'space ray' is a somewhat horrifying-looking creature with a maw of sharp fangs \
	and several vicious-looking bony protrusions.\
	<br><br>\
	In truth, however, they are largely harmless creatures, being content to drift \
	upon the solar winds. They seem to feed off a mix of interstellar gases, solar radiation, \
	space dust, and occasionally other detritus. There are no known cases of unprovoked attacks. \
	More baffling is their ability to fly within gravity fields, as they do not seem to move about \
	in the same way that carp do, instead seeming to drift on invisible field currents. \
	<br><br>\
	Scientists have found several shared genetic markers between both the 'ray' and 'carp', \
	but at this time have little direct evidence of any relationship between these species. \
	There are many competing theories, and few of them can agree on anything but the broadest \
	strokes. Oh, and that their tissues contain considerable amounts of soporifics. That too. \
	<br><br>\
	What scientists can agree on, however, is that whilst the 'space ray' may look nasty \
	they're generally little threat. Astroxenobiologists have noted that the two species do \
	seem to get along quite poorly, and that the rays are quite capable of dispatching their \
	supposed cousins, even when outnumbered."
	value = CATALOGUER_REWARD_EASY

/mob/living/simple_mob/animal/space/ray
	name = "space ray"
	desc = "A horrifying-looking but ultimately misunderstood creature that poses little actual threat."
	catalogue_data = list(/datum/category_item/catalogue/fauna/ray)
	icon = 'icons/mob/mobs_monsters/animal.dmi'
	icon_state = "ray"
	icon_living = "ray"
	icon_dead = "ray_dead"
	icon_rest = "ray_rest"
	icon_gib = "ray_gib"

	faction = "ray"
	maxHealth = 125
	health = 125
	movement_cooldown = 0 // Carp go fast
	hovering = TRUE

	response_help = "strokes the"
	response_disarm = "gently pushes aside the"
	response_harm = "hits the"

	melee_damage_lower = 10
	melee_damage_upper = 15	//minor damage variance, since they should only be fighting carp
	base_attack_cooldown = 13 // A bit slower than carp
	attack_sharp = TRUE
	attack_sound = 'sound/weapons/bite.ogg'
	attacktext = list("lanced","bitten","impaled","gored")

	organ_names = /decl/mob_organ_names/fish

	meat_amount = 5
	meat_type = /obj/item/weapon/reagent_containers/food/snacks/carpmeat/ray

	ai_holder_type = /datum/ai_holder/simple_mob/retaliate/chill
	mob_bump_flag = 0

	say_list_type = /datum/say_list/space_ray

/datum/say_list/space_ray
	emote_see = list("swoops","dives","drifts on a solar current","glides elegantly through the void","briefly tumbles")
