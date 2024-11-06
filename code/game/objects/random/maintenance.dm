/obj/random/maintenance //Clutter and loot for maintenance and away missions
	name = "random maintenance item"
	desc = "This is a random maintenance item."

/obj/random/maintenance/item_to_spawn()
	return pick(prob(300);/obj/random/tech_supply,
				prob(200);/obj/random/medical,
				prob(100);/obj/random/firstaid,
				prob(10);/obj/random/contraband,
				prob(50);/obj/random/action_figure,
				prob(50);/obj/random/plushie,
				prob(200);/obj/random/junk,
				prob(200);/obj/random/material,
				prob(50);/obj/random/toy,
				prob(100);/obj/random/tank,
				prob(50);/obj/random/soap,
				prob(60);/obj/random/drinkbottle,
				prob(500);/obj/random/maintenance/clean)

/obj/random/maintenance/clean
/*Maintenance loot lists without the trash, for use inside things.
Individual items to add to the maintenance list should go here, if you add
something, make sure it's not in one of the other lists.*/
	name = "random clean maintenance item"
	desc = "This is a random clean maintenance item."

/obj/random/maintenance/clean/item_to_spawn()
	return pick(prob(10);/obj/random/contraband,
				prob(2);/obj/item/flashlight/flare,
				prob(2);/obj/item/flashlight/glowstick,
				prob(2);/obj/item/flashlight/glowstick/blue,
				prob(1);/obj/item/flashlight/glowstick/orange,
				prob(1);/obj/item/flashlight/glowstick/red,
				prob(1);/obj/item/flashlight/glowstick/yellow,
				prob(1);/obj/item/flashlight/pen,
				prob(4);/obj/item/cell,
				prob(4);/obj/item/cell/device,
				prob(3);/obj/item/cell/high,
				prob(2);/obj/item/cell/super,
				prob(5);/obj/random/cigarettes,
				prob(3);/obj/item/clothing/mask/gas,
				prob(2);/obj/item/clothing/mask/gas/half,
				prob(4);/obj/item/clothing/mask/breath,
				prob(2);/obj/item/reagent_containers/glass/rag,
				prob(4);/obj/item/reagent_containers/food/snacks/liquidfood,
				prob(2);/obj/item/storage/secure/briefcase,
				prob(4);/obj/item/storage/briefcase,
				prob(5);/obj/item/storage/backpack,
				prob(5);/obj/item/storage/backpack/satchel/norm,
				prob(4);/obj/item/storage/backpack/satchel,
				prob(3);/obj/item/storage/backpack/dufflebag,
				prob(1);/obj/item/storage/backpack/dufflebag/syndie,
				prob(5);/obj/item/storage/box,
				prob(3);/obj/item/storage/box/donkpockets,
				prob(2);/obj/item/storage/box/sinpockets,
				prob(1);/obj/item/storage/box/cups,
				prob(3);/obj/item/storage/box/mousetraps,
				prob(3);/obj/item/storage/wallet,
				prob(1);/obj/item/paicard,
				prob(2);/obj/item/clothing/shoes/galoshes,
				prob(1);/obj/item/clothing/shoes/syndigaloshes,
				prob(4);/obj/item/clothing/shoes/black,
				prob(4);/obj/item/clothing/shoes/laceup,
				prob(4);/obj/item/clothing/shoes/laceup/grey,
				prob(4);/obj/item/clothing/shoes/laceup/brown,
				prob(1);/obj/item/clothing/gloves/yellow,
				prob(3);/obj/item/clothing/gloves/botanic_leather,
				prob(2);/obj/item/clothing/gloves/sterile/latex,
				prob(5);/obj/item/clothing/gloves/white,
				prob(5);/obj/item/clothing/gloves/rainbow,
				prob(2);/obj/item/clothing/gloves/fyellow,
				prob(1);/obj/item/clothing/glasses/sunglasses,
				prob(3);/obj/item/clothing/glasses/meson,
				prob(2);/obj/item/clothing/glasses/meson/prescription,
				prob(1);/obj/item/clothing/glasses/welding,
				prob(1);/obj/item/clothing/head/bio_hood/general,
				prob(4);/obj/item/clothing/head/hardhat,
				prob(3);/obj/item/clothing/head/hardhat/red,
				prob(1);/obj/item/clothing/head/ushanka,
				prob(2);/obj/item/clothing/head/welding,
				prob(4);/obj/item/clothing/suit/storage/hazardvest,
				prob(1);/obj/item/clothing/suit/space/emergency,
				prob(3);/obj/item/clothing/suit/storage/toggle/bomber,
				prob(1);/obj/item/clothing/suit/bio_suit/general,
				prob(3);/obj/item/clothing/suit/storage/toggle/hoodie/black,
				prob(3);/obj/item/clothing/suit/storage/toggle/hoodie/blue,
				prob(3);/obj/item/clothing/suit/storage/toggle/hoodie/red,
				prob(3);/obj/item/clothing/suit/storage/toggle/hoodie/yellow,
				prob(3);/obj/item/clothing/suit/storage/toggle/brown_jacket,
				prob(3);/obj/item/clothing/suit/storage/toggle/leather_jacket,
				prob(1);/obj/item/clothing/suit/storage/vest/press,
				prob(3);/obj/item/clothing/suit/storage/apron,
				prob(4);/obj/item/clothing/under/color/grey,
				prob(2);/obj/item/clothing/under/syndicate/tacticool,
				prob(2);/obj/item/clothing/under/pants/camo,
				prob(1);/obj/item/clothing/under/harness,
				prob(1);/obj/item/clothing/under/tactical,
				prob(3);/obj/item/clothing/accessory/storage/webbing,
				prob(3);/obj/item/camera_assembly,
				prob(4);/obj/item/clothing/suit/caution,
				prob(3);/obj/item/clothing/head/cone,
				prob(1);/obj/item/card/emag_broken,
				prob(2);/obj/item/camera,
				prob(3);/obj/item/pda,
				prob(3);/obj/item/radio/headset,
				/* VOREStation Edit Start */
				prob(3);/obj/item/toy/monster_bait,
				prob(2);/obj/item/toy/tennis,
				prob(2);/obj/item/toy/tennis/red,
				prob(2);/obj/item/toy/tennis/yellow,
				prob(2);/obj/item/toy/tennis/green,
				prob(2);/obj/item/toy/tennis/cyan,
				prob(2);/obj/item/toy/tennis/blue,
				prob(2);/obj/item/toy/tennis/purple,
				prob(1);/obj/item/toy/baseball,
				prob(1);/obj/item/pizzavoucher,
				prob(5);/obj/item/material/fishing_net/butterfly_net,
				prob(2);/obj/item/cracker,
				prob(5);/obj/random/mega_nukies,
				prob(1);/obj/random/potion_ingredient/plus,
				prob(2);/obj/random/translator
				/* VOREStation Edit End */
				)

/obj/random/maintenance/security
/*Maintenance loot list. This one is for around security areas*/
	name = "random security maintenance item"
	desc = "This is a random security maintenance item."
	icon_state = "security"

/obj/random/maintenance/security/item_to_spawn()
	return pick(prob(320);/obj/random/maintenance/clean,
				prob(2);/obj/item/flashlight/maglight,
				prob(2);/obj/item/flash,
				prob(1);/obj/item/cell/device/weapon,
				prob(1);/obj/item/clothing/mask/gas/swat,
				prob(1);/obj/item/clothing/mask/gas/syndicate,
				prob(2);/obj/item/clothing/mask/balaclava,
				prob(1);/obj/item/clothing/mask/balaclava/tactical,
				prob(3);/obj/item/storage/backpack/security,
				prob(3);/obj/item/storage/backpack/satchel/sec,
				prob(2);/obj/item/storage/backpack/messenger/sec,
				prob(2);/obj/item/storage/backpack/dufflebag/sec,
				prob(1);/obj/item/storage/backpack/dufflebag/syndie/ammo,
				prob(1);/obj/item/storage/backpack/dufflebag/syndie/med,
				prob(2);/obj/item/storage/box/swabs,
				prob(2);/obj/item/storage/belt/security,
				prob(1);/obj/item/grenade/flashbang,
				prob(1);/obj/item/melee/baton,
				prob(1);/obj/item/reagent_containers/spray/pepper,
				prob(3);/obj/item/clothing/shoes/boots/jackboots,
				prob(1);/obj/item/clothing/shoes/boots/swat,
				prob(1);/obj/item/clothing/shoes/boots/combat,
				prob(1);/obj/item/clothing/gloves/swat,
				prob(1);/obj/item/clothing/gloves/combat,
				prob(1);/obj/item/clothing/glasses/sunglasses/big,
				prob(2);/obj/item/clothing/glasses/hud/security,
				prob(1);/obj/item/clothing/glasses/sunglasses/sechud,
				prob(1);/obj/item/clothing/glasses/sunglasses/sechud/aviator,
				prob(1);/obj/item/clothing/glasses/sunglasses/sechud/tactical,
				prob(3);/obj/item/clothing/head/beret/sec,
				prob(3);/obj/item/clothing/head/beret/sec/corporate/officer,
				prob(3);/obj/item/clothing/head/beret/sec/navy/officer,
				prob(2);/obj/item/clothing/head/helmet,
				prob(4);/obj/item/clothing/head/soft/sec,
				prob(4);/obj/item/clothing/head/soft/sec/corp,
				prob(3);/obj/item/clothing/suit/armor/vest,
				prob(2);/obj/item/clothing/suit/armor/vest/security,
				prob(2);/obj/item/clothing/suit/storage/vest/officer,
				prob(1);/obj/item/clothing/suit/storage/vest/detective,
				prob(1);/obj/item/clothing/suit/storage/vest/press,
				prob(2);/obj/item/clothing/accessory/storage/black_vest,
				prob(2);/obj/item/clothing/accessory/storage/black_drop_pouches,
				prob(1);/obj/item/clothing/accessory/holster/leg,
				prob(1);/obj/item/clothing/accessory/holster/hip,
				prob(1);/obj/item/clothing/accessory/holster/waist,
				prob(1);/obj/item/clothing/accessory/holster/armpit,
				prob(2);/obj/item/clothing/ears/earmuffs,
				prob(2);/obj/item/handcuffs,)

/obj/random/maintenance/medical
/*Maintenance loot list. This one is for around medical areas*/
	name = "random medical maintenance item"
	desc = "This is a random medical maintenance item."
	icon_state = "medical"

/obj/random/maintenance/medical/item_to_spawn()
	return pick(prob(320);/obj/random/maintenance/clean,
				prob(25);/obj/random/medical/lite,
				prob(2);/obj/item/clothing/mask/breath/medical,
				prob(2);/obj/item/clothing/mask/surgical,
				prob(5);/obj/item/storage/backpack/medic,
				prob(5);/obj/item/storage/backpack/satchel/med,
				prob(5);/obj/item/storage/backpack/messenger/med,
				prob(3);/obj/item/storage/backpack/dufflebag/med,
				prob(1);/obj/item/storage/backpack/dufflebag/syndie/med,
				prob(2);/obj/item/storage/box/autoinjectors,
				prob(3);/obj/item/storage/box/beakers,
				prob(2);/obj/item/storage/box/bodybags,
				prob(3);/obj/item/storage/box/syringes,
				prob(3);/obj/item/storage/box/gloves,
				prob(2);/obj/item/storage/belt/medical/emt,
				prob(2);/obj/item/storage/belt/medical,
				prob(1);/obj/item/clothing/shoes/boots/combat,
				prob(3);/obj/item/clothing/shoes/white,
				prob(2);/obj/item/clothing/gloves/sterile/nitrile,
				prob(5);/obj/item/clothing/gloves/white,
				prob(2);/obj/item/clothing/glasses/hud/health,
				prob(1);/obj/item/clothing/glasses/hud/health/prescription,
				prob(1);/obj/item/clothing/head/bio_hood/virology,
				prob(4);/obj/item/clothing/suit/storage/toggle/labcoat,
				prob(1);/obj/item/clothing/suit/bio_suit/general,
				prob(2);/obj/item/clothing/under/rank/medical/paramedic,
				prob(2);/obj/item/clothing/accessory/storage/black_vest,
				prob(2);/obj/item/clothing/accessory/storage/white_vest,
				prob(1);/obj/item/clothing/accessory/storage/white_drop_pouches,
				prob(1);/obj/item/clothing/accessory/storage/black_drop_pouches,
				prob(2);/obj/item/clothing/accessory/stethoscope)

/obj/random/maintenance/engineering
/*Maintenance loot list. This one is for around medical areas*/
	name = "random engineering maintenance item"
	desc = "This is a random engineering maintenance item."
	icon_state = "tool"

/obj/random/maintenance/engineering/item_to_spawn()
	return pick(prob(320);/obj/random/maintenance/clean,
				prob(2);/obj/item/flashlight/maglight,
				prob(3);/obj/item/clothing/mask/gas/half,
				prob(2);/obj/item/clothing/mask/balaclava,
				prob(2);/obj/item/storage/briefcase/inflatable,
				prob(5);/obj/item/storage/backpack/industrial,
				prob(5);/obj/item/storage/backpack/satchel/eng,
				prob(5);/obj/item/storage/backpack/messenger/engi,
				prob(3);/obj/item/storage/backpack/dufflebag/eng,
				prob(5);/obj/item/storage/box,
				prob(2);/obj/item/storage/belt/utility/full,
				prob(3);/obj/item/storage/belt/utility,
				prob(3);/obj/item/clothing/head/beret/engineering,
				prob(3);/obj/item/clothing/head/soft/yellow,
				prob(2);/obj/item/clothing/head/orangebandana,
				prob(2);/obj/item/clothing/head/hardhat/dblue,
				prob(2);/obj/item/clothing/head/hardhat/orange,
				prob(1);/obj/item/clothing/glasses/welding,
				prob(2);/obj/item/clothing/head/welding,
				prob(4);/obj/item/clothing/suit/storage/hazardvest,
				prob(2);/obj/item/clothing/under/overalls,
				prob(3);/obj/item/clothing/shoes/boots/workboots,
				prob(1);/obj/item/clothing/shoes/magboots,
				prob(2);/obj/item/clothing/accessory/storage/black_vest,
				prob(2);/obj/item/clothing/accessory/storage/brown_vest,
				prob(1);/obj/item/clothing/accessory/storage/brown_drop_pouches,
				prob(3);/obj/item/clothing/ears/earmuffs,
				prob(1);/obj/item/beartrap,
				prob(2);/obj/item/handcuffs)

/obj/random/maintenance/research
/*Maintenance loot list. This one is for around medical areas*/
	name = "random research maintenance item"
	desc = "This is a random research maintenance item."
	icon_state = "science"

/obj/random/maintenance/research/item_to_spawn()
	return pick(prob(320);/obj/random/maintenance/clean,
				prob(3);/obj/item/analyzer/plant_analyzer,
				prob(1);/obj/item/flash/synthetic,
				prob(2);/obj/item/bucket_sensor,
				prob(1);/obj/item/cell/device/weapon,
				prob(5);/obj/item/storage/backpack/toxins,
				prob(5);/obj/item/storage/backpack/satchel/tox,
				prob(5);/obj/item/storage/backpack/messenger/tox,
				prob(2);/obj/item/storage/excavation,
				prob(1);/obj/item/storage/backpack/holding,
				prob(3);/obj/item/storage/box/beakers,
				prob(3);/obj/item/storage/box/syringes,
				prob(3);/obj/item/storage/box/gloves,
				prob(2);/obj/item/clothing/gloves/sterile/latex,
				prob(4);/obj/item/clothing/glasses/science,
				prob(3);/obj/item/clothing/glasses/material,
				prob(1);/obj/item/clothing/head/beret/purple,
				prob(1);/obj/item/clothing/head/bio_hood/scientist,
				prob(4);/obj/item/clothing/suit/storage/toggle/labcoat,
				prob(4);/obj/item/clothing/suit/storage/toggle/labcoat/science,
				prob(1);/obj/item/clothing/suit/bio_suit/scientist,
				prob(4);/obj/item/clothing/under/rank/scientist,
				prob(2);/obj/item/clothing/under/rank/scientist_new)

/obj/random/maintenance/cargo
/*Maintenance loot list. This one is for around cargo areas*/
	name = "random cargo maintenance item"
	desc = "This is a random cargo maintenance item."

/obj/random/maintenance/cargo/item_to_spawn()
	return pick(prob(320);/obj/random/maintenance/clean,
				prob(3);/obj/item/flashlight/lantern,
				prob(4);/obj/item/pickaxe,
				prob(3);/obj/item/pickaxe/drill,
				prob(5);/obj/item/storage/backpack/industrial,
				prob(5);/obj/item/storage/backpack/satchel/norm,
				prob(3);/obj/item/storage/backpack/dufflebag,
				prob(1);/obj/item/storage/backpack/dufflebag/syndie/ammo,
				prob(1);/obj/item/storage/toolbox/syndicate,
				prob(1);/obj/item/storage/belt/utility/full,
				prob(2);/obj/item/storage/belt/utility,
				prob(4);/obj/item/toner,
				prob(1);/obj/item/destTagger,
				prob(3);/obj/item/clothing/glasses/material,
				prob(3);/obj/item/clothing/head/soft/yellow,
				prob(4);/obj/item/clothing/suit/storage/hazardvest,
				prob(3);/obj/item/clothing/suit/storage/apron/overalls,
				prob(4);/obj/item/clothing/suit/storage/apron,
				prob(2);/obj/item/clothing/under/syndicate/tacticool,
				prob(1);/obj/item/clothing/under/syndicate/combat,
				prob(2);/obj/item/clothing/accessory/storage/black_vest,
				prob(2);/obj/item/clothing/accessory/storage/brown_vest,
				prob(3);/obj/item/clothing/ears/earmuffs,
				prob(1);/obj/item/beartrap,
				prob(2);/obj/item/handcuffs,)
