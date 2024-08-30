// Mobs intended to be on Sif. As such, they won't die to the cold.
/mob/living/simple_mob/animal/sif
	minbodytemp = 175
	cold_resist = 0.75
	heat_resist = -0.5
	allow_mind_transfer = TRUE

	tame_items = list(
	/obj/item/weapon/reagent_containers/food/snacks/crabmeat = 20,
	/obj/item/weapon/reagent_containers/food/snacks/meat = 10
	)
