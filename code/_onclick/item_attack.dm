/*
=== Item Click Call Sequences ===
These are the default click code call sequences used when clicking on stuff with an item.

Atoms:

/mob/ClickOn() calls the item's resolve_attackby() proc.
item/resolve_attackby() calls the target atom's attackby() proc.

Mobs:

/mob/living/attackby() after checking for surgery, calls the item's attack() proc.
item/attack() generates attack logs, sets click cooldown and calls the mob's attacked_with_item() proc. If you override this, consider whether you need to set a click cooldown, play attack animations, and generate logs yourself.
/mob/attacked_with_item() should then do mob-type specific stuff (like determining hit/miss, handling shields, etc) and then possibly call the item's apply_hit_effect() proc to actually apply the effects of being hit.

Item Hit Effects:

item/apply_hit_effect() can be overriden to do whatever you want. However "standard" physical damage based weapons should make use of the target mob's hit_with_weapon() proc to
avoid code duplication. This includes items that may sometimes act as a standard weapon in addition to having other effects (e.g. stunbatons on harm intent).
*/

// Called when the item is in the active hand, and clicked; alternately, there is an 'activate held object' verb or you can hit pagedown.
/obj/item/proc/attack_self(mob/user)
	if(SEND_SIGNAL(src, COMSIG_ITEM_ATTACK_SELF, user) & COMPONENT_NO_INTERACT)
		return
	return

/**
 * Called at the start of resolve_attackby(), before the actual attack.
 *
 * Arguments:
 * * atom/A - The atom about to be hit
 * * mob/living/user - The mob doing the htting
 * * params - click params such as alt/shift etc
 *
 * See: [/obj/item/proc/melee_attack_chain]
 */

/obj/item/proc/pre_attack(atom/A, mob/user, params) //do stuff before attackby!
	if(SEND_SIGNAL(src, COMSIG_ITEM_PRE_ATTACK, A, user, params) & COMPONENT_CANCEL_ATTACK_CHAIN)
		return TRUE
	return FALSE //return TRUE to avoid calling attackby after this proc does stuff

//I would prefer to rename this to attack(), but that would involve touching hundreds of files.
/obj/item/proc/resolve_attackby(atom/A, mob/user, var/attack_modifier = 1, var/click_parameters)
	add_fingerprint(user)
	. = pre_attack(A, user, click_parameters)
	if(.)	// We're returning the value of pre_attack, important if it has a special return.
		return
	return A.attackby(src, user, attack_modifier, click_parameters)

// No comment
/atom/proc/attackby(obj/item/W, mob/user, var/attack_modifier, var/click_parameters)
	if(SEND_SIGNAL(src, COMSIG_PARENT_ATTACKBY, W, user, click_parameters) & COMPONENT_CANCEL_ATTACK_CHAIN)
		return TRUE
	return FALSE

/mob/living/attackby(obj/item/I, mob/user, var/attack_modifier, var/click_parameters)
	if(!ismob(user))
		return FALSE

	if(SEND_SIGNAL(src, COMSIG_PARENT_ATTACKBY, I, user, click_parameters) & COMPONENT_CANCEL_ATTACK_CHAIN)
		return FALSE

	if(can_operate(src, user) && I.do_surgery(src,user))
		return TRUE

	if(attempt_vr(src,"vore_attackby",args)) return //VOREStation Add - The vore, of course.

	return I.attack(src, user, user.zone_sel.selecting, attack_modifier)

// Used to get how fast a mob should attack, and influences click delay.
// This is just for inheritence.
/mob/proc/get_attack_speed()
	return DEFAULT_ATTACK_COOLDOWN

// Same as above but actually does useful things.
// W is the item being used in the attack, if any. modifier is if the attack should be longer or shorter than usual, for whatever reason.
/mob/living/get_attack_speed(var/obj/item/W)
	var/speed = base_attack_cooldown
	if(W && istype(W))
		speed = W.attackspeed
	for(var/datum/modifier/M in modifiers)
		if(!isnull(M.attack_speed_percent))
			speed *= M.attack_speed_percent
	return speed

// Proximity_flag is 1 if this afterattack was called on something adjacent, in your square, or on your person.
// Click parameters is the params string from byond Click() code, see that documentation.
/obj/item/proc/afterattack(atom/target, mob/user, proximity_flag, click_parameters)
	return

//I would prefer to rename this attack_as_weapon(), but that would involve touching hundreds of files.
/obj/item/proc/attack(mob/living/M, mob/living/user, var/target_zone, var/attack_modifier)
	if(!force || (flags & NOBLUDGEON))
		return 0
	if(M == user && user.a_intent != I_HURT)
		return 0

	/////////////////////////
	user.lastattacked = M
	M.lastattacker = user

	if(!no_attack_log)
		add_attack_logs(user,M,"attacked with [name] (INTENT: [uppertext(user.a_intent)]) (DAMTYE: [uppertext(damtype)])")
	/////////////////////////

	user.setClickCooldown(user.get_attack_speed(src))
	user.do_attack_animation(M)

	var/hit_zone = M.resolve_item_attack(src, user, target_zone)
	if(hit_zone)
		apply_hit_effect(M, user, hit_zone, attack_modifier)

	return 1

//Called when a weapon is used to make a successful melee attack on a mob. Returns the blocked result
/obj/item/proc/apply_hit_effect(mob/living/target, mob/living/user, var/hit_zone, var/attack_modifier)
	user.break_cloak()
	if(hitsound)
		playsound(src, hitsound, 50, 1, -1)

	var/power = force
	for(var/datum/modifier/M in user.modifiers)
		if(!isnull(M.outgoing_melee_damage_percent))
			power *= M.outgoing_melee_damage_percent

	if(HULK in user.mutations)
		power *= 2

	power *= attack_modifier

	return target.hit_with_weapon(src, user, power, hit_zone)
