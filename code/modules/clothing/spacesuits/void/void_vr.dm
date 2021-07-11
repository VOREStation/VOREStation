//
// Because of our custom change in update_icons, we cannot rely upon the normal
// method of switching sprites when refitting (which is to have the referitter
// set the value of icon_override).  Therefore we use the sprite sheets method
// instead.
//

/obj/item/clothing/head/helmet/space/void
	species_restricted = list(SPECIES_HUMAN, SPECIES_RAPALA, SPECIES_VASILISSAN, SPECIES_ALRAUNE, SPECIES_PROMETHEAN, SPECIES_XENOCHIMERA)
	sprite_sheets = list(
		SPECIES_TAJ 				= 'icons/inventory/head/mob_tajaran.dmi',
		SPECIES_SKRELL 				= 'icons/inventory/head/mob_skrell.dmi',
		SPECIES_UNATHI 				= 'icons/inventory/head/mob_unathi.dmi',
		SPECIES_TESHARI				= 'icons/inventory/head/mob_teshari.dmi',
		SPECIES_XENOHYBRID 			= 'icons/inventory/head/mob_unathi.dmi',
		SPECIES_AKULA				= 'icons/inventory/head/mob_akula.dmi',
		SPECIES_SERGAL				= 'icons/inventory/head/mob_sergal.dmi',
		SPECIES_NEVREAN				= 'icons/inventory/head/mob_sergal.dmi',
		SPECIES_VULPKANIN			= 'icons/inventory/head/mob_vulpkanin.dmi',
		SPECIES_ZORREN_HIGH			= 'icons/inventory/head/mob_vulpkanin.dmi',
		SPECIES_FENNEC				= 'icons/inventory/head/mob_vulpkanin.dmi'
		)
	sprite_sheets_obj = list(
		SPECIES_TAJ 			= 'icons/inventory/head/item_tajaran.dmi',
		SPECIES_SKRELL			= 'icons/inventory/head/item_skrell.dmi',
		SPECIES_UNATHI			= 'icons/inventory/head/item_unathi.dmi',
		SPECIES_TESHARI			= 'icons/inventory/head/item_teshari.dmi',
		SPECIES_XENOHYBRID		= 'icons/inventory/head/item_unathi.dmi',
		SPECIES_AKULA			= 'icons/inventory/head/item_akula.dmi',
		SPECIES_SERGAL			= 'icons/inventory/head/item_sergal.dmi',
		SPECIES_NEVREAN			= 'icons/inventory/head/item_sergal.dmi',
		SPECIES_VULPKANIN		= 'icons/inventory/head/item_vulpkanin.dmi',
		SPECIES_ZORREN_HIGH		= 'icons/inventory/head/item_vulpkanin.dmi',
		SPECIES_FENNEC			= 'icons/inventory/head/item_vulpkanin.dmi'
		)

/obj/item/clothing/suit/space/void
	species_restricted = list(SPECIES_HUMAN, SPECIES_SKRELL, SPECIES_RAPALA, SPECIES_VASILISSAN, SPECIES_ALRAUNE, SPECIES_PROMETHEAN, SPECIES_XENOCHIMERA)
	sprite_sheets = list(
		SPECIES_TAJ 				= 'icons/inventory/suit/mob_tajaran.dmi',
		SPECIES_SKRELL 				= 'icons/inventory/suit/mob_skrell.dmi',
		SPECIES_UNATHI 				= 'icons/inventory/suit/mob_unathi.dmi',
		SPECIES_TESHARI				= 'icons/inventory/suit/mob_teshari.dmi',
		SPECIES_XENOHYBRID 			= 'icons/inventory/suit/mob_unathi.dmi',
		SPECIES_AKULA				= 'icons/inventory/suit/mob_akula.dmi',
		SPECIES_SERGAL				= 'icons/inventory/suit/mob_sergal.dmi',
		SPECIES_NEVREAN				= 'icons/inventory/suit/mob_sergal.dmi',
		SPECIES_VULPKANIN			= 'icons/inventory/suit/mob_vulpkanin.dmi',
		SPECIES_ZORREN_HIGH			= 'icons/inventory/suit/mob_vulpkanin.dmi',
		SPECIES_FENNEC				= 'icons/inventory/suit/mob_vulpkanin.dmi'
		)
	sprite_sheets_obj = list(
		SPECIES_TAJ			= 'icons/inventory/suit/item_tajaran.dmi',
		SPECIES_SKRELL			= 'icons/inventory/suit/item_skrell.dmi',
		SPECIES_UNATHI			= 'icons/inventory/suit/item_unathi.dmi',
		SPECIES_TESHARI			= 'icons/inventory/suit/item_teshari.dmi',
		SPECIES_XENOHYBRID		= 'icons/inventory/suit/item_unathi.dmi',
		SPECIES_AKULA			= 'icons/inventory/suit/item_akula.dmi',
		SPECIES_SERGAL			= 'icons/inventory/suit/item_sergal.dmi',
		SPECIES_NEVREAN			= 'icons/inventory/suit/item_sergal.dmi',
		SPECIES_VULPKANIN		= 'icons/inventory/suit/item_vulpkanin.dmi',
		SPECIES_ZORREN_HIGH		= 'icons/inventory/suit/item_vulpkanin.dmi',
		SPECIES_FENNEC			= 'icons/inventory/suit/item_vulpkanin.dmi'
		)

	// This is a hack to prevent the item_state variable on the suits from taking effect
	// when the item is equipped in outer clothing slot.
	// This variable is normally used to set the icon_override when the suit is refitted,
	// however the species spritesheet now means we no longer need that anyway!
	sprite_sheets_refit = list()

/obj/item/clothing/head/helmet/space/void/heck
	name = "\improper H.E.C.K. helmet"
	desc = "Hostile Environiment Cross-Kinetic Helmet: A helmet designed to withstand the wide variety of hazards from \[REDACTED\]. It wasn't enough for its last owner."
	icon_state = "hostile_env"
	item_state = "hostile_env"
	icon = 'icons/inventory/head/item_vr.dmi'
	icon_override = 'icons/inventory/head/mob_vr.dmi'
	armor = list(melee = 60, bullet = 35, laser = 35, energy = 15, bomb = 55, bio = 100, rad = 20)

/obj/item/clothing/head/helmet/space/void/heck/Initialize()
	. = ..()
	var/mutable_appearance/glass_overlay = mutable_appearance(icon, "hostile_env_glass")
	glass_overlay.appearance_flags = RESET_COLOR
	add_overlay(glass_overlay)

/obj/item/clothing/head/helmet/space/void/heck/apply_accessories(var/image/standing)
	. = ..()
	var/mutable_appearance/glass_overlay = mutable_appearance(icon_override, "hostile_env_glass")
	glass_overlay.appearance_flags = KEEP_APART|RESET_COLOR
	standing.add_overlay(glass_overlay)
	return standing

/obj/item/clothing/suit/space/void/heck
	name = "\improper H.E.C.K. suit"
	desc = "Hostile Environment Cross-Kinetic Suit: A suit designed to withstand the wide variety of hazards from \[REDACTED\]. It wasn't enough for its last owner."
	icon_state = "hostile_env"
	item_state = "hostile_env"
	icon = 'icons/inventory/suit/item_vr.dmi'
	icon_override = 'icons/inventory/suit/mob_vr.dmi'
	slowdown = 1.5
	armor = list(melee = 60, bullet = 35, laser = 35, energy = 15, bomb = 55, bio = 100, rad = 20)

/obj/item/clothing/head/helmet/space/void/syndicate_contract
	name = "syndicate contract helmet"
	desc = "A free helmet, gifted you by your new not-quite-corporate master!"
	icon_state = "syndicate-contract"
	item_state = "syndicate-contract"
	icon = 'icons/inventory/head/item_vr.dmi'
	icon_override = 'icons/inventory/head/mob_vr.dmi'
	armor = list(melee = 60, bullet = 50, laser = 30,energy = 15, bomb = 35, bio = 100, rad = 60)
	siemens_coefficient = 0.6
	camera_networks = list(NETWORK_MERCENARY)

/obj/item/clothing/suit/space/void/syndicate_contract
	name = "syndicate contract suit"
	desc = "A free suit, gifted you by your new not-quite-corporate master!"
	icon_state = "syndicate-contract"
	item_state = "syndicate-contract"
	icon = 'icons/inventory/suit/item_vr.dmi'
	icon_override = 'icons/inventory/suit/mob_vr.dmi'
	armor = list(melee = 60, bullet = 50, laser = 30,energy = 15, bomb = 35, bio = 100, rad = 60)
	siemens_coefficient = 0.6

/obj/item/clothing/head/helmet/space/void/chrono
	name = "chrono-helmet"
	desc = "From out of space and time, this helmet will protect you while you perform your duties."
	icon_state = "chronohelmet"
	item_state = "chronohelmet"
	icon = 'icons/inventory/head/item_vr.dmi'
	icon_override = 'icons/inventory/head/mob_vr.dmi'

/obj/item/clothing/suit/space/void/chrono
	name = "chrono-suit"
	desc = "From out of space and time, this helmet will protect you while you perform your duties."
	icon_state = "chronosuit"
	item_state = "chronosuit"
	icon = 'icons/inventory/suit/item_vr.dmi'
	icon_override = 'icons/inventory/suit/mob_vr.dmi'

/obj/item/clothing/suit/space/void/autolok
	name = "AutoLok pressure suit"
	desc = "A high-tech snug-fitting pressure suit. Fits any species. It offers very little physical protection, but is equipped with sensors that will automatically deploy the integral helmet to protect the wearer."
	icon = 'icons/inventory/suit/item_vr.dmi'
	icon_state = "autoloksuit"
	item_state = "autoloksuit"
	item_state_slots = list(slot_r_hand_str = "space_suit_syndicate", slot_l_hand_str = "space_suit_syndicate")
	armor = list(melee = 15, bullet = 5, laser = 5,energy = 5, bomb = 5, bio = 100, rad = 80)
	slowdown = 0.5
	siemens_coefficient = 1
	species_restricted = list("exclude",SPECIES_DIONA,SPECIES_VOX)	//this thing can autoadapt
	breach_threshold = 6 //this thing is basically tissue paper
	w_class = ITEMSIZE_NORMAL //if it's snug, high-tech, and made of relatively soft materials, it should be much easier to store!
	default_worn_icon = 'icons/inventory/suit/mob_vr.dmi'

/obj/item/clothing/suit/space/void/autolok
	sprite_sheets = list(
		SPECIES_HUMAN			= 'icons/inventory/suit/mob_vr.dmi',
		SPECIES_TAJ 			= 'icons/inventory/suit/mob_vr_tajaran.dmi',
		SPECIES_SKRELL 			= 'icons/inventory/suit/mob_vr_skrell.dmi',
		SPECIES_UNATHI 			= 'icons/inventory/suit/mob_vr_unathi.dmi',
		SPECIES_XENOHYBRID 		= 'icons/inventory/suit/mob_vr_unathi.dmi',
		SPECIES_AKULA			= 'icons/inventory/suit/mob_vr_unathi.dmi',
		SPECIES_SERGAL			= 'icons/inventory/suit/mob_vr_unathi.dmi',
		SPECIES_VULPKANIN		= 'icons/inventory/suit/mob_vr_vulpkanin.dmi',
		SPECIES_ZORREN_HIGH		= 'icons/inventory/suit/mob_vr_vulpkanin.dmi',
		SPECIES_FENNEC			= 'icons/inventory/suit/mob_vr_vulpkanin.dmi',
		SPECIES_TESHARI			= 'icons/inventory/suit/mob_vr_teshari.dmi'
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
		SPECIES_TESHARI			= 'icons/inventory/suit/item_vr.dmi'
		)

/obj/item/clothing/suit/space/void/autolok/Initialize()
	. = ..()
	helmet = new /obj/item/clothing/head/helmet/space/void/autolok //autoinstall the helmet

//override the attackby screwdriver proc so that people can't remove the helmet
/obj/item/clothing/suit/space/void/autolok/attackby(obj/item/W as obj, mob/user as mob)

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

/obj/item/clothing/head/helmet/space/void/autolok
	name = "AutoLok pressure helmet"
	desc = "A rather close-fitting helmet designed to protect the wearer from hazardous conditions. Automatically deploys when the suit's sensors detect an environment that is hazardous to the wearer."
	icon = 'icons/inventory/head/item_vr.dmi'
	icon_state = "autolokhelmet"
	item_state = "autolokhelmet"
	species_restricted = list("exclude",SPECIES_DIONA,SPECIES_VOX)	//this thing can autoadapt too
	flags_inv = HIDEEARS|BLOCKHAIR //removed HIDEFACE/MASK/EYES flags so sunglasses or facemasks don't disappear. still gotta have BLOCKHAIR or it'll clip out tho.
	default_worn_icon = 'icons/inventory/head/mob_vr.dmi'

/obj/item/clothing/head/helmet/space/void/autolok
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
		SPECIES_TESHARI			= 'icons/inventory/head/mob_vr_teshari.dmi'
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
		SPECIES_TESHARI			= 'icons/inventory/head/item_vr.dmi'
		)
	sprite_sheets_refit = list()	//have to nullify this as well just to be thorough