var/global/list/plant_seed_sprites = list()

GLOBAL_LIST_BOILERPLATE(all_seed_packs, /obj/item/seeds)

//Seed packet object/procs.
/obj/item/seeds
	name = "packet of seeds"
	icon = 'icons/obj/seeds.dmi'
	icon_state = "blank"
	w_class = ITEMSIZE_SMALL

	var/seed_type
	var/datum/seed/seed
	var/modified = 0

/obj/item/seeds/Initialize(mapload, var/_seed_type)
	if(_seed_type in SSplants.seeds)
		seed_type = _seed_type
	update_seed()
	. = ..()

//Grabs the appropriate seed datum from the global list.
/obj/item/seeds/proc/update_seed()
	if(!seed && seed_type && !isnull(SSplants.seeds) && SSplants.seeds[seed_type])
		seed = SSplants.seeds[seed_type]
	update_appearance()

//Updates strings and icon appropriately based on seed datum.
/obj/item/seeds/proc/update_appearance()
	if(!seed) return

	// Update icon.
	cut_overlays()
	var/is_seeds = ((seed.seed_noun in list("seeds","pits","nodes")) ? 1 : 0)
	var/image/seed_mask
	var/seed_base_key = "base-[is_seeds ? seed.get_trait(TRAIT_PLANT_COLOUR) : "spores"]"
	if(plant_seed_sprites[seed_base_key])
		seed_mask = plant_seed_sprites[seed_base_key]
	else
		seed_mask = image('icons/obj/seeds.dmi',"[is_seeds ? "seed" : "spore"]-mask")
		if(is_seeds) // Spore glass bits aren't coloured.
			seed_mask.color = seed.get_trait(TRAIT_PLANT_COLOUR)
		plant_seed_sprites[seed_base_key] = seed_mask

	var/image/seed_overlay
	var/seed_overlay_key = "[seed.get_trait(TRAIT_PRODUCT_ICON)]-[seed.get_trait(TRAIT_PRODUCT_COLOUR)]"
	if(plant_seed_sprites[seed_overlay_key])
		seed_overlay = plant_seed_sprites[seed_overlay_key]
	else
		seed_overlay = image('icons/obj/seeds.dmi',"[seed.get_trait(TRAIT_PRODUCT_ICON)]")
		seed_overlay.color = seed.get_trait(TRAIT_PRODUCT_COLOUR)
		plant_seed_sprites[seed_overlay_key] = seed_overlay

	add_overlay(seed_mask)
	add_overlay(seed_overlay)

	if(is_seeds)
		src.name = "packet of [seed.seed_name] [seed.seed_noun]"
		src.desc = "It has a picture of [seed.display_name] on the front."
	else
		src.name = "sample of [seed.seed_name] [seed.seed_noun]"
		src.desc = "It's labelled as coming from [seed.display_name]."

/obj/item/seeds/examine(mob/user)
	. = ..()
	if(seed && !seed.roundstart)
		. += "It's tagged as variety #[seed.uid]."

/obj/item/seeds/cutting
	name = "cuttings"
	desc = "Some plant cuttings."

/obj/item/seeds/cutting/update_appearance()
	..()
	src.name = "packet of [seed.seed_name] cuttings"

/obj/item/seeds/random
	seed_type = null

/obj/item/seeds/random/Initialize(mapload)
	seed = SSplants.create_random_seed()
	seed_type = seed.name
	. = ..()

/obj/item/seeds/replicapod
	seed_type = PLANT_DIONA

/obj/item/seeds/chiliseed
	seed_type = PLANT_CHILI

/obj/item/seeds/ghostchiliseed
	seed_type = PLANT_GHOSTCHILI

/obj/item/seeds/plastiseed
	seed_type = PLANT_PLASTIC

/obj/item/seeds/grapeseed
	seed_type = PLANT_GRAPES

/obj/item/seeds/greengrapeseed
	seed_type = PLANT_GREENGRAPES

/obj/item/seeds/peanutseed
	seed_type = PLANT_PEANUT

/obj/item/seeds/cabbageseed
	seed_type = PLANT_CABBAGE

/obj/item/seeds/shandseed
	seed_type = PLANT_SHAND

/obj/item/seeds/mtearseed
	seed_type = PLANT_MTEAR

/obj/item/seeds/berryseed
	seed_type = PLANT_BERRIES

/obj/item/seeds/glowberryseed
	seed_type = PLANT_GLOWBERRIES

/obj/item/seeds/peppercornseed
	seed_type = PLANT_PEPPERCORNS

/obj/item/seeds/bananaseed
	seed_type = PLANT_BANANA

/obj/item/seeds/eggplantseed
	seed_type = PLANT_EGGPLANT

/obj/item/seeds/bloodtomatoseed
	seed_type = PLANT_BLOODTOMATO

/obj/item/seeds/tomatoseed
	seed_type = PLANT_TOMATO

/obj/item/seeds/killertomatoseed
	seed_type = PLANT_KILLERTOMATO

/obj/item/seeds/bluetomatoseed
	seed_type = PLANT_BLUETOMATO

/obj/item/seeds/bluespacetomatoseed
	seed_type = PLANT_BLUESPACETOMATO

/obj/item/seeds/cornseed
	seed_type = PLANT_CORN

/obj/item/seeds/poppyseed
	seed_type = PLANT_POPPIES

/obj/item/seeds/potatoseed
	seed_type = PLANT_POTATO

/obj/item/seeds/icepepperseed
	seed_type = PLANT_ICECHILI

/obj/item/seeds/soyaseed
	seed_type = PLANT_SOYBEAN

/obj/item/seeds/wheatseed
	seed_type = PLANT_WHEAT

/obj/item/seeds/riceseed
	seed_type = PLANT_RICE

/obj/item/seeds/carrotseed
	seed_type = PLANT_CARROT

/obj/item/seeds/reishimycelium
	seed_type = PLANT_REISHI

/obj/item/seeds/amanitamycelium
	seed_type = PLANT_AMANITA

/obj/item/seeds/angelmycelium
	seed_type = PLANT_DESTROYINGANGEL

/obj/item/seeds/libertymycelium
	seed_type = PLANT_LIBERTYCAP

/obj/item/seeds/chantermycelium
	seed_type = PLANT_MUSHROOMS

/obj/item/seeds/towermycelium
	seed_type = PLANT_TOWERCAP

/obj/item/seeds/redtowermycelium
	seed_type = PLANT_REDCAP

/obj/item/seeds/glowshroom
	seed_type = PLANT_GLOWSHROOM

/obj/item/seeds/plumpmycelium
	seed_type = PLANT_PLUMPHELMET

/obj/item/seeds/plastellmycelium
	seed_type = PLANT_PLASTIC

/obj/item/seeds/sporemycelium
	seed_type = PLANT_SPORESHROOM

/obj/item/seeds/nettleseed
	seed_type = PLANT_NETTLE

/obj/item/seeds/deathnettleseed
	seed_type = PLANT_DEATHNETTLE

/obj/item/seeds/weeds
	seed_type = PLANT_WEEDS

/obj/item/seeds/harebell
	seed_type = PLANT_HAREBELLS

/obj/item/seeds/sunflowerseed
	seed_type = PLANT_SUNFLOWERS

/obj/item/seeds/lavenderseed
	seed_type = PLANT_LAVENDER

/obj/item/seeds/brownmold
	seed_type = PLANT_MOLD

/obj/item/seeds/appleseed
	seed_type = PLANT_APPLE

/obj/item/seeds/poisonedappleseed
	seed_type = PLANT_POISONAPPLE

/obj/item/seeds/goldappleseed
	seed_type = PLANT_GOLDAPPLE

/obj/item/seeds/ambrosiavulgarisseed
	seed_type = PLANT_AMBROSIA

/obj/item/seeds/ambrosiadeusseed
	seed_type = PLANT_AMBROSIADEUS

/obj/item/seeds/ambrosiagaiaseed
	seed_type = PLANT_AMBROSIAGAIA

/obj/item/seeds/ambrosiainfernusseed
	seed_type = PLANT_AMBROSIAINFERNUS

/obj/item/seeds/whitebeetseed
	seed_type = PLANT_WHITEBEET

/obj/item/seeds/sugarcaneseed
	seed_type = PLANT_SUGARCANE

/obj/item/seeds/watermelonseed
	seed_type = PLANT_WATERMELON

/obj/item/seeds/pumpkinseed
	seed_type = PLANT_PUMPKIN

/obj/item/seeds/limeseed
	seed_type = PLANT_LIME

/obj/item/seeds/lemonseed
	seed_type = PLANT_LEMON

/obj/item/seeds/onionseed
	seed_type = PLANT_ONION

/obj/item/seeds/orangeseed
	seed_type = PLANT_ORANGE

/obj/item/seeds/poisonberryseed
	seed_type = PLANT_POISONBERRIES

/obj/item/seeds/deathberryseed
	seed_type = PLANT_DEATHBERRIES

/obj/item/seeds/grassseed
	seed_type = PLANT_GRASS

/obj/item/seeds/carpetseed
	seed_type = PLANT_CARPET

/obj/item/seeds/cocoapodseed
	seed_type = PLANT_COCOA

/obj/item/seeds/cherryseed
	seed_type = PLANT_CHERRY

/obj/item/seeds/tobaccoseed
	seed_type = PLANT_TOBACCO

/obj/item/seeds/kudzuseed
	seed_type = PLANT_KUDZU

/obj/item/seeds/jurlmah
	seed_type = PLANT_JURLMAH

/obj/item/seeds/amauri
	seed_type = PLANT_AMAURI

/obj/item/seeds/gelthi
	seed_type = PLANT_GELTHI

/obj/item/seeds/vale
	seed_type = PLANT_VALE

/obj/item/seeds/surik
	seed_type = PLANT_SURIK

/obj/item/seeds/telriis
	seed_type = PLANT_TELRIIS

/obj/item/seeds/thaadra
	seed_type = PLANT_THAADRA

/obj/item/seeds/celery
	seed_type = PLANT_CELERY

/obj/item/seeds/rhubarb
	seed_type = PLANT_ROSE

/obj/item/seeds/wabback
	seed_type = PLANT_WHITEWABBACK

/obj/item/seeds/blackwabback
	seed_type = PLANT_BLACKWABBACK

/obj/item/seeds/wildwabback
	seed_type = PLANT_WILDWABBACK

/obj/item/seeds/lettuce
	seed_type = PLANT_LETTUCE

/obj/item/seeds/siflettuce
	seed_type = PLANT_SIFLETTUCE

/obj/item/seeds/eggyplant
	seed_type = PLANT_EGG_PLANT

/obj/item/seeds/pineapple
	seed_type = PLANT_PINEAPPLE

/obj/item/seeds/durian
	seed_type = PLANT_DURIAN

/obj/item/seeds/vanilla
	seed_type = PLANT_VANILLA

/obj/item/seeds/rose
	seed_type = PLANT_ROSE

/obj/item/seeds/rose/blood
	seed_type = PLANT_BLOODROSE

/obj/item/seeds/gnomes
	seed_type = PLANT_GNOMES

/obj/item/seeds/sifbulb
	seed_type = PLANT_SIFBULB

/obj/item/seeds/wurmwoad
	seed_type = PLANT_WURMWOAD

/obj/item/seeds/shrinkshroom
	seed_type = PLANT_MICROM

/obj/item/seeds/megashroom
	seed_type = PLANT_MEGAM
