/* Surgery Tools
 * Contains:
 *		Retractor
 *		Hemostat
 *		Cautery
 *		Surgical Drill
 *		Scalpel
 *		Circular Saw
 */

/obj/item/weapon/surgical
	name = "Surgical tool"
	desc = "This shouldn't be here, ahelp it."
	icon = 'icons/obj/surgery.dmi'
	w_class = ITEMSIZE_SMALL
	flags = CONDUCT
	var/helpforce = 0	//For help intent things

/obj/item/weapon/surgical/attack(mob/M, mob/user)
	if(user.a_intent == I_HELP)	//A tad messy, but this should stop people from smacking their patients in surgery
		return 0
	..()

/*
 * Retractor
 */

/obj/item/weapon/surgical/retractor
	name = "retractor"
	desc = "Retracts stuff."
	icon_state = "retractor"
	matter = list(DEFAULT_WALL_MATERIAL = 10000, "glass" = 5000)
	origin_tech = list(TECH_MATERIAL = 1, TECH_BIO = 1)

/*
 * Hemostat
 */
/obj/item/weapon/surgical/hemostat
	name = "hemostat"
	desc = "You think you have seen this before."
	icon_state = "hemostat"
	matter = list(DEFAULT_WALL_MATERIAL = 5000, "glass" = 2500)
	origin_tech = list(TECH_MATERIAL = 1, TECH_BIO = 1)
	attack_verb = list("attacked", "pinched")

/*
 * Cautery
 */
/obj/item/weapon/surgical/cautery
	name = "cautery"
	desc = "This stops bleeding."
	icon_state = "cautery"
	matter = list(DEFAULT_WALL_MATERIAL = 5000, "glass" = 2500)
	origin_tech = list(TECH_MATERIAL = 1, TECH_BIO = 1)
	attack_verb = list("burnt")

/*
 * Surgical Drill
 */
/obj/item/weapon/surgical/surgicaldrill
	name = "surgical drill"
	desc = "You can drill using this item. You dig?"
	icon_state = "drill"
	hitsound = 'sound/weapons/circsawhit.ogg'
	matter = list(DEFAULT_WALL_MATERIAL = 15000, "glass" = 10000)
	force = 15.0
	w_class = ITEMSIZE_NORMAL
	origin_tech = list(TECH_MATERIAL = 1, TECH_BIO = 1)
	attack_verb = list("drilled")

	suicide_act(mob/user)
		viewers(user) << pick("<span class='danger'>\The [user] is pressing \the [src] to \his temple and activating it! It looks like \he's trying to commit suicide.</span>",
		                       "<span class='danger'>\The [user] is pressing \the [src] to \his chest and activating it! It looks like \he's trying to commit suicide.</span>")
		return (BRUTELOSS)

/*
 * Scalpel
 */
/obj/item/weapon/surgical/scalpel
	name = "scalpel"
	desc = "Cut, cut, and once more cut."
	icon_state = "scalpel"
	force = 10.0
	sharp = 1
	edge = 1
	w_class = ITEMSIZE_TINY
	slot_flags = SLOT_EARS
	throwforce = 5.0
	throw_speed = 3
	throw_range = 5
	origin_tech = list(TECH_MATERIAL = 1, TECH_BIO = 1)
	matter = list(DEFAULT_WALL_MATERIAL = 10000, "glass" = 5000)
	attack_verb = list("attacked", "slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")

	suicide_act(mob/user)
		viewers(user) << pick("<span class='danger'>\The [user] is slitting \his wrists with the [src.name]! It looks like \he's trying to commit suicide.</span>", \
		                      "<span class='danger'>\The [user] is slitting \his throat with the [src.name]! It looks like \he's trying to commit suicide.</span>", \
		                      "<span class='danger'>\The [user] is slitting \his stomach open with the [src.name]! It looks like \he's trying to commit seppuku.</span>")
		return (BRUTELOSS)

/*
 * Researchable Scalpels
 */
/obj/item/weapon/surgical/scalpel/laser1
	name = "laser scalpel"
	desc = "A scalpel augmented with a directed laser, for more precise cutting without blood entering the field.  This one looks basic and could be improved."
	icon_state = "scalpel_laser1_on"
	damtype = "fire"

/obj/item/weapon/surgical/scalpel/laser2
	name = "laser scalpel"
	desc = "A scalpel augmented with a directed laser, for more precise cutting without blood entering the field.  This one looks somewhat advanced."
	icon_state = "scalpel_laser2_on"
	damtype = "fire"
	force = 12.0

/obj/item/weapon/surgical/scalpel/laser3
	name = "laser scalpel"
	desc = "A scalpel augmented with a directed laser, for more precise cutting without blood entering the field.  This one looks to be the pinnacle of precision energy cutlery!"
	icon_state = "scalpel_laser3_on"
	damtype = "fire"
	force = 15.0

/obj/item/weapon/surgical/scalpel/manager
	name = "incision management system"
	desc = "A true extension of the surgeon's body, this marvel instantly and completely prepares an incision allowing for the immediate commencement of therapeutic steps."
	icon_state = "scalpel_manager_on"
	force = 7.5

/*
 * Circular Saw
 */
/obj/item/weapon/surgical/circular_saw
	name = "circular saw"
	desc = "For heavy duty cutting."
	icon_state = "saw3"
	hitsound = 'sound/weapons/circsawhit.ogg'
	force = 15.0
	w_class = ITEMSIZE_NORMAL
	throwforce = 9.0
	throw_speed = 3
	throw_range = 5
	origin_tech = list(TECH_MATERIAL = 1, TECH_BIO = 1)
	matter = list(DEFAULT_WALL_MATERIAL = 20000,"glass" = 10000)
	attack_verb = list("attacked", "slashed", "sawed", "cut")
	sharp = 1
	edge = 1

//misc, formerly from code/defines/weapons.dm
/obj/item/weapon/surgical/bonegel
	name = "bone gel"
	desc = "For fixing bones."
	icon_state = "bone-gel"
	force = 0
	throwforce = 1.0

/obj/item/weapon/surgical/FixOVein
	name = "FixOVein"
	desc = "Like bone gel. For veins."
	icon_state = "fixovein"
	force = 0
	throwforce = 1.0
	origin_tech = list(TECH_MATERIAL = 1, TECH_BIO = 3)
	var/usage_amount = 10

/obj/item/weapon/surgical/bonesetter
	name = "bone setter"
	desc = "Put them in their place."
	icon_state = "bone_setter"
	force = 8.0
	throwforce = 9.0
	throw_speed = 3
	throw_range = 5
	attack_verb = list("attacked", "hit", "bludgeoned")

/obj/item/weapon/surgical/bone_clamp
	name = "bone clamp"
	desc = "The best way to get a bone fixed fast."
	icon_state = "bone_clamp"
	force = 8
	throwforce = 9
	throw_speed = 3
	throw_range = 5
	attack_verb = list("attacked", "hit", "bludgeoned")

// Cyborg Tools

/obj/item/weapon/surgical/retractor/cyborg
	toolspeed = 0.5

/obj/item/weapon/surgical/hemostat/cyborg
	toolspeed = 0.5

/obj/item/weapon/surgical/cautery/cyborg
	toolspeed = 0.5

/obj/item/weapon/surgical/surgicaldrill/cyborg
	toolspeed = 0.5

/obj/item/weapon/surgical/scalpel/cyborg
	toolspeed = 0.5

/obj/item/weapon/surgical/circular_saw/cyborg
	toolspeed = 0.5

/obj/item/weapon/surgical/bonegel/cyborg
	toolspeed = 0.5

/obj/item/weapon/surgical/FixOVein/cyborg
	toolspeed = 0.5

/obj/item/weapon/surgical/bonesetter/cyborg
	toolspeed = 0.5


// Alien Tools
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