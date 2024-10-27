/obj/item/storage/box/explorerkeys
	name = "box of volunteer headsets"
	desc = "A box full of volunteer headsets, for issuing out to exploration volunteers."
	starts_with = list(/obj/item/radio/headset/explorer = 7)

/obj/item/storage/box/commandkeys
	name = "box of command keys"
	desc = "A box full of command keys, for command to give out as necessary."
	starts_with = list(/obj/item/encryptionkey/headset_com = 7)

/obj/item/storage/box/servicekeys
	name = "box of service keys"
	desc = "A box full of service keys, for the HoP to give out as necessary."
	starts_with = list(/obj/item/encryptionkey/headset_service = 7)

/obj/item/storage/box/survival/space
	name = "boxed emergency suit and helmet"
	icon_state = "survival_comp3"
	starts_with = list(
		/obj/item/clothing/suit/space/emergency,
		/obj/item/clothing/head/helmet/space/emergency,
		/obj/item/clothing/mask/breath,
		/obj/item/tank/emergency/oxygen/double
	)

/obj/item/storage/secure/briefcase/trashmoney
	starts_with = list(/obj/item/spacecash/c200 = 10)

/obj/item/storage/box/brainzsnax
	name = "\improper BrainzSnax box"
	icon_state = "brainzsnax_box"
	desc = "A box designed to hold canned food. This one has BrainzSnax branding printed on it."
	can_hold = list(/obj/item/reagent_containers/food/snacks/canned)
	max_storage_space = ITEMSIZE_COST_NORMAL * 6
	starts_with = list(/obj/item/reagent_containers/food/snacks/canned/brainzsnax = 6)

/obj/item/storage/box/brainzsnax/red
	starts_with = list(/obj/item/reagent_containers/food/snacks/canned/brainzsnax/red = 6)

/obj/item/storage/box/freezer
	can_hold = list(/obj/item/organ, /obj/item/reagent_containers/blood, /obj/item/reagent_containers/glass, /obj/item/reagent_containers/food)

/obj/item/storage/box/altevian_ammo
	name = "SAM .48 ammo box"
	desc = "A box of ratty ammo."
	icon_state = "secbox"
	starts_with = list(/obj/item/ammo_magazine/sam48 = 3)
	max_storage_space = ITEMSIZE_COST_NORMAL * 3
	drop_sound = 'sound/items/drop/ammobox.ogg'
	pickup_sound = 'sound/items/pickup/ammobox.ogg'

/obj/item/storage/box/weapon_cells
	name = "box of weapon cells"
	desc = "A box full of weapon power cells. For all your portable energy storage needs."
	icon_state = "secbox"
	starts_with = list(/obj/item/cell/device/weapon = 7)
