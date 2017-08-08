/*
 * SC Medical
 */

/obj/structure/closet/secure_closet/CMO/lite
	name = "chief medical officer's locker"
	req_access = list(access_cmo)
	icon_state = "cmosecure1"
	icon_closed = "cmosecure"
	icon_locked = "cmosecure1"
	icon_opened = "cmosecureopen"
	icon_broken = "cmosecurebroken"
	icon_off = "cmosecureoff"

	New()
		..()
		if(prob(50))
			new /obj/item/weapon/storage/backpack/medic(src)
		else
			new /obj/item/weapon/storage/backpack/satchel/med(src)
		if(prob(50))
			new /obj/item/weapon/storage/backpack/dufflebag/med(src)
		new /obj/item/clothing/suit/bio_suit/cmo(src)
		new /obj/item/clothing/head/bio_hood/cmo(src)
		new /obj/item/clothing/gloves/sterile/latex(src)
		new /obj/item/device/radio/headset/heads/cmo/alt(src)
		new /obj/item/device/flash(src)
		new /obj/item/weapon/reagent_containers/hypospray(src)
		new /obj/item/weapon/storage/box/freezer(src)
		new /obj/item/clothing/mask/gas(src)
		return



/obj/structure/closet/secure_closet/CMO/wardrobe
	name = "chief medical officer's locker"
	req_access = list(access_cmo)
	icon_state = "cmosecure1"
	icon_closed = "cmosecure"
	icon_locked = "cmosecure1"
	icon_opened = "cmosecureopen"
	icon_broken = "cmosecurebroken"
	icon_off = "cmosecureoff"

	New()
		..()
		if(prob(50))
			new /obj/item/weapon/storage/backpack/medic(src)
		else
			new /obj/item/weapon/storage/backpack/satchel/med(src)
		if(prob(50))
			new /obj/item/weapon/storage/backpack/dufflebag/med(src)
		new /obj/item/clothing/shoes/white(src)
		switch(pick("blue", "green", "purple", "black", "navyblue"))
			if ("blue")
				new /obj/item/clothing/under/rank/medical/blue(src)
				new /obj/item/clothing/head/surgery/blue(src)
			if ("green")
				new /obj/item/clothing/under/rank/medical/green(src)
				new /obj/item/clothing/head/surgery/green(src)
			if ("purple")
				new /obj/item/clothing/under/rank/medical/purple(src)
				new /obj/item/clothing/head/surgery/purple(src)
			if ("black")
				new /obj/item/clothing/under/rank/medical/black(src)
				new /obj/item/clothing/head/surgery/black(src)
			if ("navyblue")
				new /obj/item/clothing/under/rank/medical/navyblue(src)
				new /obj/item/clothing/head/surgery/navyblue(src)
		new /obj/item/clothing/under/rank/chief_medical_officer(src)
		new /obj/item/clothing/under/rank/chief_medical_officer/skirt(src)
		new /obj/item/clothing/suit/storage/toggle/labcoat/cmo(src)
		new /obj/item/clothing/suit/storage/toggle/labcoat/cmoalt(src)
		new /obj/item/weapon/cartridge/cmo(src)
		new /obj/item/clothing/gloves/sterile/latex(src)
		new /obj/item/clothing/shoes/brown	(src)
		new /obj/item/device/radio/headset/heads/cmo(src)
		new /obj/item/clothing/suit/storage/hooded/wintercoat/medical(src)
		return