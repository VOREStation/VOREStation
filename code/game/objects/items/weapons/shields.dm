//** Shield Helpers
//These are shared by various items that have shield-like behaviour

//bad_arc is the ABSOLUTE arc of directions from which we cannot block. If you want to fix it to e.g. the user's facing you will need to rotate the dirs yourself.
/proc/check_shield_arc(mob/user, var/bad_arc, atom/damage_source = null, mob/attacker = null)
	//check attack direction
	var/attack_dir = 0 //direction from the user to the source of the attack
	if(istype(damage_source, /obj/item/projectile))
		var/obj/item/projectile/P = damage_source
		attack_dir = get_dir(get_turf(user), P.starting)
	else if(attacker)
		attack_dir = get_dir(get_turf(user), get_turf(attacker))
	else if(damage_source)
		attack_dir = get_dir(get_turf(user), get_turf(damage_source))

	if(!(attack_dir && (attack_dir & bad_arc)))
		return 1
	return 0

/proc/default_parry_check(mob/user, mob/attacker, atom/damage_source)
	//parry only melee attacks
	if(istype(damage_source, /obj/item/projectile) || (attacker && get_dist(user, attacker) > 1) || user.incapacitated())
		return 0

	//block as long as they are not directly behind us
	var/bad_arc = reverse_direction(user.dir) //arc of directions from which we cannot block
	if(!check_shield_arc(user, bad_arc, damage_source, attacker))
		return 0

	return 1

/obj/item/proc/unique_parry_check(mob/user, mob/attacker, atom/damage_source)	// An overrideable version of the above proc.
	return default_parry_check(user, attacker, damage_source)

/obj/item/shield
	name = "shield"
	var/base_block_chance = 50
	preserve_item = 1
	item_icons = list(
				slot_l_hand_str = 'icons/mob/items/lefthand_melee.dmi',
				slot_r_hand_str = 'icons/mob/items/righthand_melee.dmi',
				)

/obj/item/shield/handle_shield(mob/user, var/damage, atom/damage_source = null, mob/attacker = null, var/def_zone = null, var/attack_text = "the attack")
	if(user.incapacitated())
		return 0

	//block as long as they are not directly behind us
	var/bad_arc = reverse_direction(user.dir) //arc of directions from which we cannot block
	if(check_shield_arc(user, bad_arc, damage_source, attacker))
		if(prob(get_block_chance(user, damage, damage_source, attacker)))
			user.visible_message(span_danger("\The [user] blocks [attack_text] with \the [src]!"))
			return 1
	return 0

/obj/item/shield/proc/get_block_chance(mob/user, var/damage, atom/damage_source = null, mob/attacker = null)
	return base_block_chance

/obj/item/shield/riot
	name = "riot shield"
	desc = "A shield adept for close quarters engagement.  It's also capable of protecting from less powerful projectiles."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "riot"
	slot_flags = SLOT_BACK
	force = 5.0
	throwforce = 5.0
	throw_speed = 1
	throw_range = 4
	w_class = ITEMSIZE_LARGE
	origin_tech = list(TECH_MATERIAL = 2)
	matter = list(MAT_GLASS = 7500, MAT_STEEL = 1000)
	attack_verb = list("shoved", "bashed")
	var/cooldown = 0 //shield bash cooldown. based on world.time

/obj/item/shield/riot/handle_shield(mob/user, var/damage, atom/damage_source = null, mob/attacker = null, var/def_zone = null, var/attack_text = "the attack")
	if(user.incapacitated())
		return 0

	//block as long as they are not directly behind us
	var/bad_arc = reverse_direction(user.dir) //arc of directions from which we cannot block
	if(check_shield_arc(user, bad_arc, damage_source, attacker))
		if(prob(get_block_chance(user, damage, damage_source, attacker)))
			//At this point, we succeeded in our roll for a block attempt, however these kinds of shields struggle to stand up
			//to strong bullets and lasers.  They still do fine to pistol rounds of all kinds, however.
			if(istype(damage_source, /obj/item/projectile))
				var/obj/item/projectile/P = damage_source
				if((is_sharp(P) && P.armor_penetration >= 10) || istype(P, /obj/item/projectile/beam))
					//If we're at this point, the bullet/beam is going to go through the shield, however it will hit for less damage.
					//Bullets get slowed down, while beams are diffused as they hit the shield, so these shields are not /completely/
					//useless.  Extremely penetrating projectiles will go through the shield without less damage.
					user.visible_message(span_danger("\The [user]'s [src.name] is pierced by [attack_text]!"))
					if(P.armor_penetration < 30) //PTR bullets and x-rays will bypass this entirely.
						P.damage = P.damage / 2
					return 0
			//Otherwise, if we're here, we're gonna stop the attack entirely.
			user.visible_message(span_danger("\The [user] blocks [attack_text] with \the [src]!"))
			playsound(src, 'sound/weapons/Genhit.ogg', 50, 1)
			return 1
	return 0

/obj/item/shield/riot/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W, /obj/item/melee/baton))
		if(cooldown < world.time - 25)
			user.visible_message(span_warning("[user] bashes [src] with [W]!"))
			playsound(src, 'sound/effects/shieldbash.ogg', 50, 1)
			cooldown = world.time
	else
		..()

/*
 * Energy Shield
 */

/obj/item/shield/energy
	name = "energy combat shield"
	desc = "A shield capable of stopping most projectile and melee attacks. It can be retracted, expanded, and stored anywhere."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "eshield"
	item_state = "eshield"
	slot_flags = SLOT_EARS
	flags = NOCONDUCT
	force = 3.0
	throwforce = 5.0
	throw_speed = 1
	throw_range = 4
	w_class = ITEMSIZE_SMALL
	var/lrange = 1.5
	var/lpower = 1.5
	var/lcolor = "#006AFF"
	origin_tech = list(TECH_MATERIAL = 4, TECH_MAGNET = 3, TECH_ILLEGAL = 4)
	attack_verb = list("shoved", "bashed")
	var/active = 0
	item_icons = list(
			slot_l_hand_str = 'icons/mob/items/lefthand_melee.dmi',
			slot_r_hand_str = 'icons/mob/items/righthand_melee.dmi',
			)

/obj/item/shield/energy/handle_shield(mob/user)
	if(!active)
		return 0 //turn it on first!
	. = ..()

	if(.)
		var/datum/effect/effect/system/spark_spread/spark_system = new /datum/effect/effect/system/spark_spread()
		spark_system.set_up(5, 0, user.loc)
		spark_system.start()
		playsound(src, 'sound/weapons/blade1.ogg', 50, 1)

/obj/item/shield/energy/get_block_chance(mob/user, var/damage, atom/damage_source = null, mob/attacker = null)
	if(istype(damage_source, /obj/item/projectile))
		var/obj/item/projectile/P = damage_source
		if((is_sharp(P) && damage > 10) || istype(P, /obj/item/projectile/beam))
			return (base_block_chance - round(damage / 3)) //block bullets and beams using the old block chance
	return base_block_chance

/obj/item/shield/energy/attack_self(mob/living/user as mob)
	if ((CLUMSY in user.mutations) && prob(50))
		to_chat(user, span_warning("You beat yourself in the head with [src]."))
		user.take_organ_damage(5)
	active = !active
	if (active)
		force = 10
		update_icon()
		w_class = ITEMSIZE_LARGE
		slot_flags = null
		playsound(src, 'sound/weapons/saberon.ogg', 50, 1)
		to_chat(user, span_notice("\The [src] is now active."))

	else
		force = 3
		update_icon()
		w_class = ITEMSIZE_TINY
		slot_flags = SLOT_EARS
		playsound(src, 'sound/weapons/saberoff.ogg', 50, 1)
		to_chat(user, span_notice("\The [src] can now be concealed."))

	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		H.update_inv_l_hand()
		H.update_inv_r_hand()

	add_fingerprint(user)
	return

/obj/item/shield/energy/update_icon()
	var/mutable_appearance/blade_overlay = mutable_appearance(icon, "[icon_state]_blade")
	if(lcolor)
		blade_overlay.color = lcolor
		color = lcolor
	cut_overlays()		//So that it doesn't keep stacking overlays non-stop on top of each other
	if(active)
		add_overlay(blade_overlay)
		item_state = "[icon_state]_blade"
		set_light(lrange, lpower, lcolor)
	else
		color = "FFFFFF"
		set_light(0)
		item_state = "[icon_state]"

	if(ishuman(usr))
		var/mob/living/carbon/human/H = usr
		H.update_inv_l_hand()
		H.update_inv_r_hand()

/obj/item/shield/energy/AltClick(mob/living/user)
	if(!in_range(src, user))	//Basic checks to prevent abuse
		return
	if(user.incapacitated() || !istype(user))
		to_chat(user, span_warning("You can't do that right now!"))
		return
	if(tgui_alert(user, "Are you sure you want to recolor your shield?", "Confirm Recolor", list("Yes", "No")) == "Yes")
		var/energy_color_input = input(user,"","Choose Energy Color",lcolor) as color|null
		if(energy_color_input)
			lcolor = sanitize_hexcolor(energy_color_input)
		update_icon()

/obj/item/shield/energy/examine(mob/user)
	. = ..()
	. += span_notice("Alt-click to recolor it.")

/obj/item/shield/riot/tele
	name = "telescopic shield"
	desc = "An advanced riot shield made of lightweight materials that collapses for easy storage."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "teleriot0"
	slot_flags = null
	force = 3
	throwforce = 3
	throw_speed = 3
	throw_range = 4
	w_class = ITEMSIZE_NORMAL
	var/active = 0
/*
/obj/item/shield/energy/IsShield()
	if(active)
		return 1
	else
		return 0
*/
/obj/item/shield/riot/tele/attack_self(mob/living/user)
	active = !active
	icon_state = "teleriot[active]"
	playsound(src, 'sound/weapons/empty.ogg', 50, 1)

	if(active)
		force = 8
		throwforce = 5
		throw_speed = 2
		w_class = ITEMSIZE_LARGE
		slot_flags = SLOT_BACK
		to_chat(user, span_notice("You extend \the [src]."))
	else
		force = 3
		throwforce = 3
		throw_speed = 3
		w_class = ITEMSIZE_NORMAL
		slot_flags = null
		to_chat(user, span_notice("[src] can now be concealed."))

	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		H.update_inv_l_hand()
		H.update_inv_r_hand()

	add_fingerprint(user)
	return
