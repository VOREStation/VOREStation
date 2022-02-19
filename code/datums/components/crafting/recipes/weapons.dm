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
					 /obj/item/weapon/material/butterflyblade = 1)
				)
	parts = list(/obj/item/weapon/material/shard = 1,
				 /obj/item/weapon/material/butterflyblade = 1)
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
	reqs = list(list(/obj/item/stack/material/wood = 2), list(/obj/item/weapon/reagent_containers/glass/bucket/wood =1), list(/obj/item/stack/material/cloth = 5))
	time = 120
	category = CAT_WEAPONRY
	subcategory = CAT_WEAPON
