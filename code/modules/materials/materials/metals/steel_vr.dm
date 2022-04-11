/datum/material/steel/generate_recipes()
	. = ..()
	recipes += list(
		new /datum/stack_recipe_list("mounted chairs",list(
			new /datum/stack_recipe("mounted chair", /obj/structure/bed/chair/bay/chair, 2, one_per_turf = 1, on_floor = 1, time = 10),
			new /datum/stack_recipe("red mounted chair", /obj/structure/bed/chair/bay/chair/padded/red, 2, one_per_turf = 1, on_floor = 1, time = 10),
			new /datum/stack_recipe("brown mounted chair", /obj/structure/bed/chair/bay/chair/padded/brown, 2, one_per_turf = 1, on_floor = 1, time = 10),
			new /datum/stack_recipe("teal mounted chair", /obj/structure/bed/chair/bay/chair/padded/teal, 2, one_per_turf = 1, on_floor = 1, time = 10),
			new /datum/stack_recipe("black mounted chair", /obj/structure/bed/chair/bay/chair/padded/black, 2, one_per_turf = 1, on_floor = 1, time = 10),
			new /datum/stack_recipe("green mounted chair", /obj/structure/bed/chair/bay/chair/padded/green, 2, one_per_turf = 1, on_floor = 1, time = 10),
			new /datum/stack_recipe("purple mounted chair", /obj/structure/bed/chair/bay/chair/padded/purple, 2, one_per_turf = 1, on_floor = 1, time = 10),
			new /datum/stack_recipe("blue mounted chair", /obj/structure/bed/chair/bay/chair/padded/blue, 2, one_per_turf = 1, on_floor = 1, time = 10),
			new /datum/stack_recipe("beige mounted chair", /obj/structure/bed/chair/bay/chair/padded/beige, 2, one_per_turf = 1, on_floor = 1, time = 10),
			new /datum/stack_recipe("lime mounted chair", /obj/structure/bed/chair/bay/chair/padded/lime, 2, one_per_turf = 1, on_floor = 1, time = 10),
			new /datum/stack_recipe("yellow mounted chair", /obj/structure/bed/chair/bay/chair/padded/yellow, 2, one_per_turf = 1, on_floor = 1, time = 10)
			)),
		new /datum/stack_recipe_list("mounted comfy chairs",list(
			new /datum/stack_recipe("mounted comfy chair", /obj/structure/bed/chair/bay/comfy, 3, one_per_turf = 1, on_floor = 1, time = 20),
			new /datum/stack_recipe("red mounted comfy chair", /obj/structure/bed/chair/bay/comfy/red, 3, one_per_turf = 1, on_floor = 1, time = 20),
			new /datum/stack_recipe("brown mounted comfy chair", /obj/structure/bed/chair/bay/comfy/brown, 3, one_per_turf = 1, on_floor = 1, time = 20),
			new /datum/stack_recipe("teal mounted comfy chair", /obj/structure/bed/chair/bay/comfy/teal, 3, one_per_turf = 1, on_floor = 1, time = 20),
			new /datum/stack_recipe("black mounted comfy chair", /obj/structure/bed/chair/bay/comfy/black, 3, one_per_turf = 1, on_floor = 1, time = 20),
			new /datum/stack_recipe("green mounted comfy chair", /obj/structure/bed/chair/bay/comfy/green, 3, one_per_turf = 1, on_floor = 1, time = 20),
			new /datum/stack_recipe("purple mounted comfy chair", /obj/structure/bed/chair/bay/comfy/purple, 3, one_per_turf = 1, on_floor = 1, time = 20),
			new /datum/stack_recipe("blue mounted comfy chair", /obj/structure/bed/chair/bay/comfy/blue, 3, one_per_turf = 1, on_floor = 1, time = 20),
			new /datum/stack_recipe("beige mounted comfy chair", /obj/structure/bed/chair/bay/comfy/beige, 3, one_per_turf = 1, on_floor = 1, time = 20),
			new /datum/stack_recipe("lime mounted comfy chair", /obj/structure/bed/chair/bay/comfy/lime, 3, one_per_turf = 1, on_floor = 1, time = 20),
			new /datum/stack_recipe("yellow mounted comfy chair", /obj/structure/bed/chair/bay/comfy/yellow, 3, one_per_turf = 1, on_floor = 1, time = 20)
			)),
		new /datum/stack_recipe("mounted captain's chair", /obj/structure/bed/chair/bay/comfy/captain, 4, one_per_turf = 1, on_floor = 1, time = 20),
		new /datum/stack_recipe("dropship seat", /obj/structure/bed/chair/bay/shuttle, 4, one_per_turf = 1, on_floor = 1, time = 20),
		new /datum/stack_recipe("small teshari nest", /obj/structure/bed/chair/bay/chair/padded/red/smallnest, 2, one_per_turf = 1, on_floor = 1, time = 10),
		new /datum/stack_recipe("large teshari nest", /obj/structure/bed/chair/bay/chair/padded/red/bignest, 4, one_per_turf = 1, on_floor = 1, time = 20),
		new /datum/stack_recipe("dance pole", /obj/structure/dancepole, 2, one_per_turf = 1, on_floor = 1, time = 20),
		new /datum/stack_recipe("light switch frame", /obj/item/frame/lightswitch, 2),
		new /datum/stack_recipe_list("sofas",list(
			new /datum/stack_recipe("red sofa middle", /obj/structure/bed/chair/sofa, 1, one_per_turf = 1, on_floor = 1), \
			new /datum/stack_recipe("red sofa left", /obj/structure/bed/chair/sofa/left, 1, one_per_turf = 1, on_floor = 1), \
			new /datum/stack_recipe("red sofa right", /obj/structure/bed/chair/sofa/right, 1, one_per_turf = 1, on_floor = 1), \
			new /datum/stack_recipe("red sofa corner", /obj/structure/bed/chair/sofa/corner, 1, one_per_turf = 1, on_floor = 1), \
			new /datum/stack_recipe("brown sofa middle", /obj/structure/bed/chair/sofa/brown, 1, one_per_turf = 1, on_floor = 1), \
			new /datum/stack_recipe("brown sofa left", /obj/structure/bed/chair/sofa/left/brown, 1, one_per_turf = 1, on_floor = 1), \
			new /datum/stack_recipe("brown sofa right", /obj/structure/bed/chair/sofa/right/brown, 1, one_per_turf = 1, on_floor = 1), \
			new /datum/stack_recipe("brown sofa corner", /obj/structure/bed/chair/sofa/corner/brown, 1, one_per_turf = 1, on_floor = 1), \
			new /datum/stack_recipe("teal sofa middle", /obj/structure/bed/chair/sofa/teal, 1, one_per_turf = 1, on_floor = 1), \
			new /datum/stack_recipe("teal sofa left", /obj/structure/bed/chair/sofa/left/teal, 1, one_per_turf = 1, on_floor = 1), \
			new /datum/stack_recipe("teal sofa right", /obj/structure/bed/chair/sofa/right/teal, 1, one_per_turf = 1, on_floor = 1), \
			new /datum/stack_recipe("teal sofa corner", /obj/structure/bed/chair/sofa/corner/teal, 1, one_per_turf = 1, on_floor = 1), \
			new /datum/stack_recipe("black sofa middle", /obj/structure/bed/chair/sofa/black, 1, one_per_turf = 1, on_floor = 1), \
			new /datum/stack_recipe("black sofa left", /obj/structure/bed/chair/sofa/left/black, 1, one_per_turf = 1, on_floor = 1), \
			new /datum/stack_recipe("black sofa right", /obj/structure/bed/chair/sofa/right/black, 1, one_per_turf = 1, on_floor = 1), \
			new /datum/stack_recipe("black sofa corner", /obj/structure/bed/chair/sofa/corner/black, 1, one_per_turf = 1, on_floor = 1), \
			new /datum/stack_recipe("green sofa middle", /obj/structure/bed/chair/sofa/green, 1, one_per_turf = 1, on_floor = 1), \
			new /datum/stack_recipe("green sofa left", /obj/structure/bed/chair/sofa/left/green, 1, one_per_turf = 1, on_floor = 1), \
			new /datum/stack_recipe("green sofa right", /obj/structure/bed/chair/sofa/right/green, 1, one_per_turf = 1, on_floor = 1), \
			new /datum/stack_recipe("green sofa corner", /obj/structure/bed/chair/sofa/corner/green, 1, one_per_turf = 1, on_floor = 1), \
			new /datum/stack_recipe("purple sofa middle", /obj/structure/bed/chair/sofa/purp, 1, one_per_turf = 1, on_floor = 1), \
			new /datum/stack_recipe("purple sofa left", /obj/structure/bed/chair/sofa/left/purp, 1, one_per_turf = 1, on_floor = 1), \
			new /datum/stack_recipe("purple sofa right", /obj/structure/bed/chair/sofa/right/purp, 1, one_per_turf = 1, on_floor = 1), \
			new /datum/stack_recipe("purple sofa corner", /obj/structure/bed/chair/sofa/corner/purp, 1, one_per_turf = 1, on_floor = 1), \
			new /datum/stack_recipe("blue sofa middle", /obj/structure/bed/chair/sofa/blue, 1, one_per_turf = 1, on_floor = 1), \
			new /datum/stack_recipe("blue sofa left", /obj/structure/bed/chair/sofa/left/blue, 1, one_per_turf = 1, on_floor = 1), \
			new /datum/stack_recipe("blue sofa right", /obj/structure/bed/chair/sofa/right/blue, 1, one_per_turf = 1, on_floor = 1), \
			new /datum/stack_recipe("blue sofa corner", /obj/structure/bed/chair/sofa/corner/blue, 1, one_per_turf = 1, on_floor = 1), \
			new /datum/stack_recipe("beige sofa middle", /obj/structure/bed/chair/sofa/beige, 1, one_per_turf = 1, on_floor = 1), \
			new /datum/stack_recipe("beige sofa left", /obj/structure/bed/chair/sofa/left/beige, 1, one_per_turf = 1, on_floor = 1), \
			new /datum/stack_recipe("beige sofa right", /obj/structure/bed/chair/sofa/right/beige, 1, one_per_turf = 1, on_floor = 1), \
			new /datum/stack_recipe("beige sofa corner", /obj/structure/bed/chair/sofa/corner/beige, 1, one_per_turf = 1, on_floor = 1), \
			new /datum/stack_recipe("lime sofa middle", /obj/structure/bed/chair/sofa/lime, 1, one_per_turf = 1, on_floor = 1), \
			new /datum/stack_recipe("lime sofa left", /obj/structure/bed/chair/sofa/left/lime, 1, one_per_turf = 1, on_floor = 1), \
			new /datum/stack_recipe("lime sofa right", /obj/structure/bed/chair/sofa/right/lime, 1, one_per_turf = 1, on_floor = 1), \
			new /datum/stack_recipe("lime sofa corner", /obj/structure/bed/chair/sofa/corner/lime, 1, one_per_turf = 1, on_floor = 1), \
			new /datum/stack_recipe("yellow sofa middle", /obj/structure/bed/chair/sofa/yellow, 1, one_per_turf = 1, on_floor = 1), \
			new /datum/stack_recipe("yellow sofa left", /obj/structure/bed/chair/sofa/left/yellow, 1, one_per_turf = 1, on_floor = 1), \
			new /datum/stack_recipe("yellow sofa right", /obj/structure/bed/chair/sofa/right/yellow, 1, one_per_turf = 1, on_floor = 1), \
			new /datum/stack_recipe("yellow sofa corner", /obj/structure/bed/chair/sofa/corner/yellow, 1, one_per_turf = 1, on_floor = 1), \
			new /datum/stack_recipe("orange sofa middle", /obj/structure/bed/chair/sofa/orange, 1, one_per_turf = 1, on_floor = 1), \
			new /datum/stack_recipe("orange sofa left", /obj/structure/bed/chair/sofa/left/orange, 1, one_per_turf = 1, on_floor = 1), \
			new /datum/stack_recipe("orange sofa right", /obj/structure/bed/chair/sofa/right/orange, 1, one_per_turf = 1, on_floor = 1), \
			new /datum/stack_recipe("orange sofa corner", /obj/structure/bed/chair/sofa/corner/orange, 1, one_per_turf = 1, on_floor = 1), \
			)),
	)
