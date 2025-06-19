/datum/inventory_slot
	var/name = ""

	var/slot_id
	var/slot_id_str

	var/hud_location
	var/hud_object_type
	var/hud_icon_state
	var/hideable = FALSE

	var/datum/inventory/owner

/datum/inventory_slot/New(new_owner)
	. = ..()
	owner = new_owner

/datum/inventory_slot/proc/build_hud(datum/hud/HUD)
	var/obj/screen/inventory/I = new hud_object_type()
	I.name = name
	I.slot_id = slot_id
	I.screen_loc = hud_location

	I.icon = HUD.ui_style
	I.color = HUD.ui_color
	I.alpha = HUD.ui_alpha
	I.icon_state = hud_icon_state

	LAZYSET(HUD.slot_info, "[slot_id]", hud_location)

	return I

/datum/inventory_slot/proc/update_icon(atom/movable/contents)
	return

/datum/inventory_slot/proc/equipped(atom/movable/contents)
	return

/datum/inventory_slot/proc/unequipped(atom/movable/contents)
	return

// TYPES
/datum/inventory_slot/l_hand
	name = "Left Hand"

	slot_id = slot_l_hand
	slot_id_str = slot_l_hand_str

	hud_location = ui_lhand
	hud_object_type = /obj/screen/inventory/hand
	hud_icon_state = "l_hand_inactive"

/datum/inventory_slot/l_hand/build_hud(datum/hud/HUD)
	var/obj/screen/inventory/I = ..()
	HUD.l_hand_hud_object = I

	if(isliving(owner.mymob))
		var/mob/living/L = owner.mymob
		if(L.hand)
			I.icon_state = "l_hand_active"

	return I

/datum/inventory_slot/l_hand/update_icon(atom/movable/contents)
	owner.mymob.update_inv_l_hand()

/datum/inventory_slot/l_hand/unequipped(atom/movable/contents)
	. = ..()
	var/obj/item/r_hand = owner.get_item_in_slot(slot_r_hand_str)
	if(istype(r_hand))
		r_hand.update_twohanding()
		r_hand.update_held_icon()
		owner.mymob.update_inv_r_hand()

/datum/inventory_slot/r_hand
	name = "Right Hand"

	slot_id = slot_r_hand
	slot_id_str = slot_r_hand_str

	hud_location = ui_rhand
	hud_object_type = /obj/screen/inventory/hand
	hud_icon_state = "r_hand_inactive"

/datum/inventory_slot/r_hand/build_hud(datum/hud/HUD)
	var/obj/screen/inventory/I = ..()
	HUD.r_hand_hud_object = I

	if(isliving(owner.mymob))
		var/mob/living/L = owner.mymob
		if(!L.hand)
			I.icon_state = "r_hand_active"

	return I

/datum/inventory_slot/r_hand/update_icon(atom/movable/contents)
	. = ..()
	owner.mymob.update_inv_r_hand()

/datum/inventory_slot/r_hand/unequipped(atom/movable/contents)
	. = ..()
	var/obj/item/l_hand = owner.get_item_in_slot(slot_l_hand_str)
	if(istype(l_hand))
		l_hand.update_twohanding()
		l_hand.update_held_icon()
		owner.mymob.update_inv_l_hand()

/datum/inventory_slot/l_store
	name = "Left Pocket"

	slot_id = slot_l_store
	slot_id_str = slot_l_store_str

	hud_location = ui_storage1
	hud_object_type = /obj/screen/inventory
	hud_icon_state = "pocket"

/datum/inventory_slot/r_store
	name = "Right Pocket"

	slot_id = slot_r_store
	slot_id_str = slot_r_store_str

	hud_location = ui_storage2
	hud_object_type = /obj/screen/inventory
	hud_icon_state = "pocket"

/datum/inventory_slot/s_store
	name = "Suit Storage"

	slot_id = slot_s_store
	slot_id_str = slot_s_store_str

	hud_location = ui_sstore1
	hud_object_type = /obj/screen/inventory
	hud_icon_state = "suitstore"

/datum/inventory_slot/s_store/update_icon(atom/movable/contents)
	. = ..()
	owner.mymob.update_inv_s_store()

/datum/inventory_slot/back
	name = "Back"

	slot_id = slot_back
	slot_id_str = slot_back_str

	hud_location = ui_back
	hud_object_type = /obj/screen/inventory
	hud_icon_state = "back"

/datum/inventory_slot/back/update_icon(atom/movable/contents)
	owner.mymob.update_inv_back()

/datum/inventory_slot/back/equipped(atom/movable/contents)
	if(ishuman(owner.mymob))
		var/mob/living/carbon/human/H = owner.mymob
		H.worn_clothing |= contents

/datum/inventory_slot/back/unequipped(atom/movable/contents)
	if(ishuman(owner.mymob))
		var/mob/living/carbon/human/H = owner.mymob
		H.worn_clothing -= contents

/datum/inventory_slot/uniform
	name = "Uniform"

	slot_id = slot_w_uniform
	slot_id_str = slot_w_uniform_str

	hud_location = ui_iclothing
	hud_object_type = /obj/screen/inventory
	hud_icon_state = "center"
	hideable = TRUE

/datum/inventory_slot/uniform/update_icon(atom/movable/contents)
	owner.mymob.update_inv_w_uniform()

/datum/inventory_slot/uniform/equipped(atom/movable/contents)
	if(ishuman(owner.mymob))
		var/mob/living/carbon/human/H = owner.mymob
		H.worn_clothing |= contents

/datum/inventory_slot/uniform/unequipped(atom/movable/contents)
	if(owner.get_item_in_slot(slot_r_store_str))
		owner.mymob.drop_from_inventory(owner.get_item_in_slot(slot_r_store_str))
	if(owner.get_item_in_slot(slot_l_store_str))
		owner.mymob.drop_from_inventory(owner.get_item_in_slot(slot_l_store_str))
	if(ishuman(owner.mymob))
		var/mob/living/carbon/human/H = owner.mymob
		if(H.wear_id)
			H.drop_from_inventory(H.wear_id)
		var/obj/item/belt = owner.get_item_in_slot(slot_belt_str)
		if(istype(belt) && belt.suitlink == 1)
			H.drop_from_inventory(belt)

	if(ishuman(owner.mymob))
		var/mob/living/carbon/human/H = owner.mymob
		H.worn_clothing -= contents

/datum/inventory_slot/l_ear
	name = "Left Ear"

	slot_id = slot_l_ear
	slot_id_str = slot_l_ear_str

	hud_location = ui_l_ear
	hud_object_type = /obj/screen/inventory
	hud_icon_state = "ears"
	hideable = TRUE

/datum/inventory_slot/l_ear/update_icon(atom/movable/contents)
	. = ..()
	owner.mymob.update_inv_ears()

/datum/inventory_slot/l_ear/equipped(atom/movable/contents)
	. = ..()
	if(isitem(contents))
		var/obj/item/I = contents
		if(I.slot_flags & SLOT_TWOEARS)
			var/obj/item/clothing/ears/offear/O = new(I)
			O.forceMove(owner.mymob)
			O.hud_layerise()
			owner.put_item_in_slot(slot_r_ear_str, O)

/datum/inventory_slot/r_ear
	name = "Right Ear"

	slot_id = slot_r_ear
	slot_id_str = slot_r_ear_str

	hud_location = ui_r_ear
	hud_object_type = /obj/screen/inventory
	hud_icon_state = "ears"
	hideable = TRUE

/datum/inventory_slot/r_ear/update_icon(atom/movable/contents)
	. = ..()
	owner.mymob.update_inv_ears()

/datum/inventory_slot/r_ear/equipped(atom/movable/contents)
	. = ..()
	if(isitem(contents))
		var/obj/item/I = contents
		if(I.slot_flags & SLOT_TWOEARS)
			var/obj/item/clothing/ears/offear/O = new(I)
			O.forceMove(owner.mymob)
			O.hud_layerise()
			owner.put_item_in_slot(slot_l_ear_str, O)

/datum/inventory_slot/suit
	name = "Suit"

	slot_id = slot_wear_suit
	slot_id_str = slot_wear_suit_str

	hud_location = ui_oclothing
	hud_object_type = /obj/screen/inventory
	hud_icon_state = "suit"
	hideable = TRUE

/datum/inventory_slot/suit/update_icon(atom/movable/contents)
	owner.mymob.update_inv_wear_suit()

/datum/inventory_slot/suit/equipped(atom/movable/contents)
	if(ishuman(owner.mymob))
		var/mob/living/carbon/human/H = owner.mymob
		H.worn_clothing |= contents

/datum/inventory_slot/suit/unequipped(atom/movable/contents)
	if(ishuman(owner.mymob))
		var/mob/living/carbon/human/H = owner.mymob
		H.worn_clothing -= contents
		if(H.inventory.get_item_in_slot(slot_s_store_str))
			H.drop_from_inventory(H.inventory.get_item_in_slot(slot_s_store_str))

/datum/inventory_slot/belt
	name = "Belt"

	slot_id = slot_belt
	slot_id_str = slot_belt_str

	hud_location = ui_belt
	hud_object_type = /obj/screen/inventory
	hud_icon_state = "belt"

/datum/inventory_slot/belt/update_icon(atom/movable/contents)
	owner.mymob.update_inv_belt()

/datum/inventory_slot/belt/equipped(atom/movable/contents)
	if(ishuman(owner.mymob))
		var/mob/living/carbon/human/H = owner.mymob
		H.worn_clothing |= contents

/datum/inventory_slot/belt/unequipped(atom/movable/contents)
	if(ishuman(owner.mymob))
		var/mob/living/carbon/human/H = owner.mymob
		H.worn_clothing -= contents

/datum/inventory_slot/mask
	name = "Mask"

	slot_id = slot_wear_mask
	slot_id_str = slot_wear_mask_str

	hud_location = ui_mask
	hud_object_type = /obj/screen/inventory
	hud_icon_state = "mask"

/datum/inventory_slot/mask/update_icon(atom/movable/contents)
	owner.mymob.update_inv_wear_mask()

	if(isitem(contents))
		var/obj/item/I = contents
		if(I.flags_inv & (BLOCKHAIR|BLOCKHEADHAIR))
			owner.mymob.update_hair(0)	//rebuild hair
			owner.mymob.update_inv_ears(0)

/datum/inventory_slot/mask/equipped(atom/movable/contents)
	if(ishuman(owner.mymob))
		var/mob/living/carbon/human/H = owner.mymob
		H.worn_clothing |= contents

/datum/inventory_slot/mask/unequipped(atom/movable/contents)
	// If this is how the internals are connected, disable them
	if(ishuman(owner.mymob))
		var/mob/living/carbon/human/H = owner.mymob
		H.worn_clothing -= contents
		if(H.internal && !(H.head?.item_flags & AIRTIGHT))
			if(H.internals)
				H.internals.icon_state = "internal0"
			H.internal = null
