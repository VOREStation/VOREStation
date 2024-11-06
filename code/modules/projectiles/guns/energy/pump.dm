/* Contains the weapons that are station locked for expeditions
 * and can be hand pumped to charge their battery.
 *
 * Contains:
 *		Gun Locking Mechanism
 *		Expedition Frontier Phaser
 *		Expedition Frontier Carbine
 *		Expedition Frontier Rifle
 *		Holdout Phaser Pistol
 *		Holdout Phaser Bow
 */


/*
 * Gun Locking Mechanism
 */
/obj/item/gun/energy/locked
	req_access = list(access_armory) //for toggling safety
	var/locked = 1
	var/lockable = 1

/obj/item/gun/energy/locked/attackby(obj/item/I, mob/user)
	var/obj/item/card/id/id = I.GetID()
	if(istype(id) && lockable)
		if(check_access(id))
			locked = !locked
			to_chat(user, span_warning("You [locked ? "enable" : "disable"] the safety lock on \the [src]."))
		else
			to_chat(user, span_warning("Access denied."))
		user.visible_message(span_notice("[user] swipes \the [I] against \the [src]."))
	else
		return ..()

/obj/item/gun/energy/locked/emag_act(var/remaining_charges,var/mob/user)
	..()
	if(lockable)
		locked = !locked
		to_chat(user, span_warning("You [locked ? "enable" : "disable"] the safety lock on \the [src]!"))
		return 1

/obj/item/gun/energy/locked/special_check(mob/user)
	if(locked)
		var/turf/T = get_turf(src)
		if(T.z in using_map.station_levels)
			to_chat(user, span_warning("The safety device prevents the gun from firing this close to the facility."))
			return 0
	return ..()

/*
 * Expedition Frontier Phaser
 */
/obj/item/gun/energy/locked/frontier
	name = "frontier phaser"
	desc = "An extraordinarily rugged laser weapon, built to last and requiring effectively no maintenance. Includes a built-in crank \
	charger for recharging away from civilization. This one has a safety interlock that prevents firing while in proximity to the facility."
	description_fluff = "The NT Brand Model E2 Secured Phaser System, a specialty phaser that has an intergrated chip that prevents \
	the user from opperating the weapon within the vicinity of any NanoTrasen opperated outposts/stations/bases. However, this chip \
	can be disabled so the weapon CAN BE used in the vicinity of any NanoTrasen opperated outposts/stations/bases. The weapon doesn't \
	use traditional weapon power cells and instead works via a pump action that recharges the internal cells. It is a staple amongst \
	exploration personell who usually don't have the license to opperate a lethal weapon through NT and provides them with a weapon \
	that can be recharged away from civilization."
	icon_state = "phaserkill"
	item_state = "phaser"
	item_icons = list(slot_l_hand_str = 'icons/mob/items/lefthand_guns_vr.dmi', slot_r_hand_str = 'icons/mob/items/righthand_guns_vr.dmi', "slot_belt" = 'icons/inventory/belt/mob_vr.dmi')
	fire_sound = 'sound/weapons/laser2.ogg'
	origin_tech = list(TECH_COMBAT = 4, TECH_MAGNET = 2, TECH_POWER = 4)
	charge_cost = 300

	battery_lock = 1
	unacidable = TRUE

	var/recharging = 0
	var/phase_power = 75

	projectile_type = /obj/item/projectile/beam/blue

	modifystate = "phaserkill"
	firemodes = list(
		list(mode_name="lethal", fire_delay=12, projectile_type=/obj/item/projectile/beam/blue, modifystate="phaserkill", charge_cost = 300),
		list(mode_name="low-power", fire_delay=8, projectile_type=/obj/item/projectile/beam/weaklaser/blue, modifystate="phaserstun", charge_cost = 100),
	)

/obj/item/gun/energy/locked/frontier/unload_ammo(var/mob/user)
	if(recharging)
		return
	recharging = 1
	update_icon()
	user.visible_message(span_notice("[user] opens \the [src] and starts pumping the handle."), \
						span_notice("You open \the [src] and start pumping the handle."))
	while(recharging)
		if(!do_after(user, 10, src))
			break
		playsound(src,'sound/items/change_drill.ogg',25,1)
		user.hud_used.update_ammo_hud(user, src)
		if(power_supply.give(phase_power) < phase_power)
			break

	recharging = 0
	update_icon()
	user.hud_used.update_ammo_hud(user, src) // Update one last time once we're finished!

/obj/item/gun/energy/locked/frontier/update_icon()
	if(recharging)
		icon_state = "[initial(icon_state)]_pump"
		update_held_icon()
		return
	..()

/obj/item/gun/energy/locked/frontier/emp_act(severity)
	return ..(severity+2)

/obj/item/gun/energy/locked/frontier/ex_act() //|rugged|
	return

/obj/item/gun/energy/locked/frontier/unlocked
	desc = "An extraordinarily rugged laser weapon, built to last and requiring effectively no maintenance. Includes a \
	built-in crank charger for recharging away from civilization."
	req_access = newlist() //for toggling safety
	locked = 0
	lockable = 0

/*
 * Expedition Frontier Carbine
 */
/obj/item/gun/energy/locked/frontier/carbine
	name = "frontier carbine"
	desc = "An ergonomically improved version of the venerable frontier phaser, the carbine is a fairly new weapon, and has only been \
	produced in limited numbers so far. Includes a built-in crank charger for recharging away from civilization. This one has a safety \
	interlock that prevents firing while in proximity to the facility."
	description_fluff = "The NT Brand Model AT2 Secured Phaser System, a specialty phaser that has an intergrated chip that prevents \
	the user from opperating the weapon within the vicinity of any NanoTrasen opperated outposts/stations/bases. However, this chip can \
	be disabled so the weapon CAN BE used in the vicinity of any NanoTrasen opperated outposts/stations/bases. The weapon doesn't use \
	traditional weapon power cells and instead works via a pump action that recharges the internal cells. It is a staple amongst exploration \
	personell who usually don't have the license to opperate a lethal weapon through NT and provides them with a weapon that can be \
	recharged away from civilization."
	icon_state = "phcarbinekill"
	item_state = "energykill"
	item_icons = list(slot_l_hand_str = 'icons/mob/items/lefthand_guns.dmi', slot_r_hand_str = 'icons/mob/items/righthand_guns.dmi')
	phase_power = 150

	modifystate = "phcarbinekill"
	firemodes = list(
		list(mode_name="lethal", fire_delay=8, projectile_type=/obj/item/projectile/beam/blue, modifystate="phcarbinekill", charge_cost = 300),
		list(mode_name="low-power", fire_delay=5, projectile_type=/obj/item/projectile/beam/weaklaser/blue, modifystate="phcarbinestun", charge_cost = 100),
	)

/obj/item/gun/energy/locked/frontier/carbine/update_icon()
	if(recharging)
		icon_state = "[modifystate]_pump"
		update_held_icon()
		return
	..()

/obj/item/gun/energy/locked/frontier/carbine/unlocked
	desc = "An ergonomically improved version of the venerable frontier phaser, the carbine is a fairly new weapon, and has only been \
	produced in limited numbers so far. Includes a built-in crank charger for recharging away from civilization."
	req_access = newlist() //for toggling safety
	locked = 0
	lockable = 0

/*
 * Expedition Frontier Rifle
 */
/obj/item/gun/energy/locked/frontier/rifle
	name = "frontier marksman rifle"
	desc = "A much larger, heavier weapon than the typical frontier-type weapons, this DMR can be fired both from the hip, and in scope. \
	Includes a built-in crank charger for recharging away from civilization. Unlike other frontier-type weapons, this model lacks a non-lethal option. \
	This one has a safety interlock that prevents firing while in proximity to the facility."
	description_fluff = "The NT Brand Model LR10 Secured Phaser System, a specialty phaser that has an intergrated chip that prevents \
	the user from opperating the weapon within the vicinity of any NanoTrasen opperated outposts/stations/bases. However, this chip can \
	be disabled so the weapon CAN BE used in the vicinity of any NanoTrasen opperated outposts/stations/bases. The weapon doesn't use \
	traditional weapon power cells and instead works via a pump action that recharges the internal cells. It is a staple amongst exploration \
	personell who usually don't have the license to opperate a lethal weapon through NT and provides them with a weapon that can be \
	recharged away from civilization."
	icon_state = "phrifledmr"
	item_state = "lsniper"
	item_state_slots = list(slot_r_hand_str = "lsniper", slot_l_hand_str = "lsniper")
	wielded_item_state = "lsniper-wielded"
	actions_types = list(/datum/action/item_action/use_scope)
	w_class = ITEMSIZE_LARGE
	item_icons = list(slot_l_hand_str = 'icons/mob/items/lefthand_guns.dmi', slot_r_hand_str = 'icons/mob/items/righthand_guns.dmi')
	accuracy = -15 //better than most snipers but still has penalty
	scoped_accuracy = 40
	one_handed_penalty = 50 // The weapon itself is heavy, and the long barrel makes it hard to hold steady with just one hand.
	phase_power = 150 //efficient crank charger
	fire_sound = null
	charge_cost = 600
	fire_delay = 35

	projectile_type = /obj/item/projectile/beam/sniper
	modifystate = "phrifledmr"
	firemodes = list(
		list(mode_name="sniper", fire_delay=35, projectile_type=/obj/item/projectile/beam/sniper, modifystate="phrifledmr", charge_cost = 600),
		list(mode_name="lethal", fire_delay=12, projectile_type=/obj/item/projectile/beam, modifystate="phriflekill", charge_cost = 200),
	)

/obj/item/gun/energy/locked/frontier/rifle/ui_action_click(mob/user, actiontype)
	scope()

/obj/item/gun/energy/locked/frontier/rifle/verb/scope()
	set category = "Object"
	set name = "Use Scope"
	set popup_menu = 1

	toggle_scope(2.0)

/obj/item/gun/energy/locked/frontier/rifle/update_icon()
	if(recharging)
		icon_state = "[modifystate]_pump"
		update_held_icon()
		return
	..()

/obj/item/gun/energy/locked/frontier/rifle/unlocked
	desc = "A much larger, heavier weapon than the typical frontier-type weapons, this DMR can be fired both from the hip, and in scope. \
	Unlike other frontier-type weapons, this model lacks a non-lethal option. Includes a built-in crank charger for recharging away from civilization."
	req_access = newlist() //for toggling safety
	locked = 0
	lockable = 0

/*
 * Holdout Phaser Pistol
 */
/obj/item/gun/energy/locked/frontier/holdout
	name = "holdout frontier phaser"
	desc = "An minaturized weapon designed for the purpose of expeditionary support to defend themselves on the field. Includes a built-in crank charger for \
	recharging away from civilization. This one has a safety interlock that prevents firing while in proximity to the facility."
	description_fluff = null
	icon_state = "holdoutkill"
	item_state = null
	phase_power = 100
	slot_flags = SLOT_BELT|SLOT_HOLSTER
	w_class = ITEMSIZE_SMALL
	charge_cost = 600
	modifystate = "holdoutkill"
	firemodes = list(
		list(mode_name="lethal", fire_delay=12, projectile_type=/obj/item/projectile/beam/blue, modifystate="holdoutkill", charge_cost = 600),
		list(mode_name="low-power", fire_delay=8, projectile_type=/obj/item/projectile/beam/weaklaser/blue, modifystate="holdoutstun", charge_cost = 200),
		list(mode_name="stun", fire_delay=12, projectile_type=/obj/item/projectile/beam/stun/med, modifystate="holdoutshock", charge_cost = 300),
	)

/obj/item/gun/energy/locked/frontier/holdout/unlocked
	desc = "An minaturized weapon designed for the purpose of expeditionary support to defend themselves on the field. Includes a built-in \
	crank charger for recharging away from civilization."
	req_access = newlist() //for toggling safety
	locked = 0
	lockable = 0

/*
 * Holdout Phaser Bow
 */
/obj/item/gun/energy/locked/frontier/handbow
	name = "phaser handbow"
	desc = "An minaturized weapon that fires a bolt of energy. Includes a built-in crank charger for recharging away from civilization. \
	This one has a safety interlock that prevents firing while in proximity to the facility."
	description_fluff = null
	icon_state = "handbowkill"
	item_state = null
	phase_power = 100
	w_class = ITEMSIZE_SMALL
	charge_cost = 600
	modifystate = "handbowkill"
	firemodes = list(
		list(mode_name="lethal", fire_delay=12, projectile_type=/obj/item/projectile/energy/bow/heavy, modifystate="handbowkill", charge_cost = 600),
		list(mode_name="low-power", fire_delay=8, projectile_type=/obj/item/projectile/energy/bow, modifystate="handbowstun", charge_cost = 200),
	)

/obj/item/gun/energy/locked/frontier/handbow/unlocked
	desc = "An minaturized weapon that fires a bolt of energy. Includes a built-in crank charger for recharging away from civilization."
	req_access = newlist() //for toggling safety
	locked = 0
	lockable = 0
