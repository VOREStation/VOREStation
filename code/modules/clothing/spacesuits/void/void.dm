//NASA Voidsuit
/obj/item/clothing/head/helmet/space/void
	name = "void helmet"
	desc = "A high-tech dark red space suit helmet. Used for AI satellite maintenance."
	icon_state = "void"
	item_state_slots = list(slot_r_hand_str = "syndicate", slot_l_hand_str = "syndicate")
	armor = list(melee = 30, bullet = 5, laser = 20,energy = 5, bomb = 35, bio = 100, rad = 20)
	max_heat_protection_temperature = SPACE_SUIT_MAX_HEAT_PROTECTION_TEMPERATURE
	min_pressure_protection = 0 * ONE_ATMOSPHERE
	max_pressure_protection = 10 * ONE_ATMOSPHERE

//	flags_inv = HIDEEARS|BLOCKHAIR

	//Species-specific stuff.
	species_restricted = list("Human", "Promethean")
	sprite_sheets = VR_SPECIES_SPRITE_SHEETS_HEAD_MOB
	sprite_sheets_obj = VR_SPECIES_SPRITE_SHEETS_HEAD_ITEM

	light_overlay = "helmet_light"
	var/no_cycle = FALSE	//stop this item from being put in a cycler

/obj/item/clothing/suit/space/void
	name = "voidsuit"
	icon_state = "void"
	item_state_slots = list(slot_r_hand_str = "space_suit_syndicate", slot_l_hand_str = "space_suit_syndicate")
	desc = "A high-tech dark red space suit. Used for AI satellite maintenance."
	slowdown = 0.5
	armor = list(melee = 30, bullet = 5, laser = 20,energy = 5, bomb = 35, bio = 100, rad = 20)
	allowed = list(POCKET_GENERIC, POCKET_ALL_TANKS, POCKET_SUIT_REGULATORS)
	max_heat_protection_temperature = SPACE_SUIT_MAX_HEAT_PROTECTION_TEMPERATURE
	min_pressure_protection = 0 * ONE_ATMOSPHERE
	max_pressure_protection = 10 * ONE_ATMOSPHERE
	special_hood_handling = TRUE
	actions_types = list(/datum/action/item_action/toggle_helmet)
	species_restricted = list("Human", SPECIES_SKRELL, "Promethean")
	sprite_sheets = VR_SPECIES_SPRITE_SHEETS_SUIT_MOB
	sprite_sheets_obj = VR_SPECIES_SPRITE_SHEETS_SUIT_ITEM

	//Breach thresholds, should ideally be inherited by most (if not all) voidsuits.
	//With 0.2 resiliance, will reach 10 breach damage after 3 laser carbine blasts or 8 smg hits.
	breach_threshold = 12
	can_breach = 1

	//Inbuilt devices.
	var/obj/item/clothing/shoes/magboots/boots = null // Deployable boots, if any.
	hood = null   // Deployable helmet, if any.
	var/obj/item/tank/tank = null              // Deployable tank, if any.
	var/obj/item/suit_cooling_unit/cooler = null// Cooling unit, for FBPs.  Cannot be installed alongside a tank.

	//Cycler settings
	var/no_cycle = FALSE	//stop this item from being put in a cycler

//Does it spawn with any Inbuilt devices?
/obj/item/clothing/suit/space/void/Initialize(mapload)
	. = ..()
	if(boots && ispath(boots))
		boots = new boots(src)
	if(hood && ispath(hood))
		hood = new hood(src)
	if(tank && ispath(tank))
		tank = new tank(src)

/obj/item/clothing/suit/space/void/examine(mob/user)
	. = ..()
	. += to_chat(user, span_notice("Alt-click to relase Tank/Cooling unit if installed."))
	for(var/obj/item/I in list(hood,boots,tank,cooler))
		. += "It has \a [I] installed."
	if(tank && in_range(src,user))
		. += span_notice("The wrist-mounted pressure gauge reads [max(round(tank.air_contents.return_pressure()),0)] kPa remaining in \the [tank].")

/obj/item/clothing/suit/space/void/refit_for_species(var/target_species)
	..()
	if(istype(hood))
		hood.refit_for_species(target_species)
	if(istype(boots))
		boots.refit_for_species(target_species)

/obj/item/clothing/suit/space/void/equipped(mob/M)
	..()

	var/mob/living/carbon/human/H = M

	if(!istype(H)) return

	if(H.wear_suit != src)
		return

	if(boots)
		if (H.equip_to_slot_if_possible(boots, slot_shoes))
			boots.canremove = FALSE

	if(hood)
		if(H.head)
			to_chat(M, "You are unable to deploy your suit's helmet as \the [H.head] is in the way.")
		else if (H.equip_to_slot_if_possible(hood, slot_head))
			to_chat(M, "Your suit's helmet deploys with a hiss.")
			hood.canremove = FALSE

	if(cooler)
		if(H.s_store) //Ditto
			to_chat(M, "Alarmingly, the cooling unit installed into your suit fails to deploy.")
		else if (H.equip_to_slot_if_possible(cooler, slot_s_store))
			to_chat(M, "Your suit's cooling unit deploys.")
			cooler.canremove = FALSE

/obj/item/clothing/suit/space/void/dropped(mob/user)
	..()

	var/mob/living/carbon/human/H

	if(hood)
		hood.canremove = TRUE
		H = hood.loc
		if(istype(H))
			if(hood && H.head == hood)
				H.drop_from_inventory(hood)
				hood.forceMove(src)

	if(boots)
		boots.canremove = TRUE
		H = boots.loc
		if(istype(H))
			if(boots && H.shoes == boots)
				H.drop_from_inventory(boots)
				boots.forceMove(src)

	if(tank)
		tank.canremove = TRUE
		tank.forceMove(src)

	if(cooler)
		cooler.canremove = TRUE
		cooler.forceMove(src)

/obj/item/clothing/suit/space/void/proc/attach_helmet(var/obj/item/clothing/head/helmet/space/void/helm)
	if(!istype(helm) || hood)
		return

	helm.forceMove(src)
	helm.set_light_flags(helm.light_flags | LIGHT_ATTACHED)
	hood = helm

/obj/item/clothing/suit/space/void/proc/remove_helmet()
	if(!hood)
		return

	hood.forceMove(get_turf(src))
	hood.set_light_flags(hood.light_flags & ~LIGHT_ATTACHED)
	hood = null

/obj/item/clothing/suit/space/void/ui_action_click(mob/living/user, action_name)
	if(..())
		return TRUE
	toggle_helmet()

/obj/item/clothing/suit/space/void/verb/toggle_helmet()
	set name = "Toggle Helmet"
	set category = "Object"
	set src in usr

	if(!isliving(loc))
		return

	if(!hood)
		to_chat(usr, "There is no helmet installed.")
		return

	var/mob/living/carbon/human/H = usr

	if(!istype(H)) return
	if(H.stat) return
	if(H.wear_suit != src) return

	if(hood.light_on)
		to_chat(H, span_notice("The helmet light shuts off as it retracts."))
		hood.update_flashlight(H)

	if(H.head == hood)
		to_chat(H, span_notice("You retract your suit helmet."))
		hood.canremove = TRUE
		H.drop_from_inventory(hood)
		hood.forceMove(src)
		playsound(src.loc, 'sound/machines/click2.ogg', 75, 1)
	else
		if(H.head)
			to_chat(H, span_danger("You cannot deploy your helmet while wearing \the [H.head]."))
			return
		if(H.equip_to_slot_if_possible(hood, slot_head))
			hood.canremove = FALSE
			to_chat(H, span_info("You deploy your suit helmet, sealing you off from the world."))
			playsound(src.loc, 'sound/machines/click2.ogg', 75, 1)

/obj/item/clothing/suit/space/void/AltClick(mob/living/user)
	eject_tank()

/obj/item/clothing/suit/space/void/verb/eject_tank()
	set name = "Eject Voidsuit Tank/Cooler"
	set category = "Object"
	set src in usr

	if(!isliving(src.loc)) return

	var/mob/living/carbon/human/H = usr

	if(!tank && !cooler)
		to_chat(H, span_notice("There is no tank or cooling unit inserted."))
		return

	if(!istype(H)) return
	if(H.stat) return
	if(H.wear_suit != src) return

	var/obj/item/removing = null
	if(tank)
		removing = tank
		tank = null
	else
		removing = cooler
		cooler = null
	to_chat(H, span_danger("You press the emergency release, ejecting \the [removing] from your suit."))
	playsound(src.loc, 'sound/machines/click.ogg', 75, 1)
	removing.canremove = TRUE
	H.drop_from_inventory(removing)

/obj/item/clothing/suit/space/void/attackby(obj/item/W, mob/user)

	if(!isliving(user)) return

	if(istype(W,/obj/item/clothing/accessory) || istype(W, /obj/item/hand_labeler))
		return ..()

	if(user.get_inventory_slot(src) == slot_wear_suit)
		to_chat(user, span_warning("You cannot modify \the [src] while it is being worn."))
		return

	if(W.has_tool_quality(TOOL_SCREWDRIVER))
		if(hood || boots || tank)
			var/choice = tgui_input_list(user, "What component would you like to remove?", "Remove Component", list(hood,boots,tank,cooler))
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
			else if(choice == hood)
				to_chat(user, "You detach \the [hood] from \the [src]'s helmet mount.")
				remove_helmet()
				playsound(src, W.usesound, 50, 1)
			else if(choice == boots)
				to_chat(user, "You detach \the [boots] from \the [src]'s boot mounts.")
				boots.forceMove(get_turf(src))
				playsound(src, W.usesound, 50, 1)
				src.boots = null
		else
			to_chat(user, "\The [src] does not have anything installed.")
		return
	else if(istype(W,/obj/item/clothing/head/helmet/space))
		if(hood)
			to_chat(user, "\The [src] already has a helmet installed.")
		else
			to_chat(user, "You attach \the [W] to \the [src]'s helmet mount.")
			user.drop_item()
			attach_helmet(W)
		return
	else if(istype(W,/obj/item/clothing/shoes/magboots))
		if(boots)
			to_chat(user, "\The [src] already has magboots installed.")
		else
			to_chat(user, "You attach \the [W] to \the [src]'s boot mounts.")
			user.drop_item()
			W.forceMove(src)
			boots = W
		return
	else if(istype(W,/obj/item/tank))
		if(tank)
			to_chat(user, "\The [src] already has an airtank installed.")
		else if(cooler)
			to_chat(user, "\The [src]'s suit cooling unit is the modular suit storage.  Remove it first.")
		else
			to_chat(user, "You insert \the [W] into \the [src]'s storage compartment.")
			user.drop_item()
			W.forceMove(src)
			tank = W
		return
	else if(istype(W,/obj/item/suit_cooling_unit))
		if(cooler)
			to_chat(user, "\The [src] already has a suit cooling unit installed.")
		else if(tank)
			to_chat(user, "\The [src]'s airtank is in the modular suit storage.  Remove it first.")
		else
			to_chat(user, "You insert \the [W] into \the [src]'s storage compartment.")
			user.drop_item()
			W.forceMove(src)
			cooler = W
		return

	..()
