// Diyaabs are rather weak, but tend to exist in large numbers.
// They cooperate with other diyaabs, in order to swarm whoever decides to pick on the little fluffy critter.
// A cleaving weapon like an axe will make short work of the pack.

/datum/category_item/catalogue/fauna/diyaab
	name = "Sivian Fauna - Diyaab"
	desc = "Classification: S Choeros hirtus\
	<br><br>\
	Small, social omnivores with dense seasonal wool fur valued by Sivian colonists for its cold resistance and softness. \
	The Diyaab lives in packs of anywhere from three to ten individuals, usually comprised of a family unit. Primarily herbivorous browsers, \
	supplementing their diet with organisms living in tree bark, \
	Diyaab packs have been observed to hunt prey several times their size during the less plentiful winter months. \
	Despite their unassuming appearance, the Diyaab possesses remarkably sharp anterior teeth."
	value = CATALOGUER_REWARD_EASY

/mob/living/simple_mob/animal/sif/diyaab
	name = "diyaab"
	desc = "A small pack animal. Although omnivorous, it will hunt meat on occasion."
	tt_desc = "S Choeros hirtus" //diyaab and shantak are technically reletives!
	catalogue_data = list(/datum/category_item/catalogue/fauna/diyaab)

	faction = "diyaab"

	icon_state = "diyaab"
	icon_living = "diyaab"
	icon_dead = "diyaab_dead"
	icon = 'icons/jungle.dmi'

	maxHealth = 25
	health = 25

	meat_amount = 2
	meat_type = /obj/item/reagent_containers/food/snacks/meat

	movement_cooldown = -1

	melee_damage_lower = 2
	melee_damage_upper = 6
	base_attack_cooldown = 1 SECOND
	attack_sharp = TRUE //Bleeds, but it shouldn't rip off a limb?
	attacktext = list("gouged")

	say_list_type = /datum/say_list/diyaab
	ai_holder_type = /datum/ai_holder/simple_mob/retaliate/cooperative

	// What do you hit the mob with (on help) to get something from it?
	harvest_tool = /obj/item/tool/wirecutters
	// How long do we have to wait until it's harvestable again?
	harvest_cooldown = 10 MINUTES
	// How long does it take to harvest?
	harvest_delay = 30 SECONDS
	// What world.time was the last harvest?
	harvest_recent = 0
	// How many times do we roll on the chance table?
	harvest_per_hit = 1
	// Verb for harvesting. "sheared" "clipped" etc.
	harvest_verb = "sheared"
	// Associative list of paths and their chances. path = straws in the lot
	harvest_results = list(
		/obj/item/stack/material/cloth/diyaab = 10
		)

/datum/say_list/diyaab
	speak = list("Awrr?", "Aowrl!", "Worrl.")
	emote_see = list("sniffs the air cautiously","looks around")
	emote_hear = list("snuffles")
