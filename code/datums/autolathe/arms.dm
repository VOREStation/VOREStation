/datum/category_item/autolathe/arms/syringegun_ammo
	name = "syringe gun cartridge"
	path =/obj/item/weapon/syringe_cartridge

////////////////
/*Ammo casings*/
////////////////

/datum/category_item/autolathe/arms/shotgun_blanks
	name = "ammunition (12g, blank)"
	path =/obj/item/ammo_casing/a12g/blank

/datum/category_item/autolathe/arms/shotgun_beanbag
	name = "ammunition (12g, beanbag)"
	path =/obj/item/ammo_casing/a12g/beanbag

/datum/category_item/autolathe/arms/shotgun_flash
	name = "ammunition (12g, flash)"
	path =/obj/item/ammo_casing/a12g/flash

/datum/category_item/autolathe/arms/shotgun
	name = "ammunition (12g, slug)"
	path =/obj/item/ammo_casing/a12g
	hidden = 1

/datum/category_item/autolathe/arms/shotgun_pellet
	name = "ammunition (12g, pellet)"
	path =/obj/item/ammo_casing/a12g/pellet
	hidden = 1

/datum/category_item/autolathe/arms/stunshell
	name = "ammunition (stun cartridge, shotgun)"
	path =/obj/item/ammo_casing/a12g/stunshell
	hidden = 1

//////////////////
/*Ammo magazines*/
//////////////////

/////// 5mm
/*
/datum/category_item/autolathe/arms/pistol_5mm
	name = "pistol magazine (5mm)"
	path =/obj/item/ammo_magazine/c5mm
	category = "Arms and Ammunition"
	hidden = 1
*/

/////// .45
/datum/category_item/autolathe/arms/pistol_45
	name = "pistol magazine (.45)"
	path =/obj/item/ammo_magazine/m45
	hidden = 1

/datum/category_item/autolathe/arms/pistol_45p
	name = "pistol magazine (.45 practice)"
	path =/obj/item/ammo_magazine/m45/practice

/datum/category_item/autolathe/arms/pistol_45r
	name = "pistol magazine (.45 rubber)"
	path =/obj/item/ammo_magazine/m45/rubber

/datum/category_item/autolathe/arms/pistol_45f
	name = "pistol magazine (.45 flash)"
	path =/obj/item/ammo_magazine/m45/flash

/datum/category_item/autolathe/arms/pistol_45uzi
	name = "uzi magazine (.45)"
	path =/obj/item/ammo_magazine/m45uzi
	hidden = 1

/datum/category_item/autolathe/arms/tommymag
	name = "Tommygun magazine (.45)"
	path =/obj/item/ammo_magazine/m45tommy
	hidden = 1

/datum/category_item/autolathe/arms/tommydrum
	name = "Tommygun drum magazine (.45)"
	path =/obj/item/ammo_magazine/m45tommydrum
	hidden = 1

/////// 9mm

/obj/item/ammo_magazine/m9mm/flash
	ammo_type =/obj/item/ammo_casing/a9mmf

/obj/item/ammo_magazine/m9mm/rubber
	name = "magazine (9mm rubber)"
	ammo_type =/obj/item/ammo_casing/a9mmr

/obj/item/ammo_magazine/m9mm/practice
	name = "magazine (9mm practice)"
	ammo_type =/obj/item/ammo_casing/a9mmp

/datum/category_item/autolathe/arms/pistol_9mm
	name = "pistol magazine (9mm)"
	path =/obj/item/ammo_magazine/m9mm
	hidden = 1

/datum/category_item/autolathe/arms/pistol_9mmr
	name = "pistol magazine (9mm rubber)"
	path =/obj/item/ammo_magazine/m9mm/rubber

/datum/category_item/autolathe/arms/pistol_9mmp
	name = "pistol magazine (9mm practice)"
	path =/obj/item/ammo_magazine/m9mm/practice

/datum/category_item/autolathe/arms/pistol_9mmf
	name = "pistol magazine (9mm flash)"
	path =/obj/item/ammo_magazine/m9mm/flash

/datum/category_item/autolathe/arms/smg_9mm
	name = "top-mounted SMG magazine (9mm)"
	path =/obj/item/ammo_magazine/m9mmt
	hidden = 1

/datum/category_item/autolathe/arms/smg_9mmr
	name = "top-mounted SMG magazine (9mm rubber)"
	path =/obj/item/ammo_magazine/m9mmt/rubber

/datum/category_item/autolathe/arms/smg_9mmp
	name = "top-mounted SMG magazine (9mm practice)"
	path =/obj/item/ammo_magazine/m9mmt/practice

/datum/category_item/autolathe/arms/smg_9mmf
	name = "top-mounted SMG magazine (9mm flash)"
	path =/obj/item/ammo_magazine/m9mmt/flash

/////// 10mm
/datum/category_item/autolathe/arms/smg_10mm
	name = "SMG magazine (10mm)"
	path =/obj/item/ammo_magazine/m10mm
	hidden = 1

/datum/category_item/autolathe/arms/pistol_50
	name = "pistol magazine (.50AE)"
	path =/obj/item/ammo_magazine/m50
	hidden = 1

/////// 5.56mm
/datum/category_item/autolathe/arms/rifle_556
	name = "rifle magazine (5.56mm)"
	path =/obj/item/ammo_magazine/m556
	hidden = 1

/datum/category_item/autolathe/arms/rifle_556p
	name = "rifle magazine (5.56mm practice)"
	path =/obj/item/ammo_magazine/m556/practice

/datum/category_item/autolathe/arms/machinegun_556
	name = "machinegun box magazine (5.56)"
	path =/obj/item/ammo_magazine/m556saw
	hidden = 1
/////// 7.62


/datum/category_item/autolathe/arms/rifle_762
	name = "rifle magazine (7.62mm)"
	path =/obj/item/ammo_magazine/m762
	hidden = 1

/datum/category_item/autolathe/arms/shotgun_magazine
	name = "24rnd shotgun magazine (12g)"
	path =/obj/item/ammo_magazine/m12gdrum
	hidden = 1

/*
/datum/category_item/autolathe/arms/rifle_small_762
	name = "rifle magazine (7.62mm)"
	path =/obj/item/ammo_magazine/s762
	hidden = 1
*/

/* Commented out until autolathe stuff is decided/fixed. Will probably remove these entirely. -Spades
// These should always be/empty! The idea is to fill them up manually with ammo clips.

/datum/category_item/autolathe/arms/pistol_5mm
	name = "pistol magazine (5mm)"
	path =/obj/item/ammo_magazine/c5mm/empty
	category = "Arms and Ammunition"
	hidden = 1

/datum/category_item/autolathe/arms/smg_5mm
	name = "top-mounted SMG magazine (5mm)"
	path =/obj/item/ammo_magazine/c5mmt/empty
	category = "Arms and Ammunition"
	hidden = 1

/datum/category_item/autolathe/arms/pistol_45
	name = "pistol magazine (.45)"
	path =/obj/item/ammo_magazine/m45/empty
	category = "Arms and Ammunition"

/datum/category_item/autolathe/arms/pistol_45uzi
	name = "uzi magazine (.45)"
	path =/obj/item/ammo_magazine/m45uzi/empty
	category = "Arms and Ammunition"
	hidden = 1

/datum/category_item/autolathe/arms/tommymag
	name = "Tommygun magazine (.45)"
	path =/obj/item/ammo_magazine/m45tommy/empty
	category = "Arms and Ammunition"
	hidden = 1

/datum/category_item/autolathe/arms/tommydrum
	name = "Tommygun drum magazine (.45)"
	path =/obj/item/ammo_magazine/m45tommydrum/empty
	category = "Arms and Ammunition"
	hidden = 1

/datum/category_item/autolathe/arms/pistol_9mm
	name = "pistol magazine (9mm)"
	path =/obj/item/ammo_magazine/m9mm/empty
	category = "Arms and Ammunition"

/datum/category_item/autolathe/arms/smg_9mm
	name = "top-mounted SMG magazine (9mm)"
	path =/obj/item/ammo_magazine/m9mmt/empty
	category = "Arms and Ammunition"

/datum/category_item/autolathe/arms/smg_10mm
	name = "SMG magazine (10mm)"
	path =/obj/item/ammo_magazine/m10mm/empty
	category = "Arms and Ammunition"
	hidden = 1

/datum/category_item/autolathe/arms/pistol_50
	name = "pistol magazine (.50AE)"
	path =/obj/item/ammo_magazine/m50/empty
	category = "Arms and Ammunition"
	hidden = 1

/datum/category_item/autolathe/arms/rifle_556
	name = "10rnd rifle magazine (5.56mm)"
	path =/obj/item/ammo_magazine/m556saw/empty
	category = "Arms and Ammunition"

/datum/category_item/autolathe/arms/rifle_556m
	name = "20rnd rifle magazine (5.56mm)"
	path =/obj/item/ammo_magazine/m556sawm/empty
	category = "Arms and Ammunition"
	hidden = 1

/datum/category_item/autolathe/arms/rifle_SVD
	name = "10rnd rifle magazine (7.62mm)"
	path =/obj/item/ammo_magazine/SVD/empty
	category = "Arms and Ammunition"
	hidden = 1

/datum/category_item/autolathe/arms/rifle_762
	name = "20rnd rifle magazine (7.62mm)"
	path =/obj/item/ammo_magazine/m762/empty
	category = "Arms and Ammunition"
	hidden = 1

/datum/category_item/autolathe/arms/machinegun_762
	name = "machinegun box magazine (7.62)"
	path =/obj/item/ammo_magazine/a762/empty
	category = "Arms and Ammunition"
	hidden = 1

/datum/category_item/autolathe/arms/shotgun_magazine
	name = "24rnd shotgun magazine (12g)"
	path =/obj/item/ammo_magazine/m12gdrum/empty
	category = "Arms and Ammunition"
	hidden = 1*/

///////////////////////////////
/*Ammo clips and Speedloaders*/
///////////////////////////////

/datum/category_item/autolathe/arms/speedloader_357
	name = "speedloader (.357)"
	path =/obj/item/ammo_magazine/s357
	hidden = 1

/datum/category_item/autolathe/arms/speedloader_38
	name = "speedloader (.38)"
	path =/obj/item/ammo_magazine/s38
	hidden = 1

/datum/category_item/autolathe/arms/speedloader_38r
	name = "speedloader (.38 rubber)"
	path =/obj/item/ammo_magazine/s38/rubber

// Commented out until metal exploits with autolathe is fixed.
/*/datum/category_item/autolathe/arms/pistol_clip_45
	name = "ammo clip (.45)"
	path =/obj/item/ammo_magazine/clip/c45
	category = "Arms and Ammunition"
	hidden = 1

/datum/category_item/autolathe/arms/pistol_clip_45r
	name = "ammo clip (.45 rubber)"
	path =/obj/item/ammo_magazine/clip/c45/rubber
	category = "Arms and Ammunition"

/datum/category_item/autolathe/arms/pistol_clip_45f
	name = "ammo clip (.45 flash)"
	path =/obj/item/ammo_magazine/clip/c45/flash
	category = "Arms and Ammunition"

/datum/category_item/autolathe/arms/pistol_clip_45p
	name = "ammo clip (.45 practice)"
	path =/obj/item/ammo_magazine/clip/c45/practice
	category = "Arms and Ammunition"

/datum/category_item/autolathe/arms/pistol_clip_9mm
	name = "ammo clip (9mm)"
	path =/obj/item/ammo_magazine/clip/c9mm
	category = "Arms and Ammunition"
	hidden = 1

/datum/category_item/autolathe/arms/pistol_clip_9mmr
	name = "ammo clip (9mm rubber)"
	path =/obj/item/ammo_magazine/clip/c9mm/rubber
	category = "Arms and Ammunition"

/datum/category_item/autolathe/arms/pistol_clip_9mmp
	name = "ammo clip (9mm practice)"
	path =/obj/item/ammo_magazine/clip/c9mm/practice
	category = "Arms and Ammunition"

/datum/category_item/autolathe/arms/pistol_clip_9mmf
	name = "ammo clip (9mm flash)"
	path =/obj/item/ammo_magazine/clip/c9mm/flash
	category = "Arms and Ammunition"

/datum/category_item/autolathe/arms/pistol_clip_5mm
	name = "ammo clip (5mm)"
	path =/obj/item/ammo_magazine/clip/c5mm
	category = "Arms and Ammunition"
	hidden = 1

/datum/category_item/autolathe/arms/pistol_clip_10mm
	name = "ammo clip (10mm)"
	path =/obj/item/ammo_magazine/clip/c10mm
	category = "Arms and Ammunition"
	hidden = 1

/datum/category_item/autolathe/arms/pistol_clip_50
	name = "ammo clip (.50AE)"
	path =/obj/item/ammo_magazine/clip/c50
	category = "Arms and Ammunition"
	hidden = 1
*/
/datum/category_item/autolathe/arms/rifle_clip_556
	name = "ammo clip (5.56mm)"
	path =/obj/item/ammo_magazine/clip/c556
	category = "Arms and Ammunition"
	hidden = 1

/datum/category_item/autolathe/arms/rifle_clip_556_practice
	name = "ammo clip (5.56mm practice)"
	path =/obj/item/ammo_magazine/clip/c556/practice
	category = "Arms and Ammunition"

/datum/category_item/autolathe/arms/rifle_clip_762
	name = "ammo clip (7.62mm)"
	path =/obj/item/ammo_magazine/clip/c762
	hidden = 1

/datum/category_item/autolathe/arms/rifle_clip_762_practice
	name = "ammo clip (7.62mm practice)"
	path =/obj/item/ammo_magazine/clip/c762/practice

/datum/category_item/autolathe/arms/knuckledusters
	name = "knuckle dusters"
	path =/obj/item/weapon/material/knuckledusters
	hidden = 1

/datum/category_item/autolathe/arms/tacknife
	name = "tactical knife"
	path =/obj/item/weapon/material/hatchet/tacknife
	hidden = 1

/datum/category_item/autolathe/arms/flamethrower
	name = "flamethrower"
	path =/obj/item/weapon/flamethrower/full
	hidden = 1
