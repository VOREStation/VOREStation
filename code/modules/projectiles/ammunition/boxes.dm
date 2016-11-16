///////// .357 /////////

/obj/item/ammo_magazine/a357
	name = "speedloader (.357)"
	desc = "A speedloader for .357 revolvers."
	icon_state = "38"
	caliber = "357"
	ammo_type = /obj/item/ammo_casing/a357
	matter = list(DEFAULT_WALL_MATERIAL = 1260)
	max_ammo = 6
	multiple_sprites = 1

///////// .38 /////////

/obj/item/ammo_magazine/c38
	name = "speedloader (.38)"
	desc = "A speedloader for .38 revolvers."
	icon_state = "38"
	caliber = "38"
	matter = list(DEFAULT_WALL_MATERIAL = 360)
	ammo_type = /obj/item/ammo_casing/c38
	max_ammo = 6
	multiple_sprites = 1

/obj/item/ammo_magazine/c38/rubber
	name = "speedloader (.38 rubber)"
	ammo_type = /obj/item/ammo_casing/c38r

///////// .45 /////////

/obj/item/ammo_magazine/c45m
	name = "pistol magazine (.45)"
	icon_state = "45"
	mag_type = MAGAZINE
	ammo_type = /obj/item/ammo_casing/c45
	matter = list(DEFAULT_WALL_MATERIAL = 525) //metal costs are very roughly based around 1 .45 casing = 75 metal
	caliber = ".45"
	max_ammo = 7
	multiple_sprites = 1

/obj/item/ammo_magazine/c45m/empty
	initial_ammo = 0

/obj/item/ammo_magazine/c45m/rubber
	name = "magazine (.45 rubber)"
	ammo_type = /obj/item/ammo_casing/c45r

/obj/item/ammo_magazine/c45m/practice
	name = "magazine (.45 practice)"
	ammo_type = /obj/item/ammo_casing/c45p

/obj/item/ammo_magazine/c45m/flash
	name = "magazine (.45 flash)"
	ammo_type = /obj/item/ammo_casing/c45f

/obj/item/ammo_magazine/c45m/ap
	name = "magazine (.45 AP)"
	ammo_type = /obj/item/ammo_casing/c45ap

/obj/item/ammo_magazine/c45uzi
	name = "stick magazine (.45)"
	icon_state = "uzi45"
	mag_type = MAGAZINE
	ammo_type = /obj/item/ammo_casing/c45
	matter = list(DEFAULT_WALL_MATERIAL = 1200)
	caliber = ".45"
	max_ammo = 16
	multiple_sprites = 1

/obj/item/ammo_magazine/c45uzi/empty
	initial_ammo = 0

/obj/item/ammo_magazine/tommymag
	name = "tommygun magazine (.45)"
	icon_state = "tommy-mag"
	mag_type = MAGAZINE
	ammo_type = /obj/item/ammo_casing/c45
	matter = list(DEFAULT_WALL_MATERIAL = 1500)
	caliber = ".45"
	max_ammo = 20

/obj/item/ammo_magazine/tommymag/ap
	name = "tommygun magazine (.45 AP)"
	ammo_type = /obj/item/ammo_casing/c45ap

/obj/item/ammo_magazine/tommymag/empty
	initial_ammo = 0

/obj/item/ammo_magazine/tommydrum
	name = "tommygun drum magazine (.45)"
	icon_state = "tommy-drum"
	w_class = ITEMSIZE_NORMAL // Bulky ammo doesn't fit in your pockets!
	mag_type = MAGAZINE
	ammo_type = /obj/item/ammo_casing/c45
	matter = list(DEFAULT_WALL_MATERIAL = 3750)
	caliber = ".45"
	max_ammo = 50

/obj/item/ammo_magazine/tommydrum/ap
	name = "tommygun drum magazine (.45 AP)"
	ammo_type = /obj/item/ammo_casing/c45ap

/obj/item/ammo_magazine/tommydrum/empty
	initial_ammo = 0

/obj/item/ammo_magazine/clip/c45
	name = "ammo clip (.45)"
	icon_state = "clip_pistol"
	desc = "A stripper clip for reloading .45 rounds into magazines."
	caliber = ".45"
	ammo_type = /obj/item/ammo_casing/c45
	matter = list(DEFAULT_WALL_MATERIAL = 675) // metal costs very roughly based around one .45 casing = 75 metal
	max_ammo = 9
	multiple_sprites = 1

/obj/item/ammo_magazine/clip/c45/rubber
	name = "ammo clip (.45 rubber)"
	ammo_type = /obj/item/ammo_casing/c45r

/obj/item/ammo_magazine/clip/c45/practice
	name = "ammo clip (.45 practice)"
	ammo_type = /obj/item/ammo_casing/c45p

/obj/item/ammo_magazine/clip/c45/flash
	name = "ammo clip (.45 flash)"
	ammo_type = /obj/item/ammo_casing/c45f

///////// 9mm /////////

/obj/item/ammo_magazine/mc9mm
	name = "magazine (9mm)"
	icon_state = "9x19p"
	origin_tech = list(TECH_COMBAT = 2)
	mag_type = MAGAZINE
	matter = list(DEFAULT_WALL_MATERIAL = 480)
	caliber = "9mm"
	ammo_type = /obj/item/ammo_casing/c9mm
	max_ammo = 8
	multiple_sprites = 1

/obj/item/ammo_magazine/mc9mm/empty
	initial_ammo = 0

/obj/item/ammo_magazine/mc9mm/flash
	ammo_type = /obj/item/ammo_casing/c9mmf

/obj/item/ammo_magazine/mc9mm/rubber
	name = "magazine (9mm rubber)"
	ammo_type = /obj/item/ammo_casing/c9mmr

/obj/item/ammo_magazine/mc9mm/practice
	name = "magazine (9mm practice)"
	ammo_type = /obj/item/ammo_casing/c9mmp

/obj/item/ammo_magazine/mc9mmt
	name = "top mounted magazine (9mm)"
	icon_state = "9mmt"
	mag_type = MAGAZINE
	ammo_type = /obj/item/ammo_casing/c9mm
	matter = list(DEFAULT_WALL_MATERIAL = 1200)
	caliber = "9mm"
	max_ammo = 20
	multiple_sprites = 1

/obj/item/ammo_magazine/mc9mmt/empty
	initial_ammo = 0

/obj/item/ammo_magazine/mc9mmt/rubber
	name = "top mounted magazine (9mm rubber)"
	ammo_type = /obj/item/ammo_casing/c9mmr

/obj/item/ammo_magazine/mc9mmt/flash
	name = "top mounted magazine (9mm flash)"
	ammo_type = /obj/item/ammo_casing/c9mmf

/obj/item/ammo_magazine/mc9mmt/practice
	name = "top mounted magazine (9mm practice)"
	ammo_type = /obj/item/ammo_casing/c9mmp

/obj/item/ammo_magazine/p90
	name = "high capacity top mounted magazine (9mm armor-piercing)"
	icon_state = "p90"
	mag_type = MAGAZINE
	ammo_type = /obj/item/ammo_casing/c9mm/ap
	matter = list(DEFAULT_WALL_MATERIAL = 3000)
	caliber = "9mm"
	max_ammo = 50
	multiple_sprites = 1

/obj/item/ammo_magazine/p90/empty
	initial_ammo = 0

/obj/item/ammo_magazine/clip/c9mm
	name = "ammo clip (9mm)"
	icon_state = "clip_pistol"
	desc = "A stripper clip for reloading 9mm rounds into magazines."
	caliber = "9mm"
	ammo_type = /obj/item/ammo_casing/c9mm
	matter = list(DEFAULT_WALL_MATERIAL = 540) // metal costs are very roughly based around one 9mm casing = 60 metal
	max_ammo = 9
	multiple_sprites = 1

/obj/item/ammo_magazine/clip/c9mm/rubber
	name = "ammo clip (.45 rubber)"
	ammo_type = /obj/item/ammo_casing/c9mmr

/obj/item/ammo_magazine/clip/c9mm/practice
	name = "ammo clip (.45 practice)"
	ammo_type = /obj/item/ammo_casing/c9mmp

/obj/item/ammo_magazine/clip/c9mm/flash
	name = "ammo clip (.45 flash)"
	ammo_type = /obj/item/ammo_casing/c9mmf

/obj/item/ammo_magazine/c9mm // Made by RnD for Prototype SMG and should probably be removed because why does it require DIAMONDS to make bullets?
	name = "ammunition Box (9mm)"
	icon_state = "9mm"
	origin_tech = list(TECH_COMBAT = 2)
	matter = list(DEFAULT_WALL_MATERIAL = 1800)
	caliber = "9mm"
	ammo_type = /obj/item/ammo_casing/c9mm
	max_ammo = 30

/obj/item/ammo_magazine/c9mm/empty
	initial_ammo = 0

///////// 5mm /////////
/*
/obj/item/ammo_magazine/c5mm
	name = "magazine (5mm)"
	icon_state = "fiveseven"
	mag_type = MAGAZINE
	ammo_type = /obj/item/ammo_casing/c5mm
	matter = list(DEFAULT_WALL_MATERIAL = 1200)
	caliber = "5mm"
	max_ammo = 20
	//multiple_sprites = 1

/obj/item/ammo_magazine/clip/c5mm
	name = "ammo clip (5mm)"
	icon_state = "clip_pistol"
	desc = "A stripper clip for reloading 5mm rounds into magazines."
	caliber = "5mm"
	ammo_type = /obj/item/ammo_casing/c5mm
	matter = list(DEFAULT_WALL_MATERIAL = 540) // metal costs are very roughly based around one 5mm casing = 60 metal
	max_ammo = 9
	multiple_sprites = 1
*/
///////// 10mm /////////

/obj/item/ammo_magazine/a10mm
	name = "magazine (10mm)"
	icon_state = "10mm"
	origin_tech = list(TECH_COMBAT = 2)
	mag_type = MAGAZINE
	caliber = "10mm"
	matter = list(DEFAULT_WALL_MATERIAL = 1500)
	ammo_type = /obj/item/ammo_casing/a10mm
	max_ammo = 20
	multiple_sprites = 1

/obj/item/ammo_magazine/a10mm/empty
	initial_ammo = 0

/obj/item/ammo_magazine/clip/a10mm
	name = "ammo clip (10mm)"
	icon_state = "clip_pistol"
	desc = "A stripper clip for reloading 5mm rounds into magazines."
	caliber = "10mm"
	ammo_type = /obj/item/ammo_casing/a10mm
	matter = list(DEFAULT_WALL_MATERIAL = 675) // metal costs are very roughly based around one 10mm casing = 75 metal
	max_ammo = 9
	multiple_sprites = 1

///////// 5.56mm /////////

/obj/item/ammo_magazine/a556
	name = "magazine (5.56mm)"
	icon_state = "5.56"
	origin_tech = list(TECH_COMBAT = 2)
	mag_type = MAGAZINE
	caliber = "a556"
	matter = list(DEFAULT_WALL_MATERIAL = 1800)
	ammo_type = /obj/item/ammo_casing/a556
	max_ammo = 10
	multiple_sprites = 1

/obj/item/ammo_magazine/a556/empty
	initial_ammo = 0

/obj/item/ammo_magazine/a556/practice
	name = "magazine (5.56mm practice)"
	ammo_type = /obj/item/ammo_casing/a556p

/obj/item/ammo_magazine/a556/ap
	name = "magazine (5.56mm armor-piercing)"
	ammo_type = /obj/item/ammo_casing/a556/ap

/obj/item/ammo_magazine/a556m
	name = "20rnd magazine (5.56mm)"
	icon_state = "5.56mid"
	origin_tech = list(TECH_COMBAT = 2)
	mag_type = MAGAZINE
	caliber = "a556"
	matter = list(DEFAULT_WALL_MATERIAL = 3600)
	ammo_type = /obj/item/ammo_casing/a556
	max_ammo = 20
	multiple_sprites = 1

/obj/item/ammo_magazine/a556m/empty
	initial_ammo = 0

/obj/item/ammo_magazine/a556m/ap
	name = "20rnd magazine (5.56mm armor-piercing)"
	ammo_type = /obj/item/ammo_casing/a556/ap

/obj/item/ammo_magazine/a556m/practice
	name = "20rnd magazine (5.56mm practice)"
	ammo_type = /obj/item/ammo_casing/a556p

/obj/item/ammo_magazine/clip/a556
	name = "ammo clip (5.56mm)"
	icon_state = "clip_rifle"
	caliber = "a556"
	ammo_type = /obj/item/ammo_casing/a556
	matter = list(DEFAULT_WALL_MATERIAL = 450) // metal costs are very roughly based around one 10mm casing = 180 metal
	max_ammo = 5
	multiple_sprites = 1

/obj/item/ammo_magazine/clip/a556/ap
	name = "rifle clip (5.56mm armor-piercing)"
	ammo_type = /obj/item/ammo_casing/a556/ap

/obj/item/ammo_magazine/clip/a556/practice
	name = "rifle clip (5.56mm practice)"
	ammo_type = /obj/item/ammo_casing/a556

///////// .50 AE /////////

/obj/item/ammo_magazine/a50
	name = "magazine (.50 AE)"
	icon_state = "50ae"
	origin_tech = list(TECH_COMBAT = 2)
	mag_type = MAGAZINE
	caliber = ".50"
	matter = list(DEFAULT_WALL_MATERIAL = 1260)
	ammo_type = /obj/item/ammo_casing/a50
	max_ammo = 7
	multiple_sprites = 1

/obj/item/ammo_magazine/a50/empty
	initial_ammo = 0

/obj/item/ammo_magazine/clip/a50
	name = "ammo clip (.50 AE)"
	icon_state = "clip_pistol"
	desc = "A stripper clip for reloading .50 Action Express rounds into magazines."
	caliber = ".50"
	ammo_type = /obj/item/ammo_casing/a50
	matter = list(DEFAULT_WALL_MATERIAL = 1620) // metal costs are very roughly based around one .50 casing = 180 metal
	max_ammo = 9
	multiple_sprites = 1

///////// 7.62mm /////////

/obj/item/ammo_magazine/a762
	name = "magazine box (7.62mm)"
	icon_state = "a762"
	origin_tech = list(TECH_COMBAT = 2)
	mag_type = MAGAZINE
	caliber = "a762"
	matter = list(DEFAULT_WALL_MATERIAL = 10000)
	ammo_type = /obj/item/ammo_casing/a762
	w_class = ITEMSIZE_NORMAL // This should NOT fit in your pocket!!
	max_ammo = 50
	multiple_sprites = 1

/obj/item/ammo_magazine/a762/ap
	name = "magazine box (7.62mm armor-piercing)"
	ammo_type = /obj/item/ammo_casing/a762/ap

/obj/item/ammo_magazine/a762/empty
	initial_ammo = 0

/obj/item/ammo_magazine/c762
	name = "magazine (7.62mm)"
	icon_state = "c762"
	mag_type = MAGAZINE
	caliber = "a762"
	matter = list(DEFAULT_WALL_MATERIAL = 4000)
	ammo_type = /obj/item/ammo_casing/a762
	max_ammo = 20
	multiple_sprites = 1

/obj/item/ammo_magazine/c762/ap
	name = "magazine (7.62mm armor-piercing)"
	ammo_type = /obj/item/ammo_casing/a762/ap

/obj/item/ammo_magazine/c762/empty
	initial_ammo = 0

/obj/item/ammo_magazine/s762 // 's' for small!
	name = "magazine (7.62mm)"
	icon_state = "SVD"
	mag_type = MAGAZINE
	caliber = "a762"
	matter = list(DEFAULT_WALL_MATERIAL = 2000)
	ammo_type = /obj/item/ammo_casing/a762
	max_ammo = 10
	multiple_sprites = 1

/obj/item/ammo_magazine/s762/empty
	initial_ammo = 0

/obj/item/ammo_magazine/s762/ap
	name = "magazine (7.62mm armor-piercing)"
	ammo_type = /obj/item/ammo_casing/a762/ap

/obj/item/ammo_magazine/clip/a762
	name = "ammo clip (7.62mm)"
	icon_state = "clip_rifle"
	caliber = "a762"
	ammo_type = /obj/item/ammo_casing/a762
	matter = list(DEFAULT_WALL_MATERIAL = 1000) // metal costs are very roughly based around one 7.62 casing = 200 metal
	max_ammo = 5
	multiple_sprites = 1

/obj/item/ammo_magazine/clip/a762/ap
	name = "rifle clip (7.62mm armor-piercing)"
	ammo_type = /obj/item/ammo_casing/a762/ap

/obj/item/ammo_magazine/clip/a762/practice
	name = "rifle clip (7.62mm practice)"
	ammo_type = /obj/item/ammo_casing/a762p

///////// 12g /////////

/obj/item/ammo_magazine/g12
	name = "magazine (12 gauge)"
	icon_state = "12g"
	mag_type = MAGAZINE
	caliber = "shotgun"
	matter = list(DEFAULT_WALL_MATERIAL = 2200)
	ammo_type = /obj/item/ammo_casing/shotgun
	max_ammo = 24
	multiple_sprites = 1

/obj/item/ammo_magazine/g12/beanbag
	name = "magazine (12 gauge beanbag)"
	ammo_type = /obj/item/ammo_casing/shotgun/beanbag

/obj/item/ammo_magazine/g12/pellet
	name = "magazine (12 gauge pellet)"
	ammo_type = /obj/item/ammo_casing/shotgun/pellet

/obj/item/ammo_magazine/g12/flash
	name = "magazine (12 gauge flash)"
	ammo_type = /obj/item/ammo_casing/shotgun/flash

/obj/item/ammo_magazine/g12/empty
	initial_ammo = 0

///////// .75 Gyrojet /////////

/obj/item/ammo_magazine/a75
	name = "ammo magazine (.75 Gyrojet)"
	icon_state = "75"
	mag_type = MAGAZINE
	caliber = "75"
	ammo_type = /obj/item/ammo_casing/a75
	multiple_sprites = 1
	max_ammo = 4

/obj/item/ammo_magazine/a75/empty
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