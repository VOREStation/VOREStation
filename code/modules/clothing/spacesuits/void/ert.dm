/obj/item/clothing/suit/space/void/responseteam
	name = "Mark VII Emergency Response Suit"
	desc = "Utilizing cutting edge tech from Hephaestus, the Mark VII is the latest and greatest in semi-powered personal protection systems; like the civilian AutoLok suit, the Mark VII can automatically adapt to fit most species without issue via RFID tags. This significantly reduces the time required for response teams to suit up, as it eliminates the need for dedicated cycler units. It also has an integrated, unremovable helmet. Standard air tanks, suit coolers, and magboots may be installed and removed as needed."
	icon_state = "ertsuit"
	item_state = "ertsuit"
	armor = list(melee = 60, bullet = 50, laser = 30,energy = 15, bomb = 30, bio = 100, rad = 100)
	slowdown = 1
	siemens_coefficient = 0.5
	species_restricted = list("exclude",SPECIES_DIONA,SPECIES_VOX,SPECIES_TESHARI)	//this thing can autoadapt
	icon = 'icons/obj/clothing/suits_vr.dmi'
	w_class = ITEMSIZE_NORMAL //the mark vii packs itself down when not in use, thanks future-materials

/obj/item/clothing/suit/space/void/responseteam/command
	name = "Mark VII-C Emergency Response Team Commander Suit"

/obj/item/clothing/suit/space/void/responseteam/command/Initialize()
	..()
	helmet = new /obj/item/clothing/head/helmet/space/void/responseteam/command //autoinstall the helmet

/obj/item/clothing/suit/space/void/responseteam/medical
	name = "Mark VII-M Emergency Medical Response Suit"
	icon_state = "ertsuit_m"
	item_state = "ertsuit_m"

/obj/item/clothing/suit/space/void/responseteam/medical/Initialize()
	..()
	helmet = new /obj/item/clothing/head/helmet/space/void/responseteam/medical //autoinstall the helmet

/obj/item/clothing/suit/space/void/responseteam/engineer
	name = "Mark VII-E Emergency Engineering Response Suit"
	icon_state = "ertsuit_e"
	item_state = "ertsuit_e"

/obj/item/clothing/suit/space/void/responseteam/engineer/Initialize()
	..()
	helmet = new /obj/item/clothing/head/helmet/space/void/responseteam/engineer //autoinstall the helmet

/obj/item/clothing/suit/space/void/responseteam/security
	name = "Mark VII-S Emergency Security Response Suit"
	icon_state = "ertsuit_s"
	item_state = "ertsuit_s"

/obj/item/clothing/suit/space/void/responseteam/security/Initialize()
	..()
	helmet = new /obj/item/clothing/head/helmet/space/void/responseteam/security //autoinstall the helmet

/obj/item/clothing/suit/space/void/responseteam/janitor
	name = "Mark VII-J Emergency Cleanup Response Suit"
	icon_state = "ertsuit_j"
	item_state = "ertsuit_j"
	armor = list(melee = 30, bullet = 20, laser = 20, energy = 20, bomb = 20, bio = 100, rad = 100) //awful armor
	slowdown = 0 //light armor means no slowdown
	item_flags = NOSLIP //INBUILT NANOGALOSHES

/obj/item/clothing/suit/space/void/responseteam/janitor/Initialize()
	..()
	helmet = new /obj/item/clothing/head/helmet/space/void/responseteam/janitor //autoinstall the helmet

/obj/item/clothing/suit/space/void/responseteam
	sprite_sheets = list(
		SPECIES_HUMAN			= 'icons/mob/spacesuit_vr.dmi',
		SPECIES_TAJ 			= 'icons/mob/species/tajaran/suit_vr.dmi',
		SPECIES_SKRELL 			= 'icons/mob/species/skrell/suit_vr.dmi',
		SPECIES_UNATHI 			= 'icons/mob/species/unathi/suit_vr.dmi',
		SPECIES_XENOHYBRID 		= 'icons/mob/species/unathi/suit_vr.dmi',
		SPECIES_AKULA			= 'icons/mob/species/akula/suit_vr.dmi',
		SPECIES_SERGAL			= 'icons/mob/species/sergal/suit_vr.dmi',
		SPECIES_VULPKANIN		= 'icons/mob/species/vulpkanin/suit_vr.dmi',
		SPECIES_ZORREN_HIGH		= 'icons/mob/species/vulpkanin/suit_vr.dmi',
		SPECIES_FENNEC			= 'icons/mob/species/vulpkanin/suit_vr.dmi'
		)
	sprite_sheets_obj = list(
		SPECIES_TAJ			= 'icons/obj/clothing/suits_vr.dmi',
		SPECIES_SKRELL			= 'icons/obj/clothing/suits_vr.dmi',
		SPECIES_UNATHI			= 'icons/obj/clothing/suits_vr.dmi',
		SPECIES_XENOHYBRID		= 'icons/obj/clothing/suits_vr.dmi',
		SPECIES_AKULA			= 'icons/obj/clothing/suits_vr.dmi',
		SPECIES_SERGAL			= 'icons/obj/clothing/suits_vr.dmi',
		SPECIES_VULPKANIN		= 'icons/obj/clothing/suits_vr.dmi',
		SPECIES_ZORREN_HIGH		= 'icons/obj/clothing/suits_vr.dmi',
		SPECIES_FENNEC			= 'icons/obj/clothing/suits_vr.dmi'
		)


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
			var/choice = input("What component would you like to remove?") as null|anything in list(boots,tank,cooler)
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
	species_restricted = list("exclude",SPECIES_DIONA,SPECIES_VOX,SPECIES_TESHARI)	//this thing can autoadapt too
	armor = list(melee = 60, bullet = 50, laser = 30,energy = 15, bomb = 30, bio = 100, rad = 100)
	siemens_coefficient = 0.5
	icon = 'icons/obj/clothing/hats_vr.dmi'
	enables_planes = list(VIS_CH_ID,VIS_CH_HEALTH_VR,VIS_AUGMENTED)
	var/away_planes = null
	plane_slots = list(slot_head)
	var/hud_active = 1
	var/activation_sound = 'sound/items/nif_click.ogg'

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

/obj/item/clothing/head/helmet/space/void/responseteam
	sprite_sheets = list(
		SPECIES_HUMAN			= 'icons/mob/head_vr.dmi',
		SPECIES_TAJ 			= 'icons/mob/species/tajaran/helmet_vr.dmi',
		SPECIES_SKRELL 			= 'icons/mob/species/skrell/helmet_vr.dmi',
		SPECIES_UNATHI 			= 'icons/mob/species/unathi/helmet_vr.dmi',
		SPECIES_XENOHYBRID 		= 'icons/mob/species/unathi/helmet_vr.dmi',
		SPECIES_AKULA			= 'icons/mob/species/unathi/helmet_vr.dmi',
		SPECIES_SERGAL			= 'icons/mob/species/unathi/helmet_vr.dmi',
		SPECIES_VULPKANIN		= 'icons/mob/species/vulpkanin/helmet_vr.dmi',
		SPECIES_ZORREN_HIGH		= 'icons/mob/species/vulpkanin/helmet_vr.dmi',
		SPECIES_FENNEC			= 'icons/mob/species/vulpkanin/helmet_vr.dmi'
		)
	sprite_sheets_obj = list(
		SPECIES_TAJ 			= 'icons/obj/clothing/hats_vr.dmi',
		SPECIES_SKRELL			= 'icons/obj/clothing/hats_vr.dmi',
		SPECIES_UNATHI			= 'icons/obj/clothing/hats_vr.dmi',
		SPECIES_XENOHYBRID		= 'icons/obj/clothing/hats_vr.dmi',
		SPECIES_AKULA			= 'icons/obj/clothing/hats_vr.dmi',
		SPECIES_SERGAL			= 'icons/obj/clothing/hats_vr.dmi',
		SPECIES_VULPKANIN		= 'icons/obj/clothing/hats_vr.dmi',
		SPECIES_ZORREN_HIGH		= 'icons/obj/clothing/hats_vr.dmi',
		SPECIES_FENNEC			= 'icons/obj/clothing/hats_vr.dmi'
		)
	sprite_sheets_refit = list()	//have to nullify this as well just to be thorough