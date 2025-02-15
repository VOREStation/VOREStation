/obj/item/material/twohanded/baseballbat
	name = "bat"
	desc = "HOME RUN!"
	icon_state = "metalbat0"
	base_icon = "metalbat"
	throwforce = 7
	attack_verb = list("smashed", "beaten", "slammed", "smacked", "struck", "battered", "bonked")
	hitsound = 'sound/weapons/genhit3.ogg'
	default_material = MAT_WOOD
	force_divisor = 1.1           // 22 when wielded with weight 20 (steel)
	unwielded_force_divisor = 0.7 // 15 when unwielded based on above.
	dulled_divisor = 0.75		  // A "dull" bat is still gonna hurt
	slot_flags = SLOT_BACK

//Predefined materials go here.
/obj/item/material/twohanded/baseballbat/metal/Initialize(mapload)
	. = ..(mapload,MAT_STEEL)

/obj/item/material/twohanded/baseballbat/uranium/Initialize(mapload)
	. = ..(mapload,MAT_URANIUM)

/obj/item/material/twohanded/baseballbat/gold/Initialize(mapload)
	. = ..(mapload,MAT_GOLD)

/obj/item/material/twohanded/baseballbat/platinum/Initialize(mapload)
	. = ..(mapload,MAT_PLATINUM)

/obj/item/material/twohanded/baseballbat/diamond/Initialize(mapload)
	. = ..(mapload,MAT_DIAMOND)
