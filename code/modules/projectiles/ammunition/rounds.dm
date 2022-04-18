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
#    This comment is copied in magazines.dm as well.
*/
/************************************************************************/

/*
 * Foam
 */

/obj/item/ammo_casing/afoam_dart
	name = "foam dart"
	desc = "It's Donk or Don't! Ages 8 and up."
	projectile_type = /obj/item/projectile/bullet/foam_dart
	matter = list(MAT_PLASTIC = 60)
	caliber = "foam"
	icon = 'icons/obj/gun_toy.dmi'
	icon_state = "foamdart"
	caseless = 1

/obj/item/ammo_casing/afoam_dart/riot
	name = "riot foam dart"
	desc = "Whose smart idea was it to use toys as crowd control? Ages 18 and up."
	projectile_type = /obj/item/projectile/bullet/foam_dart_riot
	matter = list(MAT_STEEL = 210, MAT_PLASTIC = 60)
	icon_state = "foamdart_riot"

/*
 * .357
 */

/obj/item/ammo_casing/a357
	desc = "A .357 bullet casing."
	caliber = ".357"
	projectile_type = /obj/item/projectile/bullet/pistol/strong
	matter = list(MAT_STEEL = 210)

/obj/item/ammo_casing/a357/bb
	desc = "A .357 BB."
	projectile_type = /obj/item/projectile/bullet/bb
	matter = list(MAT_PLASTIC = 20)
	caseless = TRUE

/obj/item/ammo_casing/a357/rubber
	desc = "A .357 rubber bullet casing."
	caliber = ".357"
	icon_state = "r-casing"
	projectile_type = /obj/item/projectile/bullet/pistol/rubber/strong
	matter = list(MAT_STEEL = 60)

/obj/item/ammo_casing/a357/flash
	desc = "A .357 flash bullet casing."
	caliber = ".357"
	icon_state = "r-casing"
	projectile_type = /obj/item/projectile/energy/flash/strong

/obj/item/ammo_casing/a357/stun
	desc = "A .357 stun bullet casing."
	caliber = ".357"
	icon_state = "w-casing"
	projectile_type = /obj/item/projectile/energy/electrode/stunshot/strong

/*
 * .38
 */

/obj/item/ammo_casing/a38
	desc = "A .38 bullet casing."
	caliber = ".38"
	projectile_type = /obj/item/projectile/bullet/pistol
	matter = list(MAT_STEEL = 60)

/obj/item/ammo_casing/a38/rubber
	desc = "A .38 rubber bullet casing."
	icon_state = "r-casing"
	projectile_type = /obj/item/projectile/bullet/pistol/rubber

/obj/item/ammo_casing/a38/emp
	name = ".38 haywire round"
	desc = "A .38 bullet casing fitted with a single-use ion pulse generator."
	icon_state = "empcasing"
	projectile_type = /obj/item/projectile/ion/small
	matter = list(MAT_STEEL = 130, MAT_URANIUM = 100)

/obj/item/ammo_casing/a38/bb
	desc = "A .38 BB."
	projectile_type = /obj/item/projectile/bullet/bb
	matter = list(MAT_PLASTIC = 20)
	caseless = TRUE

/*
 * .44
 */

/obj/item/ammo_casing/a44
	desc = "A .44 bullet casing."
	caliber = ".44"
	projectile_type = /obj/item/projectile/bullet/pistol/strong
	matter = list(MAT_STEEL = 210)

/obj/item/ammo_casing/a44/rubber
	icon_state = "r-casing"
	desc = "A .44 rubber bullet casing."
	projectile_type = /obj/item/projectile/bullet/pistol/rubber/strong
	matter = list(MAT_STEEL = 60)

/obj/item/ammo_casing/a44/rifle
	desc = "A proprietary Hedberg-Hammarstrom .44 bullet casing designed for use in revolving rifles."
	projectile_type = /obj/item/projectile/bullet/rifle/a44rifle
	matter = list(MAT_STEEL = 210)

/obj/item/ammo_casing/a44/bb
	desc = "A .44 BB."
	projectile_type = /obj/item/projectile/bullet/bb
	matter = list(MAT_PLASTIC = 20)
	caseless = TRUE

/*
 * .75 (aka Gyrojet Rockets, aka admin abuse)
 */

/obj/item/ammo_casing/a75
	desc = "A .75 gyrojet rocket sheathe."
	caliber = ".75"
	projectile_type = /obj/item/projectile/bullet/gyro
	matter = list(MAT_STEEL = 4000)

/*
 * 9mm
 */

/obj/item/ammo_casing/a9mm
	desc = "A 9mm bullet casing."
	caliber = "9mm"
	projectile_type = /obj/item/projectile/bullet/pistol
	matter = list(MAT_STEEL = 60)

/obj/item/ammo_casing/a9mm/ap
	desc = "A 9mm armor-piercing bullet casing."
	projectile_type = /obj/item/projectile/bullet/pistol/ap
	matter = list(MAT_STEEL = 80)

/obj/item/ammo_casing/a9mm/hp
	desc = "A 9mm hollow-point bullet casing."
	projectile_type = /obj/item/projectile/bullet/pistol/hp

/obj/item/ammo_casing/a9mm/flash
	desc = "A 9mm flash shell casing."
	icon_state = "r-casing"
	projectile_type = /obj/item/projectile/energy/flash

/obj/item/ammo_casing/a9mm/rubber
	desc = "A 9mm rubber bullet casing."
	icon_state = "r-casing"
	projectile_type = /obj/item/projectile/bullet/pistol/rubber

/obj/item/ammo_casing/a9mm/practice
	desc = "A 9mm practice bullet casing."
	icon_state = "r-casing"
	projectile_type = /obj/item/projectile/bullet/practice

/obj/item/ammo_casing/a9mm/bb
	desc = "A 9mm BB."
	projectile_type = /obj/item/projectile/bullet/bb
	matter = list(MAT_PLASTIC = 20)
	caseless = TRUE

/*
 * .45
 */

/obj/item/ammo_casing/a45
	desc = "A .45 bullet casing."
	caliber = ".45"
	projectile_type = /obj/item/projectile/bullet/pistol/medium
	matter = list(MAT_STEEL = 75)

/obj/item/ammo_casing/a45/ap
	desc = "A .45 Armor-Piercing bullet casing."
	icon_state = "r-casing"
	projectile_type = /obj/item/projectile/bullet/pistol/medium/ap
	matter = list(MAT_STEEL = 50, MAT_PLASTEEL = 25)

/obj/item/ammo_casing/a45/practice
	desc = "A .45 practice bullet casing."
	icon_state = "r-casing"
	projectile_type = /obj/item/projectile/bullet/practice
	matter = list(MAT_STEEL = 60)

/obj/item/ammo_casing/a45/rubber
	desc = "A .45 rubber bullet casing."
	icon_state = "r-casing"
	projectile_type = /obj/item/projectile/bullet/pistol/rubber
	matter = list(MAT_STEEL = 60)

/obj/item/ammo_casing/a45/flash
	desc = "A .45 flash shell casing."
	icon_state = "r-casing"
	projectile_type = /obj/item/projectile/energy/flash
	matter = list(MAT_STEEL = 60)

/obj/item/ammo_casing/a45/emp
	name = ".45 haywire round"
	desc = "A .45 bullet casing fitted with a single-use ion pulse generator."
	projectile_type = /obj/item/projectile/ion/small
	icon_state = "empcasing"
	matter = list(MAT_STEEL = 130, MAT_URANIUM = 100)

/obj/item/ammo_casing/a45/hp
	desc = "A .45 hollow-point bullet casing."
	projectile_type = /obj/item/projectile/bullet/pistol/medium/hp
	matter = list(MAT_STEEL = 60, MAT_PLASTIC = 15)

/obj/item/ammo_casing/a45/bb
	desc = "A .45 BB."
	projectile_type = /obj/item/projectile/bullet/bb
	matter = list(MAT_PLASTIC = 20)
	caseless = TRUE

/*
 * 10mm
 */

/obj/item/ammo_casing/a10mm
	desc = "A 10mm bullet casing."
	caliber = "10mm"
	projectile_type = /obj/item/projectile/bullet/pistol/medium
	matter = list(MAT_STEEL = 75)

/obj/item/ammo_casing/a10mm/practice
	desc = "A 10mm practice bullet casing."
	icon_state = "r-casing"
	projectile_type = /obj/item/projectile/bullet/practice
	matter = list(MAT_STEEL = 60)

/obj/item/ammo_casing/a10mm/rubber
	desc = "A 10mm rubber bullet casing."
	projectile_type = /obj/item/projectile/bullet/pistol/rubber
	icon_state = "r-casing"
	matter = list(MAT_STEEL = 60)

/obj/item/ammo_casing/a10mm/emp
	name = "10mm haywire round"
	desc = "A 10mm bullet casing fitted with a single-use ion pulse generator."
	projectile_type = /obj/item/projectile/ion/small
	icon_state = "empcasing"
	matter = list(MAT_STEEL = 130, MAT_URANIUM = 100)

/obj/item/ammo_casing/a10mm/bb
	desc = "A 10mm BB."
	projectile_type = /obj/item/projectile/bullet/bb
	matter = list(MAT_PLASTIC = 20)
	caseless = TRUE

/*
 * 12g (aka shotgun ammo)
 */

/obj/item/ammo_casing/a12g
	name = "shotgun slug"
	desc = "A 12 gauge slug."
	icon_state = "slshell"
	caliber = "12g"
	projectile_type = /obj/item/projectile/bullet/shotgun
	matter = list(MAT_STEEL = 360)

/obj/item/ammo_casing/a12g/pellet
	name = "shotgun shell"
	desc = "A 12 gauge shell."
	icon_state = "gshell"
	projectile_type = /obj/item/projectile/bullet/pellet/shotgun

/obj/item/ammo_casing/a12g/blank
	name = "shotgun shell"
	desc = "A blank shell."
	icon_state = "blshell"
	projectile_type = /obj/item/projectile/bullet/blank
	matter = list(MAT_STEEL = 90)

/obj/item/ammo_casing/a12g/practice
	name = "shotgun shell"
	desc = "A practice shell."
	icon_state = "pshell"
	projectile_type = /obj/item/projectile/bullet/practice
	matter = list(MAT_STEEL = 90)

/obj/item/ammo_casing/a12g/beanbag
	name = "beanbag shell"
	desc = "A beanbag shell."
	icon_state = "bshell"
	projectile_type = /obj/item/projectile/bullet/shotgun/beanbag
	matter = list(MAT_STEEL = 180)

//Can stun in one hit if aimed at the head, but
//is blocked by clothing that stops tasers and is vulnerable to EMP
/obj/item/ammo_casing/a12g/stunshell
	name = "stun shell"
	desc = "A 12 gauge taser cartridge."
	icon_state = "stunshell"
	projectile_type = /obj/item/projectile/energy/electrode/stunshot
	matter = list(MAT_STEEL = 360, MAT_GLASS = 720)

/obj/item/ammo_casing/a12g/stunshell/emp_act(severity)
	if(prob(100/severity)) BB = null
	update_icon()

//Does not stun, only blinds, but has area of effect.
/obj/item/ammo_casing/a12g/flash
	name = "flash shell"
	desc = "A chemical shell used to signal distress or provide illumination."
	icon_state = "fshell"
	projectile_type = /obj/item/projectile/energy/flash/flare
	matter = list(MAT_STEEL = 90, MAT_GLASS = 90)

/obj/item/ammo_casing/a12g/emp
	name = "ion shell"
	desc = "An advanced shotgun round that creates a small EMP when it strikes a target."
	icon_state = "empshell"
	projectile_type = /obj/item/projectile/ion
//	projectile_type = /obj/item/projectile/bullet/shotgun/ion
	matter = list(MAT_STEEL = 360, MAT_URANIUM = 240)

/obj/item/ammo_casing/a12g/flechette
	name = "shotgun flechette"
	desc = "A 12 gauge flechette cartidge, also known as nailshot."
	icon_state = "slshell"
	caliber = "12g"
	projectile_type = /obj/item/projectile/scatter/flechette
	matter = list(MAT_STEEL = 360, MAT_PLASTEEL = 100)

/obj/item/ammo_casing/a12g/bb
	desc = "A shotgun BB shell."
	projectile_type = /obj/item/projectile/bullet/pellet/shotgun/bb // Shotgun
	matter = list(MAT_PLASTIC = 120) // 6 pellets

/*
 * 7.62mm
 */

/obj/item/ammo_casing/a762
	desc = "A 7.62mm bullet casing."
	caliber = "7.62mm"
	icon_state = "rifle-casing"
	projectile_type = /obj/item/projectile/bullet/rifle/a762
	matter = list(MAT_STEEL = 200)

/obj/item/ammo_casing/a762/ap
	desc = "A 7.62mm armor-piercing bullet casing."
	projectile_type = /obj/item/projectile/bullet/rifle/a762/ap
	matter = list(MAT_STEEL = 300)

/obj/item/ammo_casing/a762/practice
	desc = "A 7.62mm practice bullet casing."
	icon_state = "rifle-casing" // Need to make an icon for these
	projectile_type = /obj/item/projectile/bullet/practice
	matter = list(MAT_STEEL = 90)

/obj/item/ammo_casing/a762/blank
	desc = "A blank 7.62mm bullet casing."
	projectile_type = /obj/item/projectile/bullet/blank
	matter = list(MAT_STEEL = 90)

/obj/item/ammo_casing/a762/hp
	desc = "A 7.62mm hollow-point bullet casing."
	projectile_type = /obj/item/projectile/bullet/rifle/a762/hp

/obj/item/ammo_casing/a762/hunter
	desc = "A 7.62mm hunting bullet casing."
	projectile_type = /obj/item/projectile/bullet/rifle/a762/hunter

/obj/item/ammo_casing/a762/bb
	desc = "A 7.62mm BB."
	projectile_type = /obj/item/projectile/bullet/bb
	matter = list(MAT_PLASTIC = 20)
	caseless = TRUE

/*
 * 14.5mm (anti-materiel rifle round)
 */

/obj/item/ammo_casing/a145
	desc = "A 14.5mm shell."
	icon_state = "lcasing"
	caliber = "14.5mm"
	projectile_type = /obj/item/projectile/bullet/rifle/a145
	matter = list(MAT_STEEL = 1250)

/obj/item/ammo_casing/a145/highvel
	desc = "A 14.5mm sabot shell."
	projectile_type = /obj/item/projectile/bullet/rifle/a145
	
/obj/item/ammo_casing/a145/bb
	desc = "A 14.5mm BB. That'll take someone's eye out."
	projectile_type = /obj/item/projectile/bullet/bb
	matter = list(MAT_PLASTIC = 20)
	caseless = TRUE

/obj/item/ammo_casing/a145/spent/Initialize()
	..()
	expend()

/*
 * 5.45mm
 */

/obj/item/ammo_casing/a545
	desc = "A 5.45mm bullet casing."
	caliber = "5.45mm"
	icon_state = "rifle-casing"
	projectile_type = /obj/item/projectile/bullet/rifle/a545
	matter = list(MAT_STEEL = 180)

/obj/item/ammo_casing/a545/ap
	desc = "A 5.45mm armor-piercing bullet casing."
	projectile_type = /obj/item/projectile/bullet/rifle/a545/ap
	matter = list(MAT_STEEL = 270)

/obj/item/ammo_casing/a545/practice
	desc = "A 5.45mm practice bullet casing."
	icon_state = "rifle-casing" // Need to make an icon for these
	projectile_type = /obj/item/projectile/bullet/practice
	matter = list(MAT_STEEL = 90)

/obj/item/ammo_casing/a545/blank
	desc = "A blank 5.45mm bullet casing."
	projectile_type = /obj/item/projectile/bullet/blank
	matter = list(MAT_STEEL = 90)

/obj/item/ammo_casing/a545/hp
	desc = "A 5.45mm hollow-point bullet casing."
	projectile_type = /obj/item/projectile/bullet/rifle/a545/hp

/obj/item/ammo_casing/a545/hunter
	desc = "A 5.45mm hunting bullet casing."
	projectile_type = /obj/item/projectile/bullet/rifle/a545/hunter

/obj/item/ammo_casing/a545/bb
	desc = "A 5.45mm BB."
	projectile_type = /obj/item/projectile/bullet/bb
	matter = list(MAT_PLASTIC = 20)
	caseless = TRUE

/*
 * 5mm Caseless
 */

/obj/item/ammo_casing/a5mmcaseless
	desc = "A 5mm solid phoron caseless round."
	caliber = "5mm caseless"
	icon_state = "casing" // Placeholder. Should probably be purple.
	projectile_type = /obj/item/projectile/bullet/pistol // Close enough to be comparable.
	matter = list(MAT_STEEL = 180)
	caseless = 1

/obj/item/ammo_casing/a5mmcaseless/stun
	desc = "A 5mm solid phoron caseless stun round."
	projectile_type = /obj/item/projectile/energy/electrode // Maybe nerf this considering there's 30 rounds in a mag.

/obj/item/ammo_casing/a5mmcaseless/bb
	desc = "A 5mm caseless airsoft BB."
	projectile_type = /obj/item/projectile/bullet/bb
	matter = list(MAT_PLASTIC = 20)
	caseless = TRUE

/*
 * Misc
 */

/obj/item/ammo_casing/rocket
	name = "rocket shell"
	desc = "A high explosive designed to be fired from a launcher."
	icon_state = "rocketshell"
	projectile_type = /obj/item/projectile/bullet/srmrocket
	caliber = "rocket"
	matter = list(MAT_STEEL = 10000)

/obj/item/ammo_casing/cap
	name = "cap"
	desc = "A cap for children toys. Ages 8 and up."
	caliber = "caps"
	icon = 'icons/obj/gun_toy.dmi'
	icon_state = "cap"
	projectile_type = /obj/item/projectile/bullet/cap
	matter = list(MAT_STEEL = 85)
	caseless = 1

/obj/item/ammo_casing/spent // For simple hostile mobs only, so they don't cough up usable bullets when firing. This is for literally nothing else.
	icon_state = "s-casing-spent"
	BB = null
	projectile_type = null
