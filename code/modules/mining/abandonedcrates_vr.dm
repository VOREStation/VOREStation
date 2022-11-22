/obj/structure/closet/crate/secure/loot
	tamper_proof = 2

/obj/structure/closet/crate/secure/loot/proc/generate_loot()
	var/lootvalue = 0
	while(lootvalue <= 10) //if the initial generation gives you less than 10 points of stuff, add more stuff
		//pick a thing to add to the crate - the format is "list(filepath, value) = weight,"
		var/choice = list()
		choice = pickweight(list(
			list(/obj/item/weapon/storage/backpack/dufflebag/cratebooze,5) = 5,
			list(/obj/item/weapon/storage/backpack/dufflebag/cratedrills, 5) = 5,
			list(/obj/item/weapon/reagent_containers/glass/beaker/bluespace, 3) = 5,
			list(/obj/item/weapon/ore/diamond, 1) = 10,
			list(/obj/item/weapon/ore/osmium, 1) = 10,
			list(/obj/item/weapon/ore/hydrogen, 1) = 10,
			list(/obj/item/weapon/ore/verdantium, 1) = 10,
			list(/obj/item/weapon/ore/uranium, 1) = 10,
			list(/obj/item/weapon/reagent_containers/glass/beaker/noreact, 3) = 5,
			list(/obj/item/weapon/spacecash/c500, 4) = 5,
			list(/obj/item/weapon/spacecash/c200, 2) = 10,
			list(/obj/item/weapon/spacecash/c100, 1) = 10,
			list(/obj/item/weapon/spacecash/c50, 1) = 10,
			list(/obj/item/weapon/spacecash/c20, 1) = 10,
			list(/obj/item/weapon/melee/baton, 5) = 5,
			list(/obj/item/clothing/under/shorts/red, 1) = 2,
			list(/obj/item/clothing/under/shorts/blue, 1) = 2,
			list(/obj/item/clothing/accessory/tie/horrible, 1) = 2,
			list(/obj/item/clothing/under/chameleon, 5) = 2,
			list(/obj/item/weapon/melee/classic_baton, 6) = 2,
			list(/obj/item/latexballon, 2) = 2,
			list(pick(subtypesof(/obj/item/toy/mecha)), 4) = 2,
			list(pick(subtypesof(/obj/item/toy/figure)), 4) = 2,
			list(pick(subtypesof(/obj/item/toy/plushie)), 4) = 2,
			list(pick(subtypesof(/obj/item/weapon/storage/mre)), 2) = 2,
			list(pick(subtypesof(/obj/item/weapon/storage/firstaid)), 4) = 2,
			list(pick(subtypesof(/obj/item/weapon/soap)), 1) = 2,
			list(/obj/item/toy/syndicateballoon, 3) = 2,
			list(/obj/item/weapon/rig/industrial, 6) = 2,
			list(/obj/item/clothing/head/kitty, 1) = 2,
			list(pick(subtypesof(/obj/item/weapon/coin)), 2) = 10,
			list(/obj/item/clothing/suit/ianshirt, 3) = 2,
			list(pick(subtypesof(/obj/item/weapon/stock_parts) - /obj/item/weapon/stock_parts/subspace), 2) = 2,
			list(/obj/item/weapon/pickaxe/silver, 3) = 2,
			list(/obj/item/weapon/pickaxe/drill, 3) = 2,
			list(/obj/item/weapon/pickaxe/jackhammer, 4) = 2,
			list(/obj/item/weapon/pickaxe/gold, 4) = 2,
			list(/obj/item/weapon/pickaxe/diamond, 5) = 2,
			list(/obj/item/weapon/pickaxe/diamonddrill, 6) = 2,
			list(/obj/item/weapon/pickaxe/plasmacutter, 5) = 2,
			list(/obj/item/toy/katana, 1) = 2,
			list(/obj/item/seeds/random, 2) = 2,
			list(pick(subtypesof(/obj/item/weapon/reagent_containers/food/drinks/glass2/coffeemug)), 1) = 1,
			list(/obj/item/weed_extract, 2) = 1,
			list(/obj/item/xenos_claw, 1) = 1,
			list(/obj/item/clothing/head/bearpelt, 4) = 1,
			list(/obj/item/organ/internal/heart, 1) = 1,
			list(/obj/item/device/soulstone, 5) = 1,
			list(/obj/item/weapon/material/sword/katana, 5) = 1,
			list(/obj/item/weapon/dnainjector/xraymut, 6) = 1,
			list(/obj/item/weapon/storage/backpack/clown/loaded, 5) = 1,
			list(/obj/item/weapon/storage/backpack/mime/loaded, 5) = 1,
			list(/obj/item/weapon/vampiric, 2) = 1,
			list(/obj/item/weapon/archaeological_find, 3) = 1,
			list(/obj/item/weapon/melee/energy/sword, 6) = 1,
			list(/obj/item/weapon/storage/backpack/luchador/loaded, 3) = 1,
			list(/obj/item/device/personal_shield_generator/belt/mining/loaded, 6) = 1
			))
		var/path = choice[1]
		var/value = choice[2]
		contents += new path()
		lootvalue += value

//putting the multi-object loot items as their own things

/obj/item/weapon/storage/backpack/dufflebag/cratebooze
	starts_with = list(
		/obj/item/weapon/reagent_containers/food/drinks/bottle/rum,
		/obj/item/weapon/reagent_containers/food/drinks/bottle/whiskey,
		/obj/item/weapon/reagent_containers/food/snacks/grown/ambrosiadeus
		)

/obj/item/weapon/storage/backpack/dufflebag/cratedrills
	starts_with = list(
		/obj/item/weapon/pickaxe/advdrill,
		/obj/item/device/taperecorder,
		/obj/item/clothing/suit/space,
		/obj/item/clothing/head/helmet/space
		)

/obj/item/weapon/storage/backpack/clown/loaded
	starts_with = list(
		/obj/item/clothing/under/rank/clown,
		/obj/item/clothing/shoes/clown_shoes,
		/obj/item/device/pda/clown,
		/obj/item/clothing/mask/gas/clown_hat,
		/obj/item/weapon/bikehorn,
		/obj/item/weapon/pen/crayon/rainbow,
		/obj/item/weapon/reagent_containers/spray/waterflower
	)

/obj/item/weapon/storage/backpack/mime/loaded
	starts_with = list(
		/obj/item/clothing/under/mime,
		/obj/item/clothing/shoes/black,
		/obj/item/device/pda/mime,
		/obj/item/clothing/gloves/white,
		/obj/item/clothing/mask/gas/mime,
		/obj/item/clothing/head/beret,
		/obj/item/clothing/suit/suspenders,
		/obj/item/weapon/pen/crayon/mime,
		/obj/item/weapon/reagent_containers/food/drinks/bottle/bottleofnothing
	)

/obj/item/weapon/storage/backpack/luchador/loaded
	starts_with = list(
		/obj/item/weapon/storage/belt/champion,
		/obj/item/clothing/mask/luchador
	)