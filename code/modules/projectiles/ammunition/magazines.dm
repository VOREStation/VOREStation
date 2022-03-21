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
#    This comment is copied in rounds.dm and ammo_boxes.dm as well.
#
#    Also, if a magazine is only meant for a specific gun, include the name
#    of the specific gun in the path. Example: m45uzi is only for the Uzi.
*/
/************************************************************************/

///////// Foam /////////

/obj/item/ammo_magazine/mfoam_dart/pistol
	name = "\improper Donk-Soft pistol magazine"
	icon = 'icons/obj/gun_toy.dmi'
	icon_state = "toy"
	mag_type = MAGAZINE
	ammo_type = /obj/item/ammo_casing/afoam_dart
	matter = list(MAT_PLASTIC = 250)
	caliber = "foam"
	max_ammo = 9
	multiple_sprites = 1

/obj/item/ammo_magazine/mfoam_dart/pistol/empty
	initial_ammo = 0

/obj/item/ammo_magazine/mfoam_dart/pistol/riot
	ammo_type = /obj/item/ammo_casing/afoam_dart/riot

// SMG
/obj/item/ammo_magazine/mfoam_dart/smg
	name = "\improper Donk-Soft smg magazine"
	icon = 'icons/obj/gun_toy.dmi'
	icon_state = "toysmg"
	mag_type = MAGAZINE
	ammo_type = /obj/item/ammo_casing/afoam_dart
	matter = list(MAT_PLASTIC = 250)
	caliber = "foam"
	max_ammo = 20
	multiple_sprites = 1

/obj/item/ammo_magazine/mfoam_dart/smg/empty
	initial_ammo = 0

/obj/item/ammo_magazine/mfoam_dart/smg/riot
	ammo_type = /obj/item/ammo_casing/afoam_dart/riot
	matter = list(MAT_PLASTIC = 1260, MAT_PLASTIC = 250)

///////// .357 /////////

/obj/item/ammo_magazine/s357
	name = "speedloader (.357)"
	desc = "A speedloader for .357 revolvers."
	icon_state = "38"
	caliber = ".357"
	ammo_type = /obj/item/ammo_casing/a357
	matter = list(MAT_STEEL = 1260)
	max_ammo = 6
	multiple_sprites = 1

/obj/item/ammo_magazine/s357/stun
	name = "speedloader (.357 stun)"
	icon_state = "T38"
	ammo_type = /obj/item/ammo_casing/a357/stun

/obj/item/ammo_magazine/s357/rubber
	name = "speedloader (.357 rubber)"
	icon_state = "T38"
	ammo_type = /obj/item/ammo_casing/a357/rubber

/obj/item/ammo_magazine/s357/flash
	name = "speedloader (.357 flash)"
	icon_state = "S38"
	ammo_type = /obj/item/ammo_casing/a357/flash

///////// .38 /////////

/obj/item/ammo_magazine/s38
	name = "speedloader (.38)"
	desc = "A speedloader for .38 revolvers."
	icon_state = "38"
	caliber = ".38"
	matter = list(MAT_STEEL = 360)
	ammo_type = /obj/item/ammo_casing/a38
	max_ammo = 6
	multiple_sprites = 1

/obj/item/ammo_magazine/s38/rubber
	name = "speedloader (.38 rubber)"
	icon_state = "T38"
	ammo_type = /obj/item/ammo_casing/a38/rubber

/obj/item/ammo_magazine/s38/emp
	name = "speedloader (.38 haywire)"
	ammo_type = /obj/item/ammo_casing/a38/emp

///////// .45 /////////

/obj/item/ammo_magazine/m45
	name = "pistol magazine (.45)"
	icon_state = "45"
	mag_type = MAGAZINE
	ammo_type = /obj/item/ammo_casing/a45
	matter = list(MAT_STEEL = 525) //metal costs are very roughly based around 1 .45 casing = 75 metal
	caliber = ".45"
	max_ammo = 7
	multiple_sprites = 1

/obj/item/ammo_magazine/m45/empty
	initial_ammo = 0

/obj/item/ammo_magazine/m45/rubber
	name = "magazine (.45 rubber)"
	ammo_type = /obj/item/ammo_casing/a45/rubber

/obj/item/ammo_magazine/m45/practice
	name = "magazine (.45 practice)"
	ammo_type = /obj/item/ammo_casing/a45/practice

/obj/item/ammo_magazine/m45/flash
	name = "magazine (.45 flash)"
	ammo_type = /obj/item/ammo_casing/a45/flash

/obj/item/ammo_magazine/m45/ap
	name = "magazine (.45 AP)"
	ammo_type = /obj/item/ammo_casing/a45/ap

/obj/item/ammo_magazine/m45/hp
	name = "magazine (.45 HP)"
	ammo_type = /obj/item/ammo_casing/a45/hp

/obj/item/ammo_magazine/box/emp/b45
	name = "ammunition box (.45 haywire)"
	ammo_type = /obj/item/ammo_casing/a45/emp

// Uzi
/obj/item/ammo_magazine/m45uzi
	name = "stick magazine (.45)"
	icon_state = "uzi45"
	mag_type = MAGAZINE
	ammo_type = /obj/item/ammo_casing/a45
	matter = list(MAT_STEEL = 1200)
	caliber = ".45"
	max_ammo = 16
	multiple_sprites = 1

/obj/item/ammo_magazine/m45uzi/empty
	initial_ammo = 0

// Tommy Gun
/obj/item/ammo_magazine/m45tommy
	name = "Tommy Gun magazine (.45)"
	icon_state = "tomstick"
	mag_type = MAGAZINE
	ammo_type = /obj/item/ammo_casing/a45
	matter = list(MAT_STEEL = 1500)
	caliber = ".45"
	max_ammo = 20
	multiple_sprites = 1

/obj/item/ammo_magazine/m45tommy/ap
	name = "Tommy Gun magazine (.45 AP)"
	ammo_type = /obj/item/ammo_casing/a45/ap

/obj/item/ammo_magazine/m45tommy/empty
	initial_ammo = 0

/obj/item/ammo_magazine/m45tommydrum
	name = "Tommy Gun drum magazine (.45)"
	icon_state = "tomdrum"
	w_class = ITEMSIZE_NORMAL // Bulky ammo doesn't fit in your pockets!
	mag_type = MAGAZINE
	ammo_type = /obj/item/ammo_casing/a45
	matter = list(MAT_STEEL = 3750)
	caliber = ".45"
	max_ammo = 50
	multiple_sprites = 1

/obj/item/ammo_magazine/m45tommydrum/empty
	initial_ammo = 0

/obj/item/ammo_magazine/m45tommydrum/ap
	name = "Tommy Gun drum magazine (.45 AP)"
	ammo_type = /obj/item/ammo_casing/a45/ap

// Stripper Clip
/obj/item/ammo_magazine/clip/c45
	name = "ammo clip (.45)"
	icon_state = "clip_pistol"
	desc = "A stripper clip for reloading .45 rounds into magazines."
	caliber = ".45"
	ammo_type = /obj/item/ammo_casing/a45
	matter = list(MAT_STEEL = 675) // metal costs very roughly based around one .45 casing = 75 metal
	max_ammo = 9
	multiple_sprites = 1

/obj/item/ammo_magazine/clip/c45/rubber
	name = "ammo clip (.45 rubber)"
	ammo_type = /obj/item/ammo_casing/a45/rubber

/obj/item/ammo_magazine/clip/c45/practice
	name = "ammo clip (.45 practice)"
	ammo_type = /obj/item/ammo_casing/a45/practice

/obj/item/ammo_magazine/clip/c45/flash
	name = "ammo clip (.45 flash)"
	ammo_type = /obj/item/ammo_casing/a45/flash

// Speedloader
/obj/item/ammo_magazine/s45
	name = "speedloader (.45)"
	icon_state = "45s"
	ammo_type = /obj/item/ammo_casing/a45
	matter = list(MAT_STEEL = 525) //metal costs are very roughly based around 1 .45 casing = 75 metal
	caliber = ".45"
	max_ammo = 6
	multiple_sprites = 1

/obj/item/ammo_magazine/s45/empty
	initial_ammo = 0

/obj/item/ammo_magazine/s45/rubber
	name = "speedloader (.45 rubber)"
	ammo_type = /obj/item/ammo_casing/a45/rubber

/obj/item/ammo_magazine/s45/practice
	name = "speedloader (.45 practice)"
	ammo_type = /obj/item/ammo_casing/a45/practice

/obj/item/ammo_magazine/s45/flash
	name = "speedloader (.45 flash)"
	ammo_type = /obj/item/ammo_casing/a45/flash

/obj/item/ammo_magazine/s45/ap
	name = "speedloader (.45 AP)"
	ammo_type = /obj/item/ammo_casing/a45/ap

///////// 5mm Caseless /////////

/obj/item/ammo_magazine/m5mmcaseless
	name = "prototype rifle magazine (5mm caseless)"
	ammo_type = /obj/item/ammo_casing/a5mmcaseless
	icon_state = "caseless-mag"
	caliber = "5mm caseless"
	mag_type = MAGAZINE
	max_ammo = 30
	multiple_sprites = 1

/obj/item/ammo_magazine/m5mmcaseless/empty
	initial_ammo = 0

/obj/item/ammo_magazine/m5mmcaseless/stun
	icon_state = "caseless-mag-alt"
	ammo_type = /obj/item/ammo_casing/a5mmcaseless/stun

///////// 9mm /////////

/obj/item/ammo_magazine/m9mm
	name = "magazine (9mm)"
	icon_state = "m91"
	origin_tech = list(TECH_COMBAT = 2)
	mag_type = MAGAZINE
	matter = list(MAT_STEEL = 600)
	caliber = "9mm"
	ammo_type = /obj/item/ammo_casing/a9mm
	max_ammo = 10
	multiple_sprites = 1

/obj/item/ammo_magazine/m9mm/empty
	initial_ammo = 0

/obj/item/ammo_magazine/m9mm/flash
	name = "magazine (9mm flash)"
	ammo_type = /obj/item/ammo_casing/a9mm/flash

/obj/item/ammo_magazine/m9mm/rubber
	name = "magazine (9mm rubber)"
	ammo_type = /obj/item/ammo_casing/a9mm/rubber

/obj/item/ammo_magazine/m9mm/practice
	name = "magazine (9mm practice)"
	ammo_type = /obj/item/ammo_casing/a9mm/practice

// Extended
/obj/item/ammo_magazine/m9mm/large
	name = "extended magazine (9mm)"
	desc = "\"FOR LAW ENFORCEMENT/MILITARY USE ONLY\" is clearly etched on the magazine. This is probably illegal for you to have." // Remember, Security is not Law Enforcement, so it's illegal for Security to use as well.
	icon_state = "m93"
	origin_tech = list(TECH_COMBAT = 2, TECH_ILLEGAL = 1)
	mag_type = MAGAZINE
	matter = list(MAT_STEEL = 1000)
	caliber = "9mm"
	ammo_type = /obj/item/ammo_casing/a9mm
	max_ammo = 17
	multiple_sprites = 1

/obj/item/ammo_magazine/m9mm/large/empty
	initial_ammo = 0

/obj/item/ammo_magazine/m9mm/large/preban // Sold by traders.
	desc = "A large capacity magazine that was built before the SolGov Assault Weapons Ban, so it's legal to own."

/obj/item/ammo_magazine/m9mm/large/preban/hp // Hollow Point version
	name = "magazine (9mm hollow-point)"
	ammo_type = /obj/item/ammo_casing/a9mm/hp

// Compact
/obj/item/ammo_magazine/m9mm/compact
	name = "compact magazine (9mm)"
	icon_state = "m92"
	origin_tech = list(TECH_COMBAT = 2)
	mag_type = MAGAZINE
	matter = list(MAT_STEEL = 480)
	caliber = "9mm"
	ammo_type = /obj/item/ammo_casing/a9mm
	max_ammo = 8
	multiple_sprites = 1

/obj/item/ammo_magazine/m9mm/compact/empty
	initial_ammo = 0

/obj/item/ammo_magazine/m9mm/compact/flash
	name = "compact magazine (9mm flash)"
	ammo_type = /obj/item/ammo_casing/a9mm/flash

/obj/item/ammo_magazine/m9mm/compact/rubber
	name = "compact magazine (9mm rubber)"
	ammo_type = /obj/item/ammo_casing/a9mm/rubber

/obj/item/ammo_magazine/m9mm/compact/practice
	name = "compact magazine (9mm practice)"
	ammo_type = /obj/item/ammo_casing/a9mm/practice

// SMG
/obj/item/ammo_magazine/m9mmt
	name = "top mounted magazine (9mm)"
	icon_state = "9mmt"
	mag_type = MAGAZINE
	ammo_type = /obj/item/ammo_casing/a9mm
	matter = list(MAT_STEEL = 1200)
	caliber = "9mm"
	max_ammo = 20
	multiple_sprites = 1

/obj/item/ammo_magazine/m9mmt/empty
	initial_ammo = 0

/obj/item/ammo_magazine/m9mmt/rubber
	name = "top mounted magazine (9mm rubber)"
	ammo_type = /obj/item/ammo_casing/a9mm/rubber

/obj/item/ammo_magazine/m9mmt/flash
	name = "top mounted magazine (9mm flash)"
	ammo_type = /obj/item/ammo_casing/a9mm/flash

/obj/item/ammo_magazine/m9mmt/practice
	name = "top mounted magazine (9mm practice)"
	ammo_type = /obj/item/ammo_casing/a9mm/practice

/obj/item/ammo_magazine/m9mmt/ap
	name = "top mounted magazine (9mm armor piercing)"
	ammo_type = /obj/item/ammo_casing/a9mm/ap
	matter = list(MAT_STEEL = 1000, MAT_PLASTEEL = 2000)

// P90
/obj/item/ammo_magazine/m9mmp90
	name = "large capacity top mounted magazine (9mm armor-piercing)"
	icon_state = "p90"
	mag_type = MAGAZINE
	ammo_type = /obj/item/ammo_casing/a9mm/ap
	matter = list(MAT_STEEL = 3000)
	caliber = "9mm"
	max_ammo = 50
	multiple_sprites = 1

/obj/item/ammo_magazine/m9mmp90/empty
	initial_ammo = 0

// Stripper Clip
/obj/item/ammo_magazine/clip/c9mm
	name = "ammo clip (9mm)"
	icon_state = "clip_pistol"
	desc = "A stripper clip for reloading 9mm rounds into magazines."
	caliber = "9mm"
	ammo_type = /obj/item/ammo_casing/a9mm
	matter = list(MAT_STEEL = 540) // metal costs are very roughly based around one 9mm casing = 60 metal
	max_ammo = 9
	multiple_sprites = 1

/obj/item/ammo_magazine/clip/c9mm/rubber
	name = "ammo clip (.45 rubber)"
	ammo_type = /obj/item/ammo_casing/a9mm/rubber

/obj/item/ammo_magazine/clip/c9mm/practice
	name = "ammo clip (.45 practice)"
	ammo_type = /obj/item/ammo_casing/a9mm/practice

/obj/item/ammo_magazine/clip/c9mm/flash
	name = "ammo clip (.45 flash)"
	ammo_type = /obj/item/ammo_casing/a9mm/flash

// Advanced SMG
/obj/item/ammo_magazine/m9mmAdvanced
	desc = "A very high capacity double stack magazine made specially for the Advanced SMG. Filled with 21 9mm bullets."
	icon_state = "S9mm"
	mag_type = MAGAZINE
	ammo_type = /obj/item/ammo_casing/a9mm
	matter = list(MAT_STEEL = 1200)
	caliber = "9mm"
	max_ammo = 21
	origin_tech = list(TECH_COMBAT = 2, TECH_ILLEGAL = 1)
	multiple_sprites = 1

/obj/item/ammo_magazine/m9mmAdvanced/ap
	desc = "A high capacity double stack magazine made specially for the Advanced SMG. Filled with 21 9mm armor piercing bullets."
	icon_state = "S9mm"
	ammo_type = /obj/item/ammo_casing/a9mm/ap
	matter = list(MAT_STEEL = 2000)

/obj/item/ammo_magazine/m9mmR/saber/empty
	initial_ammo = 0

///////// 10mm /////////

/obj/item/ammo_magazine/m10mm
	name = "magazine (10mm)"
	icon_state = "10mm"
	origin_tech = list(TECH_COMBAT = 2)
	mag_type = MAGAZINE
	caliber = "10mm"
	matter = list(MAT_STEEL = 1500)
	ammo_type = /obj/item/ammo_casing/a10mm
	max_ammo = 20
	multiple_sprites = 1

/obj/item/ammo_magazine/m10mm/empty
	initial_ammo = 0

///////// 5.45mm /////////

/obj/item/ammo_magazine/m545
	name = "magazine (5.45mm)"
	icon_state = "m545"
	origin_tech = list(TECH_COMBAT = 2)
	mag_type = MAGAZINE
	caliber = "5.45mm"
	matter = list(MAT_STEEL = 1800)
	ammo_type = /obj/item/ammo_casing/a545
	max_ammo = 20
	multiple_sprites = 1

/obj/item/ammo_magazine/m545/empty
	initial_ammo = 0

/obj/item/ammo_magazine/m545/practice
	name = "magazine (5.45mm practice)"
	ammo_type = /obj/item/ammo_casing/a545/practice

/obj/item/ammo_magazine/m545/ap
	name = "magazine (5.45mm armor-piercing)"
	ammo_type = /obj/item/ammo_casing/a545/ap

/obj/item/ammo_magazine/m545/hunter
	name = "magazine (5.45mm hunting)"
	ammo_type = /obj/item/ammo_casing/a545/hunter

// Extended
/obj/item/ammo_magazine/m545/ext
	name = "extended magazine (5.45mm)"
	matter = list(MAT_STEEL = 2700)
	max_ammo = 30

/obj/item/ammo_magazine/m545/ext/empty
	initial_ammo = 0

/obj/item/ammo_magazine/m545/practice/ext
	name = "extended magazine (5.45mm practice)"
	max_ammo = 30

/obj/item/ammo_magazine/m545/ap/ext
	name = "extended magazine (5.45mm armor-piercing)"
	max_ammo = 30

/obj/item/ammo_magazine/m545/hunter/ext
	name = "extended magazine (5.45mm hunting)"
	max_ammo = 30

// Reduced
/obj/item/ammo_magazine/m545/small
	name = "reduced magazine (5.45mm)"
	icon_state = "m545-small"
	matter = list(MAT_STEEL = 900)
	max_ammo = 10

/obj/item/ammo_magazine/m545/small/empty
	initial_ammo = 0

/obj/item/ammo_magazine/m545/small/practice
	name = "magazine (5.45mm practice)"
	ammo_type = /obj/item/ammo_casing/a545/practice

/obj/item/ammo_magazine/m545/small/ap
	name = "magazine (5.45mm armor-piercing)"
	ammo_type = /obj/item/ammo_casing/a545/ap

/obj/item/ammo_magazine/m545/small/hunter
	name = "magazine (5.45mm hunting)"
	ammo_type = /obj/item/ammo_casing/a545/hunter

// Stripper Clip
/obj/item/ammo_magazine/clip/c545
	name = "ammo clip (5.45mm)"
	icon_state = "clip_rifle"
	caliber = "5.45mm"
	ammo_type = /obj/item/ammo_casing/a545
	matter = list(MAT_STEEL = 450) // metal costs are very roughly based around one 10mm casing = 180 metal
	max_ammo = 5
	multiple_sprites = 1

/obj/item/ammo_magazine/clip/c545/ap
	name = "rifle clip (5.45mm armor-piercing)"
	ammo_type = /obj/item/ammo_casing/a545/ap

/obj/item/ammo_magazine/clip/c545/hunter
	name = "rifle clip (5.45mm hunting)"
	ammo_type = /obj/item/ammo_casing/a545/hunter

/obj/item/ammo_magazine/clip/c545/practice
	name = "rifle clip (5.45mm practice)"
	ammo_type = /obj/item/ammo_casing/a545

// SAW
/obj/item/ammo_magazine/m545saw
	name = "magazine box (5.45mm)"
	icon_state = "a545"
	origin_tech = list(TECH_COMBAT = 2)
	mag_type = MAGAZINE
	caliber = "5.45mm"
	matter = list(MAT_STEEL = 10000)
	ammo_type = /obj/item/ammo_casing/a545
	w_class = ITEMSIZE_NORMAL // This should NOT fit in your pocket!!
	max_ammo = 50
	multiple_sprites = 1

/obj/item/ammo_magazine/m545saw/empty
	initial_ammo = 0

/obj/item/ammo_magazine/m545saw/ap
	name = "magazine box (5.45mm armor-piercing)"
	ammo_type = /obj/item/ammo_casing/a545/ap

/obj/item/ammo_magazine/m545saw/hunter
	name = "magazine box (5.45mm hunting)"
	ammo_type = /obj/item/ammo_casing/a545/hunter

///////// .44 Magnum /////////

/obj/item/ammo_magazine/m44
	name = "magazine (.44)"
	icon_state = "m44"
	origin_tech = list(TECH_COMBAT = 2)
	mag_type = MAGAZINE
	caliber = ".44"
	matter = list(MAT_STEEL = 1260)
	ammo_type = /obj/item/ammo_casing/a44
	max_ammo = 7
	multiple_sprites = 1

/obj/item/ammo_magazine/m44/empty
	initial_ammo = 0

/obj/item/ammo_magazine/m44/rubber
	desc = "magazine (.44 rubber)"
	ammo_type = /obj/item/ammo_casing/a44/rubber

// Stripper Clip
/obj/item/ammo_magazine/clip/c44
	name = "ammo clip (.44)"
	icon_state = "clip_pistol"
	desc = "A stripper clip for reloading .44 rounds into magazines."
	caliber = ".44"
	ammo_type = /obj/item/ammo_casing/a44
	matter = list(MAT_STEEL = 1620) // metal costs are very roughly based around one .50 casing = 180 metal
	max_ammo = 9
	multiple_sprites = 1

// Speedloader
/obj/item/ammo_magazine/s44
	name = "speedloader (.44)"
	icon_state = "44"
	ammo_type = /obj/item/ammo_casing/a44
	matter = list(MAT_STEEL = 1260) //metal costs are very roughly based around 1 .45 casing = 75 metal
	caliber = ".44"
	max_ammo = 6
	multiple_sprites = 1

/obj/item/ammo_magazine/s44/empty
	initial_ammo = 0

/obj/item/ammo_magazine/s44/rubber
	name = "speedloader (.44 rubber)"
	icon_state = "R44"
	ammo_type = /obj/item/ammo_casing/a44/rubber

/obj/item/ammo_magazine/s44/rifle
	name = "speedloader (.44 rifle)"
	icon_state = "RI44"
	ammo_type = /obj/item/ammo_casing/a44/rifle

///////// 7.62mm /////////

/obj/item/ammo_magazine/m762
	name = "magazine (7.62mm)"
	icon_state = "m762-small"
	mag_type = MAGAZINE
	caliber = "7.62mm"
	matter = list(MAT_STEEL = 2000)
	ammo_type = /obj/item/ammo_casing/a762
	max_ammo = 10
	multiple_sprites = 1

/obj/item/ammo_magazine/m762/empty
	initial_ammo = 0

/obj/item/ammo_magazine/m762/ap
	name = "magazine (7.62mm armor-piercing)"
	ammo_type = /obj/item/ammo_casing/a762/ap

// Extended
/obj/item/ammo_magazine/m762/ext
	name = "extended magazine (7.62mm)"
	icon_state = "m762"
	matter = list(MAT_STEEL = 4000)
	max_ammo = 20

/obj/item/ammo_magazine/m762/ext/empty
	initial_ammo = 0

/obj/item/ammo_magazine/m762/ext/ap
	name = "magazine (7.62mm armor-piercing)"
	ammo_type = /obj/item/ammo_casing/a762/ap

// Enbloc
/obj/item/ammo_magazine/m762enbloc
	name = "enbloc (7.62mm)"
	icon_state = "enbloc"
	mag_type = MAGAZINE
	caliber = "7.62mm"
	matter = list(MAT_STEEL = 1600)
	ammo_type = /obj/item/ammo_casing/a762
	max_ammo = 8
	multiple_sprites = 1

/obj/item/ammo_magazine/m762enbloc/ap
	name = "garand clip (7.62mm armor-piercing)"
	ammo_type = /obj/item/ammo_casing/a762/ap

/obj/item/ammo_magazine/m762enbloc/empty
	initial_ammo = 0

// Stripper Clip
/obj/item/ammo_magazine/clip/c762
	name = "ammo clip (7.62mm)"
	icon_state = "clip_rifle"
	caliber = "7.62mm"
	ammo_type = /obj/item/ammo_casing/a762
	matter = list(MAT_STEEL = 1000) // metal costs are very roughly based around one 7.62 casing = 200 metal
	max_ammo = 5
	multiple_sprites = 1

/obj/item/ammo_magazine/clip/c762/ap
	name = "rifle clip (7.62mm armor-piercing)"
	ammo_type = /obj/item/ammo_casing/a762/ap

/obj/item/ammo_magazine/clip/c762/practice
	name = "rifle clip (7.62mm practice)"
	ammo_type = /obj/item/ammo_casing/a762/practice

/obj/item/ammo_magazine/clip/c762/hunter
	name = "rifle clip (7.62mm hunting)"
	ammo_type = /obj/item/ammo_casing/a762/hunter

// SVD
/obj/item/ammo_magazine/m762svd
	name = "\improper SVD magazine (7.62mm)"
	icon_state = "SVD"
	mag_type = MAGAZINE
	caliber = "7.62mm"
	matter = list(MAT_STEEL = 2000)
	ammo_type = /obj/item/ammo_casing/a762
	max_ammo = 10
	multiple_sprites = 1

/obj/item/ammo_magazine/m762svd/empty
	initial_ammo = 0

/obj/item/ammo_magazine/m762svd/ap
	name = "\improper SVD magazine (7.62mm armor-piercing)"
	ammo_type = /obj/item/ammo_casing/a762/ap

///////// 12g /////////

/obj/item/ammo_magazine/m12gdrum
	name = "magazine (12 gauge)"
	icon_state = "ashot-mag"
	mag_type = MAGAZINE
	caliber = "12g"
	matter = list(MAT_STEEL = 13000)
	ammo_type = /obj/item/ammo_casing/a12g
	max_ammo = 24
	multiple_sprites = 1

/obj/item/ammo_magazine/m12gdrum/empty
	initial_ammo = 0

/obj/item/ammo_magazine/m12gdrum/beanbag
	name = "magazine (12 gauge beanbag)"
	ammo_type = /obj/item/ammo_casing/a12g/beanbag

/obj/item/ammo_magazine/m12gdrum/pellet
	name = "magazine (12 gauge pellet)"
	ammo_type = /obj/item/ammo_casing/a12g/pellet

/obj/item/ammo_magazine/m12gdrum/flash
	name = "magazine (12 gauge flash)"
	ammo_type = /obj/item/ammo_casing/a12g/flash

// Clip
/obj/item/ammo_magazine/clip/c12g
	name = "ammo clip (12g slug)"
	icon_state = "12gclipslug"
	desc = "A metal clip for holding and quickly loading two shotgun shells."
	caliber = "12g"
	ammo_type = /obj/item/ammo_casing/a12g
	matter = list(MAT_STEEL = 1070)
	max_ammo = 2
	multiple_sprites = 1

/obj/item/ammo_magazine/clip/c12g/pellet
	name = "ammo clip (12g buckshot)"
	icon_state = "12gclipshell"
	ammo_type = /obj/item/ammo_casing/a12g/pellet
	matter = list(MAT_STEEL = 1070)

/obj/item/ammo_magazine/clip/c12g/beanbag
	name = "ammo clip (12g beanbag)"
	icon_state = "12gclipbean"
	ammo_type = /obj/item/ammo_casing/a12g/beanbag
	matter = list(MAT_STEEL = 710)

///////// .75 Gyrojet /////////

/obj/item/ammo_magazine/m75
	name = "magazine (.75 Gyrojet)"
	icon_state = "75"
	mag_type = MAGAZINE
	caliber = ".75"
	ammo_type = /obj/item/ammo_casing/a75
	multiple_sprites = 1
	max_ammo = 4

/obj/item/ammo_magazine/m75/empty
	initial_ammo = 0
