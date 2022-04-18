/obj/structure/closet/secure_closet/engineering_chief
	name = "chief engineer's locker"
	req_access = list(access_ce)
	closet_appearance = /decl/closet_appearance/secure_closet/engineering/ce

	starts_with = list(
		/obj/item/clothing/accessory/storage/brown_vest,
		/obj/item/blueprints,
		///obj/item/clamp,	//VOREStation Removal: without leaks those are pointless,
		///obj/item/clamp,	//VOREStation Removal: without leaks those are pointless,
		/obj/item/clothing/under/rank/chief_engineer,
		/obj/item/clothing/under/rank/chief_engineer/skirt,
		/obj/item/clothing/head/hardhat/white,
		/obj/item/clothing/head/welding,
		/obj/item/clothing/gloves/heavy_engineer,	//VOREStation Edit: chief gets the good shit
		/obj/item/clothing/shoes/brown,
		/obj/item/cartridge/ce,
		/obj/item/radio/headset/heads/ce,
		/obj/item/radio/headset/heads/ce/alt,
		/obj/item/storage/toolbox/mechanical,
		/obj/item/clothing/suit/storage/hazardvest,
		/obj/item/clothing/mask/gas,
		/obj/item/multitool,
		/obj/item/storage/belt/utility/chief/full,
		/obj/item/flash,
		/obj/item/t_scanner/upgraded,
		/obj/item/taperoll/engineering,
		/obj/item/clothing/suit/storage/hooded/wintercoat/engineering,
		/obj/item/clothing/suit/storage/hooded/wintercoat/engineering/ce,
		/obj/item/clothing/shoes/boots/winter/engineering,
<<<<<<< HEAD
		/obj/item/clothing/head/beret/engineering/ce,
		/obj/item/clothing/head/beret/engineering/ce/white,
		/obj/item/weapon/tank/emergency/oxygen/engi,
		/obj/item/weapon/reagent_containers/spray/windowsealant) //VOREStation Add
=======
		/obj/item/tank/emergency/oxygen/engi)
>>>>>>> 61084723c7b... Merge pull request #8317 from Atermonera/remove_weapon

/obj/structure/closet/secure_closet/engineering_chief/Initialize()
	if(prob(50))
		starts_with += /obj/item/storage/backpack/industrial
	else
		starts_with += /obj/item/storage/backpack/satchel/eng
	if(prob(50))
		starts_with += /obj/item/storage/backpack/dufflebag/eng
	return ..()

/obj/structure/closet/secure_closet/engineering_electrical
	name = "electrical supplies"
	req_access = list(access_engine_equip)
	closet_appearance = /decl/closet_appearance/secure_closet/engineering/electrical

	starts_with = list(
		/obj/item/clothing/gloves/yellow = 2,
		/obj/item/storage/toolbox/electrical = 3,
		/obj/item/module/power_control = 3,
		/obj/item/multitool = 3)


/obj/structure/closet/secure_closet/engineering_welding
	name = "welding supplies"
	req_access = list(access_construction)
	closet_appearance = /decl/closet_appearance/secure_closet/engineering/welding

	starts_with = list(
		/obj/item/clothing/head/welding = 3,
		/obj/item/weldingtool/largetank = 3,
		/obj/item/weldpack = 3,
		/obj/item/clothing/glasses/welding = 3)

/obj/structure/closet/secure_closet/engineering_personal
	name = "engineer's locker"
	req_access = list(access_engine_equip)
	closet_appearance = /decl/closet_appearance/secure_closet/engineering

	starts_with = list(
		/obj/item/clothing/accessory/storage/brown_vest,
		/obj/item/storage/toolbox/mechanical,
		/obj/item/radio/headset/headset_eng,
		/obj/item/radio/headset/headset_eng/alt,
		/obj/item/clothing/suit/storage/hazardvest,
		/obj/item/clothing/mask/gas,
		/obj/item/clothing/glasses/meson,
		/obj/item/cartridge/engineering,
		/obj/item/taperoll/engineering,
		/obj/item/clothing/head/hardhat,
		/obj/item/clothing/suit/storage/hooded/wintercoat/engineering,
		/obj/item/clothing/shoes/boots/winter/engineering,
<<<<<<< HEAD
		/obj/item/weapon/tank/emergency/oxygen/engi,
		/obj/item/weapon/storage/belt/utility,	//VOREStation Add
		/obj/item/weapon/reagent_containers/spray/windowsealant) //VOREStation Add
=======
		/obj/item/tank/emergency/oxygen/engi)
>>>>>>> 61084723c7b... Merge pull request #8317 from Atermonera/remove_weapon

/obj/structure/closet/secure_closet/engineering_personal/Initialize()
	if(prob(50))
		starts_with += /obj/item/storage/backpack/industrial
	else
		starts_with += /obj/item/storage/backpack/satchel/eng
	if(prob(50))
		starts_with += /obj/item/storage/backpack/dufflebag/eng
	return ..()


/obj/structure/closet/secure_closet/atmos_personal
	name = "technician's locker"
	req_access = list(access_atmospherics)
	closet_appearance = /decl/closet_appearance/secure_closet/engineering/atmos

	starts_with = list(
		/obj/item/clothing/accessory/storage/brown_vest,
<<<<<<< HEAD
		/obj/item/clothing/suit/fire/heavy,
		/obj/item/clothing/head/hardhat/firefighter/atmos,
		/obj/item/device/flashlight,
		/obj/item/weapon/extinguisher/atmo,
		///obj/item/clamp,	//VOREStation Removal: without leaks those are pointless,
		/obj/item/device/radio/headset/headset_eng,
		/obj/item/device/radio/headset/headset_eng/alt,
		/obj/item/clothing/suit/storage/hazardvest/atmos,	//VOREStation edit. Eng locker gets regular haz-vest, atmos gets the themed one of their own
=======
		/obj/item/clothing/suit/fire/firefighter,
		/obj/item/clothing/head/hardhat/red,
		/obj/item/flashlight,
		/obj/item/extinguisher,
		/obj/item/clamp,
		/obj/item/radio/headset/headset_eng,
		/obj/item/radio/headset/headset_eng/alt,
		/obj/item/clothing/suit/storage/hazardvest,
>>>>>>> 61084723c7b... Merge pull request #8317 from Atermonera/remove_weapon
		/obj/item/clothing/mask/gas,
		/obj/item/cartridge/atmos,
		/obj/item/taperoll/atmos,
		/obj/item/clothing/suit/storage/hooded/wintercoat/engineering/atmos,
		/obj/item/clothing/shoes/boots/winter/atmos,
<<<<<<< HEAD
		/obj/item/weapon/tank/emergency/oxygen/engi,
		/obj/item/weapon/storage/belt/utility/atmostech) //VOREStation edit. They don't get a toolbox to fill it from, so why not give a spare one that's full already? 
=======
		/obj/item/tank/emergency/oxygen/engi)
>>>>>>> 61084723c7b... Merge pull request #8317 from Atermonera/remove_weapon

/obj/structure/closet/secure_closet/atmos_personal/Initialize()
	if(prob(50))
		starts_with += /obj/item/storage/backpack/industrial
	else
		starts_with += /obj/item/storage/backpack/satchel/eng
	if(prob(50))
		starts_with += /obj/item/storage/backpack/dufflebag/eng
	return ..()
