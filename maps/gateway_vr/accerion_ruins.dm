// -- Datums -- //

/obj/effect/overmap/visitable/sector/common_gateway/accerion_ruins
	initial_generic_waypoints = list("tether_excursion_accerionruins")
	in_space = 0
	name = "NRB Ambrosia Ruins"
	scanner_desc = @{"[i]Stellar Body[/i]: ACCERION
[i]Class[/i]: M-Class Planetoid
[i]Habitability[/i]: Moderate (Dense Terrain)
[b]Notice[/b]: Heavy foliage detected, teleportations signals disrupted."}
	unknown_state = "planet"
	known = FALSE
	icon_state = "lush"

// -- Areas -- //

//spawn
/area/awaymission/accerion_ruins
	icon_state = "unknown"

//engineering
/area/awaymission/accerion_ruins/engineering
	name = "accerion engineering"
	icon_state = "substation"

/area/awaymission/accerion_ruins/engineering/b1power
	name = "\improper Away Mission - NRB Ambrosia Building 1 Power Storage"
/area/awaymission/accerion_ruins/engineering/b2power
	name = "\improper Away Mission - NRB Ambrosia Building 2 Power Storage"

//general
/area/awaymission/accerion_ruins/general
	name = "accerion general"
	icon_state = "yellow"

/area/awaymission/accerion_ruins/general/b1westwing
	name = "\improper Away Mission - NRB Ambrosia Building 1 West Wing"
/area/awaymission/accerion_ruins/general/b1commonarea
	name = "\improper Away Mission - NRB Ambrosia Building 1 Common Area"
/area/awaymission/accerion_ruins/general/b2commonarea
	name = "\improper Away Mission - NRB Ambrosia Building 2 Common Area"
/area/awaymission/accerion_ruins/general/b2customs
	name = "\improper Away Mission - NRB Ambrosia Building 2 Customs"
	icon_state = "darkred"
/area/awaymission/accerion_ruins/general/b2gatewayhall
	name = "\improper Away Mission - NRB Ambrosia Building 2 Gateway Hall"
/area/awaymission/accerion_ruins/general/bathroom
	name = "\improper Away Mission - NRB Ambrosia Unisex Bathroom"
	icon_state = "restrooms"
/area/awaymission/accerion_ruins/general/cafeteria
	name = "\improper Away Mission - NRB Ambrosia Cafeteria"
	icon_state = "kitchen"
/area/awaymission/accerion_ruins/general/bar
	name = "\improper Away Mission - NRB Ambrosia Bar"
	icon_state = "bar"
/area/awaymission/accerion_ruins/general/janitor
	name = "\improper Away Mission - NRB Ambrosia Custodial Closet"
	icon_state = "janitor"
/area/awaymission/accerion_ruins/general/medical
	name = "\improper Away Mission - NRB Ambrosia Medical Office"
	icon_state = "medbay3"
/area/awaymission/accerion_ruins/general/landingpad
	name = "\improper Away Mission - NRB Ambrosia Landing Pad"
	icon_state = "purple"
/area/awaymission/accerion_ruins/general/warehouse
	name = "\improper Away Mission - NRB Ambrosia Warehouse"
/area/awaymission/accerion_ruins/general/gateway
	name = "\improper Away Mission - NRB Ambrosia Gateway"
	icon_state = "darkred"

//alien
/area/awaymission/accerion_ruins/cave/crashed_ufo_scout
	name = "POI - Crashed Alien Scout"
	requires_power = FALSE
	ambience = AMBIENCE_OTHERWORLDLY
	icon_state = "submap2"

//crew
/area/awaymission/accerion_ruins/quarters
	name = "accerion quarters"
	icon_state = "crew_quarters"

/area/awaymission/accerion_ruins/quarters/dorm1
	name = "\improper Away Mission - NRB Ambrosia Dorm Room 1"
/area/awaymission/accerion_ruins/quarters/dorm2
	name = "\improper Away Mission - NRB Ambrosia Dorm Room 2"
/area/awaymission/accerion_ruins/quarters/dorm3
	name = "\improper Away Mission - NRB Ambrosia Dorm Room 3"
/area/awaymission/accerion_ruins/quarters/dorm4
	name = "\improper Away Mission - NRB Ambrosia Dorm Room 4"
/area/awaymission/accerion_ruins/quarters/dorm5
	name = "\improper Away Mission - NRB Ambrosia Pilot's Quarters"

//outside
/area/awaymission/accerion_ruins/outside
	name = "\improper Away Mission - NRB Ambrosia Exterior"
	icon_state = "green"

// -- Turf -- //

/decl/flooring/grass/jungle
	name = "grass"
	desc = "A thick, moist grass that is common in dense jungle terrain."
	icon = 'icons/turf/outdoors.dmi'
	icon_base = "junglegrass"
	has_base_range = 1
	flags = TURF_REMOVE_SHOVEL
	build_type = /obj/item/stack/tile/grass/jungle

/turf/simulated/floor/outdoors/grass/accerion
	name = "thick grass"
	icon_state = "junglegrass0"
	initial_flooring = /decl/flooring/grass/jungle
	edge_blending_priority = 4
	grass_chance = 50

	turf_layers = list(
		/turf/simulated/floor/outdoors/rocks,
		/turf/simulated/floor/outdoors/dirt/jungle
		)

	grass_types = list(
		/obj/structure/flora/accerion/rafflesia = 1,
		/obj/structure/flora/accerion/goldbulb = 2,
		/obj/structure/flora/accerion/williamsrose = 5,
		/obj/structure/flora/accerion/glassstalks = 10,
		/obj/structure/flora/accerion/tallgrass = 60,
		/obj/structure/flora/accerion/bush = 30,
		/obj/structure/flora/accerion/stones = 30
		)

/decl/flooring/dirt/jungle
	icon_base = "jungle-dirt"

/turf/simulated/floor/outdoors/dirt/jungle
	icon_state = "jungle-dirt"
	initial_flooring = /decl/flooring/dirt/jungle

// -- Walls -- //

/turf/simulated/mineral/accerion/attackby()
	return

/turf/simulated/mineral/accerion/ex_act()
	return

/turf/simulated/mineral/accerion/take_damage()	//These things are suppose to be unbreakable
	return

/turf/simulated/mineral/accerion
	name = "thick foliage"
	desc = "A dense growth of foliage that is nigh impossible to cut or pass thorugh."
	icon_state = "junglewall"
	rock_side_icon_state = "junglewall_side"
	sand_icon_state = "asteroid"
	rock_icon_state = "junglewall"
	flags = TURF_ACID_IMMUNE
	has_resources = 0
	block_tele = TRUE

/turf/simulated/mineral/accerion/rock
	name = "mossy rock"
	desc = "Rocks covered in rich green moss."
	icon_state = "mossyrock"
	rock_side_icon_state = "mossyrock_side"
	sand_icon_state = "asteroid"
	rock_icon_state = "mossyrock"
	flags = TURF_ACID_IMMUNE
	has_resources = 0
	block_tele = TRUE

// -- Plants -- //

/obj/structure/flora/accerion
	icon = 'icons/obj/flora/jungleflora_vr.dmi'

/obj/structure/flora/accerion/tallgrass
	icon_state = "jungletallgrass1"

/obj/structure/flora/accerion/tallgrass/New()
	..()
	icon_state = "jungletallgrass[rand(1, 10)]"

/obj/structure/flora/accerion/bush
	icon_state = "leafybush1"

/obj/structure/flora/accerion/bush/New()
	..()
	icon_state = "leafybush[rand(1, 3)]"

/obj/structure/flora/accerion/stones
	icon_state = "junglestones1"

/obj/structure/flora/accerion/stones/New()
	..()
	icon_state = "junglestones[rand(1, 3)]"

/datum/category_item/catalogue/flora/accerion/rafflesia
	name = "Accerion Flora - Rafflesia"
	desc = "A plant that orginated from Earth but was brought over to Accerion as an experiment. \
	It is a parasitic plant that whose buds rise from the ground or directly from the stems of their \
	host plants. On Earth it is one of the largest flowering planets recorded and is well known for \
	its strong rotten flesh smell which it uses to attract scavengers which in turn spread the pollen \
	of the plant, continuing its life cycle."
	value = CATALOGUER_REWARD_MEDIUM

/obj/structure/flora/accerion/rafflesia
	icon_state = "jungleflower1"
	catalogue_data = list(/datum/category_item/catalogue/flora/accerion/rafflesia)

/datum/category_item/catalogue/flora/accerion/williamsrose
	name = "Accerion Flora - Williams Rose"
	desc = "A small flower that is native to Accerion which was named after the person who originally \
	discovered it. The Williams Rose is known for its sweet scent and beautifully bright color which \
	some clothing companies use as a dye in their products. It is a common sight on Accerion's surface."
	value = CATALOGUER_REWARD_EASY

/obj/structure/flora/accerion/williamsrose
	icon_state = "jungleflower2"
	catalogue_data = list(/datum/category_item/catalogue/flora/accerion/williamsrose)

/obj/structure/flora/accerion/williamsrose/New()
	..()
	icon_state = "jungleflower[rand(2, 3)]"

/datum/category_item/catalogue/flora/accerion/glassstalks
	name = "Accerion Flora - Glass Stalks"
	desc = "A small weed like flower which is known for its subtle transparency which has been known to \
	mimic the properties of glass, hence the plants name. People say that looking over a large field of \
	them as the sun sets is akin to gazing into the night sky."
	value = CATALOGUER_REWARD_EASY

/obj/structure/flora/accerion/glassstalks
	icon_state = "jungleflower4"
	catalogue_data = list(/datum/category_item/catalogue/flora/accerion/glassstalks)

/obj/structure/flora/accerion/glassstalks/New()
	..()
	icon_state = "jungleflower[rand(4, 6)]"

/datum/category_item/catalogue/flora/accerion/goldbulb
	name = "Accerion Flora - Golden Bulbs"
	desc = "A larger native flower of Accerion that is known for its brilliant golden hue which locals have \
	taken to use as a form of dye for clothing. It has a wonderfully pleaseant smell that is reminiscent of \
	honey, however, the plant is deadly to ingest."
	value = CATALOGUER_REWARD_EASY

/obj/structure/flora/accerion/goldbulb
	icon_state = "jungleflower7"
	catalogue_data = list(/datum/category_item/catalogue/flora/accerion/goldbulb)

/obj/structure/flora/accerion/goldbulb/New()
	..()
	icon_state = "jungleflower[rand(7, 8)]"