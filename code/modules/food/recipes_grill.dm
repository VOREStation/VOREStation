/datum/recipe/humanburger
	appliance = GRILL
	items = list(
		/obj/item/reagent_containers/food/snacks/meat/human,
		/obj/item/reagent_containers/food/snacks/bun
	)
	result = /obj/item/reagent_containers/food/snacks/human/burger
	wiki_flag = WIKI_SPOILER // Alt recipie doesn't need to be shown(breaks tgui)

/datum/recipe/plainburger
	appliance = GRILL
	items = list(
		/obj/item/reagent_containers/food/snacks/bun,
		/obj/item/reagent_containers/food/snacks/meat //do not place this recipe before /datum/recipe/humanburger
	)
	result = /obj/item/reagent_containers/food/snacks/monkeyburger

/datum/recipe/syntiburger
	appliance = GRILL
	items = list(
		/obj/item/reagent_containers/food/snacks/bun,
		/obj/item/reagent_containers/food/snacks/meat/syntiflesh
	)
	result = /obj/item/reagent_containers/food/snacks/monkeyburger
	wiki_flag = WIKI_SPOILER // Alt recipie doesn't need to be shown(breaks tgui)

/datum/recipe/brainburger
	appliance = GRILL
	items = list(
		/obj/item/reagent_containers/food/snacks/bun,
		/obj/item/organ/internal/brain
	)
	result = /obj/item/reagent_containers/food/snacks/brainburger

/datum/recipe/roburger
	appliance = GRILL
	items = list(
		/obj/item/reagent_containers/food/snacks/bun,
		/obj/item/robot_parts/head
	)
	result = /obj/item/reagent_containers/food/snacks/roburger

/datum/recipe/xenoburger
	appliance = GRILL
	items = list(
		/obj/item/reagent_containers/food/snacks/bun,
		/obj/item/reagent_containers/food/snacks/xenomeat
	)
	result = /obj/item/reagent_containers/food/snacks/xenoburger

/datum/recipe/fishburger
	appliance = GRILL
	items = list(
		/obj/item/reagent_containers/food/snacks/bun,
		/obj/item/reagent_containers/food/snacks/carpmeat
	)
	result = /obj/item/reagent_containers/food/snacks/fishburger

/datum/recipe/tofuburger
	appliance = GRILL
	items = list(
		/obj/item/reagent_containers/food/snacks/bun,
		/obj/item/reagent_containers/food/snacks/tofu
	)
	result = /obj/item/reagent_containers/food/snacks/tofuburger

/datum/recipe/ghostburger
	appliance = GRILL
	items = list(
		/obj/item/reagent_containers/food/snacks/bun,
		/obj/item/ectoplasm //where do you even find this stuff
	)
	result = /obj/item/reagent_containers/food/snacks/ghostburger

/datum/recipe/clownburger
	appliance = GRILL
	items = list(
		/obj/item/reagent_containers/food/snacks/bun,
		/obj/item/clothing/mask/gas/clown_hat
	)
	result = /obj/item/reagent_containers/food/snacks/clownburger

/datum/recipe/mimeburger
	appliance = GRILL
	items = list(
		/obj/item/reagent_containers/food/snacks/bun,
		/obj/item/clothing/head/beret
	)
	result = /obj/item/reagent_containers/food/snacks/mimeburger

/datum/recipe/mouseburger
	appliance = GRILL
	items = list(
		/obj/item/reagent_containers/food/snacks/bun,
		/obj/item/holder/mouse
	)
	result = /obj/item/reagent_containers/food/snacks/mouseburger

/datum/recipe/bunbun
	appliance = GRILL
	items = list(
		/obj/item/reagent_containers/food/snacks/bun,
		/obj/item/reagent_containers/food/snacks/bun
	)
	result = /obj/item/reagent_containers/food/snacks/bunbun
	wiki_flag = WIKI_SPOILER

/datum/recipe/hotdog
	appliance = GRILL
	items = list(
		/obj/item/reagent_containers/food/snacks/bun,
		/obj/item/reagent_containers/food/snacks/sausage
	)
	result = /obj/item/reagent_containers/food/snacks/hotdog

/datum/recipe/humankabob
	appliance = GRILL
	items = list(
		/obj/item/stack/rods,
		/obj/item/reagent_containers/food/snacks/meat/human,
		/obj/item/reagent_containers/food/snacks/meat/human,
	)
	result = /obj/item/reagent_containers/food/snacks/human/kabob
	wiki_flag = WIKI_SPOILER

/datum/recipe/kabob	//Do not put before humankabob
	appliance = GRILL
	items = list(
		/obj/item/stack/rods,
		/obj/item/reagent_containers/food/snacks/meat,
		/obj/item/reagent_containers/food/snacks/meat,
	)
	result = /obj/item/reagent_containers/food/snacks/monkeykabob

/datum/recipe/monkeykabob
	appliance = GRILL
	items = list(
		/obj/item/stack/rods,
		/obj/item/reagent_containers/food/snacks/meat/monkey,
		/obj/item/reagent_containers/food/snacks/meat/monkey
	)
	result = /obj/item/reagent_containers/food/snacks/monkeykabob
	wiki_flag = WIKI_SPOILER // Alt recipie doesn't need to be shown(breaks tgui)

/datum/recipe/syntikabob
	appliance = GRILL
	items = list(
		/obj/item/stack/rods,
		/obj/item/reagent_containers/food/snacks/meat/syntiflesh,
		/obj/item/reagent_containers/food/snacks/meat/syntiflesh
	)
	result = /obj/item/reagent_containers/food/snacks/monkeykabob
	wiki_flag = WIKI_SPOILER // Alt recipie doesn't need to be shown(breaks tgui)

/datum/recipe/tofukabob
	appliance = GRILL
	items = list(
		/obj/item/stack/rods,
		/obj/item/reagent_containers/food/snacks/tofu,
		/obj/item/reagent_containers/food/snacks/tofu,
	)
	result = /obj/item/reagent_containers/food/snacks/tofukabob

/datum/recipe/fakespellburger
	appliance = GRILL
	items = list(
		/obj/item/reagent_containers/food/snacks/monkeyburger,
		/obj/item/clothing/head/wizard/fake,
	)
	result = /obj/item/reagent_containers/food/snacks/spellburger
	wiki_flag = WIKI_SPOILER

/datum/recipe/spellburger
	appliance = GRILL
	items = list(
		/obj/item/reagent_containers/food/snacks/monkeyburger,
		/obj/item/clothing/head/wizard,
	)
	result = /obj/item/reagent_containers/food/snacks/spellburger

/datum/recipe/bigbiteburger
	appliance = GRILL
	items = list(
		/obj/item/reagent_containers/food/snacks/monkeyburger,
		/obj/item/reagent_containers/food/snacks/meat,
		/obj/item/reagent_containers/food/snacks/meat,
		/obj/item/reagent_containers/food/snacks/meat,
	)
	reagents = list(REAGENT_ID_EGG = 3)
	reagent_mix = RECIPE_REAGENT_REPLACE
	result = /obj/item/reagent_containers/food/snacks/bigbiteburger

/datum/recipe/superbiteburger
	appliance = GRILL
	fruit = list(PLANT_TOMATO = 1)
	reagents = list(REAGENT_ID_SODIUMCHLORIDE = 5, REAGENT_ID_BLACKPEPPER = 5)
	items = list(
		/obj/item/reagent_containers/food/snacks/bigbiteburger,
		/obj/item/reagent_containers/food/snacks/dough,
		/obj/item/reagent_containers/food/snacks/meat,
		/obj/item/reagent_containers/food/snacks/cheesewedge,
		/obj/item/reagent_containers/food/snacks/boiledegg,
	)
	result = /obj/item/reagent_containers/food/snacks/superbiteburger

/datum/recipe/slimeburger
	appliance = GRILL
	reagents = list(REAGENT_ID_SLIMEJELLY = 5)
	items = list(
		/obj/item/reagent_containers/food/snacks/bun
	)
	result = /obj/item/reagent_containers/food/snacks/jellyburger/slime

/datum/recipe/jellyburger
	appliance = GRILL
	reagents = list(REAGENT_ID_CHERRYJELLY = 5)
	items = list(
		/obj/item/reagent_containers/food/snacks/bun
	)
	result = /obj/item/reagent_containers/food/snacks/jellyburger/cherry

/datum/recipe/bearburger
	appliance = GRILL
	items = list(
		/obj/item/reagent_containers/food/snacks/bun,
		/obj/item/reagent_containers/food/snacks/bearmeat
	)
	result = /obj/item/reagent_containers/food/snacks/bearburger

/datum/recipe/baconburger
	appliance = GRILL
	items = list(
		/obj/item/reagent_containers/food/snacks/bun,
		/obj/item/reagent_containers/food/snacks/meat,
		/obj/item/reagent_containers/food/snacks/bacon,
		/obj/item/reagent_containers/food/snacks/bacon
	)
	result = /obj/item/reagent_containers/food/snacks/burger/bacon

/datum/recipe/omelette
	appliance = GRILL
	items = list(
		/obj/item/reagent_containers/food/snacks/cheesewedge,
		/obj/item/reagent_containers/food/snacks/cheesewedge,
	)
	reagents = list(REAGENT_ID_EGG = 6)
	reagent_mix = RECIPE_REAGENT_REPLACE
	result = /obj/item/reagent_containers/food/snacks/omelette

/datum/recipe/omurice
	appliance = GRILL
	reagents = list(REAGENT_ID_RICE = 5, REAGENT_ID_KETCHUP = 5, REAGENT_ID_EGG = 3)
	result = /obj/item/reagent_containers/food/snacks/omurice

/datum/recipe/omurice/heart
	appliance = GRILL
	reagents = list(REAGENT_ID_RICE = 5, REAGENT_ID_KETCHUP = 5, REAGENT_ID_SUGAR = 5, REAGENT_ID_EGG = 3)
	result = /obj/item/reagent_containers/food/snacks/omurice/heart

/datum/recipe/omurice/face
	appliance = GRILL
	reagents = list(REAGENT_ID_RICE = 5, REAGENT_ID_KETCHUP = 5, REAGENT_ID_SODIUMCHLORIDE = 1, REAGENT_ID_EGG = 3)
	result = /obj/item/reagent_containers/food/snacks/omurice/face

/datum/recipe/meatsteak
	appliance = GRILL
	reagents = list(REAGENT_ID_SODIUMCHLORIDE = 1, REAGENT_ID_BLACKPEPPER = 1)
	items = list(/obj/item/reagent_containers/food/snacks/meat)
	result = /obj/item/reagent_containers/food/snacks/meatsteak

/datum/recipe/honeytoast
	appliance = GRILL
	reagents = list(REAGENT_ID_HONEY = 5)
	items = list(
		/obj/item/reagent_containers/food/snacks/slice/bread
	)
	reagent_mix = RECIPE_REAGENT_REPLACE //Simplify end product
	result = /obj/item/reagent_containers/food/snacks/honeytoast

/datum/recipe/grilled_carp
	appliance = GRILL
	items = list(
		/obj/item/reagent_containers/food/snacks/carpmeat,
		/obj/item/reagent_containers/food/snacks/carpmeat,
		/obj/item/reagent_containers/food/snacks/carpmeat,
		/obj/item/reagent_containers/food/snacks/carpmeat,
		/obj/item/reagent_containers/food/snacks/carpmeat,
		/obj/item/reagent_containers/food/snacks/carpmeat
	)
	reagents = list(REAGENT_ID_SPACESPICE = 1)
	fruit = list(PLANT_LETTUCE = 1, PLANT_LIME = 1)
	result = /obj/item/reagent_containers/food/snacks/sliceable/grilled_carp

/datum/recipe/grilledcheese
	appliance = GRILL
	items = list(
		/obj/item/reagent_containers/food/snacks/slice/bread,
		/obj/item/reagent_containers/food/snacks/slice/bread,
		/obj/item/reagent_containers/food/snacks/cheesewedge,
	)
	result = /obj/item/reagent_containers/food/snacks/grilledcheese

/datum/recipe/toastedsandwich
	appliance = GRILL
	items = list(
		/obj/item/reagent_containers/food/snacks/sandwich
	)
	result = /obj/item/reagent_containers/food/snacks/toastedsandwich

/datum/recipe/cheese_cracker
	appliance = GRILL
	items = list(
		/obj/item/reagent_containers/food/snacks/spreads/butter,
		/obj/item/reagent_containers/food/snacks/slice/bread,
		/obj/item/reagent_containers/food/snacks/cheesewedge
	)
	reagents = list(REAGENT_ID_SPACESPICE = 1)
	result = /obj/item/reagent_containers/food/snacks/cheesetoast
	result_quantity = 4

/datum/recipe/bacongrill
	appliance = GRILL
	items = list(
		/obj/item/reagent_containers/food/snacks/spreads,
		/obj/item/reagent_containers/food/snacks/rawbacon
	)
	result = /obj/item/reagent_containers/food/snacks/bacon

/datum/recipe/chickenfillet //Also just combinable, like burgers and hot dogs.
	appliance = GRILL
	items = list(
		/obj/item/reagent_containers/food/snacks/chickenkatsu,
		/obj/item/reagent_containers/food/snacks/bun
	)
	result = /obj/item/reagent_containers/food/snacks/chickenfillet
