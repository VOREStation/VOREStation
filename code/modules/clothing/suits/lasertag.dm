/*
 * Lasertag
 */

///DO NOT USE THIS BASE VARIANT, STUFF WILL BREAK!
/obj/item/clothing/suit/lasertag
	name = "laser tag armor"
	desc = "An example laser tag armor. Can not actually be used and is just for demonstrations."
	icon = 'icons/inventory/suit/item.dmi'
	icon_state = "omnitag"
	item_icons = list(slot_l_hand_str = 'icons/mob/items/lefthand_suits.dmi', slot_r_hand_str = 'icons/mob/items/righthand_suits.dmi')
	item_state_slots = list(slot_r_hand_str = "tdomni", slot_l_hand_str = "tdomni")
	blood_overlay_type = "armor"
	body_parts_covered = UPPER_TORSO
	allowed = list (/obj/item/gun/energy/lasertag)
	siemens_coefficient = 3.0
	description_fluff = "Laser tag armor can have its health and 'healing' time adjusted. Additionally, DonkSoft brand darts are compatible with laser tag vests, proving a projectile based alternative!"
	description_antag = "Laser tag armor can be emagged, causing the user to not only have a heart attack when eliminated, but also take massive damage based on the amount of 'lives' the vest had."

	var/lasertag_max_health = 3
	var/lasertag_health = 3

	///How long it takes for us to heal one point of health
	var/time_to_heal = 10 SECONDS

	///When we were last hit!
	var/last_hit

	///If we're emagged or not.
	var/emagged

/obj/item/clothing/suit/lasertag/emag_act(remaining_charges, mob/user, emag_source)
	if(!emagged)
		emagged = TRUE
		to_chat(user, span_warning("You disable the safeties on the lasertag vest."))
		return TRUE


/obj/item/clothing/suit/lasertag/examine(mob/user)
	. = ..()
	. += "It currently has [lasertag_health] hits out of [lasertag_max_health] remaining!"
	. += "It regenerates one hit every [time_to_heal*0.1] seconds."

/obj/item/clothing/suit/lasertag/verb/adjust_health()
	set name = "Adjust Suit Health"
	set category = "Object"
	set src in usr
	if(isliving(usr))
		adjust_health_proc(usr)

/obj/item/clothing/suit/lasertag/proc/adjust_health_proc(mob/living/user)
	var/max_health = 10
	var/min_health = 1
	var/new_health = tgui_input_number(user, "Select Suit Health (Between 1 and 10)", "Tag Health", lasertag_max_health, max_health, min_health, round_value=TRUE) //If you need to go above 10, ask admins.
	if(isnull(new_health))
		return null
	if(new_health > max_health || new_health < min_health)
		to_chat(user, span_danger("Invalid health value! Must be between [min_health] and [max_health]."))
		return null
	if(!Adjacent(user))
		to_chat(user, span_danger("You must be adjacent to the suit to adjust its healing timer!"))
		return null
	lasertag_max_health = new_health
	lasertag_health = lasertag_max_health
	user.visible_message(user, span_notice("Set [src]'s allowed shots to [lasertag_max_health], fully healing the vest!"))

/obj/item/clothing/suit/lasertag/verb/adjust_heal_time()
	set name = "Adjust Healing Timer"
	set category = "Object"
	set src in usr
	if(isliving(usr))
		adjust_heal_time_proc(usr)

/obj/item/clothing/suit/lasertag/proc/adjust_heal_time_proc(mob/living/user)
	var/max_heal_time = 60
	var/min_heal_time = 0
	var/new_heal_timer = tgui_input_number(user, "Select Heal Timer (Between 0(off) to 60 seconds)", "Heal Timer", time_to_heal*0.1, max_heal_time, min_heal_time, round_value=TRUE) //If you need to go above 10, ask admins.
	if(isnull(new_heal_timer))
		return null
	if(new_heal_timer > max_heal_time || new_heal_timer < min_heal_time)
		to_chat(user, span_danger("Invalid health value! Must be between [min_heal_time] and [max_heal_time]."))
		return null
	if(!Adjacent(user))
		to_chat(user, span_danger("You must be adjacent to the suit to adjust its healing timer!"))
		return null
	time_to_heal = (new_heal_timer*10)
	if(time_to_heal)
		user.visible_message(span_notice("[src]'s heal speed has been set to [new_heal_timer] seconds!"))
	else
		user.visible_message(span_notice("[src]'s healing function has been turned off!"))

/obj/item/clothing/suit/lasertag/dropped()
	..()
	STOP_PROCESSING(SSobj, src)
	visible_message(span_notice("[src] is unequipped, its health going back to full!"))
	lasertag_health = lasertag_max_health

/obj/item/clothing/suit/lasertag/equipped()
	..()
	START_PROCESSING(SSobj, src)

/obj/item/clothing/suit/lasertag/process()
	if(lasertag_health >= lasertag_max_health) //If we're at or above max health(due to admemes), no need to process.
		return
	if(!time_to_heal) //We have healing disabled.
		return

	if(world.time > last_hit + time_to_heal)
		if(lasertag_health < 0) //overkill protection
			lasertag_health = 0
		lasertag_health++
		if(lasertag_health == lasertag_max_health)
			if(ismob(src.loc)) //sanity check
				var/mob/wearer = src.loc
				to_chat(wearer, span_notice("Your [src] beeps happily as it fully recharges! You can now be hit [lasertag_health] times before you are downed!"))

/obj/item/clothing/suit/lasertag/proc/handle_hit(damage)
	if(lasertag_health > 0)
		if(damage)
			lasertag_health -= damage
		else
			lasertag_health--
		last_hit = world.time
		if(isliving(src.loc))
			var/mob/living/wearer = src.loc

			if(lasertag_health > 0) //Still have HP, keep going.
				wearer.visible_message(span_warning("[src] beeps as it takes a shot! [lasertag_health] shots remaining!"))
				return

			wearer.visible_message(span_boldwarning("[src] beeps as its health is fully depleted! [wearer] is down!"))
			to_chat(wearer, span_large(span_danger("You're out!"))) //People KEEP MISSING THAT THEY'RE OUT, SO NOW THEY WON'T.
			wearer.Stun(5)
			wearer.Weaken(5)
			if(emagged)
				to_chat(wearer, span_bolddanger(span_massive("OH GOD! YOUR HEART!"))) //this is the last thing you see before you (presumably) die.
				wearer.apply_damage(lasertag_max_health*50, BURN, BP_TORSO, used_weapon = "High-Voltage Electrical Shock")
				if(ishuman(wearer))
					var/mob/living/carbon/human/human_wearer = wearer
					var/obj/item/organ/internal/heart/H = human_wearer.internal_organs_by_name[O_HEART]
					if(H)
						if(H.robotic)
							H.break_organ()
						else
							H.bruise()
							if(H.damage < 15)
								H.damage = 14 //Below this number we won't be KO'd from a heart attack.
			return

		if(lasertag_health > 0)
			visible_message(span_warning("[src] beeps as its health is takes a hit! [lasertag_health] shots remaining!"))
		else
			visible_message(span_boldwarning("[src] beeps as its health is depleted!"))
		return

	visible_message(span_warning("[src] beeps - its health is already depleted!"))
	return

/obj/item/clothing/suit/lasertag/bluetag
	name = "blue laser tag armor"
	desc = "Blue Pride, Station Wide."
	icon_state = "bluetag"
	item_state_slots = list(slot_r_hand_str = "tdblue", slot_l_hand_str = "tdblue")
	allowed = list (/obj/item/gun/energy/lasertag/blue)

/obj/item/clothing/suit/lasertag/redtag
	name = "red laser tag armor"
	desc = "Reputed to go faster."
	icon_state = "redtag"
	item_state_slots = list(slot_r_hand_str = "tdred", slot_l_hand_str = "tdred")
	allowed = list (/obj/item/gun/energy/lasertag/red)

/obj/item/clothing/suit/lasertag/bluetag/sub
	name = "Brigader Armor"
	desc = "Replica armor commonly worn by Spacer Union Brigade members from the hit series Spacer Trail. Modified for Laser Tag (Blue Team)."
	icon_state = "bluetag2"

/obj/item/clothing/suit/lasertag/redtag/dom
	name = "Mu'tu'bi Armor"
	desc = "Replica armor commonly worn by Dominion Of Mu'tu'bi soldiers from the hit series Spacer Trail. Modified for Laser Tag (Red Team)."
	icon_state = "redtag2"

/obj/item/clothing/suit/lasertag/omni
	name = "universal laser tag armour"
	desc = "Laser tag armor with no allegiance. For the true renegade, or a free for all."
	allowed = list (/obj/item/gun/energy/lasertag/omni)
