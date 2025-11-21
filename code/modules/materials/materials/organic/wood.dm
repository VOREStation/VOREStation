/datum/material/wood
	name = MAT_WOOD
	stack_type = /obj/item/stack/material/wood
	icon_colour = "#9c5930"
	integrity = 50
	icon_base = "wood"
	explosion_resistance = 2
	shard_type = SHARD_SPLINTER
	shard_can_repair = 0 // you can't weld splinters back into planks
	hardness = 15
	weight = 18
	protectiveness = 8 // 28%
	conductive = 0
	conductivity = 1
	melting_point = T0C+300 //okay, not melting in this case, but hot enough to destroy wood
	ignition_point = T0C+288
	stack_origin_tech = list(TECH_MATERIAL = 1, TECH_BIO = 1)
	dooropen_noise = 'sound/effects/doorcreaky.ogg'
	door_icon_base = "wood"
	destruction_desc = "splinters"
	sheet_singular_name = "plank"
	sheet_plural_name = "planks"

/datum/material/wood/generate_recipes()
	..()
	recipes += list(
		new /datum/stack_recipe("oar", /obj/item/oar, 2, time = 30, supplied_material = "[name]", pass_stack_color = TRUE),
		new /datum/stack_recipe("boat", /obj/vehicle/boat, 20, time = 10 SECONDS, supplied_material = "[name]", pass_stack_color = TRUE),
		new /datum/stack_recipe("dragon boat", /obj/vehicle/boat/dragon, 50, time = 30 SECONDS, supplied_material = "[name]", pass_stack_color = TRUE),
		new /datum/stack_recipe("wooden sandals", /obj/item/clothing/shoes/sandal, 1, pass_stack_color = TRUE, recycle_material = "[name]"),
		new /datum/stack_recipe("wood circlet", /obj/item/clothing/head/woodcirclet, 1, pass_stack_color = TRUE, recycle_material = "[name]"),
		new /datum/stack_recipe("clipboard", /obj/item/clipboard, 1, pass_stack_color = TRUE, recycle_material = "[name]"),
		new /datum/stack_recipe("wood floor tile", /obj/item/stack/tile/wood, 1, 4, 20, pass_stack_color = FALSE, recycle_material = "[name]"),
		new /datum/stack_recipe("large wood floor tile", /obj/item/stack/tile/wood/panel, 1, 4, 20, pass_stack_color = FALSE, recycle_material = "[name]"),
		new /datum/stack_recipe("parquet wood floor tile", /obj/item/stack/tile/wood/parquet, 1, 4, 20, pass_stack_color = FALSE, recycle_material = "[name]"),
		new /datum/stack_recipe("tiled wood floor tile", /obj/item/stack/tile/wood/tile, 1, 4, 20, pass_stack_color = FALSE, recycle_material = "[name]"),
		new /datum/stack_recipe("vertical wood floor tile", /obj/item/stack/tile/wood/vert, 1, 4, 20, pass_stack_color = FALSE, recycle_material = "[name]"),
		new /datum/stack_recipe("vertical large wood floor tile", /obj/item/stack/tile/wood/vert_panel, 1, 4, 20, pass_stack_color = FALSE, recycle_material = "[name]"),
		new /datum/stack_recipe("wooden chair", /obj/structure/bed/chair/wood, 3, time = 10, one_per_turf = 1, on_floor = 1, pass_stack_color = TRUE, recycle_material = "[name]"),
		new /datum/stack_recipe("crossbow frame", /obj/item/crossbowframe, 5, time = 25, one_per_turf = 0, on_floor = 0, pass_stack_color = TRUE, recycle_material = "[name]"),
		new /datum/stack_recipe("coffin", /obj/structure/closet/coffin, 5, time = 15, one_per_turf = 1, on_floor = 1, pass_stack_color = TRUE, recycle_material = "[name]"),
		new /datum/stack_recipe("beehive assembly", /obj/item/beehive_assembly, 4, pass_stack_color = TRUE, recycle_material = "[name]"),
		new /datum/stack_recipe("beehive frame", /obj/item/honey_frame, 1, pass_stack_color = TRUE, recycle_material = "[name]"),
		new /datum/stack_recipe("book shelf", /obj/structure/bookcase, 5, time = 15, one_per_turf = 1, on_floor = 1, pass_stack_color = TRUE, recycle_material = "[name]"),
		new /datum/stack_recipe("wooden shelves", /obj/structure/table/rack/shelf/wood, 1, one_per_turf = TRUE, time = 5, on_floor = TRUE, recycle_material = "[name]"),
		new /datum/stack_recipe("noticeboard frame", /obj/item/frame/noticeboard, 4, time = 5, one_per_turf = 0, on_floor = 1, pass_stack_color = TRUE, recycle_material = "[name]"),
		new /datum/stack_recipe("coilgun stock", /obj/item/coilgun_assembly, 5, pass_stack_color = TRUE, recycle_material = "[name]"),
		new /datum/stack_recipe("crude fishing rod", /obj/item/material/fishing_rod/built, 8, time = 10 SECONDS, pass_stack_color = TRUE, recycle_material = "[name]"),
		new /datum/stack_recipe("wooden standup figure", /obj/structure/barricade/cutout, 5, time = 10 SECONDS, pass_stack_color = TRUE, recycle_material = "[name]"), //VOREStation Add
		new /datum/stack_recipe("noticeboard", /obj/structure/noticeboard, 1, recycle_material = "[name]"),
		new /datum/stack_recipe("tanning rack", /obj/structure/tanning_rack, 3, one_per_turf = TRUE, time = 20, on_floor = TRUE, supplied_material = "[name]"),
		new /datum/stack_recipe("painting easel", /obj/structure/easel, 5, one_per_turf = TRUE, time = 20, on_floor = TRUE, supplied_material = "[name]"),
		new /datum/stack_recipe("painting frame", /obj/item/frame/painting, 5, one_per_turf = TRUE, time = 20, on_floor = TRUE, supplied_material = "[name]"),
		new /datum/stack_recipe("roofing tile", /obj/item/stack/tile/roofing, 3, 4, 20, recycle_material = "[name]"),
		new /datum/stack_recipe("shovel", /obj/item/shovel/wood, 2, time = 10, on_floor = TRUE, supplied_material = "[name]")
	)

/datum/material/wood/sif
	name = MAT_SIFWOOD
	stack_type = /obj/item/stack/material/wood/sif
	icon_colour = "#0099cc" // Cyan-ish
	stack_origin_tech = list(TECH_MATERIAL = 2, TECH_BIO = 2) // Alien wood would presumably be more interesting to the analyzer.

/datum/material/wood/sif/generate_recipes()
	..()
	recipes += new /datum/stack_recipe("alien wood floor tile", /obj/item/stack/tile/wood/sif, 1, 4, 20, pass_stack_color = FALSE)
	recipes += new /datum/stack_recipe("large alien wood floor tile", /obj/item/stack/tile/wood/sif/panel, 1, 4, 20, pass_stack_color = FALSE)
	recipes += new /datum/stack_recipe("alien wood parquet tile", /obj/item/stack/tile/wood/sif/parquet, 1, 4, 20, pass_stack_color = FALSE)
	recipes += new /datum/stack_recipe("tiled alien wood floor tile", /obj/item/stack/tile/wood/sif/tile, 1, 4, 20, pass_stack_color = FALSE)
	recipes += new /datum/stack_recipe("vertical alien wood floor tile", /obj/item/stack/tile/wood/sif/vert, 1, 4, 20, pass_stack_color = FALSE)
	recipes += new /datum/stack_recipe("vertical large alien wood floor tile", /obj/item/stack/tile/wood/sif/vert_panel, 1, 4, 20, pass_stack_color = FALSE)
	for(var/datum/stack_recipe/r_recipe in recipes)
		if(r_recipe.title == "wood floor tile")
			recipes -= r_recipe
			continue
		if(r_recipe.title == "large wood floor tile")
			recipes -= r_recipe
			continue
		if(r_recipe.title == "parquet wood floor tile")
			recipes -= r_recipe
			continue
		if(r_recipe.title == "tiled wood floor tile")
			recipes -= r_recipe
			continue
		if(r_recipe.title == "vertical wood floor tile")
			recipes -= r_recipe
			continue
		if(r_recipe.title == "vertical large wood floor tile")
			recipes -= r_recipe
			continue
		if(r_recipe.title == "wooden chair")
			recipes -= r_recipe
			continue

/datum/material/wood/hardwood
	name = MAT_HARDWOOD
	stack_type = /obj/item/stack/material/wood/hard
	icon_colour = "#42291a"
	icon_base = "stone"
	table_icon_base = "stone"
	icon_reinf = "reinf_stone"
	integrity = 65	//a bit stronger than regular wood
	hardness = 20
	weight = 20	//likewise, heavier

/datum/material/wood/hardwood/generate_recipes()
	..()
	recipes += new /datum/stack_recipe("hardwood floor tile", /obj/item/stack/tile/wood/hardwood, 1, 4, 20, pass_stack_color = FALSE, recycle_material = "[name]")
	recipes += new /datum/stack_recipe("large hardwood floor tile", /obj/item/stack/tile/wood/hardwood/panel, 1, 4, 20, pass_stack_color = FALSE, recycle_material = "[name]")
	recipes += new /datum/stack_recipe("parquet hardwood floor tile", /obj/item/stack/tile/wood/hardwood/parquet, 1, 4, 20, pass_stack_color = FALSE, recycle_material = "[name]")
	recipes += new /datum/stack_recipe("tiled hardwood floor tile", /obj/item/stack/tile/wood/hardwood/tile, 1, 4, 20, pass_stack_color = FALSE, recycle_material = "[name]")
	recipes += new /datum/stack_recipe("vertical hardwood floor tile", /obj/item/stack/tile/wood/hardwood/vert, 1, 4, 20, pass_stack_color = FALSE)
	recipes += new /datum/stack_recipe("vertical large hardwood floor tile", /obj/item/stack/tile/wood/hardwood/vert_panel, 1, 4, 20, pass_stack_color = FALSE)
	for(var/datum/stack_recipe/r_recipe in recipes)
		if(r_recipe.title == "wood floor tile")
			recipes -= r_recipe
			continue
		if(r_recipe.title == "large wood floor tile")
			recipes -= r_recipe
			continue
		if(r_recipe.title == "parquet wood floor tile")
			recipes -= r_recipe
			continue
		if(r_recipe.title == "tiled wood floor tile")
			recipes -= r_recipe
			continue
		if(r_recipe.title == "vertical wood floor tile")
			recipes -= r_recipe
			continue
		if(r_recipe.title == "vertical large wood floor tile")
			recipes -= r_recipe
			continue
		if(r_recipe.title == "wooden chair")
			recipes -= r_recipe
			continue
		if(r_recipe.title == "wooden standup figure")
			recipes -= r_recipe
			continue

/datum/material/wood/log
	name = MAT_LOG
	display_name = MAT_WOOD // will lead to "wood log"
	icon_base = "log"
	stack_type = /obj/item/stack/material/log
	sheet_singular_name = MAT_LOG
	sheet_plural_name = "logs"
	sheet_collective_name = "pile"
	pass_stack_colors = TRUE
	supply_conversion_value = 1

/datum/material/wood/log/generate_recipes()
	recipes = list(
		new /datum/stack_recipe("bonfire", /obj/structure/bonfire, 5, time = 50, supplied_material = "[name]", pass_stack_color = TRUE, recycle_material = "[name]")
	)

/datum/material/wood/log/sif
	name = MAT_SIFLOG
	display_name = MAT_SIFWOOD
	icon_colour = "#0099cc" // Cyan-ish
	stack_origin_tech = list(TECH_MATERIAL = 2, TECH_BIO = 2)
	stack_type = /obj/item/stack/material/log/sif

/datum/material/wood/log/hard
	name = MAT_HARDLOG
	display_name = MAT_HARDWOOD
	icon_colour = "#6f432a"
	stack_type = /obj/item/stack/material/log/hard

/datum/material/wood/stick
	name = "wooden stick"
	icon_colour = "#824B28"
	display_name = MAT_WOOD
	icon_base = "stick"
	stack_type = /obj/item/stack/material/stick
	sheet_collective_name = "pile"
	pass_stack_colors = TRUE
	supply_conversion_value = 1
	sheet_singular_name = "stick"
	sheet_plural_name = "sticks"

/datum/material/wood/stick/generate_recipes()
	return

/datum/material/wood/birch
	name = MAT_BIRCHWOOD
	stack_type = /obj/item/stack/material/wood/birch
	icon_colour = "#f6dec0"
	icon_base = "wood"
	icon_reinf = "reinf_stone"
	integrity = 65
	hardness = 20
	weight = 20

/datum/material/wood/birch/generate_recipes()
	..()
	recipes += new /datum/stack_recipe("birch floor tile", /obj/item/stack/tile/wood/birch, 1, 4, 20, pass_stack_color = FALSE, recycle_material = "[name]")
	recipes += new /datum/stack_recipe("large birch floor tile", /obj/item/stack/tile/wood/birch/panel, 1, 4, 20, pass_stack_color = FALSE, recycle_material = "[name]")
	recipes += new /datum/stack_recipe("parquet birch floor tile", /obj/item/stack/tile/wood/birch/parquet, 1, 4, 20, pass_stack_color = FALSE, recycle_material = "[name]")
	recipes += new /datum/stack_recipe("tiled birch floor tile", /obj/item/stack/tile/wood/birch/tile, 1, 4, 20, pass_stack_color = FALSE, recycle_material = "[name]")
	recipes += new /datum/stack_recipe("vertical birch floor tile", /obj/item/stack/tile/wood/birch/vert, 1, 4, 20, pass_stack_color = FALSE)
	recipes += new /datum/stack_recipe("vertical large birch floor tile", /obj/item/stack/tile/wood/birch/vert_panel, 1, 4, 20, pass_stack_color = FALSE)
	for(var/datum/stack_recipe/r_recipe in recipes)
		if(r_recipe.title == "wood floor tile")
			recipes -= r_recipe
			continue
		if(r_recipe.title == "large wood floor tile")
			recipes -= r_recipe
			continue
		if(r_recipe.title == "parquet wood floor tile")
			recipes -= r_recipe
			continue
		if(r_recipe.title == "tiled wood floor tile")
			recipes -= r_recipe
			continue
		if(r_recipe.title == "vertical wood floor tile")
			recipes -= r_recipe
			continue
		if(r_recipe.title == "vertical large wood floor tile")
			recipes -= r_recipe
			continue
		if(r_recipe.title == "wooden chair")
			recipes -= r_recipe
			continue
		if(r_recipe.title == "wooden standup figure")
			recipes -= r_recipe
			continue

/datum/material/wood/pine
	name = MAT_PINEWOOD
	stack_type = /obj/item/stack/material/wood/pine
	icon_colour = "#cd9d6f"
	icon_base = "wood"
	icon_reinf = "reinf_stone"
	integrity = 65
	hardness = 20
	weight = 20

/datum/material/wood/pine/generate_recipes()
	..()
	recipes += new /datum/stack_recipe("pine floor tile", /obj/item/stack/tile/wood/pine, 1, 4, 20, pass_stack_color = FALSE, recycle_material = "[name]")
	recipes += new /datum/stack_recipe("large pine floor tile", /obj/item/stack/tile/wood/pine/panel, 1, 4, 20, pass_stack_color = FALSE, recycle_material = "[name]")
	recipes += new /datum/stack_recipe("parquet pine floor tile", /obj/item/stack/tile/wood/pine/parquet, 1, 4, 20, pass_stack_color = FALSE, recycle_material = "[name]")
	recipes += new /datum/stack_recipe("tiled pine floor tile", /obj/item/stack/tile/wood/pine/tile, 1, 4, 20, pass_stack_color = FALSE, recycle_material = "[name]")
	recipes += new /datum/stack_recipe("vertical pine floor tile", /obj/item/stack/tile/wood/pine/vert, 1, 4, 20, pass_stack_color = FALSE)
	recipes += new /datum/stack_recipe("vertical large pine floor tile", /obj/item/stack/tile/wood/pine/vert_panel, 1, 4, 20, pass_stack_color = FALSE)
	for(var/datum/stack_recipe/r_recipe in recipes)
		if(r_recipe.title == "wood floor tile")
			recipes -= r_recipe
			continue
		if(r_recipe.title == "large wood floor tile")
			recipes -= r_recipe
			continue
		if(r_recipe.title == "parquet wood floor tile")
			recipes -= r_recipe
			continue
		if(r_recipe.title == "tiled wood floor tile")
			recipes -= r_recipe
			continue
		if(r_recipe.title == "vertical wood floor tile")
			recipes -= r_recipe
			continue
		if(r_recipe.title == "vertical large wood floor tile")
			recipes -= r_recipe
			continue
		if(r_recipe.title == "wooden chair")
			recipes -= r_recipe
			continue
		if(r_recipe.title == "wooden standup figure")
			recipes -= r_recipe
			continue

/datum/material/wood/oak
	name = MAT_OAKWOOD
	stack_type = /obj/item/stack/material/wood/oak
	icon_colour = "#674928"
	icon_base = "wood"
	icon_reinf = "reinf_stone"
	integrity = 65
	hardness = 20
	weight = 20

/datum/material/wood/oak/generate_recipes()
	..()
	recipes += new /datum/stack_recipe("oak floor tile", /obj/item/stack/tile/wood/oak, 1, 4, 20, pass_stack_color = FALSE, recycle_material = "[name]")
	recipes += new /datum/stack_recipe("large oak floor tile", /obj/item/stack/tile/wood/oak/panel, 1, 4, 20, pass_stack_color = FALSE, recycle_material = "[name]")
	recipes += new /datum/stack_recipe("parquet oak floor tile", /obj/item/stack/tile/wood/oak/parquet, 1, 4, 20, pass_stack_color = FALSE, recycle_material = "[name]")
	recipes += new /datum/stack_recipe("tiled oak floor tile", /obj/item/stack/tile/wood/oak/tile, 1, 4, 20, pass_stack_color = FALSE, recycle_material = "[name]")
	recipes += new /datum/stack_recipe("vertical oak floor tile", /obj/item/stack/tile/wood/oak/vert, 1, 4, 20, pass_stack_color = FALSE)
	recipes += new /datum/stack_recipe("vertical large oak floor tile", /obj/item/stack/tile/wood/oak/vert_panel, 1, 4, 20, pass_stack_color = FALSE)
	for(var/datum/stack_recipe/r_recipe in recipes)
		if(r_recipe.title == "wood floor tile")
			recipes -= r_recipe
			continue
		if(r_recipe.title == "large wood floor tile")
			recipes -= r_recipe
			continue
		if(r_recipe.title == "parquet wood floor tile")
			recipes -= r_recipe
			continue
		if(r_recipe.title == "tiled wood floor tile")
			recipes -= r_recipe
			continue
		if(r_recipe.title == "vertical wood floor tile")
			recipes -= r_recipe
			continue
		if(r_recipe.title == "vertical large wood floor tile")
			recipes -= r_recipe
			continue
		if(r_recipe.title == "wooden chair")
			recipes -= r_recipe
			continue
		if(r_recipe.title == "wooden standup figure")
			recipes -= r_recipe
			continue

/datum/material/wood/acacia
	name = MAT_ACACIAWOOD
	stack_type = /obj/item/stack/material/wood/acacia
	icon_colour = "#b75e12"
	icon_base = "wood"
	icon_reinf = "reinf_stone"
	integrity = 65
	hardness = 20
	weight = 20

/datum/material/wood/acacia/generate_recipes()
	..()
	recipes += new /datum/stack_recipe("acacia floor tile", /obj/item/stack/tile/wood/acacia, 1, 4, 20, pass_stack_color = FALSE, recycle_material = "[name]")
	recipes += new /datum/stack_recipe("large acacia floor tile", /obj/item/stack/tile/wood/acacia/panel, 1, 4, 20, pass_stack_color = FALSE, recycle_material = "[name]")
	recipes += new /datum/stack_recipe("parquet acacia floor tile", /obj/item/stack/tile/wood/acacia/parquet, 1, 4, 20, pass_stack_color = FALSE, recycle_material = "[name]")
	recipes += new /datum/stack_recipe("tiled acacia floor tile", /obj/item/stack/tile/wood/acacia/tile, 1, 4, 20, pass_stack_color = FALSE, recycle_material = "[name]")
	recipes += new /datum/stack_recipe("vertical acacia floor tile", /obj/item/stack/tile/wood/acacia/vert, 1, 4, 20, pass_stack_color = FALSE)
	recipes += new /datum/stack_recipe("vertical large acacia floor tile", /obj/item/stack/tile/wood/acacia/vert_panel, 1, 4, 20, pass_stack_color = FALSE)
	for(var/datum/stack_recipe/r_recipe in recipes)
		if(r_recipe.title == "wood floor tile")
			recipes -= r_recipe
			continue
		if(r_recipe.title == "large wood floor tile")
			recipes -= r_recipe
			continue
		if(r_recipe.title == "parquet wood floor tile")
			recipes -= r_recipe
			continue
		if(r_recipe.title == "tiled wood floor tile")
			recipes -= r_recipe
			continue
		if(r_recipe.title == "vertical wood floor tile")
			recipes -= r_recipe
			continue
		if(r_recipe.title == "vertical large wood floor tile")
			recipes -= r_recipe
			continue
		if(r_recipe.title == "wooden chair")
			recipes -= r_recipe
			continue
		if(r_recipe.title == "wooden standup figure")
			recipes -= r_recipe
			continue

/datum/material/wood/redwood
	name = MAT_REDWOOD
	stack_type = /obj/item/stack/material/wood/redwood
	icon_colour = "#a45a52"
	icon_base = "wood"
	table_icon_base = "stone"
	icon_reinf = "reinf_stone"
	integrity = 65
	hardness = 20
	weight = 20

/datum/material/wood/redwood/generate_recipes()
	..()
	recipes += new /datum/stack_recipe("redwood floor tile", /obj/item/stack/tile/wood/redwood, 1, 4, 20, pass_stack_color = FALSE, recycle_material = "[name]")
	recipes += new /datum/stack_recipe("large redwood floor tile", /obj/item/stack/tile/wood/redwood/panel, 1, 4, 20, pass_stack_color = FALSE, recycle_material = "[name]")
	recipes += new /datum/stack_recipe("parquet redwood floor tile", /obj/item/stack/tile/wood/redwood/parquet, 1, 4, 20, pass_stack_color = FALSE, recycle_material = "[name]")
	recipes += new /datum/stack_recipe("tiled redwood floor tile", /obj/item/stack/tile/wood/redwood/tile, 1, 4, 20, pass_stack_color = FALSE, recycle_material = "[name]")
	recipes += new /datum/stack_recipe("vertical redwood floor tile", /obj/item/stack/tile/wood/redwood/vert, 1, 4, 20, pass_stack_color = FALSE)
	recipes += new /datum/stack_recipe("vertical large redwood floor tile", /obj/item/stack/tile/wood/redwood/vert_panel, 1, 4, 20, pass_stack_color = FALSE)
	for(var/datum/stack_recipe/r_recipe in recipes)
		if(r_recipe.title == "wood floor tile")
			recipes -= r_recipe
			continue
		if(r_recipe.title == "large wood floor tile")
			recipes -= r_recipe
			continue
		if(r_recipe.title == "parquet wood floor tile")
			recipes -= r_recipe
			continue
		if(r_recipe.title == "tiled wood floor tile")
			recipes -= r_recipe
			continue
		if(r_recipe.title == "vertical wood floor tile")
			recipes -= r_recipe
			continue
		if(r_recipe.title == "vertical large wood floor tile")
			recipes -= r_recipe
			continue
		if(r_recipe.title == "wooden chair")
			recipes -= r_recipe
			continue
		if(r_recipe.title == "wooden standup figure")
			recipes -= r_recipe
			continue
