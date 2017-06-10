///////////////////////////////////////////////////////////////////////
//Glasses
/*
SEE_SELF  // can see self, no matter what
SEE_MOBS  // can see all mobs, no matter what
SEE_OBJS  // can see all objs, no matter what
SEE_TURFS // can see all turfs (and areas), no matter what
SEE_PIXELS// if an object is located on an unlit area, but some of its pixels are
          // in a lit area (via pixel_x,y or smooth movement), can see those pixels
BLIND     // can't see anything
*/
///////////////////////////////////////////////////////////////////////

/obj/item/clothing/glasses
	name = "glasses"
	icon = 'icons/obj/clothing/glasses.dmi'
	w_class = ITEMSIZE_SMALL
	slot_flags = SLOT_EYES
	var/vision_flags = 0
	var/darkness_view = 0//Base human is 2
	var/see_invisible = -1
	var/prescription = 0
	var/toggleable = 0
	var/off_state = "degoggles"
	var/active = 1
	var/activation_sound = 'sound/items/goggles_charge.ogg'
	var/obj/screen/overlay = null

	sprite_sheets = list(
		"Teshari" = 'icons/mob/species/seromi/eyes.dmi',
		"Vox" = 'icons/mob/species/vox/eyes.dmi'
		)

/obj/item/clothing/glasses/update_clothing_icon()
	if (ismob(src.loc))
		var/mob/M = src.loc
		M.update_inv_glasses()

/obj/item/clothing/glasses/attack_self(mob/user)
	if(toggleable)
		if(active)
			active = 0
			icon_state = off_state
			user.update_inv_glasses()
			usr << "You deactivate the optical matrix on the [src]."
		else
			active = 1
			icon_state = initial(icon_state)
			user.update_inv_glasses()
			usr << "You activate the optical matrix on the [src]."
		user.update_action_buttons()

/obj/item/clothing/glasses/meson
	name = "Optical Meson Scanner"
	desc = "Used for seeing walls, floors, and stuff through anything."
	icon_state = "meson"
	item_state_slots = list(slot_r_hand_str = "meson", slot_l_hand_str = "meson")
	action_button_name = "Toggle Goggles"
	origin_tech = list(TECH_MAGNET = 2, TECH_ENGINEERING = 2)
	toggleable = 1
	vision_flags = SEE_TURFS

/obj/item/clothing/glasses/meson/New()
	..()
	overlay = global_hud.meson

/obj/item/clothing/glasses/meson/prescription
	name = "prescription mesons"
	desc = "Optical Meson Scanner with prescription lenses."
	prescription = 1

/obj/item/clothing/glasses/meson/aviator
	name = "Engineering Aviators"
	icon_state = "aviator_eng"
	off_state = "aviator"
	item_state_slots = list(slot_r_hand_str = "sunglasses", slot_l_hand_str = "sunglasses")
	action_button_name = "Toggle HUD"
	activation_sound = 'sound/effects/pop.ogg'

/obj/item/clothing/glasses/meson/aviator/prescription
	name = "Prescription Engineering Aviators"
	desc = "Engineering Aviators with prescription lenses."
	prescription = 1

/obj/item/clothing/glasses/science
	name = "Science Goggles"
	desc = "The goggles do nothing!"
	icon_state = "purple"
	item_state_slots = list(slot_r_hand_str = "glasses", slot_l_hand_str = "glasses")
	toggleable = 1
	action_button_name = "Toggle Goggles"
	item_flags = AIRTIGHT

/obj/item/clothing/glasses/science/New()
	..()
	overlay = global_hud.science

/obj/item/clothing/glasses/goggles
	name = "Goggles"
	desc = "Just some plain old goggles."
	icon_state = "plaingoggles"
	item_state_slots = list(slot_r_hand_str = "glasses", slot_l_hand_str = "glasses")
	item_flags = AIRTIGHT
	body_parts_covered = EYES

/obj/item/clothing/glasses/night
	name = "Night Vision Goggles"
	desc = "You can totally see in the dark now!"
	icon_state = "night"
	item_state_slots = list(slot_r_hand_str = "glasses", slot_l_hand_str = "glasses")
	origin_tech = list(TECH_MAGNET = 2)
	darkness_view = 7
	toggleable = 1
	action_button_name = "Toggle Goggles"
	see_invisible = SEE_INVISIBLE_NOLIGHTING
	off_state = "denight"

/obj/item/clothing/glasses/night/vox
	name = "Alien Optics"
	species_restricted = list("Vox")
	phoronproof = 1

/obj/item/clothing/glasses/night/New()
	..()
	overlay = global_hud.nvg

/obj/item/clothing/glasses/eyepatch
	name = "eyepatch"
	desc = "Yarr."
	icon_state = "eyepatch"
	item_state_slots = list(slot_r_hand_str = "blindfold", slot_l_hand_str = "blindfold")
	body_parts_covered = 0
	var/eye = null

/obj/item/clothing/glasses/eyepatch/verb/switcheye()
	set name = "Switch Eyepatch"
	set category = "Object"
	set src in usr
	if(!istype(usr, /mob/living)) return
	if(usr.stat) return

	eye = !eye
	if(eye)
		icon_state = "[icon_state]_1"
	else
		icon_state = initial(icon_state)
	update_clothing_icon()

/obj/item/clothing/glasses/monocle
	name = "monocle"
	desc = "Such a dapper eyepiece!"
	icon_state = "monocle"
	item_state_slots = list(slot_r_hand_str = "headset", slot_l_hand_str = "headset")
	body_parts_covered = 0

/obj/item/clothing/glasses/material
	name = "Optical Material Scanner"
	desc = "Very confusing glasses."
	icon_state = "material"
	item_state_slots = list(slot_r_hand_str = "glasses", slot_l_hand_str = "glasses")
	origin_tech = list(TECH_MAGNET = 3, TECH_ENGINEERING = 3)
	toggleable = 1
	action_button_name = "Toggle Goggles"
	vision_flags = SEE_OBJS

/obj/item/clothing/glasses/regular
	name = "Prescription Glasses"
	desc = "Made by Nerd. Co."
	icon_state = "glasses"
	item_state_slots = list(slot_r_hand_str = "glasses", slot_l_hand_str = "glasses")
	prescription = 1
	body_parts_covered = 0

/obj/item/clothing/glasses/regular/scanners
	name = "Scanning Goggles"
	desc = "A very oddly shaped pair of goggles with bits of wire poking out the sides. A soft humming sound emanates from it."
	icon_state = "uzenwa_sissra_1"

/obj/item/clothing/glasses/regular/hipster
	name = "Prescription Glasses"
	desc = "Made by Uncool. Co."
	icon_state = "hipster_glasses"

/obj/item/clothing/glasses/threedglasses
	desc = "A long time ago, people used these glasses to makes images from screens threedimensional."
	name = "3D glasses"
	icon_state = "3d"
	item_state_slots = list(slot_r_hand_str = "glasses", slot_l_hand_str = "glasses")
	body_parts_covered = 0

/obj/item/clothing/glasses/gglasses
	name = "Green Glasses"
	desc = "Forest green glasses, like the kind you'd wear when hatching a nasty scheme."
	icon_state = "gglasses"
	item_state_slots = list(slot_r_hand_str = "glasses", slot_l_hand_str = "glasses")
	body_parts_covered = 0

/obj/item/clothing/glasses/sunglasses
	desc = "Strangely ancient technology used to help provide rudimentary eye cover. Enhanced shielding blocks many flashes."
	name = "sunglasses"
	icon_state = "sun"
	item_state_slots = list(slot_r_hand_str = "sunglasses", slot_l_hand_str = "sunglasses")
	darkness_view = -1

/obj/item/clothing/glasses/welding
	name = "welding goggles"
	desc = "Protects the eyes from welders, approved by the mad scientist association."
	icon_state = "welding-g"
	item_state_slots = list(slot_r_hand_str = "welding-g", slot_l_hand_str = "welding-g")
	action_button_name = "Flip Welding Goggles"
	matter = list(DEFAULT_WALL_MATERIAL = 1500, "glass" = 1000)
	item_flags = AIRTIGHT
	var/up = 0

/obj/item/clothing/glasses/welding/attack_self()
	toggle()

/obj/item/clothing/glasses/welding/verb/toggle()
	set category = "Object"
	set name = "Adjust welding goggles"
	set src in usr

	if(usr.canmove && !usr.stat && !usr.restrained())
		if(src.up)
			src.up = !src.up
			flags_inv |= HIDEEYES
			body_parts_covered |= EYES
			icon_state = initial(icon_state)
			usr << "You flip \the [src] down to protect your eyes."
		else
			src.up = !src.up
			flags_inv &= ~HIDEEYES
			body_parts_covered &= ~EYES
			icon_state = "[initial(icon_state)]up"
			usr << "You push \the [src] up out of your face."
		update_clothing_icon()
		usr.update_action_buttons()

/obj/item/clothing/glasses/welding/superior
	name = "superior welding goggles"
	desc = "Welding goggles made from more expensive materials, strangely smells like potatoes."
	icon_state = "rwelding-g"

/obj/item/clothing/glasses/sunglasses/blindfold
	name = "blindfold"
	desc = "Covers the eyes, preventing sight."
	icon_state = "blindfold"
	item_state_slots = list(slot_r_hand_str = "blindfold", slot_l_hand_str = "blindfold")
	//vision_flags = BLIND  	// This flag is only supposed to be used if it causes permanent blindness, not temporary because of glasses

/obj/item/clothing/glasses/sunglasses/blindfold/tape
	name = "length of tape"
	desc = "It's a robust DIY blindfold!"
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "tape_cross"
	item_state_slots = list(slot_r_hand_str = null, slot_l_hand_str = null)
	w_class = ITEMSIZE_TINY

/obj/item/clothing/glasses/sunglasses/prescription
	name = "prescription sunglasses"
	prescription = 1

/obj/item/clothing/glasses/sunglasses/big
	desc = "Strangely ancient technology used to help provide rudimentary eye cover. Larger than average enhanced shielding blocks many flashes."
	icon_state = "bigsunglasses"

/obj/item/clothing/glasses/fakesunglasses //Sunglasses without flash immunity
	name = "stylish sunglasses"
	desc = "A pair of designer sunglasses. Doesn't seem like it'll block flashes."
	icon_state = "sun"
	item_state_slots = list(slot_r_hand_str = "sunglasses", slot_l_hand_str = "sunglasses")

/obj/item/clothing/glasses/fakesunglasses/aviator
	name = "stylish aviators"
	desc = "A pair of designer sunglasses. Doesn't seem like it'll block flashes."
	icon_state = "aviator"

/obj/item/clothing/glasses/sunglasses/sechud
	name = "HUDSunglasses"
	desc = "Sunglasses with a HUD."
	icon_state = "sunSecHud"
	var/obj/item/clothing/glasses/hud/security/hud = null

	New()
		..()
		src.hud = new/obj/item/clothing/glasses/hud/security(src)
		return

/obj/item/clothing/glasses/sunglasses/sechud/tactical
	name = "tactical HUD"
	desc = "Flash-resistant goggles with inbuilt combat and security information."
	icon_state = "swatgoggles"

/obj/item/clothing/glasses/sunglasses/sechud/aviator
	name = "Security HUD aviators"
	desc = "Modified aviator glasses that can be switch between HUD and flash protection modes."
	icon_state = "aviator_sec"
	off_state = "aviator"
	action_button_name = "Toggle Mode"
	var/on = 1
	toggleable = 1
	activation_sound = 'sound/effects/pop.ogg'

	var/hud_holder

/obj/item/clothing/glasses/sunglasses/sechud/aviator/New()
	..()
	hud_holder = hud

/obj/item/clothing/glasses/sunglasses/sechud/aviator/Destroy()
	qdel(hud_holder)
	hud_holder = null
	hud = null
	. = ..()

/obj/item/clothing/glasses/sunglasses/sechud/aviator/attack_self(mob/user)
	if(toggleable && !user.incapacitated())
		on = !on
		if(on)
			src.hud = hud_holder
			to_chat(user, "You switch the [src] to HUD mode.")
		else
			src.hud = null
			to_chat(user, "You switch \the [src] to flash protection mode.")
		update_icon()
		user << activation_sound
		user.update_inv_glasses()
		user.update_action_buttons()

/obj/item/clothing/glasses/sunglasses/sechud/aviator/update_icon()
	if(on)
		icon_state = initial(icon_state)
	else
		icon_state = off_state

/obj/item/clothing/glasses/sunglasses/sechud/aviator/prescription
	name = "Prescription Security HUD aviators"
	desc = "Modified aviator glasses that can be switch between HUD and flash protection modes. Comes with bonus prescription lenses."
	prescription = 6

/obj/item/clothing/glasses/sunglasses/medhud
	name = "HUDSunglasses"
	desc = "Sunglasses with a HUD."
	icon_state = "sunMedHud"
	var/obj/item/clothing/glasses/hud/health/hud = null

/obj/item/clothing/glasses/sunglasses/medhud/New()
		..()
		src.hud = new/obj/item/clothing/glasses/hud/health(src)
		return

/obj/item/clothing/glasses/sunglasses/medhud/aviator
	name = "Medical HUD aviators"
	desc = "Modified aviator glasses with a toggled health HUD."
	icon_state = "aviator_med"
	off_state = "aviator"
	action_button_name = "Toggle Mode"
	var/on = 1
	toggleable = 1
	activation_sound = 'sound/effects/pop.ogg'

	var/hud_holder

/obj/item/clothing/glasses/sunglasses/medhud/aviator/New()
	..()
	hud_holder = hud

/obj/item/clothing/glasses/sunglasses/medhud/aviator/Destroy()
	qdel(hud_holder)
	hud_holder = null
	hud = null
	. = ..()

/obj/item/clothing/glasses/sunglasses/medhud/aviator/attack_self(mob/user)
	if(toggleable && !user.incapacitated())
		on = !on
		if(on)
			src.hud = hud_holder
			to_chat(user, "You switch the [src] to HUD mode.")
		else
			src.hud = null
			to_chat(user, "You switch \the [src] off.")
		update_icon()
		user << activation_sound
		user.update_inv_glasses()
		user.update_action_buttons()

/obj/item/clothing/glasses/sunglasses/medhud/aviator/update_icon()
	if(on)
		icon_state = initial(icon_state)
	else
		icon_state = off_state

/obj/item/clothing/glasses/sunglasses/medhud/aviator/prescription
	name = "Prescription Medical HUD aviators"
	desc = "Modified aviator glasses with a toggled health HUD. Comes with bonus prescription lenses."
	prescription = 6

/obj/item/clothing/glasses/thermal
	name = "Optical Thermal Scanner"
	desc = "Thermals in the shape of glasses."
	icon_state = "thermal"
	item_state_slots = list(slot_r_hand_str = "glasses", slot_l_hand_str = "glasses")
	origin_tech = list(TECH_MAGNET = 3)
	toggleable = 1
	action_button_name = "Toggle Goggles"
	vision_flags = SEE_MOBS
	see_invisible = SEE_INVISIBLE_NOLIGHTING


	emp_act(severity)
		if(istype(src.loc, /mob/living/carbon/human))
			var/mob/living/carbon/human/M = src.loc
			M << "\red The Optical Thermal Scanner overloads and blinds you!"
			if(M.glasses == src)
				M.Blind(3)
				M.eye_blurry = 5
				// Don't cure being nearsighted
				if(!(M.disabilities & NEARSIGHTED))
					M.disabilities |= NEARSIGHTED
					spawn(100)
						M.disabilities &= ~NEARSIGHTED
		..()

/obj/item/clothing/glasses/thermal/New()
	..()
	overlay = global_hud.thermal

/obj/item/clothing/glasses/thermal/syndi	//These are now a traitor item, concealed as mesons.	-Pete
	name = "Optical Meson Scanner"
	desc = "Used for seeing walls, floors, and stuff through anything."
	icon_state = "meson"
	item_state_slots = list(slot_r_hand_str = "meson", slot_l_hand_str = "meson")
	origin_tech = list(TECH_MAGNET = 3, TECH_ILLEGAL = 4)

/obj/item/clothing/glasses/thermal/plain
	toggleable = 0
	activation_sound = null
	action_button_name = null

/obj/item/clothing/glasses/thermal/plain/monocle
	name = "Thermoncle"
	desc = "A monocle thermal."
	icon_state = "thermoncle"
	item_state_slots = list(slot_r_hand_str = "sunglasses", slot_l_hand_str = "sunglasses")
	toggleable = 1
	action_button_name = "Toggle Monocle"
	flags = null //doesn't protect eyes because it's a monocle, duh

	body_parts_covered = 0

/obj/item/clothing/glasses/thermal/plain/eyepatch
	name = "Optical Thermal Eyepatch"
	desc = "An eyepatch with built-in thermal optics"
	icon_state = "eyepatch"
	item_state_slots = list(slot_r_hand_str = "blindfold", slot_l_hand_str = "blindfold")
	body_parts_covered = 0
	toggleable = 1
	action_button_name = "Toggle Eyepatch"

/obj/item/clothing/glasses/thermal/plain/jensen
	name = "Optical Thermal Implants"
	desc = "A set of implantable lenses designed to augment your vision"
	icon_state = "thermalimplants"
	item_state_slots = list(slot_r_hand_str = "sunglasses", slot_l_hand_str = "sunglasses")