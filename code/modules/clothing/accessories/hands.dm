/obj/item/clothing/accessory/knuckledusters
	name = "knuckle dusters"
	desc = "A pair of brass knuckles. Generally used to enhance the user's punches."
	icon_state = "knuckledusters"
	slot = ACCESSORY_SLOT_RING
	slot_flags = SLOT_GLOVES
	matter = list(MAT_STEEL = 500)
	attack_verb = list("punched", "beaten", "struck")
	siemens_coefficient = 1
	force = 10	//base punch strength is 5
	punch_force = 5	//added to base punch strength when added as a glove accessory
	icon = 'icons/inventory/hands/item.dmi'
	item_icons = list(
		slot_l_hand_str = 'icons/mob/items/lefthand_gloves.dmi',
		slot_r_hand_str = 'icons/mob/items/righthand_gloves.dmi',
		)
	drop_sound = 'sound/items/drop/metalboots.ogg'
	pickup_sound = 'sound/items/pickup/toolbox.ogg'

//bracelets

/obj/item/clothing/accessory/bracelet
	name = "bracelet"
	desc = "A simple silver bracelet with a clasp."
	icon = 'icons/inventory/accessory/item.dmi'
	icon_state = "bracelet"
	w_class = ITEMSIZE_TINY
	slot_flags = SLOT_GLOVES | SLOT_TIE
	slot = ACCESSORY_SLOT_WRIST

/obj/item/clothing/accessory/bracelet/friendship
	name = "friendship bracelet"
	desc = "A beautiful friendship bracelet in all the colors of the rainbow."
	icon_state = "friendbracelet"

/obj/item/clothing/accessory/bracelet/friendship/verb/dedicate_bracelet()
	set name = "Dedicate Bracelet"
	set category = "Object"
	set desc = "Dedicate your friendship bracelet to a special someone."
	var/mob/M = usr
	if(!M.mind)
		return 0

	var/input = sanitizeSafe(input(usr, "Who do you want to dedicate the bracelet to?", ,""), MAX_NAME_LEN)

	if(src && input && !M.stat && in_range(M,src))
		desc = "A beautiful friendship bracelet in all the colors of the rainbow. It's dedicated to [input]."
		to_chat(M, "You dedicate the bracelet to [input], remembering the times you've had together.")
		return 1


/obj/item/clothing/accessory/bracelet/material
	icon_state = "materialbracelet"

/obj/item/clothing/accessory/bracelet/material/New(var/newloc, var/new_material)
	..(newloc)
	if(!new_material)
		new_material = MAT_STEEL
	material = get_material_by_name(new_material)
	if(!istype(material))
		qdel(src)
		return
	name = "[material.display_name] bracelet"
	desc = "A bracelet made from [material.display_name]."
	color = material.icon_colour

/obj/item/clothing/accessory/bracelet/material/get_material()
	return material

/obj/item/clothing/accessory/bracelet/material/wood/New(var/newloc)
	..(newloc, MAT_WOOD)

/obj/item/clothing/accessory/bracelet/material/plastic/New(var/newloc)
	..(newloc, MAT_PLASTIC)

/obj/item/clothing/accessory/bracelet/material/iron/New(var/newloc)
	..(newloc, MAT_IRON)

/obj/item/clothing/accessory/bracelet/material/steel/New(var/newloc)
	..(newloc, MAT_STEEL)

/obj/item/clothing/accessory/bracelet/material/silver/New(var/newloc)
	..(newloc, MAT_SILVER)

/obj/item/clothing/accessory/bracelet/material/gold/New(var/newloc)
	..(newloc, MAT_GOLD)

/obj/item/clothing/accessory/bracelet/material/platinum/New(var/newloc)
	..(newloc, MAT_PLATINUM)

/obj/item/clothing/accessory/bracelet/material/phoron/New(var/newloc)
	..(newloc, MAT_PHORON)

/obj/item/clothing/accessory/bracelet/material/glass/New(var/newloc)
	..(newloc, MAT_GLASS)

//wristbands

/obj/item/clothing/accessory/wristband
	name = "wristband"
	desc = "A simple plastic wristband."
	icon = 'icons/inventory/accessory/item.dmi'
	icon_state = "wristband"
	w_class = ITEMSIZE_TINY
	slot_flags = SLOT_GLOVES  | SLOT_TIE
	slot = ACCESSORY_SLOT_WRIST

/obj/item/clothing/accessory/wristband/spiked
	name = "wristband (spiked)"
	desc = "A black wristband with short spikes around it."
	icon_state = "wristband_spiked"

/obj/item/clothing/accessory/wristband/collection
	name = "wristband collection"
	desc = "A mix of colourable plastic wristbands."
	icon_state = "wristband_collection"

/obj/item/clothing/accessory/wristband/collection/pink
	name = "wristband collection"
	desc = "A mix of colourable plastic wristbands."
	icon_state = "wristband_collection2"

/obj/item/clothing/accessory/wristband/collection/les
	name = "wristband collection"
	desc = "A mix of colourable plastic wristbands."
	icon_state = "wristband_collection3"

/obj/item/clothing/accessory/wristband/collection/trans
	name = "wristband collection"
	desc = "A mix of colourable plastic wristbands."
	icon_state = "wristband_collection4"

/obj/item/clothing/accessory/wristband/collection/bi
	name = "wristband collection"
	desc = "A mix of colourable plastic wristbands."
	icon_state = "wristband_collection5"

/obj/item/clothing/accessory/wristband/collection/ace
	name = "wristband collection"
	desc = "A mix of colourable plastic wristbands."
	icon_state = "wristband_collection6"
