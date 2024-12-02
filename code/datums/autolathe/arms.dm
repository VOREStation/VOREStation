/datum/category_item/autolathe/arms/syringegun_ammo
	name = "syringe gun cartridge"
	path =/obj/item/syringe_cartridge

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

/datum/category_item/autolathe/arms/flechetteshell
	name = "ammunition (flechette cartridge, shotgun)"
	path =/obj/item/ammo_casing/a12g/flechette
	hidden = 1
	man_rating = 2

//////////////////
/*Ammo magazines*/
//////////////////

/////// 5mm
/*
/datum/category_item/autolathe/arms/pistol_5mm
	name = "pistol magazine (5mm)"
	path =/obj/item/ammo_magazine/c5mm
	category = list("Arms and Ammunition")
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

/datum/category_item/autolathe/arms/pistol_45ap
	name = "pistol magazine (.45 armor piercing)"
	path =/obj/item/ammo_magazine/m45/ap
	hidden = 1
	resources = list(MAT_STEEL = 500, MAT_PLASTEEL = 300)

/datum/category_item/autolathe/arms/pistol_45hp
	name = "pistol magazine (.45 hollowpoint)"
	path =/obj/item/ammo_magazine/m45/hp
	hidden = 1
	resources = list(MAT_STEEL = 500, MAT_PLASTIC = 200)

/datum/category_item/autolathe/arms/pistol_45uzi
	name = "uzi magazine (.45)"
	path =/obj/item/ammo_magazine/m45uzi
	hidden = 1

/datum/category_item/autolathe/arms/tommymag
	name = "Tommy Gun magazine (.45)"
	path =/obj/item/ammo_magazine/m45tommy
	hidden = 1

/datum/category_item/autolathe/arms/tommydrum
	name = "Tommy Gun drum magazine (.45)"
	path =/obj/item/ammo_magazine/m45tommydrum
	hidden = 1

/////// 9mm

// Full size pistol mags.
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

// Small mags for small or old guns.
/datum/category_item/autolathe/arms/pistol_9mm_compact
	name = "compact pistol magazine (9mm)"
	path =/obj/item/ammo_magazine/m9mm/compact
	hidden = 1

/datum/category_item/autolathe/arms/pistol_9mmr_compact
	name = "compact pistol magazine (9mm rubber)"
	path =/obj/item/ammo_magazine/m9mm/compact/rubber
	hidden = 1 // These are all hidden because they are traitor mags and will otherwise just clutter the Autolathe.

/datum/category_item/autolathe/arms/pistol_9mmp_compact
	name = "compact pistol magazine (9mm practice)"
	path =/obj/item/ammo_magazine/m9mm/compact/practice
	hidden = 1

/datum/category_item/autolathe/arms/pistol_9mmf_compact
	name = "compact pistol magazine (9mm flash)"
	path =/obj/item/ammo_magazine/m9mm/compact/flash
	hidden = 1

// SMG mags
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

/datum/category_item/autolathe/arms/smg_9mmap
	name = "top-mounted SMG magazine (9mm armor piercing)"
	path =/obj/item/ammo_magazine/m9mmt/ap
	hidden = 1
	man_rating = 2

/////// 10mm
/datum/category_item/autolathe/arms/smg_10mm
	name = "SMG magazine (10mm)"
	path =/obj/item/ammo_magazine/m10mm
	hidden = 1

/datum/category_item/autolathe/arms/pistol_44
	name = "pistol magazine (.44)"
	path =/obj/item/ammo_magazine/m44
	hidden = 1

/////// 5.45mm
/datum/category_item/autolathe/arms/rifle_545
	name = "rifle magazine (5.45mm)"
	path =/obj/item/ammo_magazine/m545
	hidden = 1

/datum/category_item/autolathe/arms/rifle_545p
	name = "rifle magazine (5.45mm practice)"
	path =/obj/item/ammo_magazine/m545/practice

/*/datum/category_item/autolathe/arms/rifle_545_hunter //VOREStation Edit Start. By request of Ace
	name = "rifle magazine (5.45mm hunting)"
	path =/obj/item/ammo_magazine/m545/hunter*/ //VOREStation Edit End.

/datum/category_item/autolathe/arms/machinegun_545
	name = "machinegun box magazine (5.45)"
	path =/obj/item/ammo_magazine/m545saw
	hidden = 1

/*/datum/category_item/autolathe/arms/machinegun_545_hunter //VOREStation Edit Start. By request of Ace
	name = "machinegun box magazine (5.45 hunting)"
	path =/obj/item/ammo_magazine/m545saw/hunter
	hidden = 1*/ //VOREStation Edit End.

/////// 7.62

/datum/category_item/autolathe/arms/rifle_762
	name = "rifle magazine (7.62mm)"
	path =/obj/item/ammo_magazine/m762
	hidden = 1

/*
/datum/category_item/autolathe/arms/rifle_small_762
	name = "rifle magazine (7.62mm)"
	path =/obj/item/ammo_magazine/s762
	hidden = 1
*/

/////// Shotgun

/datum/category_item/autolathe/arms/shotgun_clip_beanbag
	name = "2-round 12g speedloader (beanbag)"
	path =/obj/item/ammo_magazine/clip/c12g/beanbag

/datum/category_item/autolathe/arms/shotgun_clip_slug
	name = "2-round 12g speedloader (slug)"
	path =/obj/item/ammo_magazine/clip/c12g
	hidden = 1

/datum/category_item/autolathe/arms/shotgun_clip_pellet
	name = "2-round 12g speedloader (buckshot)"
	path =/obj/item/ammo_magazine/clip/c12g/pellet
	hidden = 1

/datum/category_item/autolathe/arms/shotgun_clip_beanbag
	name = "2-round 12g speedloader (beanbag)"
	path =/obj/item/ammo_magazine/clip/c12g/beanbag

/* Commented out until autolathe stuff is decided/fixed. Will probably remove these entirely. -Spades
// These should always be/empty! The idea is to fill them up manually with ammo clips.

/datum/category_item/autolathe/arms/pistol_5mm
	name = "pistol magazine (5mm)"
	path =/obj/item/ammo_magazine/c5mm/empty
	category = list("Arms and Ammunition")
	hidden = 1

/datum/category_item/autolathe/arms/smg_5mm
	name = "top-mounted SMG magazine (5mm)"
	path =/obj/item/ammo_magazine/c5mmt/empty
	category = list("Arms and Ammunition")
	hidden = 1

/datum/category_item/autolathe/arms/pistol_45
	name = "pistol magazine (.45)"
	path =/obj/item/ammo_magazine/m45/empty
	category = list("Arms and Ammunition")

/datum/category_item/autolathe/arms/pistol_45uzi
	name = "uzi magazine (.45)"
	path =/obj/item/ammo_magazine/m45uzi/empty
	category = list("Arms and Ammunition")
	hidden = 1

/datum/category_item/autolathe/arms/tommymag
	name = "Tommy Gun magazine (.45)"
	path =/obj/item/ammo_magazine/m45tommy/empty
	category = list("Arms and Ammunition")
	hidden = 1

/datum/category_item/autolathe/arms/tommydrum
	name = "Tommy Gun drum magazine (.45)"
	path =/obj/item/ammo_magazine/m45tommydrum/empty
	category = list("Arms and Ammunition")
	hidden = 1

/datum/category_item/autolathe/arms/pistol_9mm
	name = "pistol magazine (9mm)"
	path =/obj/item/ammo_magazine/m9mm/empty
	category = list("Arms and Ammunition")

/datum/category_item/autolathe/arms/smg_9mm
	name = "top-mounted SMG magazine (9mm)"
	path =/obj/item/ammo_magazine/m9mmt/empty
	category = list("Arms and Ammunition")

/datum/category_item/autolathe/arms/smg_10mm
	name = "SMG magazine (10mm)"
	path =/obj/item/ammo_magazine/m10mm/empty
	category = list("Arms and Ammunition")
	hidden = 1

/datum/category_item/autolathe/arms/pistol_44
	name = "pistol magazine (.44)"
	path =/obj/item/ammo_magazine/m44/empty
	category = list("Arms and Ammunition")
	hidden = 1

/datum/category_item/autolathe/arms/rifle_545
	name = "10rnd rifle magazine (5.45mm)"
	path =/obj/item/ammo_magazine/m545saw/empty
	category = list("Arms and Ammunition")

/datum/category_item/autolathe/arms/rifle_545m
	name = "20rnd rifle magazine (5.45mm)"
	path =/obj/item/ammo_magazine/m545sawm/empty
	category = list("Arms and Ammunition")
	hidden = 1

/datum/category_item/autolathe/arms/rifle_SVD
	name = "10rnd rifle magazine (7.62mm)"
	path =/obj/item/ammo_magazine/m762svd/empty
	category = list("Arms and Ammunition")
	hidden = 1

/datum/category_item/autolathe/arms/rifle_762
	name = "20rnd rifle magazine (7.62mm)"
	path =/obj/item/ammo_magazine/m762/empty
	category = list("Arms and Ammunition")
	hidden = 1

/datum/category_item/autolathe/arms/machinegun_762
	name = "machinegun box magazine (7.62)"
	path =/obj/item/ammo_magazine/a762/empty
	category = list("Arms and Ammunition")
	hidden = 1

/datum/category_item/autolathe/arms/shotgun_magazine
	name = "24rnd shotgun magazine (12g)"
	path =/obj/item/ammo_magazine/m12gdrum/empty
	category = list("Arms and Ammunition")
	hidden = 1*/

/*
 * High Caliber
 */

/datum/category_item/autolathe/arms/rifle_145
	name = "14.5mm round (sabot)"
	path = /obj/item/ammo_casing/a145/highvel
	hidden = 1

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

/datum/category_item/autolathe/arms/speedloader_45
	name = "speedloader (.45)"
	path = /obj/item/ammo_magazine/s45
	hidden = 1

/datum/category_item/autolathe/arms/speedloader_45r
	name = "speedloader (.45 rubber)"
	path = /obj/item/ammo_magazine/s45/rubber

// Commented out until metal exploits with autolathe is fixed.
/*/datum/category_item/autolathe/arms/pistol_clip_45
	name = "ammo clip (.45)"
	path =/obj/item/ammo_magazine/clip/c45
	category = list("Arms and Ammunition")
	hidden = 1

/datum/category_item/autolathe/arms/pistol_clip_45r
	name = "ammo clip (.45 rubber)"
	path =/obj/item/ammo_magazine/clip/c45/rubber
	category = list("Arms and Ammunition")

/datum/category_item/autolathe/arms/pistol_clip_45f
	name = "ammo clip (.45 flash)"
	path =/obj/item/ammo_magazine/clip/c45/flash
	category = list("Arms and Ammunition")

/datum/category_item/autolathe/arms/pistol_clip_45p
	name = "ammo clip (.45 practice)"
	path =/obj/item/ammo_magazine/clip/c45/practice
	category = list("Arms and Ammunition")

/datum/category_item/autolathe/arms/pistol_clip_9mm
	name = "ammo clip (9mm)"
	path =/obj/item/ammo_magazine/clip/c9mm
	category = list("Arms and Ammunition")
	hidden = 1

/datum/category_item/autolathe/arms/pistol_clip_9mmr
	name = "ammo clip (9mm rubber)"
	path =/obj/item/ammo_magazine/clip/c9mm/rubber
	category = list("Arms and Ammunition")

/datum/category_item/autolathe/arms/pistol_clip_9mmp
	name = "ammo clip (9mm practice)"
	path =/obj/item/ammo_magazine/clip/c9mm/practice
	category = list("Arms and Ammunition")

/datum/category_item/autolathe/arms/pistol_clip_9mmf
	name = "ammo clip (9mm flash)"
	path =/obj/item/ammo_magazine/clip/c9mm/flash
	category = list("Arms and Ammunition")

/datum/category_item/autolathe/arms/pistol_clip_5mm
	name = "ammo clip (5mm)"
	path =/obj/item/ammo_magazine/clip/c5mm
	category = list("Arms and Ammunition")
	hidden = 1

/datum/category_item/autolathe/arms/pistol_clip_50
	name = "ammo clip (.44)"
	path =/obj/item/ammo_magazine/clip/c50
	category = list("Arms and Ammunition")
	hidden = 1
*/
/datum/category_item/autolathe/arms/rifle_clip_545
	name = "ammo clip (5.45mm)"
	path =/obj/item/ammo_magazine/clip/c545
	category = list("Arms and Ammunition")
	hidden = 1

/datum/category_item/autolathe/arms/rifle_clip_545_practice
	name = "ammo clip (5.45mm practice)"
	path =/obj/item/ammo_magazine/clip/c545/practice
	category = list("Arms and Ammunition")

/datum/category_item/autolathe/arms/rifle_clip_762
	name = "ammo clip (7.62mm)"
	path =/obj/item/ammo_magazine/clip/c762
	hidden = 1

/*/datum/category_item/autolathe/arms/rifle_clip_762_hunter //VOREStation Edit Start. By request of Ace
	name = "ammo clip (7.62mm hunting)"
	path =/obj/item/ammo_magazine/clip/c762/hunter*/ //VOREStation Edit End.

/datum/category_item/autolathe/arms/rifle_clip_762_practice
	name = "ammo clip (7.62mm practice)"
	path =/obj/item/ammo_magazine/clip/c762/practice

/datum/category_item/autolathe/arms/knuckledusters
	name = "knuckle dusters"
	path =/obj/item/clothing/accessory/knuckledusters
	hidden = 1

/datum/category_item/autolathe/arms/tacknife
	name = "tactical knife"
	path =/obj/item/material/knife/tacknife
	hidden = 1

/datum/category_item/autolathe/arms/flamethrower
	name = "flamethrower"
	path =/obj/item/flamethrower/full
	hidden = 1
