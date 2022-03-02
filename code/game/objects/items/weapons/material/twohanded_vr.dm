//1R1S: Malady Blanche
/obj/item/weapon/material/twohanded/riding_crop/malady
	name = "Malady's riding crop"
	icon = 'icons/vore/custom_items_vr.dmi'
	item_icons = list(
				slot_l_hand_str = 'icons/vore/custom_items_left_hand_vr.dmi',
				slot_r_hand_str = 'icons/vore/custom_items_right_hand_vr.dmi',
				)
	desc = "An infernum made riding crop with Malady Blanche engraved in the shaft. It's a little worn from how many butts it has spanked."

/obj/item/weapon/material/twohanded/longsword
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


/obj/item/weapon/material/twohanded/saber/handle_shield(mob/user, var/damage, atom/damage_source = null, mob/attacker = null, var/def_zone = null, var/attack_text = "the attack")
	if (src.wielded == 1)
		if(unique_parry_check(user, attacker, damage_source) && prob(50))
			user.visible_message("<span class='danger'>\The [user] parries [attack_text] with \the [src]!</span>")
			playsound(src, 'sound/weapons/punchmiss.ogg', 50, 1)
		return 1
	return 0
