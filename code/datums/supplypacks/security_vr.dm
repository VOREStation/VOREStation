/datum/supply_packs/security/guardbeast
	name = "VARMAcorp autoNOMous security solution"
	cost = 150
	containertype = /obj/structure/largecrate/animal/guardbeast
	containername = "VARMAcorp autoNOMous security solution crate"
	access = list(
			access_security,
			access_xenobiology)

/datum/supply_packs/security/guardmutant
	name = "VARMAcorp autoNOMous security solution for hostile environments"
	cost = 250
	containertype = /obj/structure/largecrate/animal/guardmutant
	containername = "VARMAcorp autoNOMous security phoron-proof solution crate"
	access = list(
			access_security,
			access_xenobiology)

/datum/supply_packs/security/biosuit
	contains = list(
			/obj/item/clothing/head/bio_hood/security = 3,
			/obj/item/clothing/under/rank/security = 3,
			/obj/item/clothing/suit/bio_suit/security = 2,
			/obj/item/clothing/suit/bio_suit/security/taur = 1,
			/obj/item/clothing/shoes/white = 3,
			/obj/item/clothing/mask/gas = 3,
			/obj/item/weapon/tank/oxygen = 3,
			/obj/item/clothing/gloves/sterile/latex,
			/obj/item/weapon/storage/box/gloves
			)
	cost = 40
