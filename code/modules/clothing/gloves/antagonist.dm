/*
 * Antagonist-specific gloves, such as traitor or ling-only types.
 */

// Thief - Traitor / Merc
/obj/item/clothing/gloves/sterile/thieves
	name = "sterile gloves"
	desc = "Sterile gloves."
	description_antag = "These gloves are uniquely suited for stealing, as well as breaking and entering. They have minor insulation.\
	Attempting to 'help' someone will open their backpack, if it exists, or their belt if they have no backpack, allowing you to deposit\
	items into the inventories. Be careful about making too much noise.\
	Disarm intent will swap the items in your LEFT pockets. Grab will swap RIGHT pockets."
	icon_state = "latex"
	item_state_slots = list(slot_r_hand_str = "white", slot_l_hand_str = "white")
	siemens_coefficient = 0.5 // Not perfect, but slightly more protective than nothing.
	permeability_coefficient = 0.01
	germ_level = 0
	fingerprint_chance = 10 // They're thieves' gloves. What do you think?

/obj/item/clothing/gloves/sterile/thieves/proc/pickpocket(var/mob/living/carbon/human/user, var/mob/living/carbon/human/target, var/proximity)
	if(!proximity || !user || !target)
		return 0

	if(!istype(target))
		return 0

	if(user.a_intent != I_HURT && (turn(target.dir, 180) == get_dir(user, target)))
		to_chat(target, "<span class='warning'>[user] rifles in your pockets!</span>")

	if(user.a_intent == I_HELP)
		if(istype(target.back,/obj/item/weapon/storage) && do_after(user, 3 SECONDS, target))
			var/obj/item/weapon/storage/Backpack = target.back
			Backpack.open(user)
		else if(istype(target.belt, /obj/item/weapon/storage) && do_after(user, 5 SECONDS, target))
			var/obj/item/weapon/storage/Belt = target.belt
			Belt.open(user)
		return 1

	if(user.a_intent == I_DISARM)
		var/obj/item/LTarg = target.l_store
		var/obj/item/LUser = user.l_store

		if(do_after(user, 1 SECOND, target))
			if(istype(LTarg) && do_after(user, 1 SECOND, target))
				target.drop_from_inventory(LTarg)
				target.l_store = null
				user.l_store = LTarg
				LTarg.forceMove(user)
				LTarg.equipped(user, slot_l_store)
			else
				target.drop_from_inventory(LTarg)

			if(istype(LUser) && do_after(user, 1 SECOND, target))
				user.drop_from_inventory(LUser)
				target.l_store = LUser
				LUser.forceMove(target)
				LUser.equipped(target, slot_l_store)
			else if(istype(LUser) && LUser != user.l_store) // We've taken something, so drop the one that's in bluespace.
				user.drop_from_inventory(LUser)

		return 1

	if(user.a_intent == I_GRAB)
		var/obj/item/RTarg = target.r_store
		var/obj/item/RUser = user.r_store

		if(do_after(user, 1 SECOND, target))
			if(istype(RTarg) && do_after(user, 1 SECOND, target))
				target.drop_from_inventory(RTarg)
				target.r_store = null
				user.r_store = RTarg
				RTarg.forceMove(user)
				RTarg.equipped(user, slot_r_store)
			else
				target.drop_from_inventory(RTarg)

			if(istype(RUser) && do_after(user, 1 SECOND, target))
				user.drop_from_inventory(RUser)
				target.r_store = RUser
				RUser.forceMove(target)
				RUser.equipped(target, slot_r_store)
			else if(istype(RUser) && RUser != user.r_store) // We've taken something, so drop the one that's in bluespace.
				user.drop_from_inventory(RUser)

		return 1

/obj/item/clothing/gloves/sterile/thieves/Touch(var/atom/A, var/proximity)
	if(proximity && istype(usr, /mob/living/carbon/human) && do_after(usr, 1 SECOND, A))
		return pickpocket(usr, A, proximity)
	return 0

// Buzzer Ring - Traitor, Merc.
/obj/item/clothing/gloves/ring/buzzer
	name = "ring"
	desc = "A plain metal band."
	description_antag = "This morphium-alloy ring continually generates an electric field, capable of electrocuting a target while not injuring the wearer.\
	The device is also capable of 'frankenstein'-ing a corpse, long after normal technology would be able to save them. The body will still be tied to the\
	normal damage limits for survival, however, so care must be taken."
	icon_state = "material"
	var/battery_type = /obj/item/weapon/cell/device/weapon/recharge
	var/obj/item/weapon/cell/battery = null

/obj/item/clothing/gloves/ring/buzzer/get_cell()
	return battery

/obj/item/clothing/gloves/ring/buzzer/Initialize()
	. = ..()
	if(!battery)
		battery = new battery_type(src)

/obj/item/clothing/gloves/ring/buzzer/Touch(var/atom/A, var/proximity)
	if(proximity && istype(usr, /mob/living/carbon/human))
		return zap(usr, A, proximity)
	return 0

/obj/item/clothing/gloves/ring/buzzer/proc/zap(var/mob/living/carbon/human/user, var/atom/movable/target, var/proximity)
	. = FALSE
	if(user.a_intent == I_HURT && battery.percent() >= 50)
		if(isliving(target))
			var/mob/living/L = target

			if(ishuman(L) && battery.percent() >= 90)	// Silent text-wise, for maximum potential for gimmicks.
				var/mob/living/carbon/human/H = L

				if(H.stat == DEAD)
					. = TRUE

					do_defib(H)

			to_chat(L, "<span class='warning'>You feel a powerful shock!</span>")
			if(!.)
				playsound(L, 'sound/effects/sparks7.ogg', 40, 1)
				L.electrocute_act(battery.percent() * 0.25, src)
				battery.emp_act(2)
			return .

	return 0

/obj/item/clothing/gloves/ring/buzzer/proc/do_defib(var/mob/living/carbon/human/H = null)
	if(!istype(H))
		return 0

	dead_mob_list.Remove(H)
	if((H in living_mob_list) || (H in dead_mob_list))
		WARNING("Mob [H] was ring-defibbed but already in the living or dead list still!")
	living_mob_list += H

	H.timeofdeath = 0
	H.set_stat(UNCONSCIOUS)
	H.failed_last_breath = 0
	H.reload_fullscreen()

	H.emote("gasp")
	H.Weaken(rand(10,25))
	H.updatehealth()

	battery.emp_act(1)
