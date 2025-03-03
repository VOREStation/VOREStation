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
	icon = 'icons/inventory/eyes/item.dmi'
	w_class = ITEMSIZE_SMALL
	slot_flags = SLOT_EYES
	plane_slots = list(slot_glasses)
	var/vision_flags = 0
	var/darkness_view = 0//Base human is 2
	var/see_invisible = -1
	var/prescription = 0
	var/toggleable = 0
	var/off_state = "degoggles"
	var/active = 1
	var/activation_sound = 'sound/items/goggles_charge.ogg'
	var/obj/screen/overlay = null
	var/list/away_planes //Holder for disabled planes
	drop_sound = 'sound/items/drop/accessory.ogg'
	pickup_sound = 'sound/items/pickup/accessory.ogg'

	sprite_sheets = list(
		SPECIES_TESHARI = 'icons/inventory/eyes/mob_teshari.dmi',
		SPECIES_VOX = 'icons/inventory/eyes/mob_vox.dmi'
		)
	var/glasses_layer_above = FALSE

/obj/item/clothing/glasses/update_clothing_icon()
	if (ismob(src.loc))
		var/mob/M = src.loc
		M.update_inv_glasses()

/obj/item/clothing/glasses/proc/can_toggle(mob/living/user)
	if(!toggleable)
		return FALSE

	// Prevent people from just turning their goggles back on.
	if(!active && (vision_flags & (SEE_TURFS|SEE_OBJS)))
		var/area/A = get_area(src)
		if(A.flag_check(AREA_NO_SPOILERS))
			return FALSE

	return TRUE

/obj/item/clothing/glasses/proc/toggle_active(mob/living/user)
	if(active)
		active = FALSE
		icon_state = off_state
		user.update_inv_glasses()
		flash_protection = FLASH_PROTECTION_NONE
		tint = TINT_NONE
		away_planes = enables_planes
		enables_planes = null

	else
		active = TRUE
		icon_state = initial(icon_state)
		user.update_inv_glasses()
		flash_protection = initial(flash_protection)
		tint = initial(tint)
		enables_planes = away_planes
		away_planes = null
	user.update_mob_action_buttons()
	user.recalculate_vis()

/obj/item/clothing/glasses/attack_self(mob/user)
	if(toggleable)
		if(!can_toggle(user))
			to_chat(user, span_warning("You don't seem to be able to toggle \the [src] here."))
		else
			toggle_active(user)
			if(active)
				to_chat(user, span_notice("You activate the optical matrix on the [src]."))
			else
				to_chat(user, span_notice("You deactivate the optical matrix on the [src]."))
	..()

/obj/item/clothing/glasses/meson
	name = "optical meson scanner"
	desc = "Used for seeing walls, floors, and stuff through anything."
	icon_state = "meson"
	item_state_slots = list(slot_r_hand_str = "meson", slot_l_hand_str = "meson")
	actions_types = list(/datum/action/item_action/toggle_goggles)
	origin_tech = list(TECH_MAGNET = 2, TECH_ENGINEERING = 2)
	toggleable = 1
	vision_flags = SEE_TURFS
	enables_planes = list(VIS_FULLBRIGHT, VIS_MESONS)

/obj/item/clothing/glasses/meson/New()
	..()
	overlay = global_hud.meson

/obj/item/clothing/glasses/meson/prescription
	name = "prescription mesons"
	desc = "Optical Meson Scanner with prescription lenses."
	prescription = 1

/obj/item/clothing/glasses/meson/aviator
	name = "engineering aviators"
	icon_state = "aviator_eng"
	off_state = "aviator"
	item_state_slots = list(slot_r_hand_str = "sunglasses", slot_l_hand_str = "sunglasses")
	actions_types = list(/datum/action/item_action/toggle_hud)
	activation_sound = 'sound/effects/pop.ogg'

/obj/item/clothing/glasses/meson/aviator/prescription
	name = "prescription engineering aviators"
	desc = "Engineering Aviators with prescription lenses."
	prescription = 1

/obj/item/clothing/glasses/hud/health/aviator
	name = "medical HUD aviators"
	desc = "Modified aviator glasses with a toggled health HUD."
	icon_state = "aviator_med"
	off_state = "aviator"
	actions_types = list(/datum/action/item_action/toggle_mode)
	toggleable = 1
	activation_sound = 'sound/effects/pop.ogg'

/obj/item/clothing/glasses/hud/health/aviator/prescription
	name = "prescription medical HUD aviators"
	desc = "Modified aviator glasses with a toggled health HUD. Comes with bonus prescription lenses."
	prescription = 6

/obj/item/clothing/glasses/science
	name = "Science Goggles"
	desc = "The goggles do nothing!"
	icon_state = "purple"
	item_state_slots = list(slot_r_hand_str = "glasses", slot_l_hand_str = "glasses")
	toggleable = 1
	actions_types = list(/datum/action/item_action/toggle_goggles)
	item_flags = AIRTIGHT

/obj/item/clothing/glasses/science/New()
	..()
	overlay = global_hud.science

/obj/item/clothing/glasses/goggles
	name = "goggles"
	desc = "Just some plain old goggles."
	icon_state = "plaingoggles"
	item_state_slots = list(slot_r_hand_str = "glasses", slot_l_hand_str = "glasses")
	item_flags = AIRTIGHT
	body_parts_covered = EYES

/obj/item/clothing/glasses/night
	name = "night vision goggles"
	desc = "You can totally see in the dark now!"
	icon_state = "night"
	item_state_slots = list(slot_r_hand_str = "glasses", slot_l_hand_str = "glasses")
	origin_tech = list(TECH_MAGNET = 2)
	darkness_view = 7
	toggleable = 1
	actions_types = list(/datum/action/item_action/toggle_goggles)
	off_state = "denight"
	flash_protection = FLASH_PROTECTION_REDUCED
	enables_planes = list(VIS_FULLBRIGHT)

/obj/item/clothing/glasses/night/vox
	name = "Alien Optics"
	species_restricted = list("Vox")
	flags = PHORONGUARD

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
	drop_sound = 'sound/items/drop/gloves.ogg'
	pickup_sound = 'sound/items/pickup/gloves.ogg'

/obj/item/clothing/glasses/eyepatch/verb/switcheye()
	set name = "Switch Eyepatch"
	set category = "Object"
	set src in usr
	if(!isliving(usr)) return
	if(usr.stat) return

	eye = !eye
	if(eye)
		icon_state = "[icon_state]_1"
	else
		icon_state = initial(icon_state)
	update_clothing_icon()

/obj/item/clothing/glasses/eyepatchwhite
	name = "eyepatch"
	desc = "A simple eyepatch made of a strip of cloth tied around the head."
	icon_state = "eyepatch_white"
	item_state_slots = list(slot_r_hand_str = "blindfold", slot_l_hand_str = "blindfold")
	body_parts_covered = 0
	var/eye = null
	drop_sound = 'sound/items/drop/gloves.ogg'
	pickup_sound = 'sound/items/pickup/gloves.ogg'

/obj/item/clothing/glasses/eyepatchwhite/verb/switcheye()
	set name = "Switch Eyepatch"
	set category = "Object"
	set src in usr
	if(!isliving(usr)) return
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
	name = "optical material scanner"
	desc = "Very confusing glasses."
	icon_state = "material"
	item_state_slots = list(slot_r_hand_str = "glasses", slot_l_hand_str = "glasses")
	origin_tech = list(TECH_MAGNET = 3, TECH_ENGINEERING = 3)
	toggleable = 1
	actions_types = list(/datum/action/item_action/toggle_goggles)
	vision_flags = SEE_OBJS
	enables_planes = list(VIS_FULLBRIGHT)

/obj/item/clothing/glasses/material/Initialize(mapload)
	. = ..()
	overlay = global_hud.material

/obj/item/clothing/glasses/material/prescription
	name = "prescription optical material scanner"
	prescription = 1

/obj/item/clothing/glasses/graviton
	name = "graviton goggles"
	desc = "The secrets of space travel are.. not quite yours."
	icon_state = "grav"
	item_state_slots = list(slot_r_hand_str = "glasses", slot_l_hand_str = "glasses")
	origin_tech = list(TECH_MAGNET = 2, TECH_BLUESPACE = 1)
	darkness_view = 5
	toggleable = 1
	actions_types = list(/datum/action/item_action/toggle_goggles)
	off_state = "denight"
	vision_flags = SEE_OBJS | SEE_TURFS
	flash_protection = FLASH_PROTECTION_REDUCED
	enables_planes = list(VIS_FULLBRIGHT, VIS_MESONS)

/obj/item/clothing/glasses/graviton/New()
	..()
	overlay = global_hud.material

/obj/item/clothing/glasses/regular
	name = "prescription glasses"
	desc = "Made by Nerd. Co."
	icon_state = "glasses"
	item_state_slots = list(slot_r_hand_str = "glasses", slot_l_hand_str = "glasses")
	prescription = 1
	body_parts_covered = 0

/obj/item/clothing/glasses/regular/scanners
	name = "scanning goggles"
	desc = "A very oddly shaped pair of goggles with bits of wire poking out the sides. A soft humming sound emanates from it."
	icon_state = "uzenwa_sissra_1"

/obj/item/clothing/glasses/regular/hipster
	name = "prescription glasses"
	desc = "Made by Uncool. Co."
	icon_state = "hipster_glasses"

/obj/item/clothing/glasses/threedglasses
	desc = "A long time ago, people used these glasses to makes images from screens threedimensional."
	name = "3D glasses"
	icon_state = "3d"
	item_state_slots = list(slot_r_hand_str = "glasses", slot_l_hand_str = "glasses")
	body_parts_covered = 0

/obj/item/clothing/glasses/artist
	name = "4-D Glasses"
	desc = "You can see in every dimension, and get four times the amount of headache!"
	icon_state = "artist"
	item_state = "artist_glasses"

/obj/item/clothing/glasses/gglasses
	name = "green glasses"
	desc = "Forest green glasses, like the kind you'd wear when hatching a nasty scheme."
	icon_state = "gglasses"
	item_state_slots = list(slot_r_hand_str = "glasses", slot_l_hand_str = "glasses")
	body_parts_covered = 0

/obj/item/clothing/glasses/regular/rimless
	name = "prescription rimless glasses"
	desc = "Sleek modern glasses with a single sculpted lens."
	icon_state = "glasses_rimless"

/obj/item/clothing/glasses/rimless
	name = "rimless glasses"
	desc = "Sleek modern glasses with a single sculpted lens."
	icon_state = "glasses_rimless"
	prescription = 0

/obj/item/clothing/glasses/regular/thin
	name = "prescription thin-rimmed glasses"
	desc = "Glasses with frames are so last century."
	icon_state = "glasses_thin"
	prescription = 1

/obj/item/clothing/glasses/thin
	name = "thin-rimmed glasses"
	desc = "Glasses with frames are so last century."
	icon_state = "glasses_thin"
	prescription = 0


/obj/item/clothing/glasses/sunglasses
	name = "sunglasses"
	desc = "Strangely ancient technology used to help provide rudimentary eye cover. Enhanced shielding blocks many flashes."
	icon_state = "sun"
	item_state_slots = list(slot_r_hand_str = "sunglasses", slot_l_hand_str = "sunglasses")
	darkness_view = -1
	flash_protection = FLASH_PROTECTION_MODERATE

/obj/item/clothing/glasses/sunglasses/aviator
	name = "aviators"
	desc = "A pair of designer sunglasses."
	icon_state = "aviator"

/obj/item/clothing/glasses/sunglasses/bigshot
	name = "colored glasses"
	desc = "A pair of glasses with uniquely colored lenses to make you feel like a \[BIG SHOT]."
	description_fluff = "A prototype model of the AR glasses which focused on stylization and \
	functionality. The concept never caught on and was replaced with the earlier rendition of \
	the modern AR glasses. These have quite clearly seen better days as the AR function no \
	longer works, the toggle merely obscuring the users vison."
	icon_state = "salesman"
	var/ar = 0

/obj/item/clothing/glasses/sunglasses/bigshot/examine(mob/user)
	. = ..()
	. += to_chat(user, span_notice("Alt-click to toggle modes."))

/obj/item/clothing/glasses/sunglasses/bigshot/AltClick(mob/user)
	set src in usr
	if(user.canmove && !user.stat && !user.restrained())
		if(src.ar)
			src.ar = !src.ar
			icon_state = initial(icon_state)
			to_chat(user, "You press a small button on \the [src] and deactivate the AR mode.")
		else
			src.ar = !src.ar
			icon_state = "[initial(icon_state)]_fzz"
			to_chat(user, "You press a small button on \the [src] and activate the AR mode.")
		update_clothing_icon()

/obj/item/clothing/glasses/welding
	name = "welding goggles"
	desc = "Protects the eyes from welders, approved by the mad scientist association."
	icon_state = "welding-g"
	item_state_slots = list(slot_r_hand_str = "welding-g", slot_l_hand_str = "welding-g")
	actions_types = list(/datum/action/item_action/flip_welding_goggles)
	matter = list(MAT_STEEL = 1500, MAT_GLASS = 1000)
	item_flags = AIRTIGHT
	var/up = 0
	flash_protection = FLASH_PROTECTION_MAJOR
	tint = TINT_HEAVY

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
			flash_protection = initial(flash_protection)
			tint = initial(tint)
			to_chat(usr, "You flip \the [src] down to protect your eyes.")
		else
			src.up = !src.up
			flags_inv &= ~HIDEEYES
			body_parts_covered &= ~EYES
			icon_state = "[initial(icon_state)]up"
			flash_protection = FLASH_PROTECTION_NONE
			tint = TINT_NONE
			to_chat(usr, "You push \the [src] up out of your face.")
		update_clothing_icon()
		usr.update_mob_action_buttons()

/obj/item/clothing/glasses/welding/superior
	name = "superior welding goggles"
	desc = "Welding goggles made from more expensive materials, strangely smells like potatoes."
	icon_state = "rwelding-g"
	tint = TINT_MODERATE

/obj/item/clothing/glasses/sunglasses/blindfold
	name = "blindfold"
	desc = "Covers the eyes, preventing sight."
	icon_state = "blindfold"
	item_state_slots = list(slot_r_hand_str = "blindfold", slot_l_hand_str = "blindfold")
	flash_protection = FLASH_PROTECTION_MAJOR
	body_parts_covered = EYES
	tint = BLIND
	drop_sound = 'sound/items/drop/gloves.ogg'
	pickup_sound = 'sound/items/pickup/gloves.ogg'

/obj/item/clothing/glasses/sunglasses/blindfold/whiteblindfold
	name = "white blindfold"
	desc = "A white blindfold that covers the eyes, preventing sight."
	icon_state = "blindfoldwhite"

/obj/item/clothing/glasses/sunglasses/thinblindfold
	name = "thin white blindfold"
	desc = "A thin blindfold to help protect sensitive eyes while still allowing some sight"
	icon_state = "blindfoldwhite"
	flash_protection = FLASH_PROTECTION_MODERATE //not as thick, only offers some protection
	body_parts_covered = EYES
	tint = TINT_HEAVY

/obj/item/clothing/glasses/sunglasses/blindfold/tape
	name = "length of tape"
	desc = "It's a robust DIY blindfold!"
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "tape_cross"
	item_state_slots = list(slot_r_hand_str = null, slot_l_hand_str = null)
	w_class = ITEMSIZE_TINY
	body_parts_covered = EYES

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
	name = "\improper HUD sunglasses"
	desc = "Sunglasses with a HUD."
	icon_state = "sunSecHud"
	enables_planes = list(VIS_CH_ID,VIS_CH_WANTED,VIS_CH_IMPTRACK,VIS_CH_IMPLOYAL,VIS_CH_IMPCHEM)

/obj/item/clothing/glasses/sunglasses/sechud/tactical
	name = "tactical HUD"
	desc = "Flash-resistant goggles with inbuilt combat and security information."
	icon_state = "swatgoggles"

/obj/item/clothing/glasses/sunglasses/sechud/aviator
	name = "security HUD aviators"
	desc = "Modified aviator glasses that can be switch between HUD and flash protection modes."
	icon_state = "aviator_sec"
	off_state = "aviator"
	actions_types = list(/datum/action/item_action/toggle_mode)
	var/on = 1
	toggleable = 1
	activation_sound = 'sound/effects/pop.ogg'

/obj/item/clothing/glasses/sunglasses/sechud/aviator/attack_self(mob/user)
	if(toggleable && !user.incapacitated())
		on = !on
		if(on)
			flash_protection = FLASH_PROTECTION_NONE
			enables_planes = away_planes
			away_planes = null
			to_chat(user, "You switch the [src] to HUD mode.")
		else
			flash_protection = initial(flash_protection)
			away_planes = enables_planes
			enables_planes = null
			to_chat(user, "You switch \the [src] to flash protection mode.")
		update_icon()
		user << activation_sound
		user.recalculate_vis()
		user.update_inv_glasses()
		user.update_mob_action_buttons()

/obj/item/clothing/glasses/sunglasses/sechud/aviator/update_icon()
	if(on)
		icon_state = initial(icon_state)
	else
		icon_state = off_state

/obj/item/clothing/glasses/sunglasses/sechud/aviator/prescription
	name = "prescription security HUD aviators"
	desc = "Modified aviator glasses that can be switch between HUD and flash protection modes. Comes with bonus prescription lenses."
	prescription = 6

/obj/item/clothing/glasses/sunglasses/medhud
	name = "\improper HUD sunglasses"
	desc = "Sunglasses with a HUD."
	icon_state = "sunMedHud"
	enables_planes = list(VIS_CH_STATUS,VIS_CH_HEALTH)

/obj/item/clothing/glasses/thermal
	name = "optical thermal scanner"
	desc = "Thermals in the shape of glasses."
	icon_state = "thermal"
	item_state_slots = list(slot_r_hand_str = "glasses", slot_l_hand_str = "glasses")
	origin_tech = list(TECH_MAGNET = 3)
	toggleable = 1
	actions_types = list(/datum/action/item_action/toggle_goggles)
	vision_flags = SEE_MOBS
	enables_planes = list(VIS_FULLBRIGHT, VIS_CLOAKED)
	flash_protection = FLASH_PROTECTION_REDUCED

/obj/item/clothing/glasses/thermal/emp_act(severity)
	if(ishuman(src.loc))
		var/mob/living/carbon/human/M = src.loc
		to_chat(M, span_red("The Optical Thermal Scanner overloads and blinds you!"))
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
	name = "optical meson scanner"
	desc = "Used for seeing walls, floors, and stuff through anything."
	icon_state = "meson"
	item_state_slots = list(slot_r_hand_str = "meson", slot_l_hand_str = "meson")
	origin_tech = list(TECH_MAGNET = 3, TECH_ILLEGAL = 4)

/obj/item/clothing/glasses/thermal/plain
	toggleable = 0
	activation_sound = null
	actions_types = list()

/obj/item/clothing/glasses/thermal/plain/monocle
	name = "thermonocle"
	desc = "A monocle thermal."
	icon_state = "thermoncle"
	item_state_slots = list(slot_r_hand_str = "sunglasses", slot_l_hand_str = "sunglasses")
	toggleable = 1
	actions_types = list(/datum/action/item_action/toggle_monocle)
	flags = null //doesn't protect eyes because it's a monocle, duh

	body_parts_covered = 0

/obj/item/clothing/glasses/thermal/plain/eyepatch
	name = "optical thermal eyepatch"
	desc = "An eyepatch with built-in thermal optics"
	icon_state = "eyepatch"
	item_state_slots = list(slot_r_hand_str = "blindfold", slot_l_hand_str = "blindfold")
	body_parts_covered = 0
	toggleable = 1
	actions_types = list(/datum/action/item_action/toggle_eyepatch)

/obj/item/clothing/glasses/thermal/plain/jensen
	name = "optical thermal implants"
	desc = "A set of implantable lenses designed to augment your vision"
	icon_state = "thermalimplants"
	item_state_slots = list(slot_r_hand_str = "sunglasses", slot_l_hand_str = "sunglasses")

/obj/item/clothing/glasses/aerogelgoggles
	name = "orange goggles"
	desc = "Teshari designed lightweight goggles."
	icon_state = "orange-g"
	item_state_slots = list(slot_r_hand_str = "glasses", slot_l_hand_str = "glasses")
	actions_types = list(/datum/action/item_action/adjust_orange_goggles)
	var/up = 0
	item_flags = AIRTIGHT
	body_parts_covered = EYES
	species_restricted = list(SPECIES_TESHARI)

/obj/item/clothing/glasses/aerogelgoggles/attack_self()
	toggle()

/obj/item/clothing/glasses/aerogelgoggles/verb/toggle()
	set category = "Object"
	set name = "Adjust Orange Goggles"
	set src in usr

	if(usr.canmove && !usr.stat && !usr.restrained())
		if(src.up)
			src.up = !src.up
			flags_inv |= HIDEEYES
			body_parts_covered |= EYES
			icon_state = initial(icon_state)
			to_chat(usr, "You flip \the [src] down to protect your eyes.")
		else
			src.up = !src.up
			flags_inv &= ~HIDEEYES
			body_parts_covered &= ~EYES
			icon_state = "[initial(icon_state)]up"
			to_chat(usr, "You push \the [src] up from in front of your eyes.")
		update_clothing_icon()
		usr.update_mob_action_buttons()
