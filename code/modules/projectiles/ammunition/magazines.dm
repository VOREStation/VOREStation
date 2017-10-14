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
#    This comment is copied in rounds.dm as well.
#
#    Also, if a magazine is only meant for a specific gun, include the name
#    of the specific gun in the path. Example: m45uzi is only for the Uzi.
*/
/************************************************************************/



///////// .357 /////////

/obj/item/ammo_magazine/s357
	name = "speedloader (.357)"
	desc = "A speedloader for .357 revolvers."
	icon_state = "38"
	caliber = ".357"
	ammo_type = /obj/item/ammo_casing/a357
	matter = list(DEFAULT_WALL_MATERIAL = 1260)
	max_ammo = 6
	multiple_sprites = 1

///////// .38 /////////

/obj/item/ammo_magazine/s38
	name = "speedloader (.38)"
	desc = "A speedloader for .38 revolvers."
	icon_state = "38"
	caliber = ".38"
	matter = list(DEFAULT_WALL_MATERIAL = 360)
	ammo_type = /obj/item/ammo_casing/a38
	max_ammo = 6
	multiple_sprites = 1

/obj/item/ammo_magazine/s38/rubber
	name = "speedloader (.38 rubber)"
	ammo_type = /obj/item/ammo_casing/a38r

/obj/item/ammo_magazine/s38/emp
	name = "speedloader (.38 haywire)"
	ammo_type = /obj/item/ammo_casing/a38/emp

///////// .45 /////////

/obj/item/ammo_magazine/m45
	name = "pistol magazine (.45)"
	icon_state = "45"
	mag_type = MAGAZINE
	ammo_type = /obj/item/ammo_casing/a45
	matter = list(DEFAULT_WALL_MATERIAL = 525) //metal costs are very roughly based around 1 .45 casing = 75 metal
	caliber = ".45"
	max_ammo = 7
	multiple_sprites = 1

/obj/item/ammo_magazine/m45/empty
	initial_ammo = 0

/obj/item/ammo_magazine/m45/rubber
	name = "magazine (.45 rubber)"
	ammo_type = /obj/item/ammo_casing/a45r

/obj/item/ammo_magazine/m45/practice
	name = "magazine (.45 practice)"
	ammo_type = /obj/item/ammo_casing/a45p

/obj/item/ammo_magazine/m45/flash
	name = "magazine (.45 flash)"
	ammo_type = /obj/item/ammo_casing/a45f

/obj/item/ammo_magazine/m45/ap
	name = "magazine (.45 AP)"
	ammo_type = /obj/item/ammo_casing/a45ap

/obj/item/ammo_magazine/box/emp/b45
	name = "ammunition box (.45 haywire)"
	ammo_type = /obj/item/ammo_casing/a45/emp

/obj/item/ammo_magazine/m45uzi
	name = "stick magazine (.45)"
	icon_state = "uzi45"
	mag_type = MAGAZINE
	ammo_type = /obj/item/ammo_casing/a45
	matter = list(DEFAULT_WALL_MATERIAL = 1200)
	caliber = ".45"
	max_ammo = 16
	multiple_sprites = 1

/obj/item/ammo_magazine/m45uzi/empty
	initial_ammo = 0

/obj/item/ammo_magazine/m45tommy
	name = "tommygun magazine (.45)"
	icon_state = "tommy-mag"
	mag_type = MAGAZINE
	ammo_type = /obj/item/ammo_casing/a45
	matter = list(DEFAULT_WALL_MATERIAL = 1500)
	caliber = ".45"
	max_ammo = 20

/obj/item/ammo_magazine/m45tommy/ap
	name = "tommygun magazine (.45 AP)"
	ammo_type = /obj/item/ammo_casing/a45ap

/obj/item/ammo_magazine/m45tommy/empty
	initial_ammo = 0

/obj/item/ammo_magazine/m45tommydrum
	name = "tommygun drum magazine (.45)"
	icon_state = "tommy-drum"
	w_class = ITEMSIZE_NORMAL // Bulky ammo doesn't fit in your pockets!
	mag_type = MAGAZINE
	ammo_type = /obj/item/ammo_casing/a45
	matter = list(DEFAULT_WALL_MATERIAL = 3750)
	caliber = ".45"
	max_ammo = 50

/obj/item/ammo_magazine/m45tommydrum/ap
	name = "tommygun drum magazine (.45 AP)"
	ammo_type = /obj/item/ammo_casing/a45ap

/obj/item/ammo_magazine/m45tommydrum/empty
	initial_ammo = 0

/obj/item/ammo_magazine/clip/c45
	name = "ammo clip (.45)"
	icon_state = "clip_pistol"
	desc = "A stripper clip for reloading .45 rounds into magazines."
	caliber = ".45"
	ammo_type = /obj/item/ammo_casing/a45
	matter = list(DEFAULT_WALL_MATERIAL = 675) // metal costs very roughly based around one .45 casing = 75 metal
	max_ammo = 9
	multiple_sprites = 1

/obj/item/ammo_magazine/clip/c45/rubber
	name = "ammo clip (.45 rubber)"
	ammo_type = /obj/item/ammo_casing/a45r

/obj/item/ammo_magazine/clip/c45/practice
	name = "ammo clip (.45 practice)"
	ammo_type = /obj/item/ammo_casing/a45p

/obj/item/ammo_magazine/clip/c45/flash
	name = "ammo clip (.45 flash)"
	ammo_type = /obj/item/ammo_casing/a45f

///////// 9mm /////////

/obj/item/ammo_magazine/m9mm
	name = "magazine (9mm)"
	icon_state = "9x19p"
	origin_tech = list(TECH_COMBAT = 2)
	mag_type = MAGAZINE
	matter = list(DEFAULT_WALL_MATERIAL = 480)
	caliber = "9mm"
	ammo_type = /obj/item/ammo_casing/a9mm
	max_ammo = 8
	multiple_sprites = 1

/obj/item/ammo_magazine/m9mm/empty
	initial_ammo = 0

/obj/item/ammo_magazine/m9mm/flash
	ammo_type = /obj/item/ammo_casing/a9mmf

/obj/item/ammo_magazine/m9mm/rubber
	name = "magazine (9mm rubber)"
	ammo_type = /obj/item/ammo_casing/a9mmr

/obj/item/ammo_magazine/m9mm/practice
	name = "magazine (9mm practice)"
	ammo_type = /obj/item/ammo_casing/a9mmp

/obj/item/ammo_magazine/m9mmt
	name = "top mounted magazine (9mm)"
	icon_state = "9mmt"
	mag_type = MAGAZINE
	ammo_type = /obj/item/ammo_casing/a9mm
	matter = list(DEFAULT_WALL_MATERIAL = 1200)
	caliber = "9mm"
	max_ammo = 20
	multiple_sprites = 1

/obj/item/ammo_magazine/m9mmt/empty
	initial_ammo = 0

/obj/item/ammo_magazine/m9mmt/rubber
	name = "top mounted magazine (9mm rubber)"
	ammo_type = /obj/item/ammo_casing/a9mmr

/obj/item/ammo_magazine/m9mmt/flash
	name = "top mounted magazine (9mm flash)"
	ammo_type = /obj/item/ammo_casing/a9mmf

/obj/item/ammo_magazine/m9mmt/practice
	name = "top mounted magazine (9mm practice)"
	ammo_type = /obj/item/ammo_casing/a9mmp

/obj/item/ammo_magazine/m9mmp90
	name = "high capacity top mounted magazine (9mm armor-piercing)"
	icon_state = "p90"
	mag_type = MAGAZINE
	ammo_type = /obj/item/ammo_casing/a9mm/ap
	matter = list(DEFAULT_WALL_MATERIAL = 3000)
	caliber = "9mm"
	max_ammo = 50
	multiple_sprites = 1

/obj/item/ammo_magazine/m9mmp90/empty
	initial_ammo = 0

/obj/item/ammo_magazine/clip/c9mm
	name = "ammo clip (9mm)"
	icon_state = "clip_pistol"
	desc = "A stripper clip for reloading 9mm rounds into magazines."
	caliber = "9mm"
	ammo_type = /obj/item/ammo_casing/a9mm
	matter = list(DEFAULT_WALL_MATERIAL = 540) // metal costs are very roughly based around one 9mm casing = 60 metal
	max_ammo = 9
	multiple_sprites = 1

/obj/item/ammo_magazine/clip/c9mm/rubber
	name = "ammo clip (.45 rubber)"
	ammo_type = /obj/item/ammo_casing/a9mmr

/obj/item/ammo_magazine/clip/c9mm/practice
	name = "ammo clip (.45 practice)"
	ammo_type = /obj/item/ammo_casing/a9mmp

/obj/item/ammo_magazine/clip/c9mm/flash
	name = "ammo clip (.45 flash)"
	ammo_type = /obj/item/ammo_casing/a9mmf

/obj/item/ammo_magazine/box/c9mm // Made by RnD for Prototype SMG and should probably be removed because why does it require DIAMONDS to make bullets?
	name = "ammunition Box (9mm)"
	icon_state = "9mm"
	origin_tech = list(TECH_COMBAT = 2)
	matter = list(DEFAULT_WALL_MATERIAL = 1800)
	caliber = "9mm"
	ammo_type = /obj/item/ammo_casing/a9mm
	max_ammo = 30

/obj/item/ammo_magazine/box/c9mm/empty
	initial_ammo = 0

///////// 10mm /////////

/obj/item/ammo_magazine/m10mm
	name = "magazine (10mm)"
	icon_state = "10mm"
	origin_tech = list(TECH_COMBAT = 2)
	mag_type = MAGAZINE
	caliber = "10mm"
	matter = list(DEFAULT_WALL_MATERIAL = 1500)
	ammo_type = /obj/item/ammo_casing/a10mm
	max_ammo = 20
	multiple_sprites = 1

/obj/item/ammo_magazine/m10mm/empty
	initial_ammo = 0

/obj/item/ammo_magazine/clip/c10mm
	name = "ammo clip (10mm)"
	icon_state = "clip_pistol"
	desc = "A stripper clip for reloading 5mm rounds into magazines."
	caliber = "10mm"
	ammo_type = /obj/item/ammo_casing/a10mm
	matter = list(DEFAULT_WALL_MATERIAL = 675) // metal costs are very roughly based around one 10mm casing = 75 metal
	max_ammo = 9
	multiple_sprites = 1

/obj/item/ammo_magazine/box/emp/b10
	name = "ammunition box (10mm haywire)"
	ammo_type = /obj/item/ammo_casing/a10mm/emp

///////// 5.45mm /////////

/obj/item/ammo_magazine/m545
	name = "magazine (5.45mm)"
	icon_state = "m545"
	origin_tech = list(TECH_COMBAT = 2)
	mag_type = MAGAZINE
	caliber = "5.45mm"
	matter = list(DEFAULT_WALL_MATERIAL = 1800)
	ammo_type = /obj/item/ammo_casing/a545
	max_ammo = 20
	multiple_sprites = 1

/obj/item/ammo_magazine/m545/ext
	name = "extended magazine (5.45mm)"
	matter = list(DEFAULT_WALL_MATERIAL = 2700)
	max_ammo = 30

/obj/item/ammo_magazine/m545/empty
	initial_ammo = 0

/obj/item/ammo_magazine/m545/ext/empty
	initial_ammo = 0

/obj/item/ammo_magazine/m545/practice
	name = "magazine (5.45mm practice)"
	ammo_type = /obj/item/ammo_casing/a545p

/obj/item/ammo_magazine/m545/practice/ext
	name = "extended magazine (5.45mm practice)"
	max_ammo = 30

/obj/item/ammo_magazine/m545/ap
	name = "magazine (5.45mm armor-piercing)"
	ammo_type = /obj/item/ammo_casing/a545/ap

/obj/item/ammo_magazine/m545/ap/ext
	name = "extended magazine (5.45mm armor-piercing)"
	max_ammo = 30

/obj/item/ammo_magazine/m545/small
	name = "reduced magazine (5.45mm)"
	icon_state = "m545-small"
	matter = list(DEFAULT_WALL_MATERIAL = 900)
	max_ammo = 10

/obj/item/ammo_magazine/m545/small/empty
	initial_ammo = 0

/obj/item/ammo_magazine/m545/small/practice
	name = "magazine (5.45mm practice)"
	ammo_type = /obj/item/ammo_casing/a545p

/obj/item/ammo_magazine/m545/small/ap
	name = "magazine (5.45mm armor-piercing)"
	ammo_type = /obj/item/ammo_casing/a545/ap

/obj/item/ammo_magazine/clip/c545
	name = "ammo clip (5.45mm)"
	icon_state = "clip_rifle"
	caliber = "5.45mm"
	ammo_type = /obj/item/ammo_casing/a545
	matter = list(DEFAULT_WALL_MATERIAL = 450) // metal costs are very roughly based around one 10mm casing = 180 metal
	max_ammo = 5
	multiple_sprites = 1

/obj/item/ammo_magazine/clip/c545/ap
	name = "rifle clip (5.45mm armor-piercing)"
	ammo_type = /obj/item/ammo_casing/a545/ap

/obj/item/ammo_magazine/clip/c545/practice
	name = "rifle clip (5.45mm practice)"
	ammo_type = /obj/item/ammo_casing/a545

/obj/item/ammo_magazine/m545saw
	name = "magazine box (5.45mm)"
	icon_state = "a545"
	origin_tech = list(TECH_COMBAT = 2)
	mag_type = MAGAZINE
	caliber = "5.45mm"
	matter = list(DEFAULT_WALL_MATERIAL = 10000)
	ammo_type = /obj/item/ammo_casing/a545
	w_class = ITEMSIZE_NORMAL // This should NOT fit in your pocket!!
	max_ammo = 50
	multiple_sprites = 1

/obj/item/ammo_magazine/m545saw/ap
	name = "magazine box (5.45mm armor-piercing)"
	ammo_type = /obj/item/ammo_casing/a545/ap

/obj/item/ammo_magazine/m545saw/empty
	initial_ammo = 0

///////// .44 Magnum /////////

/obj/item/ammo_magazine/m44
	name = "magazine (.44)"
	icon_state = "44"
	origin_tech = list(TECH_COMBAT = 2)
	mag_type = MAGAZINE
	caliber = ".44"
	matter = list(DEFAULT_WALL_MATERIAL = 1260)
	ammo_type = /obj/item/ammo_casing/a44
	max_ammo = 7
	multiple_sprites = 1

/obj/item/ammo_magazine/m44/empty
	initial_ammo = 0

/obj/item/ammo_magazine/clip/c44
	name = "ammo clip (.44)"
	icon_state = "clip_pistol"
	desc = "A stripper clip for reloading .44 rounds into magazines."
	caliber = ".44"
	ammo_type = /obj/item/ammo_casing/a44
	matter = list(DEFAULT_WALL_MATERIAL = 1620) // metal costs are very roughly based around one .50 casing = 180 metal
	max_ammo = 9
	multiple_sprites = 1

///////// 7.62mm /////////

/obj/item/ammo_magazine/m762
	name = "magazine (7.62mm)"
	icon_state = "m762-small"
	mag_type = MAGAZINE
	caliber = "7.62mm"
	matter = list(DEFAULT_WALL_MATERIAL = 2000)
	ammo_type = /obj/item/ammo_casing/a762
	max_ammo = 10
	multiple_sprites = 1

/obj/item/ammo_magazine/m762/ap
	name = "magazine (7.62mm armor-piercing)"
	ammo_type = /obj/item/ammo_casing/a762/ap

/obj/item/ammo_magazine/m762/empty
	initial_ammo = 0

/obj/item/ammo_magazine/m762m // Intentionally not a subtype of m762 because it's supposed to be incompatible with the Z8 Bulldog rifle.
	name = "magazine (7.62mm)"
	icon_state = "m762"
	mag_type = MAGAZINE
	caliber = "7.62mm"
	matter = list(DEFAULT_WALL_MATERIAL = 4000)
	ammo_type = /obj/item/ammo_casing/a762
	max_ammo = 20
	multiple_sprites = 1

/obj/item/ammo_magazine/m762m/ap
	name = "magazine (7.62mm armor-piercing)"
	ammo_type = /obj/item/ammo_casing/a762/ap

/obj/item/ammo_magazine/m762m/empty
	initial_ammo = 0

/obj/item/ammo_magazine/m762garand
	name = "garand clip (7.62mm)" // The clip goes into the magazine, hence the name. I'm very sure this is correct.
	icon_state = "gclip"
	mag_type = MAGAZINE
	caliber = "7.62mm"
	matter = list(DEFAULT_WALL_MATERIAL = 1600)
	ammo_type = /obj/item/ammo_casing/a762
	max_ammo = 8
	multiple_sprites = 1

/obj/item/ammo_magazine/m762garand/ap
	name = "garand clip (7.62mm armor-piercing)"
	ammo_type = /obj/item/ammo_casing/a762/ap

/obj/item/ammo_magazine/m762/empty
	initial_ammo = 0

/obj/item/ammo_magazine/clip/c762
	name = "ammo clip (7.62mm)"
	icon_state = "clip_rifle"
	caliber = "7.62mm"
	ammo_type = /obj/item/ammo_casing/a762
	matter = list(DEFAULT_WALL_MATERIAL = 1000) // metal costs are very roughly based around one 7.62 casing = 200 metal
	max_ammo = 5
	multiple_sprites = 1

/obj/item/ammo_magazine/clip/c762/ap
	name = "rifle clip (7.62mm armor-piercing)"
	ammo_type = /obj/item/ammo_casing/a762/ap

/obj/item/ammo_magazine/clip/c762/practice
	name = "rifle clip (7.62mm practice)"
	ammo_type = /obj/item/ammo_casing/a762p

/obj/item/ammo_magazine/m762svd
	name = "\improper SVD magazine (7.62mm)"
	icon_state = "SVD"
	mag_type = MAGAZINE
	caliber = "7.62mm"
	matter = list(DEFAULT_WALL_MATERIAL = 2000)
	ammo_type = /obj/item/ammo_casing/a762
	max_ammo = 10
	multiple_sprites = 1

/obj/item/ammo_magazine/m762svd/ap
	name = "\improper SVD magazine (7.62mm armor-piercing)"
	ammo_type = /obj/item/ammo_casing/a762/ap

/obj/item/ammo_magazine/m762svd/empty
	initial_ammo = 0

///////// 12g /////////

/obj/item/ammo_magazine/m12gdrum
	name = "magazine (12 gauge)"
	icon_state = "12g"
	mag_type = MAGAZINE
	caliber = "12g"
	matter = list(DEFAULT_WALL_MATERIAL = 13000) //did the math. now fixed the exploityness of this thing. Have fun!
	ammo_type = /obj/item/ammo_casing/a12g
	max_ammo = 24
	multiple_sprites = 1

/obj/item/ammo_magazine/m12gdrum/beanbag
	name = "magazine (12 gauge beanbag)"
	ammo_type = /obj/item/ammo_casing/a12g/beanbag

/obj/item/ammo_magazine/m12gdrum/pellet
	name = "magazine (12 gauge pellet)"
	ammo_type = /obj/item/ammo_casing/a12g/pellet

/obj/item/ammo_magazine/m12gdrum/flash
	name = "magazine (12 gauge flash)"
	ammo_type = /obj/item/ammo_casing/a12g/flash

/obj/item/ammo_magazine/m12gdrum/empty
	initial_ammo = 0

/obj/item/ammo_magazine/clip/c12g
	name = "ammo clip (12g slug)"
	icon_state = "12gclipslug" //largely a codersprite, looks good enough. feel free to make a better one.
	desc = "A color-coded metal clip for holding and quickly loading shotgun shells. This one is loaded with slugs."
	caliber = "12g"
	ammo_type = /obj/item/ammo_casing/a12g
	matter = list(DEFAULT_WALL_MATERIAL = 1790) // slugs shells x4 + 350 metal for the clip itself.
	max_ammo = 4
	multiple_sprites = 1

/obj/item/ammo_magazine/clip/c12g/pellet
	name = "ammo clip (12g buckshot)"
	icon_state = "12gclipshell"
	desc = "A color-coded metal clip for holding and quickly loading shotgun shells. This one is loaded with buckshot."
	ammo_type = /obj/item/ammo_casing/a12g/pellet
	matter = list(DEFAULT_WALL_MATERIAL = 1790) // buckshot and slugs cost the same

/obj/item/ammo_magazine/clip/c12g/beanbag
	name = "ammo clip (12g beanbag)"
	icon_state = "12gclipbean"
	desc = "A color-coded metal clip for holding and quickly loading shotgun shells. This one is loaded with beanbags."
	ammo_type = /obj/item/ammo_casing/a12g/beanbag
	matter = list(DEFAULT_WALL_MATERIAL = 1070) //beanbags x4 + 350 metal

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

///////// Misc. /////////

/obj/item/ammo_magazine/caps
	name = "speedloader (caps)"
	icon_state = "T38"
	caliber = "caps"
	color = "#FF0000"
	ammo_type = /obj/item/ammo_casing/cap
	matter = list(DEFAULT_WALL_MATERIAL = 600)
	max_ammo = 7
	multiple_sprites = 1