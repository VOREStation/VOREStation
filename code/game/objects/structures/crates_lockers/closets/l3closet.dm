/obj/structure/closet/l3closet
	name = "level-3 biohazard suit closet"
	desc = "It's a storage unit for level-3 biohazard gear."
	icon_state = "bio"
	icon_closed = "bio"
	icon_opened = "bioopen"

/obj/structure/closet/l3closet/general
	icon_state = "bio_general"
	icon_closed = "bio_general"
	icon_opened = "bio_generalopen"

	starts_with = list(
		/obj/item/clothing/suit/bio_suit/general,
		/obj/item/clothing/head/bio_hood/general)


/obj/structure/closet/l3closet/virology
	icon_state = "bio_virology"
	icon_closed = "bio_virology"
	icon_opened = "bio_virologyopen"

	starts_with = list(
		/obj/item/clothing/suit/bio_suit/virology,
		/obj/item/clothing/head/bio_hood/virology,
		/obj/item/clothing/mask/gas,
		/obj/item/weapon/tank/oxygen)


/obj/structure/closet/l3closet/security
	icon_state = "bio_security"
	icon_closed = "bio_security"
	icon_opened = "bio_securityopen"

	starts_with = list(
		/obj/item/clothing/suit/bio_suit/security,
		/obj/item/clothing/head/bio_hood/security)
		///obj/item/weapon/gun/energy/taser/xeno/sec) //VOREStation Removal

/obj/structure/closet/l3closet/janitor
	icon_state = "bio_janitor"
	icon_closed = "bio_janitor"
	icon_opened = "bio_janitoropen"

	starts_with = list(
		/obj/item/clothing/suit/bio_suit/janitor = 2,
		/obj/item/clothing/head/bio_hood/janitor = 2,
		/obj/item/clothing/mask/gas = 2,
		/obj/item/weapon/tank/emergency/oxygen/engi = 2)


/obj/structure/closet/l3closet/scientist
	icon_state = "bio_scientist"
	icon_closed = "bio_scientist"
	icon_opened = "bio_scientistopen"

	starts_with = list(
		/obj/item/clothing/suit/bio_suit/scientist,
		/obj/item/clothing/head/bio_hood/scientist)

/obj/structure/closet/l3closet/scientist/double
	starts_with = list(
		/obj/item/clothing/suit/bio_suit/scientist = 2,
		/obj/item/clothing/head/bio_hood/scientist = 2)


/obj/structure/closet/l3closet/medical
	icon_state = "bio_scientist"
	icon_closed = "bio_scientist"
	icon_opened = "bio_scientistopen"

	starts_with = list(
		/obj/item/clothing/suit/bio_suit/general = 3,
		/obj/item/clothing/head/bio_hood/general = 3,
		/obj/item/clothing/mask/gas = 3)
