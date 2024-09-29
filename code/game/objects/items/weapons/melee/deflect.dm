/*
 * The home of basic deflect / defense code.
 */

/obj/item/melee
	var/defend_chance = 5	// The base chance for the weapon to parry.
	var/projectile_parry_chance = 0	// The base chance for a projectile to be deflected.

/obj/item/melee/handle_shield(mob/user, var/damage, atom/damage_source = null, mob/attacker = null, var/def_zone = null, var/attack_text = "the attack")
	if(.)
		return .
	if(default_parry_check(user, attacker, damage_source) && prob(defend_chance))
		user.visible_message("<span class='danger'>\The [user] parries [attack_text] with \the [src]!</span>")
		return 1
	if(unique_parry_check(user, attacker, damage_source) && prob(projectile_parry_chance))
		user.visible_message("<span class='danger'>\The [user] deflects [attack_text] with \the [src]!</span>")
		return 1

	return 0

/obj/item/melee/unique_parry_check(mob/user, mob/attacker, atom/damage_source)
	if(.)
		return .
	if(user.incapacitated() || !istype(damage_source, /obj/item/projectile))
		return 0

	var/bad_arc = reverse_direction(user.dir)
	if(!check_shield_arc(user, bad_arc, damage_source, attacker))
		return 0

	return 1
