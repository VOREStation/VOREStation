
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
