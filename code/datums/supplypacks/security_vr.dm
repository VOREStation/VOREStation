/*/datum/supply_pack/security/guardbeast //VORESTATION AI TEMPORARY REMOVAL
	name = "VARMAcorp autoNOMous security solution"
	cost = 150
	containertype = /obj/structure/largecrate/animal/guardbeast
	containername = "VARMAcorp autoNOMous security solution crate"
	access = list(
			access_security,
			access_xenobiology)
	one_access = TRUE

/datum/supply_pack/security/guardmutant
	name = "VARMAcorp autoNOMous security solution for hostile environments"
	cost = 250
	containertype = /obj/structure/largecrate/animal/guardmutant
	containername = "VARMAcorp autoNOMous security phoron-proof solution crate"
	access = list(
			access_security,
			access_xenobiology)
	one_access = TRUE
*/

/datum/supply_pack/randomised/security/armor
	access = access_armory

/datum/supply_pack/security/biosuit
	contains = list(
			/obj/item/clothing/head/bio_hood/security = 3,
			/obj/item/clothing/under/rank/security = 3,
			/obj/item/clothing/suit/bio_suit/security = 3,
			/obj/item/clothing/shoes/white = 3,
			/obj/item/clothing/mask/gas = 3,
			/obj/item/tank/oxygen = 3,
			/obj/item/clothing/gloves/sterile/latex,
			/obj/item/storage/box/gloves
			)
	cost = 40

/datum/supply_pack/security/trackingimplant
	name = "Implants - Tracking"
	contains = list(
			/obj/item/storage/box/trackimp = 1
			)
	cost = 25
	containertype = /obj/structure/closet/crate/secure
	containername = "Tracking implants"
	access = access_security

/datum/supply_pack/security/chemicalimplant
	name = "Implants - Chemical"
	contains = list(
			/obj/item/storage/box/chemimp = 1
			)
	cost = 25
	containertype = /obj/structure/closet/crate/secure
	containername = "Chemical implants"
	access = access_security
