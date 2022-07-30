/datum/supply_pack/med/medical
	cost = 15

/datum/supply_pack/med/medicalbiosuits
	contains = list(
			/obj/item/clothing/head/bio_hood/scientist = 3,
			/obj/item/clothing/suit/bio_suit/scientist = 3,
			/obj/item/clothing/suit/bio_suit/virology = 3,
			/obj/item/clothing/head/bio_hood/virology = 3,
			/obj/item/clothing/suit/bio_suit/cmo,
			/obj/item/clothing/head/bio_hood/cmo,
			/obj/item/clothing/shoes/white = 7,
			/obj/item/clothing/mask/gas = 7,
			/obj/item/tank/oxygen = 7,
			/obj/item/storage/box/masks,
			/obj/item/storage/box/gloves
			)
	cost = 40

/datum/supply_pack/med/virologybiosuits
	name = "Virology biohazard gear"
	contains = list(
			/obj/item/clothing/suit/bio_suit/virology = 3,
			/obj/item/clothing/head/bio_hood/virology = 3,
			/obj/item/clothing/mask/gas = 3,
			/obj/item/tank/oxygen = 3,
			/obj/item/storage/box/masks,
			/obj/item/storage/box/gloves
			)
	cost = 40
	containertype = /obj/structure/closet/crate/secure
	containername = "Virology biohazard equipment"
	access = access_medical_equip

/datum/supply_pack/med/virus
	name = "Virus sample crate"
	contains = list(/obj/item/virusdish/random = 4)
	cost = 25
	containertype = /obj/structure/closet/crate/secure
	containername = "Virus sample crate"
	access = access_medical_equip


/datum/supply_pack/med/bloodpack
	containertype = /obj/structure/closet/crate/medical/blood

/datum/supply_pack/med/compactdefib
	name = "Compact Defibrillator crate"
	contains = list(/obj/item/defib_kit/compact = 1)
	cost = 90
	containertype = /obj/structure/closet/crate/secure
	containername = "Compact Defibrillator crate"
	access = access_medical_equip
