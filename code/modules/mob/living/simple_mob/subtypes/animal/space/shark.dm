// Space carp show up as a random event to wreck hapless people in space or near windows.
// They generally fit the archetype of 'fast but fragile'.
// This is compensated by being in groups (usually).

/datum/category_item/catalogue/fauna/shark
	name = "Voidborne Fauna - Space Shark"
	desc = "The space carp's bigger, highly territorial kin, space sharks are bigger, meaner, \
	and generally bad news to be around for extended periods. If you see one, hope that it's \
	the only one around, because if it isn't then that means it's probably a parent with their pups.	"
	value = CATALOGUER_REWARD_HARD

/mob/living/simple_mob/animal/space/shark
	name = "space shark"
	desc = "A regal and imposing interstellar creature, and one that poses a serious threat to the ill-prepared."
	catalogue_data = list(/datum/category_item/catalogue/fauna/shark)
	icon = 'icons/mob/mobs_monsters/animal.dmi'
	icon_state = "shark"
	icon_living = "shark"
	icon_dead = "shark_dead"
	icon_rest = "shark_rest"

	faction = "spaceshark"
	maxHealth = 125
	health = 125
	movement_cooldown = 0
	hovering = TRUE

	response_help = "strokes the"
	response_disarm = "casually rotates the"
	response_harm = "hits the"

	melee_damage_lower = 15
	melee_damage_upper = 30 //don't mess with these critters!
	base_attack_cooldown = 22 // Quite slow, given their power
	attack_sharp = TRUE
	attack_sound = 'sound/weapons/bite.ogg'
	attacktext = list("lanced","bitten","impaled","gored")

	organ_names = /decl/mob_organ_names/fish

	meat_amount = 10
	meat_type = /obj/item/reagent_containers/food/snacks/carpmeat/shark

	ai_holder_type = /datum/ai_holder/simple_mob/melee

	var/knockdown_chance = 10	//slightly reduced their knockdown prob compared to carp given their greater power

/mob/living/simple_mob/animal/space/shark/apply_melee_effects(var/atom/A)
	if(isliving(A))
		var/mob/living/L = A
		if(prob(knockdown_chance))
			L.Weaken(3)
			L.visible_message(span("danger", "\The [src] knocks down \the [L]!"))

/mob/living/simple_mob/animal/space/shark/event
	ai_holder_type = /datum/ai_holder/simple_mob/event