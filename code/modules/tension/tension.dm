// This code is used to give a very rough estimate of how screwed an individual player might be at any given moment when fighting monsters.
// You could use this to have an effect trigger when someone is in serious danger, or as a means for an AI to guess which mob needs to die first.
// The idea and the code structure was taken from Dungeon Crawl Stone Soup.

/atom/movable/proc/get_threat(var/mob/living/threatened)
	return 0


/atom/movable/proc/guess_threat_level(var/mob/living/threatened)
	return 0

/mob/living/simple_animal
	var/threat_level = null // Set this if you want an explicit danger rating.

/mob/living/simple_animal/guess_threat_level(var/mob/living/threatened)
	if(threat_level) // If they have a predefined number, use it.
		return threat_level
	// Otherwise we need to guess how scary this thing is.
	var/threat_guess = 0

	// First lets consider their attack ability.
	var/potential_damage = 0
	if(!ranged) //Melee damage.
		potential_damage = (melee_damage_lower + melee_damage_upper) / 2
	else
		if(projectiletype)
			var/obj/item/projectile/P = new projectiletype(src)
			if(P.nodamage || P.taser_effect) // Tasers are somewhat less scary.
				potential_damage = P.agony / 2
			else
				potential_damage = P.damage
				if(P.damage_type == HALLOSS) // Not sure if any projectiles do this, but can't be too safe.
					potential_damage /= 2
				// Rubber bullets, I guess.
				potential_damage += P.agony / 2

			if(rapid) // This makes them shoot three times per cycle.
				potential_damage *= 3

			qdel(P)
	threat_guess += potential_damage

	// Then consider their defense.
	threat_guess += getMaxHealth() / 5 // 100 health translates to 20 threat.

	return threat_guess

/mob/living/get_threat(var/mob/living/threatened)
	if(stat)
		return 0


/mob/living/simple_animal/get_threat(var/mob/living/threatened)
	. = ..()

	if(!hostile)
		return 0 // Can't hurt anyone.

	if(incapacitated(INCAPACITATION_DISABLED))
		return 0 // Can't currently hurt you if it's stunned.

	var/friendly = threatened.faction == faction

	var/threat = guess_threat_level()

	// Hurt entities contribute less tension.
	threat *= health
	threat /= getMaxHealth()

	// Allies reduce tension instead of adding.
	if(friendly)
		threat = -threat

	else
		if(threatened.invisibility > see_invisible)
			threat /= 2 // Target cannot be seen by src.
		if(invisibility > threatened.see_invisible)
			threat *= 2 // Target cannot see src.

	// Handle statuses.
	if(confused)
		threat /= 2

	if(has_modifier_of_type(/datum/modifier/berserk))
		threat *= 2

	// Handle ability to harm.
	// Being five tiles away from some spiders is a lot less scary than being in melee range of five spiders at once.
	if(!ranged)
		threat /= max(get_dist(src, threatened), 1)

	return threat



// Gives a rough idea of how much danger someone is in. Meant to be used for PvE things since PvP has too many unknown variables.
/mob/living/proc/get_tension()
	var/tension = 0
	var/list/potential_threats = list()

	// First, get everything threatening to us.
	for(var/thing in view(src))
		if(isliving(thing))
			potential_threats += thing
		if(istype(thing, /obj/machinery/porta_turret))
			potential_threats += thing

	var/danger = FALSE
	// Now to get all the threats.
	for(var/atom/movable/AM in potential_threats)
		var/tension_from_AM = AM.get_threat(src)
		tension += tension_from_AM
		if(tension_from_AM > 0)
			danger = TRUE

	if(!danger)
		return 0

	// Tension is roughly doubled when about to fall into crit.
	var/max_health = getMaxHealth()
	tension *= 2 * max_health / (health + max_health)

	// Being unable to act is really tense.
	if(incapacitated(INCAPACITATION_DISABLED) && !lying)
		tension *= 10
		return tension

	if(confused)
		tension *= 2

	return tension
