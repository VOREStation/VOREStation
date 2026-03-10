//////////////////
/*Shotgun rounds*/
//////////////////

/datum/design_techweb/ammobox_12g_slug
	name = "ammo box (12 gauge slug)"
	desc = "A box of 12 gauge slug rounds"
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
	name = "ammo box (12 gauge blank)"
	desc = "A box of 12 gauge blank rounds"
	id = "ammobox_12g_blank"
	materials = list(MAT_STEEL = 3600)
	build_type = AUTOLATHE
	build_path = /obj/item/ammo_magazine/ammo_box/b12g/blank
	category = list(
		RND_CATEGORY_INITIAL,
		RND_SUBCATEGORY_WEAPONS_AMMO + RND_SUBCATEGORY_WEAPONS_AMMO_SHOTGUN
	)

/datum/design_techweb/ammobox_12g_beanbag
	name = "ammo box (12 gauge beanbag)"
	desc = "A box of 12 gauge beanbag rounds"
	id = "ammobox_12g_beanbag"
	materials = list(MAT_STEEL = 3600)
	build_type = AUTOLATHE
	build_path = /obj/item/ammo_magazine/ammo_box/b12g/beanbag
	category = list(
		RND_CATEGORY_INITIAL,
		RND_SUBCATEGORY_WEAPONS_AMMO + RND_SUBCATEGORY_WEAPONS_AMMO_SHOTGUN
	)

/datum/design_techweb/ammobox_12g_flash
	name = "ammo box (12 gauge flash)"
	desc = "A box of 12 gauge flash rounds"
	id = "ammobox_12g_flash"
	materials = list(MAT_STEEL = 920, MAT_GLASS = 920)
	build_type = AUTOLATHE
	build_path = /obj/item/ammo_magazine/ammo_box/b12g/flash
	category = list(
		RND_CATEGORY_INITIAL,
		RND_SUBCATEGORY_WEAPONS_AMMO + RND_SUBCATEGORY_WEAPONS_AMMO_SHOTGUN
	)

/datum/design_techweb/ammobox_12g_pellet
	name = "ammo box (12 gauge buckshot)"
	desc = "A box of 12 gauge buckshot rounds"
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
	name = "ammo box (12 gauge stun)"
	desc = "A box of 12 gauge stun rounds"
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
	name = "ammo box (12 gauge EMP)"
	desc = "A box of 12 gauge EMP rounds"
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
	name = "ammo box (12 gauge flechette)"
	desc = "A box of 12 gauge flechette rounds"
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
	name = "ammo box (12 gauge practice)"
	desc = "A box of 12 gauge practice rounds"
	id = "ammobox_12g_practice"
	materials = list(MAT_STEEL = 3600)
	build_type = AUTOLATHE
	build_path = /obj/item/ammo_magazine/ammo_box/b12g/practice
	category = list(
		RND_CATEGORY_INITIAL,
		RND_SUBCATEGORY_WEAPONS_AMMO + RND_SUBCATEGORY_WEAPONS_AMMO_SHOTGUN
	)

// Single shells

/* These are probably not needed, just print the ammo boxes for shotguns, because most shotguns don't have a seperate magazine item.
/datum/design_techweb/ammo_12g_slug
	name = "ammunition (12g, slug)"
	id = "ammo_12g_slug"
	materials = list(MAT_STEEL = 450)
	build_type = AUTOLATHE
	build_path = /obj/item/ammo_casing/a12g
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_HACKED,
		RND_SUBCATEGORY_WEAPONS_AMMO + RND_SUBCATEGORY_WEAPONS_AMMO_SHOTGUN
	)

/datum/design_techweb/ammo_12g_blank
	name = "ammunition (12g, blank)"
	id = "ammo_12g_blank"
	materials = list(MAT_STEEL = 110)
	build_type = AUTOLATHE
	build_path = /obj/item/ammo_casing/a12g/blank
	category = list(
		RND_CATEGORY_INITIAL,
		RND_SUBCATEGORY_WEAPONS_AMMO + RND_SUBCATEGORY_WEAPONS_AMMO_SHOTGUN
	)

/datum/design_techweb/ammo_12g_beanbag
	name = "ammunition (12g, beanbag)"
	id = "ammo_12g_beanbag"
	materials = list(MAT_STEEL = 225)
	build_type = AUTOLATHE
	build_path = /obj/item/ammo_casing/a12g/beanbag
	category = list(
		RND_CATEGORY_INITIAL,
		RND_SUBCATEGORY_WEAPONS_AMMO + RND_SUBCATEGORY_WEAPONS_AMMO_SHOTGUN
	)

/datum/design_techweb/ammo_12g_flash
	name = "ammunition (12g, flash)"
	id = "ammo_12g_flash"
	materials = list(MAT_STEEL = 115, MAT_GLASS = 115)
	build_type = AUTOLATHE
	build_path = /obj/item/ammo_casing/a12g/flash
	category = list(
		RND_CATEGORY_INITIAL,
		RND_SUBCATEGORY_WEAPONS_AMMO + RND_SUBCATEGORY_WEAPONS_AMMO_SHOTGUN
	)

/datum/design_techweb/ammo_12g_pellet
	name = "ammunition (12g, pellet)"
	id = "ammo_12g_pellet"
	materials = list(MAT_STEEL = 450)
	build_type = AUTOLATHE
	build_path = /obj/item/ammo_casing/a12g/pellet
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_HACKED,
		RND_SUBCATEGORY_WEAPONS_AMMO + RND_SUBCATEGORY_WEAPONS_AMMO_SHOTGUN
	)

/datum/design_techweb/ammo_12g_stun
	name = "ammunition (stun cartridge, shotgun)"
	id = "ammo_12g_stun"
	materials = list(MAT_STEEL = 450, MAT_GLASS = 900)
	build_type = AUTOLATHE
	build_path = /obj/item/ammo_casing/a12g/stunshell
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_HACKED,
		RND_SUBCATEGORY_WEAPONS_AMMO + RND_SUBCATEGORY_WEAPONS_AMMO_SHOTGUN
	)

/datum/design_techweb/ammo_12g_emp
	name = "ammunition (haywire cartridge, shotgun)"
	id = "ammo_12g_emp"
	materials = list(MAT_STEEL = 450, MAT_URANIUM = 900)
	build_type = AUTOLATHE
	build_path = /obj/item/ammo_casing/a12g/emp
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_HACKED,
		RND_SUBCATEGORY_WEAPONS_AMMO + RND_SUBCATEGORY_WEAPONS_AMMO_SHOTGUN
	)

/datum/design_techweb/ammo_12g_flechette
	name = "ammunition (flechette cartridge, shotgun)"
	id = "ammo_12g_flechette"
	materials = list(MAT_STEEL = 450, MAT_GLASS = 125)
	build_type = AUTOLATHE
	build_path = /obj/item/ammo_casing/a12g/flechette
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_HACKED,
		RND_SUBCATEGORY_WEAPONS_AMMO + RND_SUBCATEGORY_WEAPONS_AMMO_SHOTGUN
	)

/datum/design_techweb/ammo_12g_practice
	name = "ammunition (practice cartridge, shotgun)"
	id = "ammo_12g_practice"
	materials = list(MAT_STEEL = 450)
	build_type = AUTOLATHE
	build_path = /obj/item/ammo_casing/a12g/practice
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_HACKED,
		RND_SUBCATEGORY_WEAPONS_AMMO + RND_SUBCATEGORY_WEAPONS_AMMO_SHOTGUN
	)
*/

//////////////////
/* High velocity*/
//////////////////

/datum/design_techweb/rifle_145_sabot
	name = "14.5mm round (sabot)"
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
	name = "pistol magazine (.44)"
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
	name = "pistol magazine (.44 rubber)"
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
	name = "pistol magazine (.45)"
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
	name = "pistol magazine (.45 practice)"
	id = "pistol_mag_45_practice"
	materials = list(MAT_STEEL = 650)
	build_type = AUTOLATHE
	build_path = /obj/item/ammo_magazine/m45/practice
	category = list(
		RND_CATEGORY_INITIAL,
		RND_SUBCATEGORY_WEAPONS_AMMO + RND_SUBCATEGORY_WEAPONS_AMMO_PISTOL
	)

/datum/design_techweb/pistol_mag_45_rubber
	name = "pistol magazine (.45 rubber)"
	id = "pistol_mag_45_rubber"
	materials = list(MAT_STEEL = 650)
	build_type = AUTOLATHE
	build_path = /obj/item/ammo_magazine/m45/rubber
	category = list(
		RND_CATEGORY_INITIAL,
		RND_SUBCATEGORY_WEAPONS_AMMO + RND_SUBCATEGORY_WEAPONS_AMMO_PISTOL
	)

/datum/design_techweb/pistol_mag_45_flash
	name = "pistol magazine (.45 flash)"
	id = "pistol_mag_45_flash"
	materials = list(MAT_STEEL = 650)
	build_type = AUTOLATHE
	build_path = /obj/item/ammo_magazine/m45/flash
	category = list(
		RND_CATEGORY_INITIAL,
		RND_SUBCATEGORY_WEAPONS_AMMO + RND_SUBCATEGORY_WEAPONS_AMMO_PISTOL
	)

/datum/design_techweb/pistol_mag_45_piercing
	name = "pistol magazine (.45 armor piercing)"
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
	name = "pistol magazine (.45 hollowpoint)"
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
	name = "uzi magazine (.45)"
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
	name = "Tommy Gun magazine (.45)"
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
	name = "Tommy Gun magazine (.45 armor piercing)"
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
	name = "Tommy Gun drum magazine (.45)"
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
	name = "Tommy Gun drum magazine (.45 piercing)"
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
	name = "pistol magazine (9mm)"
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
	name = "pistol magazine (9mm rubber)"
	id = "pistol_mag_9mm_rubber"
	materials = list(MAT_STEEL = 750)
	build_type = AUTOLATHE
	build_path = /obj/item/ammo_magazine/m9mm/rubber
	category = list(
		RND_CATEGORY_INITIAL,
		RND_SUBCATEGORY_WEAPONS_AMMO + RND_SUBCATEGORY_WEAPONS_AMMO_PISTOL
	)

/datum/design_techweb/pistol_mag_9mm_practice
	name = "pistol magazine (9mm practice)"
	id = "pistol_mag_9mm_practice"
	materials = list(MAT_STEEL = 750)
	build_type = AUTOLATHE
	build_path = /obj/item/ammo_magazine/m9mm/practice
	category = list(
		RND_CATEGORY_INITIAL,
		RND_SUBCATEGORY_WEAPONS_AMMO + RND_SUBCATEGORY_WEAPONS_AMMO_PISTOL
	)

/datum/design_techweb/pistol_mag_9mm_flash
	name = "pistol magazine (9mm flash)"
	id = "pistol_mag_9mm_flash"
	materials = list(MAT_STEEL = 750)
	build_type = AUTOLATHE
	build_path = /obj/item/ammo_magazine/m9mm/flash
	category = list(
		RND_CATEGORY_INITIAL,
		RND_SUBCATEGORY_WEAPONS_AMMO + RND_SUBCATEGORY_WEAPONS_AMMO_PISTOL
	)

// Small mags for small or old guns. These are all hidden because they are traitor mags and will otherwise just clutter the Autolathe.

/datum/design_techweb/pistol_mag_compact_9mm
	name = "compact pistol magazine (9mm)"
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
	name = "compact pistol magazine (9mm rubber)"
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
	name = "compact pistol magazine (9mm practice)"
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
	name = "compact pistol magazine (9mm flash)"
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
	name = "SMG magazine (9mm)"
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
	name = "top-mounted SMG magazine (9mm)"
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
	name = "top-mounted SMG magazine (9mm rubber)"
	id = "pistol_mag_topmount_9mm_rubber"
	materials = list(MAT_STEEL = 1500)
	build_type = AUTOLATHE
	build_path = /obj/item/ammo_magazine/m9mmt/rubber
	category = list(
		RND_CATEGORY_INITIAL,
		RND_SUBCATEGORY_WEAPONS_AMMO + RND_SUBCATEGORY_WEAPONS_AMMO_RIFLE
	)

/datum/design_techweb/pistol_mag_topmount_9mm_practice
	name = "top-mounted SMG magazine (9mm practice)"
	id = "pistol_mag_topmount_9mm_practice"
	materials = list(MAT_STEEL = 1500)
	build_type = AUTOLATHE
	build_path = /obj/item/ammo_magazine/m9mmt/practice
	category = list(
		RND_CATEGORY_INITIAL,
		RND_SUBCATEGORY_WEAPONS_AMMO + RND_SUBCATEGORY_WEAPONS_AMMO_RIFLE
	)

/datum/design_techweb/pistol_mag_topmount_9mm_flash
	name = "top-mounted SMG magazine (9mm flash)"
	id = "pistol_mag_topmount_9mm_flash"
	materials = list(MAT_STEEL = 1500)
	build_type = AUTOLATHE
	build_path = /obj/item/ammo_magazine/m9mmt/flash
	category = list(
		RND_CATEGORY_INITIAL,
		RND_SUBCATEGORY_WEAPONS_AMMO + RND_SUBCATEGORY_WEAPONS_AMMO_RIFLE
	)

/datum/design_techweb/pistol_mag_topmount_9mm_piercing
	name = "top-mounted SMG magazine (9mm armor piercing)"
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
	name = "top-mounted extended SMG magazine (9mm AP)"
	id = "pistol_mag_ext_topmount_9mm_piercing"
	materials = list(MAT_STEEL = 3000, MAT_PLASTEEL = 1500)
	build_type = AUTOLATHE
	build_path = /obj/item/ammo_magazine/m9mmp90
	category = list(
		RND_CATEGORY_INITIAL,
		RND_SUBCATEGORY_WEAPONS_AMMO + RND_SUBCATEGORY_WEAPONS_AMMO_RIFLE
	)

/datum/design_techweb/ammo_9mmAdvanced
	name = "9mm magazine"
	id = "ammo_9mm"
	desc = "A 21 round magazine for an advanced 9mm SMG."
	// req_tech = list(TECH_COMBAT = 4, TECH_MATERIAL = 3)
	build_type = AUTOLATHE
	materials = list(MAT_STEEL = 3750, MAT_SILVER = 100) // Requires silver for proprietary magazines! Or something.
	build_path = /obj/item/ammo_magazine/m9mmAdvanced
	category = list(
		RND_CATEGORY_WEAPONS + RND_SUBCATEGORY_WEAPONS_AMMO
	)
	departmental_flags = DEPARTMENT_BITFLAG_SECURITY | DEPARTMENT_BITFLAG_SCIENCE

/////// 10mm

/datum/design_techweb/smg_mag_10m
	name = "SMG magazine (10mm)"
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
	name = "SMG magazine (10mm practice)"
	id = "smg_mag_10m_practice"
	materials = list(MAT_STEEL = 1800)
	build_type = AUTOLATHE
	build_path = /obj/item/ammo_magazine/m10mm/practice
	category = list(
		RND_CATEGORY_INITIAL,
		RND_SUBCATEGORY_WEAPONS_AMMO + RND_SUBCATEGORY_WEAPONS_AMMO_RIFLE
	)

/datum/design_techweb/smg_mag_10m_rubber
	name = "SMG magazine (10mm rubber)"
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
	name = "SMG magazine (10mm haywire)"
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
	name = "pistol magazine (10mm)"
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
	name = "pistol magazine (10mm rubber)"
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
	name = "pistol magazine (10mm haywire)"
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
	name = "pistol magazine (10mm practice)"
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
	name = "rifle magazine (5.45mm)"
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
	name = "rifle magazine (5.45mm practice)"
	id = "rifle_mag_545_practice"
	materials = list(MAT_STEEL = 2250)
	build_type = AUTOLATHE
	build_path = /obj/item/ammo_magazine/m545/practice
	category = list(
		RND_CATEGORY_INITIAL,
		RND_SUBCATEGORY_WEAPONS_AMMO + RND_SUBCATEGORY_WEAPONS_AMMO_RIFLE
	)

/datum/design_techweb/rifle_mag_545_pierce
	name = "Rifle Magazine (5.45mm AP)"
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
	name = "machinegun box magazine (5.45)"
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
	name = "machinegun box magazine (5.45mm armor-piercing)"
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
	name = "machinegun box magazine (5.45mm hunting)"
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
	name = "Machinegun box magazine (5.45mm AP)"
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
	name = "Rifle Magazine (5.45mm Hunting)"
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
	name = "rifle magazine (7.62mm)"
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
	name = "rifle magazine (7.62mm AP)"
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
	name = "rifle magazine (7.62mm) extended"
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
	name = "rifle magazine (7.62mm AP) extended"
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
	name = "enbloc (7.62mm)"
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
	name = "enbloc (7.62mm AP)"
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
	name = "drum magazine (12 gauge)"
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
	name = "drum magazine (12 gauge beanbag)"
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
	name = "drum magazine (12 gauge pellet)"
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
	name = "drum magazine (12 gauge flash)"
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
	name = "2-round 12g speedloader (beanbag)"
	id = "loader_12g_beanbag"
	materials = list(MAT_STEEL = 900)
	build_type = AUTOLATHE
	build_path = /obj/item/ammo_magazine/clip/c12g/beanbag
	category = list(
		RND_CATEGORY_INITIAL,
		RND_SUBCATEGORY_WEAPONS_AMMO + RND_SUBCATEGORY_WEAPONS_AMMO_LOADERS
	)

/datum/design_techweb/loader_12g_slug
	name = "2-round 12g speedloader (slug)"
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
	name = "2-round 12g speedloader (buckshot)"
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
	name = "speedloader (.38)"
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
	name = "speedloader (.38 rubber)"
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
	name = "speedloader (.45)"
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
	name = "speedloader (.45 rubber)"
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
	name = "ammo clip (5.45mm)"
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
	name = "ammo clip (5.45mm practice)"
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
	name = "ammo clip (7.62mm)"
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
	name = "ammo clip (7.62mm practice)"
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
	name = "speedloader (.357)"
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
	name = "speedloader (.357 flash)"
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
	name = "speedloader (.357 stun)"
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
	name = "speedloader (.357 rubber)"
	id = "loader_357_rubber"
	materials = list(MAT_STEEL = 1575)
	build_type = AUTOLATHE
	build_path = /obj/item/ammo_magazine/s357/rubber
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_HACKED,
		RND_SUBCATEGORY_WEAPONS_AMMO + RND_SUBCATEGORY_WEAPONS_AMMO_LOADERS
	)

/////// 44

/datum/design_techweb/loader_44
	name = "speedloader (.44)"
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
	name = "speedloader (.44 rubber)"
	id = "loader_44_rubber"
	materials = list(MAT_STEEL = 1575)
	build_type = AUTOLATHE
	build_path = /obj/item/ammo_magazine/s44/rubber
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_HACKED,
		RND_SUBCATEGORY_WEAPONS_AMMO + RND_SUBCATEGORY_WEAPONS_AMMO_LOADERS
	)
