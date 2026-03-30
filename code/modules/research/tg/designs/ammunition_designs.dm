//////////////////
/*Shotgun rounds*/
//////////////////

/datum/design_techweb/ammobox_12g_slug
	SET_AMMO_DESIGN_NAMEDESC("ammo box (12 gauge slug)")
	id = "ammobox_12g_slug"
	materials = list(MAT_STEEL = 3600)
	build_type = AUTOLATHE
	build_path = /obj/item/ammo_magazine/ammo_box/b12g
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_HACKED,
		RND_SUBCATEGORY_WEAPONS_AMMO + RND_SUBCATEGORY_WEAPONS_AMMO_SHOTGUN
	)

/datum/design_techweb/ammobox_12g_blank
	SET_AMMO_DESIGN_NAMEDESC("ammo box (12 gauge blank)")
	id = "ammobox_12g_blank"
	materials = list(MAT_STEEL = 3600)
	build_type = AUTOLATHE
	build_path = /obj/item/ammo_magazine/ammo_box/b12g/blank
	category = list(
		RND_CATEGORY_INITIAL,
		RND_SUBCATEGORY_WEAPONS_AMMO + RND_SUBCATEGORY_WEAPONS_AMMO_SHOTGUN
	)

/datum/design_techweb/ammobox_12g_beanbag
	SET_AMMO_DESIGN_NAMEDESC("ammo box (12 gauge beanbag)")
	id = "ammobox_12g_beanbag"
	materials = list(MAT_STEEL = 3600)
	build_type = AUTOLATHE
	build_path = /obj/item/ammo_magazine/ammo_box/b12g/beanbag
	category = list(
		RND_CATEGORY_INITIAL,
		RND_SUBCATEGORY_WEAPONS_AMMO + RND_SUBCATEGORY_WEAPONS_AMMO_SHOTGUN
	)

/datum/design_techweb/ammobox_12g_flash
	SET_AMMO_DESIGN_NAMEDESC("ammo box (12 gauge flash)")
	id = "ammobox_12g_flash"
	materials = list(MAT_STEEL = 920, MAT_GLASS = 920)
	build_type = AUTOLATHE
	build_path = /obj/item/ammo_magazine/ammo_box/b12g/flash
	category = list(
		RND_CATEGORY_INITIAL,
		RND_SUBCATEGORY_WEAPONS_AMMO + RND_SUBCATEGORY_WEAPONS_AMMO_SHOTGUN
	)

/datum/design_techweb/ammobox_12g_pellet
	SET_AMMO_DESIGN_NAMEDESC("ammo box (12 gauge buckshot)")
	id = "ammobox_12g_pellet"
	materials = list(MAT_STEEL = 3600)
	build_type = AUTOLATHE
	build_path = /obj/item/ammo_magazine/ammo_box/b12g/pellet
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_HACKED,
		RND_SUBCATEGORY_WEAPONS_AMMO + RND_SUBCATEGORY_WEAPONS_AMMO_SHOTGUN
	)

/datum/design_techweb/ammobox_12g_stunshell
	SET_AMMO_DESIGN_NAMEDESC("ammo box (12 gauge stun)")
	id = "ammobox_12g_stunshell"
	materials = list(MAT_STEEL = 3600, MAT_GLASS = 7200)
	build_type = AUTOLATHE
	build_path = /obj/item/ammo_magazine/ammo_box/b12g/stunshell
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_HACKED,
		RND_SUBCATEGORY_WEAPONS_AMMO + RND_SUBCATEGORY_WEAPONS_AMMO_SHOTGUN
	)

/datum/design_techweb/ammobox_12g_emp
	SET_AMMO_DESIGN_NAMEDESC("ammo box (12 gauge EMP)")
	id = "ammobox_12g_emp"
	materials = list(MAT_STEEL = 3600, MAT_URANIUM = 7200)
	build_type = AUTOLATHE
	build_path = /obj/item/ammo_magazine/ammo_box/b12g/emp
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_HACKED,
		RND_SUBCATEGORY_WEAPONS_AMMO + RND_SUBCATEGORY_WEAPONS_AMMO_SHOTGUN
	)

/datum/design_techweb/ammobox_12g_flechette
	SET_AMMO_DESIGN_NAMEDESC("ammo box (12 gauge flechette)")
	id = "ammobox_12g_flechette"
	materials = list(MAT_STEEL = 3600, MAT_PLASTEEL = 7200)
	build_type = AUTOLATHE
	build_path = /obj/item/ammo_magazine/ammo_box/b12g/flechette
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_HACKED,
		RND_SUBCATEGORY_WEAPONS_AMMO + RND_SUBCATEGORY_WEAPONS_AMMO_SHOTGUN
	)

/datum/design_techweb/ammobox_12g_practice
	SET_AMMO_DESIGN_NAMEDESC("ammo box (12 gauge practice)")
	id = "ammobox_12g_practice"
	materials = list(MAT_STEEL = 3600)
	build_type = AUTOLATHE
	build_path = /obj/item/ammo_magazine/ammo_box/b12g/practice
	category = list(
		RND_CATEGORY_INITIAL,
		RND_SUBCATEGORY_WEAPONS_AMMO + RND_SUBCATEGORY_WEAPONS_AMMO_SHOTGUN
	)

//////////////////
/* High velocity*/
//////////////////

/datum/design_techweb/rifle_145_sabot
	SET_AMMO_DESIGN_NAMEDESC("14.5mm round (sabot)")
	id = "rifle_145_sabot"
	materials = list(MAT_STEEL = 1560)
	build_type = AUTOLATHE
	build_path = /obj/item/ammo_casing/a145/highvel
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_HACKED,
		RND_SUBCATEGORY_WEAPONS_AMMO + RND_SUBCATEGORY_WEAPONS_AMMO_RIFLE
	)

//////////////////
/*Ammo magazines*/
//////////////////

/////// .44

/datum/design_techweb/pistol_mag_44
	SET_AMMO_DESIGN_NAMEDESC("pistol magazine (.44)")
	id = "pistol_mag_44"
	materials = list(MAT_STEEL = 1500)
	build_type = AUTOLATHE
	build_path = /obj/item/ammo_magazine/m44
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_HACKED,
		RND_SUBCATEGORY_WEAPONS_AMMO + RND_SUBCATEGORY_WEAPONS_AMMO_PISTOL
	)

/datum/design_techweb/pistol_mag_44_rubber
	SET_AMMO_DESIGN_NAMEDESC("pistol magazine (.44 rubber)")
	id = "pistol_mag_44_rubber"
	materials = list(MAT_STEEL = 2200)
	build_type = AUTOLATHE
	build_path = /obj/item/ammo_magazine/m44/rubber
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_HACKED,
		RND_SUBCATEGORY_WEAPONS_AMMO + RND_SUBCATEGORY_WEAPONS_AMMO_PISTOL
	)

/////// .45

/datum/design_techweb/pistol_mag_45
	SET_AMMO_DESIGN_NAMEDESC("pistol magazine (.45)")
	id = "pistol_mag_45"
	materials = list(MAT_STEEL = 650)
	build_type = AUTOLATHE
	build_path = /obj/item/ammo_magazine/m45
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_HACKED,
		RND_SUBCATEGORY_WEAPONS_AMMO + RND_SUBCATEGORY_WEAPONS_AMMO_PISTOL
	)

/datum/design_techweb/pistol_mag_45_practice
	SET_AMMO_DESIGN_NAMEDESC("pistol magazine (.45 practice)")
	id = "pistol_mag_45_practice"
	materials = list(MAT_STEEL = 650)
	build_type = AUTOLATHE
	build_path = /obj/item/ammo_magazine/m45/practice
	category = list(
		RND_CATEGORY_INITIAL,
		RND_SUBCATEGORY_WEAPONS_AMMO + RND_SUBCATEGORY_WEAPONS_AMMO_PISTOL
	)

/datum/design_techweb/pistol_mag_45_rubber
	SET_AMMO_DESIGN_NAMEDESC("pistol magazine (.45 rubber)")
	id = "pistol_mag_45_rubber"
	materials = list(MAT_STEEL = 650)
	build_type = AUTOLATHE
	build_path = /obj/item/ammo_magazine/m45/rubber
	category = list(
		RND_CATEGORY_INITIAL,
		RND_SUBCATEGORY_WEAPONS_AMMO + RND_SUBCATEGORY_WEAPONS_AMMO_PISTOL
	)

/datum/design_techweb/pistol_mag_45_flash
	SET_AMMO_DESIGN_NAMEDESC("pistol magazine (.45 flash)")
	id = "pistol_mag_45_flash"
	materials = list(MAT_STEEL = 650)
	build_type = AUTOLATHE
	build_path = /obj/item/ammo_magazine/m45/flash
	category = list(
		RND_CATEGORY_INITIAL,
		RND_SUBCATEGORY_WEAPONS_AMMO + RND_SUBCATEGORY_WEAPONS_AMMO_PISTOL
	)

/datum/design_techweb/pistol_mag_45_piercing
	SET_AMMO_DESIGN_NAMEDESC("pistol magazine (.45 armor piercing)")
	id = "pistol_mag_45_piercing"
	materials = list(MAT_STEEL = 500, MAT_PLASTEEL = 300)
	build_type = AUTOLATHE
	build_path = /obj/item/ammo_magazine/m45/ap
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_HACKED,
		RND_SUBCATEGORY_WEAPONS_AMMO + RND_SUBCATEGORY_WEAPONS_AMMO_PISTOL
	)

/datum/design_techweb/pistol_mag_45_hollow
	SET_AMMO_DESIGN_NAMEDESC("pistol magazine (.45 hollowpoint)")
	id = "pistol_mag_45_hollow"
	materials = list(MAT_STEEL = 500, MAT_PLASTEEL = 200)
	build_type = AUTOLATHE
	build_path = /obj/item/ammo_magazine/m45/hp
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_HACKED,
		RND_SUBCATEGORY_WEAPONS_AMMO + RND_SUBCATEGORY_WEAPONS_AMMO_PISTOL
	)

/////// specialty 45

/datum/design_techweb/uzi_mag_45
	SET_AMMO_DESIGN_NAMEDESC("uzi magazine (.45)")
	id = "uzi_mag_45"
	materials = list(MAT_STEEL = 1500)
	build_type = AUTOLATHE
	build_path = /obj/item/ammo_magazine/m45uzi
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_HACKED,
		RND_SUBCATEGORY_WEAPONS_AMMO + RND_SUBCATEGORY_WEAPONS_AMMO_RIFLE
	)

/datum/design_techweb/tommy_mag_45
	SET_AMMO_DESIGN_NAMEDESC("Tommy Gun magazine (.45)")
	id = "tommy_mag_45"
	materials = list(MAT_STEEL = 1875)
	build_type = AUTOLATHE
	build_path = /obj/item/ammo_magazine/m45tommy
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_HACKED,
		RND_SUBCATEGORY_WEAPONS_AMMO + RND_SUBCATEGORY_WEAPONS_AMMO_RIFLE
	)

/datum/design_techweb/tommy_mag_45_pierce
	SET_AMMO_DESIGN_NAMEDESC("Tommy Gun magazine (.45 armor piercing)")
	id = "tommy_mag_45_pierce"
	materials = list(MAT_STEEL = 1875, MAT_PLASTEEL = 1600)
	build_type = AUTOLATHE
	build_path = /obj/item/ammo_magazine/m45tommy/ap
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_HACKED,
		RND_SUBCATEGORY_WEAPONS_AMMO + RND_SUBCATEGORY_WEAPONS_AMMO_RIFLE
	)

/datum/design_techweb/tommy_drum_45
	SET_AMMO_DESIGN_NAMEDESC("Tommy Gun drum magazine (.45)")
	id = "tommy_drum_45"
	materials = list(MAT_STEEL = 4680)
	build_type = AUTOLATHE
	build_path = /obj/item/ammo_magazine/m45tommydrum
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_HACKED,
		RND_SUBCATEGORY_WEAPONS_AMMO + RND_SUBCATEGORY_WEAPONS_AMMO_RIFLE
	)

/datum/design_techweb/tommy_drum_45_pierce
	SET_AMMO_DESIGN_NAMEDESC("Tommy Gun drum magazine (.45 piercing)")
	id = "tommy_drum_45_pierce"
	materials = list(MAT_STEEL = 4680, MAT_PLASTEEL = 3200)
	build_type = AUTOLATHE
	build_path = /obj/item/ammo_magazine/m45tommydrum/ap
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_HACKED,
		RND_SUBCATEGORY_WEAPONS_AMMO + RND_SUBCATEGORY_WEAPONS_AMMO_RIFLE
	)

/////// 9mm

// Full size pistol mags.

/datum/design_techweb/pistol_mag_9mm
	SET_AMMO_DESIGN_NAMEDESC("pistol magazine (9mm)")
	id = "pistol_mag_9mm"
	materials = list(MAT_STEEL = 750)
	build_type = AUTOLATHE
	build_path = /obj/item/ammo_magazine/m9mm
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_HACKED,
		RND_SUBCATEGORY_WEAPONS_AMMO + RND_SUBCATEGORY_WEAPONS_AMMO_PISTOL
	)

/datum/design_techweb/pistol_mag_9mm_rubber
	SET_AMMO_DESIGN_NAMEDESC("pistol magazine (9mm rubber)")
	id = "pistol_mag_9mm_rubber"
	materials = list(MAT_STEEL = 750)
	build_type = AUTOLATHE
	build_path = /obj/item/ammo_magazine/m9mm/rubber
	category = list(
		RND_CATEGORY_INITIAL,
		RND_SUBCATEGORY_WEAPONS_AMMO + RND_SUBCATEGORY_WEAPONS_AMMO_PISTOL
	)

/datum/design_techweb/pistol_mag_9mm_practice
	SET_AMMO_DESIGN_NAMEDESC("pistol magazine (9mm practice)")
	id = "pistol_mag_9mm_practice"
	materials = list(MAT_STEEL = 750)
	build_type = AUTOLATHE
	build_path = /obj/item/ammo_magazine/m9mm/practice
	category = list(
		RND_CATEGORY_INITIAL,
		RND_SUBCATEGORY_WEAPONS_AMMO + RND_SUBCATEGORY_WEAPONS_AMMO_PISTOL
	)

/datum/design_techweb/pistol_mag_9mm_flash
	SET_AMMO_DESIGN_NAMEDESC("pistol magazine (9mm flash)")
	id = "pistol_mag_9mm_flash"
	materials = list(MAT_STEEL = 750)
	build_type = AUTOLATHE
	build_path = /obj/item/ammo_magazine/m9mm/flash
	category = list(
		RND_CATEGORY_INITIAL,
		RND_SUBCATEGORY_WEAPONS_AMMO + RND_SUBCATEGORY_WEAPONS_AMMO_PISTOL
	)

/datum/design_techweb/pistol_mag_9mm_spectral
	SET_AMMO_DESIGN_NAMEDESC("pistol magazine (9mm spectral)")
	id = "pistol_mag_9mm_spectral"
	materials = list(MAT_STEEL = 750)
	build_type = AUTOLATHE
	build_path = /obj/item/ammo_magazine/m9mm/spectral
	category = list(
		RND_CATEGORY_INITIAL,
		RND_SUBCATEGORY_WEAPONS_AMMO + RND_SUBCATEGORY_WEAPONS_AMMO_PISTOL
	)

// Small mags for small or old guns. These are all hidden because they are traitor mags and will otherwise just clutter the Autolathe.

/datum/design_techweb/pistol_mag_compact_9mm
	SET_AMMO_DESIGN_NAMEDESC("compact pistol magazine (9mm)")
	id = "pistol_mag_compact_9mm"
	materials = list(MAT_STEEL = 600)
	build_type = AUTOLATHE
	build_path = /obj/item/ammo_magazine/m9mm/compact
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_HACKED,
		RND_SUBCATEGORY_WEAPONS_AMMO + RND_SUBCATEGORY_WEAPONS_AMMO_PISTOL
	)

/datum/design_techweb/pistol_mag_compact_9mm_rubber
	SET_AMMO_DESIGN_NAMEDESC("compact pistol magazine (9mm rubber)")
	id = "pistol_mag_compact_9mm_rubber"
	materials = list(MAT_STEEL = 600)
	build_type = AUTOLATHE
	build_path = /obj/item/ammo_magazine/m9mm/compact/rubber
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_HACKED,
		RND_SUBCATEGORY_WEAPONS_AMMO + RND_SUBCATEGORY_WEAPONS_AMMO_PISTOL
	)

/datum/design_techweb/pistol_mag_compact_9mm_practice
	SET_AMMO_DESIGN_NAMEDESC("compact pistol magazine (9mm practice)")
	id = "pistol_mag_compact_9mm_practice"
	materials = list(MAT_STEEL = 600)
	build_type = AUTOLATHE
	build_path = /obj/item/ammo_magazine/m9mm/compact/practice
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_HACKED,
		RND_SUBCATEGORY_WEAPONS_AMMO + RND_SUBCATEGORY_WEAPONS_AMMO_PISTOL
	)

/datum/design_techweb/pistol_mag_compact_9mm_flash
	SET_AMMO_DESIGN_NAMEDESC("compact pistol magazine (9mm flash)")
	id = "pistol_mag_compact_9mm_flash"
	materials = list(MAT_STEEL = 600)
	build_type = AUTOLATHE
	build_path = /obj/item/ammo_magazine/m9mm/compact/flash
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_HACKED,
		RND_SUBCATEGORY_WEAPONS_AMMO + RND_SUBCATEGORY_WEAPONS_AMMO_PISTOL
	)

// SMG mags

/datum/design_techweb/smg_mag_9mm
	SET_AMMO_DESIGN_NAMEDESC("SMG magazine (9mm)")
	id = "smg_mag_9mm"
	materials = list(MAT_STEEL = 1500)
	build_type = AUTOLATHE
	build_path = /obj/item/ammo_magazine/m9mml
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_HACKED,
		RND_SUBCATEGORY_WEAPONS_AMMO + RND_SUBCATEGORY_WEAPONS_AMMO_RIFLE
	)

/datum/design_techweb/pistol_mag_topmount_9mm
	SET_AMMO_DESIGN_NAMEDESC("top-mounted SMG magazine (9mm)")
	id = "pistol_mag_topmount_9mm"
	materials = list(MAT_STEEL = 1500)
	build_type = AUTOLATHE
	build_path = /obj/item/ammo_magazine/m9mmt
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_HACKED,
		RND_SUBCATEGORY_WEAPONS_AMMO + RND_SUBCATEGORY_WEAPONS_AMMO_RIFLE
	)

/datum/design_techweb/pistol_mag_topmount_9mm_rubber
	SET_AMMO_DESIGN_NAMEDESC("top-mounted SMG magazine (9mm rubber)")
	id = "pistol_mag_topmount_9mm_rubber"
	materials = list(MAT_STEEL = 1500)
	build_type = AUTOLATHE
	build_path = /obj/item/ammo_magazine/m9mmt/rubber
	category = list(
		RND_CATEGORY_INITIAL,
		RND_SUBCATEGORY_WEAPONS_AMMO + RND_SUBCATEGORY_WEAPONS_AMMO_RIFLE
	)

/datum/design_techweb/pistol_mag_topmount_9mm_practice
	SET_AMMO_DESIGN_NAMEDESC("top-mounted SMG magazine (9mm practice)")
	id = "pistol_mag_topmount_9mm_practice"
	materials = list(MAT_STEEL = 1500)
	build_type = AUTOLATHE
	build_path = /obj/item/ammo_magazine/m9mmt/practice
	category = list(
		RND_CATEGORY_INITIAL,
		RND_SUBCATEGORY_WEAPONS_AMMO + RND_SUBCATEGORY_WEAPONS_AMMO_RIFLE
	)

/datum/design_techweb/pistol_mag_topmount_9mm_flash
	SET_AMMO_DESIGN_NAMEDESC("top-mounted SMG magazine (9mm flash)")
	id = "pistol_mag_topmount_9mm_flash"
	materials = list(MAT_STEEL = 1500)
	build_type = AUTOLATHE
	build_path = /obj/item/ammo_magazine/m9mmt/flash
	category = list(
		RND_CATEGORY_INITIAL,
		RND_SUBCATEGORY_WEAPONS_AMMO + RND_SUBCATEGORY_WEAPONS_AMMO_RIFLE
	)

/datum/design_techweb/pistol_mag_topmount_9mm_piercing
	SET_AMMO_DESIGN_NAMEDESC("top-mounted SMG magazine (9mm armor piercing)")
	id = "pistol_mag_topmount_9mm_piercing"
	materials = list(MAT_STEEL = 1500)
	build_type = AUTOLATHE
	build_path = /obj/item/ammo_magazine/m9mmt/ap
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_HACKED,
		RND_SUBCATEGORY_WEAPONS_AMMO + RND_SUBCATEGORY_WEAPONS_AMMO_RIFLE
	)

/datum/design_techweb/pistol_mag_ext_topmount_9mm_piercing
	SET_AMMO_DESIGN_NAMEDESC("top-mounted extended SMG magazine (9mm AP)")
	id = "pistol_mag_ext_topmount_9mm_piercing"
	materials = list(MAT_STEEL = 3000, MAT_PLASTEEL = 1500)
	build_type = AUTOLATHE
	build_path = /obj/item/ammo_magazine/m9mmp90
	category = list(
		RND_CATEGORY_INITIAL,
		RND_SUBCATEGORY_WEAPONS_AMMO + RND_SUBCATEGORY_WEAPONS_AMMO_RIFLE
	)

/datum/design_techweb/ammo_9mmAdvanced // Special PDW ammo
	SET_AMMO_DESIGN_NAMEDESC("advanced 9mm magazine")
	id = "ammo_9mm"
	// req_tech = list(TECH_COMBAT = 4, TECH_MATERIAL = 3)
	build_type = AUTOLATHE | PROTOLATHE
	materials = list(MAT_STEEL = 3750, MAT_SILVER = 100) // Requires silver for proprietary magazines! Or something.
	build_path = /obj/item/ammo_magazine/m9mmAdvanced
	category = list(
		RND_CATEGORY_WEAPONS + RND_SUBCATEGORY_WEAPONS_AMMO
	)
	departmental_flags = DEPARTMENT_BITFLAG_SECURITY | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/smg_mag_9mm_spectral
	SET_AMMO_DESIGN_NAMEDESC("SMG magazine (9mm spectral)")
	id = "smg_mag_9mm_spectral"
	materials = list(MAT_STEEL = 1500)
	build_type = AUTOLATHE
	build_path = /obj/item/ammo_magazine/m9mml/spectral
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_HACKED,
		RND_SUBCATEGORY_WEAPONS_AMMO + RND_SUBCATEGORY_WEAPONS_AMMO_RIFLE
	)

/////// 10mm

/datum/design_techweb/smg_mag_10m
	SET_AMMO_DESIGN_NAMEDESC("SMG magazine (10mm)")
	id = "smg_mag_10m"
	materials = list(MAT_STEEL = 1800)
	build_type = AUTOLATHE
	build_path = /obj/item/ammo_magazine/m10mm
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_HACKED,
		RND_SUBCATEGORY_WEAPONS_AMMO + RND_SUBCATEGORY_WEAPONS_AMMO_RIFLE
	)

/datum/design_techweb/smg_mag_10m_practice
	SET_AMMO_DESIGN_NAMEDESC("SMG magazine (10mm practice)")
	id = "smg_mag_10m_practice"
	materials = list(MAT_STEEL = 1800)
	build_type = AUTOLATHE
	build_path = /obj/item/ammo_magazine/m10mm/practice
	category = list(
		RND_CATEGORY_INITIAL,
		RND_SUBCATEGORY_WEAPONS_AMMO + RND_SUBCATEGORY_WEAPONS_AMMO_RIFLE
	)

/datum/design_techweb/smg_mag_10m_rubber
	SET_AMMO_DESIGN_NAMEDESC("SMG magazine (10mm rubber)")
	id = "smg_mag_10m_rubber"
	materials = list(MAT_STEEL = 1800)
	build_type = AUTOLATHE
	build_path = /obj/item/ammo_magazine/m10mm/rubber
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_HACKED,
		RND_SUBCATEGORY_WEAPONS_AMMO + RND_SUBCATEGORY_WEAPONS_AMMO_RIFLE
	)

/datum/design_techweb/smg_mag_10m_emp
	SET_AMMO_DESIGN_NAMEDESC("SMG magazine (10mm haywire)")
	id = "smg_mag_10m_emp"
	materials = list(MAT_STEEL = 1800, MAT_URANIUM = 2400)
	build_type = AUTOLATHE
	build_path = /obj/item/ammo_magazine/m10mm/emp
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_HACKED,
		RND_SUBCATEGORY_WEAPONS_AMMO + RND_SUBCATEGORY_WEAPONS_AMMO_RIFLE
	)

/datum/design_techweb/pistol_mag_10m
	SET_AMMO_DESIGN_NAMEDESC("pistol magazine (10mm)")
	id = "pistol_mag_10m"
	materials = list(MAT_STEEL = 1800)
	build_type = AUTOLATHE
	build_path = /obj/item/ammo_magazine/m10mm/pistol
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_HACKED,
		RND_SUBCATEGORY_WEAPONS_AMMO + RND_SUBCATEGORY_WEAPONS_AMMO_PISTOL
	)

/datum/design_techweb/pistol_mag_10m_rubber
	SET_AMMO_DESIGN_NAMEDESC("pistol magazine (10mm rubber)")
	id = "pistol_mag_10m_rubber"
	materials = list(MAT_STEEL = 1800)
	build_type = AUTOLATHE
	build_path = /obj/item/ammo_magazine/m10mm/pistol/rubber
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_HACKED,
		RND_SUBCATEGORY_WEAPONS_AMMO + RND_SUBCATEGORY_WEAPONS_AMMO_PISTOL
	)

/datum/design_techweb/pistol_mag_10m_emp
	SET_AMMO_DESIGN_NAMEDESC("pistol magazine (10mm haywire)")
	id = "pistol_mag_10m_emp"
	materials = list(MAT_STEEL = 1800, MAT_URANIUM = 2400)
	build_type = AUTOLATHE
	build_path = /obj/item/ammo_magazine/m10mm/pistol/emp
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_HACKED,
		RND_SUBCATEGORY_WEAPONS_AMMO + RND_SUBCATEGORY_WEAPONS_AMMO_PISTOL
	)

/datum/design_techweb/pistol_mag_10m_practice
	SET_AMMO_DESIGN_NAMEDESC("pistol magazine (10mm practice)")
	id = "pistol_mag_10m_practice"
	materials = list(MAT_STEEL = 1800)
	build_type = AUTOLATHE
	build_path = /obj/item/ammo_magazine/m10mm/pistol/practice
	category = list(
		RND_CATEGORY_INITIAL,
		RND_SUBCATEGORY_WEAPONS_AMMO + RND_SUBCATEGORY_WEAPONS_AMMO_PISTOL
	)

/////// 5.45mm

/datum/design_techweb/rifle_mag_545
	SET_AMMO_DESIGN_NAMEDESC("rifle magazine (5.45mm)")
	id = "rifle_mag_545"
	materials = list(MAT_STEEL = 2250)
	build_type = AUTOLATHE
	build_path = /obj/item/ammo_magazine/m545
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_HACKED,
		RND_SUBCATEGORY_WEAPONS_AMMO + RND_SUBCATEGORY_WEAPONS_AMMO_RIFLE
	)

/datum/design_techweb/rifle_mag_545_practice
	SET_AMMO_DESIGN_NAMEDESC("rifle magazine (5.45mm practice)")
	id = "rifle_mag_545_practice"
	materials = list(MAT_STEEL = 2250)
	build_type = AUTOLATHE
	build_path = /obj/item/ammo_magazine/m545/practice
	category = list(
		RND_CATEGORY_INITIAL,
		RND_SUBCATEGORY_WEAPONS_AMMO + RND_SUBCATEGORY_WEAPONS_AMMO_RIFLE
	)

/datum/design_techweb/rifle_mag_545_pierce
	SET_AMMO_DESIGN_NAMEDESC("Rifle Magazine (5.45mm AP)")
	id = "rifle_mag_545_pierce"
	materials = list(MAT_STEEL = 2250, MAT_PLASTEEL = 1200)
	build_type = AUTOLATHE
	build_path = /obj/item/ammo_magazine/m545/ap
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_HACKED,
		RND_SUBCATEGORY_WEAPONS_AMMO + RND_SUBCATEGORY_WEAPONS_AMMO_RIFLE
	)

/datum/design_techweb/machinegun_box_545
	SET_AMMO_DESIGN_NAMEDESC("machinegun box magazine (5.45)")
	id = "machinegun_box_545"
	materials = list(MAT_STEEL = 12500)
	build_type = AUTOLATHE
	build_path = /obj/item/ammo_magazine/m545saw
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_HACKED,
		RND_SUBCATEGORY_WEAPONS_AMMO + RND_SUBCATEGORY_WEAPONS_AMMO_RIFLE
	)

/datum/design_techweb/machinegun_box_545_pierce
	SET_AMMO_DESIGN_NAMEDESC("machinegun box magazine (5.45mm armor-piercing)")
	id = "machinegun_box_545_pierce"
	materials = list(MAT_STEEL = 12500)
	build_type = AUTOLATHE
	build_path = /obj/item/ammo_casing/a545/ap
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_HACKED,
		RND_SUBCATEGORY_WEAPONS_AMMO + RND_SUBCATEGORY_WEAPONS_AMMO_RIFLE
	)

/datum/design_techweb/machinegun_box_545_hunting
	SET_AMMO_DESIGN_NAMEDESC("machinegun box magazine (5.45mm hunting)")
	id = "machinegun_box_545_hunting"
	materials = list(MAT_STEEL = 12500)
	build_type = AUTOLATHE
	build_path = /obj/item/ammo_magazine/m545saw/hunter
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_HACKED,
		RND_SUBCATEGORY_WEAPONS_AMMO + RND_SUBCATEGORY_WEAPONS_AMMO_RIFLE
	)

/datum/design_techweb/machinegun_box_545_pierce
	SET_AMMO_DESIGN_NAMEDESC("Machinegun box magazine (5.45mm AP)")
	id = "machinegun_box_545_pierce"
	materials = list(MAT_STEEL = 12500, MAT_PLASTEEL = 15000)
	build_type = AUTOLATHE
	build_path = /obj/item/ammo_magazine/m545saw/ap
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_HACKED,
		RND_SUBCATEGORY_WEAPONS_AMMO + RND_SUBCATEGORY_WEAPONS_AMMO_RIFLE
	)

/datum/design_techweb/rifle_mag_545_hunting
	SET_AMMO_DESIGN_NAMEDESC("Rifle Magazine (5.45mm Hunting)")
	id = "rifle_mag_545_hunting"
	materials = list(MAT_STEEL = 3375)
	build_type = AUTOLATHE
	build_path = /obj/item/ammo_magazine/m545/hunter
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_HACKED,
		RND_SUBCATEGORY_WEAPONS_AMMO + RND_SUBCATEGORY_WEAPONS_AMMO_RIFLE
	)

/////// 7.62

/datum/design_techweb/rifle_mag_762
	SET_AMMO_DESIGN_NAMEDESC("rifle magazine (7.62mm)")
	id = "rifle_mag_762"
	materials = list(MAT_STEEL = 2500)
	build_type = AUTOLATHE
	build_path = /obj/item/ammo_magazine/m762
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_HACKED,
		RND_SUBCATEGORY_WEAPONS_AMMO + RND_SUBCATEGORY_WEAPONS_AMMO_RIFLE
	)

/datum/design_techweb/rifle_mag_762_pierce
	SET_AMMO_DESIGN_NAMEDESC("rifle magazine (7.62mm AP)")
	id = "rifle_mag_762_pierce"
	materials = list(MAT_STEEL = 2500, MAT_PLASTEEL = 1200)
	build_type = AUTOLATHE
	build_path = /obj/item/ammo_magazine/m762/ap
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_HACKED,
		RND_SUBCATEGORY_WEAPONS_AMMO + RND_SUBCATEGORY_WEAPONS_AMMO_RIFLE
	)

/datum/design_techweb/rifle_mag_762_ext
	SET_AMMO_DESIGN_NAMEDESC("rifle magazine (7.62mm) extended")
	id = "rifle_mag_762_ext"
	materials = list(MAT_STEEL = 5000)
	build_type = AUTOLATHE
	build_path = /obj/item/ammo_magazine/m762/ext
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_HACKED,
		RND_SUBCATEGORY_WEAPONS_AMMO + RND_SUBCATEGORY_WEAPONS_AMMO_RIFLE
	)

/datum/design_techweb/rifle_mag_762_ap_ext
	SET_AMMO_DESIGN_NAMEDESC("rifle magazine (7.62mm AP) extended")
	id = "rifle_mag_762_ext_pierce"
	materials = list(MAT_STEEL = 5000, MAT_PLASTEEL = 2400)
	build_type = AUTOLATHE
	build_path = /obj/item/ammo_magazine/m762/ext/ap
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_HACKED,
		RND_SUBCATEGORY_WEAPONS_AMMO + RND_SUBCATEGORY_WEAPONS_AMMO_RIFLE
	)

/datum/design_techweb/rifle_enblock_762
	SET_AMMO_DESIGN_NAMEDESC("enbloc (7.62mm)")
	id = "rifle_enblock_762"
	materials = list(MAT_STEEL = 2500)
	build_type = AUTOLATHE
	build_path = /obj/item/ammo_magazine/m762enbloc
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_HACKED,
		RND_SUBCATEGORY_WEAPONS_AMMO + RND_SUBCATEGORY_WEAPONS_AMMO_RIFLE
	)

/datum/design_techweb/rifle_enblock_762_pierce
	SET_AMMO_DESIGN_NAMEDESC("enbloc (7.62mm AP)")
	id = "rifle_enblock_762_pierce"
	materials = list(MAT_STEEL = 2500, MAT_PLASTEEL = 1800)
	build_type = AUTOLATHE
	build_path = /obj/item/ammo_magazine/m762enbloc/ap
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_HACKED,
		RND_SUBCATEGORY_WEAPONS_AMMO + RND_SUBCATEGORY_WEAPONS_AMMO_RIFLE
	)

// 12guage auto-shotgun

/datum/design_techweb/shotgun_mag_12g_drum
	SET_AMMO_DESIGN_NAMEDESC("drum magazine (12 gauge)")
	id = "shotgun_mag_12g_drum"
	materials = list(MAT_STEEL = 18000)
	build_type = AUTOLATHE
	build_path = /obj/item/ammo_magazine/m12gdrum
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_HACKED,
		RND_SUBCATEGORY_WEAPONS_AMMO + RND_SUBCATEGORY_WEAPONS_AMMO_SHOTGUN
	)

/datum/design_techweb/shotgun_mag_12g_drum_beanbag
	SET_AMMO_DESIGN_NAMEDESC("drum magazine (12 gauge beanbag)")
	id = "shotgun_mag_12g_drum_beanbag"
	materials = list(MAT_STEEL = 18000)
	build_type = AUTOLATHE
	build_path = /obj/item/ammo_magazine/m12gdrum/beanbag
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_HACKED,
		RND_SUBCATEGORY_WEAPONS_AMMO + RND_SUBCATEGORY_WEAPONS_AMMO_SHOTGUN
	)

/datum/design_techweb/shotgun_mag_12g_drum_pellet
	SET_AMMO_DESIGN_NAMEDESC("drum magazine (12 gauge pellet)")
	id = "shotgun_mag_12g_drum_pellet"
	materials = list(MAT_STEEL = 18000)
	build_type = AUTOLATHE
	build_path = /obj/item/ammo_magazine/m12gdrum/pellet
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_HACKED,
		RND_SUBCATEGORY_WEAPONS_AMMO + RND_SUBCATEGORY_WEAPONS_AMMO_SHOTGUN
	)

/datum/design_techweb/shotgun_mag_12g_drum_flash
	SET_AMMO_DESIGN_NAMEDESC("drum magazine (12 gauge flash)")
	id = "shotgun_mag_12g_drum_flash"
	materials = list(MAT_STEEL = 18000)
	build_type = AUTOLATHE
	build_path = /obj/item/ammo_magazine/m12gdrum/flash
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_HACKED,
		RND_SUBCATEGORY_WEAPONS_AMMO + RND_SUBCATEGORY_WEAPONS_AMMO_SHOTGUN
	)

///////////////////////////////
/*Ammo clips and Speedloaders*/
///////////////////////////////

/////// Shotgun

/datum/design_techweb/loader_12g_beanbag
	SET_AMMO_DESIGN_NAMEDESC("2-round 12g speedloader (beanbag)")
	id = "loader_12g_beanbag"
	materials = list(MAT_STEEL = 900)
	build_type = AUTOLATHE
	build_path = /obj/item/ammo_magazine/clip/c12g/beanbag
	category = list(
		RND_CATEGORY_INITIAL,
		RND_SUBCATEGORY_WEAPONS_AMMO + RND_SUBCATEGORY_WEAPONS_AMMO_LOADERS
	)

/datum/design_techweb/loader_12g_slug
	SET_AMMO_DESIGN_NAMEDESC("2-round 12g speedloader (slug)")
	id = "loader_12g_slug"
	materials = list(MAT_STEEL = 1350)
	build_type = AUTOLATHE
	build_path = /obj/item/ammo_magazine/clip/c12g
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_HACKED,
		RND_SUBCATEGORY_WEAPONS_AMMO + RND_SUBCATEGORY_WEAPONS_AMMO_LOADERS
	)

/datum/design_techweb/loader_12g_buck
	SET_AMMO_DESIGN_NAMEDESC("2-round 12g speedloader (buckshot)")
	id = "loader_12g_buck"
	materials = list(MAT_STEEL = 1350)
	build_type = AUTOLATHE
	build_path = /obj/item/ammo_magazine/clip/c12g/pellet
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_HACKED,
		RND_SUBCATEGORY_WEAPONS_AMMO + RND_SUBCATEGORY_WEAPONS_AMMO_LOADERS
	)

/////// 38

/datum/design_techweb/loader_38
	SET_AMMO_DESIGN_NAMEDESC("speedloader (.38)")
	id = "loader_38"
	materials = list(MAT_STEEL = 450)
	build_type = AUTOLATHE
	build_path = /obj/item/ammo_magazine/s38
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_HACKED,
		RND_SUBCATEGORY_WEAPONS_AMMO + RND_SUBCATEGORY_WEAPONS_AMMO_LOADERS
	)

/datum/design_techweb/loader_38_rubber
	SET_AMMO_DESIGN_NAMEDESC("speedloader (.38 rubber)")
	id = "loader_38_rubber"
	materials = list(MAT_STEEL = 450)
	build_type = AUTOLATHE
	build_path = /obj/item/ammo_magazine/s38/rubber
	category = list(
		RND_CATEGORY_INITIAL,
		RND_SUBCATEGORY_WEAPONS_AMMO + RND_SUBCATEGORY_WEAPONS_AMMO_LOADERS
	)

/////// 45

/datum/design_techweb/loader_45
	SET_AMMO_DESIGN_NAMEDESC("speedloader (.45)")
	id = "loader_45"
	materials = list(MAT_STEEL = 660)
	build_type = AUTOLATHE
	build_path = /obj/item/ammo_magazine/s45
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_HACKED,
		RND_SUBCATEGORY_WEAPONS_AMMO + RND_SUBCATEGORY_WEAPONS_AMMO_LOADERS
	)

/datum/design_techweb/loader_45_rubber
	SET_AMMO_DESIGN_NAMEDESC("speedloader (.45 rubber)")
	id = "loader_45_rubber"
	materials = list(MAT_STEEL = 660)
	build_type = AUTOLATHE
	build_path = /obj/item/ammo_magazine/s45/rubber
	category = list(
		RND_CATEGORY_INITIAL,
		RND_SUBCATEGORY_WEAPONS_AMMO + RND_SUBCATEGORY_WEAPONS_AMMO_LOADERS
	)

/////// 5.48

/datum/design_techweb/loader_545
	SET_AMMO_DESIGN_NAMEDESC("ammo clip (5.45mm)")
	id = "loader_545"
	materials = list(MAT_STEEL = 560)
	build_type = AUTOLATHE
	build_path = /obj/item/ammo_magazine/clip/c545
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_HACKED,
		RND_SUBCATEGORY_WEAPONS_AMMO + RND_SUBCATEGORY_WEAPONS_AMMO_LOADERS
	)

/datum/design_techweb/loader_545_practice
	SET_AMMO_DESIGN_NAMEDESC("ammo clip (5.45mm practice)")
	id = "loader_545_practice"
	materials = list(MAT_STEEL = 560)
	build_type = AUTOLATHE
	build_path = /obj/item/ammo_magazine/clip/c545/practice
	category = list(
		RND_CATEGORY_INITIAL,
		RND_SUBCATEGORY_WEAPONS_AMMO + RND_SUBCATEGORY_WEAPONS_AMMO_LOADERS
	)

/////// 762

/datum/design_techweb/loader_762
	SET_AMMO_DESIGN_NAMEDESC("ammo clip (7.62mm)")
	id = "loader_762"
	materials = list(MAT_STEEL = 1250)
	build_type = AUTOLATHE
	build_path = /obj/item/ammo_magazine/clip/c762
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_HACKED,
		RND_SUBCATEGORY_WEAPONS_AMMO + RND_SUBCATEGORY_WEAPONS_AMMO_LOADERS
	)

/datum/design_techweb/loader_762_practice
	SET_AMMO_DESIGN_NAMEDESC("ammo clip (7.62mm practice)")
	id = "loader_762_practice"
	materials = list(MAT_STEEL = 1250)
	build_type = AUTOLATHE
	build_path = /obj/item/ammo_magazine/clip/c762/practice
	category = list(
		RND_CATEGORY_INITIAL,
		RND_SUBCATEGORY_WEAPONS_AMMO + RND_SUBCATEGORY_WEAPONS_AMMO_LOADERS
	)


/////// 357

/datum/design_techweb/loader_357
	SET_AMMO_DESIGN_NAMEDESC("speedloader (.357)")
	id = "loader_357"
	materials = list(MAT_STEEL = 1500)
	build_type = AUTOLATHE
	build_path = /obj/item/ammo_magazine/s357
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_HACKED,
		RND_SUBCATEGORY_WEAPONS_AMMO + RND_SUBCATEGORY_WEAPONS_AMMO_LOADERS
	)

/datum/design_techweb/loader_357_flash
	SET_AMMO_DESIGN_NAMEDESC("speedloader (.357 flash)")
	id = "loader_357_flash"
	materials = list(MAT_STEEL = 1575)
	build_type = AUTOLATHE
	build_path = /obj/item/ammo_magazine/s357/flash
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_HACKED,
		RND_SUBCATEGORY_WEAPONS_AMMO + RND_SUBCATEGORY_WEAPONS_AMMO_LOADERS
	)

/datum/design_techweb/loader_357_stun
	SET_AMMO_DESIGN_NAMEDESC("speedloader (.357 stun)")
	id = "loader_357_stun"
	materials = list(MAT_STEEL = 1575)
	build_type = AUTOLATHE
	build_path = /obj/item/ammo_magazine/s357/stun
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_HACKED,
		RND_SUBCATEGORY_WEAPONS_AMMO + RND_SUBCATEGORY_WEAPONS_AMMO_LOADERS
	)

/datum/design_techweb/loader_357_rubber
	SET_AMMO_DESIGN_NAMEDESC("speedloader (.357 rubber)")
	id = "loader_357_rubber"
	materials = list(MAT_STEEL = 1575)
	build_type = AUTOLATHE
	build_path = /obj/item/ammo_magazine/s357/rubber
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_HACKED,
		RND_SUBCATEGORY_WEAPONS_AMMO + RND_SUBCATEGORY_WEAPONS_AMMO_LOADERS
	)

/datum/design_techweb/loader_357_spectral
	SET_AMMO_DESIGN_NAMEDESC("speedloader (.357 spectral)")
	id = "loader_357_spectral"
	materials = list(MAT_STEEL = 1575)
	build_type = AUTOLATHE
	build_path = /obj/item/ammo_magazine/s357/spectral
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_HACKED,
		RND_SUBCATEGORY_WEAPONS_AMMO + RND_SUBCATEGORY_WEAPONS_AMMO_LOADERS
	)

/////// 44

/datum/design_techweb/loader_44
	SET_AMMO_DESIGN_NAMEDESC("speedloader (.44)")
	id = "loader_44"
	materials = list(MAT_STEEL = 1575)
	build_type = AUTOLATHE
	build_path = /obj/item/ammo_magazine/s44
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_HACKED,
		RND_SUBCATEGORY_WEAPONS_AMMO + RND_SUBCATEGORY_WEAPONS_AMMO_LOADERS
	)

/datum/design_techweb/loader_44_rubber
	SET_AMMO_DESIGN_NAMEDESC("speedloader (.44 rubber)")
	id = "loader_44_rubber"
	materials = list(MAT_STEEL = 1575)
	build_type = AUTOLATHE
	build_path = /obj/item/ammo_magazine/s44/rubber
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_HACKED,
		RND_SUBCATEGORY_WEAPONS_AMMO + RND_SUBCATEGORY_WEAPONS_AMMO_LOADERS
	)

/datum/design_techweb/loader_44_spectral
	SET_AMMO_DESIGN_NAMEDESC("speedloader (.44 spectral)")
	id = "loader_44_spectral"
	materials = list(MAT_STEEL = 1575)
	build_type = AUTOLATHE
	build_path = /obj/item/ammo_magazine/s44/spectral
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_HACKED,
		RND_SUBCATEGORY_WEAPONS_AMMO + RND_SUBCATEGORY_WEAPONS_AMMO_LOADERS
	)

///////////////////
/*Rifle Ammoboxes*/
///////////////////

/*
 * .357
 */

/datum/design_techweb/ammobox_357
	SET_AMMO_DESIGN_NAMEDESC("ammo box (.357)")
	id = "ammobox_357"
	materials = list(MAT_STEEL = 5040)
	build_type = AUTOLATHE
	build_path = /obj/item/ammo_magazine/ammo_box/b357
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_HACKED,
		RND_SUBCATEGORY_WEAPONS_AMMO + RND_SUBCATEGORY_WEAPONS_AMMO_BOXES
	)

/datum/design_techweb/ammobox_357_rubber
	SET_AMMO_DESIGN_NAMEDESC("ammo box (.357 rubber)")
	id = "ammobox_357_rubber"
	materials = list(MAT_STEEL = 5040)
	build_type = AUTOLATHE
	build_path = /obj/item/ammo_magazine/ammo_box/b357/rubber
	category = list(
		RND_CATEGORY_INITIAL,
		RND_SUBCATEGORY_WEAPONS_AMMO + RND_SUBCATEGORY_WEAPONS_AMMO_BOXES
	)

/*
 * .38
 */

/datum/design_techweb/ammobox_38
	SET_AMMO_DESIGN_NAMEDESC("ammo box (.38)")
	id = "ammobox_38"
	materials = list(MAT_STEEL = 1440)
	build_type = AUTOLATHE
	build_path = /obj/item/ammo_magazine/ammo_box/b38
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_HACKED,
		RND_SUBCATEGORY_WEAPONS_AMMO + RND_SUBCATEGORY_WEAPONS_AMMO_BOXES
	)

/datum/design_techweb/ammobox_38_rubber
	SET_AMMO_DESIGN_NAMEDESC("ammo box (.38 rubber)")
	id = "ammobox_38_rubber"
	materials = list(MAT_STEEL = 1440)
	build_type = AUTOLATHE
	build_path = /obj/item/ammo_magazine/ammo_box/b38/rubber
	category = list(
		RND_CATEGORY_INITIAL,
		RND_SUBCATEGORY_WEAPONS_AMMO + RND_SUBCATEGORY_WEAPONS_AMMO_BOXES
	)

/datum/design_techweb/ammobox_38_spectral
	SET_AMMO_DESIGN_NAMEDESC("ammo box (.38 spectral)")
	id = "ammobox_38_spectral"
	materials = list(MAT_STEEL = 1440)
	build_type = AUTOLATHE
	build_path = /obj/item/ammo_magazine/ammo_box/b38/spectral
	category = list(
		RND_CATEGORY_INITIAL,
		RND_SUBCATEGORY_WEAPONS_AMMO + RND_SUBCATEGORY_WEAPONS_AMMO_BOXES
	)

/*
 * 10mm
 */

/datum/design_techweb/ammobox_10mm
	SET_AMMO_DESIGN_NAMEDESC("ammo box (10mm)")
	id = "ammobox_10mm"
	materials = list(MAT_STEEL = 3000)
	build_type = AUTOLATHE
	build_path = /obj/item/ammo_magazine/ammo_box/b10mm
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_HACKED,
		RND_SUBCATEGORY_WEAPONS_AMMO + RND_SUBCATEGORY_WEAPONS_AMMO_BOXES
	)

/datum/design_techweb/ammobox_10mm_practice
	SET_AMMO_DESIGN_NAMEDESC("ammo box (10mm practice)")
	id = "ammobox_10mm_practice"
	materials = list(MAT_STEEL = 2400)
	build_type = AUTOLATHE
	build_path = /obj/item/ammo_magazine/ammo_box/b10mm/practice
	category = list(
		RND_CATEGORY_INITIAL,
		RND_SUBCATEGORY_WEAPONS_AMMO + RND_SUBCATEGORY_WEAPONS_AMMO_BOXES
	)

/datum/design_techweb/ammobox_10mm_rubber
	SET_AMMO_DESIGN_NAMEDESC("ammo box (10mm rubber)")
	id = "ammobox_10mm_rubber"
	materials = list(MAT_STEEL = 2400)
	build_type = AUTOLATHE
	build_path = /obj/item/ammo_magazine/ammo_box/b10mm/rubber
	category = list(
		RND_CATEGORY_INITIAL,
		RND_SUBCATEGORY_WEAPONS_AMMO + RND_SUBCATEGORY_WEAPONS_AMMO_BOXES
	)

/datum/design_techweb/ammobox_10mm_haywire
	SET_AMMO_DESIGN_NAMEDESC("ammo box (10mm haywire)")
	id = "ammobox_10mm_haywire"
	materials = list(MAT_STEEL = 5200, MAT_URANIUM = 4000)
	build_type = AUTOLATHE
	build_path = /obj/item/ammo_magazine/ammo_box/b10mm/emp
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_HACKED,
		RND_SUBCATEGORY_WEAPONS_AMMO + RND_SUBCATEGORY_WEAPONS_AMMO_BOXES
	)

/*
 * .44
 */

/datum/design_techweb/ammobox_44
	SET_AMMO_DESIGN_NAMEDESC("ammo box (.44)")
	id = "ammobox_44"
	materials = list(MAT_STEEL = 5040)
	build_type = AUTOLATHE
	build_path = /obj/item/ammo_magazine/ammo_box/b44
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_HACKED,
		RND_SUBCATEGORY_WEAPONS_AMMO + RND_SUBCATEGORY_WEAPONS_AMMO_BOXES
	)

/datum/design_techweb/ammobox_44_rubber
	SET_AMMO_DESIGN_NAMEDESC("ammo box (.44 rubber)")
	id = "ammobox_44_rubber"
	materials = list(MAT_STEEL = 1440)
	build_type = AUTOLATHE
	build_path = /obj/item/ammo_magazine/ammo_box/b44/rubber
	category = list(
		RND_CATEGORY_INITIAL,
		RND_SUBCATEGORY_WEAPONS_AMMO + RND_SUBCATEGORY_WEAPONS_AMMO_BOXES
	)

/datum/design_techweb/ammobox_44_spectral
	SET_AMMO_DESIGN_NAMEDESC("ammo box (.44 spectral)")
	id = "ammobox_44_spectral"
	materials = list(MAT_STEEL = 1440)
	build_type = AUTOLATHE
	build_path = /obj/item/ammo_magazine/ammo_box/b44/spectral
	category = list(
		RND_CATEGORY_INITIAL,
		RND_SUBCATEGORY_WEAPONS_AMMO + RND_SUBCATEGORY_WEAPONS_AMMO_BOXES
	)

/*
 * .45
 */

/datum/design_techweb/ammobox_45
	SET_AMMO_DESIGN_NAMEDESC("ammo box (.45)")
	id = "ammobox_45"
	materials = list(MAT_STEEL = 1800)
	build_type = AUTOLATHE
	build_path = /obj/item/ammo_magazine/ammo_box/b45
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_HACKED,
		RND_SUBCATEGORY_WEAPONS_AMMO + RND_SUBCATEGORY_WEAPONS_AMMO_BOXES
	)

/datum/design_techweb/ammobox_45_practice
	SET_AMMO_DESIGN_NAMEDESC("ammo box (.45 practice)")
	id = "ammobox_45_practice"
	materials = list(MAT_STEEL = 1440)
	build_type = AUTOLATHE
	build_path = /obj/item/ammo_magazine/ammo_box/b45/practice
	category = list(
		RND_CATEGORY_INITIAL,
		RND_SUBCATEGORY_WEAPONS_AMMO + RND_SUBCATEGORY_WEAPONS_AMMO_BOXES
	)

/datum/design_techweb/ammobox_45_ap
	SET_AMMO_DESIGN_NAMEDESC("ammo box (.45 armor piercing)")
	id = "ammobox_45_ap"
	materials = list(MAT_STEEL = 1200, MAT_PLASTEEL = 600)
	build_type = AUTOLATHE
	build_path = /obj/item/ammo_magazine/ammo_box/b45/ap
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_HACKED,
		RND_SUBCATEGORY_WEAPONS_AMMO + RND_SUBCATEGORY_WEAPONS_AMMO_BOXES
	)

/datum/design_techweb/ammobox_45_hp
	SET_AMMO_DESIGN_NAMEDESC("ammo box (.45 hollow point)")
	id = "ammobox_45_hp"
	materials = list(MAT_STEEL = 1440, MAT_PLASTIC = 360)
	build_type = AUTOLATHE
	build_path = /obj/item/ammo_magazine/ammo_box/b45/hp
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_HACKED,
		RND_SUBCATEGORY_WEAPONS_AMMO + RND_SUBCATEGORY_WEAPONS_AMMO_BOXES
	)

/datum/design_techweb/ammobox_45_rubber
	SET_AMMO_DESIGN_NAMEDESC("ammo box (.45 rubber)")
	id = "ammobox_45_rubber"
	materials = list(MAT_STEEL = 1440)
	build_type = AUTOLATHE
	build_path = /obj/item/ammo_magazine/ammo_box/b45/rubber
	category = list(
		RND_CATEGORY_INITIAL,
		RND_SUBCATEGORY_WEAPONS_AMMO + RND_SUBCATEGORY_WEAPONS_AMMO_BOXES
	)

/datum/design_techweb/ammobox_45_haywire
	SET_AMMO_DESIGN_NAMEDESC("ammo box (.45 haywire)")
	id = "ammobox_45_haywire"
	materials = list(MAT_STEEL = 3120, MAT_URANIUM = 2400)
	build_type = AUTOLATHE
	build_path = /obj/item/ammo_magazine/ammo_box/b45/emp
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_HACKED,
		RND_SUBCATEGORY_WEAPONS_AMMO + RND_SUBCATEGORY_WEAPONS_AMMO_BOXES
	)

/*
 * 14.5mm (anti-materiel rifle round)
 */

/datum/design_techweb/ammobox_145
	SET_AMMO_DESIGN_NAMEDESC("ammo box (14.5mm)")
	id = "ammobox_145"
	materials = list(MAT_STEEL = 8750)
	build_type = AUTOLATHE
	build_path = /obj/item/ammo_magazine/ammo_box/b145
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_HACKED,
		RND_SUBCATEGORY_WEAPONS_AMMO + RND_SUBCATEGORY_WEAPONS_AMMO_BOXES
	)

/datum/design_techweb/ammobox_145_highvel
	SET_AMMO_DESIGN_NAMEDESC("ammo box (14.5mm sabot)")
	id = "ammobox_145_highvel"
	materials = list(MAT_STEEL = 8750)
	build_type = AUTOLATHE
	build_path = /obj/item/ammo_magazine/ammo_box/b145/highvel
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_HACKED,
		RND_SUBCATEGORY_WEAPONS_AMMO + RND_SUBCATEGORY_WEAPONS_AMMO_BOXES
	)

/*
 * 7.62mm
 */

/datum/design_techweb/ammobox_762
	SET_AMMO_DESIGN_NAMEDESC("ammo box (7.62mm)")
	id = "ammobox_762"
	materials = list(MAT_STEEL = 6000)
	build_type = AUTOLATHE
	build_path = /obj/item/ammo_magazine/ammo_box/b762
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_HACKED,
		RND_SUBCATEGORY_WEAPONS_AMMO + RND_SUBCATEGORY_WEAPONS_AMMO_BOXES
	)

/datum/design_techweb/ammobox_762_hp
	SET_AMMO_DESIGN_NAMEDESC("ammo box (7.62mm hollow point)")
	id = "ammobox_762_hp"
	materials = list(MAT_STEEL = 9000)
	build_type = AUTOLATHE
	build_path = /obj/item/ammo_magazine/ammo_box/b762/hp
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_HACKED,
		RND_SUBCATEGORY_WEAPONS_AMMO + RND_SUBCATEGORY_WEAPONS_AMMO_BOXES
	)

/datum/design_techweb/ammobox_762_ap
	SET_AMMO_DESIGN_NAMEDESC("ammo box (7.62mm armor piercing)")
	id = "ammobox_762_ap"
	materials = list(MAT_STEEL = 9000)
	build_type = AUTOLATHE
	build_path = /obj/item/ammo_magazine/ammo_box/b762/ap
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_HACKED,
		RND_SUBCATEGORY_WEAPONS_AMMO + RND_SUBCATEGORY_WEAPONS_AMMO_BOXES
	)

/datum/design_techweb/ammobox_762_practice
	SET_AMMO_DESIGN_NAMEDESC("ammo box (7.62mm practice)")
	id = "ammobox_762_practice"
	materials = list(MAT_STEEL = 2700)
	build_type = AUTOLATHE
	build_path = /obj/item/ammo_magazine/ammo_box/b762/practice
	category = list(
		RND_CATEGORY_INITIAL,
		RND_SUBCATEGORY_WEAPONS_AMMO + RND_SUBCATEGORY_WEAPONS_AMMO_BOXES
	)

/datum/design_techweb/ammobox_762_hunter
	SET_AMMO_DESIGN_NAMEDESC("ammo box (7.62mm hunter)")
	id = "ammobox_762_hunter"
	materials = list(MAT_STEEL = 6000)
	build_type = AUTOLATHE
	build_path = /obj/item/ammo_magazine/ammo_box/b762/hunter
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_HACKED,
		RND_SUBCATEGORY_WEAPONS_AMMO + RND_SUBCATEGORY_WEAPONS_AMMO_BOXES
	)

/*
 * 5.45mm
 */

/datum/design_techweb/ammobox_545
	SET_AMMO_DESIGN_NAMEDESC("ammo box (5.45mm)")
	id = "ammobox_545"
	materials = list(MAT_STEEL = 5400)
	build_type = AUTOLATHE
	build_path = /obj/item/ammo_magazine/ammo_box/b545
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_HACKED,
		RND_SUBCATEGORY_WEAPONS_AMMO + RND_SUBCATEGORY_WEAPONS_AMMO_BOXES
	)

/datum/design_techweb/ammobox_545_ap
	SET_AMMO_DESIGN_NAMEDESC("ammo box (5.45mm armor piercing)")
	id = "ammobox_545_ap"
	materials = list(MAT_STEEL = 8100)
	build_type = AUTOLATHE
	build_path = /obj/item/ammo_magazine/ammo_box/b545/ap
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_HACKED,
		RND_SUBCATEGORY_WEAPONS_AMMO + RND_SUBCATEGORY_WEAPONS_AMMO_BOXES
	)

/datum/design_techweb/ammobox_545_hp
	SET_AMMO_DESIGN_NAMEDESC("ammo box (5.45mm hollow point)")
	id = "ammobox_545_hp"
	materials = list(MAT_STEEL = 5400)
	build_type = AUTOLATHE
	build_path = /obj/item/ammo_magazine/ammo_box/b545/hp
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_HACKED,
		RND_SUBCATEGORY_WEAPONS_AMMO + RND_SUBCATEGORY_WEAPONS_AMMO_BOXES
	)

/datum/design_techweb/ammobox_545_practice
	SET_AMMO_DESIGN_NAMEDESC("ammo box (5.45mm practice)")
	id = "ammobox_545_practice"
	materials = list(MAT_STEEL = 2700)
	build_type = AUTOLATHE
	build_path = /obj/item/ammo_magazine/ammo_box/b545/practice
	category = list(
		RND_CATEGORY_INITIAL,
		RND_SUBCATEGORY_WEAPONS_AMMO + RND_SUBCATEGORY_WEAPONS_AMMO_BOXES
	)

/datum/design_techweb/ammobox_545_hunter
	SET_AMMO_DESIGN_NAMEDESC("ammo box (5.45mm hunter)")
	id = "ammobox_545_hunter"
	materials = list(MAT_STEEL = 5400)
	build_type = AUTOLATHE
	build_path = /obj/item/ammo_magazine/ammo_box/b545/hunter
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_HACKED,
		RND_SUBCATEGORY_WEAPONS_AMMO + RND_SUBCATEGORY_WEAPONS_AMMO_BOXES
	)

/datum/design_techweb/ammobox_545_blank
	SET_AMMO_DESIGN_NAMEDESC("ammo box (5.45mm blanks)")
	id = "ammobox_545_blank"
	materials = list(MAT_STEEL = 2700)
	build_type = AUTOLATHE
	build_path = /obj/item/ammo_magazine/ammo_box/b545/blank
	category = list(
		RND_CATEGORY_INITIAL,
		RND_SUBCATEGORY_WEAPONS_AMMO + RND_SUBCATEGORY_WEAPONS_AMMO_BOXES
	)

// huge boxes

/datum/design_techweb/ammocrate_545
	SET_AMMO_DESIGN_NAMEDESC("large ammo crate (5.45mm)")
	id = "ammocrate_545"
	materials = list(MAT_STEEL = 18000)
	build_type = AUTOLATHE
	build_path = /obj/item/ammo_magazine/ammo_box/b545/large
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_HACKED,
		RND_SUBCATEGORY_WEAPONS_AMMO + RND_SUBCATEGORY_WEAPONS_AMMO_BOXES
	)

/datum/design_techweb/ammocrate_545_ap
	SET_AMMO_DESIGN_NAMEDESC("large ammo crate (5.45mm armor piercing)")
	id = "ammocrate_545_ap"
	materials = list(MAT_STEEL = 27000)
	build_type = AUTOLATHE
	build_path = /obj/item/ammo_magazine/ammo_box/b545/large/ap
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_HACKED,
		RND_SUBCATEGORY_WEAPONS_AMMO + RND_SUBCATEGORY_WEAPONS_AMMO_BOXES
	)

/datum/design_techweb/ammocrate_545_hp
	SET_AMMO_DESIGN_NAMEDESC("large ammo crate (5.45mm hollow point)")
	id = "ammocrate_545_hp"
	materials = list(MAT_STEEL = 18000)
	build_type = AUTOLATHE
	build_path = /obj/item/ammo_magazine/ammo_box/b545/large/hp
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_HACKED,
		RND_SUBCATEGORY_WEAPONS_AMMO + RND_SUBCATEGORY_WEAPONS_AMMO_BOXES
	)

/datum/design_techweb/ammocrate_545_practice
	SET_AMMO_DESIGN_NAMEDESC("large ammo crate (5.45mm practice)")
	id = "ammocrate_545_practice"
	materials = list(MAT_STEEL = 9000)
	build_type = AUTOLATHE
	build_path = /obj/item/ammo_magazine/ammo_box/b545/large/practice
	category = list(
		RND_CATEGORY_INITIAL,
		RND_SUBCATEGORY_WEAPONS_AMMO + RND_SUBCATEGORY_WEAPONS_AMMO_BOXES
	)

/datum/design_techweb/ammocrate_545_hunter
	SET_AMMO_DESIGN_NAMEDESC("large ammo crate (5.45mm hunter)")
	id = "ammocrate_545_hunter"
	materials = list(MAT_STEEL = 18000)
	build_type = AUTOLATHE
	build_path = /obj/item/ammo_magazine/ammo_box/b545/large/hunter
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_HACKED,
		RND_SUBCATEGORY_WEAPONS_AMMO + RND_SUBCATEGORY_WEAPONS_AMMO_BOXES
	)
