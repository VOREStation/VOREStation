/datum/crafting_recipe/shovel
	name = "Wooden Shovel"
	result = /obj/item/shovel/wood
	reqs = list(
		list(/obj/item/stack/material/stick = 5),
		list(/obj/item/stack/material/wood = 1),
		list(/obj/item/stack/material/fiber = 3),
		list(/obj/item/stack/material/flint = 1)
	)
	time = 120
	category = CAT_WEAPONRY
	subcategory = CAT_WEAPON

/datum/crafting_recipe/stoneblade
	name = "stone blade"
	result = /obj/item/material/knife/stone
	reqs = list(
		list(/obj/item/stack/material/flint = 2)
	)
	time = 60
	category = CAT_WEAPONRY
	subcategory = CAT_WEAPON

/datum/crafting_recipe/stonewoodknife
	name = "stone knife"
	result = /obj/item/material/knife/stone/wood
	reqs = list(
		list(/obj/item/material/knife/stone = 1),
		list(/obj/item/stack/material/flint = 1),
		list(/obj/item/stack/material/wood = 1),
		list(/obj/item/stack/material/fiber = 3)
	)
	time = 120
	category = CAT_WEAPONRY
	subcategory = CAT_WEAPON

/datum/crafting_recipe/stoneboneknife
	name = "stone knife"
	result = /obj/item/material/knife/stone/bone
	reqs = list(
		list(/obj/item/material/knife/stone = 1),
		list(/obj/item/stack/material/flint = 1),
		list(/obj/item/bone = 1),
		list(/obj/item/stack/material/fiber = 3)
	)
	time = 120
	category = CAT_WEAPONRY
	subcategory = CAT_WEAPON

/datum/crafting_recipe/woodbucket
	name = "wooden bucket"
	result = /obj/item/reagent_containers/glass/bucket/wood
	reqs = list(
		list(/obj/item/stack/material/wood = 1),
		list(/obj/item/stack/material/stick = 1),
		list(/obj/item/stack/material/fiber = 2)
	)
	time = 60
	category = CAT_TOOL

/datum/crafting_recipe/sticks
	name = "sticks"
	result = /obj/item/stack/material/stick/fivestack
	reqs = list(list(/obj/item/stack/material/wood = 1))
	tool_paths = list(/obj/item/material/knife)
	time = 200
	category = CAT_MISC

/datum/crafting_recipe/stonewoodaxe
	name = "stone axe"
	result = /obj/item/material/knife/machete/hatchet/stone
	reqs = list(
		list(/obj/item/material/knife/stone = 1),
		list(/obj/item/stack/material/flint = 1),
		list(/obj/item/stack/material/stick = 1),
		list(/obj/item/stack/material/fiber = 3)
	)
	time = 120
	category = CAT_WEAPONRY
	subcategory = CAT_WEAPON

/datum/crafting_recipe/stoneboneaxe
	name = "stone axe"
	result = /obj/item/material/knife/machete/hatchet/stone/bone
	reqs = list(
		list(/obj/item/material/knife/stone = 1),
		list(/obj/item/stack/material/flint = 1),
		list(/obj/item/bone = 1),
		list(/obj/item/stack/material/fiber = 3)
	)
	time = 120
	category = CAT_WEAPONRY
	subcategory = CAT_WEAPON

/datum/crafting_recipe/stonewoodspear
	name = "stone spear"
	result = /obj/item/material/twohanded/spear/flint
	reqs = list(
		list(/obj/item/material/knife/stone = 1),
		list(/obj/item/stack/material/flint = 1),
		list(/obj/item/stack/material/wood = 2),
		list(/obj/item/stack/material/fiber = 3)
	)
	time = 120
	category = CAT_WEAPONRY
	subcategory = CAT_WEAPON

/datum/crafting_recipe/stonebonespear
	name = "stone spear"
	result = /obj/item/material/twohanded/spear/flint
	reqs = list(
		list(/obj/item/material/knife/stone = 1),
		list(/obj/item/stack/material/flint = 1),
		list(/obj/item/bone = 2),
		list(/obj/item/stack/material/fiber = 3)
	)
	time = 120
	category = CAT_WEAPONRY
	subcategory = CAT_WEAPON

/datum/crafting_recipe/ropebindings
	name = "rope bindings"
	result = /obj/item/handcuffs/cable/plantfiber
	reqs = list(list(/obj/item/stack/material/fiber = 3))
	time = 60
	category = CAT_MISC