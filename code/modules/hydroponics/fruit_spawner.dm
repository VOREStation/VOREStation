/obj/fruitspawner //this doesn't need to do anything but make the stack and die so it's light
	name = "fruit spawner"
	desc = "This item spawns harvested seed items."
	icon = 'icons/obj/seeds.dmi'
	icon_state = "no name"
	var/seedtype = null

/obj/fruitspawner/Initialize(mapload)
	..()
	if(!seedtype || !SSplants.seeds[seedtype])
		return
	var/turf/T = get_turf(src)
	var/obj/structure/closet/C = locate() in T
	var/datum/seed/S = SSplants.seeds[seedtype]
	S.harvest(T || C,0,0,1)
	return INITIALIZE_HINT_QDEL

/obj/fruitspawner/cabbage
	name = "cabbage spawner"
	seedtype = PLANT_CABBAGE
	icon_state = "cabbage"

/obj/fruitspawner/ambrosia
	name = "ambrosia spawner"
	seedtype = PLANT_AMBROSIA
	icon_state = "ambrosia"

/obj/fruitspawner/apple
	name = "apple spawner"
	seedtype = PLANT_APPLE
	icon_state = "apple"

/obj/fruitspawner/banana
	name = "banana spawner"
	seedtype = PLANT_BANANA
	icon_state = "bananas"

/obj/fruitspawner/berry
	name = "berry spawner"
	seedtype = PLANT_BERRIES
	icon_state = "berry"

/obj/fruitspawner/carrot
	name = "carrot spawner"
	seedtype = PLANT_CARROT
	icon_state = "carrot"

/obj/fruitspawner/celery
	name = "celery spawner"
	seedtype = PLANT_CELERY
	icon_state = "stalk"

/obj/fruitspawner/cherry
	name = "cherry spawner"
	seedtype = PLANT_CHERRY
	icon_state = "cherry"

/obj/fruitspawner/chili
	name = "chili spawner"
	seedtype = PLANT_CHILI
	icon_state = "chili"

/obj/fruitspawner/icechili
	name = "icechili spawner"
	seedtype = PLANT_ICECHILI
	icon_state = "chili"

/obj/fruitspawner/ghostchili
	name = "ghost chili spawner"
	seedtype = PLANT_GHOSTCHILI
	icon_state = "chili"

/obj/fruitspawner/lime
	name = "lime spawner"
	seedtype = PLANT_LIME
	icon_state = "treefruit"

/obj/fruitspawner/lemon
	name = "lemon spawner"
	seedtype = PLANT_LEMON
	icon_state = "lemon"

/obj/fruitspawner/orange
	name = "orange spawner"
	seedtype = PLANT_ORANGE
	icon_state = "treefruit"

/obj/fruitspawner/cocoa
	name = "cocoa spawner"
	seedtype = PLANT_COCOA
	icon_state = "treefruit"

/obj/fruitspawner/corn
	name = "corn spawner"
	seedtype = PLANT_CORN
	icon_state = "corn"

/obj/fruitspawner/diona
	name = "diona spawner"
	seedtype = PLANT_DIONA
	icon_state = "diona"

/obj/fruitspawner/durian
	name = "durian spawner"
	seedtype = PLANT_DURIAN
	icon_state = "spinefruit"

/obj/fruitspawner/eggplant
	name = "eggplant spawner"
	seedtype = PLANT_EGGPLANT
	icon_state = "eggplant"

/obj/fruitspawner/harebells
	name = "harebells spawner"
	seedtype = PLANT_HAREBELLS
	icon_state = "flower5"

/obj/fruitspawner/poppies
	name = "poppies spawner"
	seedtype = PLANT_POPPIES
	icon_state = "flower3"

/obj/fruitspawner/sunflowers
	name = "sunflowers spawner"
	seedtype = PLANT_SUNFLOWERS
	icon_state = "flower2"

/obj/fruitspawner/lavender
	name = "lavender spawner"
	seedtype = PLANT_LAVENDER
	icon_state = "flower6"

/obj/fruitspawner/rose
	name = "rose spawner"
	seedtype = PLANT_ROSE
	icon_state = "flowers"

/obj/fruitspawner/bloodrose
	name = "bloodrose spawner"
	seedtype = PLANT_BLOODROSE
	icon_state = "flowers"

/obj/fruitspawner/gnomes
	name = "gnomes spawner"
	seedtype = PLANT_GNOMES
	icon_state = "gnomes"

/obj/fruitspawner/grapes
	name = "grapes spawner"
	seedtype = PLANT_GRAPES
	icon_state = "grapes"

/obj/fruitspawner/greengrapes
	name = "greengrapes spawner"
	seedtype = PLANT_GREENGRAPES
	icon_state = "grapes"

/obj/fruitspawner/grass
	name = "grass spawner"
	seedtype = PLANT_GRASS
	icon_state = "grass"

/obj/fruitspawner/carpet
	name = "carpet spawner"
	seedtype = PLANT_CARPET
	icon_state = "grass"

/obj/fruitspawner/kudzu
	name = "kudzu spawner"
	seedtype = PLANT_KUDZU
	icon_state = "treefruit"

/obj/fruitspawner/lettuce
	name = "lettuce spawner"
	seedtype = PLANT_LETTUCE
	icon_state = "lettuce"

/obj/fruitspawner/siflettuce
	name = "siflettuce spawner"
	seedtype = PLANT_SIFLETTUCE
	icon_state = "lettuce"

/obj/fruitspawner/mtear
	name = "mtear spawner"
	seedtype = PLANT_MTEAR
	icon_state = "alien4"

/obj/fruitspawner/mushrooms
	name = "chanterelle spawner"
	seedtype = PLANT_MUSHROOMS
	icon_state = "mushroom4"

/obj/fruitspawner/mold
	name = "mold spawner"
	seedtype = PLANT_MOLD
	icon_state = "mushroom5"

/obj/fruitspawner/plumphelmet
	name = "plumphelmet spawner"
	seedtype = PLANT_PLUMPHELMET
	icon_state = "mushroom10"

/obj/fruitspawner/reishi
	name = "reishi spawner"
	seedtype = PLANT_REISHI
	icon_state = "mushroom11"

/obj/fruitspawner/libertycap
	name = "libertycap spawner"
	seedtype = PLANT_LIBERTYCAP
	icon_state = "mushroom8"

/obj/fruitspawner/amanita
	name = "amanita spawner"
	seedtype = PLANT_AMANITA
	icon_state = "mushroom"

/obj/fruitspawner/destroyingangel
	name = "destroyingangel spawner"
	seedtype = PLANT_DESTROYINGANGEL
	icon_state = "mushroom3"

/obj/fruitspawner/towercap
	name = "towercap spawner"
	seedtype = PLANT_TOWERCAP
	icon_state = "mushroom7"

/obj/fruitspawner/redcap
	name = "redcap spawner"
	seedtype = PLANT_REDCAP
	icon_state = "mushroom7"

/obj/fruitspawner/glowshroom
	name = "glowshroom spawner"
	seedtype = PLANT_GLOWSHROOM
	icon_state = "mushroom2"

/obj/fruitspawner/plastic
	name = "plastic spawner"
	seedtype = PLANT_PLASTIC
	icon_state = "mushroom6"

/obj/fruitspawner/sporeshroom
	name = "sporeshroom spawner"
	seedtype = PLANT_SPORESHROOM
	icon_state = "mushroom5"

/obj/fruitspawner/nettle
	name = "nettle spawner"
	seedtype = PLANT_NETTLE
	icon_state = "nettles"

/obj/fruitspawner/deathnettle
	name = "deathnettle spawner"
	seedtype = PLANT_DEATHNETTLE
	icon_state = "nettles"

/obj/fruitspawner/onion
	name = "onion spawner"
	seedtype = PLANT_ONION
	icon_state = "onion"

/obj/fruitspawner/peanut
	name = "peanut spawner"
	seedtype = PLANT_PEANUT
	icon_state = "nuts"

/obj/fruitspawner/pineapple
	name = "pineapple spawner"
	seedtype = PLANT_PINEAPPLE
	icon_state = "pineapple"

/obj/fruitspawner/spineapple
	name = "spineapple spawner"
	seedtype = PLANT_SPINEAPPLE
	icon_state = "pineapple"

/obj/fruitspawner/potato
	name = "potato spawner"
	seedtype = PLANT_POTATO
	icon_state = "potato"

/obj/fruitspawner/pumpkin
	name = "pumpkin spawner"
	seedtype = PLANT_PUMPKIN
	icon_state = "vine2"

/obj/fruitspawner/rhubarb
	name = "rhubarb spawner"
	seedtype = PLANT_ROSE
	icon_state = "stalk"

/obj/fruitspawner/rice
	name = "rice spawner"
	seedtype = PLANT_RICE
	icon_state = "rice"

/obj/fruitspawner/shand
	name = "selems hand spawner"
	seedtype = PLANT_SHAND
	icon_state = "alien3"

/obj/fruitspawner/soybean
	name = "soybean spawner"
	seedtype = PLANT_SOYBEAN
	icon_state = "bean"

/obj/fruitspawner/sugarcane
	name = "sugarcane spawner"
	seedtype = PLANT_SUGARCANE
	icon_state = "stalk"

/obj/fruitspawner/telriis
	name = "telriis spawner"
	seedtype = PLANT_TELRIIS
	icon_state = "ambrosia"

/obj/fruitspawner/thaadra
	name = "thaadra spawner"
	seedtype = PLANT_THAADRA
	icon_state = "grass"

/obj/fruitspawner/tobacco
	name = "tobacco spawner"
	seedtype = PLANT_TOBACCO
	icon_state = "leafy"

/obj/fruitspawner/stimbush
	name = "stimbush spawner"
	seedtype = "stimbush"
	icon_state = "leafy"

/obj/fruitspawner/tomato
	name = "tomato spawner"
	seedtype = PLANT_TOMATO
	icon_state = "tomato"

/obj/fruitspawner/bloodtomato
	name = "bloodtomato spawner"
	seedtype = PLANT_BLOODTOMATO
	icon_state = "tomato"

/obj/fruitspawner/bluetomato
	name = "bluetomato spawner"
	seedtype = PLANT_BLUETOMATO
	icon_state = "tomato"

/obj/fruitspawner/bluespacetomato
	name = "bluespacetomato spawner"
	seedtype = PLANT_BLUESPACETOMATO
	icon_state = "tomato"

/obj/fruitspawner/vanilla
	name = "vanilla spawner"
	seedtype = PLANT_VANILLA
	icon_state = "chili"

/obj/fruitspawner/whitewabback
	name = "whitewabback spawner"
	seedtype = PLANT_WHITEWABBACK
	icon_state = "carrot2"

/obj/fruitspawner/blackwabback
	name = "blackwabback spawner"
	seedtype = PLANT_BLACKWABBACK
	icon_state = "carrot2"

/obj/fruitspawner/wildwabback
	name = "wildwabback spawner"
	seedtype = PLANT_WILDWABBACK
	icon_state = "carrot2"

/obj/fruitspawner/watermelon
	name = "watermelon spawner"
	seedtype = PLANT_WATERMELON
	icon_state = "vine"

/obj/fruitspawner/weeds
	name = "weeds spawner"
	seedtype = PLANT_WEEDS
	icon_state = "flower4"

/obj/fruitspawner/wheat
	name = "wheat spawner"
	seedtype = PLANT_WHEAT
	icon_state = "wheat"

/obj/fruitspawner/whitebeet
	name = "whitebeet spawner"
	seedtype = PLANT_WHITEBEET
	icon_state = "carrot2"

/obj/fruitspawner/wurmwoad
	name = "wurmwoad spawner"
	seedtype = PLANT_WURMWOAD
	icon_state = "eyepod"
