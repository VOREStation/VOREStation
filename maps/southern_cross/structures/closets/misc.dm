//Gun Cabinets

/obj/structure/closet/secure_closet/guncabinet/sidearm
	name = "emergency weapon cabinet"
	req_one_access = list(access_armory,access_captain)

/obj/structure/closet/secure_closet/guncabinet/sidearm/New()
	..()
	for(var/i = 1 to 4)
		new /obj/item/weapon/gun/energy/gun(src)
	return

/obj/structure/closet/secure_closet/guncabinet/rifle
	name = "rifle cabinet"
	req_access = list(access_explorer)

/obj/structure/closet/secure_closet/guncabinet/rifle/New()
	..()
	for(var/i = 1 to 9)
		new /obj/item/ammo_magazine/clip/c762/hunter(src)
	if(prob(85))
		new /obj/item/weapon/gun/projectile/shotgun/pump/rifle(src)
	else
		new /obj/item/weapon/gun/projectile/shotgun/pump/rifle/lever(src)
	new /obj/item/weapon/gun/projectile/shotgun/pump/rifle(src)
	new /obj/item/weapon/gun/projectile/shotgun/pump/rifle(src)
	return

//Explorer Lockers

/obj/structure/closet/secure_closet/explorer
	name = "explorer locker"
	req_access = list(access_explorer)

/obj/structure/closet/secure_closet/explorer/New()
	..()
	if(prob(50))
		new /obj/item/weapon/storage/backpack(src)
	else
		new /obj/item/weapon/storage/backpack/satchel/norm(src)
	new /obj/item/clothing/under/explorer(src)
	new /obj/item/clothing/suit/storage/hooded/explorer(src)
	new	/obj/item/clothing/mask/gas/explorer(src)
	new /obj/item/clothing/shoes/boots/winter/explorer(src)
	new /obj/item/clothing/gloves/black(src)
	new /obj/item/device/radio/headset(src)
	new /obj/item/device/flashlight(src)
	new /obj/item/device/gps/explorer(src)
	new /obj/item/weapon/material/knife/tacknife/survival(src)
	new /obj/item/weapon/storage/box/flare(src)
	new /obj/item/device/geiger(src)
	new /obj/item/weapon/cell/device(src)
	new /obj/item/device/radio(src)
	new /obj/item/stack/marker_beacon/thirty(src)
	return

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


/obj/structure/closet/secure_closet/sar/New()
	..()
	new /obj/item/weapon/storage/backpack/dufflebag/emt(src)
	new /obj/item/weapon/storage/box/autoinjectors(src)
	new /obj/item/weapon/storage/box/syringes(src)
	new /obj/item/weapon/reagent_containers/glass/bottle/inaprovaline(src)
	new /obj/item/weapon/reagent_containers/glass/bottle/antitoxin(src)
	new /obj/item/weapon/storage/belt/medical/emt(src)
	new /obj/item/clothing/mask/gas(src)
	new /obj/item/clothing/suit/storage/hooded/wintercoat/medical/sar(src)
	new /obj/item/clothing/shoes/boots/winter/explorer(src)
	new /obj/item/device/radio/headset/headset_med/alt(src)
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
	return
