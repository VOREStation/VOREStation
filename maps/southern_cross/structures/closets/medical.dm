/*
 * SC Medical
 */


/obj/structure/closet/secure_closet/CMO_wardrobe
	name = "chief medical officer's locker"
	req_access = list(access_cmo)
	closet_appearance = /decl/closet_appearance/secure_closet/cmo

	starts_with = list(
		/obj/item/clothing/under/rank/chief_medical_officer,
		/obj/item/clothing/under/rank/chief_medical_officer/skirt,
		/obj/item/clothing/suit/storage/toggle/labcoat/cmo,
		/obj/item/clothing/suit/storage/toggle/labcoat/cmoalt,
<<<<<<< HEAD
		/obj/item/clothing/suit/storage/toggle/labcoat/modern/cmo,
		/obj/item/weapon/cartridge/cmo,
=======
		/obj/item/cartridge/cmo,
>>>>>>> 61084723c7b... Merge pull request #8317 from Atermonera/remove_weapon
		/obj/item/clothing/gloves/sterile/latex,
		/obj/item/clothing/shoes/brown,
		/obj/item/radio/headset/heads/cmo,
		/obj/item/clothing/suit/storage/hooded/wintercoat/medical,
		/obj/item/clothing/shoes/white)

/obj/structure/closet/secure_closet/CMO_wardrobe/Initialize()
	if(prob(50))
		starts_with += /obj/item/storage/backpack/medic
	else
		starts_with += /obj/item/storage/backpack/satchel/med
	if(prob(50))
		starts_with += /obj/item/storage/backpack/dufflebag/med
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
