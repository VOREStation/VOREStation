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
		/obj/item/ammo_magazine/clip/c762/hunter = 9,
		/obj/item/weapon/gun/projectile/shotgun/pump/rifle = 2)

/obj/structure/closet/secure_closet/guncabinet/rifle/initialize()
	if(prob(85))
		starts_with += /obj/item/weapon/gun/projectile/shotgun/pump/rifle
	else
		starts_with += /obj/item/weapon/gun/projectile/shotgun/pump/rifle/lever
	return ..()

/obj/structure/closet/secure_closet/guncabinet/phase
	name = "phase pistol cabinet"
	req_one_access = list(access_explorer,access_brig)

	starts_with = list(
		/obj/item/weapon/gun/energy/phasegun = 2,
		/obj/item/weapon/cell/device/weapon = 2,
		/obj/item/clothing/accessory/permit/gun/planetside)

//Explorer Lockers

/obj/structure/closet/secure_closet/explorer
	name = "explorer locker"
	//VOREStation Add begin
	icon = 'icons/obj/closet_vr.dmi' //VOREStation Add
	icon_state = "secureexp1"
	icon_closed = "secureexp"
	icon_locked = "secureexp1"
	icon_opened = "secureexpopen"
	icon_broken = "secureexpbroken"
	icon_off = "secureexpoff"
	//VOREStation Add end
	req_access = list(access_explorer)

	starts_with = list(
		/obj/item/clothing/under/explorer,
		/obj/item/clothing/suit/storage/hooded/explorer,
		/obj/item/clothing/mask/gas/explorer,
		/obj/item/clothing/shoes/boots/winter/explorer,
		/obj/item/clothing/gloves/black,
		/obj/item/device/radio/headset/explorer,
		/obj/item/device/flashlight,
		/obj/item/device/gps/explorer,
		/obj/item/weapon/storage/box/flare,
		/obj/item/device/geiger,
		/obj/item/weapon/cell/device,
		/obj/item/device/radio,
		/obj/item/stack/marker_beacon/thirty,
		/obj/item/weapon/material/knife/tacknife/survival, //VOREStation Add,
		/obj/item/weapon/material/knife/machete, //VOREStation Add,
		/obj/item/clothing/accessory/holster/machete, //VOREStation Add,
		/obj/item/weapon/reagent_containers/food/snacks/liquidfood = 2) //VOREStation Add

/obj/structure/closet/secure_closet/explorer/initialize()
	if(prob(50))
		starts_with += /obj/item/weapon/storage/backpack
	else
		starts_with += /obj/item/weapon/storage/backpack/satchel/norm
	/* VOREStation Removal - Always give both
	if(prob(75))
		starts_with += /obj/item/weapon/material/knife/tacknife/survival
	else
		starts_with += /obj/item/weapon/material/knife/machete
	*/ //VOREStation Removal End
	return ..()

//SAR Lockers

/obj/structure/closet/secure_closet/sar
	name = "search and rescue locker"
	desc = "Supplies for a wilderness first responder."
	icon_state = "medical1"
	icon_closed = "medical"
	icon_locked = "medical1"
	icon_opened = "medicalopen"
	icon_broken = "medicalbroken"
	icon_off = "medicaloff"
	req_access = list(access_medical_equip)

<<<<<<< master
	starts_with = list(
		/obj/item/weapon/storage/backpack/dufflebag/emt,
		/obj/item/weapon/storage/box/autoinjectors,
		/obj/item/weapon/storage/box/syringes,
		/obj/item/weapon/reagent_containers/glass/bottle/inaprovaline,
		/obj/item/weapon/reagent_containers/glass/bottle/antitoxin,
		/obj/item/weapon/storage/belt/medical/emt,
		/obj/item/clothing/mask/gas,
		/obj/item/clothing/suit/storage/hooded/wintercoat/medical/sar,
		/obj/item/clothing/shoes/boots/winter/explorer,
		/obj/item/device/radio/headset/sar,
		/obj/item/weapon/cartridge/medical,
		/obj/item/device/flashlight,
		/obj/item/weapon/tank/emergency/oxygen/engi,
		/obj/item/clothing/glasses/hud/health,
		/obj/item/device/healthanalyzer,
		/obj/item/device/radio/off,
		/obj/random/medical,
		/obj/item/weapon/crowbar,
		/obj/item/weapon/extinguisher/mini,
		/obj/item/weapon/storage/box/freezer,
		/obj/item/clothing/accessory/storage/white_vest,
		/obj/item/taperoll/medical,
		/obj/item/device/gps,
		/obj/item/device/geiger,
		/obj/item/bodybag/cryobag)
=======

/obj/structure/closet/secure_closet/sar/New()
	..()
	new /obj/item/weapon/storage/backpack/dufflebag/emt(src)
	new /obj/item/weapon/storage/box/autoinjectors(src)
	new /obj/item/weapon/storage/box/syringes(src)
	new /obj/item/weapon/reagent_containers/glass/bottle/inaprovaline(src)
	new /obj/item/weapon/reagent_containers/glass/bottle/antitoxin(src)
	new /obj/item/weapon/storage/belt/medical/emt(src)
	new /obj/item/weapon/material/knife/tacknife/survival(src) //VOREStation Edit
	new /obj/item/clothing/mask/gas(src)
	new /obj/item/clothing/suit/storage/hooded/wintercoat/medical/sar(src)
	new /obj/item/clothing/shoes/boots/winter/explorer(src)
	new /obj/item/device/radio/headset/sar(src)
	new /obj/item/weapon/cartridge/medical(src)
	new /obj/item/device/flashlight(src)
	new /obj/item/weapon/tank/emergency/oxygen/engi(src)
	new /obj/item/clothing/glasses/hud/health(src)
	new /obj/item/device/healthanalyzer(src)
	new /obj/item/device/radio/off(src)
	new /obj/random/medical(src)
	new /obj/item/weapon/crowbar(src)
	new /obj/item/weapon/extinguisher/mini(src)
	new /obj/item/weapon/storage/box/freezer(src)
	new /obj/item/clothing/accessory/storage/white_vest(src)
	new /obj/item/taperoll/medical(src)
	new /obj/item/device/gps(src)
	new /obj/item/device/geiger(src)
	new /obj/item/bodybag/cryobag(src)
	return
>>>>>>> Pathfinder Update

//Pilot Locker

/obj/structure/closet/secure_closet/pilot
	name = "pilot locker"
	req_access = list(access_pilot)

	starts_with = list(
		/obj/item/weapon/storage/backpack/parachute,
		/obj/item/weapon/material/knife/tacknife/survival,
		/obj/item/clothing/head/pilot,
		/obj/item/clothing/under/rank/pilot1,
		/obj/item/clothing/suit/storage/toggle/bomber/pilot,
		/obj/item/clothing/mask/gas/half,
		/obj/item/clothing/shoes/black,
		/obj/item/clothing/gloves/fingerless,
		/obj/item/device/radio/headset/pilot/alt,
		/obj/item/device/flashlight,
		/obj/item/weapon/reagent_containers/food/snacks/liquidfood,
		/obj/item/weapon/reagent_containers/food/drinks/cans/waterbottle,
		/obj/item/weapon/storage/box/flare,
		/obj/item/weapon/cell/device,
		/obj/item/device/radio)

/obj/structure/closet/secure_closet/pilot/initialize()
	if(prob(50))
		starts_with += /obj/item/weapon/storage/backpack
	else
<<<<<<< master
		starts_with += /obj/item/weapon/storage/backpack/satchel/norm
	return ..()
=======
		new /obj/item/weapon/storage/backpack/satchel/norm(src)
	new /obj/item/weapon/storage/backpack/parachute(src)
	new /obj/item/weapon/material/knife/tacknife/survival(src)
	new /obj/item/clothing/head/pilot(src)
	new /obj/item/clothing/under/rank/pilot1(src)
	new /obj/item/clothing/suit/storage/toggle/bomber/pilot(src)
	new	/obj/item/clothing/mask/gas/half(src)
	new /obj/item/clothing/shoes/black(src)
	new /obj/item/clothing/gloves/fingerless(src)
	new /obj/item/device/radio/headset/pilot/alt(src)
	new /obj/item/device/flashlight(src)
	new /obj/item/device/survivalcapsule(src) //VOREStation Edit
	new /obj/item/weapon/reagent_containers/food/snacks/liquidfood(src)
	new /obj/item/weapon/reagent_containers/food/drinks/cans/waterbottle(src)
	new /obj/item/weapon/storage/box/flare(src)
	new /obj/item/weapon/cell/device(src)
	new /obj/item/device/radio(src)
	return
>>>>>>> Pathfinder Update

//VOREStation Addition - Pathfinder Lockers

/obj/structure/closet/secure_closet/pathfinder
	name = "pathfinder locker"
	icon = 'icons/obj/closet_vr.dmi'
	icon_state = "secureexp1"
	icon_closed = "secureexp"
	icon_locked = "secureexp1"
	icon_opened = "secureexpopen"
	icon_broken = "secureexpbroken"
	icon_off = "secureexpoff"
	req_access = list(access_gateway)

/obj/structure/closet/secure_closet/pathfinder/New()
	..()
	if(prob(50))
		new /obj/item/weapon/storage/backpack(src)
	else
		new /obj/item/weapon/storage/backpack/satchel/norm(src)
	new /obj/item/weapon/material/knife/tacknife/survival(src)
	new /obj/item/weapon/material/knife/machete/deluxe(src)
	new /obj/item/clothing/accessory/holster/machete(src)
	new /obj/item/clothing/under/explorer(src)
	new /obj/item/clothing/suit/storage/hooded/explorer(src)
	new	/obj/item/clothing/mask/gas/explorer(src)
	new /obj/item/clothing/shoes/boots/winter/explorer(src)
	new /obj/item/clothing/gloves/black(src)
	new /obj/item/device/radio/headset/explorer(src)
	new /obj/item/device/flashlight(src)
	new /obj/item/device/gps/explorer(src)
	new /obj/item/weapon/storage/box/flare(src)
	new /obj/item/weapon/reagent_containers/food/snacks/liquidfood(src)
	new /obj/item/weapon/reagent_containers/food/snacks/liquidfood(src)
	new /obj/item/device/geiger(src)
	new /obj/item/device/survivalcapsule/luxury(src)
	new /obj/item/weapon/cell/device(src)
	//new /obj/item/device/radio/pathfinder(src) //Removed until I can get it working
	new /obj/item/weapon/storage/box/explorerkeys(src)
	new /obj/item/stack/marker_beacon/thirty(src)
	return

//VOREStation Addition End

//Exotic Seeds Crate

/obj/structure/closet/crate/hydroponics/exotic
	name = "exotic seeds crate"
	desc = "All you need to destroy that pesky planet."

	starts_with = list(
		/obj/item/seeds/random = 6,
		/obj/item/seeds/replicapod = 2,
		/obj/item/seeds/ambrosiavulgarisseed = 2,
		/obj/item/seeds/kudzuseed,
		/obj/item/seeds/libertymycelium,
		/obj/item/seeds/reishimycelium)
