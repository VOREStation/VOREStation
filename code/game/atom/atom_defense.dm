/atom
	///any atom that uses integrity and can be damaged must set this to true, otherwise the integrity procs will throw an error
	var/uses_integrity = FALSE

	VAR_PRIVATE/atom_integrity //defaults to max_integrity
	var/max_integrity = 500
	var/integrity_failure = 0 //0 if we have no special broken behavior, otherwise is a percentage of at what point the atom breaks. 0.5 being 50%
	///Damage under this value will be completely ignored
	var/damage_deflection = 0

	var/resistance_flags = NONE // INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | ON_FIRE | UNACIDABLE | ACID_PROOF

///the sound played when the atom is damaged.
/atom/proc/play_attack_sound(damage_amount, damage_type = BRUTE, damage_flag = 0)
	switch(damage_type)
		if(BRUTE)
			if(damage_amount)
				playsound(src, 'sound/items/weapons/smash.ogg', 50, TRUE)
			else
				playsound(src, 'sound/items/weapons/tap.ogg', 50, TRUE)
		if(BURN)
			playsound(src.loc, 'sound/items/tools/welder.ogg', 100, TRUE)

/// Handles the integrity of an atom changing. This must be called instead of changing integrity directly.
/atom/proc/update_integrity(new_value)
	SHOULD_NOT_OVERRIDE(TRUE)
	if(!uses_integrity)
		CRASH("/atom/proc/update_integrity() was called on [src] when it doesn't use integrity!")
	var/old_value = atom_integrity
	new_value = max(0, new_value)
	if(atom_integrity == new_value)
		return
	atom_integrity = new_value
	on_update_integrity(old_value, new_value)
	return new_value

/// Handle updates to your atom's integrity
/atom/proc/on_update_integrity(old_value, new_value)
	SHOULD_NOT_SLEEP(TRUE)
	SHOULD_CALL_PARENT(TRUE)
	SEND_SIGNAL(src, COMSIG_ATOM_INTEGRITY_CHANGED, old_value, new_value)

/// Called after the atom takes damage and integrity is below integrity_failure level
/atom/proc/atom_break(damage_flag)
	SHOULD_CALL_PARENT(TRUE)
	SEND_SIGNAL(src, COMSIG_ATOM_BREAK, damage_flag)

/// Called when integrity is repaired above the breaking point having been broken before
/atom/proc/atom_fix()
	SHOULD_CALL_PARENT(TRUE)
	SEND_SIGNAL(src, COMSIG_ATOM_FIX)

///what happens when the atom's integrity reaches zero.
/atom/proc/atom_destruction(damage_flag)
	SHOULD_CALL_PARENT(TRUE)
	SEND_SIGNAL(src, COMSIG_ATOM_DESTRUCTION, damage_flag)

///returns the damage value of the attack after processing the atom's various armor protections
///Damage_flag can be any of the following: "melee" = 0, "bullet" = 0, "laser" = 0,"energy" = 0, "bomb" = 0, "bio" = 0, "rad" = 0
///MELEE, BULLET, LASER, ENERGY, BOMB, BIO, and "rad"
/atom/proc/run_atom_armor(damage_amount, damage_type, damage_flag = 0, attack_dir, armour_penetration = 0)
	if(!uses_integrity)
		CRASH("/atom/proc/run_atom_armor was called on [src] without being implemented as a type that uses integrity!")
	if(damage_flag == MELEE && damage_amount < damage_deflection)
		return 0
	if(damage_type != BRUTE && damage_type != BURN)
		return 0
	var/armor_protection = 0
	if(isitem(src)) //Only items have armor until we get armor datums.
		var/obj/item/item_to_check = src
		if(damage_flag)
			armor_protection = item_to_check.armor[damage_flag]
		if(armor_protection) //Only apply weak-against-armor/hollowpoint effects if there actually IS armor.
			armor_protection = clamp(PENETRATE_ARMOUR(armor_protection, armour_penetration), min(armor_protection, 0), 100)
	return round(damage_amount * (100 - armor_protection) * 0.01, DAMAGE_PRECISION)
