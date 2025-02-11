/obj/structure/closet/crate/secure/loot
	tamper_proof = 2

/obj/structure/closet/crate/secure/loot/proc/generate_loot()
	var/lootvalue = 0
	while(lootvalue <= 10) //if the initial generation gives you less than 10 points of stuff, add more stuff
		//pick a thing to add to the crate - the format is "list(filepath, value) = weight,"
		var/choice = list()
		choice = pickweight(list(
			list(pick(/obj/item/ore/diamond,
				/obj/item/ore/osmium,
				/obj/item/ore/hydrogen,
				/obj/item/ore/verdantium,
				/obj/item/ore/uranium), 1) = 10,
			list(pick(subtypesof(/obj/item/coin)), 2) = 10,
			list(/obj/item/spacecash/c500, 4) = 5,
			list(/obj/item/spacecash/c200, 2) = 10,
			list(/obj/item/spacecash/c100, 1) = 10,
			list(/obj/item/spacecash/c50, 1) = 10,
			list(/obj/item/spacecash/c20, 1) = 10,
			list(pick(subtypesof(/obj/item/reagent_containers/food/drinks/bottle/) - /obj/item/reagent_containers/food/drinks/bottle/small), 1) = 5,
			list(/obj/item/storage/backpack/dufflebag/cratebooze,5) = 5,
			list(/obj/item/storage/backpack/dufflebag/cratedrills, 5) = 5,
			list(/obj/item/reagent_containers/glass/beaker/bluespace, 3) = 5,
			list(/obj/item/reagent_containers/glass/beaker/noreact, 3) = 5,
			list(/obj/item/melee/baton, 5) = 4,
			list(pick(subtypesof(/obj/item/storage/mre)), 2) = 3,
			list(/obj/item/seeds/random, 2) = 3,
			list(/obj/item/clothing/under/chameleon, 5) = 3,
			list(/obj/item/melee/classic_baton, 6) = 3,
			list(/obj/item/rig/industrial, 6) = 3,
			list(/obj/item/multitool/hacktool, 5) = 3,
			list(/obj/item/multitool/hacktool/modified, 4) = 4,
			list(/obj/item/toy/katana, 1) = 2,
			list(/obj/item/clothing/head/kitty, 1) = 2,
			list(pick(subtypesof(/obj/item/soap)), 1) = 2,
			list(/obj/item/clothing/under/shorts/red, 1) = 2,
			list(/obj/item/clothing/under/shorts/blue, 1) = 2,
			list(/obj/item/clothing/accessory/tie/horrible, 1) = 2,
			list(pick(subtypesof(/obj/item/stock_parts) - /obj/item/stock_parts/subspace), 2) = 3,
			list(/obj/item/latexballon, 2) = 2,
			list(/obj/item/toy/syndicateballoon, 3) = 2,
			list(/obj/item/clothing/suit/ianshirt, 3) = 2,
			list(/obj/item/clothing/head/bearpelt, 4) = 2,
			//list(/obj/item/archaeological_find, 3) = 2, // Removed, causes runtimes
			list(pick(subtypesof(/obj/item/toy/mecha)), 4) = 2,
			list(pick(subtypesof(/obj/item/toy/figure)), 4) = 2,
			list(pick(subtypesof(/obj/item/toy/plushie)), 4) = 2,
			list(pick(subtypesof(/obj/item/storage/firstaid)), 4) = 2,
			list(/obj/item/pickaxe/silver, 3) = 2,
			list(/obj/item/pickaxe/drill, 3) = 2,
			list(/obj/item/pickaxe/jackhammer, 4) = 2,
			list(/obj/item/pickaxe/gold, 4) = 2,
			list(/obj/item/pickaxe/diamond, 5) = 2,
			list(/obj/item/pickaxe/diamonddrill, 6) = 2,
			list(/obj/item/pickaxe/plasmacutter, 5) = 2,
			list(/obj/item/soulstone, 5) = 2,
			list(/obj/item/material/sword/katana, 5) = 2,
			list(/obj/item/storage/belt/utility/chief/full, 8) = 2,
			list(/obj/item/personal_shield_generator/belt/mining/loaded, 6) = 2,
			list(pick(subtypesof(/obj/item/melee/energy/sword) - /obj/item/melee/energy/sword/charge), 6) = 2,
			// Traitgenes New injector loot
			list(pick(/obj/item/dnainjector/random_good,/obj/item/dnainjector/random_good_labeled,/obj/item/dnainjector/random_labeled,/obj/item/dnainjector/random), 6) = 2,
			list(/obj/item/gun/energy/netgun, 7) = 2,
			list(pick(prob(300);/obj/item/gun/energy/mouseray,
				prob(50);/obj/item/gun/energy/mouseray/corgi,
				prob(50);/obj/item/gun/energy/mouseray/woof,
				prob(50);/obj/item/gun/energy/mouseray/cat,
				prob(50);/obj/item/gun/energy/mouseray/chicken,
				prob(50);/obj/item/gun/energy/mouseray/lizard,
				prob(50);/obj/item/gun/energy/mouseray/rabbit,
				prob(50);/obj/item/gun/energy/mouseray/fennec,
				prob(5);/obj/item/gun/energy/mouseray/monkey,
				prob(5);/obj/item/gun/energy/mouseray/wolpin,
				prob(5);/obj/item/gun/energy/mouseray/otie,
				prob(5);/obj/item/gun/energy/mouseray/direwolf,
				prob(5);/obj/item/gun/energy/mouseray/giantrat,
				prob(50);/obj/item/gun/energy/mouseray/redpanda,
				prob(5);/obj/item/gun/energy/mouseray/catslug,
				prob(5);/obj/item/gun/energy/mouseray/teppi,
				prob(1);/obj/item/gun/energy/mouseray/metamorphosis,
				prob(1);/obj/item/gun/energy/mouseray/metamorphosis/advanced/random
				), 8) = 2,
			list(/obj/item/gun/energy/pummeler, 11) = 2,
			list(pick(subtypesof(/obj/item/reagent_containers/food/drinks/glass2/coffeemug)), 1) = 1,
			list(/obj/item/xenos_claw, 1) = 1,
			list(/obj/item/organ/internal/heart, 1) = 1,
			list(/obj/item/vampiric, 2) = 1,
			list(/obj/item/weed_extract, 2) = 1,
			list(/obj/item/storage/backpack/luchador/loaded, 3) = 1,
			list(/obj/item/storage/backpack/clown/loaded, 5) = 1,
			list(/obj/item/storage/backpack/mime/loaded, 5) = 1,
			list(pick(/obj/item/multitool/alien,
				/obj/item/stack/cable_coil/alien,
				/obj/item/tool/crowbar/alien,
				/obj/item/tool/screwdriver/alien,
				/obj/item/weldingtool/alien,
				/obj/item/tool/wirecutters/alien,
				/obj/item/tool/wrench/alien), 7) = 1,
			list(pick(/obj/item/melee/energy/axe, /obj/item/melee/energy/spear), 11) = 1,
			list(/obj/item/card/emag/used, 7) = 1,
			list(pick(/obj/item/grenade/spawnergrenade/spesscarp, /obj/item/grenade/spawnergrenade/spider, /obj/item/grenade/explosive/frag), 7) = 1,
			list(/obj/item/grenade/flashbang/clusterbang, 7) = 1,
			list(/obj/item/card/emag, 11) = 1,
			list(/obj/item/melee/shock_maul, 11) = 3,
			list(/obj/item/clothing/suit/storage/vest/martian_miner/reinforced, 4) = 6,
			list(/obj/item/storage/backpack/sport/hyd/catchemall, 11) = 1,
			list(/obj/item/prop/alien/junk, 12) = 1,
			))
		var/path = choice[1]
		var/value = choice[2]
		contents += new path()
		lootvalue += value

//putting the multi-object loot items as their own things

/obj/item/storage/backpack/dufflebag/cratebooze
	starts_with = list(
		/obj/item/reagent_containers/food/drinks/bottle/rum,
		/obj/item/reagent_containers/food/drinks/bottle/whiskey,
		/obj/item/reagent_containers/food/snacks/grown/ambrosiadeus,
		/obj/item/reagent_containers/food/snacks/grown/ambrosiadeus,
		/obj/item/reagent_containers/food/snacks/grown/ambrosiadeus,
		)

/obj/item/storage/backpack/dufflebag/cratedrills
	starts_with = list(
		/obj/item/pickaxe/advdrill,
		/obj/item/taperecorder,
		/obj/item/clothing/suit/space,
		/obj/item/clothing/head/helmet/space
		)

/obj/item/storage/backpack/clown/loaded
	starts_with = list(
		/obj/item/clothing/under/rank/clown,
		/obj/item/clothing/shoes/clown_shoes,
		/obj/item/pda/clown,
		/obj/item/clothing/mask/gas/clown_hat,
		/obj/item/bikehorn,
		/obj/item/pen/crayon/rainbow,
		/obj/item/reagent_containers/spray/waterflower
	)

/obj/item/storage/backpack/mime/loaded
	starts_with = list(
		/obj/item/clothing/under/mime,
		/obj/item/clothing/shoes/black,
		/obj/item/pda/mime,
		/obj/item/clothing/gloves/white,
		/obj/item/clothing/mask/gas/mime,
		/obj/item/clothing/head/beret,
		/obj/item/clothing/suit/suspenders,
		/obj/item/pen/crayon/mime,
		/obj/item/reagent_containers/food/drinks/bottle/bottleofnothing
	)

/obj/item/storage/backpack/luchador/loaded
	starts_with = list(
		/obj/item/storage/belt/champion,
		/obj/item/clothing/mask/luchador
	)


/obj/item/storage/backpack/sport/hyd/catchemall
	name = "sports backpack"
	desc = "A green sports backpack."
	starts_with = list(
		/obj/item/clothing/head/soft/red,
		/obj/item/clothing/suit/varsity/blue,
		/obj/item/clothing/under/pants/youngfolksjeans,
		/obj/item/capture_crystal
	)

/obj/item/storage/backpack/sport/hyd/catchemall/Initialize() //gotta have your starter 'mon too (or an improved way to catch one)
	. = ..()
	var/path = pick(subtypesof(/obj/item/capture_crystal))
	contents += new path()
