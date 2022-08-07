/obj/item/clothing/under/vox
	has_sensor = 0
	species_restricted = list(SPECIES_VOX)
	starting_accessories = list(/obj/item/clothing/accessory/storage/vox)	// Dont' start with a backback, so free webbing
	flags = PHORONGUARD

/obj/item/clothing/under/vox/vox_utility
	name = "alien clothing"
	desc = "A set of oddly textured straps and wraps making up some kind of alien clothing. It's not cloth, and it's not leather."
	icon_state = "vox-casual-1"
	item_state = "vox-casual-1"
	body_parts_covered = LEGS

/obj/item/clothing/under/vox/vox_robes
	name = "alien robes"
	desc = "A complex wrap of some kind of shed reptile skin or synthetic textile."
	icon_state = "vox-casual-2"
	item_state = "vox-casual-2"

//Vox Accessories
/obj/item/clothing/accessory/storage/vox
	name = "alien mesh"
	desc = "An alien mesh. Seems to be made up mostly of pockets and writhing flesh."
	icon_state = "webbing-vox"

	flags = PHORONGUARD

	slots = 3

/obj/item/clothing/accessory/storage/vox/Initialize()
	. = ..()
	hold.max_storage_space = slots * ITEMSIZE_COST_NORMAL
	hold.max_w_class = ITEMSIZE_NORMAL
