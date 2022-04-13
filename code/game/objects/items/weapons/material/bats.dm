/obj/item/weapon/material/twohanded/baseballbat
	name = "bat"
	desc = "HOME RUN!"
	icon_state = "metalbat0"
	base_icon = "metalbat"
	throwforce = 7
	attack_verb = list("smashed", "beaten", "slammed", "smacked", "struck", "battered", "bonked")
	hitsound = 'sound/weapons/genhit3.ogg'
	default_material = "wood"
	force_divisor = 1.1           // 22 when wielded with weight 20 (steel)
	unwielded_force_divisor = 0.7 // 15 when unwielded based on above.
	dulled_divisor = 0.75		  // A "dull" bat is still gonna hurt
	slot_flags = SLOT_BACK

//Predefined materials go here.
/obj/item/weapon/material/twohanded/baseballbat/metal/Initialize(var/ml)
	. = ..(ml, MAT_STEEL)

/obj/item/weapon/material/twohanded/baseballbat/uranium/Initialize(var/ml)
	. = ..(ml, MAT_URANIUM)

/obj/item/weapon/material/twohanded/baseballbat/gold/Initialize(var/ml)
	. = ..(ml, MAT_GOLD)

/obj/item/weapon/material/twohanded/baseballbat/platinum/Initialize(var/ml)
	. = ..(ml, MAT_PLATINUM)

/obj/item/weapon/material/twohanded/baseballbat/diamond/Initialize(var/ml)
	. = ..(ml, MAT_DIAMOND)
