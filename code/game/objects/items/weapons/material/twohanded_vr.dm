//1R1S: Malady Blanche
/obj/item/material/twohanded/riding_crop/malady
	name = "Malady's riding crop"
	icon = 'icons/vore/custom_items_vr.dmi'
	item_icons = list(
				slot_l_hand_str = 'icons/vore/custom_items_left_hand_vr.dmi',
				slot_r_hand_str = 'icons/vore/custom_items_right_hand_vr.dmi',
				)
	desc = "An infernum made riding crop with Malady Blanche engraved in the shaft. It's a little worn from how many butts it has spanked."

/obj/item/material/twohanded/longsword
    w_class = ITEMSIZE_NORMAL
    name = "longsword"
    desc = "a more elegant weapon from a more civilised age"
    icon= 'icons/obj/weapons_vr.dmi'
    icon_state = "longsword"
    base_icon = "longsword"
    item_icons = list(
			slot_l_hand_str = 'icons/mob/items/lefthand_melee_vr.dmi',
			slot_r_hand_str = 'icons/mob/items/righthand_melee_vr.dmi',
			)
    item_state = "saber"
    unwielded_force_divisor = 0.1
    force_divisor = 0.3
    attack_verb = list("attacked", "slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")
    edge = TRUE
    sharp = TRUE

/obj/item/material/twohanded/saber/handle_shield(mob/user, var/damage, atom/damage_source = null, mob/attacker = null, var/def_zone = null, var/attack_text = "the attack")
	if (src.wielded == 1)
		if(unique_parry_check(user, attacker, damage_source) && prob(50))
			user.visible_message(span_danger("\The [user] parries [attack_text] with \the [src]!"))
			playsound(src, 'sound/weapons/punchmiss.ogg', 50, 1)
		return 1
	return 0

/obj/item/material/twohanded/staff
	w_class = ITEMSIZE_LARGE
	default_material = MAT_WOOD
	name = "staff"
	desc = "A sturdy length of metal or wood. A common traveler's aid mostly used for support or probing unstable ground, but also a fairly effective weapon in a pinch."
	description_info = "When wielded with two hands, staves can be used to parry incoming melee attacks. Being on disarm intent also grants them an added chance to stun or knock down opponents, and increases your chances of parrying an attack."
	icon = 'icons/obj/weapons_vr.dmi'
	icon_state = "mat_staff"
	base_icon = "mat_staff"
	item_state = "mat_staff"
	item_icons = list(
			slot_l_hand_str = 'icons/mob/items/lefthand_melee_vr.dmi',
			slot_r_hand_str = 'icons/mob/items/righthand_melee_vr.dmi',
			)
	force_wielded = 18	//a bit stronger than a stun baton
	force_divisor = 0.45
	unwielded_force_divisor = 0.1
	var/base_parry_chance = 20
	var/disarm_defense = 1.5	//bonus multiplier to parry rate when in disarm stance
	var/stun_chance = 25	//chance to weaken an opponent when used in disarm stance only, remembering that disarm also halves damage dealt
	var/stun_duration = 2
	attack_verb = list("struck","smashed","thumped","thrashed","beaten","slammed","battered")
	edge = FALSE
	sharp = FALSE

/obj/item/material/twohanded/staff/handle_shield(mob/user, var/damage, atom/damage_source = null, mob/attacker = null, var/def_zone = null, var/attack_text = "the attack")
	var/parry_chance
	if(istype(damage_source, /obj/item/projectile))	//can't block ranged attacks, only melee!
		return 0
	if(src.wielded == 1)
		if(user.a_intent == I_DISARM)
			parry_chance = base_parry_chance * disarm_defense
		else
			parry_chance = base_parry_chance
		if(unique_parry_check(user, attacker, damage_source) && prob(parry_chance))
			user.visible_message(span_danger("\The [user] parries [attack_text] with \the [src]!"))
			playsound(src, 'sound/weapons/punchmiss.ogg', 50, 1)
			return 1
	return 0

/obj/item/material/twohanded/staff/apply_hit_effect(mob/living/target, mob/living/user, var/hit_zone)
	. = ..()
	if(src.wielded == 1 && user.a_intent == I_DISARM && prob(stun_chance))
		target.Weaken(stun_duration)
		user.visible_message(span_danger("\The [user] trips [target] with \the [src]!"))
