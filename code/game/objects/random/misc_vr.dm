//This file is for VR only

/obj/random/explorer_shield
	name = "random explorer shield"
	desc = "This is a random shield for the explorer lockers."
	icon = 'icons/obj/weapons_vr.dmi'
	icon_state = "explorer_shield"

/obj/random/explorer_shield/item_to_spawn()
	return pick(/obj/item/weapon/shield/riot/explorer,
				/obj/item/weapon/shield/riot/explorer/purple)

/obj/random/awayloot
	name = "random away mission loot"
	desc = "A list of things that people can find in away missions."
	icon = 'icons/mob/randomlandmarks.dmi'
	icon_state = "awayloot"
	spawn_nothing_percentage = 50

/obj/random/awayloot/item_to_spawn()
	return pick(prob(50);/obj/item/weapon/aliencoin/basic,
				prob(40);/obj/item/weapon/aliencoin/silver,
				prob(30);/obj/item/weapon/aliencoin/gold,
				prob(20);/obj/item/weapon/aliencoin/phoron,
				prob(10);/obj/item/device/denecrotizer,
				prob(5);/obj/item/capture_crystal,
				prob(5);/obj/item/device/perfect_tele,
				prob(5);/obj/item/weapon/bluespace_harpoon,
				prob(1);/obj/item/weapon/cell/infinite,
				prob(1);/obj/item/weapon/cell/void,
				prob(1);/obj/item/weapon/cell/device/weapon/recharge/alien,
				prob(1);/obj/item/clothing/shoes/boots/speed,
				prob(1);/obj/item/device/nif,
				prob(1);/obj/item/device/paicard,
				prob(2);/obj/item/weapon/storage/backpack/dufflebag/syndie,
				prob(2);/obj/item/weapon/storage/backpack/dufflebag/syndie/ammo,
				prob(2);/obj/item/weapon/storage/backpack/dufflebag/syndie/med,
				prob(2);/obj/item/clothing/mask/gas/voice,
				prob(2);/obj/item/device/radio_jammer,
				prob(1);/obj/item/toy/bosunwhistle,
				prob(1);/obj/item/weapon/bananapeel,
				prob(5);/obj/fiftyspawner/platinum,
				prob(3);/obj/fiftyspawner/gold,
				prob(3);/obj/fiftyspawner/silver,
				prob(1);/obj/fiftyspawner/diamond,
				prob(5);/obj/fiftyspawner/phoron,
				prob(1);/obj/item/weapon/telecube/randomized,
				prob(1);/obj/item/capture_crystal/random
				)

/obj/random/awayloot/nofail
	name = "garunteed random away mission loot"
	spawn_nothing_percentage = 0

/obj/random/awayloot/looseloot
/obj/random/awayloot/looseloot/item_to_spawn()
	return pick(prob(50);/obj/item/weapon/aliencoin,
				prob(40);/obj/item/weapon/aliencoin/silver,
				prob(30);/obj/item/weapon/aliencoin/gold,
				prob(20);/obj/item/weapon/aliencoin/phoron,
				prob(10);/obj/item/device/denecrotizer,
				prob(5);/obj/item/capture_crystal,
				prob(3);/obj/item/capture_crystal/great,
				prob(1);/obj/item/capture_crystal/ultra,
				prob(4);/obj/item/capture_crystal/random,
				prob(5);/obj/item/device/perfect_tele,
				prob(5);/obj/item/weapon/bluespace_harpoon,
				prob(1);/obj/item/weapon/cell/infinite,
				prob(1);/obj/item/weapon/cell/void,
				prob(1);/obj/item/weapon/cell/device/weapon/recharge/alien,
				prob(1);/obj/item/clothing/shoes/boots/speed,
				prob(1);/obj/item/device/nif,
				prob(1);/obj/item/device/paicard,
				prob(2);/obj/item/weapon/storage/backpack/dufflebag/syndie,
				prob(2);/obj/item/weapon/storage/backpack/dufflebag/syndie/ammo,
				prob(2);/obj/item/weapon/storage/backpack/dufflebag/syndie/med,
				prob(2);/obj/item/clothing/mask/gas/voice,
				prob(2);/obj/item/device/radio_jammer,
				prob(1);/obj/item/toy/bosunwhistle,
				prob(1);/obj/item/weapon/bananapeel,
				prob(5);/obj/fiftyspawner/platinum,
				prob(3);/obj/fiftyspawner/gold,
				prob(3);/obj/fiftyspawner/silver,
				prob(1);/obj/fiftyspawner/diamond,
				prob(5);/obj/fiftyspawner/phoron,
				prob(1);/obj/item/weapon/telecube/randomized,
				prob(10);/obj/random/empty_or_lootable_crate,
				prob(10);/obj/random/medical,
				prob(5);/obj/random/firstaid,
				prob(30);/obj/random/maintenance,
				prob(10);/obj/random/mre,
				prob(15);/obj/random/snack,
				prob(10);/obj/random/tech_supply,
				prob(15);/obj/random/tech_supply/component,
				prob(10);/obj/random/tool,
				prob(5);/obj/random/tool/power,
				prob(1);/obj/random/tool/alien,
				prob(5);/obj/random/weapon,
				prob(5);/obj/random/ammo_all,
				prob(3);/obj/random/projectile/random,
				prob(5);/obj/random/multiple/voidsuit
				)

/obj/random/mainttoyloot
	name = "random loot from maint"
	desc = "A list of things that people can find in away missions."
	icon = 'icons/mob/randomlandmarks.dmi'
	icon_state = "fanc_trejur"
	spawn_nothing_percentage = 50

/obj/random/mainttoyloot/item_to_spawn()
	return pick(prob(50);/obj/item/weapon/aliencoin/basic,
				prob(40);/obj/item/weapon/aliencoin/silver,
				prob(30);/obj/item/weapon/aliencoin/gold,
				prob(20);/obj/item/weapon/aliencoin/phoron,
				prob(5);/obj/item/capture_crystal,
				prob(5);/obj/random/mouseray,
				prob(5);/obj/item/device/perfect_tele,
				prob(5);/obj/item/weapon/bluespace_harpoon,
				prob(1);/obj/item/device/paicard,
				prob(2);/obj/item/weapon/storage/backpack/dufflebag/syndie,
				prob(2);/obj/item/weapon/storage/backpack/dufflebag/syndie/ammo,
				prob(2);/obj/item/weapon/storage/backpack/dufflebag/syndie/med,
				prob(2);/obj/item/clothing/mask/gas/voice,
				prob(2);/obj/item/device/radio_jammer,
				prob(1);/obj/item/toy/bosunwhistle,
				prob(1);/obj/item/weapon/bananapeel,
				prob(5);/obj/fiftyspawner/platinum,
				prob(3);/obj/fiftyspawner/gold,
				prob(3);/obj/fiftyspawner/silver,
				prob(1);/obj/fiftyspawner/diamond,
				prob(5);/obj/fiftyspawner/phoron,
				prob(1);/obj/item/capture_crystal/random,
				prob(1);/obj/random/unidentified_medicine
				)
/obj/random/mainttoyloot/nofail
	spawn_nothing_percentage = 0


/obj/random/maintenance/misc //Clutter and loot for maintenance and away missions
	name = "random maintenance item"
	desc = "This is a random maintenance item."
	icon = 'icons/mob/randomlandmarks.dmi'
	icon_state = "trejur"
	spawn_nothing_percentage = 25


/obj/random/maintenance/misc/item_to_spawn()
	return pick(prob(500);/obj/random/maintenance,
				prob(300);/obj/random/maintenance/cargo,
				prob(300);/obj/random/maintenance/engineering,
				prob(300);/obj/random/maintenance/medical,
				prob(300);/obj/random/maintenance/research,
				prob(300);/obj/random/maintenance/security,
				prob(300);/obj/random/maintenance/security,
				prob(50);/obj/random/maintenance/morestuff,
				prob(25);/obj/random/mainttoyloot/nofail,
				prob(10);/obj/random/maintenance/foodstuff)

/obj/random/maintenance/foodstuff
	name = "random food or drink item"
	desc = "This is a random maintenance item."
	icon = 'icons/mob/randomlandmarks.dmi'
	icon_state = "foodstuffs"
	spawn_nothing_percentage = 0


/obj/random/maintenance/foodstuff/item_to_spawn()
	return pick(prob(100);/obj/random/snack,
				prob(100);/obj/random/drinksoft,
				prob(50);/obj/random/mre,
				prob(10);/obj/random/donkpocketbox,
				prob(1);/obj/random/meat)

/obj/random/maintenance/morestuff
	name = "random potentially useful things"
	desc = "This is a random maintenance item."
	icon = 'icons/mob/randomlandmarks.dmi'
	icon_state = "trejur"
	spawn_nothing_percentage = 0


/obj/random/maintenance/misc/item_to_spawn()
	return pick(prob(10);/obj/random/tool,
				prob(1);/obj/random/toolbox,
				prob(2);/obj/random/powercell,
				prob(2);/obj/random/flashlight,
				prob(1);/obj/random/pouch,
				prob(1);/obj/random/thermalponcho,
				prob(5);/obj/random/contraband,
				prob(5);/obj/random/cargopod,
				prob(1);/obj/item/weapon/flame/lighter,
				prob(1);/obj/item/weapon/storage/wallet/random,
				prob(1);/obj/random/cutout)

/obj/random/instrument
	name = "random instrument"
	desc = "This is a random instrument."
	icon = 'icons/obj/musician.dmi'
	icon_state = "violin"
	spawn_nothing_percentage = 0

/obj/random/instrument/item_to_spawn()
	return pick(prob(5);/obj/item/instrument/violin,
				prob(5);/obj/item/instrument/banjo,
				prob(5);/obj/item/instrument/guitar,
				prob(5);/obj/item/instrument/eguitar,
				prob(5);/obj/item/instrument/accordion,
				prob(5);/obj/item/instrument/trumpet,
				prob(5);/obj/item/instrument/saxophone,
				prob(5);/obj/item/instrument/trombone,
				prob(5);/obj/item/instrument/recorder,
				prob(5);/obj/item/instrument/harmonica,
				prob(1);/obj/item/instrument/bikehorn,
				prob(5);/obj/item/instrument/piano_synth,
				prob(5);/obj/item/instrument/glockenspiel,
				prob(1);/obj/item/instrument/musicalmoth
				)

/obj/random/internal_organ
	name = "random organ"
	desc = "A random internal organ. Juicy fresh! Or... maybe not."
	icon = 'icons/obj/surgery.dmi'
	icon_state = "heart"
	spawn_nothing_percentage = 10

/obj/random/internal_organ/item_to_spawn()
	return pick(prob(5);/obj/item/organ/internal/appendix,
				prob(5);/obj/item/organ/internal/eyes,
				prob(5);/obj/item/organ/internal/heart,
				prob(5);/obj/item/organ/internal/kidneys,
				prob(5);/obj/item/organ/internal/liver,
				prob(5);/obj/item/organ/internal/spleen,
				prob(5);/obj/item/organ/internal/lungs,
				prob(5);/obj/item/organ/internal/stomach,
				prob(5);/obj/item/organ/internal/voicebox,
				)

/obj/random/potion
	name = "random potion"
	desc = "A random potion."
	icon_state = "potion"
	spawn_nothing_percentage = 0

/obj/random/potion/item_to_spawn()
	return pick(prob(20);/obj/item/weapon/reagent_containers/glass/bottle/potion/healing,
				prob(4);/obj/item/weapon/reagent_containers/glass/bottle/potion/greater_healing,
				prob(20);/obj/item/weapon/reagent_containers/glass/bottle/potion/fire_resist,
				prob(20);/obj/item/weapon/reagent_containers/glass/bottle/potion/antidote,
				prob(20);/obj/item/weapon/reagent_containers/glass/bottle/potion/water,
				prob(8);/obj/item/weapon/reagent_containers/glass/bottle/potion/regeneration,
				prob(10);/obj/item/weapon/reagent_containers/glass/bottle/potion/panacea,
				prob(10);/obj/item/weapon/reagent_containers/glass/bottle/potion/magic,
				prob(10);/obj/item/weapon/reagent_containers/glass/bottle/potion/lightness,
				prob(4);/obj/item/weapon/reagent_containers/glass/bottle/potion/SOP,
				prob(4);/obj/item/weapon/reagent_containers/glass/bottle/potion/shrink,
				prob(4);/obj/item/weapon/reagent_containers/glass/bottle/potion/growth,
				prob(20);/obj/item/weapon/reagent_containers/glass/bottle/potion/pain,
				prob(10);/obj/item/weapon/reagent_containers/glass/bottle/potion/faerie,
				prob(10);/obj/item/weapon/reagent_containers/glass/bottle/potion/relaxation,
				prob(10);/obj/item/weapon/reagent_containers/glass/bottle/potion/speed,
				prob(10);/obj/item/weapon/reagent_containers/glass/bottle/potion/attractiveness,
				prob(4);/obj/item/weapon/reagent_containers/glass/bottle/potion/girljuice,
				prob(4);/obj/item/weapon/reagent_containers/glass/bottle/potion/boyjuice,
				prob(4);/obj/item/weapon/reagent_containers/glass/bottle/potion/badpolymorph,
				prob(2);/obj/item/weapon/reagent_containers/glass/bottle/potion/bonerepair,
				prob(1);/obj/item/weapon/reagent_containers/glass/bottle/potion/truepolymorph
				)

/obj/random/potion_ingredient
	name = "random potion ingredient"
	desc = "A random potion."
	icon_state = "ingredient"
	spawn_nothing_percentage = 0

/obj/random/potion_ingredient/item_to_spawn()
	return pick(prob(10);/obj/item/weapon/potion_material/blood_ruby,
				prob(2);/obj/item/weapon/potion_material/ruby_eye,
				prob(10);/obj/item/weapon/potion_material/golden_scale,
				prob(10);/obj/item/weapon/potion_material/frozen_dew,
				prob(10);/obj/item/weapon/potion_material/living_coral,
				prob(4);/obj/item/weapon/potion_material/rare_horn,
				prob(5);/obj/item/weapon/potion_material/moldy_bread,
				prob(5);/obj/item/weapon/potion_material/glowing_gem,
				prob(5);/obj/item/weapon/potion_material/giant_toe,
				prob(2);/obj/item/weapon/potion_material/flesh_of_the_stars,
				prob(2);/obj/item/weapon/potion_material/spinning_poppy,
				prob(2);/obj/item/weapon/potion_material/salt_mage,
				prob(10);/obj/item/weapon/potion_material/golden_grapes,
				prob(5);/obj/item/weapon/potion_material/fairy_house,
				prob(5);/obj/item/weapon/potion_material/thorny_bulb,
				prob(5);/obj/item/weapon/potion_material/ancient_egg,
				prob(5);/obj/item/weapon/potion_material/crown_stem,
				prob(2);/obj/item/weapon/potion_material/red_ingot,
				prob(2);/obj/item/weapon/potion_material/soft_diamond,
				prob(2);/obj/item/weapon/potion_material/solid_mist,
				prob(1);/obj/item/weapon/potion_material/spider_leg,
				prob(1);/obj/item/weapon/potion_material/folded_dark
				)

/obj/random/potion_base
	name = "random potion base"
	desc = "A random potion base."
	icon_state = "base"
	spawn_nothing_percentage = 0

/obj/random/potion_base/item_to_spawn()
	return pick(prob(10);/obj/item/weapon/potion_base/aqua_regia,
				prob(10);/obj/item/weapon/potion_base/ichor,
				prob(10);/obj/item/weapon/potion_base/alkahest
				)

/obj/random/fantasy_item
	name = "random fantasy item"
	desc = "A random fantasy item."
	icon_state = "fantasy"
	spawn_nothing_percentage = 0

/obj/random/fantasy_item/item_to_spawn()
	return pick(prob(3);/obj/item/device/healthanalyzer/scroll,
				prob(10);/obj/item/weapon/gun/energy/taser/magic,
				prob(5);/obj/item/weapon/bluespace_harpoon/wand,
				prob(10);/obj/item/device/slow_sizegun/magic,
				prob(10);/obj/item/clothing/gloves/bluespace/magic,
				prob(30);/obj/item/weapon/coin/gold,
				prob(30);/obj/item/weapon/coin/silver,
				prob(30);/obj/item/weapon/coin/platinum,
				prob(20);/obj/item/weapon/material/sword/rapier,
				prob(20);/obj/item/weapon/material/sword/longsword,
				prob(20);/obj/item/clothing/head/helmet/bucket/wood,
				prob(3);/obj/item/weapon/tool/wirecutters/alien/magic,
				prob(3);/obj/item/weapon/tool/crowbar/alien/magic,
				prob(3);/obj/item/weapon/tool/screwdriver/alien/magic,
				prob(3);/obj/item/weapon/weldingtool/alien/magic,
				prob(3);/obj/item/weapon/tool/wrench/alien/magic,
				prob(3);/obj/item/weapon/surgical/bone_clamp/alien/magic,
				prob(10);/obj/item/stack/material/gold,
				prob(10);/obj/item/stack/material/silver,
				prob(3);/obj/item/weapon/bone/skull,
				prob(20);/obj/item/weapon/material/twohanded/staff,
				prob(3);/obj/item/weapon/gun/energy/hooklauncher/ring,
				prob(3);/obj/item/toy/eight_ball
				)
