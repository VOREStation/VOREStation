/* Utility Closets
 * Contains:
 *		Emergency Closet
 *		Fire Closet
 *		Tool Closet
 *		Radiation Closet
 *		Bombsuit Closet
 *		Hydrant
 *		First Aid
 */

/*
 * Emergency Closet
 */
/obj/structure/closet/emcloset
	name = "emergency closet"
	desc = "It's a storage unit for emergency breathmasks and O2 tanks."
	icon_state = "emergency"
	icon_closed = "emergency"
	icon_opened = "emergencyopen"

/obj/structure/closet/emcloset/Initialize()
	switch (pickweight(list("small" = 55, "aid" = 25, "tank" = 10, "both" = 10)))
		if ("small")
			starts_with = list(
				/obj/item/weapon/tank/emergency/oxygen = 2,
				/obj/item/clothing/mask/breath = 2,
				/obj/item/clothing/suit/space/emergency,
				/obj/item/clothing/head/helmet/space/emergency)
		if ("aid")
			starts_with = list(
				/obj/item/weapon/tank/emergency/oxygen,
				/obj/item/weapon/storage/toolbox/emergency,
				/obj/item/clothing/mask/breath,
				/obj/item/weapon/storage/firstaid/o2,
				/obj/item/clothing/suit/space/emergency,
				/obj/item/clothing/head/helmet/space/emergency)
		if ("tank")
			starts_with = list(
				/obj/item/weapon/tank/emergency/oxygen/engi = 2,
				/obj/item/clothing/mask/breath = 2)
		if ("both")
			starts_with = list(
				/obj/item/weapon/storage/toolbox/emergency,
				/obj/item/weapon/tank/emergency/oxygen/engi,
				/obj/item/clothing/mask/breath,
				/obj/item/weapon/storage/firstaid/o2,
				/obj/item/clothing/suit/space/emergency = 2,
				/obj/item/clothing/head/helmet/space/emergency = 2)

	return ..()

/obj/structure/closet/emcloset/legacy
	starts_with = list(
		/obj/item/weapon/tank/oxygen,
		/obj/item/clothing/mask/gas)

/*
 * Fire Closet
 */
/obj/structure/closet/firecloset
	name = "fire-safety closet"
	desc = "It's a storage unit for fire-fighting supplies."
	icon_state = "firecloset"
	icon_closed = "firecloset"
	icon_opened = "fireclosetopen"

	starts_with = list(
		/obj/item/clothing/suit/fire/firefighter,
		/obj/item/clothing/mask/gas,
		/obj/item/weapon/tank/oxygen/red,
		/obj/item/weapon/extinguisher,
		/obj/item/clothing/head/hardhat/red)

/obj/structure/closet/firecloset/full
	starts_with = list(
		/obj/item/clothing/suit/fire/firefighter,
		/obj/item/clothing/mask/gas,
		/obj/item/device/flashlight,
		/obj/item/weapon/tank/oxygen/red,
		/obj/item/weapon/extinguisher,
		/obj/item/clothing/head/hardhat/red)

/obj/structure/closet/firecloset/full/double
	starts_with = list(
		/obj/item/clothing/suit/fire/firefighter = 2,
		/obj/item/clothing/mask/gas = 2,
		/obj/item/device/flashlight = 2,
		/obj/item/weapon/tank/oxygen/red = 2,
		/obj/item/weapon/extinguisher = 2,
		/obj/item/clothing/head/hardhat/red = 2)

/obj/structure/closet/firecloset/update_icon()
	if(!opened)
		icon_state = icon_closed
	else
		icon_state = icon_opened

/*
 * Tool Closet
 */
/obj/structure/closet/toolcloset
	name = "tool closet"
	desc = "It's a storage unit for tools."
	icon_state = "toolcloset"
	icon_closed = "toolcloset"
	icon_opened = "toolclosetopen"

/obj/structure/closet/toolcloset/Initialize()
	starts_with = list()
	if(prob(40))
		starts_with += /obj/item/clothing/suit/storage/hazardvest
	if(prob(70))
		starts_with += /obj/item/device/flashlight
	if(prob(70))
		starts_with += /obj/item/weapon/tool/screwdriver
	if(prob(70))
		starts_with += /obj/item/weapon/tool/wrench
	if(prob(70))
		starts_with += /obj/item/weapon/weldingtool
	if(prob(70))
		starts_with += /obj/item/weapon/tool/crowbar
	if(prob(70))
		starts_with += /obj/item/weapon/tool/wirecutters
	if(prob(70))
		starts_with += /obj/item/device/t_scanner
	if(prob(20))
		starts_with += /obj/item/weapon/storage/belt/utility
	if(prob(30))
		starts_with += /obj/item/stack/cable_coil/random
	if(prob(30))
		starts_with += /obj/item/stack/cable_coil/random
	if(prob(30))
		starts_with += /obj/item/stack/cable_coil/random
	if(prob(20))
		starts_with += /obj/item/device/multitool
	if(prob(5))
		starts_with += /obj/item/clothing/gloves/yellow
	if(prob(40))
		starts_with += /obj/item/clothing/head/hardhat
	if(prob(30))
		starts_with += /obj/item/weapon/reagent_containers/spray/windowsealant //VOREStation Add
	return ..()

/*
 * Radiation Closet
 */
/obj/structure/closet/radiation
	name = "radiation suit closet"
	desc = "It's a storage unit for rad-protective suits."
	icon_state = "radsuitcloset"
	icon_opened = "toolclosetopen"
	icon_closed = "radsuitcloset"

	starts_with = list(
		/obj/item/clothing/suit/radiation = 2,
		/obj/item/clothing/head/radiation = 2,
		/obj/item/device/geiger = 2)

/*
 * Bombsuit closet
 */
/obj/structure/closet/bombcloset
	name = "\improper EOD closet"
	desc = "It's a storage unit for explosion-protective suits."
	icon_state = "bombsuit"
	icon_closed = "bombsuit"
	icon_opened = "bombsuitopen"

	starts_with = list(
		/obj/item/clothing/suit/bomb_suit,
		/obj/item/clothing/under/color/black,
		/obj/item/clothing/shoes/black,
		/obj/item/clothing/head/bomb_hood)

/obj/structure/closet/bombcloset/double
	starts_with = list(
		/obj/item/clothing/suit/bomb_suit = 2,
		/obj/item/clothing/under/color/black = 2,
		/obj/item/clothing/shoes/black = 2,
		/obj/item/clothing/head/bomb_hood = 2)

/obj/structure/closet/bombclosetsecurity
	name = "\improper EOD closet"
	desc = "It's a storage unit for explosion-protective suits."
	icon_state = "bombsuitsec"
	icon_closed = "bombsuitsec"
	icon_opened = "bombsuitsecopen"

	starts_with = list(
		/obj/item/clothing/suit/bomb_suit/security,
		/obj/item/clothing/under/rank/security,
		/obj/item/clothing/shoes/brown,
		/obj/item/clothing/head/bomb_hood/security)

/*
 * Hydrant
 */
/obj/structure/closet/hydrant //wall mounted fire closet
	name = "fire-safety closet"
	desc = "It's a storage unit for fire-fighting supplies."
	icon_state = "hydrant"
	icon_closed = "hydrant"
	icon_opened = "hydrant_open"
	plane = TURF_PLANE
	layer = ABOVE_TURF_LAYER
	anchored = 1
	density = 0
	wall_mounted = 1

	starts_with = list(
		/obj/item/clothing/suit/fire/firefighter,
		/obj/item/clothing/mask/gas,
		/obj/item/device/flashlight,
		/obj/item/weapon/tank/oxygen/red,
		/obj/item/weapon/extinguisher,
		/obj/item/clothing/head/hardhat/red)

/*
 * First Aid
 */
/obj/structure/closet/medical_wall //wall mounted medical closet
	name = "first-aid closet"
	desc = "It's wall-mounted storage unit for first aid supplies."
	icon_state = "medical_wall"
	icon_closed = "medical_wall"
	icon_opened = "medical_wall_open"
	anchored = 1
	density = 0
	wall_mounted = 1

/obj/structure/closet/medical_wall/update_icon()
	if(!opened)
		icon_state = icon_closed
	else
		icon_state = icon_opened
