//Spacesuit
//Note: Everything in modules/clothing/spacesuits should have the entire suit grouped together.
//      Meaning the the suit is defined directly after the corrisponding helmet. Just like below!

/obj/item/clothing/head/helmet/space
	name = "Space helmet"
	icon_state = "space"
	desc = "A special helmet designed for work in a hazardous, low-pressure environment."
	item_flags = STOPPRESSUREDAMAGE | THICKMATERIAL | AIRTIGHT
	permeability_coefficient = 0.01
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 100, rad = 50)
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|HIDEFACE|BLOCKHAIR
	body_parts_covered = HEAD|FACE|EYES
	cold_protection = HEAD
	min_cold_protection_temperature = SPACE_HELMET_MIN_COLD_PROTECTION_TEMPERATURE
	siemens_coefficient = 0.9
	species_restricted = list("exclude",SPECIES_DIONA)
	preserve_item = 1
	phoronproof = 1
	flash_protection = FLASH_PROTECTION_MAJOR
	valid_accessory_slots = null

	var/obj/machinery/camera/camera
	var/list/camera_networks

	action_button_name = "Toggle Helmet Light"
	light_overlay = "helmet_light"
	brightness_on = 4
	on = 0

/obj/item/clothing/head/helmet/space/attack_self(mob/user)

	if(!camera && camera_networks)

		camera = new /obj/machinery/camera(src)
		camera.replace_networks(camera_networks)
		camera.c_tag = user.name
		user << "<font color='blue'>User scanned as [camera.c_tag]. Camera activated.</font>"
		user.update_action_buttons()
		return 1

	..()

/obj/item/clothing/head/helmet/space/examine()
	..()
	if(camera_networks && get_dist(usr,src) <= 1)
		usr << "This helmet has a built-in camera. It's [camera ? "" : "in"]active."

/obj/item/clothing/suit/space
	name = "Space suit"
	desc = "A suit that protects against low pressure environments."
	icon = 'icons/obj/clothing/spacesuits.dmi'
	update_icon_define = INV_SPACESUIT_DEF_ICON
	icon_state = "space"
	w_class = ITEMSIZE_HUGE // So you can't fit this in your bag and be prepared at all times.
	gas_transfer_coefficient = 0.01
	permeability_coefficient = 0.02
	item_flags = STOPPRESSUREDAMAGE | THICKMATERIAL
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|FEET|ARMS|HANDS
	allowed = list(/obj/item/device/flashlight,/obj/item/weapon/tank/emergency/oxygen,/obj/item/device/suit_cooling_unit)
	slowdown = 3
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 100, rad = 50)
	flags_inv = HIDEGLOVES|HIDESHOES|HIDEJUMPSUIT|HIDETAIL|HIDETIE|HIDEHOLSTER
	cold_protection = UPPER_TORSO | LOWER_TORSO | LEGS | FEET | ARMS | HANDS
	min_cold_protection_temperature = SPACE_SUIT_MIN_COLD_PROTECTION_TEMPERATURE
	siemens_coefficient = 0.9
	species_restricted = list("exclude",SPECIES_DIONA)
	preserve_item = 1
	phoronproof = 1

	var/list/supporting_limbs //If not-null, automatically splints breaks. Checked when removing the suit.

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
				user << "You feel [src] constrict about your [E.name], supporting it."
				supporting_limbs |= E
	else
		// Otherwise, remove the splints.
		for(var/obj/item/organ/external/E in supporting_limbs)
			if(E.splinted == src && E.remove_splint(src))
				user << "\The [src] stops supporting your [E.name]."
		supporting_limbs.Cut()

/obj/item/clothing/suit/space/proc/handle_fracture(var/mob/living/carbon/human/user, var/obj/item/organ/external/E)
	if(!istype(user) || isnull(supporting_limbs))
		return
	if(E.is_broken() && E.apply_splint(src))
		user << "You feel [src] constrict about your [E.name], supporting it."
		supporting_limbs |= E
