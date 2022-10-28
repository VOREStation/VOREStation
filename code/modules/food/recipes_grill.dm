/datum/recipe/humanburger
	appliance = GRILL
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/meat/human,
		/obj/item/weapon/reagent_containers/food/snacks/bun
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/human/burger

/datum/recipe/plainburger
	appliance = GRILL
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/bun,
		/obj/item/weapon/reagent_containers/food/snacks/meat //do not place this recipe before /datum/recipe/humanburger
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/monkeyburger

/datum/recipe/syntiburger
	appliance = GRILL
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/bun,
		/obj/item/weapon/reagent_containers/food/snacks/meat/syntiflesh
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/monkeyburger

/datum/recipe/brainburger
	appliance = GRILL
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/bun,
		/obj/item/organ/internal/brain
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/brainburger

/datum/recipe/roburger
	appliance = GRILL
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/bun,
		/obj/item/robot_parts/head
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/roburger

/datum/recipe/xenoburger
	appliance = GRILL
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/bun,
		/obj/item/weapon/reagent_containers/food/snacks/xenomeat
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/xenoburger

/datum/recipe/fishburger
	appliance = GRILL
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/bun,
		/obj/item/weapon/reagent_containers/food/snacks/carpmeat
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/fishburger

/datum/recipe/tofuburger
	appliance = GRILL
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/bun,
		/obj/item/weapon/reagent_containers/food/snacks/tofu
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/tofuburger

/datum/recipe/ghostburger
	appliance = GRILL
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/bun,
		/obj/item/weapon/ectoplasm //where do you even find this stuff
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/ghostburger

/datum/recipe/clownburger
	appliance = GRILL
	items = list(
<<<<<<< HEAD
		/obj/item/weapon/reagent_containers/food/snacks/bun,
		/obj/item/clothing/mask/gas/clown_hat
=======
		/obj/item/reagent_containers/food/snacks/bun,
		/obj/item/clothing/mask/gas/costume
>>>>>>> 540b5cf6487... Merge pull request #8797 from Cerebulon/holloweeb
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/clownburger

/datum/recipe/mimeburger
	appliance = GRILL
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/bun,
		/obj/item/clothing/head/beret
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/mimeburger

/datum/recipe/mouseburger
	appliance = GRILL
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/bun,
		/obj/item/weapon/holder/mouse
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/mouseburger

/datum/recipe/bunbun
	appliance = GRILL
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/bun,
		/obj/item/weapon/reagent_containers/food/snacks/bun
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/bunbun

/datum/recipe/hotdog
	appliance = GRILL
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/bun,
		/obj/item/weapon/reagent_containers/food/snacks/sausage
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/hotdog

/datum/recipe/humankabob
	appliance = GRILL
	items = list(
		/obj/item/stack/rods,
		/obj/item/weapon/reagent_containers/food/snacks/meat/human,
		/obj/item/weapon/reagent_containers/food/snacks/meat/human,
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/human/kabob

/datum/recipe/kabob	//Do not put before humankabob
	appliance = GRILL
	items = list(
		/obj/item/stack/rods,
		/obj/item/weapon/reagent_containers/food/snacks/meat,
		/obj/item/weapon/reagent_containers/food/snacks/meat,
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/monkeykabob

/datum/recipe/monkeykabob
	appliance = GRILL
	items = list(
		/obj/item/stack/rods,
		/obj/item/weapon/reagent_containers/food/snacks/meat/monkey,
		/obj/item/weapon/reagent_containers/food/snacks/meat/monkey
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/monkeykabob

/datum/recipe/syntikabob
	appliance = GRILL
	items = list(
		/obj/item/stack/rods,
		/obj/item/weapon/reagent_containers/food/snacks/meat/syntiflesh,
		/obj/item/weapon/reagent_containers/food/snacks/meat/syntiflesh
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/monkeykabob

/datum/recipe/tofukabob
	appliance = GRILL
	items = list(
		/obj/item/stack/rods,
		/obj/item/weapon/reagent_containers/food/snacks/tofu,
		/obj/item/weapon/reagent_containers/food/snacks/tofu,
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/tofukabob

/datum/recipe/fakespellburger
	appliance = GRILL
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/monkeyburger,
		/obj/item/clothing/head/wizard/fake,
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/spellburger

/datum/recipe/spellburger
	appliance = GRILL
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/monkeyburger,
		/obj/item/clothing/head/wizard,
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/spellburger

/datum/recipe/bigbiteburger
	appliance = GRILL
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/monkeyburger,
		/obj/item/weapon/reagent_containers/food/snacks/meat,
		/obj/item/weapon/reagent_containers/food/snacks/meat,
		/obj/item/weapon/reagent_containers/food/snacks/meat,
	)
	reagents = list("egg" = 3)
	reagent_mix = RECIPE_REAGENT_REPLACE
	result = /obj/item/weapon/reagent_containers/food/snacks/bigbiteburger

/datum/recipe/superbiteburger
	appliance = GRILL
	fruit = list("tomato" = 1)
	reagents = list("sodiumchloride" = 5, "blackpepper" = 5)
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/bigbiteburger,
		/obj/item/weapon/reagent_containers/food/snacks/dough,
		/obj/item/weapon/reagent_containers/food/snacks/meat,
		/obj/item/weapon/reagent_containers/food/snacks/cheesewedge,
		/obj/item/weapon/reagent_containers/food/snacks/boiledegg,
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/superbiteburger

/datum/recipe/slimeburger
	appliance = GRILL
	reagents = list("slimejelly" = 5)
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/bun
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/jellyburger/slime

/datum/recipe/jellyburger
	appliance = GRILL
	reagents = list("cherryjelly" = 5)
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/bun
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/jellyburger/cherry

/datum/recipe/bearburger
	appliance = GRILL
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/bun,
		/obj/item/weapon/reagent_containers/food/snacks/bearmeat
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/bearburger

/datum/recipe/baconburger
	appliance = GRILL
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/bun,
		/obj/item/weapon/reagent_containers/food/snacks/meat,
		/obj/item/weapon/reagent_containers/food/snacks/bacon,
		/obj/item/weapon/reagent_containers/food/snacks/bacon
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/burger/bacon

/datum/recipe/omelette
	appliance = GRILL
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/cheesewedge,
		/obj/item/weapon/reagent_containers/food/snacks/cheesewedge,
	)
	reagents = list("egg" = 6)
	reagent_mix = RECIPE_REAGENT_REPLACE
	result = /obj/item/weapon/reagent_containers/food/snacks/omelette

/datum/recipe/omurice
	appliance = GRILL
	reagents = list("rice" = 5, "ketchup" = 5, "egg" = 3)
	result = /obj/item/weapon/reagent_containers/food/snacks/omurice

/datum/recipe/omurice/heart
	appliance = GRILL
	reagents = list("rice" = 5, "ketchup" = 5, "sugar" = 5, "egg" = 3)
	result = /obj/item/weapon/reagent_containers/food/snacks/omurice/heart

/datum/recipe/omurice/face
	appliance = GRILL
	reagents = list("rice" = 5, "ketchup" = 5, "sodiumchloride" = 1, "egg" = 3)
	result = /obj/item/weapon/reagent_containers/food/snacks/omurice/face

/datum/recipe/meatsteak
	appliance = GRILL
	reagents = list("sodiumchloride" = 1, "blackpepper" = 1)
	items = list(/obj/item/weapon/reagent_containers/food/snacks/meat)
	result = /obj/item/weapon/reagent_containers/food/snacks/meatsteak

/datum/recipe/honeytoast
	appliance = GRILL
	reagents = list("honey" = 5)
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/slice/bread
	)
	reagent_mix = RECIPE_REAGENT_REPLACE //Simplify end product
	result = /obj/item/weapon/reagent_containers/food/snacks/honeytoast

/datum/recipe/grilled_carp
	appliance = GRILL
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/carpmeat,
		/obj/item/weapon/reagent_containers/food/snacks/carpmeat,
		/obj/item/weapon/reagent_containers/food/snacks/carpmeat,
		/obj/item/weapon/reagent_containers/food/snacks/carpmeat,
		/obj/item/weapon/reagent_containers/food/snacks/carpmeat,
		/obj/item/weapon/reagent_containers/food/snacks/carpmeat
	)
	reagents = list("spacespice" = 1)
	fruit = list("lettuce" = 1, "lime" = 1)
	result = /obj/item/weapon/reagent_containers/food/snacks/sliceable/grilled_carp

/datum/recipe/grilledcheese
	appliance = GRILL
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/slice/bread,
		/obj/item/weapon/reagent_containers/food/snacks/slice/bread,
		/obj/item/weapon/reagent_containers/food/snacks/cheesewedge,
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/grilledcheese

/datum/recipe/toastedsandwich
	appliance = GRILL
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/sandwich
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/toastedsandwich

/datum/recipe/cheese_cracker
	appliance = GRILL
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/spreads/butter,
		/obj/item/weapon/reagent_containers/food/snacks/slice/bread,
		/obj/item/weapon/reagent_containers/food/snacks/cheesewedge
	)
	reagents = list("spacespice" = 1)
	result = /obj/item/weapon/reagent_containers/food/snacks/cheesetoast
	result_quantity = 4

/datum/recipe/bacongrill
	appliance = GRILL
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/spreads,
		/obj/item/weapon/reagent_containers/food/snacks/rawbacon
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/bacon

/datum/recipe/chickenfillet //Also just combinable, like burgers and hot dogs.
	appliance = GRILL
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/chickenkatsu,
		/obj/item/weapon/reagent_containers/food/snacks/bun
	)
<<<<<<< HEAD
	result = /obj/item/weapon/reagent_containers/food/snacks/chickenfillet
=======
	result = /obj/item/reagent_containers/food/snacks/chickenfillet
>>>>>>> 540b5cf6487... Merge pull request #8797 from Cerebulon/holloweeb
