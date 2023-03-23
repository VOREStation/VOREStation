/obj/item/weapon/melee/rapier
	name = "rapier"
	desc = "A gleaming steel blade with a gold handguard and inlayed with an outstanding red gem."
	icon = 'icons/obj/weapons_vr.dmi'
	icon_state = "rapier"
	item_icons = list(
		slot_l_hand_str = 'icons/mob/items/lefthand_melee_vr.dmi',
		slot_r_hand_str = 'icons/mob/items/righthand_melee_vr.dmi',
		)
	force = 15
	throwforce = 10
	w_class = ITEMSIZE_NORMAL
	sharp = TRUE
	edge = FALSE
	attack_verb = list("stabbed", "lunged at", "dextrously struck", "sliced", "lacerated", "impaled", "diced", "charioted")
	hitsound = 'sound/weapons/bladeslice.ogg'

/obj/item/weapon/melee/altevian_wrench
	name = "Hull Systems Multi-Wrench"
	desc = "A wrench designed with a method to help secure and access bolts, hatches, and airlocks on altevian designed vessels. This operates as nothing more than a massive wrench when used for other purposes."
	icon = 'icons/obj/weapons_vr.dmi'
	icon_state = "altevian-wrench"
	item_icons = list(
		slot_l_hand_str = 'icons/mob/items/lefthand_melee_vr.dmi',
		slot_r_hand_str = 'icons/mob/items/righthand_melee_vr.dmi',
		)
	slot_flags = SLOT_BACK
	force = 25
	throwforce = 15
	w_class = ITEMSIZE_HUGE
	sharp = FALSE
	edge = FALSE
	attack_verb = list("whacked", "slammed", "bashed", "wrenched", "fixed", "bolted", "clonked", "bonked")
	hitsound = 'sound/weapons/smash.ogg'