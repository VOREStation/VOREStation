/* Two-handed Weapons
 * Contains:
 * 		Twohanded
 *		Fireaxe
 *		Double-Bladed Energy Swords
 */

/*##################################################################
##################### TWO HANDED WEAPONS BE HERE~ -Agouri :3 ########
####################################################################*/

//Rewrote TwoHanded weapons stuff and put it all here. Just copypasta fireaxe to make new ones ~Carn
//This rewrite means we don't have two variables for EVERY item which are used only by a few weapons.
//It also tidies stuff up elsewhere.

/*
 * Twohanded
 */
/obj/item/weapon/material/twohanded
	w_class = ITEMSIZE_LARGE
	var/wielded = 0
	var/force_wielded = 0
	var/force_unwielded
	var/wieldsound = null
	var/unwieldsound = null
	var/base_icon
	var/base_name
	var/unwielded_force_divisor = 0.25
	hitsound = "swing_hit"
	drop_sound = 'sound/items/drop/sword.ogg'
	pickup_sound = 'sound/items/pickup/sword.ogg'

/obj/item/weapon/material/twohanded/update_held_icon()
	var/mob/living/M = loc
	if(istype(M) && M.can_wield_item(src) && is_held_twohanded(M))
		wielded = 1
		force = force_wielded
		name = "[base_name] (wielded)"
		update_icon()
	else
		wielded = 0
		force = force_unwielded
		name = "[base_name]"
	update_icon()
	..()

/obj/item/weapon/material/twohanded/update_force()
	base_name = name
	if(sharp || edge)
		force_wielded = material.get_edge_damage()
	else
		force_wielded = material.get_blunt_damage()
	force_wielded = round(force_wielded*force_divisor)
	force_unwielded = round(force_wielded*unwielded_force_divisor)
	force = force_unwielded
	throwforce = round(force*thrown_force_divisor)
	//to_world("[src] has unwielded force [force_unwielded], wielded force [force_wielded] and throwforce [throwforce] when made from default material [material.name]")

/obj/item/weapon/material/twohanded/New()
	..()
	update_icon()

//Allow a small chance of parrying melee attacks when wielded - maybe generalize this to other weapons someday
/obj/item/weapon/material/twohanded/handle_shield(mob/user, var/damage, atom/damage_source = null, mob/attacker = null, var/def_zone = null, var/attack_text = "the attack")
	if(wielded && default_parry_check(user, attacker, damage_source) && prob(15))
		user.visible_message("<span class='danger'>\The [user] parries [attack_text] with \the [src]!</span>")
		playsound(src, 'sound/weapons/punchmiss.ogg', 50, 1)
		return 1
	return 0

/obj/item/weapon/material/twohanded/update_icon()
	icon_state = "[base_icon][wielded]"
	item_state = icon_state

/obj/item/weapon/material/twohanded/dropped()
	..()
	if(wielded)
		spawn(0)
			update_held_icon()

/*
 * Fireaxe
 */
/obj/item/weapon/material/twohanded/fireaxe  // DEM AXES MAN, marker -Agouri
	icon_state = "fireaxe0"
	base_icon = "fireaxe"
	name = "fire axe"
	desc = "Truly, the weapon of a madman. Who would think to fight fire with an axe?"
	description_info = "This weapon can cleave, striking nearby lesser, hostile enemies close to the primary target.  It must be held in both hands to do this."
	unwielded_force_divisor = 0.25
	force_divisor = 0.7 // 10/42 with hardness 60 (steel) and 0.25 unwielded divisor
	dulled_divisor = 0.75	//Still metal on a stick
	sharp = TRUE
	edge = TRUE
	w_class = ITEMSIZE_LARGE
	slot_flags = SLOT_BACK
	force_wielded = 30
	attack_verb = list("attacked", "chopped", "cleaved", "torn", "cut")
	applies_material_colour = 0
	can_cleave = TRUE
	drop_sound = 'sound/items/drop/axe.ogg'
	pickup_sound = 'sound/items/pickup/axe.ogg'

/obj/item/weapon/material/twohanded/fireaxe/update_held_icon()
	var/mob/living/M = loc
	if(istype(M) && !issmall(M) && M.item_is_in_hands(src) && !M.hands_are_full())
		wielded = 1
		pry = 1
		force = force_wielded
		name = "[base_name] (wielded)"
		update_icon()
	else
		wielded = 0
		pry = 0
		force = force_unwielded
		name = "[base_name]"
	update_icon()
	..()

/obj/item/weapon/material/twohanded/fireaxe/afterattack(atom/A as mob|obj|turf|area, mob/user as mob, proximity)
	if(!proximity) return
	..()
	if(A && wielded)
		if(istype(A,/obj/structure/window))
			var/obj/structure/window/W = A
			W.shatter()
		else if(istype(A,/obj/structure/grille))
			qdel(A)
		else if(istype(A,/obj/effect/plant))
			var/obj/effect/plant/P = A
			P.die_off()

/obj/item/weapon/material/twohanded/fireaxe/scythe
	icon_state = "scythe0"
	base_icon = "scythe"
	name = "scythe"
	desc = "A sharp and curved blade on a long fibremetal handle, this tool makes it easy to reap what you sow."
	force_divisor = 0.65
	origin_tech = list(TECH_MATERIAL = 2, TECH_COMBAT = 2)
	attack_verb = list("chopped", "sliced", "cut", "reaped")

//spears, bay edition
/obj/item/weapon/material/twohanded/spear
	icon_state = "spearglass0"
	base_icon = "spearglass"
	name = "spear"
	desc = "A haphazardly-constructed yet still deadly weapon of ancient design."
	description_info = "This weapon can strike from two tiles away, and over certain objects such as tables, or other people."
	force = 10
	w_class = ITEMSIZE_LARGE
	slot_flags = SLOT_BACK
	force_divisor = 0.5 			// 15 when wielded with hardness 30 (glass)
	unwielded_force_divisor = 0.375
	thrown_force_divisor = 1.5 		// 22.5 when thrown with weight 15 (glass)
	throw_speed = 3
	edge = FALSE
	sharp = TRUE
	hitsound = 'sound/weapons/bladeslice.ogg'
	mob_throw_hit_sound =  'sound/weapons/pierce.ogg'
	attack_verb = list("attacked", "poked", "jabbed", "torn", "gored")
	default_material = "glass"
	applies_material_colour = 0
	fragile = 1	//It's a haphazard thing of glass, wire, and steel
	reach = 2 // Spears are long.
	attackspeed = 14

//This is mostly for centaurs.
/obj/item/weapon/material/twohanded/spear/lance
	name = "lance"
	desc = "End him rightly"
	icon = 'icons/obj/weapons_vr.dmi'
	icon_state = "lance"
	item_state = "lance"
	force_divisor = 0.3
	force = 10
	thrown_force_divisor = 1
	default_material = "MAT_STEEL"
	fragile = 0
	sharp = TRUE
	edge = FALSE

/obj/item/weapon/material/twohanded/riding_crop
	name = "riding crop"
	desc = "A rod, a little over a foot long with a widened grip and a thick, leather patch at the end. Used since the dawn of the West to control animals."
	force_divisor = 0.05 //Required in order for the X attacks Y message to pop up.
	unwielded_force_divisor = 1 // One here, too.
	applies_material_colour = 1
	unbreakable = 1
	base_icon = "riding_crop"
	icon_state = "riding_crop0"
	attack_verb = list("cropped","spanked","swatted","smacked","peppered")

/obj/item/weapon/material/twohanded/spear/flint
	default_material = MAT_FLINT