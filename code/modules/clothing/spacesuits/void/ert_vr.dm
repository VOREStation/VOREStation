/obj/item/clothing/suit/space/void/responseteam
	name = "Mark VII Emergency Response Suit"
	desc = "Utilizing cutting edge tech from Hephaestus, the Mark VII is the latest and greatest in semi-powered personal protection systems; like the civilian AutoLok suit, the Mark VII can automatically adapt to fit most species without issue via RFID tags. This significantly reduces the time required for response teams to suit up, as it eliminates the need for dedicated cycler units. It also has an integrated, unremovable helmet. Standard air tanks, suit coolers, and magboots may be installed and removed as needed."
	icon_state = "ertsuit"
	item_state = "ertsuit"
	armor = list(melee = 60, bullet = 50, laser = 30,energy = 15, bomb = 30, bio = 100, rad = 100)
	slowdown = 0.5
	siemens_coefficient = 0.5
	species_restricted = list("exclude",SPECIES_DIONA,SPECIES_VOX,SPECIES_TESHARI,SPECIES_ALTEVIAN)	//this thing can autoadapt
	icon = 'icons/inventory/suit/item_vr.dmi'
	default_worn_icon = 'icons/inventory/suit/mob_vr.dmi'
	w_class = ITEMSIZE_NORMAL //the mark vii packs itself down when not in use, thanks future-materials
	breach_threshold = 16 //Extra Thicc
	resilience = 0.05 //Military Armor
	min_pressure_protection = 0 * ONE_ATMOSPHERE
	max_pressure_protection = 15* ONE_ATMOSPHERE
	max_heat_protection_temperature = SPACE_SUIT_MAX_HEAT_PROTECTION_TEMPERATURE+10000

/obj/item/clothing/suit/space/void/responseteam/command
	name = "Mark VII-C Emergency Response Team Commander Suit"

/obj/item/clothing/suit/space/void/responseteam/command/Initialize()
	..()
	attach_helmet(new /obj/item/clothing/head/helmet/space/void/responseteam/command) //autoinstall the helmet

/obj/item/clothing/suit/space/void/responseteam/medical
	name = "Mark VII-M Emergency Medical Response Suit"
	icon_state = "ertsuit_m"
	item_state = "ertsuit_m"

/obj/item/clothing/suit/space/void/responseteam/medical/Initialize()
	..()
	attach_helmet(new /obj/item/clothing/head/helmet/space/void/responseteam/medical) //autoinstall the helmet

/obj/item/clothing/suit/space/void/responseteam/engineer
	name = "Mark VII-E Emergency Engineering Response Suit"
	icon_state = "ertsuit_e"
	item_state = "ertsuit_e"

/obj/item/clothing/suit/space/void/responseteam/engineer/Initialize()
	..()
	attach_helmet(new /obj/item/clothing/head/helmet/space/void/responseteam/engineer) //autoinstall the helmet

/obj/item/clothing/suit/space/void/responseteam/security
	name = "Mark VII-S Emergency Security Response Suit"
	icon_state = "ertsuit_s"
	item_state = "ertsuit_s"

/obj/item/clothing/suit/space/void/responseteam/security/Initialize()
	..()
	attach_helmet(new /obj/item/clothing/head/helmet/space/void/responseteam/security) //autoinstall the helmet

/obj/item/clothing/suit/space/void/responseteam/janitor
	name = "Mark VII-J Emergency Cleanup Response Suit"
	icon_state = "ertsuit_j"
	item_state = "ertsuit_j"
	armor = list(melee = 30, bullet = 20, laser = 20, energy = 20, bomb = 20, bio = 100, rad = 100) //awful armor
	slowdown = 0 //light armor means no slowdown
	item_flags = NOSLIP //INBUILT NANOGALOSHES

/obj/item/clothing/suit/space/void/responseteam/janitor/Initialize()
	..()
	attach_helmet(new /obj/item/clothing/head/helmet/space/void/responseteam/janitor) //autoinstall the helmet


//override the attackby screwdriver proc so that people can't remove the helmet
/obj/item/clothing/suit/space/void/responseteam/attackby(obj/item/W as obj, mob/user as mob)

	if(!isliving(user))
		return

	if(istype(W, /obj/item/clothing/accessory) || istype(W, /obj/item/weapon/hand_labeler))
		return ..()

	if(user.get_inventory_slot(src) == slot_wear_suit)
		to_chat(user, "<span class='warning'>You cannot modify \the [src] while it is being worn.</span>")
		return

	if(W.is_screwdriver())
		if(boots || tank || cooler)
			var/choice = tgui_input_list(usr, "What component would you like to remove?", "Remove Component", list(boots,tank,cooler))
			if(!choice) return

			if(choice == tank)	//No, a switch doesn't work here. Sorry. ~Techhead
				to_chat(user, "You pop \the [tank] out of \the [src]'s storage compartment.")
				tank.forceMove(get_turf(src))
				playsound(src, W.usesound, 50, 1)
				src.tank = null
			else if(choice == cooler)
				to_chat(user, "You pop \the [cooler] out of \the [src]'s storage compartment.")
				cooler.forceMove(get_turf(src))
				playsound(src, W.usesound, 50, 1)
				src.cooler = null
			else if(choice == boots)
				to_chat(user, "You detach \the [boots] from \the [src]'s boot mounts.")
				boots.forceMove(get_turf(src))
				playsound(src, W.usesound, 50, 1)
				src.boots = null
		else
			to_chat(user, "\The [src] does not have anything installed.")
		return

	..()

/obj/item/clothing/head/helmet/space/void/responseteam
	name = "Mark VII Emergency Response Helmet"
	desc = "As a vital part of the Mark VII suit, the integral helmet cannot be removed - so don't try."
	icon_state = "erthelmet"
	item_state = "erthelmet"
	species_restricted = list("exclude",SPECIES_DIONA,SPECIES_VOX,SPECIES_TESHARI,SPECIES_ALTEVIAN)	//this thing can autoadapt too
	armor = list(melee = 60, bullet = 50, laser = 30,energy = 15, bomb = 30, bio = 100, rad = 100)
	siemens_coefficient = 0.5
	icon = 'icons/inventory/head/item_vr.dmi'
	default_worn_icon = 'icons/inventory/head/mob_vr.dmi'
	enables_planes = list(VIS_CH_ID,VIS_CH_HEALTH_VR,VIS_AUGMENTED)
	var/away_planes = null
	plane_slots = list(slot_head)
	var/hud_active = 1
	var/activation_sound = 'sound/items/nif_click.ogg'
	min_pressure_protection = 0 * ONE_ATMOSPHERE
	max_pressure_protection = 15* ONE_ATMOSPHERE
	max_heat_protection_temperature = SPACE_SUIT_MAX_HEAT_PROTECTION_TEMPERATURE+10000

/obj/item/clothing/head/helmet/space/void/responseteam/verb/toggle()
	set category = "Object"
	set name = "Toggle Mark 7 Suit HUD"
	set src in usr

	if(usr.canmove && !usr.stat && !usr.restrained())
		if(src.hud_active)
			away_planes = enables_planes
			enables_planes = null
			to_chat(usr, "You disable the inbuilt heads-up display.")
			hud_active = 0
		else
			enables_planes = away_planes
			away_planes = null
			to_chat(usr, "You enable the inbuilt heads-up display.")
			hud_active = 1
		usr << activation_sound
		usr.recalculate_vis()

/obj/item/clothing/head/helmet/space/void/responseteam/command
	name = "Mark VII-C Emergency Response Team Commander Helmet"
	enables_planes = list(VIS_CH_ID,VIS_CH_HEALTH_VR,VIS_CH_STATUS_R,VIS_CH_BACKUP,VIS_CH_WANTED,VIS_AUGMENTED)

/obj/item/clothing/head/helmet/space/void/responseteam/medical
	name = "Mark VII-M Emergency Medical Response Helmet"
	icon_state = "erthelmet_m"
	item_state = "erthelmet_m"
	enables_planes = list(VIS_CH_ID,VIS_CH_HEALTH_VR,VIS_CH_STATUS_R,VIS_CH_BACKUP,VIS_AUGMENTED)

/obj/item/clothing/head/helmet/space/void/responseteam/engineer
	name = "Mark VII-E Emergency Engineering Response Helmet"
	icon_state = "erthelmet_e"
	item_state = "erthelmet_e"

/obj/item/clothing/head/helmet/space/void/responseteam/security
	name = "Mark VII-S Emergency Security Response Helmet"
	icon_state = "erthelmet_s"
	item_state = "erthelmet_s"
	enables_planes = list(VIS_CH_ID,VIS_CH_HEALTH_VR,VIS_CH_WANTED,VIS_AUGMENTED)

/obj/item/clothing/head/helmet/space/void/responseteam/janitor
	name = "Mark VII-J Emergency Cleanup Response Helmet"
	icon_state = "erthelmet_j"
	item_state = "erthelmet_j"

/obj/item/clothing/suit/space/void/responseteam
	sprite_sheets = list(
		SPECIES_HUMAN			= 'icons/inventory/suit/mob_vr.dmi',
		SPECIES_TAJ 			= 'icons/inventory/suit/mob_vr_tajaran.dmi',
		SPECIES_SKRELL 			= 'icons/inventory/suit/mob_vr_skrell.dmi',
		SPECIES_UNATHI 			= 'icons/inventory/suit/mob_vr_unathi.dmi',
		SPECIES_XENOHYBRID 		= 'icons/inventory/suit/mob_vr_unathi.dmi',
		SPECIES_AKULA			= 'icons/inventory/suit/mob_vr_akula.dmi',
		SPECIES_SERGAL			= 'icons/inventory/suit/mob_vr_sergal.dmi',
		SPECIES_VULPKANIN		= 'icons/inventory/suit/mob_vr_vulpkanin.dmi',
		SPECIES_ZORREN_HIGH		= 'icons/inventory/suit/mob_vr_vulpkanin.dmi',
		SPECIES_FENNEC			= 'icons/inventory/suit/mob_vr_vulpkanin.dmi',
		SPECIES_SHADEKIN_CREW		= 'icons/inventory/suit/mob_vr_vulpkanin.dmi',
		SPECIES_VASILISSAN		= 'icons/inventory/suit/mob_vr.dmi',
		SPECIES_NEVREAN			= 'icons/inventory/suit/mob_vr.dmi',
		SPECIES_RAPALA			= 'icons/inventory/suit/mob_vr.dmi',
		SPECIES_ALRAUNE			= 'icons/inventory/suit/mob_vr.dmi',
		SPECIES_ZADDAT			= 'icons/inventory/suit/mob_vr.dmi'
		)
	sprite_sheets_obj = list(
		SPECIES_TAJ			= 'icons/inventory/suit/item_vr.dmi',
		SPECIES_SKRELL			= 'icons/inventory/suit/item_vr.dmi',
		SPECIES_UNATHI			= 'icons/inventory/suit/item_vr.dmi',
		SPECIES_XENOHYBRID		= 'icons/inventory/suit/item_vr.dmi',
		SPECIES_AKULA			= 'icons/inventory/suit/item_vr.dmi',
		SPECIES_SERGAL			= 'icons/inventory/suit/item_vr.dmi',
		SPECIES_VULPKANIN		= 'icons/inventory/suit/item_vr.dmi',
		SPECIES_ZORREN_HIGH		= 'icons/inventory/suit/item_vr.dmi',
		SPECIES_FENNEC			= 'icons/inventory/suit/item_vr.dmi',
		SPECIES_SHADEKIN_CREW		= 'icons/inventory/suit/item_vr.dmi',
		SPECIES_VASILISSAN		= 'icons/inventory/suit/item_vr.dmi',
		SPECIES_NEVREAN			= 'icons/inventory/suit/item_vr.dmi',
		SPECIES_RAPALA			= 'icons/inventory/suit/item_vr.dmi',
		SPECIES_ALRAUNE			= 'icons/inventory/suit/item_vr.dmi',
		SPECIES_ZADDAT			= 'icons/inventory/suit/item_vr.dmi'
		)

/obj/item/clothing/head/helmet/space/void/responseteam
	sprite_sheets = list(
		SPECIES_HUMAN			= 'icons/inventory/head/mob_vr.dmi',
		SPECIES_TAJ 			= 'icons/inventory/head/mob_vr_tajaran.dmi',
		SPECIES_SKRELL 			= 'icons/inventory/head/mob_vr_skrell.dmi',
		SPECIES_UNATHI 			= 'icons/inventory/head/mob_vr_unathi.dmi',
		SPECIES_XENOHYBRID 		= 'icons/inventory/head/mob_vr_unathi.dmi',
		SPECIES_AKULA			= 'icons/inventory/head/mob_vr_unathi.dmi',
		SPECIES_SERGAL			= 'icons/inventory/head/mob_vr_unathi.dmi',
		SPECIES_VULPKANIN		= 'icons/inventory/head/mob_vr_vulpkanin.dmi',
		SPECIES_ZORREN_HIGH		= 'icons/inventory/head/mob_vr_vulpkanin.dmi',
		SPECIES_FENNEC			= 'icons/inventory/head/mob_vr_vulpkanin.dmi',
		SPECIES_SHADEKIN_CREW		= 'icons/inventory/head/mob_vr_vulpkanin.dmi',
		SPECIES_VASILISSAN		= 'icons/inventory/head/mob_vr.dmi',
		SPECIES_NEVREAN			= 'icons/inventory/head/mob_vr.dmi',
		SPECIES_RAPALA			= 'icons/inventory/head/mob_vr.dmi',
		SPECIES_ALRAUNE			= 'icons/inventory/head/mob_vr.dmi',
		SPECIES_ZADDAT			= 'icons/inventory/head/mob_vr.dmi'
		)
	sprite_sheets_obj = list(
		SPECIES_TAJ 			= 'icons/inventory/head/item_vr.dmi',
		SPECIES_SKRELL			= 'icons/inventory/head/item_vr.dmi',
		SPECIES_UNATHI			= 'icons/inventory/head/item_vr.dmi',
		SPECIES_XENOHYBRID		= 'icons/inventory/head/item_vr.dmi',
		SPECIES_AKULA			= 'icons/inventory/head/item_vr.dmi',
		SPECIES_SERGAL			= 'icons/inventory/head/item_vr.dmi',
		SPECIES_VULPKANIN		= 'icons/inventory/head/item_vr.dmi',
		SPECIES_ZORREN_HIGH		= 'icons/inventory/head/item_vr.dmi',
		SPECIES_FENNEC			= 'icons/inventory/head/item_vr.dmi',
		SPECIES_SHADEKIN_CREW		= 'icons/inventory/head/item_vr.dmi',
		SPECIES_VASILISSAN		= 'icons/inventory/head/item_vr.dmi',
		SPECIES_NEVREAN			= 'icons/inventory/head/item_vr.dmi',
		SPECIES_RAPALA			= 'icons/inventory/head/item_vr.dmi',
		SPECIES_ALRAUNE			= 'icons/inventory/head/item_vr.dmi',
		SPECIES_ZADDAT			= 'icons/inventory/head/item_vr.dmi'
		)
