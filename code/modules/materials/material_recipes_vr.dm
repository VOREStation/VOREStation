
/material/steel/generate_recipes()
	. = ..()
	recipes += new/datum/stack_recipe("light switch frame", /obj/item/frame/lightswitch, 2)
	recipes += new/datum/stack_recipe_list("sofas", list( \
		new/datum/stack_recipe("sofa middle", /obj/structure/bed/chair/sofa, 1, one_per_turf = 1, on_floor = 1), \
		new/datum/stack_recipe("sofa left", /obj/structure/bed/chair/sofa/left, 1, one_per_turf = 1, on_floor = 1), \
		new/datum/stack_recipe("sofa right", /obj/structure/bed/chair/sofa/right, 1, one_per_turf = 1, on_floor = 1), \
		new/datum/stack_recipe("sofa corner", /obj/structure/bed/chair/sofa/corner, 1, one_per_turf = 1, on_floor = 1), \
		))

/material/durasteel/generate_recipes()
	. = ..()
	recipes += new/datum/stack_recipe("durasteel fishing rod", /obj/item/weapon/material/fishing_rod/modern/strong, 2)

/material/metaglass/generate_recipes()
	. = ..()
	recipes += new/datum/stack_recipe("metamorphic drinking glass", /obj/item/weapon/reagent_containers/food/drinks/metaglass, 1)
	recipes += new/datum/stack_recipe_list("drinking glass", list( \
		new/datum/stack_recipe("half-pint glass", /obj/item/weapon/reagent_containers/food/drinks/glass2/square, 1), \
		new/datum/stack_recipe("rocks glass", /obj/item/weapon/reagent_containers/food/drinks/glass2/rocks, 1), \
		new/datum/stack_recipe("milkshake glass", /obj/item/weapon/reagent_containers/food/drinks/glass2/shake, 1), \
		new/datum/stack_recipe("cocktail glass", /obj/item/weapon/reagent_containers/food/drinks/glass2/cocktail, 1), \
		new/datum/stack_recipe("shot glass", /obj/item/weapon/reagent_containers/food/drinks/glass2/shot, 1), \
		new/datum/stack_recipe("pint glass", /obj/item/weapon/reagent_containers/food/drinks/glass2/pint, 1), \
		new/datum/stack_recipe("mug glass", /obj/item/weapon/reagent_containers/food/drinks/glass2/mug, 1), \
		new/datum/stack_recipe("wine glass", /obj/item/weapon/reagent_containers/food/drinks/glass2/wine, 1), \
		))