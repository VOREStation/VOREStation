//////////////////
/*Shotgun rounds*/
//////////////////

/datum/design_techweb/mechfab/ammo_12g_slug
	name = "ammunition (12g, slug)"
	id = "ammo_12g_slug"
	materials = list(MAT_STEEL = 450)
	build_type = AUTOLATHE | PROTOLATHE
	build_path = /obj/item/ammo_casing/a12g
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_HACKED,
		RND_SUBCATEGORY_WEAPONS_AMMO
	)

/datum/design_techweb/mechfab/ammo_12g_blank
	name = "ammunition (12g, blank)"
	id = "ammo_12g_blank"
	materials = list(MAT_STEEL = 110)
	build_type = AUTOLATHE | PROTOLATHE
	build_path = /obj/item/ammo_casing/a12g/blank
	category = list(
		RND_CATEGORY_INITIAL,
		RND_SUBCATEGORY_WEAPONS_AMMO
	)

/datum/design_techweb/mechfab/ammo_12g_beanbag
	name = "ammunition (12g, beanbag)"
	id = "ammo_12g_beanbag"
	materials = list(MAT_STEEL = 225)
	build_type = AUTOLATHE | PROTOLATHE
	build_path = /obj/item/ammo_casing/a12g/beanbag
	category = list(
		RND_CATEGORY_INITIAL,
		RND_SUBCATEGORY_WEAPONS_AMMO
	)

/datum/design_techweb/mechfab/ammo_12g_flash
	name = "ammunition (12g, flash)"
	id = "ammo_12g_flash"
	materials = list(MAT_STEEL = 115, MAT_GLASS = 115)
	build_type = AUTOLATHE | PROTOLATHE
	build_path = /obj/item/ammo_casing/a12g/flash
	category = list(
		RND_CATEGORY_INITIAL,
		RND_SUBCATEGORY_WEAPONS_AMMO
	)

/datum/design_techweb/mechfab/ammo_12g_pellet
	name = "ammunition (12g, pellet)"
	id = "ammo_12g_pellet"
	materials = list(MAT_STEEL = 450)
	build_type = AUTOLATHE | PROTOLATHE
	build_path = /obj/item/ammo_casing/a12g/pellet
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_HACKED,
		RND_SUBCATEGORY_WEAPONS_AMMO
	)

/datum/design_techweb/mechfab/ammo_12g_stun
	name = "ammunition (stun cartridge, shotgun)"
	id = "ammo_12g_stun"
	materials = list(MAT_STEEL = 450, MAT_GLASS = 900)
	build_type = AUTOLATHE | PROTOLATHE
	build_path = /obj/item/ammo_casing/a12g/stunshell
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_HACKED,
		RND_SUBCATEGORY_WEAPONS_AMMO
	)

/datum/design_techweb/mechfab/ammo_12g_flechette
	name = "ammunition (flechette cartridge, shotgun)"
	id = "ammo_12g_flechette"
	materials = list(MAT_STEEL = 450, MAT_GLASS = 125)
	build_type = AUTOLATHE | PROTOLATHE
	build_path = /obj/item/ammo_casing/a12g/flechette
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_HACKED,
		RND_SUBCATEGORY_WEAPONS_AMMO
	)

//////////////////
/* High velocity*/
//////////////////

/datum/design_techweb/mechfab/rifle_145_sabot
	name = "14.5mm round (sabot)"
	id = "rifle_145_sabot"
	materials = list(MAT_STEEL = 1560)
	build_type = AUTOLATHE | PROTOLATHE
	build_path = /obj/item/ammo_casing/a145/highvel
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_HACKED,
		RND_SUBCATEGORY_WEAPONS_AMMO
	)

//////////////////
/*Ammo magazines*/
//////////////////

/////// .45

/datum/design_techweb/mechfab/pistol_mag_45
	name = "pistol magazine (.45)"
	id = "pistol_mag_45"
	materials = list(MAT_STEEL = 650)
	build_type = AUTOLATHE | PROTOLATHE
	build_path = /obj/item/ammo_magazine/m45
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_HACKED,
		RND_SUBCATEGORY_WEAPONS_AMMO
	)

/datum/design_techweb/mechfab/pistol_mag_45_practice
	name = "pistol magazine (.45 practice)"
	id = "pistol_mag_45_practice"
	materials = list(MAT_STEEL = 650)
	build_type = AUTOLATHE | PROTOLATHE
	build_path = /obj/item/ammo_magazine/m45/practice
	category = list(
		RND_CATEGORY_INITIAL,
		RND_SUBCATEGORY_WEAPONS_AMMO
	)

/datum/design_techweb/mechfab/pistol_mag_45_rubber
	name = "pistol magazine (.45 rubber)"
	id = "pistol_mag_45_rubber"
	materials = list(MAT_STEEL = 650)
	build_type = AUTOLATHE | PROTOLATHE
	build_path = /obj/item/ammo_magazine/m45/rubber
	category = list(
		RND_CATEGORY_INITIAL,
		RND_SUBCATEGORY_WEAPONS_AMMO
	)

/datum/design_techweb/mechfab/pistol_mag_45_flash
	name = "pistol magazine (.45 flash)"
	id = "pistol_mag_45_flash"
	materials = list(MAT_STEEL = 650)
	build_type = AUTOLATHE | PROTOLATHE
	build_path = /obj/item/ammo_magazine/m45/flash
	category = list(
		RND_CATEGORY_INITIAL,
		RND_SUBCATEGORY_WEAPONS_AMMO
	)

/datum/design_techweb/mechfab/pistol_mag_45_piercing
	name = "pistol magazine (.45 armor piercing)"
	id = "pistol_mag_45_piercing"
	materials = list(MAT_STEEL = 500, MAT_PLASTEEL = 300)
	build_type = AUTOLATHE | PROTOLATHE
	build_path = /obj/item/ammo_magazine/m45/ap
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_HACKED,
		RND_SUBCATEGORY_WEAPONS_AMMO
	)

/datum/design_techweb/mechfab/pistol_mag_45_hollow
	name = "pistol magazine (.45 hollowpoint)"
	id = "pistol_mag_45_hollow"
	materials = list(MAT_STEEL = 500, MAT_PLASTIC = 200)
	build_type = AUTOLATHE | PROTOLATHE
	build_path = /obj/item/ammo_magazine/m45/hp
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_HACKED,
		RND_SUBCATEGORY_WEAPONS_AMMO
	)

/////// specialty 45

/datum/design_techweb/mechfab/uzi_mag_45
	name = "uzi magazine (.45)"
	id = "uzi_mag_45"
	materials = list(MAT_STEEL = 1500)
	build_type = AUTOLATHE | PROTOLATHE
	build_path = /obj/item/ammo_magazine/m45uzi
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_HACKED,
		RND_SUBCATEGORY_WEAPONS_AMMO
	)

/datum/design_techweb/mechfab/tommy_mag_45
	name = "Tommy Gun magazine (.45)"
	id = "tommy_mag_45"
	materials = list(MAT_STEEL = 1875)
	build_type = AUTOLATHE | PROTOLATHE
	build_path = /obj/item/ammo_magazine/m45tommy
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_HACKED,
		RND_SUBCATEGORY_WEAPONS_AMMO
	)

/datum/design_techweb/mechfab/tommy_drum_45
	name = "Tommy Gun drum magazine (.45)"
	id = "tommy_drum_45"
	materials = list(MAT_STEEL = 4680)
	build_type = AUTOLATHE | PROTOLATHE
	build_path = /obj/item/ammo_magazine/m45tommydrum
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_HACKED,
		RND_SUBCATEGORY_WEAPONS_AMMO
	)

/////// 9mm

// Full size pistol mags.

/datum/design_techweb/mechfab/pistol_mag_9mm
	name = "pistol magazine (9mm)"
	id = "pistol_mag_9mm"
	materials = list(MAT_STEEL = 750)
	build_type = AUTOLATHE | PROTOLATHE
	build_path = /obj/item/ammo_magazine/m9mm
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_HACKED,
		RND_SUBCATEGORY_WEAPONS_AMMO
	)

/datum/design_techweb/mechfab/pistol_mag_9mm_rubber
	name = "pistol magazine (9mm rubber)"
	id = "pistol_mag_9mm_rubber"
	materials = list(MAT_STEEL = 750)
	build_type = AUTOLATHE | PROTOLATHE
	build_path = /obj/item/ammo_magazine/m9mm/rubber
	category = list(
		RND_CATEGORY_INITIAL,
		RND_SUBCATEGORY_WEAPONS_AMMO
	)

/datum/design_techweb/mechfab/pistol_mag_9mm_practice
	name = "pistol magazine (9mm practice)"
	id = "pistol_mag_9mm_practice"
	materials = list(MAT_STEEL = 750)
	build_type = AUTOLATHE | PROTOLATHE
	build_path = /obj/item/ammo_magazine/m9mm/practice
	category = list(
		RND_CATEGORY_INITIAL,
		RND_SUBCATEGORY_WEAPONS_AMMO
	)

/datum/design_techweb/mechfab/pistol_mag_9mm_flash
	name = "pistol magazine (9mm flash)"
	id = "pistol_mag_9mm_flash"
	materials = list(MAT_STEEL = 750)
	build_type = AUTOLATHE | PROTOLATHE
	build_path = /obj/item/ammo_magazine/m9mm/flash
	category = list(
		RND_CATEGORY_INITIAL,
		RND_SUBCATEGORY_WEAPONS_AMMO
	)

// Small mags for small or old guns. These are all hidden because they are traitor mags and will otherwise just clutter the Autolathe.

/datum/design_techweb/mechfab/pistol_mag_compact_9mm
	name = "compact pistol magazine (9mm)"
	id = "pistol_mag_compact_9mm"
	materials = list(MAT_STEEL = 600)
	build_type = AUTOLATHE | PROTOLATHE
	build_path = /obj/item/ammo_magazine/m9mm/compact
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_HACKED,
		RND_SUBCATEGORY_WEAPONS_AMMO
	)

/datum/design_techweb/mechfab/pistol_mag_compact_9mm_rubber
	name = "compact pistol magazine (9mm rubber)"
	id = "pistol_mag_compact_9mm_rubber"
	materials = list(MAT_STEEL = 600)
	build_type = AUTOLATHE | PROTOLATHE
	build_path = /obj/item/ammo_magazine/m9mm/compact/rubber
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_HACKED,
		RND_SUBCATEGORY_WEAPONS_AMMO
	)

/datum/design_techweb/mechfab/pistol_mag_compact_9mm_practice
	name = "compact pistol magazine (9mm practice)"
	id = "pistol_mag_compact_9mm_practice"
	materials = list(MAT_STEEL = 600)
	build_type = AUTOLATHE | PROTOLATHE
	build_path = /obj/item/ammo_magazine/m9mm/compact/practice
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_HACKED,
		RND_SUBCATEGORY_WEAPONS_AMMO
	)

/datum/design_techweb/mechfab/pistol_mag_compact_9mm_flash
	name = "compact pistol magazine (9mm flash)"
	id = "pistol_mag_compact_9mm_flash"
	materials = list(MAT_STEEL = 600)
	build_type = AUTOLATHE | PROTOLATHE
	build_path = /obj/item/ammo_magazine/m9mm/compact/flash
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_HACKED,
		RND_SUBCATEGORY_WEAPONS_AMMO
	)

// SMG mags

/datum/design_techweb/mechfab/pistol_mag_smg_9mm
	name = "SMG magazine (9mm)"
	id = "pistol_mag_smg_9mm"
	materials = list(MAT_STEEL = 1500)
	build_type = AUTOLATHE | PROTOLATHE
	build_path = /obj/item/ammo_magazine/m9mml
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_HACKED,
		RND_SUBCATEGORY_WEAPONS_AMMO
	)

/datum/design_techweb/mechfab/pistol_mag_topmount_9mm
	name = "top-mounted SMG magazine (9mm)"
	id = "pistol_mag_topmount_9mm"
	materials = list(MAT_STEEL = 1500)
	build_type = AUTOLATHE | PROTOLATHE
	build_path = /obj/item/ammo_magazine/m9mmt
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_HACKED,
		RND_SUBCATEGORY_WEAPONS_AMMO
	)

/datum/design_techweb/mechfab/pistol_mag_topmount_9mm_rubber
	name = "top-mounted SMG magazine (9mm rubber)"
	id = "pistol_mag_topmount_9mm_rubber"
	materials = list(MAT_STEEL = 1500)
	build_type = AUTOLATHE | PROTOLATHE
	build_path = /obj/item/ammo_magazine/m9mmt/rubber
	category = list(
		RND_CATEGORY_INITIAL,
		RND_SUBCATEGORY_WEAPONS_AMMO
	)

/datum/design_techweb/mechfab/pistol_mag_topmount_9mm_practice
	name = "top-mounted SMG magazine (9mm practice)"
	id = "pistol_mag_topmount_9mm_practice"
	materials = list(MAT_STEEL = 1500)
	build_type = AUTOLATHE | PROTOLATHE
	build_path = /obj/item/ammo_magazine/m9mmt/practice
	category = list(
		RND_CATEGORY_INITIAL,
		RND_SUBCATEGORY_WEAPONS_AMMO
	)

/datum/design_techweb/mechfab/pistol_mag_topmount_9mm_flash
	name = "top-mounted SMG magazine (9mm flash)"
	id = "pistol_mag_topmount_9mm_flash"
	materials = list(MAT_STEEL = 1500)
	build_type = AUTOLATHE | PROTOLATHE
	build_path = /obj/item/ammo_magazine/m9mmt/flash
	category = list(
		RND_CATEGORY_INITIAL,
		RND_SUBCATEGORY_WEAPONS_AMMO
	)

/datum/design_techweb/mechfab/pistol_mag_topmount_9mm_piercing
	name = "top-mounted SMG magazine (9mm armor piercing)"
	id = "pistol_mag_topmount_9mm_piercing"
	materials = list(MAT_STEEL = 1500)
	build_type = AUTOLATHE | PROTOLATHE
	build_path = /obj/item/ammo_magazine/m9mmt/ap
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_HACKED,
		RND_SUBCATEGORY_WEAPONS_AMMO
	)

/////// 10mm

/datum/design_techweb/mechfab/pistol_mag_10m
	name = "SMG magazine (10mm)"
	id = "pistol_mag_10m"
	materials = list(MAT_STEEL = 1800)
	build_type = AUTOLATHE | PROTOLATHE
	build_path = /obj/item/ammo_magazine/m10mm
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_HACKED,
		RND_SUBCATEGORY_WEAPONS_AMMO
	)

/datum/design_techweb/mechfab/pistol_mag_44
	name = "pistol magazine (.44)"
	id = "pistol_mag_44"
	materials = list(MAT_STEEL = 1500)
	build_type = AUTOLATHE | PROTOLATHE
	build_path = /obj/item/ammo_magazine/m44
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_HACKED,
		RND_SUBCATEGORY_WEAPONS_AMMO
	)

/////// 5.45mm

/datum/design_techweb/mechfab/rifle_mag_545
	name = "rifle magazine (5.45mm)"
	id = "rifle_mag_545"
	materials = list(MAT_STEEL = 2250)
	build_type = AUTOLATHE | PROTOLATHE
	build_path = /obj/item/ammo_magazine/m545
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_HACKED,
		RND_SUBCATEGORY_WEAPONS_AMMO
	)

/datum/design_techweb/mechfab/rifle_mag_545_practice
	name = "rifle magazine (5.45mm practice)"
	id = "rifle_mag_545_practice"
	materials = list(MAT_STEEL = 2250)
	build_type = AUTOLATHE | PROTOLATHE
	build_path = /obj/item/ammo_magazine/m545/practice
	category = list(
		RND_CATEGORY_INITIAL,
		RND_SUBCATEGORY_WEAPONS_AMMO
	)

/datum/design_techweb/mechfab/machinegun_box_545
	name = "machinegun box magazine (5.45)"
	id = "machinegun_box_545"
	materials = list(MAT_STEEL = 12500)
	build_type = AUTOLATHE | PROTOLATHE
	build_path = /obj/item/ammo_magazine/m545saw
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_HACKED,
		RND_SUBCATEGORY_WEAPONS_AMMO
	)

/////// 7.62

/datum/design_techweb/mechfab/rifle_mag_762
	name = "rifle magazine (7.62mm)"
	id = "rifle_mag_762"
	materials = list(MAT_STEEL = 2500)
	build_type = AUTOLATHE | PROTOLATHE
	build_path = /obj/item/ammo_magazine/m762
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_HACKED,
		RND_SUBCATEGORY_WEAPONS_AMMO
	)

///////////////////////////////
/*Ammo clips and Speedloaders*/
///////////////////////////////

/////// Shotgun

/datum/design_techweb/mechfab/loader_12g_beanbag
	name = "2-round 12g speedloader (beanbag)"
	id = "loader_12g_beanbag"
	materials = list(MAT_STEEL = 900)
	build_type = AUTOLATHE | PROTOLATHE
	build_path = /obj/item/ammo_magazine/clip/c12g/beanbag
	category = list(
		RND_CATEGORY_INITIAL,
		RND_SUBCATEGORY_WEAPONS_AMMO
	)

/datum/design_techweb/mechfab/loader_12g_slug
	name = "2-round 12g speedloader (slug)"
	id = "loader_12g_slug"
	materials = list(MAT_STEEL = 1350)
	build_type = AUTOLATHE | PROTOLATHE
	build_path = /obj/item/ammo_magazine/clip/c12g
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_HACKED,
		RND_SUBCATEGORY_WEAPONS_AMMO
	)

/datum/design_techweb/mechfab/loader_12g_buck
	name = "2-round 12g speedloader (buckshot)"
	id = "loader_12g_buck"
	materials = list(MAT_STEEL = 1350)
	build_type = AUTOLATHE | PROTOLATHE
	build_path = /obj/item/ammo_magazine/clip/c12g/pellet
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_HACKED,
		RND_SUBCATEGORY_WEAPONS_AMMO
	)

/////// 38

/datum/design_techweb/mechfab/loader_38
	name = "speedloader (.38)"
	id = "loader_38"
	materials = list(MAT_STEEL = 450)
	build_type = AUTOLATHE | PROTOLATHE
	build_path = /obj/item/ammo_magazine/s38
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_HACKED,
		RND_SUBCATEGORY_WEAPONS_AMMO
	)

/datum/design_techweb/mechfab/loader_38_rubber
	name = "speedloader (.38 rubber)"
	id = "loader_38_rubber"
	materials = list(MAT_STEEL = 450)
	build_type = AUTOLATHE | PROTOLATHE
	build_path = /obj/item/ammo_magazine/s38/rubber
	category = list(
		RND_CATEGORY_INITIAL,
		RND_SUBCATEGORY_WEAPONS_AMMO
	)

/////// 45

/datum/design_techweb/mechfab/loader_45
	name = "speedloader (.45)"
	id = "loader_45"
	materials = list(MAT_STEEL = 660)
	build_type = AUTOLATHE | PROTOLATHE
	build_path = /obj/item/ammo_magazine/s45
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_HACKED,
		RND_SUBCATEGORY_WEAPONS_AMMO
	)

/datum/design_techweb/mechfab/loader_45
	name = "speedloader (.45 rubber)"
	id = "loader_45_rubber"
	materials = list(MAT_STEEL = 660)
	build_type = AUTOLATHE | PROTOLATHE
	build_path = /obj/item/ammo_magazine/s45/rubber
	category = list(
		RND_CATEGORY_INITIAL,
		RND_SUBCATEGORY_WEAPONS_AMMO
	)

/////// 5.48

/datum/design_techweb/mechfab/loader_45
	name = "ammo clip (5.45mm)"
	id = "loader_45"
	materials = list(MAT_STEEL = 560)
	build_type = AUTOLATHE | PROTOLATHE
	build_path = /obj/item/ammo_magazine/clip/c545
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_HACKED,
		RND_SUBCATEGORY_WEAPONS_AMMO
	)

/datum/design_techweb/mechfab/loader_45_practice
	name = "ammo clip (5.45mm practice)"
	id = "loader_45_practice"
	materials = list(MAT_STEEL = 560)
	build_type = AUTOLATHE | PROTOLATHE
	build_path = /obj/item/ammo_magazine/clip/c545/practice
	category = list(
		RND_CATEGORY_INITIAL,
		RND_SUBCATEGORY_WEAPONS_AMMO
	)

/////// 762

/datum/design_techweb/mechfab/loader_762
	name = "ammo clip (7.62mm)"
	id = "loader_762"
	materials = list(MAT_STEEL = 1250)
	build_type = AUTOLATHE | PROTOLATHE
	build_path = /obj/item/ammo_magazine/clip/c545
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_HACKED,
		RND_SUBCATEGORY_WEAPONS_AMMO
	)

/datum/design_techweb/mechfab/loader_762
	name = "ammo clip (7.62mm practice)"
	id = "loader_762"
	materials = list(MAT_STEEL = 1250)
	build_type = AUTOLATHE | PROTOLATHE
	build_path = /obj/item/ammo_magazine/clip/c762/practice
	category = list(
		RND_CATEGORY_INITIAL,
		RND_SUBCATEGORY_WEAPONS_AMMO
	)


/////// 357

/datum/design_techweb/mechfab/loader_357
	name = "speedloader (.357)"
	id = "loader_357"
	materials = list(MAT_STEEL = 1500)
	build_type = AUTOLATHE | PROTOLATHE
	build_path = /obj/item/ammo_magazine/s357
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_HACKED,
		RND_SUBCATEGORY_WEAPONS_AMMO
	)

/datum/design_techweb/mechfab/loader_357_flash
	name = "speedloader (.357 flash)"
	id = "loader_357_flash"
	materials = list(MAT_STEEL = 1575)
	build_type = AUTOLATHE | PROTOLATHE
	build_path = /obj/item/ammo_magazine/s357/flash
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_HACKED,
		RND_SUBCATEGORY_WEAPONS_AMMO
	)

/datum/design_techweb/mechfab/loader_357_stun
	name = "speedloader (.357 stun)"
	id = "loader_357_stun"
	materials = list(MAT_STEEL = 1575)
	build_type = AUTOLATHE | PROTOLATHE
	build_path = /obj/item/ammo_magazine/s357/stun
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_HACKED,
		RND_SUBCATEGORY_WEAPONS_AMMO
	)

/datum/design_techweb/mechfab/loader_357_rubber
	name = "speedloader (.357 rubber)"
	id = "loader_357_rubber"
	materials = list(MAT_STEEL = 1575)
	build_type = AUTOLATHE | PROTOLATHE
	build_path = /obj/item/ammo_magazine/s357/rubber
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_HACKED,
		RND_SUBCATEGORY_WEAPONS_AMMO
	)

/////// 44

/datum/design_techweb/mechfab/loader_44
	name = "speedloader (.44)"
	id = "loader_44"
	materials = list(MAT_STEEL = 1575)
	build_type = AUTOLATHE | PROTOLATHE
	build_path = /obj/item/ammo_magazine/s44
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_HACKED,
		RND_SUBCATEGORY_WEAPONS_AMMO
	)

/datum/design_techweb/mechfab/loader_44_rubber
	name = "speedloader (.44 rubber)"
	id = "loader_44_rubber"
	materials = list(MAT_STEEL = 1575)
	build_type = AUTOLATHE | PROTOLATHE
	build_path = /obj/item/ammo_magazine/s44/rubber
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_HACKED,
		RND_SUBCATEGORY_WEAPONS_AMMO
	)

/datum/design_techweb/mechfab/rifle_magazine_44
	name = "magazine (.44)"
	id = "rifle_magazine_44"
	materials = list(MAT_STEEL = 1575)
	build_type = AUTOLATHE | PROTOLATHE
	build_path = /obj/item/ammo_magazine/m44
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_HACKED,
		RND_SUBCATEGORY_WEAPONS_AMMO
	)

/datum/design_techweb/mechfab/rifle_magazine_44_rubber
	name = "magazine (.44 rubber)"
	id = "rifle_magazine_44_rubber"
	materials = list(MAT_STEEL = 2200)
	build_type = AUTOLATHE | PROTOLATHE
	build_path = /obj/item/ammo_magazine/m44/rubber
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_HACKED,
		RND_SUBCATEGORY_WEAPONS_AMMO
	)
