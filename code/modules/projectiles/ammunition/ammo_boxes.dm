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
	ammo_type = /obj/item/ammo_casing/afoam_dart/riot
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

/*
 * .357
 */

/obj/item/ammo_magazine/ammo_box/b357
	name = "ammo box (.357)"
	desc = "A box of .357 rounds"
	icon_state = "magnum"
	caliber = ".357"
	ammo_type = /obj/item/ammo_casing/a357
	matter = list(MAT_STEEL = 5040)
	max_ammo = 24
	multiple_sprites = 1

/obj/item/ammo_magazine/ammo_box/b357/rubber
	name = "ammo box (.357 rubber)"
	desc = "A box of .357 rubber rounds"
	icon_state = "magnum_r"
	caliber = ".357"
	ammo_type = /obj/item/ammo_casing/a357/rubber
	matter = list(MAT_STEEL = 5040)
	max_ammo = 24
	multiple_sprites = 1

/*
 * .38
 */

/obj/item/ammo_magazine/ammo_box/b38
	name = "ammo box (.38)"
	desc = "A box of .38 rounds"
	icon_state = "pistol"
	caliber = ".38"
	ammo_type = /obj/item/ammo_casing/a38
	matter = list(MAT_STEEL = 1440)
	max_ammo = 24
	multiple_sprites = 1

/obj/item/ammo_magazine/ammo_box/b38/rubber
	name = "ammo box (.38 rubber)"
	desc = "A box of .38 rubber rounds"
	icon_state = "pistol_p"
	caliber = ".38"
	ammo_type = /obj/item/ammo_casing/a38/rubber
	matter = list(MAT_STEEL = 1440)
	max_ammo = 24
	multiple_sprites = 1

/*
 * 10mm
 */

/obj/item/ammo_magazine/ammo_box/b10mm
	name = "ammo box (10mm)"
	desc = "A box of 10mm rounds"
	icon_state = "box10mm"
	caliber = "10mm"
	ammo_type = /obj/item/ammo_casing/a10mm
	matter = list(MAT_STEEL = 3000)
	max_ammo = 40
	multiple_sprites = 1

/obj/item/ammo_magazine/ammo_box/b10mm/practice
	name = "ammo box (10mm practice)"
	desc = "A box of 10mm practice rounds"
	icon_state = "box10mm-practice"
	caliber = "10mm"
	ammo_type = /obj/item/ammo_casing/a10mm/practice
	matter = list(MAT_STEEL = 2400)
	max_ammo = 40
	multiple_sprites = 1

/obj/item/ammo_magazine/ammo_box/b10mm/rubber
	name = "ammo box (10mm rubber)"
	desc = "A box of 10mm rubber rounds"
	icon_state = "box10mm-rubber"
	caliber = "10mm"
	ammo_type = /obj/item/ammo_casing/a10mm/rubber
	matter = list(MAT_STEEL = 2400)
	max_ammo = 40
	multiple_sprites = 1

/obj/item/ammo_magazine/ammo_box/b10mm/emp
	name = "ammo box (10mm haywire)"
	desc = "A box of 10mm haywire rounds"
	icon_state = "box10mm-hw"
	caliber = "10mm"
	ammo_type = /obj/item/ammo_casing/a10mm/emp
	matter = list(MAT_STEEL = 5200, MAT_URANIUM = 4000)
	max_ammo = 40
	multiple_sprites = 1

/*
 * .44
 */

/obj/item/ammo_magazine/ammo_box/b44
	name = "ammo box (.44)"
	desc = "A box of .44 rounds"
	icon_state = "box44"
	caliber = ".44"
	ammo_type = /obj/item/ammo_casing/a44
	matter = list(MAT_STEEL = 5040)
	max_ammo = 24
	multiple_sprites = 1

/obj/item/ammo_magazine/ammo_box/b44/rubber
	name = "ammo box (.44 rubber)"
	desc = "A box of .44 rubber rounds"
	icon_state = "box44-rubber"
	caliber = ".44"
	ammo_type = /obj/item/ammo_casing/a44/rubber
	matter = list(MAT_STEEL = 1440)
	max_ammo = 24
	multiple_sprites = 1

/*
 * .45
 */

/obj/item/ammo_magazine/ammo_box/b45
	name = "ammo box (.45)"
	desc = "A box of .45 rounds"
	icon_state = "pistol_s"
	caliber = ".45"
	ammo_type = /obj/item/ammo_casing/a45
	matter = list(MAT_STEEL = 1800)
	max_ammo = 24
	multiple_sprites = 1

/obj/item/ammo_magazine/ammo_box/b45/practice
	name = "ammo box (.45 practice)"
	desc = "A box of .45 practice rounds"
	icon_state = "pistol_p"
	caliber = ".45"
	ammo_type = /obj/item/ammo_casing/a45/practice
	matter = list(MAT_STEEL = 1440)
	max_ammo = 24
	multiple_sprites = 1

/obj/item/ammo_magazine/ammo_box/b45/ap
	name = "ammo box (.45 AP)"
	desc = "A box of .45 armor-piercing rounds"
	icon_state = "pistol_ap"
	caliber = ".45"
	ammo_type = /obj/item/ammo_casing/a45/ap
	matter = list(MAT_STEEL = 1200, MAT_PLASTEEL = 600)
	max_ammo = 24
	multiple_sprites = 1

/obj/item/ammo_magazine/ammo_box/b45/hp
	name = "ammo box (.45 HP)"
	desc = "A box of .45 hollow-point rounds"
	icon_state = "pistol_hp"
	caliber = ".45"
	ammo_type = /obj/item/ammo_casing/a45/hp
	matter = list(MAT_STEEL = 1440, MAT_PLASTIC = 360)
	max_ammo = 24
	multiple_sprites = 1

/obj/item/ammo_magazine/ammo_box/b45/rubber
	name = "ammo box (.45 rubber)"
	desc = "A box of .45 rubber rounds"
	icon_state = "pistol_r"
	caliber = ".45"
	ammo_type = /obj/item/ammo_casing/a45/rubber
	matter = list(MAT_STEEL = 1440)
	max_ammo = 24
	multiple_sprites = 1

/obj/item/ammo_magazine/ammo_box/b45/emp
	name = "ammo box (.45 haywire)"
	desc = "A box of .45 haywire rounds"
	icon_state = "pistol_hw"
	caliber = ".45"
	ammo_type = /obj/item/ammo_casing/a45/emp
	matter = list(MAT_STEEL = 3120, MAT_URANIUM = 2400)
	max_ammo = 24
	multiple_sprites = 1

/*
 * 12g (aka shotgun ammo)
 */

/obj/item/ammo_magazine/ammo_box/b12g
	name = "ammo box (12 gauge slug)"
	desc = "A box of 12 gauge slug rounds"
	icon_state = "slug"
	caliber = "12g"
	ammo_type = /obj/item/ammo_casing/a12g
	matter = list(MAT_STEEL = 2880)
	max_ammo = 8
	multiple_sprites = 1

/obj/item/ammo_magazine/ammo_box/b12g/pellet
	name = "ammo box (12 gauge buckshot)"
	desc = "A box of 12 gauge buckshot rounds"
	icon_state = "buckshot"
	caliber = "12g"
	ammo_type = /obj/item/ammo_casing/a12g/pellet
	matter = list(MAT_STEEL = 2880)
	max_ammo = 8
	multiple_sprites = 1

/obj/item/ammo_magazine/ammo_box/b12g/beanbag
	name = "ammo box (12 gauge beanbag)"
	desc = "A box of 12 gauge beanbag rounds"
	icon_state = "bean"
	caliber = "12g"
	ammo_type = /obj/item/ammo_casing/a12g/beanbag
	matter = list(MAT_STEEL = 1440)
	max_ammo = 8
	multiple_sprites = 1

/obj/item/ammo_magazine/ammo_box/b12g/stunshell
	name = "ammo box (12 gauge stun)"
	desc = "A box of 12 gauge stun rounds"
	icon_state = "stunslug"
	caliber = "12g"
	ammo_type = /obj/item/ammo_casing/a12g/stunshell
	matter = list(MAT_STEEL = 2880, MAT_GLASS = 5760)
	max_ammo = 8
	multiple_sprites = 1

/obj/item/ammo_magazine/ammo_box/b12g/emp
	name = "ammo box (12 gauge EMP)"
	desc = "A box of 12 gauge EMP rounds"
	icon_state = "emp"
	caliber = "12g"
	ammo_type = /obj/item/ammo_casing/a12g/emp
	matter = list(MAT_STEEL = 2880, MAT_URANIUM = 1920)
	max_ammo = 8
	multiple_sprites = 1

/obj/item/ammo_magazine/ammo_box/b12g/flechette
	name = "ammo box (12 gauge flechette)"
	desc = "A box of 12 gauge flechette rounds"
	icon_state = "bean"
	caliber = "12g"
	ammo_type = /obj/item/ammo_casing/a12g/flechette
	matter = list(MAT_STEEL = 2880, MAT_PLASTEEL = 800)
	max_ammo = 8
	multiple_sprites = 1

/obj/item/ammo_magazine/ammo_box/b12g/practice
	name = "ammo box (12 gauge practice)"
	desc = "A box of 12 gauge practice rounds"
	icon_state = "practice"
	caliber = "12g"
	ammo_type = /obj/item/ammo_casing/a12g/practice
	matter = list(MAT_STEEL = 480)
	max_ammo = 8
	multiple_sprites = 1

/obj/item/ammo_magazine/ammo_box/b12g/blank
	name = "ammo box (12 gauge blank)"
	desc = "A box of 12 gauge blank rounds"
	icon_state = "blank"
	caliber = "12g"
	ammo_type = /obj/item/ammo_casing/a12g/blank
	matter = list(MAT_STEEL = 720)
	max_ammo = 8
	multiple_sprites = 1

/obj/item/ammo_magazine/ammo_box/b12g/flash
	name = "ammo box (12 gauge flash)"
	desc = "A box of 12 gauge flash rounds"
	icon_state = "flash"
	caliber = "12g"
	ammo_type = /obj/item/ammo_casing/a12g/flash
	matter = list(MAT_STEEL = 720, MAT_GLASS = 720)
	max_ammo = 8
	multiple_sprites = 1

/*
 * 14.5mm (anti-materiel rifle round)
 */

/obj/item/ammo_magazine/ammo_box/b145
	desc = "ammo box (14.5mm)"
	desc = "A box of 14.5mm rounds"
	icon_state = "sniper"
	caliber = "14.5mm"
	ammo_type = /obj/item/ammo_casing/a145
	matter = list(MAT_STEEL = 8750)
	max_ammo = 7
	multiple_sprites = 1

/obj/item/ammo_magazine/ammo_box/b145/highvel
	desc = "ammo box (14.5mm sabot)"
	desc = "A box of 14.5mm sabot rounds"
	icon_state = "sniper"
	caliber = "14.5mm"
	ammo_type = /obj/item/ammo_casing/a145
	matter = list(MAT_STEEL = 8750)
	max_ammo = 7
	multiple_sprites = 1

/*
 * 7.62mm
 */

/obj/item/ammo_magazine/ammo_box/b762
	name = "ammo box (7.62mm)"
	desc = "A box of 7.62mm rounds"
	icon_state = "rifle"
	caliber = "7.62mm"
	ammo_type = /obj/item/ammo_casing/a762
	matter = list(MAT_STEEL = 6000)
	max_ammo = 30
	multiple_sprites = 1

/obj/item/ammo_magazine/ammo_box/b762/hp
	name = "ammo box (7.62mm HP)"
	desc = "A box of 7.62mm hollow-point rounds"
	icon_state = "rifle_hp"
	caliber = "7.62mm"
	ammo_type = /obj/item/ammo_casing/a762/hp
	matter = list(MAT_STEEL = 9000)
	max_ammo = 30
	multiple_sprites = 1

/obj/item/ammo_magazine/ammo_box/b762/ap
	name = "ammo box (7.62mm AP)"
	desc = "A box of 7.62mm armor-piercing rounds"
	icon_state = "rifle_ap"
	caliber = "7.62mm"
	ammo_type = /obj/item/ammo_casing/a762/ap
	matter = list(MAT_STEEL = 9000)
	max_ammo = 30
	multiple_sprites = 1

/obj/item/ammo_magazine/ammo_box/b762/practice
	name = "ammo box (7.62mm practice)"
	desc = "A box of 7.62mm practice rounds"
	icon_state = "rifle_p"
	caliber = "7.62mm"
	ammo_type = /obj/item/ammo_casing/a762/practice
	matter = list(MAT_STEEL = 2700)
	max_ammo = 30
	multiple_sprites = 1

/obj/item/ammo_magazine/ammo_box/b762/hunter
	name = "ammo box (7.62mm hunter)"
	desc = "A box of 7.62mm hunter rounds"
	icon_state = "rifle_hunter"
	caliber = "7.62mm"
	ammo_type = /obj/item/ammo_casing/a762/hunter
	matter = list(MAT_STEEL = 6000)
	max_ammo = 30
	multiple_sprites = 1

/obj/item/ammo_magazine/ammo_box/b762/surplus
	name = "ammo wrap (7.62mm)"
	desc = "A paper wrap of 7.62mm rounds"
	icon_state = "paper_wrap"
	caliber = "7.62mm"
	ammo_type = /obj/item/ammo_casing/a762
	matter = list(MAT_STEEL = 1600)
	max_ammo = 8
	multiple_sprites = 1

/obj/item/ammo_magazine/ammo_box/b762/surplus/blank
	name = "ammo wrap (7.62mm blank)"
	desc = "A paper wrap of 7.62mm blank rounds"
	icon_state = "paper_wrap"
	caliber = "7.62mm"
	ammo_type = /obj/item/ammo_casing/a762/blank
	matter = list(MAT_STEEL = 720)
	max_ammo = 8
	multiple_sprites = 1

/obj/item/ammo_magazine/ammo_box/b762/surplus/hunter
	name = "ammo wrap (7.62mm hunter)"
	desc = "A paper wrap of 7.62mm hunter rounds"
	icon_state = "paper_wrap"
	caliber = "7.62mm"
	ammo_type = /obj/item/ammo_casing/a762/hunter
	matter = list(MAT_STEEL = 1600)
	max_ammo = 8
	multiple_sprites = 1

/*
 * 5.45mm
 */

/obj/item/ammo_magazine/ammo_box/b545
	name = "ammo box (5.45mm)"
	desc = "A box of 5.45mm rounds"
	icon_state = "hrifle"
	caliber = "5.45mm"
	ammo_type = /obj/item/ammo_casing/a545
	matter = list(MAT_STEEL = 5400)
	max_ammo = 30
	multiple_sprites = 1

/obj/item/ammo_magazine/ammo_box/b545/ap
	name = "ammo box (5.45mm AP)"
	desc = "A box of 5.45mm armor-piercing rounds"
	icon_state = "hrifle-ap"
	caliber = "5.45mm"
	ammo_type = /obj/item/ammo_casing/a545/ap
	matter = list(MAT_STEEL = 8100)
	max_ammo = 30
	multiple_sprites = 1

/obj/item/ammo_magazine/ammo_box/b545/hp
	name = "ammo box (5.45mm HP)"
	desc = "A box of 5.45mm hollow-point rounds"
	icon_state = "hrifle-hp"
	caliber = "5.45mm"
	ammo_type = /obj/item/ammo_casing/a545/hp
	matter = list(MAT_STEEL = 5400)
	max_ammo = 30
	multiple_sprites = 1

/obj/item/ammo_magazine/ammo_box/b545/practice
	name = "ammo box (5.45mm practice)"
	desc = "A box of 5.45mm practice rounds"
	icon_state = "hrifle-practice"
	caliber = "5.45mm"
	ammo_type = /obj/item/ammo_casing/a545/practice
	matter = list(MAT_STEEL = 2700)
	max_ammo = 30
	multiple_sprites = 1

/obj/item/ammo_magazine/ammo_box/b545/hunter
	name = "ammo box (5.45mm hunter)"
	desc = "A box of 5.45mm hunter rounds"
	icon_state = "hrifle-hunter"
	caliber = "5.45mm"
	ammo_type = /obj/item/ammo_casing/a545/hunter
	matter = list(MAT_STEEL = 5400)
	max_ammo = 30
	multiple_sprites = 1

/obj/item/ammo_magazine/ammo_box/b545/blank
	name = "ammo box (5.45mm blank)"
	desc = "A box of 5.45mm blank rounds"
	icon_state = "hrifle-practice"
	caliber = "5.45mm"
	ammo_type = /obj/item/ammo_casing/a545/blank
	matter = list(MAT_STEEL = 2700)
	max_ammo = 30
	multiple_sprites = 1

/obj/item/ammo_magazine/ammo_box/b545/large
	name = "ammo box (5.45mm)"
	desc = "A steel box of 5.45mm rounds"
	icon_state = "boxhrifle"
	caliber = "5.45mm"
	ammo_type = /obj/item/ammo_casing/a545
	matter = list(MAT_STEEL = 18000)
	max_ammo = 100
	multiple_sprites = 1

/obj/item/ammo_magazine/ammo_box/b545/large/ap
	name = "ammo box (5.45mm AP)"
	desc = "A steel box of 5.45mm armor-piercing rounds"
	icon_state = "boxhrifle-ap"
	caliber = "5.45mm"
	ammo_type = /obj/item/ammo_casing/a545/ap
	matter = list(MAT_STEEL = 27000)
	max_ammo = 100
	multiple_sprites = 1

/obj/item/ammo_magazine/ammo_box/b545/large/hp
	name = "ammo box (5.45mm HP)"
	desc = "A steel box of 5.45mm hollow-point rounds"
	icon_state = "boxhrifle-hp"
	caliber = "5.45mm"
	ammo_type = /obj/item/ammo_casing/a545/hp
	matter = list(MAT_STEEL = 18000)
	max_ammo = 100
	multiple_sprites = 1

/obj/item/ammo_magazine/ammo_box/b545/large/practice
	name = "ammo box (5.45mm practice)"
	desc = "A steel box of 5.45mm practice rounds"
	icon_state = "boxhrifle-practice"
	caliber = "5.45mm"
	ammo_type = /obj/item/ammo_casing/a545/practice
	matter = list(MAT_STEEL = 9000)
	max_ammo = 100
	multiple_sprites = 1

/obj/item/ammo_magazine/ammo_box/b545/large/hunter
	name = "ammo box (5.45mm hunter)"
	desc = "A steel box of 5.45mm hunter rounds"
	icon_state = "boxhrifle-hunter"
	caliber = "5.45mm"
	ammo_type = /obj/item/ammo_casing/a545/hunter
	matter = list(MAT_STEEL = 18000)
	max_ammo = 100
	multiple_sprites = 1