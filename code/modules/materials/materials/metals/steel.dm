/datum/material/steel
	name = MAT_STEEL
	stack_type = /obj/item/stack/material/steel
	integrity = 150
	conductivity = 11 // Assuming this is carbon steel, it would actually be slightly less conductive than iron, but lets ignore that.
	protectiveness = 10 // 33%
	icon_base = "solid"
	icon_reinf = "reinf_over"
	icon_colour = "#666666"

/datum/material/steel/generate_recipes()
	..()
	recipes += list(
		new /datum/stack_recipe_list("office chairs",list(
			new /datum/stack_recipe("dark office chair", /obj/structure/bed/chair/office/dark, 5, one_per_turf = 1, on_floor = 1, recycle_material = "[name]"),
			new /datum/stack_recipe("light office chair", /obj/structure/bed/chair/office/light, 5, one_per_turf = 1, on_floor = 1, recycle_material = "[name]")
			)),
		new /datum/stack_recipe_list("comfy chairs", list(
			new /datum/stack_recipe("beige comfy chair", /obj/structure/bed/chair/comfy/beige, 2, one_per_turf = 1, on_floor = 1, recycle_material = "[name]"),
			new /datum/stack_recipe("black comfy chair", /obj/structure/bed/chair/comfy/black, 2, one_per_turf = 1, on_floor = 1, recycle_material = "[name]"),
			new /datum/stack_recipe("brown comfy chair", /obj/structure/bed/chair/comfy/brown, 2, one_per_turf = 1, on_floor = 1, recycle_material = "[name]"),
			new /datum/stack_recipe("lime comfy chair", /obj/structure/bed/chair/comfy/lime, 2, one_per_turf = 1, on_floor = 1, recycle_material = "[name]"),
			new /datum/stack_recipe("teal comfy chair", /obj/structure/bed/chair/comfy/teal, 2, one_per_turf = 1, on_floor = 1, recycle_material = "[name]"),
			new /datum/stack_recipe("red comfy chair", /obj/structure/bed/chair/comfy/red, 2, one_per_turf = 1, on_floor = 1, recycle_material = "[name]"),
			new /datum/stack_recipe("blue comfy chair", /obj/structure/bed/chair/comfy/blue, 2, one_per_turf = 1, on_floor = 1, recycle_material = "[name]"),
			new /datum/stack_recipe("purple comfy chair", /obj/structure/bed/chair/comfy/purp, 2, one_per_turf = 1, on_floor = 1, recycle_material = "[name]"),
			new /datum/stack_recipe("green comfy chair", /obj/structure/bed/chair/comfy/green, 2, one_per_turf = 1, on_floor = 1, recycle_material = "[name]"),
			new /datum/stack_recipe("yellow comfy chair", /obj/structure/bed/chair/comfy/yellow, 2, one_per_turf = 1, on_floor = 1, recycle_material = "[name]"),
			new /datum/stack_recipe("orange comfy chair", /obj/structure/bed/chair/comfy/orange, 2, one_per_turf = 1, on_floor = 1, recycle_material = "[name]"),
		)),
		new /datum/stack_recipe_list("airlock assemblies", list(
			new /datum/stack_recipe("standard airlock assembly", /obj/structure/door_assembly, 4, time = 50, one_per_turf = 1, on_floor = 1, recycle_material = "[name]"),
			new /datum/stack_recipe("command airlock assembly", /obj/structure/door_assembly/door_assembly_com, 4, time = 50, one_per_turf = 1, on_floor = 1, recycle_material = "[name]"),
			new /datum/stack_recipe("security airlock assembly", /obj/structure/door_assembly/door_assembly_sec, 4, time = 50, one_per_turf = 1, on_floor = 1, recycle_material = "[name]"),
			new /datum/stack_recipe("eng atmos airlock assembly", /obj/structure/door_assembly/door_assembly_eat, 4, time = 50, one_per_turf = 1, on_floor = 1, recycle_material = "[name]"),
			new /datum/stack_recipe("engineering airlock assembly", /obj/structure/door_assembly/door_assembly_eng, 4, time = 50, one_per_turf = 1, on_floor = 1, recycle_material = "[name]"),
			new /datum/stack_recipe("mining airlock assembly", /obj/structure/door_assembly/door_assembly_min, 4, time = 50, one_per_turf = 1, on_floor = 1, recycle_material = "[name]"),
			new /datum/stack_recipe("atmospherics airlock assembly", /obj/structure/door_assembly/door_assembly_atmo, 4, time = 50, one_per_turf = 1, on_floor = 1, recycle_material = "[name]"),
			new /datum/stack_recipe("research airlock assembly", /obj/structure/door_assembly/door_assembly_research, 4, time = 50, one_per_turf = 1, on_floor = 1, recycle_material = "[name]"),
			new /datum/stack_recipe("medical airlock assembly", /obj/structure/door_assembly/door_assembly_med, 4, time = 50, one_per_turf = 1, on_floor = 1, recycle_material = "[name]"),
			new /datum/stack_recipe("maintenance airlock assembly", /obj/structure/door_assembly/door_assembly_mai, 4, time = 50, one_per_turf = 1, on_floor = 1, recycle_material = "[name]"),
			new /datum/stack_recipe("external airlock assembly", /obj/structure/door_assembly/door_assembly_ext, 4, time = 50, one_per_turf = 1, on_floor = 1, recycle_material = "[name]"),
			new /datum/stack_recipe("freezer airlock assembly", /obj/structure/door_assembly/door_assembly_fre, 4, time = 50, one_per_turf = 1, on_floor = 1, recycle_material = "[name]"),
			new /datum/stack_recipe("airtight hatch assembly", /obj/structure/door_assembly/door_assembly_hatch, 4, time = 50, one_per_turf = 1, on_floor = 1, recycle_material = "[name]"),
			new /datum/stack_recipe("maintenance hatch assembly", /obj/structure/door_assembly/door_assembly_mhatch, 4, time = 50, one_per_turf = 1, on_floor = 1, recycle_material = "[name]"),
			new /datum/stack_recipe("high security airlock assembly", /obj/structure/door_assembly/door_assembly_highsecurity, 4, time = 50, one_per_turf = 1, on_floor = 1, recycle_material = "[name]"),
			new /datum/stack_recipe("voidcraft airlock assembly horizontal", /obj/structure/door_assembly/door_assembly_voidcraft, 4, time = 50, one_per_turf = 1, on_floor = 1, recycle_material = "[name]"),
			new /datum/stack_recipe("voidcraft airlock assembly vertical", /obj/structure/door_assembly/door_assembly_voidcraft/vertical, 4, time = 50, one_per_turf = 1, on_floor = 1, recycle_material = "[name]"),
			new /datum/stack_recipe("emergency shutter", /obj/structure/firedoor_assembly, 4, time = 50, one_per_turf = 1, on_floor = 1, recycle_material = "[name]"),
			new /datum/stack_recipe("multi-tile airlock assembly", /obj/structure/door_assembly/multi_tile, 4, time = 50, one_per_turf = 1, on_floor = 1, recycle_material = "[name]"),
		)),
		new /datum/stack_recipe_list("modular computer frames", list(
			new /datum/stack_recipe("modular console frame", /obj/item/modular_computer/console, 20, recycle_material = "[name]"),\
			new /datum/stack_recipe("modular telescreen frame", /obj/item/modular_computer/telescreen, 10, recycle_material = "[name]"),\
			new /datum/stack_recipe("modular laptop frame", /obj/item/modular_computer/laptop, 10, recycle_material = "[name]"),\
			new /datum/stack_recipe("modular tablet frame", /obj/item/modular_computer/tablet, 5, recycle_material = "[name]"),\
		)),
		new /datum/stack_recipe_list("filing cabinets", list(
			new /datum/stack_recipe("filing cabinet", /obj/structure/filingcabinet, 4, time = 20, one_per_turf = 1, on_floor = 1, recycle_material = "[name]"),
			new /datum/stack_recipe("tall filing cabinet", /obj/structure/filingcabinet/filingcabinet, 4, time = 20, one_per_turf = 1, on_floor = 1, recycle_material = "[name]"),
			new /datum/stack_recipe("chest drawer", /obj/structure/filingcabinet/chestdrawer, 4, time = 20, one_per_turf = 1, on_floor = 1, recycle_material = "[name]"),
		)),
		new /datum/stack_recipe("table frame", /obj/structure/table, 1, time = 10, one_per_turf = 1, on_floor = 1, recycle_material = "[name]"),
		new /datum/stack_recipe("bench frame", /obj/structure/table/bench, 1, time = 10, one_per_turf = 1, on_floor = 1, recycle_material = "[name]"),
		new /datum/stack_recipe("rack", /obj/structure/table/rack, 1, time = 5, one_per_turf = 1, on_floor = 1, recycle_material = "[name]"),
		new /datum/stack_recipe("closet", /obj/structure/closet, 2, time = 15, one_per_turf = 1, on_floor = 1, recycle_material = "[name]"),
		new /datum/stack_recipe("canister", /obj/machinery/portable_atmospherics/canister, 10, time = 15, one_per_turf = 1, on_floor = 1, recycle_material = "[name]"),
		new /datum/stack_recipe("cannon frame", /obj/item/weapon/cannonframe, 10, time = 15, one_per_turf = 0, on_floor = 0, recycle_material = "[name]"),
		new /datum/stack_recipe("regular floor tile", /obj/item/stack/tile/floor, 1, 4, 20, recycle_material = "[name]"),
		new /datum/stack_recipe("roofing tile", /obj/item/stack/tile/roofing, 3, 4, 20, recycle_material = "[name]"),
		new /datum/stack_recipe("metal rod", /obj/item/stack/rods, 1, 2, 60, recycle_material = "[name]"),
		new /datum/stack_recipe("frame", /obj/item/frame, 5, time = 25, one_per_turf = 1, on_floor = 1, recycle_material = "[name]"),
		new /datum/stack_recipe("mirror frame", /obj/item/frame/mirror, 1, time = 5, one_per_turf = 0, on_floor = 1, recycle_material = "[name]"),
		new /datum/stack_recipe("fire extinguisher cabinet frame", /obj/item/frame/extinguisher_cabinet, 4, time = 5, one_per_turf = 0, on_floor = 1, recycle_material = "[name]"),
		new /datum/stack_recipe("railing", /obj/structure/railing, 2, time = 50, one_per_turf = 0, on_floor = 1, recycle_material = "[name]"),
		new /datum/stack_recipe("turret frame", /obj/machinery/porta_turret_construct, 5, time = 25, one_per_turf = 1, on_floor = 1, recycle_material = "[name]"),
		//new /datum/stack_recipe("IV drip", /obj/machinery/iv_drip, 4, time = 20, one_per_turf = 1, on_floor = 1, recycle_material = "[name]"), //VOREStation Removal
		new /datum/stack_recipe("medical stand", /obj/structure/medical_stand, 4, time = 20, one_per_turf = 1, on_floor = 1, recycle_material = "[name]"), //VOREStation Replacement,
		new /datum/stack_recipe("conveyor switch", /obj/machinery/conveyor_switch, 2, time = 20, one_per_turf = 1, on_floor = 1, recycle_material = "[name]"),
		new /datum/stack_recipe("grenade casing", /obj/item/weapon/grenade/chem_grenade, recycle_material = "[name]"),
		new /datum/stack_recipe("light fixture frame", /obj/item/frame/light, 2, recycle_material = "[name]"),
		new /datum/stack_recipe("floor light fixture frame", /obj/machinery/light_construct/floortube, 2, recycle_material = "[name]"),
		new /datum/stack_recipe("small light fixture frame", /obj/item/frame/light/small, 1, recycle_material = "[name]"),
		new /datum/stack_recipe("floor lamp fixture frame", /obj/machinery/light_construct/flamp, 2, recycle_material = "[name]"),
		new /datum/stack_recipe("big floor lamp fixture frame", /obj/machinery/light_construct/bigfloorlamp, 3, recycle_material = "[name]"),
		new /datum/stack_recipe("apc frame", /obj/item/frame/apc, 2, recycle_material = "[name]"),
		new /datum/stack_recipe("desk bell", /obj/item/weapon/deskbell, 1, on_floor = 1, supplied_material = "[name]"),
		new /datum/stack_recipe("tanning rack", /obj/structure/tanning_rack, 3, one_per_turf = TRUE, time = 20, on_floor = TRUE, supplied_material = "[name]")
	)