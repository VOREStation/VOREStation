/* Surgery Tools
 * Contains:
 *		Bio-Regenerator
 *		Retractor
 *		Hemostat
 *		Cautery
 *		Surgical Drill
 *		Scalpel
 *		Researchable Scalpels
 *		Circular Saws
 *		Misc Tools
 *		Cyborg Tools
 *		Alien Tools
 */

/obj/item/weapon/surgical
	name = "Surgical tool"
	desc = "This shouldn't be here, ahelp it."
	icon = 'icons/obj/surgery_vr.dmi'
	w_class = ITEMSIZE_SMALL
	drop_sound = 'sound/items/drop/weldingtool.ogg'
	pickup_sound = 'sound/items/pickup/weldingtool.ogg'
	var/helpforce = 0	//For help intent things

/obj/item/weapon/surgical/attack(mob/M, mob/user)
	if(user.a_intent == I_HELP)	//A tad messy, but this should stop people from smacking their patients in surgery
		return 0
	..()

/*
 * Bio-Regenerator
 */
/obj/item/weapon/surgical/bioregen
	name="bioregenerator"
	desc="A special tool used in surgeries which can pull toxins from and restore oxygen to organic tissue as well as recreate missing biological structures to allow otherwise irreperable flesh to be mended."
	icon_state="bioregen"
	drop_sound = 'sound/items/drop/scrap.ogg'

/*
 * Retractor
 */

/obj/item/weapon/surgical/retractor
	name = "retractor"
	desc = "Retracts stuff."
	icon_state = "retractor"
	matter = list(MAT_STEEL = 10000, MAT_GLASS = 5000)
	origin_tech = list(TECH_MATERIAL = 1, TECH_BIO = 1)
	drop_sound = 'sound/items/drop/scrap.ogg'

/*
 * Hemostat
 */
/obj/item/weapon/surgical/hemostat
	name = "hemostat"
	desc = "You think you have seen this before."
	icon_state = "hemostat"
	matter = list(MAT_STEEL = 5000, MAT_GLASS = 2500)
	origin_tech = list(TECH_MATERIAL = 1, TECH_BIO = 1)
	attack_verb = list("attacked", "pinched")
	drop_sound = 'sound/items/drop/scrap.ogg'

/*
 * Cautery
 */
/obj/item/weapon/surgical/cautery
	name = "cautery"
	desc = "This stops bleeding."
	icon_state = "cautery"
	matter = list(MAT_STEEL = 5000, MAT_GLASS = 2500)
	origin_tech = list(TECH_MATERIAL = 1, TECH_BIO = 1)
	attack_verb = list("burnt")
	drop_sound = 'sound/items/drop/scrap.ogg'

/*
 * Surgical Drill
 */
/obj/item/weapon/surgical/surgicaldrill
	name = "surgical drill"
	desc = "You can drill using this item. You dig?"
	icon_state = "drill"
	hitsound = 'sound/weapons/circsawhit.ogg'
	matter = list(MAT_STEEL = 15000, MAT_GLASS = 10000)
	force = 15.0
	w_class = ITEMSIZE_NORMAL
	origin_tech = list(TECH_MATERIAL = 1, TECH_BIO = 1)
	attack_verb = list("drilled")
	drop_sound = 'sound/items/drop/accessory.ogg'

/*
 * Scalpel
 */
/obj/item/weapon/surgical/scalpel
	name = "scalpel"
	desc = "Cut, cut, and once more cut."
	icon_state = "scalpel"
	force = 10.0
	sharp = TRUE
	edge = TRUE
	w_class = ITEMSIZE_TINY
	slot_flags = SLOT_EARS
	throwforce = 5.0
	throw_speed = 3
	throw_range = 5
	origin_tech = list(TECH_MATERIAL = 1, TECH_BIO = 1)
	matter = list(MAT_STEEL = 10000, MAT_GLASS = 5000)
	attack_verb = list("attacked", "slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")
	drop_sound = 'sound/items/drop/knife.ogg'

/*
 * Researchable Scalpels
 */
/obj/item/weapon/surgical/scalpel/laser1
	name = "laser scalpel"
	desc = "A scalpel augmented with a directed laser, for more precise cutting without blood entering the field.  This one looks basic and could be improved."
	icon_state = "scalpel_laser1"
	damtype = "fire"

/obj/item/weapon/surgical/scalpel/laser2
	name = "laser scalpel"
	desc = "A scalpel augmented with a directed laser, for more precise cutting without blood entering the field.  This one looks somewhat advanced."
	icon_state = "scalpel_laser2"
	damtype = "fire"
	force = 12.0

/obj/item/weapon/surgical/scalpel/laser3
	name = "laser scalpel"
	desc = "A scalpel augmented with a directed laser, for more precise cutting without blood entering the field.  This one looks to be the pinnacle of precision energy cutlery!"
	icon_state = "scalpel_laser3"
	damtype = "fire"
	force = 15.0

/obj/item/weapon/surgical/scalpel/manager
	name = "incision management system"
	desc = "A true extension of the surgeon's body, this marvel instantly and completely prepares an incision allowing for the immediate commencement of therapeutic steps."
	icon_state = "scalpel_manager"
	force = 7.5

/obj/item/weapon/surgical/scalpel/ripper
	name = "jagged scalpel"
	desc = "A horrifying bladed tool with a large metal spike in its center. The tool is used for rapidly removing organs or medical malpractice."
	icon_state = "organ_ripper"
	item_state = "bone_setter"
	force = 15.0
	toolspeed = 0.75
	origin_tech = list(TECH_MATERIAL = 5, TECH_BIO = 3, TECH_ILLEGAL = 2)

/*
 * Circular Saws
 */
/obj/item/weapon/surgical/circular_saw
	name = "circular saw"
	desc = "For heavy duty cutting."
	icon_state = "saw"
	hitsound = 'sound/weapons/circsawhit.ogg'
	drop_sound = 'sound/items/drop/accessory.ogg'
	force = 15.0
	w_class = ITEMSIZE_NORMAL
	throwforce = 9.0
	throw_speed = 3
	throw_range = 5
	origin_tech = list(TECH_MATERIAL = 1, TECH_BIO = 1)
	matter = list(MAT_STEEL = 20000,MAT_GLASS = 10000)
	attack_verb = list("attacked", "slashed", "sawed", "cut")
	sharp = TRUE
	edge = TRUE

/obj/item/weapon/surgical/circular_saw/manager
	name = "energetic bone diverter"
	desc = "For heavy duty cutting (and sealing), with science!"
	icon_state = "adv_saw"
	item_state = "saw3"
	hitsound = 'sound/weapons/emitter2.ogg'
	damtype = SEARING
	w_class = ITEMSIZE_NORMAL
	origin_tech = list(TECH_BIO = 4, TECH_MATERIAL = 6, TECH_MAGNET = 6)
	matter = list(MAT_STEEL = 25000,MAT_GLASS = 20000)
	attack_verb = list("attacked", "slashed", "seared", "cut")
	toolspeed = 0.75

/*
 * Misc Tools
 */
/obj/item/weapon/surgical/bonegel
	name = "bone gel"
	desc = "For fixing bones."
	icon_state = "bone-gel"
	force = 0
	throwforce = 1.0
	drop_sound = 'sound/items/drop/bottle.ogg'

/obj/item/weapon/surgical/FixOVein
	name = "FixOVein"
	desc = "Like bone gel. For veins."
	icon_state = "fixovein"
	force = 0
	throwforce = 1.0
	origin_tech = list(TECH_MATERIAL = 1, TECH_BIO = 3)
	var/usage_amount = 10
	drop_sound = 'sound/items/drop/bottle.ogg'

/obj/item/weapon/surgical/bonesetter
	name = "bone setter"
	desc = "Put them in their place."
	icon_state = "bone_setter"
	force = 8.0
	throwforce = 9.0
	throw_speed = 3
	throw_range = 5
	attack_verb = list("attacked", "hit", "bludgeoned")
	drop_sound = 'sound/items/drop/scrap.ogg'

/obj/item/weapon/surgical/bone_clamp
	name = "bone clamp"
	desc = "The best way to get a bone fixed fast."
	icon_state = "bone_clamp"
	force = 8
	throwforce = 9
	throw_speed = 3
	throw_range = 5
	attack_verb = list("attacked", "hit", "bludgeoned")

/*
 * Cyborg Tools
 */
/obj/item/weapon/surgical/retractor/cyborg
	icon_state = "cyborg_retractor"
	toolspeed = 0.5

/obj/item/weapon/surgical/hemostat/cyborg
	icon_state = "cyborg_hemostat"
	toolspeed = 0.5

/obj/item/weapon/surgical/cautery/cyborg
	icon_state = "cyborg_cautery"
	toolspeed = 0.5

/obj/item/weapon/surgical/surgicaldrill/cyborg
	icon_state = "cyborg_drill"
	toolspeed = 0.5

/obj/item/weapon/surgical/scalpel/cyborg
	icon_state = "cyborg_scalpel"
	toolspeed = 0.5

/obj/item/weapon/surgical/circular_saw/cyborg
	icon_state = "cyborg_saw"
	toolspeed = 0.5

/obj/item/weapon/surgical/bonegel/cyborg
	toolspeed = 0.5

/obj/item/weapon/surgical/FixOVein/cyborg
	toolspeed = 0.5

/obj/item/weapon/surgical/bonesetter/cyborg
	icon_state = "cyborg_setter"
	toolspeed = 0.5

/obj/item/weapon/surgical/bioregen/cyborg //VoreStation edit: let the borgs S U C C
	icon_state = "cyborg_bioregen"
	toolspeed = 0.5

/*
 * Alien Tools
 */
/obj/item/weapon/surgical/retractor/alien
	icon = 'icons/obj/abductor.dmi'
	toolspeed = 0.25

/obj/item/weapon/surgical/hemostat/alien
	icon = 'icons/obj/abductor.dmi'
	toolspeed = 0.25

/obj/item/weapon/surgical/cautery/alien
	icon = 'icons/obj/abductor.dmi'
	toolspeed = 0.25

/obj/item/weapon/surgical/surgicaldrill/alien
	icon = 'icons/obj/abductor.dmi'
	toolspeed = 0.25

/obj/item/weapon/surgical/scalpel/alien
	icon = 'icons/obj/abductor.dmi'
	toolspeed = 0.25

/obj/item/weapon/surgical/circular_saw/alien
	icon = 'icons/obj/abductor.dmi'
	toolspeed = 0.25

/obj/item/weapon/surgical/FixOVein/alien
	icon = 'icons/obj/abductor.dmi'
	toolspeed = 0.25

/obj/item/weapon/surgical/bone_clamp/alien
	icon = 'icons/obj/abductor.dmi'
	toolspeed = 0.75
