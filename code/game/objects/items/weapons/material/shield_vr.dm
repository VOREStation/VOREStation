/obj/item/weapon/material/sword/shield
	name = "makeshift shield"
	desc = "A makeshift shield"
	icon = 'icons/obj/weapons.dmi'
	icon_state = "eshield"
	item_state = "eshield"
	force_divisor = 0.07
	sharp = FALSE
	attack_verb = list ("attacked", "bashed", "smacked", "bonked", "spanked")

/obj/item/weapon/material/sword/handle_shield(mob/user, var/damage, atom/damage_source = null, mob/attacker = null, var/def_zone = null, var/attack_text = "the attack")
	if(unique_parry_check((user*10), attacker, damage_source) && prob(50))
		user.visible_message("<span class='danger'>\The [user] parries [attack_text] with \the [src]!</span>")
		playsound(src, 'sound/weapons/punchmiss.ogg', 50, 1)
		return 1
	return 0
