/datum/recipe/humanburger
	appliance = GRILL
	items = list(
		/obj/item/food/meat/human,
		/obj/item/food/bun
	)
	result = /obj/item/food/human/burger
	wiki_flag = WIKI_SPOILER // Alt recipie doesn't need to be shown(breaks tgui)

/datum/recipe/plainburger
	appliance = GRILL
	items = list(
		/obj/item/food/bun,
		/obj/item/food/meat //do not place this recipe before /datum/recipe/humanburger
	)
	result = /obj/item/food/monkeyburger

/datum/recipe/syntiburger
	appliance = GRILL
	items = list(
		/obj/item/food/bun,
		/obj/item/food/meat/syntiflesh
	)
	result = /obj/item/food/monkeyburger
	wiki_flag = WIKI_SPOILER // Alt recipie doesn't need to be shown(breaks tgui)

/datum/recipe/brainburger
	appliance = GRILL
	items = list(
		/obj/item/food/bun,
		/obj/item/organ/internal/brain
	)
	result = /obj/item/food/brainburger

/datum/recipe/roburger
	appliance = GRILL
	items = list(
		/obj/item/food/bun,
		/obj/item/robot_parts/head
	)
	result = /obj/item/food/roburger

/datum/recipe/xenoburger
	appliance = GRILL
	items = list(
		/obj/item/food/bun,
		/obj/item/food/xenomeat
	)
	result = /obj/item/food/xenoburger

/datum/recipe/fishburger
	appliance = GRILL
	items = list(
		/obj/item/food/bun,
		/obj/item/food/carpmeat
	)
	result = /obj/item/food/fishburger

/datum/recipe/tofuburger
	appliance = GRILL
	items = list(
		/obj/item/food/bun,
		/obj/item/food/tofu
	)
	result = /obj/item/food/tofuburger

/datum/recipe/ghostburger
	appliance = GRILL
	items = list(
		/obj/item/food/bun,
		/obj/item/ectoplasm //where do you even find this stuff
	)
	result = /obj/item/food/ghostburger

/datum/recipe/clownburger
	appliance = GRILL
	items = list(
		/obj/item/food/bun,
		/obj/item/clothing/mask/gas/clown_hat
	)
	result = /obj/item/food/clownburger

/datum/recipe/mimeburger
	appliance = GRILL
	items = list(
		/obj/item/food/bun,
		/obj/item/clothing/head/beret
	)
	result = /obj/item/food/mimeburger

/datum/recipe/mouseburger
	appliance = GRILL
	items = list(
		/obj/item/food/bun,
		/obj/item/holder/mouse
	)
	result = /obj/item/food/mouseburger

/datum/recipe/bunbun
	appliance = GRILL
	items = list(
		/obj/item/food/bun,
		/obj/item/food/bun
	)
	result = /obj/item/food/bunbun
	wiki_flag = WIKI_SPOILER

/datum/recipe/hotdog
	appliance = GRILL
	items = list(
		/obj/item/food/bun,
		/obj/item/food/sausage
	)
	result = /obj/item/food/hotdog

/datum/recipe/humankabob
	appliance = GRILL
	items = list(
		/obj/item/stack/rods,
		/obj/item/food/meat/human,
		/obj/item/food/meat/human,
	)
	result = /obj/item/food/human/kabob
	wiki_flag = WIKI_SPOILER

/datum/recipe/kabob	//Do not put before humankabob
	appliance = GRILL
	items = list(
		/obj/item/stack/rods,
		/obj/item/food/meat,
		/obj/item/food/meat,
	)
	result = /obj/item/food/monkeykabob

/datum/recipe/monkeykabob
	appliance = GRILL
	items = list(
		/obj/item/stack/rods,
		/obj/item/food/meat/monkey,
		/obj/item/food/meat/monkey
	)
	result = /obj/item/food/monkeykabob
	wiki_flag = WIKI_SPOILER // Alt recipie doesn't need to be shown(breaks tgui)

/datum/recipe/syntikabob
	appliance = GRILL
	items = list(
		/obj/item/stack/rods,
		/obj/item/food/meat/syntiflesh,
		/obj/item/food/meat/syntiflesh
	)
	result = /obj/item/food/monkeykabob
	wiki_flag = WIKI_SPOILER // Alt recipie doesn't need to be shown(breaks tgui)

/datum/recipe/tofukabob
	appliance = GRILL
	items = list(
		/obj/item/stack/rods,
		/obj/item/food/tofu,
		/obj/item/food/tofu,
	)
	result = /obj/item/food/tofukabob

/datum/recipe/fakespellburger
	appliance = GRILL
	items = list(
		/obj/item/food/monkeyburger,
		/obj/item/clothing/head/wizard/fake,
	)
	result = /obj/item/food/spellburger
	wiki_flag = WIKI_SPOILER

/datum/recipe/spellburger
	appliance = GRILL
	items = list(
		/obj/item/food/monkeyburger,
		/obj/item/clothing/head/wizard,
	)
	result = /obj/item/food/spellburger

/datum/recipe/bigbiteburger
	appliance = GRILL
	items = list(
		/obj/item/food/monkeyburger,
		/obj/item/food/meat,
		/obj/item/food/meat,
		/obj/item/food/meat,
	)
	reagents = list(REAGENT_ID_EGG = 3)
	reagent_mix = RECIPE_REAGENT_REPLACE
	result = /obj/item/food/bigbiteburger

/datum/recipe/superbiteburger
	appliance = GRILL
	fruit = list(PLANT_TOMATO = 1)
	reagents = list(REAGENT_ID_SODIUMCHLORIDE = 5, REAGENT_ID_BLACKPEPPER = 5)
	items = list(
		/obj/item/food/bigbiteburger,
		/obj/item/food/dough,
		/obj/item/food/meat,
		/obj/item/food/cheesewedge,
		/obj/item/food/boiledegg,
	)
	result = /obj/item/food/superbiteburger

/datum/recipe/slimeburger
	appliance = GRILL
	reagents = list(REAGENT_ID_SLIMEJELLY = 5)
	items = list(
		/obj/item/food/bun
	)
	result = /obj/item/food/jellyburger/slime

/datum/recipe/jellyburger
	appliance = GRILL
	reagents = list(REAGENT_ID_CHERRYJELLY = 5)
	items = list(
		/obj/item/food/bun
	)
	result = /obj/item/food/jellyburger/cherry

/datum/recipe/bearburger
	appliance = GRILL
	items = list(
		/obj/item/food/bun,
		/obj/item/food/bearmeat
	)
	result = /obj/item/food/bearburger

/datum/recipe/baconburger
	appliance = GRILL
	items = list(
		/obj/item/food/bun,
		/obj/item/food/meat,
		/obj/item/food/bacon,
		/obj/item/food/bacon
	)
	result = /obj/item/food/burger/bacon

/datum/recipe/omelette
	appliance = GRILL
	items = list(
		/obj/item/food/cheesewedge,
		/obj/item/food/cheesewedge,
	)
	reagents = list(REAGENT_ID_EGG = 6)
	reagent_mix = RECIPE_REAGENT_REPLACE
	result = /obj/item/food/omelette

/datum/recipe/omurice
	appliance = GRILL
	reagents = list(REAGENT_ID_RICE = 5, REAGENT_ID_KETCHUP = 5, REAGENT_ID_EGG = 3)
	result = /obj/item/food/omurice

/datum/recipe/omurice/heart
	appliance = GRILL
	reagents = list(REAGENT_ID_RICE = 5, REAGENT_ID_KETCHUP = 5, REAGENT_ID_SUGAR = 5, REAGENT_ID_EGG = 3)
	result = /obj/item/food/omurice/heart

/datum/recipe/omurice/face
	appliance = GRILL
	reagents = list(REAGENT_ID_RICE = 5, REAGENT_ID_KETCHUP = 5, REAGENT_ID_SODIUMCHLORIDE = 1, REAGENT_ID_EGG = 3)
	result = /obj/item/food/omurice/face

/datum/recipe/meatsteak
	appliance = GRILL
	reagents = list(REAGENT_ID_SODIUMCHLORIDE = 1, REAGENT_ID_BLACKPEPPER = 1)
	items = list(/obj/item/food/meat)
	result = /obj/item/food/meatsteak

/datum/recipe/honeytoast
	appliance = GRILL
	reagents = list(REAGENT_ID_HONEY = 5)
	items = list(
		/obj/item/food/slice/bread
	)
	reagent_mix = RECIPE_REAGENT_REPLACE //Simplify end product
	result = /obj/item/food/honeytoast

/datum/recipe/grilled_carp
	appliance = GRILL
	items = list(
		/obj/item/food/carpmeat,
		/obj/item/food/carpmeat,
		/obj/item/food/carpmeat,
		/obj/item/food/carpmeat,
		/obj/item/food/carpmeat,
		/obj/item/food/carpmeat
	)
	reagents = list(REAGENT_ID_SPACESPICE = 1)
	fruit = list(PLANT_LETTUCE = 1, PLANT_LIME = 1)
	result = /obj/item/food/sliceable/grilled_carp

/datum/recipe/grilledcheese
	appliance = GRILL
	items = list(
		/obj/item/food/slice/bread,
		/obj/item/food/slice/bread,
		/obj/item/food/cheesewedge,
	)
	result = /obj/item/food/grilledcheese

/datum/recipe/toastedsandwich
	appliance = GRILL
	items = list(
		/obj/item/food/sandwich
	)
	result = /obj/item/food/toastedsandwich

/datum/recipe/cheese_cracker
	appliance = GRILL
	items = list(
		/obj/item/food/spreads/butter,
		/obj/item/food/slice/bread,
		/obj/item/food/cheesewedge
	)
	reagents = list(REAGENT_ID_SPACESPICE = 1)
	result = /obj/item/food/cheesetoast
	result_quantity = 4

/datum/recipe/bacongrill
	appliance = GRILL
	items = list(
		/obj/item/food/spreads,
		/obj/item/food/rawbacon
	)
	result = /obj/item/food/bacon

/datum/recipe/chickenfillet //Also just combinable, like burgers and hot dogs.
	appliance = GRILL
	items = list(
		/obj/item/food/chickenkatsu,
		/obj/item/food/bun
	)
	result = /obj/item/food/chickenfillet
