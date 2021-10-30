/obj/item/weapon/gun/projectile/sec/flash
	name = ".45 pistol"

/obj/item/weapon/gun/projectile/p92x/sec
	magazine_type = /obj/item/ammo_magazine/m9mm/rubber

/obj/item/weapon/gun/projectile/p92x/large/preban
	icon_state = "p92x-brown"
	magazine_type = /obj/item/ammo_magazine/m9mm/large/preban // Spawns with big magazines that are legal.

/obj/item/weapon/gun/projectile/p92x/large/preban/hp
	magazine_type = /obj/item/ammo_magazine/m9mm/large/preban/hp // Spawns with legal hollow-point mag

//////////////////// Eris Ported Guns ////////////////////
//HoS Gun
/obj/item/weapon/gun/projectile/lamia
	name = "FS HG .44 \"Lamia\""
	desc = "Uses .44 rounds."
	icon = 'icons/obj/gun_vr.dmi'
	icon_state = "Headdeagle"
	item_state = "revolver"
	caliber = ".44"
	magazine_type = /obj/item/ammo_magazine/m44/rubber
	allowed_magazines = list(/obj/item/ammo_magazine/m44,/obj/item/ammo_magazine/m44/rubber)
	load_method = MAGAZINE
	auto_eject = 1
	auto_eject_sound = 'sound/weapons/smg_empty_alarm.ogg'
	origin_tech = list(TECH_COMBAT = 4, TECH_MATERIAL = 4)

/obj/item/weapon/gun/projectile/lamia/update_icon()
	cut_overlays()
	if(!ammo_magazine)
		return
	var/ratio = ammo_magazine.stored_ammo.len * 100 / ammo_magazine.max_ammo
	ratio = round(ratio, 33)
	add_overlay("deagle_[ratio]")

//Civilian gun
/obj/item/weapon/gun/projectile/giskard
	name = "\improper \"Giskard\" holdout pistol"
	desc = "The FS HG .380 \"Giskard\" can even fit into the pocket! Uses .380 rounds."
	icon = 'icons/obj/gun_vr.dmi'
	icon_override = 'icons/obj/gun_vr.dmi'
	icon_state = "giskardcivil"
	item_state = "giskardcivil"
	caliber = ".380"
	magazine_type = /obj/item/ammo_magazine/m380
	allowed_magazines = list(/obj/item/ammo_magazine/m380)
	load_method = MAGAZINE
	w_class = ITEMSIZE_SMALL
	fire_sound = 'sound/weapons/gunshot_pathetic.ogg'
	origin_tech = list(TECH_COMBAT = 2, TECH_MATERIAL = 3)

/obj/item/weapon/gun/projectile/giskard/update_icon()
	..()
	if(ammo_magazine && ammo_magazine.stored_ammo.len)
		icon_state = "giskardcivil"
	else
		icon_state = "giskardcivil_empty"

//Not so civilian gun
/obj/item/weapon/gun/projectile/giskard/olivaw
	name = "\improper \"Olivaw\" holdout burst-pistol"
	desc = "The FS HG .380 \"Olivaw\" is a more advanced version of the \"Giskard\". This one seems to have a two-round burst-fire mode. Uses .380 rounds."
	icon_state = "olivawcivil"
	item_state = "olivawcivil"
	firemodes = list(
		list(mode_name="semiauto",       burst=1, fire_delay=1.2,    move_delay=null, burst_accuracy=null, dispersion=null),
		list(mode_name="2-round bursts", burst=2, fire_delay=0.2, move_delay=4,    burst_accuracy=list(0,-15),       dispersion=list(1.2, 1.8)),
		)

/obj/item/weapon/gun/projectile/giskard/olivaw/update_icon()
	..()
	if(ammo_magazine && ammo_magazine.stored_ammo.len)
		icon_state = "olivawcivil"
	else
		icon_state = "olivawcivil_empty"
