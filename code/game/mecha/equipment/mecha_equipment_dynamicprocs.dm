/*
 * File containing all the default 'handlers' for Exosuit equipment, hopefully to make all dynX calls extinct.
 */

// Used for impacting (thrown) objects, and damage value.
/obj/item/mecha_parts/mecha_equipment/proc/handle_ranged_contact(var/obj/A, var/inc_damage = 0)
	return max(0, inc_damage)

// Used for melee strikes with an object, and a mob, and damage value.
/obj/item/mecha_parts/mecha_equipment/proc/handle_melee_contact(var/obj/item/W, var/mob/living/user, var/inc_damage = 0)
	return max(0, inc_damage)

// Used for projectile impacts from bullet_act.
/obj/item/mecha_parts/mecha_equipment/proc/handle_projectile_contact(var/obj/item/projectile/Proj, var/inc_damage = 0)
	return max(0, inc_damage)

// Used for on-movement actions.
/obj/item/mecha_parts/mecha_equipment/proc/handle_movement_action() //Any modules that have special effects or needs when taking a step or floating through space.
	return
