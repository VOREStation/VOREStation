
//9mm
/obj/item/ammo_magazine/m9mm/spectral
	name = "magazine (9mm specter shot)"
	ammo_type = /obj/item/ammo_casing/a9mm/spectral

/obj/item/ammo_magazine/m9mml/spectral
	name = "compact magazine (9mm specter shot)"
	ammo_type = /obj/item/ammo_casing/a9mm/spectral

/obj/item/ammo_casing/a9mm/spectral
	desc = "A 9mm spectral bullet casing. Hits incorporeal entities and brings them into the corporeal realm, but near-useless against corporeal ones."
	icon_state = "r-casing"
	projectile_type = /obj/item/projectile/bullet/spectral

//357
/obj/item/ammo_magazine/s357/spectral
	name = "speedloader (.357 specter shot)"
	icon_state = "T38"
	ammo_type = /obj/item/ammo_casing/a357/spectral

/obj/item/ammo_casing/a357/spectral
	desc = "A .357 spectral bullet casing. Hits incorporeal entities and brings them into the corporeal realm, but near-useless against corporeal ones."
	caliber = ".357"
	icon_state = "r-casing"
	projectile_type = /obj/item/projectile/bullet/spectral/strong
	matter = list(MAT_STEEL = 210)

//38
/obj/item/ammo_magazine/s38/spectral
	name = "speedloader (.38 spectral)"
	icon_state = "T38"
	ammo_type = /obj/item/ammo_casing/a38/spectral

/obj/item/ammo_magazine/ammo_box/b38/spectral
	name = "ammo box (.38 spectral)"
	icon_state = "pistol_p"
	ammo_type = /obj/item/ammo_casing/a38/spectral
	max_ammo = 24

/obj/item/ammo_casing/a38/spectral
	desc = "A .38 rubber bullet casing. Hits incorporeal entities and brings them into the corporeal realm, but near-useless against corporeal ones.""
	icon_state = "empcasing"
	projectile_type = /obj/item/projectile/bullet/spectral

//44
/obj/item/ammo_magazine/s44/spectral
	name = "speedloader (.44 specter shot)"
	icon_state = "R44"
	ammo_type = /obj/item/ammo_casing/a44/spectral

/obj/item/ammo_magazine/ammo_box/b44/spectral
	name = "ammo box (.44 specter shot)"
	icon_state = "box44-rubber"
	ammo_type = /obj/item/ammo_casing/a44/spectral
	max_ammo = 24

/obj/item/ammo_casing/a44/spectral
	desc = "A .44 bullet casing. Hits incorporeal entities and brings them into the corporeal realm, but near-useless against corporeal ones."
	caliber = ".44"
	icon_state = "r-casing"
	projectile_type = /obj/item/projectile/bullet/spectral/strong
	matter = list(MAT_STEEL = 210)

//The actual spectral bullet.
/obj/item/projectile/bullet/spectral
	damage = 1 //Very, very weak.
	hud_state = "smg_light"
	hits_phased = TRUE
	dephasing = TRUE
	var/phaser_damage = 10
	var/weaken_duration = 5
	var/stun_duration = 3

/obj/item/projectile/bullet/spectral/attack_mob(mob/living/target_mob, distance, miss_modifier)
	var/incorp = is_incorporeal()
	if(incorp)
		damage = phaser_damage
	. = ..()
	if(. && incorp)
		target_mob.Stun(stun_duration)
		target_mob.Weaken(weaken_duration)

/obj/item/projectile/bullet/spectral/can_embed()
	return FALSE

//Subtypes
/obj/item/projectile/bullet/spectral/strong
	damage = 5
	phaser_damage = 25
	stun_duration = 5
	weaken_duration = 10
