<<<<<<< HEAD
/obj/item/weapon/material/twohanded/baseballbat/foam/New(var/newloc)
	..(newloc,"foam")
=======
/obj/item/material/twohanded/baseballbat/foam/Initialize(var/ml)
	. = ..(ml, "foam")
>>>>>>> 61084723c7b... Merge pull request #8317 from Atermonera/remove_weapon

/obj/item/material/sword/foam
	attack_verb = list("bonked","whacked")
	force_divisor = 0
	unbreakable = 1

/obj/item/material/twohanded/baseballbat/foam
	attack_verb = list("bonked","whacked")
	force_wielded = 0
	force_divisor = 0
	unbreakable = 1

<<<<<<< HEAD
/obj/item/weapon/material/sword/foam/New(var/newloc)
	..(newloc,"foam")
=======
/obj/item/material/sword/foam/Initialize(var/ml)
	. = ..(ml, "foam")
>>>>>>> 61084723c7b... Merge pull request #8317 from Atermonera/remove_weapon

/obj/item/material/twohanded/spear/foam
	attack_verb = list("bonked","whacked")
	force_wielded = 0
	force_divisor = 0
	applies_material_colour = 1
	base_icon = "spear_mask"
	icon_state = "spear_mask0"
	unbreakable = 1

<<<<<<< HEAD
/obj/item/weapon/material/twohanded/spear/foam/New(var/newloc)
	..(newloc,"foam")
=======
/obj/item/material/twohanded/spear/foam/Initialize(var/ml)
	. = ..(ml, "foam")
>>>>>>> 61084723c7b... Merge pull request #8317 from Atermonera/remove_weapon

/obj/item/material/twohanded/fireaxe/foam
	attack_verb = list("bonked","whacked")
	force_wielded = 0
	force_divisor = 0
	applies_material_colour = 1
	base_icon = "fireaxe_mask"
	icon_state = "fireaxe_mask0"
	unbreakable = 1

<<<<<<< HEAD
/obj/item/weapon/material/twohanded/fireaxe/foam/New(var/newloc)
	..(newloc,"foam")
=======
/obj/item/material/twohanded/fireaxe/foam/Initialize(var/ml)
	. = ..(ml,"foam")
>>>>>>> 61084723c7b... Merge pull request #8317 from Atermonera/remove_weapon

/obj/item/material/twohanded/fireaxe/foam/afterattack()
	return