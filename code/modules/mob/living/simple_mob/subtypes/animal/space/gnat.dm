// Space carp show up as a random event to wreck hapless people in space or near windows.
// They generally fit the archetype of 'fast but fragile'.
// This is compensated by being in groups (usually).

/datum/category_item/catalogue/fauna/gnat
	name = "Voidborne Fauna - Space Gnat"
	desc = "Stellar explorers once thought the greatest nuisance was the space carp. \
	<br><br>\
	Regrettably, they were wrong.\
	<br><br>\
	The so-called 'space gnat' is a populous and highly irritating but largely harmless threat \
	mostly known for how much of a nuisance it poses by flying into various intakes and other \
	sensitive or delicate starship components. Their small, spherical bodies are very fragile \
	and possess four stubby wings that serve no apparent purpose, but which the gnats flap furiously \
	all the same, perhaps in anger at the cruelties of life and the universe.\
	<br><br>\
	Indeed, what kind of god could create such a misbegotten creature? Certainly not a benevolent one."
	value = CATALOGUER_REWARD_EASY

/mob/living/simple_mob/animal/space/gnat
	name = "space gnat"
	desc = "A small, wretched interstellar pest. Whilst little danger by themselves, they can be a problem in large numbers."
	catalogue_data = list(/datum/category_item/catalogue/fauna/gnat)
	icon = 'icons/mob/mobs_monsters/animal.dmi'
	icon_state = "gnat"
	icon_living = "gnat"
	icon_dead = "gnat_dead"

	faction = "gnat"
	maxHealth = 5
	health = 5
	movement_cooldown = 0
	hovering = TRUE

	response_help = "baps the"
	response_disarm = "gently pushes aside the"
	response_harm = "hits the"

	melee_damage_lower = 2
	melee_damage_upper = 3	//they do very little damage but attack fairly fast, like organic viscerators
	base_attack_cooldown = 10 // Bitey bitey!
	attack_sharp = TRUE
	attack_sound = 'sound/weapons/bite.ogg'
	attacktext = list("nibbled")

	organ_names = /decl/mob_organ_names/fish

	meat_amount = 1
	meat_type = /obj/item/reagent_containers/food/snacks/carpmeat/gnat

	ai_holder_type = /datum/ai_holder/simple_mob/melee/evasive/jellyfish
	mob_bump_flag = 0

	organ_names = /decl/mob_organ_names/space_gnat

/decl/mob_organ_names/space_gnat
	hit_zones = list("cephalothorax", "stubby winglets", "flailing tail")
