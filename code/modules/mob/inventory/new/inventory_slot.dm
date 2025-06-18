/datum/inventory_slot
	var/name = ""

	var/slot_id
	var/slot_id_str

	var/hud_location
	var/hud_object_type
	var/hud_icon_state

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

	HUD.slot_info["[slot_id]"] = I.screen_loc

	return I

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
