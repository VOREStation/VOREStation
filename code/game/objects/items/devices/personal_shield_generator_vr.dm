// TO ANYBODY LOOKING AT THIS FILE:
// Everything is mostly commented on to give as much detailed information as possible.
// Some things may be difficult to understand, but every variable in here has a comment explaining what it is/does.
// The base unit, the 'personal_shield_generator' is a backpack, comes with a gun, and has normal numbers for everything.
// The belt units do NOT come with a gun and have a cell that is half the capacity of backpack units.
// These can be VERY, VERY, VERY strong if too many are handed out, the cell is too strong, or the modifier is too strong.
// Additionally, if you are mapping any of these in, ensure you map in the /loaded versions or else they won't have a battery.
// I have also made it so you can modify everything about them, including the modifier they give and the cell, which can be changed via mapping.

// In essence, these can be viewed as an extra layer of armor that has upsides and downsides with more extensive features.
// Shield generators apply PRE armor. Ultimately this shouldn't matter too much, but it makes more sense this way.
// There are a good amount of variants in here, ranging from mining to security to misc ones.
// If you want to make a variant, you need to only change modifier_type and make the modifier desired.


/obj/item/personal_shield_generator
	name = "personal shield generator"
	desc = "A personal shield generator."
	icon = 'icons/obj/items_vr.dmi'
	icon_state = "shieldpack_basic"
	item_state = "defibunit" //Placeholder
	slot_flags = SLOT_BACK
	force = 5
	throwforce = 6
	preserve_item = 1
	w_class = ITEMSIZE_HUGE //It's a giant shield generator!!!
	unacidable = TRUE
	origin_tech = list(TECH_MATERIAL = 6, TECH_COMBAT = 8, TECH_POWER = 6, TECH_DATA = 4) //These are limited AND high tech. Breaking one of them down is massive.
	actions_types = list(/datum/action/item_action/toggle_shield)
	var/obj/item/gun/energy/gun/generator/active_weapon
	var/obj/item/cell/device/bcell = null
	var/upgraded = 0 										// If the PSG has been upgraded by some method or not. Only used for the mining belt ATM.


	var/generator_hit_cost = 100							// Power used when a special effect (such as a bullet being blocked) is performed! Could also be expanded to other things.
	var/generator_active_cost = 10							// Power used when turned on.
	var/damage_cost = 25									// 40 damage absorbed per 1000 charge.
	var/modifier_type = /datum/modifier/shield_projection	// What type of modifier will it add? Used for variant modifiers!

	var/has_weapon = 1										// Backpack units generally have weapons.
	var/shield_active = 0 									// If the shield gen is active.
	var/effect_color = "#99FFFF"							// Allows for changing shield colors. Default cyan.

/obj/item/personal_shield_generator/get_cell()
	return bcell

/obj/item/personal_shield_generator/New()
	..()
	if(ispath(bcell))
		bcell = new bcell(src)

	if(has_weapon)
		if(ispath(active_weapon))
			active_weapon = new active_weapon(src, src)
			active_weapon.power_supply = bcell
		else
			active_weapon = new(src, src)
			active_weapon.power_supply = bcell
	else
		verbs -= /obj/item/personal_shield_generator/verb/weapon_toggle
	STOP_PROCESSING(SSobj, src) //We do this so it doesn't start processing until it's first used.
	update_icon()

/obj/item/personal_shield_generator/Destroy()
	. = ..()
	QDEL_NULL(active_weapon)
	QDEL_NULL(bcell)

/obj/item/personal_shield_generator/loaded //starts with a cell
	bcell = /obj/item/cell/device/shield_generator/backpack


/obj/item/personal_shield_generator/update_icon()
	if(shield_active)
		icon_state = "shieldpack_basic_on"
	else
		icon_state = "shieldpack_basic"

/obj/item/personal_shield_generator/examine(mob/user)
	. = ..()
	if(Adjacent(user))
		if(upgraded)
			. += "The unit appears to be upgraded."
		if(bcell)
			. += "The internal cell is [round(bcell.percent() )]% charged."
		else
			. += "The device has no cell installed."
			return
		if(damage_cost) //Prevention of dividing by 0 errors.
			. += "It reads that it can take [bcell.charge/damage_cost] more damage before the shield goes down."
		if(bcell.self_recharge && bcell.charge_amount)
			. += "This model is self charging and will take [bcell.maxcharge/bcell.charge_amount] seconds to fully charge from empty."
		if(bcell.rigged)
			. += "A red flashing 'WARNING' is visible on the display, noting that the cell is unstable and requires replacement."


/* //This would be cool, but we need sprites.
	cut_overlays()

	if(has_weapon && active_weapon && active_weapon.loc == src) //in case gun gets destroyed somehow.
		add_overlay("[initial(icon_state)]-paddles")
	if(bcell)
		if(bcell.check_charge(generator_hit_cost)) //Can we take a blow?
			add_overlay("[initial(icon_state)]-powered")
		else if(has_weapon && active_weapon)
			if(bcell.check_charge(active_weapon.charge_cost)) //We got enough to go pew pew?
				add_overlay("[initial(icon_state)]-powered")

		var/ratio = CEILING(bcell.percent()/25, 1) * 25
		add_overlay("[initial(icon_state)]-charge[ratio]")
	else
		add_overlay("[initial(icon_state)]-nocell")
*/

/obj/item/personal_shield_generator/emp_act(severity)
	if(bcell && shield_active)
		switch(severity)
			if(1) //Point blank EMP shots have a good chance of burning the cell charge.
				if(prob(50))
					bcell.emp_act(severity)
					if(prob(5)) //1 in 20% chance to fry the battery completly, which has a 1/10 chance of making the battery explode on next use.
						bcell.corrupt() //Not too bad if you slotted a battery in. Disasterous if it has a self-charging battery.
					if(bcell.rigged) //Did the above just rig the cell? Turn it off. Don't immediately have it go boom. Instead have the cell blow soon-ish.
						var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
						s.set_up(5, 1, src)
						s.start()
						shield_active = 0
						if(bcell.charge_delay) //It WILL blow up soon. Downside of self-charging cells.
							to_chat(src.loc, span_critical("Your shield generator sparks and suddenly goes down! A warning message pops up on screen: \
							'WARNING, INTERNAL CELL MELTDOWN IMMINENT. TIME TILL EXPLOSION: [bcell.charge_delay/10] SECONDS. DISCARD UNIT IMMEDIATELY!'"))
						else //It won't blow up unless you turn it back on again. Upside of using non-charging cells.
							to_chat(src.loc, span_critical("Your shield generator sparks and suddenly goes down! A warning message pops up on screen: \
							'WARNING, INTERNAL CELL CRITICALLY DAMAGED. REPLACE CELL IMMEDIATELY.'"))
						STOP_PROCESSING(SSobj, src)
						update_icon()
			else
				if(prob(25))
					bcell.emp_act(severity)
	..()

/obj/item/personal_shield_generator/ui_action_click(mob/user, actiontype)
	toggle_shield()

/obj/item/personal_shield_generator/attack_hand(mob/user)
	if(loc == user)
		toggle_shield()
	else
		..()

/obj/item/personal_shield_generator/AltClick(mob/living/user)
	weapon_toggle()

/obj/item/personal_shield_generator/MouseDrop()
	if(ismob(src.loc))
		if(!CanMouseDrop(src))
			return
		var/mob/M = src.loc
		if(!M.unEquip(src))
			return
		src.add_fingerprint(usr)
		M.put_in_any_hand_if_possible(src)


/obj/item/personal_shield_generator/attackby(obj/item/W, mob/user, params)
	if(W == active_weapon)
		reattach_gun(user)
	else if(istype(W, /obj/item/cell))
		if(bcell)
			to_chat(user, span_notice("\The [src] already has a cell."))
		else if(!istype(W, /obj/item/cell/device/weapon)) //Weapon cells only!
			to_chat(user, span_notice("This cell will not fit in the device."))
		else
			if(!user.unEquip(W))
				return
			W.forceMove(src)
			bcell = W
			if(active_weapon)
				active_weapon.power_supply = bcell
			to_chat(user, span_notice("You install a cell in \the [src]."))
			update_icon()

	else if(W.has_tool_quality(TOOL_SCREWDRIVER))
		if(bcell)
			if(istype(bcell, /obj/item/cell/device/shield_generator)) //No stealing self charging batteries!
				var/choice = tgui_alert(user, "A popup appears on the device 'REMOVING THE INTERNAL CELL WILL DESTROY THE BATTERY. DO YOU WISH TO CONTINUE?'...Well, do you?", "Selection List", list("Cancel", "Remove"))
				if(choice == "Remove") //Warned you...
					var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
					s.set_up(5, 1, src)
					s.start()
					bcell.forceMove(get_turf(src.loc))
					qdel(bcell)
					bcell = null //Sanity.
					if(active_weapon)
						reattach_gun() //Put the gun back if it's out. No shooting if we don't have a cell!
						active_weapon.power_supply = null //No power cell anymore!
					to_chat(user, span_notice("You remove the cell from \the [src], destroying the battery."))
					update_icon()
					return
				else
					return
			else
				bcell.update_icon()
				bcell.forceMove(get_turf(src.loc))
				bcell = null
				if(active_weapon)
					reattach_gun() //Put the gun back if it's out. No shooting if we don't have a cell!
					active_weapon.power_supply = null //No power cell anymore!
				to_chat(user, span_notice("You remove the cell from \the [src]."))
				update_icon()
	else if(istype(W,/obj/item/multitool))
		var/new_color = tgui_color_picker(usr, "Choose a color to set the shield to!", "", effect_color)
		if(new_color)
			effect_color = new_color
	else
		return ..()

// TODO: EMAG ACT
// Perhaps make it so emagging the generator gives two options: One to rig the cell (stealthily) and one to disable the safeties (supercharge it)
// Disabling the safeties would make it a stronger variant but boost the 'damage_cost' perhaps. Dunno.
// We're an RP server so emags don't come into play except for random trash finds. Meaning it'd be RNG if you could 'supercharge' your shield genrator.
// This would kind of be like people being able to emag the NIFSoft for bloodletters & all the buffs that come with an emagged NIFSoft.
// Making it so emagging the weapon it comes with would also be a good idea. Different modes, perhaps?

/*
/obj/item/personal_shield_generator/emag_act(var/remaining_charges, var/mob/user)
	if(active_weapon)
		. = active_weapon.emag_act(user)
		update_icon()
	return
*/

//Gun stuff


/obj/item/personal_shield_generator/verb/toggle_shield()
	set name = "Toggle Shield"
	set category = "Object"

	var/mob/living/carbon/human/user = usr

	if(user.last_special > world.time)
		return
	user.last_special = world.time + 10 //No spamming!

	if(!bcell || !bcell.check_charge(generator_hit_cost) || !bcell.check_charge(generator_active_cost))
		to_chat(user, span_warning("You require a charged cell to do this!"))
		return

	if(!slot_check())
		to_chat(user, span_warning("You need to equip [src] before starting the shield up!"))
		return
	else
		if(shield_active)
			shield_active = !shield_active //Deactivate the shield!
			to_chat(user, span_warning("You deactive the shield!"))
			user.remove_modifiers_of_type(/datum/modifier/shield_projection)
			STOP_PROCESSING(SSobj, src)
			playsound(src, 'sound/weapons/saberoff.ogg', 50, 1) //Shield turning off! PLACEHOLDER
		else
			shield_active = !shield_active
			to_chat(user, span_warning("You activate the shield!"))
			user.remove_modifiers_of_type(/datum/modifier/shield_projection) //Just to make sure they aren't using two at once!
			user.add_modifier(modifier_type)
			user.update_modifier_visuals() //Forces coloration to WORK.
			START_PROCESSING(SSobj, src) //Let's only bother draining power when we're being used!
			playsound(src, 'sound/weapons/saberon.ogg', 50, 1) //Shield turning off! PLACEHOLDER
	update_icon()

/obj/item/personal_shield_generator/verb/weapon_toggle() //Make this work on Alt-Click
	set name = "Toggle Gun"
	set category = "Object"

	var/mob/living/carbon/human/user = usr

	if(user.last_special > world.time)
		return
	user.last_special = world.time + 10 //No spamming!

	if(!active_weapon)
		to_chat(user, span_warning("The gun is missing!"))
		return

	if(!bcell)
		to_chat(user, span_warning("The gun requires a power supply!"))
		return

	if(active_weapon.loc != src)
		reattach_gun(user) //Remove from their hands and back onto the defib unit
		return

	if(!slot_check())
		to_chat(user, span_warning("You need to equip [src] before taking out [active_weapon]."))
	else
		if(!usr.put_in_hands(active_weapon)) //Detach the gun into the user's hands
			to_chat(user, span_warning("You need a free hand to hold the gun!"))
		update_icon() //success

/obj/item/personal_shield_generator/process()
	if(!bcell) //They removed the battery midway.
		if(ishuman(loc)) //We on someone? Tell them it turned off.
			var/mob/living/carbon/human/user = loc
			to_chat(user, span_warning("The shield deactivates! An error message pops up on screen: 'Cell missing. Cell replacement required.'"))
			user.remove_modifiers_of_type(/datum/modifier/shield_projection)
		shield_active = 0
		STOP_PROCESSING(SSobj, src)
		update_icon()
		playsound(src, 'sound/weapons/saberoff.ogg', 50, 1) //Shield turning off! PLACEHOLDER
		return

	if(shield_active)
		if(bcell.rigged) //They turned it back on after it was rigged to go boom.
			if(ishuman(loc)) //Deactivate the shield, first. You're not getting reduced damage...
				var/mob/living/carbon/human/user = loc
				to_chat(user, span_warning("The shield deactivates, an error message popping up on screen: 'Cell Reactor Critically damaged. Cell replacement required.'"))
				user.remove_modifiers_of_type(/datum/modifier/shield_projection)

			if(active_weapon) //Retract the gun. There's about to be no cell anymore.
				reattach_gun()
				active_weapon.power_supply = null

			bcell.use(generator_active_cost) //Causes it to go boom.
			bcell = null
			shield_active = 0
			STOP_PROCESSING(SSobj, src)
			update_icon()
			return

		else //Normal operation.
			bcell.use(generator_active_cost)

	if(bcell.charge < generator_hit_cost || bcell.charge < generator_active_cost) //Out of charge...
		shield_active = 0
		if(ishuman(loc)) //We on someone? Tell them it turned off.
			var/mob/living/carbon/human/user = loc
			to_chat(user, span_warning("The shield deactivates, an error message popping up on screen: 'Cell out of charge.'"))
			user.remove_modifiers_of_type(/datum/modifier/shield_projection)
		STOP_PROCESSING(SSobj, src)
		update_icon()
		playsound(src, 'sound/weapons/saberoff.ogg', 50, 1) //Shield turning off! PLACEHOLDER
		return



//checks that the base unit is in the correct slot to be used
/obj/item/personal_shield_generator/proc/slot_check()
	var/mob/M = loc
	if(!istype(M))
		return 0 //not equipped

	if((slot_flags & SLOT_BACK) && M.get_equipped_item(slot_back) == src)
		return 1
	if((slot_flags & SLOT_BELT) && M.get_equipped_item(slot_belt) == src)
		return 1
	//RIGSuit compatability. This shouldn't be possible, however, except for select RIGs.
	if((slot_flags & SLOT_BACK) && M.get_equipped_item(slot_s_store) == src)
		return 1
	if((slot_flags & SLOT_BELT) && M.get_equipped_item(slot_s_store) == src)
		return 1

	return 0

/obj/item/personal_shield_generator/dropped(mob/user)
	..()
	reattach_gun(user) //A gun attached to a base unit should never exist outside of their base unit or the mob equipping the base unit

/obj/item/personal_shield_generator/proc/reattach_gun(mob/user)
	if(!active_weapon) return

	if(ismob(active_weapon.loc))
		var/mob/M = active_weapon.loc
		if(M.drop_from_inventory(active_weapon, src))
			to_chat(user, span_notice("\The [active_weapon] snaps back into the main unit."))
	else
		active_weapon.forceMove(src)

	update_icon()

//The gun

/obj/item/gun/energy/gun/generator //The gun attached to the personal shield generator.
	name = "generator gun"
	desc = "A gun that is attached to the battery of the personal shield generator."
	icon_state = "egunstun"
	item_state = null //so the human update icon uses the icon_state instead.
	fire_delay = 8
	use_external_power = TRUE
	cell_type = null //No cell! It runs off the cell in the shield_gen!

	projectile_type = /obj/item/projectile/beam/stun/med
	modifystate = "egunstun"

	firemodes = list(
		list(mode_name="stun", projectile_type=/obj/item/projectile/beam/stun/med, modifystate="egunstun", fire_sound='sound/weapons/Taser.ogg', charge_cost = 240),
		list(mode_name="lethal", projectile_type=/obj/item/projectile/beam, modifystate="egunkill", fire_sound='sound/weapons/Laser.ogg', charge_cost = 480),
		)

	var/obj/item/personal_shield_generator/shield_generator //The generator we are linked to!
	var/wielded = 0
	var/cooldown = 0
	var/busy = 0

/obj/item/gun/energy/gun/generator/New(newloc, obj/item/personal_shield_generator/shield_gen)
	..(newloc)
	shield_generator = shield_gen
	power_supply = shield_generator.bcell

/* //Unused. Use for large guns.
/obj/item/gun/energy/gun/generator/update_held_icon()
	var/mob/living/M = loc
	if(istype(M) && M.item_is_in_hands(src) && !M.hands_are_full())
		wielded = 1
		name = "[initial(name)] (wielded)"
	else
		wielded = 0
		name = initial(name)
	update_icon()
	..()
*/

/obj/item/gun/energy/gun/generator/proc/can_use(mob/user, mob/M)
	if(busy)
		return 0
	if(!check_charge(charge_cost))
		to_chat(user, span_warning("\The [src] doesn't have enough charge left to do that."))
		return 0
	if(!wielded && !isrobot(user))
		to_chat(user, span_warning("You need to wield the gun with both hands before you can use it on someone!"))
		return 0
	if(cooldown)
		to_chat(user, span_warning("\The [src] are re-energizing!"))
		return 0
	return 1

// TODO: EMP ACT
// The cell already gets hit and can have some nasty effects when EMP'd, so this isn't too much of a concern.

/*
/obj/item/gun/energy/gun/generator/emp_act(severity)
	..()
*/

/obj/item/gun/energy/gun/generator/dropped(mob/user)
	..() //update twohanding
	if(shield_generator)
		shield_generator.reattach_gun(user)

/obj/item/gun/energy/proc/check_charge(var/charge_amt) //In case using any other guns.
	return 0

/obj/item/gun/energy/proc/checked_use(var/charge_amt) //In case using any other guns.
	return 0

/obj/item/gun/energy/gun/generator/check_charge(var/charge_amt)
	return (shield_generator.bcell && shield_generator.bcell.check_charge(charge_amt))

/obj/item/gun/energy/gun/generator/checked_use(var/charge_amt)
	return (shield_generator.bcell && shield_generator.bcell.checked_use(charge_amt))



//VARIANTS.

/obj/item/personal_shield_generator/belt
	name = "personal shield generator"
	desc = "A personal shield generator."
	icon_state = "shieldpack_basic"
	item_state = "defibunit"
	w_class = ITEMSIZE_LARGE //No putting these in backpacks!
	slot_flags = SLOT_BELT
	has_weapon = 0 //No gun with the belt!

/obj/item/personal_shield_generator/belt/loaded
	bcell = /obj/item/cell/device/shield_generator

/obj/item/personal_shield_generator/belt/update_icon()
	if(shield_active)
		icon_state = "shieldpack_basic_on"
	else
		icon_state = "shieldpack_basic"

/obj/item/personal_shield_generator/belt/bruteburn //Example of a modified generator.
	modifier_type = /datum/modifier/shield_projection/bruteburn
/obj/item/personal_shield_generator/belt/bruteburn/loaded //If mapped in, ONLY put loaded ones down.
	bcell = /obj/item/cell/device/shield_generator

// Mining belts
/obj/item/personal_shield_generator/belt/mining
	name = "mining PSG"
	desc = "A personal shield generator designed for mining. It has a warning on the back: 'Do NOT expose the shield to stun-based weaponry.'"
	modifier_type = /datum/modifier/shield_projection/mining

/obj/item/personal_shield_generator/belt/mining/loaded
	bcell = /obj/item/cell/device/shield_generator

/obj/item/personal_shield_generator/belt/mining/update_icon()
	if(shield_active)
		icon_state = "shieldpack_mining_on"
	else
		icon_state = "shieldpack_mining"

/obj/item/borg/upgrade/shield_upgrade
	name = "mining PSG upgrade disk."
	desc = "A upgrade disk that, when slotted into a mining shield generator, upgrades the efficiency of the internal software, providing a stronger shield \
	in exchange for being weaker to stun-based weaponry."
	icon = 'icons/obj/objects_vr.dmi'
	icon_state = "modkit"
	w_class = ITEMSIZE_SMALL

/obj/item/personal_shield_generator/belt/mining/attackby(obj/item/W, mob/user, params)
	if(istype(W, /obj/item/borg/upgrade/shield_upgrade))
		if(modifier_type == /datum/modifier/shield_projection/mining/strong)
			to_chat(user, span_warning("This shield generator is already upgraded!"))
			return
		modifier_type = /datum/modifier/shield_projection/mining/strong
		upgraded = 1
		to_chat(user, span_notice("You upgrade the [src] with the [W]!"))
		user.drop_from_inventory(W)
		qdel(W)
	else
		..()


//Security belts

/obj/item/personal_shield_generator/belt/security
	name = "security PSG"
	desc = "A personal shield generator designed for security."
	modifier_type = /datum/modifier/shield_projection/security/weak

/obj/item/personal_shield_generator/belt/security/loaded
	bcell = /obj/item/cell/device/shield_generator

/obj/item/personal_shield_generator/belt/security/update_icon()
	if(shield_active)
		icon_state = "shieldpack_security_on"
	else
		icon_state = "shieldpack_security"

//Misc belts. Admin-spawn only atm.

/obj/item/personal_shield_generator/belt/adminbus
	desc = DEVELOPER_WARNING_NAME + " You REALLY should not see this. If you do, you have either been blessed or are about to be the target of some sick prank."
	modifier_type = /datum/modifier/shield_projection/admin
	generator_hit_cost = 0
	generator_active_cost = 0
	shield_active = 0
	damage_cost = 0
	bcell = /obj/item/cell/device/shield_generator

/obj/item/personal_shield_generator/belt/parry 	//The 'provides one second of pure immunity to brute/burn/halloss' belt.
	name = "PSG variant-P" 		//Not meant to be used in any serious capacity.
	desc = "A personal shield generator that sacrifices long-term usability in exchange for a strong, short-lived shield projection, enabling the user to be nigh \
	impervious for a second."
	modifier_type = /datum/modifier/shield_projection/parry
	generator_hit_cost = 0 //No cost for being hit.
	damage_cost = 0//No cost for blocking effects.
	generator_active_cost = 100 //However, it disables the tick immediately after being turned on.
	shield_active = 0
	bcell = /obj/item/cell/device/shield_generator/parry

// Backpacks. These are meant to be MUCH stronger in exchange for the fact that you are giving up a backpack slot.
// HOWEVER, be careful with these. They come loaded with a gun in them, so they shouldn't be handed out willy-nilly.

/obj/item/personal_shield_generator/security
	name = "security PSG"
	desc = "A personal shield generator designed for security. Comes with a built in defense pistol."
	modifier_type = /datum/modifier/shield_projection/security

/obj/item/personal_shield_generator/security/loaded
	bcell = /obj/item/cell/device/shield_generator/backpack

/obj/item/personal_shield_generator/security/strong
	modifier_type = /datum/modifier/shield_projection/security/strong

/obj/item/personal_shield_generator/security/strong/loaded
	bcell = /obj/item/cell/device/shield_generator/backpack

/obj/item/personal_shield_generator/security/update_icon()
	if(shield_active)
		icon_state = "shieldpack_security_on"
	else
		icon_state = "shieldpack_security"

//Power cells.
/obj/item/cell/device/shield_generator //The base power cell the shield gen comes with.
	name = "shield generator battery"
	desc = "A self charging battery which houses a micro-nuclear reactor. Takes a while to start charging."
	maxcharge = 2400
	self_recharge = TRUE
	charge_amount = 80 //After the charge_delay is over, charges the cell over 30 seconds.
	charge_delay = 600 //Takes a minute before it starts to recharge.

/obj/item/cell/device/shield_generator/backpack //The base power cell the backpack units come with. Double the charge vs the belt.
	maxcharge = 4800
	charge_amount = 160

/obj/item/cell/device/shield_generator/upgraded //A stronger version of the normal cell. Double the maxcharge, halved charge time.
	maxcharge = 4800
	charge_amount = 320
	charge_delay = 300

/obj/item/cell/device/shield_generator/parry //The cell for the 'parry' shield gen.
	maxcharge = 100
	charge_amount = 100
	charge_delay = 20 //Starts charging two seconds after it's discharged.
