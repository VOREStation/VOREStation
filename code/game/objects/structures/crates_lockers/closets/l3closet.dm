/obj/structure/closet/l3closet
	name = "level-3 biohazard suit closet"
	desc = "It's a storage unit for level-3 biohazard gear."
	closet_appearance = /decl/closet_appearance/bio

/obj/structure/closet/l3closet/general
	closet_appearance = /decl/closet_appearance/bio

	starts_with = list(
		/obj/item/clothing/suit/bio_suit/general,
		/obj/item/clothing/head/bio_hood/general)


/obj/structure/closet/l3closet/virology
	closet_appearance = /decl/closet_appearance/bio/virology

	starts_with = list(
		/obj/item/clothing/suit/bio_suit/virology,
		/obj/item/clothing/head/bio_hood/virology,
		/obj/item/clothing/mask/gas,
		/obj/item/weapon/tank/oxygen)


/obj/structure/closet/l3closet/security
	closet_appearance = /decl/closet_appearance/bio/security

	starts_with = list(
		/obj/item/clothing/suit/bio_suit/security,
		/obj/item/clothing/head/bio_hood/security)
		///obj/item/weapon/gun/energy/taser/xeno/sec) //VOREStation Removal

/obj/structure/closet/l3closet/janitor
	closet_appearance = /decl/closet_appearance/bio/janitor

	starts_with = list(
		/obj/item/clothing/suit/bio_suit/janitor = 2,
		/obj/item/clothing/head/bio_hood/janitor = 2,
		/obj/item/clothing/mask/gas = 2,
		/obj/item/weapon/tank/emergency/oxygen/engi = 2)


/obj/structure/closet/l3closet/scientist
	closet_appearance = /decl/closet_appearance/bio/science

	starts_with = list(
		/obj/item/clothing/suit/bio_suit/scientist,
		/obj/item/clothing/head/bio_hood/scientist)

/obj/structure/closet/l3closet/scientist/double
	starts_with = list(
		/obj/item/clothing/suit/bio_suit/scientist = 2,
		/obj/item/clothing/head/bio_hood/scientist = 2)


/obj/structure/closet/l3closet/medical
	closet_appearance = /decl/closet_appearance/bio/medical

	starts_with = list(
		/obj/item/clothing/suit/bio_suit/general = 3,
		/obj/item/clothing/head/bio_hood/general = 3,
		/obj/item/clothing/mask/gas = 3)
