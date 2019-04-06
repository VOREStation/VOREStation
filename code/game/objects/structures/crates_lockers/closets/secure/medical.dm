/obj/structure/closet/secure_closet/medical1
	name = "medicine closet"
	desc = "Filled with medical junk."
	icon_state = "medical1"
	icon_closed = "medical"
	icon_locked = "medical1"
	icon_opened = "medicalopen"
	icon_broken = "medicalbroken"
	icon_off = "medicaloff"
	req_access = list(access_medical)

	starts_with = list(
		/obj/item/weapon/storage/box/autoinjectors,
		/obj/item/weapon/storage/box/syringes,
		/obj/item/weapon/reagent_containers/dropper = 2,
		/obj/item/weapon/reagent_containers/glass/beaker = 2,
		/obj/item/weapon/reagent_containers/glass/bottle/inaprovaline = 2,
		/obj/item/weapon/reagent_containers/glass/bottle/antitoxin = 2)


/obj/structure/closet/secure_closet/medical2
	name = "anesthetics closet"
	desc = "Used to knock people out."
	icon_state = "medical1"
	icon_closed = "medical"
	icon_locked = "medical1"
	icon_opened = "medicalopen"
	icon_broken = "medicalbroken"
	icon_off = "medicaloff"
	req_access = list(access_surgery)

	starts_with = list(
		/obj/item/weapon/tank/anesthetic = 3,
		/obj/item/clothing/mask/breath/medical = 3)


/obj/structure/closet/secure_closet/medical3
	name = "medical doctor's locker"
	req_access = list(access_medical_equip)
	icon_state = "securemed1"
	icon_closed = "securemed"
	icon_locked = "securemed1"
	icon_opened = "securemedopen"
	icon_broken = "securemedbroken"
	icon_off = "securemedoff"

	starts_with = list(
		/obj/item/clothing/under/rank/medical,
		/obj/item/clothing/under/rank/nurse,
		/obj/item/clothing/under/rank/orderly,
		/obj/item/clothing/suit/storage/toggle/labcoat,
		/obj/item/clothing/suit/storage/toggle/fr_jacket,
		/obj/item/clothing/shoes/white,
		/obj/item/weapon/cartridge/medical,
		/obj/item/device/radio/headset/headset_med,
		/obj/item/device/radio/headset/headset_med/alt,
		/obj/item/clothing/suit/storage/hooded/wintercoat/medical,
		/obj/item/clothing/shoes/boots/winter/medical,
		/obj/item/clothing/under/rank/nursesuit,
		/obj/item/clothing/head/nursehat,
		/obj/item/weapon/storage/box/freezer = 3)

/obj/structure/closet/secure_closet/medical3/Initialize()
	if(prob(50))
		starts_with += /obj/item/weapon/storage/backpack/medic
	else
		starts_with += /obj/item/weapon/storage/backpack/satchel/med
	if(prob(50))
		starts_with += /obj/item/weapon/storage/backpack/dufflebag/med
	switch(pick("blue", "green", "purple", "black", "navyblue"))
		if ("blue")
			starts_with += /obj/item/clothing/under/rank/medical/scrubs
			starts_with += /obj/item/clothing/head/surgery/blue
		if ("green")
			starts_with += /obj/item/clothing/under/rank/medical/scrubs/green
			starts_with += /obj/item/clothing/head/surgery/green
		if ("purple")
			starts_with += /obj/item/clothing/under/rank/medical/scrubs/purple
			starts_with += /obj/item/clothing/head/surgery/purple
		if ("black")
			starts_with += /obj/item/clothing/under/rank/medical/scrubs/black
			starts_with += /obj/item/clothing/head/surgery/black
		if ("navyblue")
			starts_with += /obj/item/clothing/under/rank/medical/scrubs/navyblue
			starts_with += /obj/item/clothing/head/surgery/navyblue
	switch(pick("blue", "green", "purple", "black", "navyblue"))
		if ("blue")
			starts_with += /obj/item/clothing/under/rank/medical/scrubs
			starts_with += /obj/item/clothing/head/surgery/blue
		if ("green")
			starts_with += /obj/item/clothing/under/rank/medical/scrubs/green
			starts_with += /obj/item/clothing/head/surgery/green
		if ("purple")
			starts_with += /obj/item/clothing/under/rank/medical/scrubs/purple
			starts_with += /obj/item/clothing/head/surgery/purple
		if ("black")
			starts_with += /obj/item/clothing/under/rank/medical/scrubs/black
			starts_with += /obj/item/clothing/head/surgery/black
		if ("navyblue")
			starts_with += /obj/item/clothing/under/rank/medical/scrubs/navyblue
			starts_with += /obj/item/clothing/head/surgery/navyblue
	return ..()


/obj/structure/closet/secure_closet/paramedic
	name = "paramedic locker"
	desc = "Supplies for a first responder."
	icon_state = "medical1"
	icon_closed = "medical"
	icon_locked = "medical1"
	icon_opened = "medicalopen"
	icon_broken = "medicalbroken"
	icon_off = "medicaloff"
	req_access = list(access_medical_equip)

	starts_with = list(
		/obj/item/weapon/storage/backpack/dufflebag/emt,
		/obj/item/weapon/storage/box/autoinjectors,
		/obj/item/weapon/storage/box/syringes,
		/obj/item/weapon/reagent_containers/glass/bottle/inaprovaline,
		/obj/item/weapon/reagent_containers/glass/bottle/antitoxin,
		/obj/item/weapon/storage/belt/medical/emt,
		/obj/item/clothing/mask/gas,
		/obj/item/clothing/suit/storage/toggle/fr_jacket,
		/obj/item/clothing/suit/storage/toggle/labcoat/emt,
		/obj/item/device/radio/headset/headset_med/alt,
		/obj/item/weapon/cartridge/medical,
		/obj/item/weapon/storage/briefcase/inflatable,
		/obj/item/device/flashlight,
		/obj/item/weapon/tank/emergency/oxygen/engi,
		/obj/item/clothing/glasses/hud/health,
		/obj/item/device/healthanalyzer,
		/obj/item/device/radio/off,
		/obj/random/medical,
		/obj/item/weapon/tool/crowbar,
		/obj/item/weapon/extinguisher/mini,
		/obj/item/weapon/storage/box/freezer,
		/obj/item/clothing/accessory/storage/white_vest,
		/obj/item/taperoll/medical)

/obj/structure/closet/secure_closet/CMO
	name = "chief medical officer's locker"
	req_access = list(access_cmo)
	icon_state = "cmosecure1"
	icon_closed = "cmosecure"
	icon_locked = "cmosecure1"
	icon_opened = "cmosecureopen"
	icon_broken = "cmosecurebroken"
	icon_off = "cmosecureoff"

	starts_with = list(
		/obj/item/clothing/under/rank/chief_medical_officer,
		/obj/item/clothing/under/rank/chief_medical_officer/skirt,
		/obj/item/clothing/suit/storage/toggle/labcoat/cmo,
		/obj/item/clothing/suit/storage/toggle/labcoat/cmoalt,
		/obj/item/weapon/cartridge/cmo,
		/obj/item/clothing/gloves/sterile/latex,
		/obj/item/clothing/shoes/brown	,
		/obj/item/device/radio/headset/heads/cmo,
		/obj/item/device/radio/headset/heads/cmo/alt,
		/obj/item/device/flash,
		/obj/item/weapon/reagent_containers/hypospray/vial,
		/obj/item/clothing/suit/storage/hooded/wintercoat/medical,
		/obj/item/clothing/shoes/boots/winter/medical,
		/obj/item/weapon/storage/box/freezer,
		/obj/item/clothing/mask/gas,
		/obj/item/taperoll/medical,
		/obj/item/clothing/suit/bio_suit/cmo,
		/obj/item/clothing/head/bio_hood/cmo,
		/obj/item/clothing/shoes/white,
		/obj/item/weapon/reagent_containers/glass/beaker/vial) //VOREStation Add

/obj/structure/closet/secure_closet/CMO/Initialize()
	if(prob(50))
		starts_with += /obj/item/weapon/storage/backpack/medic
	else
		starts_with += /obj/item/weapon/storage/backpack/satchel/med
	if(prob(50))
		starts_with += /obj/item/weapon/storage/backpack/dufflebag/med
	switch(pick("blue", "green", "purple", "black", "navyblue"))
		if ("blue")
			starts_with += /obj/item/clothing/under/rank/medical/scrubs
			starts_with += /obj/item/clothing/head/surgery/blue
		if ("green")
			starts_with += /obj/item/clothing/under/rank/medical/scrubs/green
			starts_with += /obj/item/clothing/head/surgery/green
		if ("purple")
			starts_with += /obj/item/clothing/under/rank/medical/scrubs/purple
			starts_with += /obj/item/clothing/head/surgery/purple
		if ("black")
			starts_with += /obj/item/clothing/under/rank/medical/scrubs/black
			starts_with += /obj/item/clothing/head/surgery/black
		if ("navyblue")
			starts_with += /obj/item/clothing/under/rank/medical/scrubs/navyblue
			starts_with += /obj/item/clothing/head/surgery/navyblue
	return ..()


/obj/structure/closet/secure_closet/animal
	name = "animal control closet"
	req_access = list(access_surgery)

	starts_with = list(
		/obj/item/device/assembly/signaler,
		/obj/item/device/radio/electropack = 3)


/obj/structure/closet/secure_closet/chemical
	name = "chemical closet"
	desc = "Store dangerous chemicals in here."
	icon_state = "medical1"
	icon_closed = "medical"
	icon_locked = "medical1"
	icon_opened = "medicalopen"
	icon_broken = "medicalbroken"
	icon_off = "medicaloff"
	req_access = list(access_chemistry)

	starts_with = list(
		/obj/item/weapon/storage/box/pillbottles = 2,
		/obj/item/weapon/storage/box/beakers,
		/obj/item/weapon/storage/box/autoinjectors,
		/obj/item/weapon/storage/box/syringes,
		/obj/item/weapon/reagent_containers/dropper = 2,
		/obj/item/weapon/reagent_containers/glass/bottle/inaprovaline = 2,
		/obj/item/weapon/reagent_containers/glass/bottle/antitoxin = 2,
		/obj/item/weapon/storage/fancy/vials) //VOREStation Add


/obj/structure/closet/secure_closet/psych
	name = "psychiatric closet"
	desc = "Store psychology tools and medicines in here."
	icon_state = "medical1"
	icon_closed = "medical"
	icon_locked = "medical1"
	icon_opened = "medicalopen"
	icon_broken = "medicalbroken"
	icon_off = "medicaloff"
	req_access = list(access_psychiatrist)

	starts_with = list(
		/obj/item/clothing/under/rank/psych,
		/obj/item/clothing/under/rank/psych/turtleneck,
		/obj/item/clothing/suit/straight_jacket,
		/obj/item/weapon/reagent_containers/glass/bottle/stoxin,
		/obj/item/weapon/reagent_containers/syringe,
		/obj/item/weapon/storage/pill_bottle/citalopram,
		/obj/item/weapon/reagent_containers/pill/methylphenidate,
		/obj/item/weapon/clipboard,
		/obj/item/weapon/folder/white,
		/obj/item/device/taperecorder,
		/obj/item/device/tape/random = 3,
		/obj/item/device/camera,
		/obj/item/toy/plushie/therapy/blue)


/obj/structure/closet/secure_closet/medical_wall
	name = "first aid closet"
	desc = "It's a secure wall-mounted storage unit for first aid supplies."
	icon_state = "medical_wall_locked"
	icon_closed = "medical_wall_unlocked"
	icon_locked = "medical_wall_locked"
	icon_opened = "medical_wall_open"
	icon_broken = "medical_wall_spark"
	icon_off = "medical_wall_off"
	plane = TURF_PLANE
	layer = ABOVE_TURF_LAYER
	anchored = 1
	density = 0
	wall_mounted = 1
	req_access = list(access_medical_equip)

/obj/structure/closet/secure_closet/medical_wall/update_icon()
	if(broken)
		icon_state = icon_broken
	else
		if(!opened)
			if(locked)
				icon_state = icon_locked
			else
				icon_state = icon_closed
		else
			icon_state = icon_opened

/obj/structure/closet/secure_closet/medical_wall/pills
	name = "pill cabinet"

	starts_with = list(
		/obj/item/weapon/storage/pill_bottle/tramadol,
		/obj/item/weapon/storage/pill_bottle/antitox,
		/obj/item/weapon/storage/pill_bottle/carbon,
		/obj/random/medical/pillbottle)


/obj/structure/closet/secure_closet/medical_wall/anesthetics
	name = "anesthetics wall closet"
	desc = "Used to knock people out."
	req_access = list(access_surgery)

	starts_with = list(
		/obj/item/weapon/tank/anesthetic = 3,
		/obj/item/clothing/mask/breath/medical = 3)
