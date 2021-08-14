/datum/crafting_recipe/shovel
	name = "Wooden Shovel"
	result = /obj/item/weapon/shovel/wood
	reqs = list(
		/obj/item/stack/material/stick = 5,
		/obj/item/stack/material/wood = 1,
		/obj/item/stack/material/fiber = 3,
		/obj/item/stack/material/flint = 1
	)
	time = 120
	category = CAT_WEAPONRY
	subcategory = CAT_WEAPON

/datum/crafting_recipe/stoneblade
	name = "stone blade"
	result = /obj/item/weapon/material/knife/stone
	reqs = list(
		/obj/item/stack/material/flint = 2
	)
	time = 60
	category = CAT_WEAPONRY
	subcategory = CAT_WEAPON

/datum/crafting_recipe/stonewoodknife
	name = "stone knife"
	result = /obj/item/weapon/material/knife/stone/wood
	reqs = list(
		/obj/item/weapon/material/knife/stone = 1,
		/obj/item/stack/material/flint = 1,
		/obj/item/stack/material/wood = 1,
		/obj/item/stack/material/fiber = 3
	)
	time = 120
	category = CAT_WEAPONRY
	subcategory = CAT_WEAPON

/datum/crafting_recipe/stoneboneknife
	name = "stone knife"
	result = /obj/item/weapon/material/knife/stone/bone
	reqs = list(
		/obj/item/weapon/material/knife/stone = 1,
		/obj/item/stack/material/flint = 1,
		/obj/item/weapon/bone = 1,
		/obj/item/stack/material/fiber = 3
	)
	time = 120
	category = CAT_WEAPONRY
	subcategory = CAT_WEAPON

/datum/crafting_recipe/woodbucket
	name = "wooden bucket"
	result = /obj/item/weapon/reagent_containers/glass/bucket/wood
	reqs = list(
		/obj/item/stack/material/wood = 1,
		/obj/item/stack/material/stick = 1,
		/obj/item/stack/material/fiber = 2
	)
	time = 60
	category = CAT_TOOL

/datum/crafting_recipe/sticks
	name = "sticks"
	result = /obj/item/stack/material/stick/fivestack
	reqs = list(/obj/item/stack/material/wood = 1)
	tool_paths = list(/obj/item/weapon/material/knife)
	time = 200
	category = CAT_MISC

/datum/crafting_recipe/stonewoodaxe
	name = "stone axe"
	result = /obj/item/weapon/material/knife/machete/hatchet/stone
	reqs = list(
		/obj/item/weapon/material/knife/stone = 1,
		/obj/item/stack/material/flint = 1,
		/obj/item/stack/material/stick = 10,
		/obj/item/stack/material/fiber = 3
	)
	time = 120
	category = CAT_WEAPONRY
	subcategory = CAT_WEAPON

/datum/crafting_recipe/stoneboneaxe
	name = "stone axe"
	result = /obj/item/weapon/material/knife/machete/hatchet/stone/bone
	reqs = list(
		/obj/item/weapon/material/knife/stone = 1,
		/obj/item/stack/material/flint = 1,
		/obj/item/weapon/bone = 1,
		/obj/item/stack/material/fiber = 3
	)
	time = 120
	category = CAT_WEAPONRY
	subcategory = CAT_WEAPON

/datum/crafting_recipe/stonewoodspear
	name = "stone spear"
	result = /obj/item/weapon/material/twohanded/spear/flint
	reqs = list(
		/obj/item/weapon/material/knife/stone = 1,
		/obj/item/stack/material/flint = 1,
		/obj/item/stack/material/wood = 2,
		/obj/item/stack/material/fiber = 3
	)
	time = 120
	category = CAT_WEAPONRY
	subcategory = CAT_WEAPON

/datum/crafting_recipe/stonebonespear
	name = "stone spear"
	result = /obj/item/weapon/material/twohanded/spear/flint
	reqs = list(
		/obj/item/weapon/material/knife/stone = 1,
		/obj/item/stack/material/flint = 1,
		/obj/item/weapon/bone = 2,
		/obj/item/stack/material/fiber = 3
	)
	time = 120
	category = CAT_WEAPONRY
	subcategory = CAT_WEAPON

/datum/crafting_recipe/ropebindings
	name = "rope bindings"
	result = /obj/item/weapon/handcuffs/cable/plantfiber
	reqs = list(/obj/item/stack/material/fiber = 3)
	time = 60
	category = CAT_MISC