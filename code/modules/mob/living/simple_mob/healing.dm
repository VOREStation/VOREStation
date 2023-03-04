// Simple mob healing interactions, moved here to keep attackby() shorter.
// TODO: Potentially datumize this system a la Bay's movement handlers; have
// some /decl/mob_heal_method static list on a proc based on mob flags, then
// iterate it in attackby.

// Checks if a tool can heal us; left as a proc for override in the future.
/mob/living/simple_mob/proc/item_can_heal_mob(var/obj/item/thing)
	var/static/list/_item_heals_synthetic_simplemobs = list(
		/obj/item/borg/upgrade/restart,
		/obj/item/weldingtool,
		/obj/item/stack/cable_coil,
		/obj/item/stack/nanopaste
	)
	var/static/list/_items_heals_nonsynthetic_simplemobs = list(
		/obj/item/stack/medical,
		/obj/item/shockpaddles
	)
	return is_type_in_list(thing, (isSynthetic() ? _item_heals_synthetic_simplemobs : _items_heals_nonsynthetic_simplemobs))

// Make an attempt to heal the mob with a tool supplied by a user.
// Return value is FALSE if parent attackby should proceed, TRUE
// if we handled it and it should end.
/mob/living/simple_mob/proc/attempt_healing(var/mob/user, var/obj/item/tool)

	// Check our base mob_class in case we are currently unhandled (slime, aberration, demon)
	if(!(mob_class & MOB_CLASSES_HEALABLE) || (mob_class & MOB_CLASSES_UNHEALABLE))
		return FALSE

	/// Check if the supplied tool can even theoretically be applied to us.
	if(!item_can_heal_mob(tool))
		return FALSE

	// Prevent spamming.
	user.setClickCooldown(user.get_attack_speed(tool))

	var/datum/gender/T = gender_datums[get_visible_gender()]

	// If they're dead, all we can do is revive them, not heal them.
	// They recover a bit easier than humans since they have no DOT
	// to kill them immediately after revival.
	if(stat == DEAD)

		// Too late, too bad, so sad.
		var/is_synthetic = isSynthetic()
		if(world.time - timeofdeath >= 15 MINUTES)
			to_chat(user, SPAN_NOTICE("Unfortunately, \the [src] is beyond recovery."))
		else if(istype(tool, is_synthetic ? /obj/item/borg/upgrade/restart : /obj/item/shockpaddles))
			attempt_medical_revive(user, tool)
		else
			to_chat(user, SPAN_WARNING("\The [src] is [is_synthetic ? "beyond repair" : "dead"], patching [T.him] up won't bring [T.him] back[is_synthetic ? " online" : ""]."))
		return TRUE

	// Basic medical item repair.
	if(istype(tool, /obj/item/stack/medical))
		var/obj/item/stack/medical/MED = tool

		// Check if they actually need healing with this item.
		if(health >= getMaxHealth())
			to_chat(user, SPAN_WARNING("\The [src] does not need medical treatment."))
			return TRUE
		if((MED.heal_burn && !MED.heal_brute) && !getFireLoss())
			to_chat(user, SPAN_WARNING("\The [src] has no burns to treat."))
			return TRUE
		if((!MED.heal_burn && MED.heal_brute) && !getBruteLoss())
			to_chat(user, SPAN_WARNING("\The [src] has no physical injuries to treat."))
			return TRUE

		// Apply!
		if(MED.get_amount() < 1)
			to_chat(user, SPAN_WARNING("You do not have enough of \the [MED] to treat \the [src]."))
			return TRUE
		if(length(MED.apply_sounds))
			playsound(user, pick(MED.apply_sounds), 25)
		if(do_mob(user, src, 2 SECONDS) && !QDELETED(MED) && MED.get_amount() >= 1 && health < getMaxHealth())
			heal_organ_damage(MED.heal_brute * 25, MED.heal_burn * 25)
			visible_message(SPAN_NOTICE("\The [user] applies \the [MED] to \the [src]."))
			MED.use(1)
		return TRUE

	// Welding tool repair for robot brute damage.
	if(istype(tool, /obj/item/weldingtool))
		if(!getBruteLoss())
			to_chat(user, SPAN_WARNING("\The [src] has no physical damage to repair."))
			return TRUE
		var/obj/item/weldingtool/WT = tool
		if(!WT.isOn())
			to_chat(user, SPAN_WARNING("Turn \the [WT] on first!"))
			return TRUE
		if(!WT.remove_fuel(0))
			to_chat(user, SPAN_WARNING("You need more fuel to repair \the [src]."))
			return TRUE
		playsound(loc, 'sound/items/Welder2.ogg', 25)
		if(do_mob(user, src, 2 SECONDS) && !QDELETED(WT) && WT.remove_fuel(0) && getBruteLoss())
			visible_message(SPAN_NOTICE("\The [user] patches some of the dents and cracks on \the [src]."))
			heal_organ_damage(rand(5,15), 0)
		return TRUE

	// Cable repair for robot burn damage.
	if(istype(tool, /obj/item/stack/cable_coil))
		if(!getFireLoss())
			to_chat(user, SPAN_WARNING("\The [src] has no wiring damage to repair."))
			return TRUE
		var/obj/item/stack/cable_coil/coil = tool
		if(coil.get_amount() < 3)
			to_chat(user, SPAN_WARNING("You need at least three lengths of cable to repair \the [src]."))
			return TRUE
		if(do_mob(user, src, 2 SECONDS) && !QDELETED(coil) && coil.use(3) && getFireLoss())
			visible_message(SPAN_NOTICE("\The [user] patches some of the damaged wiring in \the [src]."))
			heal_organ_damage(0, rand(5,15))
		return TRUE

	// Nanopaste for Powerful Robot Repair.
	if(istype(tool, /obj/item/stack/nanopaste))
		if(health >= getMaxHealth())
			to_chat(user, SPAN_WARNING("\The [src] does not need repair."))
			return TRUE
		var/obj/item/stack/nanopaste/N = tool
		if(N.get_amount() < 1)
			to_chat(user, SPAN_WARNING("You do not have enough of \the [N] to repair \the [src]."))
			return TRUE
		if(do_mob(user, src, 2 SECONDS) && !QDELETED(N) && N.get_amount() >= 1 && health < getMaxHealth())
			heal_organ_damage(rand(10,15), rand(10,15))
			visible_message(SPAN_NOTICE("\The [user] applies \the [N] to \the [src]."))
		return TRUE

/mob/living/simple_mob/proc/attempt_medical_revive(var/mob/user, var/obj/item/tool)

	var/mob/observer/dead/ghost = get_ghost()
	if(ghost)
		ghost.notify_revive("Someone is trying to resuscitate you. Re-enter your body if you want to be revived!", 'sound/effects/genetics.ogg', source = src)

	user.visible_message(SPAN_NOTICE("\The [user] begins applying \the [tool] to \the [src]..."))

	var/delay_time = 5 SECONDS
	var/obj/item/shockpaddles/paddles = tool
	if(istype(paddles))
		if(!paddles.check_charge(paddles.chargecost))
			to_chat(user, SPAN_WARNING("\The [src] does not have enough battery."))
			return FALSE
		playsound(src, 'sound/machines/defib_charge.ogg', 50, 0)
		delay_time = paddles.chargetime

	if(!do_after(user, delay_time, src) || stat != DEAD)
		return FALSE

	if(istype(paddles))
		if(QDELETED(paddles) || !paddles.checked_use(paddles.chargecost))
			return FALSE
		playsound(src, 'sound/machines/defib_zap.ogg', 100, 1, -1)

	if(key && !client && !teleop)
		visible_message(SPAN_WARNING("\The [src] twitches a bit, but then falls still."))
		return FALSE

	visible_message(SPAN_NOTICE("\The [src] is shocked back to life!"))

	// Set the health to what it was prior to rejuve, with a bit of wiggle-room for totally dead critters.
	var/initial_brute = bruteloss
	var/initial_burn =  fireloss
	rejuvenate()

	// This is a bit clunky, but set brute and burn such
	// that they remain injured but don't instantly die.
	var/halfhealth = round(getMaxHealth() * 0.45)
	bruteloss = min(initial_brute, halfhealth)
	fireloss =  min(initial_burn, halfhealth)
	updatehealth()

	// Give them some lingering effects.
	Confuse(20)
	Weaken(20)
	Stun(20)
	Blind(20)
	Sleeping(20)

	if(!resting)
		resting = TRUE
		update_canmove()
	update_icon()

	if(istype(tool, /obj/item/borg/upgrade/restart))
		user.drop_from_inventory(tool)
		qdel(tool)
	return TRUE
