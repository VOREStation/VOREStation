// ported from Citadel-Station-13/Citadel-Station-13-RP#3015, basically all the work done by silicons
// thanks silicons

//TODO: Two handed component. Update this file in its ENTIRETY to be 1:1 with TG.

/*********************Mining Hammer****************/
/obj/item/kinetic_crusher
	icon = 'icons/obj/mining_vr.dmi'
	icon_state = "crusher"
	item_state = "crusher0"
	item_icons = list(
		slot_l_hand_str = 'icons/mob/items/lefthand_melee_vr.dmi',
		slot_r_hand_str = 'icons/mob/items/righthand_melee_vr.dmi'
		)
	name = "proto-kinetic crusher"
	desc = "An early design of the proto-kinetic accelerator, it is little more than an combination of various mining tools cobbled together, forming a high-tech club. \
	While it is an effective mining tool, it did little to aid any but the most skilled and/or suicidal miners against local fauna."
	force = 25
	w_class = ITEMSIZE_LARGE
	slot_flags = SLOT_BACK
	throwforce = 5
	throw_speed = 4
	armor_penetration = 10
	hitsound = 'sound/weapons/bladeslice.ogg'
	attack_verb = list("smashed", "crushed", "cleaved", "chopped", "pulped")
	sharp = FALSE //crushing damage
	edge = FALSE
	embed_chance = FALSE
	actions_types = list(/datum/action/item_action/toggle_light)
	var/charged = TRUE
	var/charge_time = 15
	var/detonation_damage = 50 //75
	var/backstab_bonus = 30 //105
	/// does it have a light icon
	var/integ_light_icon = TRUE
	/// is the light on?
	var/integ_light_on = FALSE
	var/brightness_on = 7
	var/wielded = FALSE // track wielded status on item
	/// is this emagged? (unlocks !!!FUN!!!)
	var/emagged = 0
	/// Damage penalty factor to detonation damage to non simple mobs
	var/human_damage_nerf = 0.25
	/// Damage penalty factor to backstab bonus damage to non simple mobs
	var/human_backstab_nerf = 0.25
	/// damage buff for throw impacts
	var/thrown_bonus = 35 //140
	/// do we need to be wielded?
	var/requires_wield = FALSE
	/// do we have a charge overlay?
	var/charge_overlay = TRUE
	/// do we update item state?
	var/update_item_state = FALSE

/obj/item/kinetic_crusher/cyborg //probably give this a unique sprite later
	desc = "An integrated version of the standard kinetic crusher with a grinded down axe head to dissuade mis-use against crewmen. Deals damage equal to the standard crusher against creatures, however."
	force = 10 //wouldn't want to give a borg a 20 brute melee weapon unemagged now would we
	detonation_damage = 60
	wielded = 1

/obj/item/kinetic_crusher/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/conflict_checking, CONFLICT_ELEMENT_CRUSHER)

/obj/item/kinetic_crusher/Destroy()
	return ..()

/obj/item/kinetic_crusher/emag_act()
	. = ..()
	if(emagged)
		return
	emagged = TRUE
	desc = desc + " The destabilizer module occasionally sparks and glows a menacing red."

/obj/item/kinetic_crusher/proc/can_mark(mob/living/victim)
	if(emagged)
		return TRUE
	return !ishuman(victim) && !issilicon(victim)

/// triggered on wield of two handed item
/obj/item/kinetic_crusher/proc/on_wield(obj/item/source, mob/user)
	wielded = TRUE

/// triggered on unwield of two handed item
/obj/item/kinetic_crusher/proc/on_unwield(obj/item/source, mob/user)
	wielded = FALSE

/obj/item/kinetic_crusher/examine(mob/living/user)
	. = ..()
	. += span_notice("Mark a[emagged ? "nything": " creature"] with the destabilizing force, then hit them in melee to do <b>[force + detonation_damage]</b> damage.")
	. += span_notice("Does <b>[force + detonation_damage + backstab_bonus]</b> damage if the target is backstabbed, instead of <b>[force + detonation_damage]</b>.")

/obj/item/kinetic_crusher/attack(mob/living/target, mob/living/carbon/user)
	if(!wielded && requires_wield)
		to_chat(user, span_warning("[src] is too heavy to use with one hand."))
		return
	..()

/obj/item/kinetic_crusher/afterattack(atom/target, mob/living/user, proximity_flag, clickparams)
	. = ..()

	if(requires_wield && !wielded)
		return
	if(!proximity_flag && charged)//Mark a target, or mine a tile.
		var/turf/proj_turf = user.loc
		if(!isturf(proj_turf))
			return
		var/obj/item/projectile/destabilizer/D = new /obj/item/projectile/destabilizer(proj_turf)
		D.preparePixelProjectile(target, user, clickparams)
		D.firer = user
		D.hammer_synced = src
		playsound(user, 'sound/weapons/plasma_cutter.ogg', 100, 1)
		D.fire()
		charged = FALSE
		update_icon()
		addtimer(CALLBACK(src, PROC_REF(Recharge)), charge_time)
		return
	if(proximity_flag && isliving(target))
		detonate(target, user)

/obj/item/kinetic_crusher/proc/detonate(mob/living/L, mob/living/user, thrown = FALSE)
	var/datum/modifier/crusher_mark/CM = L.get_modifier_of_type(/datum/modifier/crusher_mark)
	if(!CM || CM.hammer_synced != src)
		return
	if(!QDELETED(L))
		L.remove_modifiers_of_type(/datum/modifier/crusher_mark)
		new /obj/effect/temp_visual/kinetic_blast(get_turf(L))
		var/backstab_dir = get_dir(user, L)
		var/def_check = L.getarmor(null, "bomb")
		var/detonation_damage = src.detonation_damage * (!ishuman(L)? 1 : human_damage_nerf)
		var/backstab_bonus = src.backstab_bonus * (!ishuman(L)? 1 : human_backstab_nerf)
		var/thrown_bonus = thrown? (src.thrown_bonus * (!ishuman(L)? 1 : human_damage_nerf)) : 0
		if(thrown? (get_dir(src, L) & L.dir) : ((user.dir & backstab_dir) && (L.dir & backstab_dir)))
			L.apply_damage(detonation_damage + backstab_bonus + thrown_bonus, BRUTE, blocked = def_check)
			playsound(src, 'sound/weapons/kenetic_accel.ogg', 100, 1) //Seriously who spelled it wrong
		else
			L.apply_damage(detonation_damage + thrown_bonus, BRUTE, blocked = def_check)

/obj/item/kinetic_crusher/throw_impact(atom/hit_atom, speed)
	. = ..()
	if(!isliving(hit_atom))
		return
	var/mob/living/L = hit_atom
	if(L.has_modifier_of_type(/datum/modifier/crusher_mark))
		detonate(L, thrower, TRUE)

/obj/item/kinetic_crusher/proc/Recharge()
	if(!charged)
		charged = TRUE
		update_icon()
		playsound(src.loc, 'sound/weapons/kenetic_reload.ogg', 60, 1)

/obj/item/kinetic_crusher/ui_action_click(mob/user, actiontype)
	integ_light_on = !integ_light_on
	playsound(src, 'sound/weapons/empty.ogg', 100, TRUE)
	update_brightness(user)
	update_icon()

/obj/item/kinetic_crusher/proc/update_brightness(mob/user = null)
	if(integ_light_on)
		set_light(brightness_on)
	else
		set_light(0)

/obj/item/kinetic_crusher/update_icon()
	. = ..()
	cut_overlay("[icon_state]_uncharged")
	cut_overlay("[icon_state]_lit")
	if(charge_overlay)
		if(!charged)
			add_overlay("[icon_state]_uncharged")
	if(integ_light_icon)
		if(integ_light_on)
			add_overlay("[icon_state]_lit")

/obj/item/kinetic_crusher/glaive
	name = "kinetic glaive"
	icon_state = "crusher-glaive"
	force = 20
	detonation_damage = 20 // 40
	backstab_bonus = 30 // 60
	reach = 2
	slot_flags = SLOT_BELT
	w_class = ITEMSIZE_NORMAL
	requires_wield = FALSE


/obj/item/kinetic_crusher/machete
	// general purpose. cleaves though
	name = "proto-kinetic machete"
	desc = "A scaled down version of a proto-kinetic crusher, used by people who don't want to lug around an axe-hammer."
	icon_state = "glaive-machete"
	item_icons = list(
			slot_l_hand_str = 'icons/mob/items/lefthand_melee_vr.dmi',
			slot_r_hand_str = 'icons/mob/items/righthand_melee_vr.dmi',
			)
	item_state = "c-machete"
	w_class = ITEMSIZE_NORMAL
	attack_verb = list("cleaved", "chopped", "pulped", "stabbed", "skewered")
	can_cleave = TRUE
	requires_wield = FALSE
	sharp = TRUE
	edge = TRUE
	// yeah yeah buff but polaris mobs are meatwalls.
	force = 24
	detonation_damage = 36 // 60
	backstab_bonus = 80 // 140
	thrown_bonus = 20 // 160
	update_item_state = FALSE
	slot_flags = SLOT_BELT




/obj/item/kinetic_crusher/machete/gauntlets
	// did someone say single target damage
	name = "\improper proto-kinetic gear"
	desc = "A pair of scaled-down proto-kinetic crusher destabilizer modules shoved into gauntlets and greaves, used by those who wish to spit in the eyes of God."
	hitsound = 'sound/weapons/resonator_blast.ogg'
	embed_chance = 0
	icon_state = "crusher-hands"
	item_state = "c-gauntlets"
	attack_verb = list("bashed", "kicked", "punched", "struck", "axe kicked", "uppercut", "cross-punched", "jabbed", "hammerfisted", "roundhouse kicked")
	integ_light_icon = FALSE
	w_class = ITEMSIZE_NORMAL
	can_cleave = FALSE
	requires_wield = TRUE
	armor_penetration = 0
	force = 35
	detonation_damage = 65 // 100
	backstab_bonus = 25 // 125
	var/obj/item/offhand/crushergauntlets/offhand
	slot_flags = null

/obj/item/kinetic_crusher/machete/gauntlets/equipped()
	. = ..()
	START_PROCESSING(SSprocessing, src)

/obj/item/kinetic_crusher/machete/gauntlets/dropped(mob/user)
	ready_toggle(TRUE)
	STOP_PROCESSING(SSprocessing, src)
	. = ..()

/obj/item/kinetic_crusher/machete/gauntlets/Destroy()
	. = ..()
	STOP_PROCESSING(SSprocessing, src)

/obj/item/kinetic_crusher/machete/gauntlets/attack_self(mob/user)
	ready_toggle()

/obj/item/kinetic_crusher/machete/gauntlets/process()
	if(wielded) // are we supposed to be wielded
		if(!offhand) // does our offhand exist
			ready_toggle(TRUE) // no? well, shit

/// toggles twohand. if forced is true, forces an unready state
/obj/item/kinetic_crusher/machete/gauntlets/proc/ready_toggle(var/forced = 0)
	var/mob/living/M = loc
	if(istype(M) && forced == 0)
		if(M.can_wield_item(src) && src.is_held_twohanded(M))
			wield(M)
		else
			unwield(M)
	else
		unwield(M)

/obj/item/kinetic_crusher/machete/gauntlets/proc/wield(var/mob/living/M)
	name = initial(name)
	wielded = TRUE
	to_chat(M, span_notice("You ready [src]."))
	var/obj/item/offhand/crushergauntlets/O = new(M)
	O.name = "[name] - readied"
	O.desc = "As much as you'd like to punch things with one hand, [src] is far too unwieldy for that."
	O.linked = src
	M.put_in_inactive_hand(O)
	offhand = O

/obj/item/kinetic_crusher/machete/gauntlets/proc/unwield(var/mob/living/M)
	to_chat(M, span_notice("You unready [src]."))
	name = "[initial(name)] (unreadied)"
	wielded = FALSE
	if(offhand)
		QDEL_NULL(offhand)

/obj/item/offhand
	icon = 'icons/obj/weapons.dmi'
	icon_state = "offhand"
	name = "offhand that shouldn't exist doo dee doo"
	w_class = ITEMSIZE_NO_CONTAINER

/obj/item/offhand/crushergauntlets
	var/obj/item/kinetic_crusher/machete/gauntlets/linked

/obj/item/offhand/crushergauntlets/dropped(mob/user)
	SHOULD_CALL_PARENT(FALSE)
	if(linked.wielded)
		linked.ready_toggle(TRUE)

/obj/item/kinetic_crusher/machete/gauntlets/rig
	name = "\improper mounted proto-kinetic gear"
	var/obj/item/rig_module/gauntlets/storing_module

/obj/item/kinetic_crusher/machete/gauntlets/rig/dropped(mob/user)
	. = ..(user)
	if(storing_module)
		src.forceMove(storing_module)
		storing_module.stored_gauntlets = src
		user.visible_message(
			span_notice("[user] retracts [src] with a click and a hiss."),
			span_notice("You retract [src] with a click and a hiss."),
			span_notice("You hear a click and a hiss.")
			)
		playsound(src, 'sound/items/helmetdeploy.ogg', 40, 1)
		storing_module.active = FALSE
	else
		QDEL_NULL(src)

// gimmicky backup for throwing
/obj/item/kinetic_crusher/machete/dagger
	name = "proto-kinetic dagger"
	desc = "A scaled down version of a proto-kinetic machete, usually used in a last ditch scenario."
	icon_state = "glaive-dagger"
	item_icons = list(
			slot_l_hand_str = 'icons/mob/items/lefthand_melee_vr.dmi',
			slot_r_hand_str = 'icons/mob/items/righthand_melee_vr.dmi',
			)
	item_state = "c-knife"
	w_class = ITEMSIZE_SMALL
	requires_wield = FALSE
	charge_overlay = FALSE
	charge_time = 10 // lowered charge in return for lowered damage
	force = 18
	armor_penetration = 50
	detonation_damage = 27 // 45
	backstab_bonus = 30 // 75
	// gimmick mode
	thrown_bonus = 60 // 135 but you drop your knife because you threw it



//destablizing force
/obj/item/projectile/destabilizer
	name = "destabilizing force"
	icon_state = "pulse1"
	nodamage = TRUE
	damage = 0 //We're just here to mark people. This is still a melee weapon.
	damage_type = BRUTE
	check_armour = "bomb"
	range = 6
	accuracy = INFINITY	// NO.
	var/obj/item/kinetic_crusher/hammer_synced

/obj/item/projectile/destabilizer/Destroy()
	hammer_synced = null
	return ..()

/obj/item/projectile/destabilizer/on_impact(var/atom/A)
	if(ismineralturf(A))
		var/turf/simulated/mineral/M = A
		new /obj/effect/temp_visual/kinetic_blast(M)
		M.GetDrilled(firer)
	. = ..()

/obj/item/projectile/destabilizer/on_hit(atom/target, blocked = FALSE)
	if(isliving(target))
		var/mob/living/L = target
		if(hammer_synced.can_mark(L))
			L.add_modifier(/datum/modifier/crusher_mark, 30 SECONDS, firer, TRUE)
	..()
