#define DEFIB_TIME_LIMIT (10 MINUTES) //past this many seconds, defib is useless.
#define DEFIB_TIME_LOSS  (2 MINUTES) //past this many seconds, brain damage occurs.

//backpack item
/obj/item/defib_kit
	name = "defibrillator"
	desc = "A device that delivers powerful shocks to detachable paddles that resuscitate incapacitated patients."
	icon = 'icons/obj/defibrillator.dmi'
	icon_state = "defibunit"
	item_state = "defibunit"
	slot_flags = SLOT_BACK
	force = 5
	throwforce = 6
	preserve_item = 1
	w_class = ITEMSIZE_LARGE
	unacidable = TRUE
	origin_tech = list(TECH_BIO = 4, TECH_POWER = 2)
	action_button_name = "Remove/Replace Paddles"

	var/obj/item/shockpaddles/linked/paddles
	var/obj/item/cell/bcell = null

/obj/item/defib_kit/get_cell()
	return bcell

<<<<<<< HEAD
/obj/item/device/defib_kit/New() //starts without a cell for rnd
	..()
=======
/obj/item/defib_kit/Initialize() //starts without a cell for rnd
	. = ..()
>>>>>>> 61084723c7b... Merge pull request #8317 from Atermonera/remove_weapon
	if(ispath(paddles))
		paddles = new paddles(src, src)
	else
		paddles = new(src, src)

	if(ispath(bcell))
		bcell = new bcell(src)
	update_icon()

/obj/item/defib_kit/Destroy()
	. = ..()
	QDEL_NULL(paddles)
	QDEL_NULL(bcell)

/obj/item/defib_kit/loaded //starts with a cell
	bcell = /obj/item/cell/apc


<<<<<<< HEAD
/obj/item/device/defib_kit/update_icon()
	cut_overlays()
=======
/obj/item/defib_kit/update_icon()
	var/list/new_overlays = list()
>>>>>>> 61084723c7b... Merge pull request #8317 from Atermonera/remove_weapon

	if(paddles && paddles.loc == src) //in case paddles got destroyed somehow.
		add_overlay("[initial(icon_state)]-paddles")
	if(bcell && paddles)
		if(bcell.check_charge(paddles.chargecost))
			if(paddles.combat)
				add_overlay("[initial(icon_state)]-combat")
			else if(!paddles.safety)
				add_overlay("[initial(icon_state)]-emagged")
			else
				add_overlay("[initial(icon_state)]-powered")

		var/ratio = CEILING(bcell.percent()/25, 1) * 25
		add_overlay("[initial(icon_state)]-charge[ratio]")
	else
		add_overlay("[initial(icon_state)]-nocell")

/obj/item/defib_kit/ui_action_click()
	toggle_paddles()

/obj/item/defib_kit/attack_hand(mob/user)
	if(loc == user)
		toggle_paddles()
	else
		..()

/obj/item/defib_kit/MouseDrop()
	if(ismob(src.loc))
		if(!CanMouseDrop(src))
			return
		var/mob/M = src.loc
		if(!M.unEquip(src))
			return
		src.add_fingerprint(usr)
		M.put_in_any_hand_if_possible(src)


/obj/item/defib_kit/attackby(obj/item/W, mob/user, params)
	if(W == paddles)
		reattach_paddles(user)
	else if(istype(W, /obj/item/cell))
		if(bcell)
			to_chat(user, "<span class='notice'>\The [src] already has a cell.</span>")
		else
			if(!user.unEquip(W))
				return
			W.forceMove(src)
			bcell = W
			to_chat(user, "<span class='notice'>You install a cell in \the [src].</span>")
			update_icon()

	else if(W.is_screwdriver())
		if(bcell)
			bcell.update_icon()
			bcell.forceMove(get_turf(src.loc))
			bcell = null
			to_chat(user, "<span class='notice'>You remove the cell from \the [src].</span>")
			update_icon()
	else
		return ..()

/obj/item/defib_kit/emag_act(var/remaining_charges, var/mob/user)
	if(paddles)
		. = paddles.emag_act(user)
		update_icon()
	return

//Paddle stuff

/obj/item/defib_kit/verb/toggle_paddles()
	set name = "Toggle Paddles"
	set category = "Object"

	var/mob/living/carbon/human/user = usr
	if(!paddles)
		to_chat(user, "<span class='warning'>The paddles are missing!</span>")
		return

	if(paddles.loc != src)
		reattach_paddles(user) //Remove from their hands and back onto the defib unit
		return

	if(!slot_check())
		to_chat(user, "<span class='warning'>You need to equip [src] before taking out [paddles].</span>")
	else
		if(!usr.put_in_hands(paddles)) //Detach the paddles into the user's hands
			to_chat(user, "<span class='warning'>You need a free hand to hold the paddles!</span>")
		update_icon() //success

//checks that the base unit is in the correct slot to be used
/obj/item/defib_kit/proc/slot_check()
	var/mob/M = loc
	if(!istype(M))
		return 0 //not equipped

	if((slot_flags & SLOT_BACK) && M.get_equipped_item(slot_back) == src)
		return 1
	if((slot_flags & SLOT_BELT) && M.get_equipped_item(slot_belt) == src)
		return 1
	//VOREStation Add Start - RIGSuit compatability
	if((slot_flags & SLOT_BACK) && M.get_equipped_item(slot_s_store) == src)
		return 1
	if((slot_flags & SLOT_BELT) && M.get_equipped_item(slot_s_store) == src)
		return 1
	//VOREStation Add End

	return 0

/obj/item/defib_kit/dropped(mob/user)
	..()
	reattach_paddles(user) //paddles attached to a base unit should never exist outside of their base unit or the mob equipping the base unit

/obj/item/defib_kit/proc/reattach_paddles(mob/user)
	if(!paddles) return

	if(ismob(paddles.loc))
		var/mob/M = paddles.loc
		if(M.drop_from_inventory(paddles, src))
			to_chat(user, "<span class='notice'>\The [paddles] snap back into the main unit.</span>")
	else
		paddles.forceMove(src)

	update_icon()

/*
	Base Unit Subtypes
*/

/obj/item/defib_kit/compact
	name = "compact defibrillator"
	desc = "A belt-equipped defibrillator that can be rapidly deployed."
	icon_state = "defibcompact"
	item_state = "defibcompact"
	w_class = ITEMSIZE_NORMAL
	slot_flags = SLOT_BELT
	origin_tech = list(TECH_BIO = 5, TECH_POWER = 3)

/obj/item/defib_kit/compact/loaded
	bcell = /obj/item/cell/high


/obj/item/defib_kit/compact/combat
	name = "combat defibrillator"
	desc = "A belt-equipped blood-red defibrillator that can be rapidly deployed. Does not have the restrictions or safeties of conventional defibrillators and can revive through space suits."
	paddles = /obj/item/shockpaddles/linked/combat

/obj/item/defib_kit/compact/combat/loaded
	bcell = /obj/item/cell/high

/obj/item/shockpaddles/linked/combat
	combat = 1
	safety = 0
	chargetime = (1 SECONDS)


//paddles

/obj/item/shockpaddles
	name = "defibrillator paddles"
	desc = "A pair of plastic-gripped paddles with flat metal surfaces that are used to deliver powerful electric shocks."
	icon = 'icons/obj/defibrillator.dmi'
	icon_state = "defibpaddles"
	item_state = "defibpaddles"
	gender = PLURAL
	force = 2
	throwforce = 6
	w_class = ITEMSIZE_LARGE

	var/safety = 1 //if you can zap people with the paddles on harm mode
	var/combat = 0 //If it can be used to revive people wearing thick clothing (e.g. spacesuits)
	var/cooldowntime = (6 SECONDS) // How long in deciseconds until the defib is ready again after use.
	var/chargetime = (2 SECONDS)
	var/chargecost = 1250 //units of charge per zap	//With the default APC level cell, this allows 4 shocks
	var/burn_damage_amt = 5
	var/use_on_synthetic = 0 //If 1, this is only useful on FBPs, if 0, this is only useful on fleshies

	var/wielded = 0
	var/cooldown = 0
	var/busy = 0

/obj/item/shockpaddles/proc/set_cooldown(var/delay)
	cooldown = 1
	update_icon()

	spawn(delay)
		if(cooldown)
			cooldown = 0
			update_icon()

			make_announcement("beeps, \"Unit is re-energized.\"", "notice")
			playsound(src, 'sound/machines/defib_ready.ogg', 50, 0)

/obj/item/shockpaddles/update_held_icon()
	var/mob/living/M = loc
	if(istype(M) && M.item_is_in_hands(src) && !M.hands_are_full())
		wielded = 1
		name = "[initial(name)] (wielded)"
	else
		wielded = 0
		name = initial(name)
	update_icon()
	..()

/obj/item/shockpaddles/update_icon()
	icon_state = "defibpaddles[wielded]"
	item_state = "defibpaddles[wielded]"
	if(cooldown)
		icon_state = "defibpaddles[wielded]_cooldown"

/obj/item/shockpaddles/proc/can_use(mob/user, mob/M)
	if(busy)
		return 0
	if(!check_charge(chargecost))
		to_chat(user, "<span class='warning'>\The [src] doesn't have enough charge left to do that.</span>")
		return 0
	if(!wielded && !isrobot(user))
		to_chat(user, "<span class='warning'>You need to wield the paddles with both hands before you can use them on someone!</span>")
		return 0
	if(cooldown)
		to_chat(user, "<span class='warning'>\The [src] are re-energizing!</span>")
		return 0
	return 1

//Checks for various conditions to see if the mob is revivable
/obj/item/shockpaddles/proc/can_defib(mob/living/carbon/human/H) //This is checked before doing the defib operation
	if((H.species.flags & NO_DEFIB))
		return "buzzes, \"Incompatible physiology. Operation aborted.\""
	else if(H.isSynthetic() && !use_on_synthetic)
		return "buzzes, \"Synthetic Body. Operation aborted.\""
	else if(!H.isSynthetic() && use_on_synthetic)
		return "buzzes, \"Organic Body. Operation aborted.\""

	if(H.stat != DEAD)
		return "buzzes, \"Patient is not in a valid state. Operation aborted.\""

	if(!check_contact(H))
		return "buzzes, \"Patient's chest is obstructed. Operation aborted.\""

	return null

/obj/item/shockpaddles/proc/can_revive(mob/living/carbon/human/H) //This is checked right before attempting to revive
	var/obj/item/organ/internal/brain/brain = H.internal_organs_by_name[O_BRAIN]
	if(H.should_have_organ(O_BRAIN) && (!brain || brain.defib_timer <= 0 ) )
		return "buzzes, \"Resuscitation failed - Excessive neural degeneration. Further attempts futile.\""

	H.updatehealth()

	if(H.isSynthetic())
		if(H.health + H.getOxyLoss() + H.getToxLoss() <= config.health_threshold_dead)
			return "buzzes, \"Resuscitation failed - Severe damage detected. Begin manual repair before further attempts futile.\""

	else if(H.health + H.getOxyLoss() <= config.health_threshold_dead || (HUSK in H.mutations) || !H.can_defib)
		return "buzzes, \"Resuscitation failed - Severe tissue damage makes recovery of patient impossible via defibrillator. Further attempts futile.\""

	var/bad_vital_organ = check_vital_organs(H)
	if(bad_vital_organ)
		return bad_vital_organ

	//this needs to be last since if any of the 'other conditions are met their messages take precedence
	if(!H.client && !H.teleop)
		return "buzzes, \"Resuscitation failed - Mental interface error. Further attempts may be successful.\""

	return null

/obj/item/shockpaddles/proc/check_contact(mob/living/carbon/human/H)
	if(!combat)
		for(var/obj/item/clothing/cloth in list(H.wear_suit, H.w_uniform))
			if((cloth.body_parts_covered & UPPER_TORSO) && (cloth.item_flags & THICKMATERIAL))
				return FALSE
	return TRUE

/obj/item/shockpaddles/proc/check_vital_organs(mob/living/carbon/human/H)
	for(var/organ_tag in H.species.has_organ)
		var/obj/item/organ/O = H.species.has_organ[organ_tag]
		var/name = initial(O.name)
		var/vital = initial(O.vital) //check for vital organs
		if(vital)
			O = H.internal_organs_by_name[organ_tag]
			if(!O)
				return "buzzes, \"Resuscitation failed - Patient is missing vital organ ([name]). Further attempts futile.\""
			if(O.damage > O.max_damage)
				return "buzzes, \"Resuscitation failed - Excessive damage to vital organ ([name]). Further attempts futile.\""
	return null

/obj/item/shockpaddles/proc/check_blood_level(mob/living/carbon/human/H)
	if(!H.should_have_organ(O_HEART))
		return FALSE

	var/obj/item/organ/internal/heart/heart = H.internal_organs_by_name[O_HEART]
	if(!heart)
		return TRUE

	var/blood_volume = H.vessel.get_reagent_amount("blood")
	if(!heart || heart.is_broken())
		blood_volume *= 0.3
	else if(heart.is_bruised())
		blood_volume *= 0.7
	else if(heart.damage > 1)
		blood_volume *= 0.8
	return blood_volume < H.species.blood_volume*H.species.blood_level_fatal

/obj/item/shockpaddles/proc/check_charge(var/charge_amt)
	return 0

/obj/item/shockpaddles/proc/checked_use(var/charge_amt)
	return 0

/obj/item/shockpaddles/attack(mob/living/M, mob/living/user, var/target_zone)
	var/mob/living/carbon/human/H = M
	if(!istype(H) || user.a_intent == I_HURT)
		return ..() //Do a regular attack. Harm intent shocking happens as a hit effect

	if(can_use(user, H))
		busy = 1
		update_icon()

		do_revive(H, user)

		busy = 0
		update_icon()

	return 1

//Since harm-intent now skips the delay for deliberate placement, you have to be able to hit them in combat in order to shock people.
/obj/item/shockpaddles/apply_hit_effect(mob/living/target, mob/living/user, var/hit_zone)
	if(ishuman(target) && can_use(user, target))
		busy = 1
		update_icon()

		do_electrocute(target, user, hit_zone)

		busy = 0
		update_icon()

		return 1

	return ..()

// This proc is used so that we can return out of the revive process while ensuring that busy and update_icon() are handled
/obj/item/shockpaddles/proc/do_revive(mob/living/carbon/human/H, mob/user)
	var/mob/observer/dead/ghost = H.get_ghost()
	if(ghost)
		ghost.notify_revive("Someone is trying to resuscitate you. Re-enter your body if you want to be revived!", 'sound/effects/genetics.ogg', source = src)

	//beginning to place the paddles on patient's chest to allow some time for people to move away to stop the process
	user.visible_message("<span class='warning'>\The [user] begins to place [src] on [H]'s chest.</span>", "<span class='warning'>You begin to place [src] on [H]'s chest...</span>")
	if(!do_after(user, 30, H))
		return
	user.visible_message("<b>\The [user]</b> places [src] on [H]'s chest.", "<span class='warning'>You place [src] on [H]'s chest.</span>")
	playsound(src, 'sound/machines/defib_charge.ogg', 50, 0)

	var/error = can_defib(H)
	if(error)
		make_announcement(error, "warning")
		playsound(src, 'sound/machines/defib_failed.ogg', 50, 0)
		return

	if(check_blood_level(H))
		make_announcement("buzzes, \"Warning - Patient is in hypovolemic shock.\"", "warning") //also includes heart damage

	//placed on chest and short delay to shock for dramatic effect, revive time is 5sec total
	if(!do_after(user, chargetime, H))
		return

	//deduct charge here, in case the base unit was EMPed or something during the delay time
	if(!checked_use(chargecost))
		make_announcement("buzzes, \"Insufficient charge.\"", "warning")
		playsound(src, 'sound/machines/defib_failed.ogg', 50, 0)
		return

	H.visible_message("<span class='warning'>\The [H]'s body convulses a bit.</span>")
	playsound(src, "bodyfall", 50, 1)
	playsound(src, 'sound/machines/defib_zap.ogg', 50, 1, -1)
	set_cooldown(cooldowntime)

	error = can_revive(H)
	if(error)
		make_announcement(error, "warning")
		playsound(src, 'sound/machines/defib_failed.ogg', 50, 0)
		return

	H.apply_damage(burn_damage_amt, BURN, BP_TORSO)

	//set oxyloss so that the patient is just barely in crit, if possible
	var/barely_in_crit = config.health_threshold_crit - 1
	var/adjust_health = barely_in_crit - H.health //need to increase health by this much
	H.adjustOxyLoss(-adjust_health)

	if(H.isSynthetic())
		H.adjustToxLoss(-H.getToxLoss())

	make_announcement("pings, \"Resuscitation successful.\"", "notice")
	playsound(src, 'sound/machines/defib_success.ogg', 50, 0)

	make_alive(H)

	log_and_message_admins("used \a [src] to revive [key_name(H)].")


/obj/item/shockpaddles/proc/do_electrocute(mob/living/carbon/human/H, mob/user, var/target_zone)
	var/obj/item/organ/external/affecting = H.get_organ(target_zone)
	if(!affecting)
		to_chat(user, "<span class='warning'>They are missing that body part!</span>")
		return

	//no need to spend time carefully placing the paddles, we're just trying to shock them
	user.visible_message("<span class='danger'>\The [user] slaps [src] onto [H]'s [affecting.name].</span>", "<span class='danger'>You overcharge [src] and slap them onto [H]'s [affecting.name].</span>")

	//Just stop at awkwardly slapping electrodes on people if the safety is enabled
	if(safety)
		to_chat(user, "<span class='warning'>You can't do that while the safety is enabled.</span>")
		return

	playsound(src, 'sound/machines/defib_charge.ogg', 50, 0)
	audible_message("<span class='warning'>\The [src] lets out a steadily rising hum...</span>", runemessage = "whines")

	if(!do_after(user, chargetime, H))
		return

	//deduct charge here, in case the base unit was EMPed or something during the delay time
	if(!checked_use(chargecost))
		make_announcement("buzzes, \"Insufficient charge.\"", "warning")
		playsound(src, 'sound/machines/defib_failed.ogg', 50, 0)
		return

	user.visible_message("<span class='danger'><i>\The [user] shocks [H] with \the [src]!</i></span>", "<span class='warning'>You shock [H] with \the [src]!</span>")
	playsound(src, 'sound/machines/defib_zap.ogg', 100, 1, -1)
	playsound(src, 'sound/weapons/Egloves.ogg', 100, 1, -1)
	set_cooldown(cooldowntime)

	H.stun_effect_act(2, 120, target_zone)
	var/burn_damage = H.electrocute_act(burn_damage_amt*2, src, def_zone = target_zone)
	if(burn_damage > 15 && H.can_feel_pain())
		H.emote("scream")

	add_attack_logs(user,H,"Shocked using [name]")

/obj/item/shockpaddles/proc/make_alive(mob/living/carbon/human/M) //This revives the mob
	dead_mob_list.Remove(M)
	if((M in living_mob_list) || (M in dead_mob_list))
		WARNING("Mob [M] was defibbed but already in the living or dead list still!")
	living_mob_list += M

	M.timeofdeath = 0
	M.set_stat(UNCONSCIOUS) //Life() can bring them back to consciousness if it needs to.
	M.failed_last_breath = 0 //So mobs that died of oxyloss don't revive and have perpetual out of breath.
	M.reload_fullscreen()

	M.emote("gasp")
	M.Weaken(rand(10,25))
	M.updatehealth()
	apply_brain_damage(M)
	// VOREStation Edits Start: Defib pain
	if(istype(M.species, /datum/species/xenochimera)) // Only do the following to Xenochimera. Handwave this however you want, this is to balance defibs on an alien race.
		M.adjustHalLoss(220) // This hurts a LOT, stacks on top of the previous halloss.
		M.feral += 100 // If they somehow weren't already feral, force them feral by increasing ferality var directly, to avoid any messy checks. handle_feralness() will immediately set our feral properly according to halloss anyhow.
	// VOREStation Edits End
	// SSgame_master.adjust_danger(-20) // VOREStation Edit - We don't use SSgame_master yet.

/obj/item/shockpaddles/proc/apply_brain_damage(mob/living/carbon/human/H)
	if(!H.should_have_organ(O_BRAIN))
		return // No brain.

	var/obj/item/organ/internal/brain/brain = H.internal_organs_by_name[O_BRAIN]
	if(!brain)
		return // Still no brain.

	// If the brain'd `defib_timer` var gets below this number, brain damage will happen at a linear rate.
	// This is measures in `Life()` ticks. E.g. 10 minute defib timer = 300 `Life()` ticks.				// Original math was VERY off. Life() tick occurs every ~2 seconds, not every 2 world.time ticks.
	var/brain_damage_timer = ((config.defib_timer MINUTES) / 20) - ((config.defib_braindamage_timer MINUTES) / 20)

	if(brain.defib_timer > brain_damage_timer)
		return // They got revived before brain damage got a chance to set in.

	// As the brain decays, this will be between 0 and 1, with 1 being the most fresh.
	var/brain_death_scale = brain.defib_timer / brain_damage_timer

	// This is backwards from what you might expect, since 1 = fresh and 0 = rip.
	var/damage_calc = LERP(brain.max_damage, H.getBrainLoss(), brain_death_scale)

	// A bit of sanity.
	var/brain_damage = between(H.getBrainLoss(), damage_calc, brain.max_damage)

	H.setBrainLoss(brain_damage)

/obj/item/shockpaddles/proc/make_announcement(var/message, var/msg_class)
	audible_message("<b>\The [src]</b> [message]", "\The [src] vibrates slightly.", runemessage = "buzz")

/obj/item/shockpaddles/emag_act(mob/user)
	if(safety)
		safety = 0
		to_chat(user, "<span class='warning'>You silently disable \the [src]'s safety protocols with the cryptographic sequencer.</span>")
		update_icon()
		return 1
	else
		safety = 1
		to_chat(user, "<span class='notice'>You silently enable \the [src]'s safety protocols with the cryptographic sequencer.</span>")
		update_icon()
		return 1

/obj/item/shockpaddles/emp_act(severity)
	var/new_safety = rand(0, 1)
	if(safety != new_safety)
		safety = new_safety
		if(safety)
			make_announcement("beeps, \"Safety protocols enabled!\"", "notice")
			playsound(src, 'sound/machines/defib_safetyon.ogg', 50, 0)
		else
			make_announcement("beeps, \"Safety protocols disabled!\"", "warning")
			playsound(src, 'sound/machines/defib_safetyoff.ogg', 50, 0)
		update_icon()
	..()

/obj/item/shockpaddles/robot
	name = "defibrillator paddles"
	desc = "A pair of advanced shockpaddles powered by a robot's internal power cell, able to penetrate thick clothing."
	chargecost = 50
	combat = 1
	icon_state = "defibpaddles0"
	item_state = "defibpaddles0"
	cooldowntime = (3 SECONDS)

/obj/item/shockpaddles/robot/check_charge(var/charge_amt)
	if(isrobot(src.loc))
		var/mob/living/silicon/robot/R = src.loc
		return (R.cell && R.cell.check_charge(charge_amt))

/obj/item/shockpaddles/robot/checked_use(var/charge_amt)
	if(isrobot(src.loc))
		var/mob/living/silicon/robot/R = src.loc
		return (R.cell && R.cell.checked_use(charge_amt))

/obj/item/shockpaddles/robot/combat
	name = "combat defibrillator paddles"
	desc = "A pair of advanced shockpaddles powered by a robot's internal power cell, able to penetrate thick clothing.  This version \
	appears to be optimized for combat situations, foregoing the safety inhabitors in favor of a faster charging time."
	safety = 0
	chargetime = (1 SECONDS)

/*
	Shockpaddles that are linked to a base unit
*/
/obj/item/shockpaddles/linked
	var/obj/item/defib_kit/base_unit

<<<<<<< HEAD
/obj/item/weapon/shockpaddles/linked/New(newloc, obj/item/device/defib_kit/defib)
=======
/obj/item/shockpaddles/linked/Initialize(var/ml, obj/item/defib_kit/defib)
>>>>>>> 61084723c7b... Merge pull request #8317 from Atermonera/remove_weapon
	base_unit = defib
	..(newloc)

/obj/item/shockpaddles/linked/Destroy()
	if(base_unit)
		//ensure the base unit's icon updates
		if(base_unit.paddles == src)
			base_unit.paddles = null
			base_unit.update_icon()
		base_unit = null
	return ..()

/obj/item/shockpaddles/linked/dropped(mob/user)
	..() //update twohanding
	if(base_unit)
		base_unit.reattach_paddles(user) //paddles attached to a base unit should never exist outside of their base unit or the mob equipping the base unit

/obj/item/shockpaddles/linked/check_charge(var/charge_amt)
	return (base_unit.bcell && base_unit.bcell.check_charge(charge_amt))

/obj/item/shockpaddles/linked/checked_use(var/charge_amt)
	return (base_unit.bcell && base_unit.bcell.checked_use(charge_amt))

/obj/item/shockpaddles/linked/make_announcement(var/message, var/msg_class)
	base_unit.audible_message("<b>\The [base_unit]</b> [message]", "\The [base_unit] vibrates slightly.")

/*
	Standalone Shockpaddles
*/

/obj/item/shockpaddles/standalone
	desc = "A pair of shockpaddles powered by an experimental miniaturized reactor" //Inspired by the advanced e-gun
	var/fail_counter = 0

/obj/item/shockpaddles/standalone/Destroy()
	. = ..()
	if(fail_counter)
		STOP_PROCESSING(SSobj, src)

/obj/item/shockpaddles/standalone/check_charge(var/charge_amt)
	return 1

/obj/item/shockpaddles/standalone/checked_use(var/charge_amt)
	SSradiation.radiate(src, charge_amt/12) //just a little bit of radiation. It's the price you pay for being powered by magic I guess
	return 1

/obj/item/shockpaddles/standalone/process()
	if(fail_counter > 0)
		SSradiation.radiate(src, fail_counter--)
	else
		STOP_PROCESSING(SSobj, src)

/obj/item/shockpaddles/standalone/emp_act(severity)
	..()
	var/new_fail = 0
	switch(severity)
		if(1)
			new_fail = max(fail_counter, 20)
			visible_message("\The [src]'s reactor overloads!")
		if(2)
			new_fail = max(fail_counter, 8)
			if(ismob(loc))
				to_chat(loc, "<span class='warning'>\The [src] feel pleasantly warm.</span>")

	if(new_fail && !fail_counter)
		START_PROCESSING(SSobj, src)
	fail_counter = new_fail

/* From the Bay port, this doesn't seem to have a sprite.
/obj/item/shockpaddles/standalone/traitor
	name = "defibrillator paddles"
	desc = "A pair of unusual looking paddles powered by an experimental miniaturized reactor. It possesses both the ability to penetrate armor and to deliver powerful shocks."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "defibpaddles0"
	item_state = "defibpaddles0"
	combat = 1
	safety = 0
	chargetime = (1 SECONDS)
*/

//FBP Defibs
/obj/item/defib_kit/jumper_kit
	name = "jumper cable kit"
	desc = "A device that delivers powerful shocks to detachable jumper cables that are capable of reviving full body prosthetics."
	icon_state = "jumperunit"
	item_state = "defibunit"
//	item_state = "jumperunit"
	paddles = /obj/item/shockpaddles/linked/jumper

/obj/item/defib_kit/jumper_kit/loaded
	bcell = /obj/item/cell/high

/obj/item/shockpaddles/linked/jumper
	name = "jumper cables"
	icon_state = "jumperpaddles"
	item_state = "jumperpaddles"
	use_on_synthetic = 1

/obj/item/shockpaddles/robot/jumper
	name = "jumper cables"
	desc = "A pair of advanced shockpaddles powered by a robot's internal power cell, able to penetrate thick clothing."
	icon_state = "jumperpaddles0"
	item_state = "jumperpaddles0"
	use_on_synthetic = 1

#undef DEFIB_TIME_LIMIT
#undef DEFIB_TIME_LOSS
