//////////////////// Eris Ported Guns ////////////////////
//Detective gun
/obj/item/weapon/gun/projectile/revolver/consul
	name = "\improper \"Consul\" Revolver"
	desc = "Are you feeling lucky, punk? Uses .44 rounds."
	icon = 'icons/obj/gun_vr.dmi'
	icon_state = "inspector"
	item_state = "revolver"
	caliber = ".44"
	ammo_type = /obj/item/ammo_casing/a44/rubber
	handle_casings = CYCLE_CASINGS
	origin_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 3)

/obj/item/weapon/gun/projectile/revolver/consul/proc/update_charge()
	cut_overlays()
	if(loaded.len==0)
		add_overlay("inspector_off")
	else
		add_overlay("inspector_on")

/obj/item/weapon/gun/projectile/revolver/consul/update_icon()
	update_charge()

//.357 special ammo
/obj/item/ammo_magazine/s357/stun
	name = "speedloader (.357 stun)"
	desc = "A speedloader for .357 revolvers."
	icon = 'icons/obj/ammo_vr.dmi'
	icon_state = "s357"
	caliber = ".357"
	ammo_type = /obj/item/ammo_casing/a357/stun


/obj/item/ammo_casing/a357/stun
	desc = "A .357 stun bullet casing."
	caliber = ".357"
	icon = 'icons/obj/ammo_vr.dmi'
	icon_state = "stun357"
	projectile_type = /obj/item/projectile/energy/electrode/stunshot/strong

/obj/item/ammo_magazine/s357/rubber
	name = "speedloader (.357 rubber)"
	desc = "A speedloader for .357 revolvers."
	icon = 'icons/obj/ammo_vr.dmi'
	icon_state = "r357"
	caliber = ".357"
	ammo_type = /obj/item/ammo_casing/a357/rubber


/obj/item/ammo_casing/a357/rubber
	desc = "A .357 rubber bullet casing."
	caliber = ".357"
	icon = 'icons/obj/ammo_vr.dmi'
	icon_state = "rubber357"
	projectile_type = /obj/item/projectile/bullet/pistol/rubber/strong

/obj/item/ammo_magazine/s357/flash
	name = "speedloader (.357 flash)"
	desc = "A speedloader for .357 revolvers."
	icon = 'icons/obj/ammo_vr.dmi'
	icon_state = "f357"
	caliber = ".357"
	ammo_type = /obj/item/ammo_casing/a357/flash

/obj/item/ammo_casing/a357/flash
	desc = "A .357 flash bullet casing."
	caliber = ".357"
	icon = 'icons/obj/ammo_vr.dmi'
	icon_state = "flash357"
	projectile_type = /obj/item/projectile/energy/flash/strong

//.380
/obj/item/ammo_casing/a380
	desc = "A .380 bullet casing."
	caliber = ".380"
	projectile_type = /obj/item/projectile/bullet/pistol

/obj/item/ammo_magazine/m380
	name = "magazine (.380)"
	icon_state = "9x19p"
	origin_tech = list(TECH_COMBAT = 2)
	mag_type = MAGAZINE
	matter = list(MAT_STEEL = 480)
	caliber = ".380"
	ammo_type = /obj/item/ammo_casing/a380
	max_ammo = 8
	multiple_sprites = 1

//.44
/obj/item/ammo_casing/a44/rubber
	icon_state = "r-casing"
	desc = "A .44 rubber bullet casing."
	projectile_type = /obj/item/projectile/bullet/pistol/rubber/strong

/obj/item/ammo_magazine/m44/rubber
	desc = "A magazine for .44 less-than-lethal ammo."
	ammo_type = /obj/item/ammo_casing/a44/rubber

//.44 speedloaders
/obj/item/ammo_magazine/s44
	name = "speedloader (.44)"
	desc = "A speedloader for .44 revolvers."
	icon = 'icons/obj/ammo_vr.dmi'
	icon_state = "s357"
	caliber = ".44"
	matter = list(MAT_STEEL = 1260)
	ammo_type = /obj/item/ammo_casing/a44
	max_ammo = 6
	multiple_sprites = 1
	mag_type = SPEEDLOADER

/obj/item/ammo_magazine/s44/rubber
	name = "speedloader (.44 rubber)"
	icon_state = "r357"
	ammo_type = /obj/item/ammo_casing/a44/rubber
