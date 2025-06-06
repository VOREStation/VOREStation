/* Weapons
 * Contains:
 *		Sword
 *		Classic Baton
 *		Telescopic Baton
 */

/*
 * Classic Baton
 */

/obj/item/melee
	name = "weapon"
	desc = "Murder device."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "baton"
	slot_flags = SLOT_BELT
	force = 10
	drop_sound = 'sound/items/drop/metalweapon.ogg'

/obj/item/melee/classic_baton
	name = "police baton"
	desc = "A wooden truncheon for beating criminal scum."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "baton"
	item_state = "classic_baton"
	slot_flags = SLOT_BELT
	force = 10
	drop_sound = 'sound/items/drop/crowbar.ogg'
	pickup_sound = 'sound/items/pickup/crowbar.ogg'

/obj/item/melee/classic_baton/attack(mob/M as mob, mob/living/user as mob)
	if ((CLUMSY in user.mutations) && prob(50))
		to_chat(user, span_warning("You club yourself over the head."))
		user.Weaken(3 * force)
		if(ishuman(user))
			var/mob/living/carbon/human/H = user
			H.apply_damage(2*force, BRUTE, BP_HEAD)
		else
			user.take_organ_damage(2*force)
		return
	return ..()

//Telescopic baton
/obj/item/melee/telebaton
	name = "telescopic baton"
	desc = "A compact yet rebalanced personal defense weapon. Can be concealed when folded."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "telebaton0"
	item_state = "telebaton0"
	slot_flags = SLOT_BELT
	w_class = ITEMSIZE_SMALL
	force = 3
	drop_sound = 'sound/items/drop/crowbar.ogg'
	pickup_sound = 'sound/items/pickup/crowbar.ogg'
	var/on = 0

/obj/item/melee/telebaton/attack_self(mob/user as mob)
	on = !on
	if(on)
		user.visible_message(span_warning("With a flick of their wrist, [user] extends their telescopic baton."),\
		span_warning("You extend the baton."),\
		"You hear an ominous click.")
		icon_state = "telebaton1"
		item_state = icon_state
		w_class = ITEMSIZE_NORMAL
		force = 15//quite robust
		attack_verb = list("smacked", "struck", "slapped")
	else
		user.visible_message(span_infoplain(span_bold("\The [user]") + " collapses their telescopic baton."),\
		span_notice("You collapse the baton."),\
		"You hear a click.")
		icon_state = "telebaton0"
		item_state = icon_state
		w_class = ITEMSIZE_SMALL
		force = 3//not so robust now
		attack_verb = list("hit", "punched")

	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		H.update_inv_l_hand()
		H.update_inv_r_hand()

	playsound(src, 'sound/weapons/empty.ogg', 50, 1)
	add_fingerprint(user)

	if(blood_overlay && forensic_data?.has_blooddna()) //updates blood overlay, if any
		cut_overlays()

		var/icon/I = new /icon(src.icon, src.icon_state)
		I.Blend(new /icon('icons/effects/blood.dmi', rgb(255,255,255)),ICON_ADD)
		I.Blend(new /icon('icons/effects/blood.dmi', "itemblood"),ICON_MULTIPLY)
		blood_overlay = I

		add_overlay(blood_overlay)

	return

/obj/item/melee/telebaton/attack(mob/target as mob, mob/living/user as mob)
	if(on)
		if ((CLUMSY in user.mutations) && prob(50))
			to_chat(user, span_warning("You club yourself over the head."))
			user.Weaken(3 * force)
			if(ishuman(user))
				var/mob/living/carbon/human/H = user
				H.apply_damage(2*force, BRUTE, BP_HEAD)
			else
				user.take_organ_damage(2*force)
			return
		if(..())
			//playsound(src, "swing_hit", 50, 1, -1)
			return
	else
		return ..()
