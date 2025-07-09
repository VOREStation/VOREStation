/datum/design_techweb/advmop
	name = "advanced mop"
	desc = "An advanced mop with pressured water jets that break away the toughest stains."
	id = "advmop"
	build_type = PROTOLATHE
	materials = list(MAT_STEEL = 5000, MAT_GLASS = 2000, MAT_GOLD = 1000)
	build_path = /obj/item/mop/advanced
	category = list(
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_JANITORIAL
	)
	departmental_flags = DEPARTMENT_BITFLAG_SERVICE

/datum/design_techweb/light_replacer
	name = "Light replacer"
	desc = "A device to automatically replace lights. Refill with working lightbulbs."
	id = "light_replacer"
	build_type = PROTOLATHE
	materials = list(MAT_STEEL = 1500, MAT_SILVER = 150, MAT_GLASS = 3000)
	build_path = /obj/item/lightreplacer
	category = list(
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_JANITORIAL
	)
	departmental_flags = DEPARTMENT_BITFLAG_SERVICE

/datum/design_techweb/spraybottle
	name = "spray bottle"
	desc = "A spray bottle, with an unscrewable top."
	id = "spraybottle"
	build_type = PROTOLATHE
	materials = list(MAT_STEEL = 300, MAT_GLASS = 300)
	build_path = /obj/item/reagent_containers/spray
	category = list(
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_JANITORIAL
	)
	departmental_flags = DEPARTMENT_BITFLAG_SERVICE

/datum/design_techweb/beartrap
	name = "mechanical trap"
	desc = "A mechanically activated leg trap. Low-tech, but reliable. Looks like it could really hurt if you set it off."
	id = "beartrap"
	build_type = PROTOLATHE
	materials = list(MAT_STEEL = 18750)
	build_path = /obj/item/beartrap
	category = list(
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_JANITORIAL
	)
	departmental_flags = DEPARTMENT_BITFLAG_SERVICE
