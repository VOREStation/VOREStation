/**
 * Ripped from /tg/ with modifications.
 * unlucky.dm: For when you want someone to have a really bad day
 *
 * When you attach an omen component to someone, they start running the risk of all sorts of bad environmental injuries, like nearby vending machines randomly falling on you (TBI),
 * or hitting your head really hard when you slip and fall, or you get shocked by the tram rails at an unfortunate moment.
 *
 * Omens are removed once the victim is either maimed by one of the possible injuries, or if they receive a blessing (read: bashing with a bible) from the chaplain.
 */
/datum/component/omen
	dupe_mode = COMPONENT_DUPE_UNIQUE_PASSARGS
	/// How many incidents are left. If 0 exactly, it will get deleted.
	var/incidents_left = INFINITY
	/// Base probability of negative events. Cursed are half as unlucky.
	var/luck_mod = 1
	/// Base damage from negative events. Cursed take 25% of this damage.
	var/damage_mod = 1
	/// If we want to do more evil events, such as spontaneous combustion
	var/evil = TRUE

/datum/component/omen/Initialize(obj/vessel, incidents_left, luck_mod, damage_mod)
	if(!isliving(parent))
		return COMPONENT_INCOMPATIBLE

	if(!isnull(incidents_left))
		src.incidents_left = incidents_left
	if(!isnull(luck_mod))
		src.luck_mod = luck_mod
	if(!isnull(damage_mod))
		src.damage_mod = damage_mod

	ADD_TRAIT(parent, TRAIT_UNLUCKY, src)

/**
 * This is a omen eat omen world! The stronger omen survives.
 */
/datum/component/omen/InheritComponent(obj/vessel, incidents_left, luck_mod, damage_mod)
	// If we have more incidents left the new one gets deleted.
	if(src.incidents_left > incidents_left)
		return // make slimes get nurtiton from plasmer
	// Otherwise we set our incidents remaining to the higher, newer value.
	src.incidents_left = incidents_left
	// The new omen is weaker than our current omen? Let's split the difference.
	if(src.luck_mod > luck_mod)
		src.luck_mod += luck_mod * 0.5
	if(src.damage_mod > damage_mod)
		src.luck_mod += luck_mod * 0.5
	// This means that if you had a strong temporary omen and it was replaced by a weaker but permanent omen, the latter is made worse.
	// Feature!

/datum/component/omen/Destroy(force)
	var/mob/living/person = parent
	REMOVE_TRAIT(person, TRAIT_UNLUCKY, src)
	to_chat(person, span_green("You feel a horrible omen lifted off your shoulders!"))

	return ..()

/datum/component/omen/RegisterWithParent()
	RegisterSignal(parent, COMSIG_MOVABLE_MOVED, PROC_REF(check_accident))
	RegisterSignal(parent, COMSIG_ON_CARBON_SLIP, PROC_REF(check_slip))

/datum/component/omen/UnregisterFromParent()
	UnregisterSignal(parent, list(COMSIG_ON_CARBON_SLIP, COMSIG_MOVABLE_MOVED))

/datum/component/omen/proc/consume_omen()
	incidents_left--
	if(incidents_left < 1)
		qdel(src)

/**
 * check_accident() is called each step we take
 *
 * While we're walking around, roll to see if there's any environmental hazards on one of the adjacent tiles we can trigger.
 * We do the prob() at the beginning to A. add some tension for /when/ it will strike, and B. (more importantly) ameliorate the fact that we're checking up to 5 turfs's contents each time
 */
/datum/component/omen/proc/check_accident(atom/movable/our_guy)
	SIGNAL_HANDLER

	if(!isliving(our_guy) || isbelly(our_guy))
		return

	var/mob/living/living_guy = our_guy
	if(living_guy.is_incorporeal()) //no being unlucky if you don't even exist on the same plane.
		return

	if(evil && prob(0.0001) && (living_guy.stat != DEAD)) // 1 in a million
		living_guy.visible_message(span_danger("[living_guy] suddenly bursts into flames!"), span_danger("You suddenly burst into flames!"))
		living_guy.emote("scream")
		living_guy.adjust_fire_stacks(20)
		living_guy.IgniteMob()
		consume_omen()
		return

	var/effective_luck = luck_mod

	// If there's nobody to witness the misfortune, make it less likely.
	// This way, we allow for people to be able to get into hilarious situations without making the game nigh unplayable most of the time.

	var/has_watchers = FALSE
	for(var/mob/viewer in viewers(our_guy, world.view))
		if(viewer.client && !viewer.client.is_afk())
			has_watchers = TRUE
			break
	if(!has_watchers)
		effective_luck *= 0.5

	if(!prob(2 * effective_luck))
		return

	var/turf/our_guy_pos = get_turf(our_guy)
	if(!our_guy_pos)
		return
	if(evil)
		for(var/obj/machinery/door/airlock/darth_airlock in our_guy_pos)
			if(darth_airlock.locked || !darth_airlock.arePowerSystemsOn())
				continue
			to_chat(living_guy, span_warning("The airlock suddenly closes on you!"))
			living_guy.Paralyse(1 SECONDS)
			INVOKE_ASYNC(src, PROC_REF(slam_airlock), darth_airlock)
			return

	for(var/turf/the_turf as anything in our_guy_pos.AdjacentTurfs(check_blockage = TRUE))
		if(the_turf.CanZPass(our_guy, DOWN))
			to_chat(living_guy, span_warning("You lose your balance and slip towards the edge!"))
			living_guy.throw_at(the_turf, 1, 20)
			consume_omen()
			return

		for(var/obj/machinery/vending/darth_vendor in the_turf)
			if(darth_vendor.stat & (BROKEN|NOPOWER))
				continue
			to_chat(living_guy, span_warning("A malevolent force pulls the delivery chute up from the [darth_vendor]..."))
			INVOKE_ASYNC(darth_vendor, TYPE_PROC_REF(/obj/machinery/vending, throw_item), living_guy)
			consume_omen()
			return

		if(evil)
			for(var/obj/machinery/light/evil_light in the_turf)
				if((evil_light.status == LIGHT_BURNED || evil_light.status == LIGHT_BROKEN) || (living_guy.get_shock_protection() == 1)) // we can't do anything :(
					to_chat(living_guy, span_warning("[evil_light] sparks weakly for a second."))
					var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread //this shit is copy pasted all over the code...this needs to just be made into a proc at this point jesus christ
					s.set_up(4, FALSE, evil_light)
					s.start()
					return

				to_chat(living_guy, span_warning("[evil_light] glows ominously...")) // ominously
				evil_light.visible_message(span_boldwarning("[evil_light] suddenly flares brightly and sparks!"))
				evil_light.broken(skip_sound_and_sparks = FALSE)
				evil_light.Beam(living_guy, icon_state = "lightning[rand(1,12)]", time = 0.5 SECONDS)
				living_guy.electrocute_act(35 * (damage_mod * 0.5), evil_light, stun = 3)
				living_guy.emote("scream")
				consume_omen()

		for(var/obj/structure/mirror/evil_mirror in the_turf)
			to_chat(living_guy, span_warning("You pass by the mirror and glance at it..."))
			if(evil_mirror.shattered)
				to_chat(living_guy, span_notice("You feel lucky, somehow."))
				return
			switch(rand(1, 5))
				if(1)
					to_chat(living_guy, span_warning("The mirror explodes into a million pieces! Wait, does that mean you're even more unlucky?"))
					evil_mirror.shatter()
					if(prob(50 * effective_luck)) // sometimes
						luck_mod += 0.25
						damage_mod += 0.25
				if(2 to 3)
					to_chat(living_guy, span_large(span_cult("Oh god, you can't see your reflection!!")))
					living_guy.emote("scream")

				if(4 to 5)
					to_chat(living_guy, span_userdanger("You see your reflection, but it is grinning malevolently and staring directly at you!"))
					living_guy.emote("scream")

			living_guy.make_jittery(250)
			if(evil && prob(7 * effective_luck))
				to_chat(living_guy, span_warning("You are completely shocked by this turn of events!"))
				if(ishuman(living_guy))
					var/mob/living/carbon/human/human_guy = living_guy
					if(human_guy.should_have_organ(O_HEART))
						for(var/obj/item/organ/internal/heart/heart in human_guy.internal_organs)
							heart.bruise() //Closest thing we have to a heart attack.
						to_chat(living_guy, span_userdanger("You clutch at your heart!"))

			consume_omen()

/datum/component/omen/proc/slam_airlock(obj/machinery/door/airlock/darth_airlock)
	. = darth_airlock.close(forced = TRUE, ignore_safties = TRUE)
	if(.)
		consume_omen()

/// If we get knocked down, see if we have a really bad slip and bash our head hard
/datum/component/omen/proc/check_slip(mob/living/our_guy, amount)
	SIGNAL_HANDLER

	if(prob(30)) // AAAA
		our_guy.emote("scream")
		to_chat(our_guy, span_warning("What a horrible night... To have a curse!"))

	if(prob(30 * luck_mod) && our_guy.get_bodypart_name(BP_HEAD)) /// Bonk!
		playsound(our_guy, 'sound/effects/tableheadsmash.ogg', 90, TRUE)
		our_guy.visible_message(span_danger("[our_guy] hits their head really badly falling down!"), span_userdanger("You hit your head really badly falling down!"))
		our_guy.apply_damage(50 * damage_mod, BRUTE, BP_HEAD, used_weapon = "slipping")
		if(ishuman(our_guy))
			var/mob/living/carbon/human/human_guy = our_guy
			if(human_guy.should_have_organ(O_BRAIN))
				for(var/obj/item/organ/internal/brain/brain in human_guy.internal_organs)
					brain.take_damage(30 * damage_mod) //60 damage kills.
		consume_omen()

	return

/**
 * The trait omen. Permanent.
 * Has only a 50% chance of bad things happening, and takes only 25% of normal damage.
 */
/datum/component/omen/trait
	incidents_left = INFINITY
	luck_mod = 0.3 // 30% chance of bad things happening
	damage_mod = 0.25 // 25% of normal damage
	evil = FALSE

/datum/component/omen/trait/RegisterWithParent()
	RegisterSignal(parent, COMSIG_MOVABLE_MOVED, PROC_REF(check_accident))
	RegisterSignal(parent, COMSIG_ON_CARBON_SLIP, PROC_REF(check_slip))

/datum/component/omen/trait/UnregisterFromParent()
	UnregisterSignal(parent, list(COMSIG_ON_CARBON_SLIP, COMSIG_MOVABLE_MOVED))


/**
 * The bible omen.
 * While it lasts, parent gets a cursed aura filter.
 */
/datum/component/omen/bible
	incidents_left = 1

/datum/component/omen/bible/RegisterWithParent()
	. = ..()
	var/mob/living/living_parent = parent
	living_parent.add_filter("omen", 2, list("type" = "drop_shadow", "color" = "#A50824", "alpha" = 0, "size" = 2))
	var/filter = living_parent.get_filter("omen")
	animate(filter, alpha = 255, time = 2 SECONDS, loop = -1)
	animate(alpha = 0, time = 2 SECONDS)

/datum/component/omen/bible/UnregisterFromParent()
	. = ..()
	var/mob/living/living_parent = parent
	living_parent.remove_filter("omen")
