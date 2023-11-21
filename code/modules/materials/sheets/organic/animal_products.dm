/obj/item/stack/material/chitin
	name = "chitin"
	desc = "The by-product of mob grinding."
	icon_state = "chitin"
	default_type = MAT_CHITIN
	no_variants = FALSE
	pass_color = TRUE
	strict_color_stacking = TRUE
	drop_sound = 'sound/items/drop/leather.ogg'
	pickup_sound = 'sound/items/pickup/leather.ogg'

//don't see anywhere else to put these, maybe together they could be used to make the xenos suit?
/obj/item/stack/xenochitin
	name = "alien chitin"
	desc = "A piece of the hide of a terrible creature."
	singular_name = "alien chitin piece"
	icon = 'icons/mob/alien.dmi'
	icon_state = "chitin"
	stacktype = "hide-chitin"

/obj/item/xenos_claw
	name = "alien claw"
	desc = "The claw of a terrible creature."
	icon = 'icons/mob/alien.dmi'
	icon_state = "claw"

/obj/item/weed_extract
	name = "weed extract"
	desc = "A piece of slimy, purplish weed."
	icon = 'icons/mob/alien.dmi'
	icon_state = "weed_extract"

/////FUR AND WOOL MATERIALS/////

/datum/material/fur
	name = "fur"
	icon_colour = "#fff2d3"
	stack_origin_tech = list(TECH_MATERIAL = 2)
	display_name = "fur"
	icon_base = "sheet-fabric"
	stack_type = /obj/item/stack/material/fur
	sheet_collective_name = "pile"
	pass_stack_colors = TRUE
	supply_conversion_value = 1
	sheet_singular_name = "bundle"
	sheet_plural_name = "bundles"
	ignition_point = T0C+232
	melting_point = T0C+300
	protectiveness = 1
	flags = MATERIAL_PADDING
	conductive = 0
	integrity = 40
	hardness = 5

/datum/material/fur/wool
	name = "wool"
	display_name = "wool"
	stack_type = /obj/item/stack/material/fur/wool

/datum/material/fur/generate_recipes()
	recipes = list(
		new /datum/stack_recipe("duster", /obj/item/clothing/suit/storage/duster/craftable, 10, time = 15 SECONDS, pass_stack_color = TRUE, recycle_material = "[name]"),
		new /datum/stack_recipe("bedsheet", /obj/item/weapon/bedsheet/craftable, 10, time = 30 SECONDS, pass_stack_color = TRUE, recycle_material = "[name]"),
		new /datum/stack_recipe("jumpsuit", /obj/item/clothing/under/color/white/craftable, 8, time = 15 SECONDS, pass_stack_color = TRUE, recycle_material = "[name]"),
		new /datum/stack_recipe("foot wraps", /obj/item/clothing/shoes/footwraps/craftable, 2, time = 5 SECONDS, pass_stack_color = TRUE, recycle_material = "[name]"),
		new /datum/stack_recipe("gloves", /obj/item/clothing/gloves/white/craftable, 2, time = 5 SECONDS, pass_stack_color = TRUE, recycle_material = "[name]"),
		new /datum/stack_recipe("wig", /obj/item/clothing/head/powdered_wig, 4, time = 10 SECONDS, pass_stack_color = TRUE, recycle_material = "[name]"),
		new /datum/stack_recipe("philosopher's wig", /obj/item/clothing/head/philosopher_wig, 50, time = 2 MINUTES, pass_stack_color = TRUE, recycle_material = "[name]"),
		new /datum/stack_recipe("taqiyah", /obj/item/clothing/head/taqiyah/craftable, 3, time = 6 SECONDS, pass_stack_color = TRUE, recycle_material = "[name]"),
		new /datum/stack_recipe("turban", /obj/item/clothing/head/turban/craftable, 3, time = 6 SECONDS, pass_stack_color = TRUE, recycle_material = "[name]"),
		new /datum/stack_recipe("hijab", /obj/item/clothing/head/hijab/craftable, 3, time = 6 SECONDS, pass_stack_color = TRUE, recycle_material = "[name]"),
		new /datum/stack_recipe("kippa", /obj/item/clothing/head/kippa/craftable, 3, time = 6 SECONDS, pass_stack_color = TRUE, recycle_material = "[name]"),
		new /datum/stack_recipe("scarf", /obj/item/clothing/accessory/scarf/white/craftable, 4, time = 5 SECONDS, pass_stack_color = TRUE, recycle_material = "[name]"),
		new /datum/stack_recipe("baggy pants", /obj/item/clothing/under/pants/baggy/white/craftable, 8, time = 10 SECONDS, pass_stack_color = TRUE, recycle_material = "[name]"),
		new /datum/stack_recipe("belt pouch", /obj/item/weapon/storage/belt/fannypack/white/craftable, 25, time = 1 MINUTE, pass_stack_color = TRUE, recycle_material = "[name]"),
		new /datum/stack_recipe("pouch, small", /obj/item/weapon/storage/pouch/small, 10, time = 20 SECONDS, pass_stack_color = FALSE, recycle_material = "[name]"), //vorestation Add
		new /datum/stack_recipe("pouch, ammo", /obj/item/weapon/storage/pouch/ammo, 10, time = 20 SECONDS, pass_stack_color = FALSE, recycle_material = "[name]"), //vorestation Add
		new /datum/stack_recipe("pouch, tools", /obj/item/weapon/storage/pouch/eng_tool, 10, time = 20 SECONDS, pass_stack_color = FALSE, recycle_material = "[name]"), //vorestation Add
		new /datum/stack_recipe("pouch, parts", /obj/item/weapon/storage/pouch/eng_parts, 10, time = 20 SECONDS, pass_stack_color = FALSE, recycle_material = "[name]"), //vorestation Add
		new /datum/stack_recipe("pouch, supplies", /obj/item/weapon/storage/pouch/eng_supply, 10, time = 20 SECONDS, pass_stack_color = FALSE, recycle_material = "[name]"), //vorestation Add
		new /datum/stack_recipe("pouch, medical", /obj/item/weapon/storage/pouch/medical, 10, time = 20 SECONDS, pass_stack_color = FALSE, recycle_material = "[name]"), //vorestation Add
		new /datum/stack_recipe("pouch, flare", /obj/item/weapon/storage/pouch/flares, 10, time = 20 SECONDS, pass_stack_color = FALSE, recycle_material = "[name]"), //vorestation Add
		new /datum/stack_recipe("crude bandage", /obj/item/stack/medical/crude_pack, 1, time = 2 SECONDS, pass_stack_color = TRUE, recycle_material = "[name]"),
		new /datum/stack_recipe("empty sandbag", /obj/item/stack/emptysandbag, 2, time = 2 SECONDS, pass_stack_color = TRUE, supplied_material = "[name]"),
		new /datum/stack_recipe("satchel", /obj/item/weapon/storage/backpack/satchel/craftable, 30, time = 1 MINUTE, pass_stack_color = TRUE, recycle_material = "[name]"),
		new /datum/stack_recipe("backpack", /obj/item/weapon/storage/backpack/craftable, 30, time = 1 MINUTE, pass_stack_color = TRUE, recycle_material = "[name]"),
		new /datum/stack_recipe("cloak", /obj/item/clothing/accessory/poncho/roles/cloak/custom, 10, time = 15 SECONDS, pass_stack_color = TRUE, recycle_material = "[name]"),
		new /datum/stack_recipe("teshari cloak", /obj/item/clothing/under/teshari/smock/white/craftable, 10, time = 15 SECONDS, pass_stack_color = TRUE, recycle_material = "[name]"),
		new /datum/stack_recipe("teshari beltcloak", /obj/item/clothing/suit/storage/teshari/beltcloak/standard/black_white/craftable, 10, time = 15 SECONDS, pass_stack_color = TRUE, recycle_material = "[name]"),
		new /datum/stack_recipe("bandana", /obj/item/clothing/head/bandana/craftable, 5, time = 5 SECONDS, pass_stack_color = TRUE, recycle_material = "[name]"),
		new /datum/stack_recipe("headband", /obj/item/clothing/head/fluff/headbando/craftable, 5, time = 5 SECONDS, pass_stack_color = TRUE, recycle_material = "[name]"),
		new /datum/stack_recipe("armband", /obj/item/clothing/accessory/armband/med/color/craftable, 5, time = 5 SECONDS, pass_stack_color = TRUE, recycle_material = "[name]"),
		new /datum/stack_recipe("collar", /obj/item/clothing/accessory/collar/craftable, 2, time = 5 SECONDS, pass_stack_color = TRUE, recycle_material = "[name]"),
		new /datum/stack_recipe("blindfold", /obj/item/clothing/glasses/sunglasses/blindfold/whiteblindfold/craftable, 2, time = 5 SECONDS, pass_stack_color = TRUE, recycle_material = "[name]")
	)
/obj/item/stack/material/fur
	name = "fur"
	icon_state = "sheet-fabric"
	default_type = MAT_FUR
	strict_color_stacking = TRUE
	apply_colour = 1
	drop_sound = 'sound/items/drop/clothing.ogg'
	pickup_sound = 'sound/items/pickup/clothing.ogg'
	no_variants = FALSE
	pass_color = TRUE
	apply_colour = TRUE

/obj/item/stack/material/fur/wool
	name = "wool"
	default_type = "wool"

/obj/item/clothing/suit/storage/duster/craftable
	name = "handmade duster"
/obj/item/weapon/bedsheet/craftable
	name = "handmade bedsheet"
/obj/item/clothing/under/color/white/craftable
	name = "handmade jumpsuit"
/obj/item/clothing/shoes/footwraps/craftable
	name = "handmade footwraps"
/obj/item/clothing/gloves/white/craftable
	name = "handmade gloves"
/obj/item/clothing/head/taqiyah/craftable
	name = "handmade taqiyah"
/obj/item/clothing/head/turban/craftable
	name = "handmade turban"
/obj/item/clothing/head/hijab/craftable
	name = "handmade hijab"
/obj/item/clothing/head/kippa/craftable
	name = "handmade kippa"
/obj/item/clothing/accessory/scarf/white/craftable
	name = "handmade scarf"
/obj/item/clothing/under/pants/baggy/white/craftable
	name = "handmade pants"
/obj/item/weapon/storage/belt/fannypack/white/craftable
	name = "handmade fannypack"
/obj/item/weapon/storage/backpack/satchel/craftable
	name = "handmade satchel"
	icon_state = "satchel_white"
	desc = "A handmade satchel, made for holding your things!"
/obj/item/weapon/storage/backpack/craftable
	name = "handmade backpack"
	icon_state = "backpack_white"
/obj/item/clothing/under/teshari/smock/white/craftable
	name = "handmade smock"
/obj/item/clothing/suit/storage/teshari/cloak/standard/white/craftable
	name = "handmade teshari cloak"
/obj/item/clothing/suit/storage/teshari/beltcloak/standard/black_white/craftable
	name = "handmade teshari beltcloak"
/obj/item/clothing/head/bandana/craftable
	name = "handmade bandana"
	icon_state = "bandana-pirate-white"
/obj/item/clothing/head/fluff/headbando/craftable
	name = "handmade bandana"
/obj/item/clothing/accessory/armband/med/color/craftable
	name = "handmade armband"
/obj/item/clothing/accessory/collar/craftable
	name = "handmade collar"
	desc = "A collar made out of pliable material."
	icon_state = "collar_handmade"
	var/given_name
/obj/item/clothing/glasses/sunglasses/blindfold/whiteblindfold/craftable
	name = "handmade blindfold"
	desc = "A handmade blindfold that covers the eyes, preventing sight."

/obj/item/clothing/accessory/collar/craftable/attack_self(mob/living/user as mob)
	given_name = sanitizeSafe(tgui_input_text(usr, "What would you like to label the collar?", "Collar Labelling", null, MAX_NAME_LEN), MAX_NAME_LEN)
