//Gun Cabinets

/obj/structure/closet/secure_closet/guncabinet/sidearm
	name = "emergency weapon cabinet"
	req_one_access = list(access_armory,access_captain)

	starts_with = list(
		/obj/item/weapon/gun/energy/gun = 4)


/obj/structure/closet/secure_closet/guncabinet/rifle
	name = "rifle cabinet"
	req_one_access = list(access_explorer,access_brig)

	starts_with = list(
		/obj/item/weapon/ammo_magazine/clip/c762/hunter = 9,
		/obj/item/weapon/gun/projectile/shotgun/pump/rifle = 2)

/obj/structure/closet/secure_closet/guncabinet/rifle/Initialize()
	if(prob(85))
		starts_with += /obj/item/weapon/gun/projectile/shotgun/pump/rifle
	else
		starts_with += /obj/item/weapon/gun/projectile/shotgun/pump/rifle/lever
	return ..()

/obj/structure/closet/secure_closet/guncabinet/phase
	name = "explorer weapon cabinet"
	req_one_access = list(access_explorer,access_brig)

	starts_with = list(
		/obj/item/weapon/gun/energy/phasegun = 2,
		/obj/item/weapon/gun/energy/phasegun/pistol,
		/obj/item/weapon/cell/device/weapon = 2,
		/obj/item/weapon/clothing/accessory/permit/gun/planetside)

//Explorer Lockers

/obj/structure/closet/secure_closet/explorer
	name = "explorer locker"
	req_access = list(access_explorer)

	starts_with = list(
		/obj/item/weapon/clothing/under/explorer,
		/obj/item/weapon/clothing/suit/armor/pcarrier/explorer/light,
		/obj/item/weapon/clothing/head/helmet/explorer,
		/obj/item/weapon/clothing/suit/storage/hooded/explorer,
		/obj/item/weapon/clothing/mask/gas/explorer,
		/obj/item/weapon/clothing/shoes/boots/winter/explorer,
		/obj/item/weapon/clothing/gloves/black,
		/obj/item/weapon/radio/headset/explorer,
		/obj/item/weapon/flashlight,
		/obj/item/weapon/gps/explorer,
		/obj/item/weapon/storage/box/flare,
		/obj/item/weapon/geiger,
		/obj/item/weapon/cell/device,
		/obj/item/weapon/radio,
		/obj/item/weapon/stack/marker_beacon/thirty,
		/obj/item/weapon/cataloguer
		)

/obj/structure/closet/secure_closet/explorer/Initialize()
	if(prob(50))
		starts_with += /obj/item/weapon/storage/backpack/rucksack
	else
		starts_with += /obj/item/weapon/storage/backpack/satchel/norm
	if(prob(75))
		starts_with += /obj/item/weapon/material/knife/tacknife/survival
	else
		starts_with += /obj/item/weapon/material/knife/machete
	return ..()

//SAR Lockers

/obj/structure/closet/secure_closet/sar
	name = "search and rescue locker"
	desc = "Supplies for a wilderness first responder."
	req_access = list(access_medical_equip)
	closet_appearance = /decl/closet_appearance/secure_closet/medical

	starts_with = list(
		/obj/item/weapon/storage/backpack/dufflebag/emt,
		/obj/item/weapon/storage/box/autoinjectors,
		/obj/item/weapon/storage/box/syringes,
		/obj/item/weapon/reagent_containers/glass/bottle/inaprovaline,
		/obj/item/weapon/reagent_containers/glass/bottle/antitoxin,
		/obj/item/weapon/storage/belt/medical/emt,
		/obj/item/weapon/clothing/mask/gas,
		/obj/item/weapon/clothing/suit/storage/hooded/wintercoat/medical/sar,
		/obj/item/weapon/clothing/shoes/boots/winter/explorer,
		/obj/item/weapon/radio/headset/sar,
		/obj/item/weapon/cartridge/medical,
		/obj/item/weapon/flashlight,
		/obj/item/weapon/tank/emergency/oxygen/engi,
		/obj/item/weapon/clothing/glasses/hud/health,
		/obj/item/weapon/healthanalyzer,
		/obj/item/weapon/radio/off,
		/obj/random/medical,
		/obj/item/weapon/tool/crowbar,
		/obj/item/weapon/extinguisher/mini,
		/obj/item/weapon/storage/box/freezer,
		/obj/item/weapon/clothing/accessory/storage/white_vest,
		/obj/item/weapon/taperoll/medical,
		/obj/item/weapon/gps,
		/obj/item/weapon/geiger,
		/obj/item/weapon/bodybag/cryobag)

//Cynosure Paramedic Locker

/obj/structure/closet/secure_closet/paramedic
	name = "paramedic locker"
	desc = "Supplies for a first responder."
	req_access = list(access_medical_equip)
	closet_appearance = /decl/closet_appearance/secure_closet/medical/paramedic

	starts_with = list(
		/obj/item/weapon/storage/backpack/dufflebag/emt,
		/obj/item/weapon/storage/box/autoinjectors,
		/obj/item/weapon/storage/box/syringes,
		/obj/item/weapon/reagent_containers/glass/bottle/inaprovaline,
		/obj/item/weapon/reagent_containers/glass/bottle/antitoxin,
		/obj/item/weapon/storage/belt/medical/emt,
		/obj/item/weapon/clothing/mask/gas,
		/obj/item/weapon/clothing/suit/storage/toggle/fr_jacket,
		/obj/item/weapon/clothing/suit/storage/toggle/labcoat/emt,
		/obj/item/weapon/clothing/suit/storage/hooded/wintercoat/medical/sar,
		/obj/item/weapon/clothing/shoes/boots/winter/explorer,
		/obj/item/weapon/radio/headset/headset_med/alt,
		/obj/item/weapon/radio/headset/sar,
		/obj/item/weapon/cartridge/medical,
		/obj/item/weapon/storage/briefcase/inflatable,
		/obj/item/weapon/flashlight,
		/obj/item/weapon/tank/emergency/oxygen/engi,
		/obj/item/weapon/clothing/glasses/hud/health,
		/obj/item/weapon/healthanalyzer,
		/obj/item/weapon/radio/off,
		/obj/random/medical,
		/obj/item/weapon/tool/crowbar,
		/obj/item/weapon/extinguisher/mini,
		/obj/item/weapon/storage/box/freezer,
		/obj/item/weapon/clothing/accessory/storage/white_vest,
		/obj/item/weapon/taperoll/medical,
		/obj/item/weapon/gps/medical,
		/obj/item/weapon/geiger,
		/obj/item/weapon/gun/energy/phasegun/pistol,
		/obj/item/weapon/cell/device/weapon
		)

//Pilot Locker

/obj/structure/closet/secure_closet/pilot
	name = "pilot locker"
	req_access = list(access_explorer)

	starts_with = list(
		/obj/item/weapon/storage/backpack/parachute,
		/obj/item/weapon/material/knife/tacknife/survival,
		/obj/item/weapon/clothing/head/pilot,
		/obj/item/weapon/clothing/under/rank/pilot1,
		/obj/item/weapon/clothing/suit/storage/toggle/bomber/pilot,
		/obj/item/weapon/clothing/mask/gas/half,
		/obj/item/weapon/clothing/shoes/black,
		/obj/item/weapon/clothing/gloves/fingerless,
		/obj/item/weapon/radio/headset/explorer/alt,
		/obj/item/weapon/flashlight,
		/obj/item/weapon/reagent_containers/food/snacks/liquidfood,
		/obj/item/weapon/reagent_containers/food/drinks/cans/waterbottle,
		/obj/item/weapon/storage/box/flare,
		/obj/item/weapon/cell/device,
		/obj/item/weapon/radio)

/obj/structure/closet/secure_closet/pilot/Initialize()
	if(prob(50))
		starts_with += /obj/item/weapon/storage/backpack
	else
		starts_with += /obj/item/weapon/storage/backpack/satchel/norm
	return ..()

//Exotic Seeds Crate

/obj/structure/closet/crate/hydroponics/exotic
	name = "exotic seeds crate"
	desc = "All you need to destroy that pesky planet."

	starts_with = list(
		/obj/item/weapon/seeds/random = 6,
		/obj/item/weapon/seeds/replicapod = 2,
		/obj/item/weapon/seeds/ambrosiavulgarisseed = 2,
		/obj/item/weapon/seeds/kudzuseed,
		/obj/item/weapon/seeds/libertymycelium,
		/obj/item/weapon/seeds/reishimycelium)
