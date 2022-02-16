/************************************************************************/
/*
#    An explaination of the naming format for guns and ammo:
#
#    a = Ammo, as in individual rounds of ammunition.
#    b = Box, intended to have ammo taken out one at a time by hand.
#    c = Clips, intended to reload magazines or guns quickly.
#    m = Magazine, intended to hold rounds of ammo.
#    s = Speedloaders, intended to reload guns quickly.
#
#    Use this format, followed by the caliber. For example, a shotgun's caliber
#    variable is "12g" as a result. Ergo, a shotgun round's path would have "a12g",
#    or a magazine with shotgun shells would be "m12g" instead. To avoid confusion
#    for developers and in-game admins spawning these items, stick to this format.
#    Likewise, when creating new rounds, the caliber variable should match whatever
#    the name says.
#
#    This comment is copied in rounds.dm and magazines.dm as well.
#
#    Also, to remove bullets from ammo boxes, use Alt-Click on the box.
*/
/************************************************************************/

/*
 * Foam
 */

/obj/item/ammo_magazine/ammo_box/foam
	name = "\improper Donk-Soft ammo box"
	desc = "Contains Donk-Soft foam darts. It's Donk or Don't! Ages 8 and up."
	icon = 'icons/obj/gun_toy.dmi'
	icon_state = "foambox"
	caliber = "foam"
	ammo_type = /obj/item/ammo_casing/afoam_dart
	matter = list(MAT_PLASTIC = 1800)
	max_ammo = 30
	multiple_sprites = null

/obj/item/ammo_magazine/ammo_box/foam/riot
	name = "\improper Donk-Soft riot ammo box"
	desc = "Contains Donk-Soft riot darts. It's Donk or Don't! Ages 18 and up."
	icon_state = "foambox_riot"
	matter = list(MAT_STEEL = 5040, MAT_PLASTIC = 1800)

/*
 * Cap
 */

/obj/item/ammo_magazine/ammo_box/cap
	name = "\improper AlliCo SNAP! Caps"
	desc = "A box of spare caps for capguns. Ages 8 and up."
	icon = 'icons/obj/gun_toy.dmi'
	icon_state = "capbox"
	caliber = "caps"
	ammo_type = /obj/item/ammo_casing/cap
	matter = list(MAT_STEEL = 2040)
	max_ammo = 24
	multiple_sprites = null