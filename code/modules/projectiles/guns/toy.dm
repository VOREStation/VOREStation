/* Toys Guns!
 *
 * Contains:
 *		Cap Gun
 *		Shotgun
 *		Pistol
 *		N99 Pistol
 *		Levergun
 *		Revolver
 *		Big Iron
 *		Crossbow
 *		Crossbow (Halloween)
 *		Sawn Off
 *		SMG
 *		Laser Tag
 */

/*
 * Cap Gun
 */
/obj/item/weapon/gun/projectile/revolver/capgun
	name = "cap gun"
	desc = "Looks almost like the real thing! Ages 8 and up."
	icon = 'icons/obj/gun_toy.dmi'
	icon_state = "cap_gun"
	item_state = "revolver"
	caliber = "caps"
	origin_tech = list(TECH_COMBAT = 1, TECH_MATERIAL = 1)
	ammo_type = /obj/item/ammo_casing/cap
	projectile_type = /obj/item/projectile/bullet/cap
	matter = list(MAT_STEEL = 1000)
	handle_casings = null
	recoil = 1 //it's a toy

/*
 * Shotgun
 */
/obj/item/weapon/gun/projectile/shotgun/pump/toy
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
/obj/item/weapon/gun/projectile/pistol/toy
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

/obj/item/weapon/gun/projectile/pistol/toy/update_icon()
	if(ammo_magazine)
		icon_state = initial(icon_state)
	else
		icon_state = "[initial(icon_state)]-e"

/*
 * N99 Pistol
 */
/obj/item/weapon/gun/projectile/pistol/toy/n99
	name = "\improper Donk-Soft commemorative pistol"
	desc = "A special made Donk-Soft pistol to promote 'Radius: Legend of the Demon Core', a popular post-apocolyptic TV series."
	icon_state = "n99"
	item_state = "gun"

/obj/item/weapon/gun/projectile/pistol/toy/n99/update_icon()
	if(ammo_magazine)
		icon_state = initial(icon_state)
	else
		icon_state = "[initial(icon_state)]-e"

/*
 * Levergun
 */
/obj/item/weapon/gun/projectile/shotgun/pump/toy/levergun
	name = "\improper Donk-Soft levergun"
	desc = "Donk-Soft foam levergun! Time to cowboy up! Ages 8 and up."
	icon_state = "leveraction"
	item_state = "leveraction"
	max_shells = 5
	pump_animation = "leveraction-cycling"

/*
 * Revolver
 */
/obj/item/weapon/gun/projectile/revolver/toy
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
/obj/item/weapon/gun/projectile/revolver/toy/big_iron
	name = "\improper Donk-Soft big iron"
	desc = "A special made Donk-Soft pistol to promote 'A Fistful of Phoron', a popular frontier novel series."
	icon_state = "big_iron"
	item_state = "revolver"

/*
 * Crossbow
 */
/obj/item/weapon/gun/projectile/revolver/toy/crossbow
	name = "\improper Donk-Soft crossbow"
	desc = "Donk-Soft foam crossbow! It's Donk or Don't! Ages 8 and up."
	icon = 'icons/obj/gun_toy.dmi'
	icon_state = "foamcrossbow"
	item_state = "foamcrossbow"
	max_shells = 5

/*
 * Crossbow (Halloween)
 */
/obj/item/weapon/gun/projectile/revolver/toy/crossbow/halloween
	name = "\improper Donk-Soft special edition crossbow"
	desc = "A special edition Donk-Soft crossbow! Made special for your Halloween cosplay. It's Donk or Don't! Ages 8 and up."
	icon = 'icons/obj/gun_toy.dmi'
	icon_state = "foamcrossbow_halloween"
	item_state = "foamcrossbow_halloween"
	max_shells = 5

/*
 * Sawn Off
 */
/obj/item/weapon/gun/projectile/revolver/toy/sawnoff //revolver code just because it's easier
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
/obj/item/weapon/gun/projectile/automatic/toy
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

/obj/item/weapon/gun/projectile/automatic/toy/riot
	magazine_type = /obj/item/ammo_magazine/mfoam_dart/smg/riot

/obj/item/weapon/gun/projectile/automatic/toy/update_icon()
	if(ammo_magazine)
		icon_state = initial(icon_state)
	else
		icon_state = "[initial(icon_state)]-e"
/*
 * Cyborg
 */
/obj/item/weapon/gun/projectile/cyborgtoy
	name = "\improper Donk-Soft Cyborg Blaster"
	desc = "Donk-Soft Cyborg Blaster! It's Donk or Don't! Adult supervision required. Use to toggle between battle and cleanup mode."
	icon = 'icons/obj/gun_toy.dmi'
	icon_state = "smg"
	caliber = "foam"
	load_method = SINGLE_CASING
	max_shells = 15
	var/cleanup = 0
	ammo_type = /obj/item/ammo_casing/afoam_dart
	projectile_type = /obj/item/projectile/bullet/foam_dart
	recoil = null
	handle_casings = null

/obj/item/weapon/gun/projectile/cyborgtoy/attack_self(var/mob/user)
	cleanup = !cleanup
	to_chat(user, "The [src] is now on [cleanup ? "cleanup" : "battle"] mode.")

/obj/item/weapon/gun/projectile/cyborgtoy/afterattack(atom/A, mob/living/user, adjacent, params)
	if(cleanup)
		if(!adjacent)
			return 0
		collectammo(A, user)
		return 0
	..()

/obj/item/weapon/gun/projectile/cyborgtoy/proc/collectammo(atom/A, user)
	if(loaded.len >= max_shells)
		to_chat(user, "The [src] is at max capacity.")
		return
	var/T = get_turf(A)
	var/success = 0
	for(var/obj/item/ammo_casing/afoam_dart/D in T)
		if(loaded.len >= max_shells)
			break
		D.loc = src
		loaded.Insert(1, D)
		success = 1
	if(success)
		playsound(src, 'sound/machines/hiss.ogg', 50, 0)
		to_chat(user, "The [src] vacuums in the darts!")
	else
		to_chat(user, "No Donk-Soft brand foam darts detected. Aborting.")
/*
 * Laser Tag
 */
/obj/item/weapon/gun/energy/lasertag
	name = "laser tag gun"
	desc = "Standard issue weapon of the Imperial Guard"
	icon = 'icons/obj/gun_toy.dmi'
	item_state = "omnitag"
	item_state = "retro"
	origin_tech = list(TECH_COMBAT = 1, TECH_MAGNET = 2)
	matter = list(MAT_STEEL = 2000)
	projectile_type = /obj/item/projectile/beam/lasertag/blue
	cell_type = /obj/item/weapon/cell/device/weapon/recharge
	battery_lock = 1
	var/required_vest

/obj/item/weapon/gun/energy/lasertag/special_check(var/mob/living/carbon/human/M)
	if(ishuman(M))
		if(!istype(M.wear_suit, required_vest))
			to_chat(M, "<span class='warning'>You need to be wearing your laser tag vest!</span>")
			return 0
	return ..()

/obj/item/weapon/gun/energy/lasertag/blue
	icon_state = "bluetag"
	item_state = "bluetag"
	projectile_type = /obj/item/projectile/beam/lasertag/blue
	required_vest = /obj/item/clothing/suit/bluetag

/obj/item/weapon/gun/energy/lasertag/blue/sub
	name = "Brigader Sidearm"
	desc = "A laser tag replica of the standard issue weapon for the Spacer Union Brigade from the hit series Spacer Trail (Blue Team)."
	icon_state = "bluetwo"
	item_state = "retro"

/obj/item/weapon/gun/energy/lasertag/red
	icon_state = "redtag"
	item_state = "redtag"
	projectile_type = /obj/item/projectile/beam/lasertag/red
	required_vest = /obj/item/clothing/suit/redtag

/obj/item/weapon/gun/energy/lasertag/red/dom
	name = "Mu'tu'bi sidearm"
	desc = "A laser tag replica of the Mu'tu'bi sidearm from the hit series Spacer Trail (Red Team)."
	icon_state = "redtwo"
	item_state = "retro"

/obj/item/weapon/gun/energy/lasertag/omni
	projectile_type = /obj/item/projectile/beam/lasertag/omni