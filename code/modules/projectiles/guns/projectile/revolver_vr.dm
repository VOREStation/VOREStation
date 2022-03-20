//Dunno why .380 ammo was in here but Im not touching it. Rest was moved to other files.

//.380
/obj/item/ammo_casing/a380
	desc = "A .380 bullet casing."
	caliber = ".380"
	projectile_type = /obj/item/projectile/bullet/pistol

/obj/item/ammo_magazine/m380
	name = "magazine (.380)"
	icon_state = "m92"
	origin_tech = list(TECH_COMBAT = 2)
	mag_type = MAGAZINE
	matter = list(MAT_STEEL = 480)
	caliber = ".380"
	ammo_type = /obj/item/ammo_casing/a380
	max_ammo = 8
	multiple_sprites = 1

