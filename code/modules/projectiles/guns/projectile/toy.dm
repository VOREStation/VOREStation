/* Toys Guns!
 * Contains:
 *		Shotgun
 *		Pistol
 *		N99 Pistol
 *		Levergun
 *		Revolver
 *		Big Iron
 *		Crossbow
 *		Sawn Off
 *		SMG
 */


/*
 * Shotgun
 */
/obj/item/gun/projectile/shotgun/pump/toy
	name = "\improper Donk-Soft shotgun"
	desc = "Donk-Soft foam shotgun! It's Donk or Don't! Ages 8 and up."
	icon = 'icons/obj/gun_toy.dmi'
	icon_state = "shotgun"
	item_state = "shotgun"
	max_shells = 6
	w_class = ITEMSIZE_LARGE
	force = 2
	slot_flags = null
	caliber = "foam"
	origin_tech = list(TECH_COMBAT = 1, TECH_MATERIAL = 1)
	load_method = SINGLE_CASING
	ammo_type = /obj/item/ammo_casing/afoam_dart
	projectile_type = /obj/item/projectile/bullet/foam_dart
	matter = list(MAT_PLASTIC = 2000)
	handle_casings = null
	recoil = null //it's a toy

/*
 * Pistol
 */
/obj/item/gun/projectile/pistol/toy
	name = "\improper Donk-Soft pistol"
	desc = "Donk-Soft foam pistol! It's Donk or Don't! Ages 8 and up."
	icon = 'icons/obj/gun_toy.dmi'
	icon_state = "pistol"
	item_state = "gun"
	magazine_type = /obj/item/ammo_magazine/mfoam_dart/pistol
	allowed_magazines = list(/obj/item/ammo_magazine/mfoam_dart/pistol)
	projectile_type = /obj/item/projectile/bullet/foam_dart
	caliber = "foam"
	origin_tech = list(TECH_COMBAT = 1, TECH_MATERIAL = 1)
	load_method = MAGAZINE
	matter = list(MAT_PLASTIC = 1000)
	recoil = null //it's a toy

/obj/item/gun/projectile/pistol/toy/update_icon()
	if(ammo_magazine)
		icon_state = initial(icon_state)
	else
		icon_state = "[initial(icon_state)]-e"

/*
 * N99 Pistol
 */
/obj/item/gun/projectile/pistol/toy/n99
	name = "\improper Donk-Soft commemorative pistol"
	desc = "A special made Donk-Soft pistol to promote 'Radius: Legend of the Demon Core', a popular post-apocolyptic TV series."
	icon_state = "n99"
	item_state = "gun"

/obj/item/gun/projectile/pistol/toy/n99/update_icon()
	if(ammo_magazine)
		icon_state = initial(icon_state)
	else
		icon_state = "[initial(icon_state)]-e"

/*
 * Levergun
 */
/obj/item/gun/projectile/shotgun/pump/toy/levergun
	name = "\improper Donk-Soft levergun"
	desc = "Donk-Soft foam levergun! Time to cowboy up! Ages 8 and up."
	icon_state = "leveraction"
	item_state = "leveraction"
	max_shells = 5
	pump_animation = "leveraction-cycling"

/*
 * Revolver
 */
/obj/item/gun/projectile/revolver/toy
	name = "\improper Donk-Soft revolver"
	desc = "Donk-Soft foam revolver! Time to cowboy up! Ages 8 and up."
	icon = 'icons/obj/gun_toy.dmi'
	icon_state = "revolver"
	item_state = "revolver"
	caliber = "foam"
	ammo_type = /obj/item/ammo_casing/afoam_dart
	projectile_type = /obj/item/projectile/bullet/foam_dart
	origin_tech = list(TECH_COMBAT = 1, TECH_MATERIAL = 1)
	load_method = SINGLE_CASING
	max_shells = 6
	matter = list(MAT_PLASTIC = 1000)
	handle_casings = null
	recoil = null //it's a toy

/*
 * Big Iron
 */
/obj/item/gun/projectile/revolver/toy/big_iron
	name = "\improper Donk-Soft big iron"
	desc = "A special made Donk-Soft pistol to promote 'A Fistful of Phoron', a popular frontier novel series."
	icon_state = "big_iron"
	item_state = "revolver"

/*
 * Crossbow
 */
/obj/item/gun/projectile/revolver/toy/crossbow
	name = "\improper Donk-Soft crossbow"
	desc = "Donk-Soft foam pistol! It's Donk or Don't! Ages 8 and up."
	icon = 'icons/obj/gun_toy.dmi'
	icon_state = "foamcrossbow"
	item_state = "foamcrossbow"
	max_shells = 5

/*
 * Sawn Off
 */
/obj/item/gun/projectile/revolver/toy/sawnoff //revolver code just because it's easier
	name = "\improper Donk-Soft sawn off shotgun"
	desc = "Donk-Soft foam sawn off! It's Donk or Don't! Ages 8 and up."
	icon = 'icons/obj/gun_toy.dmi'
	icon_state = "sawnshotgun"
	item_state = "dshotgun"
	max_shells = 2
	w_class = ITEMSIZE_NORMAL
	matter = list(MAT_PLASTIC = 1500)

/*
 * SMG
 */
/obj/item/gun/projectile/automatic/toy
	name = "\improper Donk-Soft SMG"
	desc = "Donk-Soft foam SMG! It's Donk or Don't! Ages 8 and up."
	icon = 'icons/obj/gun_toy.dmi'
	icon_state = "smg"
	caliber = "foam"
	w_class = ITEMSIZE_NORMAL
	load_method = MAGAZINE
	origin_tech = list(TECH_COMBAT = 1, TECH_MATERIAL = 1)
	slot_flags = SLOT_BELT
	magazine_type = /obj/item/ammo_magazine/mfoam_dart/smg
	allowed_magazines = list(/obj/item/ammo_magazine/mfoam_dart/smg)
	projectile_type = /obj/item/projectile/bullet/foam_dart
	matter = list(MAT_PLASTIC = 1500)
	recoil = null //it's a toy

	firemodes = list(
		list(mode_name="semiauto",       burst=1, fire_delay=0,    move_delay=null, burst_accuracy=null, dispersion=null),
		list(mode_name="3-round bursts", burst=3, fire_delay=null, move_delay=2,    burst_accuracy=list(0,-2,-2), dispersion=null)
	)

/obj/item/gun/projectile/automatic/toy/update_icon()
	if(ammo_magazine)
		icon_state = initial(icon_state)
	else
		icon_state = "[initial(icon_state)]-e"