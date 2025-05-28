/obj/item/clothing/glasses/omnihud
	name = "\improper AR glasses"
	desc = "The ARG-62 AR Glasses are capable of displaying information on individuals. \
	Commonly used to allow non-augmented crew to interact with virtual interfaces. \
	<br>They are also fitted with toggleable cosmetic electrochromic lenses. \
	The lenses will not protect against sudden bright flashes or welding."
	origin_tech = list(TECH_MAGNET = 3, TECH_BIO = 3)
	var/obj/item/clothing/glasses/hud/omni/hud = null
	var/mode = "civ"
	icon_state = "glasses"
	var/datum/tgui_module/tgarscreen
	var/tgarscreen_path
	var/flash_prot = 0 //0 for none, 1 for flash weapon protection, 2 for welder protection
	enables_planes = list(VIS_CH_ID,VIS_CH_HEALTH_VR,VIS_AUGMENTED)
	plane_slots = list(slot_glasses)
	var/ar_toggled = TRUE //Used for toggle_ar_planes() verb


/obj/item/clothing/glasses/omnihud/Initialize(mapload)
	. = ..()
	if(tgarscreen_path)
		tgarscreen = new tgarscreen_path(src)

/obj/item/clothing/glasses/omnihud/Destroy()
	QDEL_NULL(tgarscreen)
	. = ..()

/obj/item/clothing/glasses/omnihud/dropped(mob/user)
	if(tgarscreen)
		SStgui.close_uis(src)
	..()

/obj/item/clothing/glasses/omnihud/examine()
	. = ..()
	if(ar_toggled)
		. += "\n " + span_notice("The HUD indicator reads ON.")
	else
		. += "\n " + span_notice("The HUD indicator reads OFF.")


/obj/item/clothing/glasses/omnihud/emp_act(var/severity)
	if(tgarscreen)
		SStgui.close_uis(src)
	var/disconnect_tgar = tgarscreen
	tgarscreen = null
	spawn(20 SECONDS)
		tgarscreen = disconnect_tgar

	//extra fun for non-sci variants; a small chance flip the state to the dumb 3d glasses when EMP'd
	if(icon_state == "glasses" || icon_state == "sun")
		if(prob(10))
			icon_state = "3d"
			if(ishuman(loc))
				to_chat(loc, span_warning("The lenses of your [src.name] malfunction!"))
	..()

/obj/item/clothing/glasses/omnihud/proc/flashed()
	if(flash_prot && ishuman(loc))
		to_chat(loc, span_warning("Your [src.name] darken to try and protect your eyes!"))

/obj/item/clothing/glasses/omnihud/prescribe(var/mob/user)
	prescription = !prescription
	playsound(src,'sound/items/screwdriver.ogg', 50, 1)
	if(prescription)
		user.visible_message("[user] uploads new prescription data to the [src.name] and resets the lenses.")
		name = "[initial(name)] (pr)" //change the name *after* the text so the message above is accurate
		icon_state = "[initial(icon_state)]" //reset the icon state just to be safe
	else
		user.visible_message("[user] deletes the prescription data on the [src.name] and resets the lenses.")
		name = "[initial(name)]"
		icon_state = "[initial(icon_state)]"

/obj/item/clothing/glasses/omnihud/attack_self(mob/user)
	if(!ishuman(user))
		return

	var/mob/living/carbon/human/H = user
	if(!H.glasses || !(H.glasses == src))
		to_chat(user, span_warning("You must be wearing the [src] to see the display."))
	else
		if(!ar_interact(H))
			to_chat(user, span_warning("The [src] does not have any kind of special display."))

//cosmetic shading, doesn't enhance eye protection
/obj/item/clothing/glasses/omnihud/verb/chromatize()
	set name = "Toggle AR Glasses Shading"
	set desc = "Toggle the cosmetic electrochromatic shading of your AR glasses."
	set category = "Object"
	set src in usr
	if(!usr.canmove || usr.stat || usr.restrained())
		return
	if(icon_state == "3d")
		to_chat(usr, "You reset the electrochromic lenses of \the [src] back to normal.")
		if(prescription)
			name = "[initial(name)] (pr)"
		else
			name = "[initial(name)]"
		icon_state = "[initial(icon_state)]"
	else if(prescription)
		if(icon_state == "glasses")
			to_chat(usr, "You darken the electrochromic lenses of \the [src] to one-way transparency.")
			name = "[initial(name)] (shaded, pr)"
			flags_inv |= HIDEEYES
			icon_state = "sun"
		else if(icon_state == "sun")
			to_chat(usr, "You restore the electrochromic lenses of \the [src] to standard two-way transparency.")
			name = "[initial(name)] (pr)"
			flags_inv &= ~HIDEEYES
			icon_state = "glasses"
		else
			to_chat(usr, "The [src] don't seem to support this functionality.")
	else if(!prescription)
		if(icon_state == "glasses")
			to_chat(usr, "You darken the electrochromic lenses of \the [src] to one-way transparency.")
			name = "[initial(name)] (shaded)"
			flags_inv |= HIDEEYES
			icon_state = "sun"
		else if(icon_state == "sun")
			to_chat(usr, "You restore the electrochromic lenses of \the [src] to standard two-way transparency.")
			name = "[initial(name)]"
			flags_inv &= ~HIDEEYES
			icon_state = "glasses"
		else
			to_chat(usr, "The [src] don't seem to support this functionality.")
	update_clothing_icon()

/obj/item/clothing/glasses/omnihud/verb/toggle_ar_planes()
	set name = "Toggle AR Heads-Up Display"
	set desc = "Toggles the job icon and other non-manually requested displays. Does not disable Crew monitor and similar."
	set category = "Object"
	set src in usr

	//We do not check if user can move or not, since this system is inspired to help see chat bubbles during scenes primarily.
	//Preventing turning off the HUD could get in the way of scene flow.
	if(ar_toggled)
		away_planes = enables_planes
		enables_planes = null
		to_chat(usr, span_notice("You disabled the Augmented Reality HUD of your [src.name]."))
	else
		enables_planes = away_planes
		away_planes = null
		to_chat(usr, span_notice("You enabled the Augmented Reality HUD of your [src.name]."))
	ar_toggled = !ar_toggled
	usr.update_mob_action_buttons()
	usr.recalculate_vis()



/obj/item/clothing/glasses/omnihud/proc/ar_interact(var/mob/living/carbon/human/user)
	return 0 //The base models do nothing.

/obj/item/clothing/glasses/omnihud/visor
	name = "AR visor"
	desc = "The VZR-AR are a product based upon the classic AR Glasses, just more fashionable."
	icon_override = 'icons/inventory/eyes/mob_vr.dmi'
	icon = 'icons/inventory/eyes/mob_vr.dmi'
	icon_state = "visor_CIV"
	item_state = "visor_CIV"

/obj/item/clothing/glasses/omnihud/prescription
	name = "AR glasses (pr)"
	prescription = 1

/obj/item/clothing/glasses/omnihud/med
	name = "\improper AR-M glasses"
	desc = "The ARG-62-M AR Glasses are capable of displaying information on individuals. \
	These have been upgraded with medical records access and virus database integration. \
	They can also read data from active suit sensors using the crew monitoring system."
	mode = "med"
	actions_types = list(/datum/action/item_action/ar_console_crew)
	tgarscreen_path = /datum/tgui_module/crew_monitor/glasses
	enables_planes = list(VIS_CH_ID,VIS_CH_HEALTH_VR,VIS_CH_STATUS_R,VIS_CH_BACKUP,VIS_AUGMENTED)

/obj/item/clothing/glasses/omnihud/med/ar_interact(var/mob/living/carbon/human/user)
	if(tgarscreen)
		tgarscreen.tgui_interact(user)
	return 1

/obj/item/clothing/glasses/omnihud/sec
	name = "\improper AR-S glasses"
	desc = "The ARG-62-S AR Glasses are capable of displaying information on individuals. \
	These have been upgraded with security records integration and flash protection. \
	They also have access to security alerts such as camera and motion sensor alarms."
	mode = "sec"
	flash_protection = FLASH_PROTECTION_MODERATE //weld protection is a little too widespread
	actions_types = list(/datum/action/item_action/ar_console_security_alerts)
	tgarscreen_path = /datum/tgui_module/alarm_monitor/security/glasses
	enables_planes = list(VIS_CH_ID,VIS_CH_HEALTH_VR,VIS_CH_WANTED,VIS_AUGMENTED)

/obj/item/clothing/glasses/omnihud/sec/ar_interact(var/mob/living/carbon/human/user)
	if(tgarscreen)
		tgarscreen.tgui_interact(user)
	return 1

/obj/item/clothing/glasses/omnihud/eng
	name = "\improper AR-E glasses"
	desc = "The ARG-62-E AR Glasses are capable of displaying information on individuals. \
	These have been upgraded with advanced electrochromic lenses to protect your eyes during welding, \
	and can also display a list of atmospheric, fire, and power alarms."
	mode = "eng"
	flash_protection = FLASH_PROTECTION_MAJOR
	actions_types = list(/datum/action/item_action/ar_console_station_alerts)
	tgarscreen_path = /datum/tgui_module/alarm_monitor/engineering/glasses

/obj/item/clothing/glasses/omnihud/eng/ar_interact(var/mob/living/carbon/human/user)
	if(tgarscreen)
		tgarscreen.tgui_interact(user)
	return 1

/obj/item/clothing/glasses/omnihud/rnd
	name = "\improper AR-R glasses"
	desc = "The ARG-62-R AR Glasses are capable of displaying information on individuals. \
	They... don't seem to do anything particularly interesting? But hey, at least they look kinda science-y."
	mode = "sci"

/obj/item/clothing/glasses/omnihud/eng/meson
	name = "meson scanner HUD"
	desc = "A headset equipped with a scanning lens and mounted retinal projector. It doesn't provide any eye protection, but it's less obtrusive than goggles."
	icon = 'icons/vore/custom_items_vr.dmi'
	icon_override = 'icons/vore/custom_clothes_vr.dmi'
	icon_state = "projector"
	off_state = "projector-off"
	body_parts_covered = 0
	toggleable = 1
	vision_flags = SEE_TURFS //but they can spot breaches. Due to the way HUDs work, they don't provide darkvision up-close the way mesons do.
	flash_protection = 0 //it's an open, single-eye retinal projector. there's no way it protects your eyes from flashes or welders.

/obj/item/clothing/glasses/omnihud/eng/meson/attack_self(mob/user)
	if(!active)
		toggleprojector()
	..()

/obj/item/clothing/glasses/omnihud/eng/meson/verb/toggleprojector()
	set name = "Toggle projector"
	set category = "Object"
	set src in usr
	if(!isliving(usr)) return
	if(usr.stat) return
	if(toggleable)
		if(active)
			active = 0
			icon_state = off_state
			item_state = "[initial(item_state)]-off"
			usr.update_inv_glasses()
			to_chat(usr, "You deactivate the retinal projector on the [src].")
		else
			active = 1
			icon_state = initial(icon_state)
			item_state = initial(item_state)
			usr.update_inv_glasses()
			to_chat(usr, "You activate the retinal projector on the [src].")
		usr.update_mob_action_buttons()

/obj/item/clothing/glasses/omnihud/all
	name = "\improper AR-B glasses"
	desc = "The ARG-62-B AR Glasses are capable of displaying information on individuals. \
	These have been upgraded with (almost) every feature the lesser models have. Now we're talkin'. \
	<br>Offers full protection against bright flashes/welders and full access to system alarm monitoring."
	mode = "best"
	flash_protection = FLASH_PROTECTION_MAJOR
	enables_planes = list(VIS_CH_ID,VIS_CH_HEALTH_VR,VIS_CH_STATUS_R,VIS_CH_BACKUP,VIS_CH_WANTED,VIS_AUGMENTED)
	actions_types = list(/datum/action/item_action/ar_console_all_alerts)
	tgarscreen_path = /datum/tgui_module/alarm_monitor/all/glasses

/obj/item/clothing/glasses/omnihud/all/ar_interact(var/mob/living/carbon/human/user)
	if(tgarscreen)
		tgarscreen.tgui_interact(user)
	return 1

/obj/item/clothing/glasses/hud/security/eyepatch
	name = "Security Hudpatch"
	desc = "An eyepatch with built in scanners, that analyzes those in view and provides accurate data about their ID status and security records."
	icon_state = "eyepatch"
	item_state_slots = list(slot_r_hand_str = "blindfold", slot_l_hand_str = "blindfold")
	body_parts_covered = 0
	enables_planes = list(VIS_CH_ID,VIS_CH_WANTED,VIS_CH_IMPTRACK,VIS_CH_IMPLOYAL,VIS_CH_IMPCHEM)
	var/eye = null

/obj/item/clothing/glasses/hud/security/eyepatch/verb/switcheye()
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

/obj/item/clothing/glasses/hud/security/eyepatch2
	name = "Security Hudpatch MKII"
	desc = "An eyepatch with built in scanners, that analyzes those in view and provides accurate data about their ID status and security records. This updated model offers better ergonomics and updated sensors."
	icon = 'icons/inventory/eyes/item_vr.dmi'
	icon_override = 'icons/inventory/eyes/mob_vr.dmi'
	icon_state = "sec_eyepatch"
	item_state_slots = list(slot_r_hand_str = "blindfold", slot_l_hand_str = "blindfold")
	body_parts_covered = 0
	enables_planes = list(VIS_CH_ID,VIS_CH_WANTED,VIS_CH_IMPTRACK,VIS_CH_IMPLOYAL,VIS_CH_IMPCHEM)
	var/eye = null

/obj/item/clothing/glasses/hud/security/eyepatch2/verb/switcheye()
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


/obj/item/clothing/glasses/hud/health/eyepatch
	name = "Medical Hudpatch"
	desc = "An eyepatch with built in scanners, that analyzes those in view and provides accurate data about their health status."
	icon_state = "eyepatch"
	item_state_slots = list(slot_r_hand_str = "blindfold", slot_l_hand_str = "blindfold")
	body_parts_covered = 0
	enables_planes =  list(VIS_CH_STATUS,VIS_CH_HEALTH)
	var/eye = null

/obj/item/clothing/glasses/hud/health/eyepatch/verb/switcheye()
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
