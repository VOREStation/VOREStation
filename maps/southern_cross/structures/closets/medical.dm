/*
 * SC Medical
 */


/obj/structure/closet/secure_closet/CMO_wardrobe
	name = "chief medical officer's locker"
	req_access = list(access_cmo)
	icon_state = "cmosecure1"
	icon_closed = "cmosecure"
	icon_locked = "cmosecure1"
	icon_opened = "cmosecureopen"
	icon_broken = "cmosecurebroken"
	icon_off = "cmosecureoff"

/obj/structure/closet/secure_closet/CMO_wardrobe/New()
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
			new /obj/item/clothing/under/rank/medical/scrubs(src)
			new /obj/item/clothing/head/surgery/blue(src)
		if ("green")
			new /obj/item/clothing/under/rank/medical/scrubs/green(src)
			new /obj/item/clothing/head/surgery/green(src)
		if ("purple")
			new /obj/item/clothing/under/rank/medical/scrubs/purple(src)
			new /obj/item/clothing/head/surgery/purple(src)
		if ("black")
			new /obj/item/clothing/under/rank/medical/scrubs/black(src)
			new /obj/item/clothing/head/surgery/black(src)
		if ("navyblue")
			new /obj/item/clothing/under/rank/medical/scrubs/navyblue(src)
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