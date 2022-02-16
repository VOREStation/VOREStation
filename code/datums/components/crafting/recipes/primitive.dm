/*
 * Misc
 */

/datum/crafting_recipe/cloth
	name = "Cloth bolt"
	result = /obj/item/stack/material/cloth
	reqs = list(list(/obj/item/stack/material/fiber = 3))
	time = 40
	category = CAT_PRIMAL

/datum/crafting_recipe/crude_bandage
	name = "Crude bandages (x10)"
	result = /obj/item/stack/medical/crude_pack
	reqs = list(list(/obj/item/stack/material/cloth = 2))
	time = 40
	category = CAT_PRIMAL

/*
 * Primitive Clothing
 */

/datum/crafting_recipe/primitive_clothes
	name = "primitive clothes"
	result = /obj/item/clothing/under/primitive
	reqs = list(
		list(/obj/item/stack/material/fiber = 4),
		list(/obj/item/stack/material/cloth = 6)
	)
	time = 90
	category = CAT_CLOTHING

/datum/crafting_recipe/primitive_shoes
	name = "primitive shoes"
	result = /obj/item/clothing/shoes/primitive
	reqs = list(
		list(/obj/item/stack/material/fiber = 2),
		list(/obj/item/stack/material/cloth = 3)
	)
	time = 60
	category = CAT_CLOTHING