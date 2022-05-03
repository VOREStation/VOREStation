/datum/crafting_recipe/stunprod
	name = "Stunprod"
	result = /obj/item/weapon/melee/baton/cattleprod
	reqs = list(list(/obj/item/weapon/handcuffs/cable = 1),
				list(/obj/item/stack/rods = 1),
				list(/obj/item/weapon/tool/wirecutters = 1))
	time = 40
	category = CAT_WEAPONRY
	subcategory = CAT_WEAPON

/datum/crafting_recipe/spear
	name = "Spear"
	result = /obj/item/weapon/material/twohanded/spear
	reqs = list(list(/obj/item/weapon/handcuffs/cable = 1),
				list(/obj/item/stack/rods = 1),
				list(/obj/item/weapon/material/shard = 1,
					 /obj/item/weapon/material/knifeblade = 1)
				)
	parts = list(/obj/item/weapon/material/shard = 1,
				 /obj/item/weapon/material/knifeblade = 1)
	time = 40
	category = CAT_WEAPONRY
	subcategory = CAT_WEAPON

/datum/crafting_recipe/shortbow
	name = "Shortbow"
	result = /obj/item/weapon/gun/launcher/crossbow/bow
	reqs = list(list(/obj/item/stack/material/wood = 10),
		list(/obj/item/stack/material/cloth = 5))
	time = 120
	category = CAT_WEAPONRY
	subcategory = CAT_WEAPON

/datum/crafting_recipe/arrow_sandstone
	name = "Wood arrow (sandstone tip)"
	result = /obj/item/weapon/arrow/standard
	reqs = list(list(/obj/item/stack/material/wood = 2),
		list(/obj/item/stack/material/sandstone = 2))
	time = 40
	category = CAT_WEAPONRY
	subcategory = CAT_AMMO

/datum/crafting_recipe/arrow_marble
	name = "Wood arrow (marble tip)"
	result = /obj/item/weapon/arrow/standard
	reqs = list(list(/obj/item/stack/material/wood = 2),
		list(/obj/item/stack/material/marble = 2))
	time = 40
	category = CAT_WEAPONRY
	subcategory = CAT_AMMO

/datum/crafting_recipe/primitive_shield
	name = "Primitive Shield"
	result = /obj/item/weapon/shield/primitive
	reqs = list(list(/obj/item/stack/material/wood = 2),
		list(/obj/item/weapon/reagent_containers/glass/bucket/wood =1),
		list(/obj/item/stack/material/cloth = 5))
	time = 120
	category = CAT_WEAPONRY
	subcategory = CAT_WEAPON

/datum/crafting_recipe/scrap_bola
	name = "Scrap Bola"
	result = /obj/item/weapon/handcuffs/legcuffs/bola/cable
	reqs = list(list(/obj/item/stack/material/steel = 6),
		list(/obj/item/stack/cable_coil = 12))
	time = 180
	category = CAT_WEAPONRY
	subcategory = CAT_WEAPON

/datum/crafting_recipe/primitive_bola
	name = "Primitive Bola"
	result = /obj/item/weapon/handcuffs/legcuffs/bola
	reqs = list(list(/obj/item/stack/material/flint = 6),
		list(/obj/item/stack/material/cloth = 3),
		list(/obj/item/stack/material/fiber = 6))
	time = 120
	category = CAT_WEAPONRY
	subcategory = CAT_WEAPON

/datum/crafting_recipe/warclub
	name = "Wooden War Club"
	result = /obj/item/weapon/melee/warclub
	reqs = list(list(/obj/item/stack/material/wood = 4),
		list(/obj/item/stack/material/cloth = 3))
	tool_paths = list(/obj/item/weapon/material/knife)
	time = 120
	category = CAT_WEAPONRY
	subcategory = CAT_WEAPON

/*
 * Needs tweaking (or removal, the material code is god awful)
/datum/crafting_recipe/warmace
	name = "Wooden War Mace"
	result = /obj/item/weapon/material/twohanded/warmace
	reqs = list(list(/obj/item/stack/material/wood = 8),
		list(/obj/item/stack/material/cloth = 4))
	tool_paths = list(/obj/item/weapon/material/knife)
	time = 240
	category = CAT_WEAPONRY
	subcategory = CAT_WEAPON
*/

/datum/crafting_recipe/scopedrifle
	name = "Bolt scope to bolt-action (cannot be removed)"
	result = /obj/item/weapon/gun/projectile/shotgun/pump/rifle/scoped
	reqs = list(list(/obj/item/device/binoculars/scope = 1),
		list(/obj/item/weapon/gun/projectile/shotgun/pump/rifle = 1))
	time = 180
	category = CAT_WEAPONRY
	subcategory = CAT_WEAPON