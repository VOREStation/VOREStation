
/material/steel/generate_recipes()
	. = ..()
	recipes += new/datum/stack_recipe("light switch frame", /obj/item/frame/lightswitch, 2)
	recipes += new/datum/stack_recipe_list("sofas", list(
		new/datum/stack_recipe("red sofa middle", /obj/structure/bed/chair/sofa, 1, one_per_turf = 1, on_floor = 1), \
		new/datum/stack_recipe("red sofa left", /obj/structure/bed/chair/sofa/left, 1, one_per_turf = 1, on_floor = 1), \
		new/datum/stack_recipe("red sofa right", /obj/structure/bed/chair/sofa/right, 1, one_per_turf = 1, on_floor = 1), \
		new/datum/stack_recipe("red sofa corner", /obj/structure/bed/chair/sofa/corner, 1, one_per_turf = 1, on_floor = 1), \
		new/datum/stack_recipe("brown sofa middle", /obj/structure/bed/chair/sofa/brown, 1, one_per_turf = 1, on_floor = 1), \
		new/datum/stack_recipe("brown sofa left", /obj/structure/bed/chair/sofa/brown/left, 1, one_per_turf = 1, on_floor = 1), \
		new/datum/stack_recipe("brown sofa right", /obj/structure/bed/chair/sofa/brown/right, 1, one_per_turf = 1, on_floor = 1), \
		new/datum/stack_recipe("brown sofa corner", /obj/structure/bed/chair/sofa/brown/corner, 1, one_per_turf = 1, on_floor = 1), \
		new/datum/stack_recipe("teal sofa middle", /obj/structure/bed/chair/sofa/teal, 1, one_per_turf = 1, on_floor = 1), \
		new/datum/stack_recipe("teal sofa left", /obj/structure/bed/chair/sofa/teal/left, 1, one_per_turf = 1, on_floor = 1), \
		new/datum/stack_recipe("teal sofa right", /obj/structure/bed/chair/sofa/teal/right, 1, one_per_turf = 1, on_floor = 1), \
		new/datum/stack_recipe("teal sofa corner", /obj/structure/bed/chair/sofa/teal/corner, 1, one_per_turf = 1, on_floor = 1), \
		new/datum/stack_recipe("black sofa middle", /obj/structure/bed/chair/sofa/black, 1, one_per_turf = 1, on_floor = 1), \
		new/datum/stack_recipe("black sofa left", /obj/structure/bed/chair/sofa/black/left, 1, one_per_turf = 1, on_floor = 1), \
		new/datum/stack_recipe("black sofa right", /obj/structure/bed/chair/sofa/black/right, 1, one_per_turf = 1, on_floor = 1), \
		new/datum/stack_recipe("black sofa corner", /obj/structure/bed/chair/sofa/black/corner, 1, one_per_turf = 1, on_floor = 1), \
		new/datum/stack_recipe("green sofa middle", /obj/structure/bed/chair/sofa/green, 1, one_per_turf = 1, on_floor = 1), \
		new/datum/stack_recipe("green sofa left", /obj/structure/bed/chair/sofa/green/left, 1, one_per_turf = 1, on_floor = 1), \
		new/datum/stack_recipe("green sofa right", /obj/structure/bed/chair/sofa/green/right, 1, one_per_turf = 1, on_floor = 1), \
		new/datum/stack_recipe("green sofa corner", /obj/structure/bed/chair/sofa/green/corner, 1, one_per_turf = 1, on_floor = 1), \
		new/datum/stack_recipe("purple sofa middle", /obj/structure/bed/chair/sofa/purp, 1, one_per_turf = 1, on_floor = 1), \
		new/datum/stack_recipe("purple sofa left", /obj/structure/bed/chair/sofa/purp/left, 1, one_per_turf = 1, on_floor = 1), \
		new/datum/stack_recipe("purple sofa right", /obj/structure/bed/chair/sofa/purp/right, 1, one_per_turf = 1, on_floor = 1), \
		new/datum/stack_recipe("purple sofa corner", /obj/structure/bed/chair/sofa/purp/corner, 1, one_per_turf = 1, on_floor = 1), \
		new/datum/stack_recipe("blue sofa middle", /obj/structure/bed/chair/sofa/blue, 1, one_per_turf = 1, on_floor = 1), \
		new/datum/stack_recipe("blue sofa left", /obj/structure/bed/chair/sofa/blue/left, 1, one_per_turf = 1, on_floor = 1), \
		new/datum/stack_recipe("blue sofa right", /obj/structure/bed/chair/sofa/blue/right, 1, one_per_turf = 1, on_floor = 1), \
		new/datum/stack_recipe("blue sofa corner", /obj/structure/bed/chair/sofa/blue/corner, 1, one_per_turf = 1, on_floor = 1), \
		new/datum/stack_recipe("beige sofa middle", /obj/structure/bed/chair/sofa/beige, 1, one_per_turf = 1, on_floor = 1), \
		new/datum/stack_recipe("beige sofa left", /obj/structure/bed/chair/sofa/beige/left, 1, one_per_turf = 1, on_floor = 1), \
		new/datum/stack_recipe("beige sofa right", /obj/structure/bed/chair/sofa/beige/right, 1, one_per_turf = 1, on_floor = 1), \
		new/datum/stack_recipe("beige sofa corner", /obj/structure/bed/chair/sofa/beige/corner, 1, one_per_turf = 1, on_floor = 1), \
		new/datum/stack_recipe("lime sofa middle", /obj/structure/bed/chair/sofa/lime, 1, one_per_turf = 1, on_floor = 1), \
		new/datum/stack_recipe("lime sofa left", /obj/structure/bed/chair/sofa/lime/left, 1, one_per_turf = 1, on_floor = 1), \
		new/datum/stack_recipe("lime sofa right", /obj/structure/bed/chair/sofa/lime/right, 1, one_per_turf = 1, on_floor = 1), \
		new/datum/stack_recipe("lime sofa corner", /obj/structure/bed/chair/sofa/lime/corner, 1, one_per_turf = 1, on_floor = 1), \
		new/datum/stack_recipe("yellow sofa middle", /obj/structure/bed/chair/sofa/yellow, 1, one_per_turf = 1, on_floor = 1), \
		new/datum/stack_recipe("yellow sofa left", /obj/structure/bed/chair/sofa/yellow/left, 1, one_per_turf = 1, on_floor = 1), \
		new/datum/stack_recipe("yellow sofa right", /obj/structure/bed/chair/sofa/yellow/right, 1, one_per_turf = 1, on_floor = 1), \
		new/datum/stack_recipe("yellow sofa corner", /obj/structure/bed/chair/sofa/yellow/corner, 1, one_per_turf = 1, on_floor = 1), \
		new/datum/stack_recipe("yellow sofa middle", /obj/structure/bed/chair/sofa/orange, 1, one_per_turf = 1, on_floor = 1), \
		new/datum/stack_recipe("yellow sofa left", /obj/structure/bed/chair/sofa/orange/left, 1, one_per_turf = 1, on_floor = 1), \
		new/datum/stack_recipe("yellow sofa right", /obj/structure/bed/chair/sofa/orange/right, 1, one_per_turf = 1, on_floor = 1), \
		new/datum/stack_recipe("yellow sofa corner", /obj/structure/bed/chair/sofa/orange/corner, 1, one_per_turf = 1, on_floor = 1), \
		))

/material/durasteel/generate_recipes()
	. = ..()
	recipes += new/datum/stack_recipe("durasteel fishing rod", /obj/item/weapon/material/fishing_rod/modern/strong, 2)