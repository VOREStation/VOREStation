/obj/fruitspawner //this doesn't need to do anything but make the stack and die so it's light
	name = "fruit spawner"
	desc = "This item spawns harvested seed items."
	icon = 'icons/obj/seeds.dmi'
	icon_state = "no name"
	var/seedtype = null

/obj/fruitspawner/Initialize()
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
	seedtype = "cabbage"
	icon_state = "cabbage"

/obj/fruitspawner/ambrosia
	name = "ambrosia spawner"
	seedtype = "ambrosia"
	icon_state = "ambrosia"

/obj/fruitspawner/apple
	name = "apple spawner"
	seedtype = "apple"
	icon_state = "apple"

/obj/fruitspawner/banana
	name = "banana spawner"
	seedtype = "banana"
	icon_state = "bananas"

/obj/fruitspawner/berry
	name = "berry spawner"
	seedtype = "berries"
	icon_state = "berry"

/obj/fruitspawner/carrot
	name = "carrot spawner"
	seedtype = "carrot"
	icon_state = "carrot"

/obj/fruitspawner/celery
	name = "celery spawner"
	seedtype = "celery"
	icon_state = "stalk"

/obj/fruitspawner/cherry
	name = "cherry spawner"
	seedtype = "cherry"
	icon_state = "cherry"

/obj/fruitspawner/chili
	name = "chili spawner"
	seedtype = "chili"
	icon_state = "chili"

/obj/fruitspawner/icechili
	name = "icechili spawner"
	seedtype = "icechili"
	icon_state = "chili"

/obj/fruitspawner/ghostchili
	name = "ghost chili spawner"
	seedtype = "ghostchili"
	icon_state = "chili"

/obj/fruitspawner/lime
	name = "lime spawner"
	seedtype = "lime"
	icon_state = "treefruit"

/obj/fruitspawner/lemon
	name = "lemon spawner"
	seedtype = "lemon"
	icon_state = "lemon"

/obj/fruitspawner/orange
	name = "orange spawner"
	seedtype = "orange"
	icon_state = "treefruit"

/obj/fruitspawner/cocoa
	name = "cocoa spawner"
	seedtype = "cocoa"
	icon_state = "treefruit"

/obj/fruitspawner/corn
	name = "corn spawner"
	seedtype = "corn"
	icon_state = "corn"

/obj/fruitspawner/diona
	name = "diona spawner"
	seedtype = "diona"
	icon_state = "diona"

/obj/fruitspawner/durian
	name = "durian spawner"
	seedtype = "durian"
	icon_state = "spinefruit"

/obj/fruitspawner/eggplant
	name = "eggplant spawner"
	seedtype = "eggplant"
	icon_state = "eggplant"

/obj/fruitspawner/harebells
	name = "harebells spawner"
	seedtype = "harebells"
	icon_state = "flower5"

/obj/fruitspawner/poppies
	name = "poppies spawner"
	seedtype = "poppies"
	icon_state = "flower3"

/obj/fruitspawner/sunflowers
	name = "sunflowers spawner"
	seedtype = "sunflowers"
	icon_state = "flower2"

/obj/fruitspawner/lavender
	name = "lavender spawner"
	seedtype = "lavender"
	icon_state = "flower6"

/obj/fruitspawner/rose
	name = "rose spawner"
	seedtype = "rose"
	icon_state = "flowers"

/obj/fruitspawner/bloodrose
	name = "bloodrose spawner"
	seedtype = "bloodrose"
	icon_state = "flowers"

/obj/fruitspawner/gnomes
	name = "gnomes spawner"
	seedtype = "gnomes"
	icon_state = "gnomes"

/obj/fruitspawner/grapes
	name = "grapes spawner"
	seedtype = "grapes"
	icon_state = "grapes"

/obj/fruitspawner/greengrapes
	name = "greengrapes spawner"
	seedtype = "greengrapes"
	icon_state = "grapes"

/obj/fruitspawner/grass
	name = "grass spawner"
	seedtype = "grass"
	icon_state = "grass"

/obj/fruitspawner/carpet
	name = "carpet spawner"
	seedtype = "carpet"
	icon_state = "grass"

/obj/fruitspawner/kudzu
	name = "kudzu spawner"
	seedtype = "kudzu"
	icon_state = "treefruit"

/obj/fruitspawner/lettuce
	name = "lettuce spawner"
	seedtype = "lettuce"
	icon_state = "lettuce"

/obj/fruitspawner/siflettuce
	name = "siflettuce spawner"
	seedtype = "siflettuce"
	icon_state = "lettuce"

/obj/fruitspawner/mtear
	name = "mtear spawner"
	seedtype = "mtear"
	icon_state = "alien4"

/obj/fruitspawner/mushrooms
	name = "chanterelle spawner"
	seedtype = "mushrooms"
	icon_state = "mushroom4"

/obj/fruitspawner/mold
	name = "mold spawner"
	seedtype = "mold"
	icon_state = "mushroom5"

/obj/fruitspawner/plumphelmet
	name = "plumphelmet spawner"
	seedtype = "plumphelmet"
	icon_state = "mushroom10"

/obj/fruitspawner/reishi
	name = "reishi spawner"
	seedtype = "reishi"
	icon_state = "mushroom11"

/obj/fruitspawner/libertycap
	name = "libertycap spawner"
	seedtype = "libertycap"
	icon_state = "mushroom8"

/obj/fruitspawner/amanita
	name = "amanita spawner"
	seedtype = "amanita"
	icon_state = "mushroom"

/obj/fruitspawner/destroyingangel
	name = "destroyingangel spawner"
	seedtype = "destroyingangel"
	icon_state = "mushroom3"

/obj/fruitspawner/towercap
	name = "towercap spawner"
	seedtype = "towercap"
	icon_state = "mushroom7"

/obj/fruitspawner/redcap
	name = "redcap spawner"
	seedtype = "redcap"
	icon_state = "mushroom7"

/obj/fruitspawner/glowshroom
	name = "glowshroom spawner"
	seedtype = "glowshroom"
	icon_state = "mushroom2"

/obj/fruitspawner/plastic
	name = "plastic spawner"
	seedtype = "plastic"
	icon_state = "mushroom6"

/obj/fruitspawner/sporeshroom
	name = "sporeshroom spawner"
	seedtype = "sporeshroom"
	icon_state = "mushroom5"

/obj/fruitspawner/nettle
	name = "nettle spawner"
	seedtype = "nettle"
	icon_state = "nettles"

/obj/fruitspawner/deathnettle
	name = "deathnettle spawner"
	seedtype = "deathnettle"
	icon_state = "nettles"

/obj/fruitspawner/onion
	name = "onion spawner"
	seedtype = "onion"
	icon_state = "onion"

/obj/fruitspawner/peanut
	name = "peanut spawner"
	seedtype = "peanut"
	icon_state = "nuts"

/obj/fruitspawner/pineapple
	name = "pineapple spawner"
	seedtype = "pineapple"
	icon_state = "pineapple"

/obj/fruitspawner/spineapple
	name = "spineapple spawner"
	seedtype = "spineapple"
	icon_state = "pineapple"

/obj/fruitspawner/potato
	name = "potato spawner"
	seedtype = "potato"
	icon_state = "potato"

/obj/fruitspawner/pumpkin
	name = "pumpkin spawner"
	seedtype = "pumpkin"
	icon_state = "vine2"

/obj/fruitspawner/rhubarb
	name = "rhubarb spawner"
	seedtype = "rhubarb"
	icon_state = "stalk"

/obj/fruitspawner/rice
	name = "rice spawner"
	seedtype = "rice"
	icon_state = "rice"

/obj/fruitspawner/shand
	name = "selems hand spawner"
	seedtype = "shand"
	icon_state = "alien3"

/obj/fruitspawner/soybean
	name = "soybean spawner"
	seedtype = "soybean"
	icon_state = "bean"

/obj/fruitspawner/sugarcane
	name = "sugarcane spawner"
	seedtype = "sugarcane"
	icon_state = "stalk"

/obj/fruitspawner/telriis
	name = "telriis spawner"
	seedtype = "telriis"
	icon_state = "ambrosia"

/obj/fruitspawner/thaadra
	name = "thaadra spawner"
	seedtype = "thaadra"
	icon_state = "grass"

/obj/fruitspawner/tobacco
	name = "tobacco spawner"
	seedtype = "tobacco"
	icon_state = "leafy"

/obj/fruitspawner/stimbush
	name = "stimbush spawner"
	seedtype = "stimbush"
	icon_state = "leafy"

/obj/fruitspawner/tomato
	name = "tomato spawner"
	seedtype = "tomato"
	icon_state = "tomato"

/obj/fruitspawner/bloodtomato
	name = "bloodtomato spawner"
	seedtype = "bloodtomato"
	icon_state = "tomato"

/obj/fruitspawner/bluetomato
	name = "bluetomato spawner"
	seedtype = "bluetomato"
	icon_state = "tomato"

/obj/fruitspawner/bluespacetomato
	name = "bluespacetomato spawner"
	seedtype = "bluespacetomato"
	icon_state = "tomato"

/obj/fruitspawner/vanilla
	name = "vanilla spawner"
	seedtype = "vanilla"
	icon_state = "chili"

/obj/fruitspawner/whitewabback
	name = "whitewabback spawner"
	seedtype = "whitewabback"
	icon_state = "carrot2"

/obj/fruitspawner/blackwabback
	name = "blackwabback spawner"
	seedtype = "blackwabback"
	icon_state = "carrot2"

/obj/fruitspawner/wildwabback
	name = "wildwabback spawner"
	seedtype = "wildwabback"
	icon_state = "carrot2"

/obj/fruitspawner/watermelon
	name = "watermelon spawner"
	seedtype = "watermelon"
	icon_state = "vine"

/obj/fruitspawner/weeds
	name = "weeds spawner"
	seedtype = "weeds"
	icon_state = "flower4"

/obj/fruitspawner/wheat
	name = "wheat spawner"
	seedtype = "wheat"
	icon_state = "wheat"

/obj/fruitspawner/whitebeet
	name = "whitebeet spawner"
	seedtype = "whitebeet"
	icon_state = "carrot2"

/obj/fruitspawner/wurmwoad
	name = "wurmwoad spawner"
	seedtype = "wurmwoad"
	icon_state = "eyepod"
