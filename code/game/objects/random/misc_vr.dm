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
