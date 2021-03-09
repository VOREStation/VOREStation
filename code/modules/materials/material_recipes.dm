/datum/material/proc/get_recipes()
	if(!recipes)
		generate_recipes()
	return recipes

/datum/material/proc/generate_recipes()
	recipes = list()

	// If is_brittle() returns true, these are only good for a single strike.
	recipes += new/datum/stack_recipe("[display_name] baseball bat", /obj/item/weapon/material/twohanded/baseballbat, 10, time = 20, one_per_turf = 0, on_floor = 1, supplied_material = "[name]", pass_stack_color = TRUE)
	recipes += new/datum/stack_recipe("[display_name] ashtray", /obj/item/weapon/material/ashtray, 2, one_per_turf = 1, on_floor = 1, supplied_material = "[name]", pass_stack_color = TRUE)
	recipes += new/datum/stack_recipe("[display_name] spoon", /obj/item/weapon/material/kitchen/utensil/spoon/plastic, 1, on_floor = 1, supplied_material = "[name]", pass_stack_color = TRUE)
	recipes += new/datum/stack_recipe("[display_name] armor plate", /obj/item/weapon/material/armor_plating, 1, time = 20, on_floor = 1, supplied_material = "[name]", pass_stack_color = TRUE)
	recipes += new/datum/stack_recipe("[display_name] armor plate insert", /obj/item/weapon/material/armor_plating/insert, 2, time = 40, on_floor = 1, supplied_material = "[name]", pass_stack_color = TRUE)
	recipes += new/datum/stack_recipe("[display_name] grave marker", /obj/item/weapon/material/gravemarker, 5, time = 50, supplied_material = "[name]", pass_stack_color = TRUE)
	recipes += new/datum/stack_recipe("[display_name] ring", /obj/item/clothing/gloves/ring/material, 1, on_floor = 1, supplied_material = "[name]", pass_stack_color = TRUE)
	recipes += new/datum/stack_recipe("[display_name] bracelet", /obj/item/clothing/accessory/bracelet/material, 1, on_floor = 1, supplied_material = "[name]", pass_stack_color = TRUE)

	if(integrity>=50)
		recipes += new/datum/stack_recipe("[display_name] door", /obj/structure/simple_door, 10, one_per_turf = 1, on_floor = 1, supplied_material = "[name]", pass_stack_color = TRUE)
		recipes += new/datum/stack_recipe("[display_name] barricade", /obj/structure/barricade, 5, time = 50, one_per_turf = 1, on_floor = 1, supplied_material = "[name]", pass_stack_color = TRUE)
		recipes += new/datum/stack_recipe("[display_name] stool", /obj/item/weapon/stool, one_per_turf = 1, on_floor = 1, supplied_material = "[name]", pass_stack_color = TRUE)
		recipes += new/datum/stack_recipe("[display_name] chair", /obj/structure/bed/chair, one_per_turf = 1, on_floor = 1, supplied_material = "[name]", pass_stack_color = TRUE)
		recipes += new/datum/stack_recipe("[display_name] bed", /obj/structure/bed, 2, one_per_turf = 1, on_floor = 1, supplied_material = "[name]", pass_stack_color = TRUE)
		recipes += new/datum/stack_recipe("[display_name] double bed", /obj/structure/bed/double, 4, one_per_turf = 1, on_floor = 1, supplied_material = "[name]", pass_stack_color = TRUE)
		recipes += new/datum/stack_recipe("[display_name] wall girders", /obj/structure/girder, 2, time = 50, one_per_turf = 1, on_floor = 1, supplied_material = "[name]", pass_stack_color = TRUE)

	if(hardness>50)
		recipes += new/datum/stack_recipe("[display_name] fork", /obj/item/weapon/material/kitchen/utensil/fork/plastic, 1, on_floor = 1, supplied_material = "[name]", pass_stack_color = TRUE)
		recipes += new/datum/stack_recipe("[display_name] knife", /obj/item/weapon/material/knife/plastic, 1, on_floor = 1, supplied_material = "[name]", pass_stack_color = TRUE)
		recipes += new/datum/stack_recipe("[display_name] blade", /obj/item/weapon/material/butterflyblade, 6, time = 20, one_per_turf = 0, on_floor = 1, supplied_material = "[name]", pass_stack_color = TRUE)
		recipes += new/datum/stack_recipe("[display_name] defense wire", /obj/item/weapon/material/barbedwire, 10, time = 1 MINUTE, one_per_turf = 0, on_floor = 1, supplied_material = "[name]", pass_stack_color = TRUE)

/datum/material/steel/generate_recipes()
	..()
	recipes += new/datum/stack_recipe_list("office chairs",list( \
		new/datum/stack_recipe("dark office chair", /obj/structure/bed/chair/office/dark, 5, one_per_turf = 1, on_floor = 1, recycle_material = "[name]"), \
		new/datum/stack_recipe("light office chair", /obj/structure/bed/chair/office/light, 5, one_per_turf = 1, on_floor = 1, recycle_material = "[name]") \
		))
	recipes += new/datum/stack_recipe_list("comfy chairs", list( \
		new/datum/stack_recipe("beige comfy chair", /obj/structure/bed/chair/comfy/beige, 2, one_per_turf = 1, on_floor = 1, recycle_material = "[name]"), \
		new/datum/stack_recipe("black comfy chair", /obj/structure/bed/chair/comfy/black, 2, one_per_turf = 1, on_floor = 1, recycle_material = "[name]"), \
		new/datum/stack_recipe("brown comfy chair", /obj/structure/bed/chair/comfy/brown, 2, one_per_turf = 1, on_floor = 1, recycle_material = "[name]"), \
		new/datum/stack_recipe("lime comfy chair", /obj/structure/bed/chair/comfy/lime, 2, one_per_turf = 1, on_floor = 1, recycle_material = "[name]"), \
		new/datum/stack_recipe("teal comfy chair", /obj/structure/bed/chair/comfy/teal, 2, one_per_turf = 1, on_floor = 1, recycle_material = "[name]"), \
		new/datum/stack_recipe("red comfy chair", /obj/structure/bed/chair/comfy/red, 2, one_per_turf = 1, on_floor = 1, recycle_material = "[name]"), \
		new/datum/stack_recipe("blue comfy chair", /obj/structure/bed/chair/comfy/blue, 2, one_per_turf = 1, on_floor = 1, recycle_material = "[name]"), \
		new/datum/stack_recipe("purple comfy chair", /obj/structure/bed/chair/comfy/purp, 2, one_per_turf = 1, on_floor = 1, recycle_material = "[name]"), \
		new/datum/stack_recipe("green comfy chair", /obj/structure/bed/chair/comfy/green, 2, one_per_turf = 1, on_floor = 1, recycle_material = "[name]"), \
		new/datum/stack_recipe("yellow comfy chair", /obj/structure/bed/chair/comfy/yellow, 2, one_per_turf = 1, on_floor = 1, recycle_material = "[name]"), \
		new/datum/stack_recipe("orange comfy chair", /obj/structure/bed/chair/comfy/orange, 2, one_per_turf = 1, on_floor = 1, recycle_material = "[name]"), \
		))
	recipes += new/datum/stack_recipe("table frame", /obj/structure/table, 1, time = 10, one_per_turf = 1, on_floor = 1, recycle_material = "[name]")
	recipes += new/datum/stack_recipe("bench frame", /obj/structure/table/bench, 1, time = 10, one_per_turf = 1, on_floor = 1, recycle_material = "[name]")
	recipes += new/datum/stack_recipe("rack", /obj/structure/table/rack, 1, time = 5, one_per_turf = 1, on_floor = 1, recycle_material = "[name]")
	recipes += new/datum/stack_recipe("closet", /obj/structure/closet, 2, time = 15, one_per_turf = 1, on_floor = 1, recycle_material = "[name]")
	recipes += new/datum/stack_recipe("canister", /obj/machinery/portable_atmospherics/canister, 10, time = 15, one_per_turf = 1, on_floor = 1, recycle_material = "[name]")
	recipes += new/datum/stack_recipe("cannon frame", /obj/item/weapon/cannonframe, 10, time = 15, one_per_turf = 0, on_floor = 0, recycle_material = "[name]")
	recipes += new/datum/stack_recipe("regular floor tile", /obj/item/stack/tile/floor, 1, 4, 20, recycle_material = "[name]")
	recipes += new/datum/stack_recipe("roofing tile", /obj/item/stack/tile/roofing, 3, 4, 20, recycle_material = "[name]")
	recipes += new/datum/stack_recipe("metal rod", /obj/item/stack/rods, 1, 2, 60, recycle_material = "[name]")
	recipes += new/datum/stack_recipe("frame", /obj/item/frame, 5, time = 25, one_per_turf = 1, on_floor = 1, recycle_material = "[name]")
	recipes += new/datum/stack_recipe("mirror frame", /obj/item/frame/mirror, 1, time = 5, one_per_turf = 0, on_floor = 1, recycle_material = "[name]")
	recipes += new/datum/stack_recipe("fire extinguisher cabinet frame", /obj/item/frame/extinguisher_cabinet, 4, time = 5, one_per_turf = 0, on_floor = 1, recycle_material = "[name]")
	//recipes += new/datum/stack_recipe("fire axe cabinet frame", /obj/item/frame/fireaxe_cabinet, 4, time = 5, one_per_turf = 0, on_floor = 1)
	recipes += new/datum/stack_recipe("railing", /obj/structure/railing, 2, time = 50, one_per_turf = 0, on_floor = 1, recycle_material = "[name]")
	recipes += new/datum/stack_recipe("turret frame", /obj/machinery/porta_turret_construct, 5, time = 25, one_per_turf = 1, on_floor = 1, recycle_material = "[name]")
	recipes += new/datum/stack_recipe_list("airlock assemblies", list( \
		new/datum/stack_recipe("standard airlock assembly", /obj/structure/door_assembly, 4, time = 50, one_per_turf = 1, on_floor = 1, recycle_material = "[name]"), \
		new/datum/stack_recipe("command airlock assembly", /obj/structure/door_assembly/door_assembly_com, 4, time = 50, one_per_turf = 1, on_floor = 1, recycle_material = "[name]"), \
		new/datum/stack_recipe("security airlock assembly", /obj/structure/door_assembly/door_assembly_sec, 4, time = 50, one_per_turf = 1, on_floor = 1, recycle_material = "[name]"), \
		new/datum/stack_recipe("eng atmos airlock assembly", /obj/structure/door_assembly/door_assembly_eat, 4, time = 50, one_per_turf = 1, on_floor = 1, recycle_material = "[name]"), \
		new/datum/stack_recipe("engineering airlock assembly", /obj/structure/door_assembly/door_assembly_eng, 4, time = 50, one_per_turf = 1, on_floor = 1, recycle_material = "[name]"), \
		new/datum/stack_recipe("mining airlock assembly", /obj/structure/door_assembly/door_assembly_min, 4, time = 50, one_per_turf = 1, on_floor = 1, recycle_material = "[name]"), \
		new/datum/stack_recipe("atmospherics airlock assembly", /obj/structure/door_assembly/door_assembly_atmo, 4, time = 50, one_per_turf = 1, on_floor = 1, recycle_material = "[name]"), \
		new/datum/stack_recipe("research airlock assembly", /obj/structure/door_assembly/door_assembly_research, 4, time = 50, one_per_turf = 1, on_floor = 1, recycle_material = "[name]"), \
		new/datum/stack_recipe("medical airlock assembly", /obj/structure/door_assembly/door_assembly_med, 4, time = 50, one_per_turf = 1, on_floor = 1, recycle_material = "[name]"), \
		new/datum/stack_recipe("maintenance airlock assembly", /obj/structure/door_assembly/door_assembly_mai, 4, time = 50, one_per_turf = 1, on_floor = 1, recycle_material = "[name]"), \
		new/datum/stack_recipe("external airlock assembly", /obj/structure/door_assembly/door_assembly_ext, 4, time = 50, one_per_turf = 1, on_floor = 1, recycle_material = "[name]"), \
		new/datum/stack_recipe("freezer airlock assembly", /obj/structure/door_assembly/door_assembly_fre, 4, time = 50, one_per_turf = 1, on_floor = 1, recycle_material = "[name]"), \
		new/datum/stack_recipe("airtight hatch assembly", /obj/structure/door_assembly/door_assembly_hatch, 4, time = 50, one_per_turf = 1, on_floor = 1, recycle_material = "[name]"), \
		new/datum/stack_recipe("maintenance hatch assembly", /obj/structure/door_assembly/door_assembly_mhatch, 4, time = 50, one_per_turf = 1, on_floor = 1, recycle_material = "[name]"), \
		new/datum/stack_recipe("high security airlock assembly", /obj/structure/door_assembly/door_assembly_highsecurity, 4, time = 50, one_per_turf = 1, on_floor = 1, recycle_material = "[name]"), \
		new/datum/stack_recipe("voidcraft airlock assembly horizontal", /obj/structure/door_assembly/door_assembly_voidcraft, 4, time = 50, one_per_turf = 1, on_floor = 1, recycle_material = "[name]"), \
		new/datum/stack_recipe("voidcraft airlock assembly vertical", /obj/structure/door_assembly/door_assembly_voidcraft/vertical, 4, time = 50, one_per_turf = 1, on_floor = 1, recycle_material = "[name]"), \
		new/datum/stack_recipe("emergency shutter", /obj/structure/firedoor_assembly, 4, time = 50, one_per_turf = 1, on_floor = 1, recycle_material = "[name]"), \
		new/datum/stack_recipe("multi-tile airlock assembly", /obj/structure/door_assembly/multi_tile, 4, time = 50, one_per_turf = 1, on_floor = 1, recycle_material = "[name]"), \
		))
	//recipes += new/datum/stack_recipe("IV drip", /obj/machinery/iv_drip, 4, time = 20, one_per_turf = 1, on_floor = 1, recycle_material = "[name]")//VOREStation Removal
	recipes += new/datum/stack_recipe("medical stand", /obj/structure/medical_stand, 4, time = 20, one_per_turf = 1, on_floor = 1, recycle_material = "[name]")//VOREStation Replacement
	recipes += new/datum/stack_recipe("conveyor switch", /obj/machinery/conveyor_switch, 2, time = 20, one_per_turf = 1, on_floor = 1, recycle_material = "[name]")
	recipes += new/datum/stack_recipe("grenade casing", /obj/item/weapon/grenade/chem_grenade, recycle_material = "[name]")
	recipes += new/datum/stack_recipe("light fixture frame", /obj/item/frame/light, 2, recycle_material = "[name]")
	recipes += new/datum/stack_recipe("small light fixture frame", /obj/item/frame/light/small, 1, recycle_material = "[name]")
	recipes += new/datum/stack_recipe("floor lamp fixture frame", /obj/machinery/light_construct/flamp, 2, recycle_material = "[name]")
	recipes += new/datum/stack_recipe("apc frame", /obj/item/frame/apc, 2, recycle_material = "[name]")
	recipes += new/datum/stack_recipe_list("modular computer frames", list( \
		new/datum/stack_recipe("modular console frame", /obj/item/modular_computer/console, 20, recycle_material = "[name]"),\
		new/datum/stack_recipe("modular telescreen frame", /obj/item/modular_computer/telescreen, 10, recycle_material = "[name]"),\
		new/datum/stack_recipe("modular laptop frame", /obj/item/modular_computer/laptop, 10, recycle_material = "[name]"),\
		new/datum/stack_recipe("modular tablet frame", /obj/item/modular_computer/tablet, 5, recycle_material = "[name]"),\
	))
	recipes += new/datum/stack_recipe_list("filing cabinets", list( \
		new/datum/stack_recipe("filing cabinet", /obj/structure/filingcabinet, 4, time = 20, one_per_turf = 1, on_floor = 1, recycle_material = "[name]"), \
		new/datum/stack_recipe("tall filing cabinet", /obj/structure/filingcabinet/filingcabinet, 4, time = 20, one_per_turf = 1, on_floor = 1, recycle_material = "[name]"), \
		new/datum/stack_recipe("chest drawer", /obj/structure/filingcabinet/chestdrawer, 4, time = 20, one_per_turf = 1, on_floor = 1, recycle_material = "[name]"), \
		))
	recipes += new/datum/stack_recipe("desk bell", /obj/item/weapon/deskbell, 1, on_floor = 1, supplied_material = "[name]")

/datum/material/plasteel/generate_recipes()
	..()
	recipes += new/datum/stack_recipe("AI core", /obj/structure/AIcore, 4, time = 50, one_per_turf = 1, recycle_material = "[name]")
	recipes += new/datum/stack_recipe("Metal crate", /obj/structure/closet/crate, 10, time = 50, one_per_turf = 1, recycle_material = "[name]")
	recipes += new/datum/stack_recipe("knife grip", /obj/item/weapon/material/butterflyhandle, 4, time = 20, one_per_turf = 0, on_floor = 1, supplied_material = "[name]")
	recipes += new/datum/stack_recipe("dark floor tile", /obj/item/stack/tile/floor/dark, 1, 4, 20, recycle_material = "[name]")
	recipes += new/datum/stack_recipe("roller bed", /obj/item/roller, 5, time = 30, on_floor = 1, recycle_material = "[name]")
	recipes += new/datum/stack_recipe("whetstone", /obj/item/weapon/whetstone, 2, time = 10, recycle_material = "[name]")

/datum/material/stone/generate_recipes()
	..()
	recipes += new/datum/stack_recipe("planting bed", /obj/machinery/portable_atmospherics/hydroponics/soil, 3, time = 10, one_per_turf = 1, on_floor = 1, recycle_material = "[name]")

/datum/material/stone/marble/generate_recipes()
	..()
	recipes += new/datum/stack_recipe("light marble floor tile", /obj/item/stack/tile/wmarble, 1, 4, 20, recycle_material = "[name]")
	recipes += new/datum/stack_recipe("dark marble floor tile", /obj/item/stack/tile/bmarble, 1, 4, 20, recycle_material = "[name]")

/datum/material/plastic/generate_recipes()
	..()
	recipes += new/datum/stack_recipe("plastic crate", /obj/structure/closet/crate/plastic, 10, one_per_turf = 1, on_floor = 1, pass_stack_color = TRUE, recycle_material = "[name]")
	recipes += new/datum/stack_recipe("plastic bag", /obj/item/weapon/storage/bag/plasticbag, 3, on_floor = 1, pass_stack_color = TRUE, recycle_material = "[name]")
	recipes += new/datum/stack_recipe("blood pack", /obj/item/weapon/reagent_containers/blood/empty, 4, on_floor = 0, pass_stack_color = TRUE, recycle_material = "[name]")
	recipes += new/datum/stack_recipe("reagent dispenser cartridge (large)", /obj/item/weapon/reagent_containers/chem_disp_cartridge,        5, on_floor=0, pass_stack_color = TRUE, recycle_material = "[name]") // 500u
	recipes += new/datum/stack_recipe("reagent dispenser cartridge (med)",   /obj/item/weapon/reagent_containers/chem_disp_cartridge/medium, 3, on_floor=0, pass_stack_color = TRUE, recycle_material = "[name]") // 250u
	recipes += new/datum/stack_recipe("reagent dispenser cartridge (small)", /obj/item/weapon/reagent_containers/chem_disp_cartridge/small,  1, on_floor=0, pass_stack_color = TRUE, recycle_material = "[name]") // 100u
	recipes += new/datum/stack_recipe("white floor tile", /obj/item/stack/tile/floor/white, 1, 4, 20, pass_stack_color = TRUE, recycle_material = "[name]")
	recipes += new/datum/stack_recipe("freezer floor tile", /obj/item/stack/tile/floor/freezer, 1, 4, 20, pass_stack_color = TRUE, recycle_material = "[name]")
	recipes += new/datum/stack_recipe("shower curtain", /obj/structure/curtain, 4, time = 15, one_per_turf = 1, on_floor = 1, pass_stack_color = TRUE, recycle_material = "[name]")
	recipes += new/datum/stack_recipe("plastic flaps", /obj/structure/plasticflaps, 4, time = 25, one_per_turf = 1, on_floor = 1, pass_stack_color = TRUE, recycle_material = "[name]")
	recipes += new/datum/stack_recipe("water-cooler", /obj/structure/reagent_dispensers/water_cooler, 4, time = 10, one_per_turf = 1, on_floor = 1, pass_stack_color = TRUE, recycle_material = "[name]")
	recipes += new/datum/stack_recipe("lampshade", /obj/item/weapon/lampshade, 1, time = 1, pass_stack_color = TRUE, recycle_material = "[name]")
	recipes += new/datum/stack_recipe("plastic net", /obj/item/weapon/material/fishing_net, 25, time = 1 MINUTE, pass_stack_color = TRUE, recycle_material = "[name]")
	recipes += new/datum/stack_recipe("plastic fishtank", /obj/item/glass_jar/fish/plastic, 2, time = 30 SECONDS, recycle_material = "[name]")
	recipes += new/datum/stack_recipe("reagent tubing", /obj/item/stack/hose, 1, 4, 20, pass_stack_color = TRUE, recycle_material = "[name]")

/datum/material/wood/generate_recipes()
	..()
	recipes += new/datum/stack_recipe("oar", /obj/item/weapon/oar, 2, time = 30, supplied_material = "[name]", pass_stack_color = TRUE)
	recipes += new/datum/stack_recipe("boat", /obj/vehicle/boat, 20, time = 10 SECONDS, supplied_material = "[name]", pass_stack_color = TRUE)
	recipes += new/datum/stack_recipe("dragon boat", /obj/vehicle/boat/dragon, 50, time = 30 SECONDS, supplied_material = "[name]", pass_stack_color = TRUE)
	recipes += new/datum/stack_recipe("wooden sandals", /obj/item/clothing/shoes/sandal, 1, pass_stack_color = TRUE, recycle_material = "[name]")
	recipes += new/datum/stack_recipe("wood circlet", /obj/item/clothing/head/woodcirclet, 1, pass_stack_color = TRUE, recycle_material = "[name]")
	recipes += new/datum/stack_recipe("clipboard", /obj/item/weapon/clipboard, 1, pass_stack_color = TRUE, recycle_material = "[name]")
	recipes += new/datum/stack_recipe("wood floor tile", /obj/item/stack/tile/wood, 1, 4, 20, pass_stack_color = TRUE, recycle_material = "[name]")
	recipes += new/datum/stack_recipe("wooden chair", /obj/structure/bed/chair/wood, 3, time = 10, one_per_turf = 1, on_floor = 1, pass_stack_color = TRUE, recycle_material = "[name]")
	recipes += new/datum/stack_recipe("crossbow frame", /obj/item/weapon/crossbowframe, 5, time = 25, one_per_turf = 0, on_floor = 0, pass_stack_color = TRUE, recycle_material = "[name]")
	recipes += new/datum/stack_recipe("coffin", /obj/structure/closet/coffin, 5, time = 15, one_per_turf = 1, on_floor = 1, pass_stack_color = TRUE, recycle_material = "[name]")
	recipes += new/datum/stack_recipe("beehive assembly", /obj/item/beehive_assembly, 4, pass_stack_color = TRUE, recycle_material = "[name]")
	recipes += new/datum/stack_recipe("beehive frame", /obj/item/honey_frame, 1, pass_stack_color = TRUE, recycle_material = "[name]")
	recipes += new/datum/stack_recipe("book shelf", /obj/structure/bookcase, 5, time = 15, one_per_turf = 1, on_floor = 1, pass_stack_color = TRUE, recycle_material = "[name]")
	recipes += new/datum/stack_recipe("noticeboard frame", /obj/item/frame/noticeboard, 4, time = 5, one_per_turf = 0, on_floor = 1, pass_stack_color = TRUE, recycle_material = "[name]")
	recipes += new/datum/stack_recipe("wooden bucket", /obj/item/weapon/reagent_containers/glass/bucket/wood, 2, time = 4, one_per_turf = 0, on_floor = 0, pass_stack_color = TRUE, recycle_material = "[name]")
	recipes += new/datum/stack_recipe("coilgun stock", /obj/item/weapon/coilgun_assembly, 5, pass_stack_color = TRUE, recycle_material = "[name]")
	recipes += new/datum/stack_recipe("crude fishing rod", /obj/item/weapon/material/fishing_rod/built, 8, time = 10 SECONDS, pass_stack_color = TRUE, recycle_material = "[name]")
	recipes += new/datum/stack_recipe("wooden standup figure", /obj/structure/barricade/cutout, 5, time = 10 SECONDS, pass_stack_color = TRUE, recycle_material = "[name]") //VOREStation Add
	recipes += new/datum/stack_recipe("noticeboard", /obj/structure/noticeboard, 1, recycle_material = "[name]")

/datum/material/wood/log/generate_recipes()
	recipes = list()
	recipes += new/datum/stack_recipe("bonfire", /obj/structure/bonfire, 5, time = 50, supplied_material = "[name]", pass_stack_color = TRUE, recycle_material = "[name]")

/datum/material/cardboard/generate_recipes()
	..()
	recipes += new/datum/stack_recipe("box", /obj/item/weapon/storage/box, pass_stack_color = TRUE, recycle_material = "[name]")
	recipes += new/datum/stack_recipe("donut box", /obj/item/weapon/storage/box/donut/empty, pass_stack_color = TRUE, recycle_material = "[name]")
	recipes += new/datum/stack_recipe("egg box", /obj/item/weapon/storage/fancy/egg_box, pass_stack_color = TRUE, recycle_material = "[name]")
	recipes += new/datum/stack_recipe("light tubes box", /obj/item/weapon/storage/box/lights/tubes, pass_stack_color = TRUE, recycle_material = "[name]")
	recipes += new/datum/stack_recipe("light bulbs box", /obj/item/weapon/storage/box/lights/bulbs, pass_stack_color = TRUE, recycle_material = "[name]")
	recipes += new/datum/stack_recipe("mouse traps box", /obj/item/weapon/storage/box/mousetraps, pass_stack_color = TRUE, recycle_material = "[name]")
	recipes += new/datum/stack_recipe("cardborg suit", /obj/item/clothing/suit/cardborg, 3, pass_stack_color = TRUE, recycle_material = "[name]")
	recipes += new/datum/stack_recipe("cardborg helmet", /obj/item/clothing/head/cardborg, pass_stack_color = TRUE, recycle_material = "[name]")
	recipes += new/datum/stack_recipe("pizza box", /obj/item/pizzabox, pass_stack_color = TRUE, recycle_material = "[name]")
	recipes += new/datum/stack_recipe_list("folders",list( \
		new/datum/stack_recipe("blue folder", /obj/item/weapon/folder/blue, recycle_material = "[name]"), \
		new/datum/stack_recipe("grey folder", /obj/item/weapon/folder, recycle_material = "[name]"), \
		new/datum/stack_recipe("red folder", /obj/item/weapon/folder/red, recycle_material = "[name]"), \
		new/datum/stack_recipe("white folder", /obj/item/weapon/folder/white, recycle_material = "[name]"), \
		new/datum/stack_recipe("yellow folder", /obj/item/weapon/folder/yellow, recycle_material = "[name]"), \
		))

/datum/material/snow/generate_recipes()
	recipes = list()
	recipes += new/datum/stack_recipe("snowball", /obj/item/weapon/material/snow/snowball, 1, time = 10, recycle_material = "[name]")
	recipes += new/datum/stack_recipe("snow brick", /obj/item/stack/material/snowbrick, 2, time = 10, recycle_material = "[name]")
	recipes += new/datum/stack_recipe("snowman", /obj/structure/snowman, 2, time = 15, recycle_material = "[name]")
	recipes += new/datum/stack_recipe("snow robot", /obj/structure/snowman/borg, 2, time = 10, recycle_material = "[name]")
	recipes += new/datum/stack_recipe("snow spider", /obj/structure/snowman/spider, 3, time = 20, recycle_material = "[name]")

/datum/material/snowbrick/generate_recipes()
	recipes = list()
	recipes += new/datum/stack_recipe("[display_name] door", /obj/structure/simple_door, 10, one_per_turf = 1, on_floor = 1, supplied_material = "[name]")
	recipes += new/datum/stack_recipe("[display_name] barricade", /obj/structure/barricade, 5, time = 50, one_per_turf = 1, on_floor = 1, supplied_material = "[name]")
	recipes += new/datum/stack_recipe("[display_name] stool", /obj/item/weapon/stool, one_per_turf = 1, on_floor = 1, supplied_material = "[name]")
	recipes += new/datum/stack_recipe("[display_name] chair", /obj/structure/bed/chair, one_per_turf = 1, on_floor = 1, supplied_material = "[name]")
	recipes += new/datum/stack_recipe("[display_name] bed", /obj/structure/bed, 2, one_per_turf = 1, on_floor = 1, supplied_material = "[name]")
	recipes += new/datum/stack_recipe("[display_name] double bed", /obj/structure/bed/double, 4, one_per_turf = 1, on_floor = 1, supplied_material = "[name]")
	recipes += new/datum/stack_recipe("[display_name] wall girders", /obj/structure/girder, 2, time = 50, one_per_turf = 1, on_floor = 1, supplied_material = "[name]")
	recipes += new/datum/stack_recipe("[display_name] ashtray", /obj/item/weapon/material/ashtray, 2, one_per_turf = 1, on_floor = 1, supplied_material = "[name]")

/datum/material/wood/sif/generate_recipes()
	..()
	recipes += new/datum/stack_recipe("alien wood floor tile", /obj/item/stack/tile/wood/sif, 1, 4, 20, pass_stack_color = TRUE)
	for(var/datum/stack_recipe/r_recipe in recipes)
		if(r_recipe.title == "wood floor tile")
			recipes -= r_recipe
			continue
		if(r_recipe.title == "wooden chair")
			recipes -= r_recipe
			continue

/datum/material/supermatter/generate_recipes()
	recipes = list()
	recipes += new/datum/stack_recipe("supermatter shard", /obj/machinery/power/supermatter/shard, 30 , one_per_turf = 1, time = 600, on_floor = 1, recycle_material = "[name]")

/datum/material/cloth/generate_recipes()
	recipes = list()
	recipes += new/datum/stack_recipe("woven net", /obj/item/weapon/material/fishing_net, 10, time = 30 SECONDS, pass_stack_color = TRUE, supplied_material = "[name]")
	recipes += new/datum/stack_recipe("bedsheet", /obj/item/weapon/bedsheet, 10, time = 30 SECONDS, pass_stack_color = TRUE, recycle_material = "[name]")
	recipes += new/datum/stack_recipe("uniform", /obj/item/clothing/under/color/white, 8, time = 15 SECONDS, pass_stack_color = TRUE, recycle_material = "[name]")
	recipes += new/datum/stack_recipe("foot wraps", /obj/item/clothing/shoes/footwraps, 2, time = 5 SECONDS, pass_stack_color = TRUE, recycle_material = "[name]")
	recipes += new/datum/stack_recipe("gloves", /obj/item/clothing/gloves/white, 2, time = 5 SECONDS, pass_stack_color = TRUE, recycle_material = "[name]")
	recipes += new/datum/stack_recipe("wig", /obj/item/clothing/head/powdered_wig, 4, time = 10 SECONDS, pass_stack_color = TRUE, recycle_material = "[name]")
	recipes += new/datum/stack_recipe("philosopher's wig", /obj/item/clothing/head/philosopher_wig, 50, time = 2 MINUTES, pass_stack_color = TRUE, recycle_material = "[name]")
	recipes += new/datum/stack_recipe("taqiyah", /obj/item/clothing/head/taqiyah, 3, time = 6 SECONDS, pass_stack_color = TRUE, recycle_material = "[name]")
	recipes += new/datum/stack_recipe("turban", /obj/item/clothing/head/turban, 3, time = 6 SECONDS, pass_stack_color = TRUE, recycle_material = "[name]")
	recipes += new/datum/stack_recipe("hijab", /obj/item/clothing/head/hijab, 3, time = 6 SECONDS, pass_stack_color = TRUE, recycle_material = "[name]")
	recipes += new/datum/stack_recipe("kippa", /obj/item/clothing/head/kippa, 3, time = 6 SECONDS, pass_stack_color = TRUE, recycle_material = "[name]")
	recipes += new/datum/stack_recipe("scarf", /obj/item/clothing/accessory/scarf/white, 4, time = 5 SECONDS, pass_stack_color = TRUE, recycle_material = "[name]")
	recipes += new/datum/stack_recipe("baggy pants", /obj/item/clothing/under/pants/baggy/white, 8, time = 10 SECONDS, pass_stack_color = TRUE, recycle_material = "[name]")
	recipes += new/datum/stack_recipe("belt pouch", /obj/item/weapon/storage/belt/fannypack/white, 25, time = 1 MINUTE, pass_stack_color = TRUE, recycle_material = "[name]")
	recipes += new/datum/stack_recipe("crude bandage", /obj/item/stack/medical/crude_pack, 1, time = 2 SECONDS, pass_stack_color = TRUE, recycle_material = "[name]")
	recipes += new/datum/stack_recipe("empty sandbag", /obj/item/stack/emptysandbag, 2, time = 2 SECONDS, pass_stack_color = TRUE, supplied_material = "[name]")

/datum/material/resin/generate_recipes()
	recipes = list()
	recipes += new/datum/stack_recipe("[display_name] door", /obj/structure/simple_door/resin, 10, one_per_turf = 1, on_floor = 1, supplied_material = "[name]", pass_stack_color = TRUE)
	recipes += new/datum/stack_recipe("[display_name] barricade", /obj/effect/alien/resin/wall, 5, time = 5 SECONDS, one_per_turf = 1, on_floor = 1, pass_stack_color = TRUE, recycle_material = "[name]")
	recipes += new/datum/stack_recipe("[display_name] nest", /obj/structure/bed/nest, 2, one_per_turf = 1, on_floor = 1, supplied_material = "[name]", pass_stack_color = TRUE)
	recipes += new/datum/stack_recipe("[display_name] wall girders", /obj/structure/girder/resin, 2, time = 5 SECONDS, one_per_turf = 1, on_floor = 1, supplied_material = "[name]", pass_stack_color = TRUE)
	recipes += new/datum/stack_recipe("crude [display_name] bandage", /obj/item/stack/medical/crude_pack, 1, time = 2 SECONDS, pass_stack_color = TRUE, recycle_material = "[name]")
	recipes += new/datum/stack_recipe("[display_name] net", /obj/item/weapon/material/fishing_net, 10, time = 5 SECONDS, supplied_material = "[name]", pass_stack_color = TRUE)
	recipes += new/datum/stack_recipe("[display_name] membrane", /obj/effect/alien/resin/membrane, 1, time = 2 SECONDS, pass_stack_color = TRUE, recycle_material = "[name]")
	recipes += new/datum/stack_recipe("[display_name] node", /obj/effect/alien/weeds/node, 1, time = 4 SECONDS, recycle_material = "[name]")

/datum/material/leather/generate_recipes()
	recipes = list()
	recipes += new/datum/stack_recipe("bedsheet", /obj/item/weapon/bedsheet, 10, time = 30 SECONDS, pass_stack_color = TRUE, recycle_material = "[name]")
	recipes += new/datum/stack_recipe("uniform", /obj/item/clothing/under/color/white, 8, time = 15 SECONDS, pass_stack_color = TRUE, recycle_material = "[name]")
	recipes += new/datum/stack_recipe("foot wraps", /obj/item/clothing/shoes/footwraps, 2, time = 5 SECONDS, pass_stack_color = TRUE, recycle_material = "[name]")
	recipes += new/datum/stack_recipe("gloves", /obj/item/clothing/gloves/white, 2, time = 5 SECONDS, pass_stack_color = TRUE, recycle_material = "[name]")
	recipes += new/datum/stack_recipe("wig", /obj/item/clothing/head/powdered_wig, 4, time = 10 SECONDS, pass_stack_color = TRUE, recycle_material = "[name]")
	recipes += new/datum/stack_recipe("philosopher's wig", /obj/item/clothing/head/philosopher_wig, 50, time = 2 MINUTES, pass_stack_color = TRUE, recycle_material = "[name]")
	recipes += new/datum/stack_recipe("taqiyah", /obj/item/clothing/head/taqiyah, 3, time = 6 SECONDS, pass_stack_color = TRUE, recycle_material = "[name]")
	recipes += new/datum/stack_recipe("turban", /obj/item/clothing/head/turban, 3, time = 6 SECONDS, pass_stack_color = TRUE, recycle_material = "[name]")
	recipes += new/datum/stack_recipe("hijab", /obj/item/clothing/head/hijab, 3, time = 6 SECONDS, pass_stack_color = TRUE, recycle_material = "[name]")
	recipes += new/datum/stack_recipe("kippa", /obj/item/clothing/head/kippa, 3, time = 6 SECONDS, pass_stack_color = TRUE, recycle_material = "[name]")
	recipes += new/datum/stack_recipe("scarf", /obj/item/clothing/accessory/scarf/white, 4, time = 5 SECONDS, pass_stack_color = TRUE, recycle_material = "[name]")
	recipes += new/datum/stack_recipe("baggy pants", /obj/item/clothing/under/pants/baggy/white, 8, time = 10 SECONDS, pass_stack_color = TRUE, recycle_material = "[name]")
	recipes += new/datum/stack_recipe("belt pouch", /obj/item/weapon/storage/belt/fannypack/white, 25, time = 1 MINUTE, pass_stack_color = TRUE, recycle_material = "[name]")
	recipes += new/datum/stack_recipe("crude [display_name] bandage", /obj/item/stack/medical/crude_pack, 1, time = 2 SECONDS, pass_stack_color = TRUE, recycle_material = "[name]")
	recipes += new/datum/stack_recipe("[display_name] net", /obj/item/weapon/material/fishing_net, 10, time = 5 SECONDS, supplied_material = "[name]", pass_stack_color = TRUE)
	recipes += new/datum/stack_recipe("[display_name] ring", /obj/item/clothing/gloves/ring/material, 1, on_floor = 1, supplied_material = "[name]", pass_stack_color = TRUE)
	recipes += new/datum/stack_recipe("[display_name] bracelet", /obj/item/clothing/accessory/bracelet/material, 1, on_floor = 1, supplied_material = "[name]", pass_stack_color = TRUE)
	recipes += new/datum/stack_recipe("[display_name] armor plate", /obj/item/weapon/material/armor_plating, 1, time = 20, on_floor = 1, supplied_material = "[name]", pass_stack_color = TRUE)
	recipes += new/datum/stack_recipe("empty sandbag", /obj/item/stack/emptysandbag, 2, time = 2 SECONDS, pass_stack_color = TRUE, supplied_material = "[name]")
	recipes += new/datum/stack_recipe("whip", /obj/item/weapon/material/whip, 5, time = 15 SECONDS, pass_stack_color = TRUE, supplied_material = "[name]")
