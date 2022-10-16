/obj/item/clothing/head/hood/techpriest
	name = "techpriest hood"
	armor = list(melee = 20, bullet = 10, laser = 10, energy = 10, bomb = 25, bio = 50, rad = 25)

// Armor versions here
/obj/item/clothing/head/hood/galahad
	name = "galahad hood"
	armor = list(melee = 80, bullet = 10, laser = 10, energy = 0, bomb = 0, bio = 0, rad = 0)
	siemens_coefficient = 2

/obj/item/clothing/head/hood/lancelot
	name = "lancelot hood"
	armor = list(melee = 80, bullet = 10, laser = 10, energy = 0, bomb = 0, bio = 0, rad = 0)
	siemens_coefficient = 2

/obj/item/clothing/head/hood/robin
	name = "robin hood"
	armor = list(melee = 80, bullet = 10, laser = 10, energy = 0, bomb = 0, bio = 0, rad = 0)
	siemens_coefficient = 3

// Costume Versions Here
/obj/item/clothing/head/hood/galahad_costume
	name = "galahad costume hood"

/obj/item/clothing/head/hood/lancelot_costume
	name = "lancelot costume hood"

/obj/item/clothing/head/hood/robin_costume
	name = "robin costume hood"

// Talon Winter Hood
/obj/item/clothing/head/hood/winter/talon
	name = "Talon winter hood"
	desc = "A cozy winter hood attached to a heavy winter jacket."
	icon_override = 'icons/inventory/head/mob_vr.dmi'
	icon_state = "winterhood_talon"

//Food costumes
// Hotdog suit hood
/obj/item/clothing/head/hood_vr/hotdog_hood
	name = "Hotdog suit hood"
	desc = "The hood of a hotdog suit, attached to said hotdog suit." //Honestly i just don't know how to force the costume to hide hats.
	icon = 'icons/inventory/head/mob_vr.dmi'
	icon_override = 'icons/inventory/head/mob_vr.dmi'
	icon_state = "hotdog_hood"
	flags_inv = HIDEEARS|BLOCKHAIR

// Turnip suit hood
/obj/item/clothing/head/hood_vr/turnip_hood
	name = "Turnip suit hood"
	desc = "The hood of a hotdog suit, attached to said hotdog suit. Most cooks cut this part off and throw it in the garbage"
	icon = 'icons/inventory/head/mob_vr.dmi'
	icon_override = 'icons/inventory/head/mob_vr.dmi'
	icon_state = "turnip_hood"
	flags_inv = HIDEEARS|BLOCKHAIR