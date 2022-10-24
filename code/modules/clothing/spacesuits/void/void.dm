//NASA Voidsuit
/obj/item/clothing/head/helmet/space/void
	name = "void helmet"
	desc = "A high-tech dark red space suit helmet. Used for AI satellite maintenance."
	icon_state = "void"
	item_state_slots = list(slot_r_hand_str = "syndicate", slot_l_hand_str = "syndicate")
	heat_protection = HEAD
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|HIDEFACE|BLOCKHAIR
	armor = list(melee = 30, bullet = 5, laser = 20,energy = 5, bomb = 35, bio = 100, rad = 20)
	max_heat_protection_temperature = SPACE_SUIT_MAX_HEAT_PROTECTION_TEMPERATURE
	min_pressure_protection = 0 * ONE_ATMOSPHERE
	max_pressure_protection = 10 * ONE_ATMOSPHERE

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
	allowed = list(/obj/item/device/flashlight,/obj/item/weapon/tank,/obj/item/device/suit_cooling_unit)
	heat_protection = UPPER_TORSO|LOWER_TORSO|LEGS|FEET|ARMS|HANDS
	max_heat_protection_temperature = SPACE_SUIT_MAX_HEAT_PROTECTION_TEMPERATURE
	min_pressure_protection = 0 * ONE_ATMOSPHERE
	max_pressure_protection = 10 * ONE_ATMOSPHERE

	species_restricted = list("Human", SPECIES_SKRELL, "Promethean")
	sprite_sheets = VR_SPECIES_SPRITE_SHEETS_SUIT_MOB
	sprite_sheets_obj = VR_SPECIES_SPRITE_SHEETS_SUIT_ITEM

	//Breach thresholds, should ideally be inherited by most (if not all) voidsuits.
	//With 0.2 resiliance, will reach 10 breach damage after 3 laser carbine blasts or 8 smg hits.
	breach_threshold = 12
	can_breach = 1

	//Inbuilt devices.
	var/obj/item/clothing/shoes/magboots/boots = null // Deployable boots, if any.
	var/obj/item/clothing/head/helmet/helmet = null   // Deployable helmet, if any.
<<<<<<< HEAD
	var/obj/item/weapon/tank/tank = null              // Deployable tank, if any.
	var/obj/item/device/suit_cooling_unit/cooler = null// Cooling unit, for FBPs.  Cannot be installed alongside a tank.
	
=======
	var/obj/item/tank/tank = null              // Deployable tank, if any.
	var/obj/item/suit_cooling_unit/cooler = null// Cooling unit, for FBPs.  Cannot be installed alongside a tank.

>>>>>>> 07c02a713a4... Merge pull request #8780 from Cerebulon/new_basics_civilian
	//Cycler settings
	var/no_cycle = FALSE	//stop this item from being put in a cycler

/obj/item/clothing/suit/space/void/examine(user)
	. = ..()
	for(var/obj/item/I in list(helmet,boots,tank,cooler))
		. += "It has \a [I] installed."
	if(tank && in_range(src,user))
		. += "<span class='notice'>The wrist-mounted pressure gauge reads [max(round(tank.air_contents.return_pressure()),0)] kPa remaining in \the [tank].</span>"

/obj/item/clothing/suit/space/void/refit_for_species(var/target_species)
	..()
	if(istype(helmet))
		helmet.refit_for_species(target_species)
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

	if(helmet)
		if(H.head)
			to_chat(M, "You are unable to deploy your suit's helmet as \the [H.head] is in the way.")
		else if (H.equip_to_slot_if_possible(helmet, slot_head))
			to_chat(M, "Your suit's helmet deploys with a hiss.")
			helmet.canremove = FALSE

	if(tank)
		if(H.s_store) //In case someone finds a way.
			to_chat(M, "Alarmingly, the valve on your suit's installed tank fails to engage.")
		else if (H.equip_to_slot_if_possible(tank, slot_s_store))
			to_chat(M, "The valve on your suit's installed tank safely engages.")
			tank.canremove = FALSE

	if(cooler)
		if(H.s_store) //Ditto
			to_chat(M, "Alarmingly, the cooling unit installed into your suit fails to deploy.")
		else if (H.equip_to_slot_if_possible(cooler, slot_s_store))
			to_chat(M, "Your suit's cooling unit deploys.")
			cooler.canremove = FALSE

/obj/item/clothing/suit/space/void/dropped()
	..()

	var/mob/living/carbon/human/H

	if(helmet)
		helmet.canremove = TRUE
		H = helmet.loc
		if(istype(H))
			if(helmet && H.head == helmet)
				H.drop_from_inventory(helmet)
				helmet.forceMove(src)

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
	if(!istype(helm) || helmet)
		return

	helm.forceMove(src)
	helm.set_light_flags(helm.light_flags | LIGHT_ATTACHED)
	helmet = helm

/obj/item/clothing/suit/space/void/proc/remove_helmet()
	if(!helmet)
		return

	helmet.forceMove(get_turf(src))
	helmet.set_light_flags(helmet.light_flags & ~LIGHT_ATTACHED)
	helmet = null

/obj/item/clothing/suit/space/void/verb/toggle_helmet()

	set name = "Toggle Helmet"
	set category = "Object"
	set src in usr

	if(!istype(src.loc,/mob/living)) return

	if(!helmet)
		to_chat(usr, "There is no helmet installed.")
		return

	var/mob/living/carbon/human/H = usr

	if(!istype(H))
		return
	if(H.stat)
		return
	if(H.wear_suit != src)
		return

	if(H.head == helmet)
		to_chat(H, "<span class='notice'>You retract your suit helmet.</span>")
		helmet.canremove = TRUE
		H.drop_from_inventory(helmet)
		helmet.forceMove(src)
	else
		if(H.head)
			to_chat(H, "<span class='danger'>You cannot deploy your helmet while wearing \the [H.head].</span>")
			return
		if(H.equip_to_slot_if_possible(helmet, slot_head))
			helmet.pickup(H)
			helmet.canremove = FALSE
			to_chat(H, "<span class='info'>You deploy your suit helmet, sealing you off from the world.</span>")
	
	if(helmet.light_system == STATIC_LIGHT)
		helmet.update_light()

/obj/item/clothing/suit/space/void/verb/eject_tank()

	set name = "Eject Voidsuit Tank/Cooler"
	set category = "Object"
	set src in usr

	if(!istype(src.loc,/mob/living)) return

	if(!tank && !cooler)
		to_chat(usr, "There is no tank or cooling unit inserted.")
		return

	var/mob/living/carbon/human/H = usr

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
	to_chat(H, "<span class='info'>You press the emergency release, ejecting \the [removing] from your suit.</span>")
	removing.canremove = TRUE
	H.drop_from_inventory(removing)

/obj/item/clothing/suit/space/void/attackby(obj/item/W as obj, mob/user as mob)

	if(!istype(user,/mob/living)) return

	if(istype(W,/obj/item/clothing/accessory) || istype(W, /obj/item/weapon/hand_labeler))
		return ..()

	if(user.get_inventory_slot(src) == slot_wear_suit)
		to_chat(user, "<span class='warning'>You cannot modify \the [src] while it is being worn.</span>")
		return

	if(W.is_screwdriver())
		if(helmet || boots || tank)
			var/choice = tgui_input_list(usr, "What component would you like to remove?", "Remove Component", list(helmet,boots,tank,cooler))
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
			else if(choice == helmet)
				to_chat(user, "You detach \the [helmet] from \the [src]'s helmet mount.")
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
		if(helmet)
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
	else if(istype(W,/obj/item/weapon/tank))
		if(tank)
			to_chat(user, "\The [src] already has an airtank installed.")
		else if(cooler)
			to_chat(user, "\The [src]'s suit cooling unit is in the way.  Remove it first.")
		else if(istype(W,/obj/item/weapon/tank/phoron))
			to_chat(user, "\The [W] cannot be inserted into \the [src]'s storage compartment.")
		else
			to_chat(user, "You insert \the [W] into \the [src]'s storage compartment.")
			user.drop_item()
			W.forceMove(src)
			tank = W
		return
	else if(istype(W,/obj/item/device/suit_cooling_unit))
		if(cooler)
			to_chat(user, "\The [src] already has a suit cooling unit installed.")
		else if(tank)
			to_chat(user, "\The [src]'s airtank is in the way.  Remove it first.")
		else
			to_chat(user, "You insert \the [W] into \the [src]'s storage compartment.")
			user.drop_item()
			W.forceMove(src)
			cooler = W
		return

	..()
