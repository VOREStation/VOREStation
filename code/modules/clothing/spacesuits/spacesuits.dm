//Spacesuit
//Note: Everything in modules/clothing/spacesuits should have the entire suit grouped together.
//      Meaning the the suit is defined directly after the corrisponding helmet. Just like below!

/obj/item/clothing/head/helmet/space
	name = "Space helmet"
	icon_state = "space"
	desc = "A special helmet designed for work in a hazardous, low-pressure environment."
	randpixel = 0
	center_of_mass = null
	flags = PHORONGUARD
	item_flags = THICKMATERIAL | AIRTIGHT | ALLOW_SURVIVALFOOD
	permeability_coefficient = 0.01
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 100, rad = 50)
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|HIDEFACE|BLOCKHAIR
	body_parts_covered = HEAD|FACE|EYES
	cold_protection = HEAD
	min_cold_protection_temperature = SPACE_HELMET_MIN_COLD_PROTECTION_TEMPERATURE
	min_pressure_protection = 0 * ONE_ATMOSPHERE
	max_pressure_protection = 2 * ONE_ATMOSPHERE
	siemens_coefficient = 0.9
	species_restricted = list("exclude",SPECIES_DIONA)
	preserve_item = 1
	flash_protection = FLASH_PROTECTION_MAJOR
	valid_accessory_slots = null

	var/obj/machinery/camera/camera
	var/list/camera_networks

	action_button_name = "Toggle Helmet Light"
	light_overlay = "helmet_light"
	light_range = 4

/obj/item/clothing/head/helmet/space/Initialize()
	. = ..()
	if(camera_networks)
		verbs |= /obj/item/clothing/head/helmet/space/proc/toggle_camera

	if(type == /obj/item/clothing/head/helmet/space) //VOREStation edit - use the specially refitted sprites by KBraid. Done this way to avoid breaking subtypes.
		LAZYSET(sprite_sheets, SPECIES_TESHARI, 'icons/inventory/head/mob_vr_teshari.dmi')

/obj/item/clothing/head/helmet/space/proc/toggle_camera()
	set name = "Toggle Helmet Camera"
	set desc = "Turn your helmet's camera on or off."
	set category = "Hardsuit"
	set src in usr
	if(usr.stat || usr.restrained() || usr.incapacitated())
		return

	if(!camera)
		camera = new /obj/machinery/camera(src)
		camera.replace_networks(camera_networks)
		camera.set_status(FALSE) //So the camera will activate in the following check.

	if(camera.status == TRUE)
		camera.set_status(FALSE)
		to_chat(usr, span_blue("Camera deactivated."))
	else
		camera.set_status(TRUE)
		camera.c_tag = usr.name
		to_chat(usr, span_blue("User scanned as [camera.c_tag]. Camera activated."))

/obj/item/clothing/head/helmet/space/examine(mob/user)
	. = ..()
	if(camera_networks && Adjacent(user))
		. += "This helmet has a built-in camera. It's [camera ? "" : "in"]active."

/obj/item/clothing/suit/space
	name = "Space suit"
	desc = "A suit that protects against low pressure environments."
	icon = 'icons/inventory/suit/item.dmi'
	icon_state = "space"
	w_class = ITEMSIZE_HUGE // So you can't fit this in your bag and be prepared at all times.
	gas_transfer_coefficient = 0.01
	permeability_coefficient = 0.02
	flags = PHORONGUARD
	item_flags = THICKMATERIAL
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|FEET|ARMS|HANDS
	allowed = list(/obj/item/device/flashlight,/obj/item/weapon/tank/emergency/oxygen,/obj/item/device/suit_cooling_unit)
	slowdown = 1.5
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 100, rad = 50)
	flags_inv = HIDEGLOVES|HIDESHOES|HIDEJUMPSUIT|HIDETAIL|HIDETIE|HIDEHOLSTER
	cold_protection = UPPER_TORSO | LOWER_TORSO | LEGS | FEET | ARMS | HANDS
	min_cold_protection_temperature = SPACE_SUIT_MIN_COLD_PROTECTION_TEMPERATURE
	min_pressure_protection = 0 * ONE_ATMOSPHERE
	max_pressure_protection = 2 * ONE_ATMOSPHERE
	siemens_coefficient = 0.9
	species_restricted = list("exclude",SPECIES_DIONA)
	preserve_item = 1
	valid_accessory_slots = (ACCESSORY_SLOT_OVER | ACCESSORY_SLOT_ARMBAND | ACCESSORY_SLOT_DECOR)
	var/list/supporting_limbs //If not-null, automatically splints breaks. Checked when removing the suit.

//VOREStation edit start - use the specially refitted sprites by KBraid. Done this way to avoid breaking subtypes.
/obj/item/clothing/suit/space/Initialize()
	. = ..()
	if(type == /obj/item/clothing/suit/space)
		LAZYSET(sprite_sheets, SPECIES_TESHARI, 'icons/inventory/suit/mob_vr_teshari.dmi')
//VOREStation edit end.

/obj/item/clothing/suit/space/equipped(mob/M)
	check_limb_support(M)
	..()

/obj/item/clothing/suit/space/dropped(var/mob/user)
	check_limb_support(user)
	..()

// Some space suits are equipped with reactive membranes that support
// broken limbs - at the time of writing, only the ninja suit, but
// I can see it being useful for other suits as we expand them. ~ Z
// The actual splinting occurs in /obj/item/organ/external/proc/fracture()
/obj/item/clothing/suit/space/proc/check_limb_support(var/mob/living/carbon/human/user)

	// If this isn't set, then we don't need to care.
	if(!istype(user) || isnull(supporting_limbs))
		return

	if(user.wear_suit == src)
		for(var/obj/item/organ/external/E in user.bad_external_organs)
			if(E.is_broken() && E.apply_splint(src))
				to_chat(user, "You feel [src] constrict about your [E.name], supporting it.")
				supporting_limbs |= E
	else
		// Otherwise, remove the splints.
		for(var/obj/item/organ/external/E in supporting_limbs)
			if(E.splinted == src && E.remove_splint(src))
				to_chat(user, "\The [src] stops supporting your [E.name].")
		supporting_limbs.Cut()

/obj/item/clothing/suit/space/proc/handle_fracture(var/mob/living/carbon/human/user, var/obj/item/organ/external/E)
	if(!istype(user) || isnull(supporting_limbs))
		return
	if(E.is_broken() && E.apply_splint(src))
		to_chat(user, "You feel [src] constrict about your [E.name], supporting it.")
		supporting_limbs |= E
