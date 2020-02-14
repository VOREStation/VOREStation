/obj/item/clothing/glasses/omnihud
	name = "\improper AR glasses"
	desc = "The KHI-62 AR Glasses are a design from Kitsuhana Heavy Industries. These are a cheap export version \
	for Nanotrasen. Probably not as complete as KHI could make them, but more readily available for NT."
	origin_tech = list(TECH_MAGNET = 3, TECH_BIO = 3)
	var/obj/item/clothing/glasses/hud/omni/hud = null
	var/mode = "civ"
	icon_state = "glasses"
	var/datum/nano_module/arscreen
	var/arscreen_path
	var/flash_prot = 0 //0 for none, 1 for flash weapon protection, 2 for welder protection
	enables_planes = list(VIS_CH_ID,VIS_CH_HEALTH_VR,VIS_AUGMENTED)
	plane_slots = list(slot_glasses)

/obj/item/clothing/glasses/omnihud/New()
	..()
	if(arscreen_path)
		arscreen = new arscreen_path(src)

/obj/item/clothing/glasses/omnihud/Destroy()
	QDEL_NULL(arscreen)
	. = ..()

/obj/item/clothing/glasses/omnihud/dropped()
	if(arscreen)
		SSnanoui.close_uis(src)
	..()

/obj/item/clothing/glasses/omnihud/emp_act(var/severity)
	var/disconnect_ar = arscreen
	arscreen = null
	spawn(20 SECONDS)
		arscreen = disconnect_ar
	..()

/obj/item/clothing/glasses/omnihud/proc/flashed()
	if(flash_prot && ishuman(loc))
		to_chat(loc, "<span class='warning'>Your [src.name] darken to try and protect your eyes!</span>")

/obj/item/clothing/glasses/omnihud/prescribe(var/mob/user)
	prescription = !prescription
	playsound(user,'sound/items/screwdriver.ogg', 50, 1)
	if(prescription)
		name = "[initial(name)] (pr)"
		user.visible_message("[user] uploads new prescription data to the [src.name].")
	else
		name = "[initial(name)]"
		user.visible_message("[user] deletes the prescription data on the [src.name].")

/obj/item/clothing/glasses/omnihud/attack_self(mob/user)
	if(!ishuman(user))
		return

	var/mob/living/carbon/human/H = user
	if(!H.glasses || !(H.glasses == src))
		to_chat(user, "<span class='warning'>You must be wearing the [src] to see the display.</span>")
	else
		if(!ar_interact(H))
			to_chat(user, "<span class='warning'>The [src] does not have any kind of special display.</span>")

/obj/item/clothing/glasses/omnihud/proc/ar_interact(var/mob/living/carbon/human/user)
	return 0 //The base models do nothing.

/obj/item/clothing/glasses/omnihud/prescription
	name = "AR glasses (pr)"
	prescription = 1

/obj/item/clothing/glasses/omnihud/med
	name = "\improper AR-M glasses"
	desc = "The KHI-62-M AR glasses are a design from Kitsuhana Heavy Industries. \
	These have been upgraded with medical records access and virus database integration."
	mode = "med"
	action_button_name = "AR Console (Crew Monitor)"
	arscreen_path = /datum/nano_module/crew_monitor
	enables_planes = list(VIS_CH_ID,VIS_CH_HEALTH_VR,VIS_CH_STATUS_R,VIS_CH_BACKUP,VIS_AUGMENTED)

	ar_interact(var/mob/living/carbon/human/user)
		if(arscreen)
			arscreen.ui_interact(user,"main",null,1,glasses_state)
		return 1

/obj/item/clothing/glasses/omnihud/sec
	name = "\improper AR-S glasses"
	desc = "The KHI-62-S AR glasses are a design from Kitsuhana Heavy Industries. \
	These have been upgraded with security records integration and flash protection."
	mode = "sec"
	flash_protection = FLASH_PROTECTION_MAJOR
	action_button_name = "AR Console (Security Alerts)"
	arscreen_path = /datum/nano_module/alarm_monitor/security
	enables_planes = list(VIS_CH_ID,VIS_CH_HEALTH_VR,VIS_CH_WANTED,VIS_AUGMENTED)

	ar_interact(var/mob/living/carbon/human/user)
		if(arscreen)
			arscreen.ui_interact(user,"main",null,1,glasses_state)
		return 1

/obj/item/clothing/glasses/omnihud/eng
	name = "\improper AR-E glasses"
	desc = "The KHI-62-E AR glasses are a design from Kitsuhana Heavy Industries. \
	These have been upgraded with advanced electrochromic lenses to protect your eyes during welding."
	mode = "eng"
	flash_protection = FLASH_PROTECTION_MAJOR
	action_button_name = "AR Console (Station Alerts)"
	arscreen_path = /datum/nano_module/alarm_monitor/engineering

	ar_interact(var/mob/living/carbon/human/user)
		if(arscreen)
			arscreen.ui_interact(user,"main",null,1,glasses_state)
		return 1

/obj/item/clothing/glasses/omnihud/rnd
	name = "\improper AR-R glasses"
	desc = "The KHI-62-R AR glasses are a design from Kitsuhana Heavy Industries. \
	These have been ... modified ... to fit into a different frame."
	mode = "sci"
	icon = 'icons/obj/clothing/glasses.dmi'
	icon_override = null
	icon_state = "purple"

/obj/item/clothing/glasses/omnihud/eng/meson
	name = "meson scanner HUD"
	desc = "A headset equipped with a scanning lens and mounted retinal projector. They don't provide any eye protection, but they're less obtrusive than goggles."
	icon = 'icons/vore/custom_items_vr.dmi'
	icon_override = 'icons/vore/custom_clothes_vr.dmi'
	icon_state = "projector"
	off_state = "projector-off"
	body_parts_covered = 0
	toggleable = 1
	vision_flags = SEE_TURFS //but they can spot breaches. Due to the way HUDs work, they don't provide darkvision up-close the way mesons do.

/obj/item/clothing/glasses/omnihud/eng/meson/attack_self(mob/user)
	if(!active)
		toggleprojector()
	..()

/obj/item/clothing/glasses/omnihud/eng/meson/verb/toggleprojector()
	set name = "Toggle projector"
	set category = "Object"
	set src in usr
	if(!istype(usr, /mob/living)) return
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
		usr.update_action_buttons()

/obj/item/clothing/glasses/omnihud/all
	name = "\improper AR-B glasses"
	desc = "The KHI-62-B AR glasses are a design from Kitsuhana Heavy Industries. \
	These have been upgraded with every feature the lesser models have. Now we're talkin'."
	mode = "best"
	flash_protection = FLASH_PROTECTION_MAJOR
	enables_planes = list(VIS_CH_ID,VIS_CH_HEALTH_VR,VIS_CH_STATUS_R,VIS_CH_BACKUP,VIS_CH_WANTED)

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
	if(!istype(usr, /mob/living)) return
	if(usr.stat) return

	eye = !eye
	if(eye)
		icon_state = "[icon_state]_1"
	else
		icon_state = initial(icon_state)
	update_clothing_icon()
