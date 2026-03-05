/**
 * Ripped from /tg/ with modifications.
 * unlucky.dm: For when you want someone to have a really bad day
 *
 * When you attach an omen component to someone, they start running the risk of all sorts of bad environmental injuries, like nearby vending machines randomly falling on you (TBI),
 * or hitting your head really hard when you slip and fall, or you get shocked by the tram rails at an unfortunate moment.
 *
 * Omens are removed once the victim is either maimed by one of the possible injuries, or if they receive a blessing (read: bashing with a bible) from the chaplain. (TBI)
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
	/// If our codebase has safe disposals or not
	var/safe_disposals = FALSE
	/// If we have vore interactions or not
	var/vorish = TRUE

/datum/component/omen/Initialize(incidents_left, luck_mod, damage_mod, evil, safe_disposals, vorish)
	if(!isliving(parent))
		return COMPONENT_INCOMPATIBLE

	if(!isnull(incidents_left))
		src.incidents_left = incidents_left
	if(!isnull(luck_mod))
		src.luck_mod = luck_mod
	if(!isnull(damage_mod))
		src.damage_mod = damage_mod
	if(!isnull(evil))
		src.evil = evil
	if(!isnull(safe_disposals))
		src.safe_disposals = safe_disposals
	if(!isnull(vorish))
		src.vorish = vorish

	ADD_TRAIT(parent, TRAIT_UNLUCKY, src)

/**
 * This is a omen eat omen world! The stronger omen survives.
 */
/datum/component/omen/InheritComponent(
	datum/component/omen/new_comp,
	i_am_original,
	incidents_left,
	luck_mod,
	damage_mod,
	evil,
	safe_disposals,
	vorish,
)
	// If we have more incidents left the new one gets deleted.
	if(src.incidents_left > incidents_left)
		return
	src.incidents_left = incidents_left

	// The new omen is weaker than our current omen? Let's split the difference.
	if(src.luck_mod > luck_mod)
		src.luck_mod += luck_mod * 0.5
	if(src.damage_mod > damage_mod)
		src.damage_mod += damage_mod * 0.5

	// If the new omen has special modifiers, we take them on forever!
	if(evil)
		src.evil = TRUE
	if(safe_disposals)
		src.safe_disposals = TRUE
	if(vorish)
		src.vorish = TRUE
	//This means weaker, longing lasting omens will take priority, but have some of the strength of the original.

/datum/component/omen/Destroy(force)
	var/mob/living/person = parent
	REMOVE_TRAIT(person, TRAIT_UNLUCKY, src)
	to_chat(person, span_warning(span_green("You feel a horrible omen lifted off your shoulders!")))

	return ..()

/datum/component/omen/RegisterWithParent()
	RegisterSignal(parent, COMSIG_MOVABLE_MOVED, PROC_REF(check_accident))
	RegisterSignal(parent, COMSIG_ON_CARBON_SLIP, PROC_REF(check_slip))
	RegisterSignal(parent, COMSIG_MOVED_DOWN_STAIRS, PROC_REF(check_stairs))
	RegisterSignal(parent, COMSIG_STUN_EFFECT_ACT, PROC_REF(check_taser))
	RegisterSignal(parent, COMSIG_MOB_ROLLED_DICE, PROC_REF(check_roll))
	RegisterSignal(parent, COMSIG_HUMAN_ON_CATCH_THROW, PROC_REF(check_throw))
	RegisterSignal(parent, COMSIG_ITEM_PICKUP, PROC_REF(check_pickup))

/datum/component/omen/UnregisterFromParent()
	UnregisterSignal(parent, list(COMSIG_ON_CARBON_SLIP, COMSIG_MOVABLE_MOVED, COMSIG_STUN_EFFECT_ACT, COMSIG_MOVED_DOWN_STAIRS, COMSIG_MOB_ROLLED_DICE, COMSIG_HUMAN_ON_CATCH_THROW, COMSIG_ITEM_PICKUP))

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

	if(!isliving(our_guy) || isbelly(our_guy.loc))
		return

	var/mob/living/living_guy = our_guy
	if(living_guy.is_incorporeal()) //no being unlucky if you don't even exist on the same plane.
		return

	if(evil && prob(0.0001) && (living_guy.stat != DEAD)) // 1 in a million
		living_guy.visible_message(span_danger("[living_guy] suddenly bursts into flames!"), span_danger("You suddenly burst into flames!"))
		living_guy.emote("scream")
		living_guy.adjust_fire_stacks(20)
		living_guy.ignite_mob()
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
			living_guy.Paralyse(5)
			living_guy.Sleeping(5)
			slam_airlock(darth_airlock)
			consume_omen()
			return

	for(var/turf/the_turf as anything in our_guy_pos.AdjacentTurfs(check_blockage = FALSE)) //need false so we can check disposal units
		if(iswall(the_turf))
			continue
		if(the_turf.CanZPass(our_guy, DOWN) && !isspace(the_turf))
			to_chat(living_guy, span_warning("You lose your balance and slip towards the edge!"))
			living_guy.Weaken(5)
			living_guy.throw_at(the_turf, 1, 20)
			consume_omen()
			return

		if(vorish)
			for(var/mob/living/living_mob in the_turf)
				if(living_mob == our_guy || (living_mob.vore_selected == living_guy.vore_selected))
					continue //Don't do anything to ourselves.
				if(living_mob.stat)
					continue
				if(!can_stumble_vore(living_guy, living_mob) && !can_stumble_vore(living_mob, living_guy)) //Works both ways! Either way, someone's getting eaten!
					continue
				living_mob.stumble_into(living_guy) //logic reversed here because the game is DUMB. This means that living_guy is stumbling into the target!
				living_guy.visible_message(span_danger("[living_guy] loses their balance and slips into [living_mob]!"), span_boldwarning("You lose your balance, slipping into [living_mob]!"))
				consume_omen()
				return

		for(var/obj/machinery/washing_machine/evil_washer in the_turf)
			if(evil_washer.state == 1) //Empty and open door
				our_guy.visible_message(span_danger("[our_guy] slips near the [evil_washer] and falls in, the door shutting!"), span_boldwarning("You slip on a wet spot near the [evil_washer] and fall in, the door shutting! You're stuck!"))
				our_guy.forceMove(evil_washer)
				evil_washer.washing += our_guy
				evil_washer.state = 4
				evil_washer.visible_message(span_danger("[evil_washer] begins its spin cycle!"))
				evil_washer.start(TRUE, damage_mod)
				consume_omen()
				return

		if((evil || safe_disposals) && living_guy.m_intent == I_RUN) //On servers without safe disposals, this is a death sentence. With servers with safe disposals, it's just funny. Either way, walk near disposals.
			for(var/obj/machinery/disposal/evil_disposal in the_turf)
				if(evil_disposal.stat & (BROKEN|NOPOWER))
					continue
				if(evil_disposal.loc == living_guy.loc) //Let's not do a continual loop of them falling into it as soon as they climb out, as funny as that is.
					continue
				our_guy.visible_message(span_danger("[our_guy] slips on a spill near the [evil_disposal] and falls in!"), span_boldwarning("You slip on a spill near the [evil_disposal] and fall in!"))
				living_guy.forceMove(evil_disposal)
				evil_disposal.flush = TRUE
				evil_disposal.update_icon()
				living_guy.Stun(5)
				consume_omen()
				return

		if(evil && prob(33)) //This has an additional 2 in 3 chance to not happen as there's a LOT of lights on stations. This should be rarer.
			for(var/obj/machinery/light/evil_light in the_turf)
				if((evil_light.status == LIGHT_BURNED || evil_light.status == LIGHT_BROKEN) || (living_guy.get_shock_protection() == 1)) // we can't do anything :(
					to_chat(living_guy, span_warning("[evil_light] sparks weakly for a second."))
					var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread //this shit is copy pasted all over the code...this needs to just be made into a proc at this point jesus christ
					s.set_up(4, FALSE, evil_light)
					s.start()
					//We don't clear the omen as nothing really happened.
					break

				to_chat(living_guy, span_warning("[evil_light] glows ominously...")) // ominously
				evil_light.visible_message(span_boldwarning("[evil_light] suddenly flares brightly and sparks!"))
				//evil_light.broken(skip_sound_and_sparks = FALSE) //Let's not break it actually.
				evil_light.Beam(living_guy, icon_state = "lightning[rand(1,12)]", time = 0.5 SECONDS)
				living_guy.electrocute_act(35 * (damage_mod * 0.5), evil_light, stun = TRUE) //Stun is binary and scales on damage..Lame.
				living_guy.emote("scream")
				consume_omen()
				return

		for(var/obj/machinery/vending/darth_vendor in the_turf)
			if(darth_vendor.stat & (BROKEN|NOPOWER))
				continue
			darth_vendor.visible_message(span_warning("[darth_vendor] suddenly clunks and the delivery chute raises up!"))
			darth_vendor.throw_item(living_guy)
			consume_omen()
			return

		for(var/obj/structure/mirror/evil_mirror in the_turf)
			to_chat(living_guy, span_warning("You pass by the mirror and glance at it..."))
			if(evil_mirror.shattered)
				to_chat(living_guy, span_notice("You feel lucky, somehow."))
				return
			var/mirror_rand
			if(evil)
				mirror_rand = rand(1,5)
			else
				mirror_rand = rand(1,3)
			switch(mirror_rand)
				if(1)
					to_chat(living_guy, span_boldwarning("You see your reflection, but it is grinning malevolently and staring directly at you!"))
					living_guy.emote("scream")
				if(2 to 3)
					to_chat(living_guy, span_large(span_cult("Oh god, you can't see your reflection!!")))
					living_guy.emote("scream")
				if(4 to 5)
					to_chat(living_guy, span_warning("The mirror explodes into a million pieces! Wait, does that mean you're even more unlucky?"))
					evil_mirror.shatter()
					if(prob(50 * effective_luck)) // sometimes
						luck_mod += 0.25
						damage_mod += 0.25
					var/max_health_coefficient = (living_guy.maxHealth * 0.06)
					for(var/obj/item/organ/external/limb in living_guy.organs)
						living_guy.apply_damage(max_health_coefficient * damage_mod, BRUTE, limb.organ_tag, used_weapon = "glass shrapnel")

			living_guy.make_jittery(250)
			if(evil && prob(7 * effective_luck))
				to_chat(living_guy, span_warning("You are completely shocked by this turn of events!"))
				if(ishuman(living_guy))
					var/mob/living/carbon/human/human_guy = living_guy
					if(human_guy.should_have_organ(O_HEART))
						for(var/obj/item/organ/internal/heart/heart in human_guy.internal_organs)
							heart.bruise() //Closest thing we have to a heart attack.
						to_chat(living_guy, span_boldwarning("You clutch at your heart!"))

			consume_omen()
			return
		if(evil)
			for(var/obj/item/reagent_containers/glass/beaker/evil_beaker in the_turf)
				if(!evil_beaker.is_open_container() && (evil_beaker.reagents.total_volume > 0)) //A closed beaker is a safe beaker!
					continue
				living_guy.visible_message(span_danger("[evil_beaker] tilts, spilling its contents on [living_guy]!"), span_bolddanger("[evil_beaker] spills all over you!"))
				evil_beaker.balloon_alert_visible("[evil_beaker]'s contents splashes onto [living_guy]!")
				evil_beaker.reagents.splash(living_guy, evil_beaker.reagents.total_volume)
				consume_omen()
				return

		for(var/obj/structure/table/evil_table in the_turf)
			if(!evil_table.material) //We only want tables, not just table frames.
				continue
			if(!prob(10)) //Reduce the chance further, due to the number of tables that are passed in normal play.
				continue
			living_guy.visible_message(span_danger("[living_guy] stubs [living_guy.p_their()] toe on [evil_table]!"), span_bolddanger("You stub your toe on [evil_table]!"))
			living_guy.apply_damage(2 * damage_mod, BRUTE, pick(BP_L_FOOT, BP_R_FOOT), used_weapon = "blunt force trauma")
			living_guy.adjustHalLoss(25) //It REALLY hurts.
			living_guy.Weaken(3)
			consume_omen()
			return
	//Ran out of turf options. Let's do more generic options.

	if(prob(luck_mod * 5))
		// In complete darkness
		if(our_guy_pos.get_lumcount() <= LIGHTING_SOFT_THRESHOLD)
			living_guy.Blind(5) //10 seconds of 'OH GOD WHAT'S HAPPENING'
			living_guy.silent = max(living_guy.silent, 5)
			living_guy.Paralyse(5)
			to_chat(living_guy, span_bolddanger("You feel the ground buckle underneath you, falling down, your vision going dark as you feel paralyzed in place!"))
			consume_omen()
			return


/datum/component/omen/proc/slam_airlock(obj/machinery/door/airlock/darth_airlock)
	SIGNAL_HANDLER
	. = darth_airlock.close(forced = TRUE, ignore_safties = TRUE, crush_damage = 15) //Not enough to cause any IB or massively injured organs.
	if(.)
		consume_omen()

/// If we get knocked down, see if we have a really bad slip and bash our head hard
/datum/component/omen/proc/check_slip(mob/living/our_guy, amount)
	SIGNAL_HANDLER

	if(prob(30)) // AAAA
		our_guy.emote("scream")
		to_chat(our_guy, span_cult("What a horrible night... To have a curse!"))

	if(prob(30 * luck_mod) && our_guy.get_bodypart_name(BP_HEAD)) /// Bonk!
		playsound(our_guy, 'sound/effects/tableheadsmash.ogg', 90, TRUE)
		our_guy.visible_message(span_danger("[our_guy] hits [our_guy.p_their()] head really badly falling down!"), span_bolddanger("You hit your head really badly falling down!"))
		var/max_health_coefficient = (our_guy.maxHealth * 0.5)
		our_guy.apply_damage(max_health_coefficient * damage_mod, BRUTE, BP_HEAD, used_weapon = "slipping")
		if(ishuman(our_guy))
			var/mob/living/carbon/human/human_guy = our_guy
			if(human_guy.should_have_organ(O_BRAIN))
				for(var/obj/item/organ/internal/brain/brain in human_guy.internal_organs)
					brain.take_damage(30 * damage_mod) //60 damage kills.
			if(human_guy.glasses && human_guy.canUnEquip(human_guy.glasses))
				var/turf/T = get_turf(human_guy)
				if(T)
					var/obj/item/our_glasses = human_guy.glasses
					human_guy.unEquip(human_guy.glasses, target = T)
					to_chat(human_guy, span_warning("Your glasses fly off as you hit the ground!"))
					our_glasses.throw_at_random(FALSE, 3, 2)
		consume_omen()

	return

/datum/component/omen/proc/check_roll(mob/living/unlucky_soul, var/obj/item/dice/the_dice, silent, result)
	SIGNAL_HANDLER
	if(prob(20 * luck_mod))
		//unlucky_soul.visible_message(span_danger("[unlucky_soul] rolls [the_dice] with it landing on the edge of [result] before tilting over!"), span_boldwarning("You feel dreadfully unlucky as you roll the dice!"))
		//I had thought about making this have a notice that it happened.
		//However, gaslighting the user by providing no visible notice is MUCH funnier.
		return 1 // We override the roll to a 1.

///Returns TRUE and stops us from catching
/datum/component/omen/proc/check_throw(mob/living/unlucky_soul, source, speed)
	SIGNAL_HANDLER
	if(prob(30 * luck_mod)) //~9% chance
		if(istype(source, /obj/item/grenade))
			var/obj/item/grenade/bad_grenade = source
			if(bad_grenade.active)
				unlucky_soul.put_in_active_hand(bad_grenade)
				unlucky_soul.visible_message(span_warning("[src] catches [source] as it goes off in their hand!"), span_bolddanger("You catch [source] and it goes off in your hand!"))
				unlucky_soul.throw_mode_off()
				bad_grenade.detonate()
				return TRUE
		else
			unlucky_soul.visible_message(span_attack("[unlucky_soul] tries to catch [source] and fumbles it, getting thrown back!"))
			unlucky_soul.Weaken(5)
			return TRUE

/*
 * Dynamic injury system for when you pick up objects!
 * Some objects might cut, burn, or otherwise injure you if you pick them up!
 * Genenerally more of an annoyance than anything.
 * Variables that can be changed:
 * injury_type, damage_to_inflict, damage_type, injury_verb, is_sharp, is_edge.
*/
/datum/component/omen/proc/check_pickup(mob/living/unlucky_soul, obj/item/item)
	SIGNAL_HANDLER
	if(prob(3 * luck_mod) && ishuman(unlucky_soul)) // ~3% chance
		var/mob/living/carbon/human/unlucky_human = unlucky_soul

		///What the injury will show up as on an autopsy.
		var/injury_type = "injury"

		///How much damage we'll inflect.
		var/damage_to_inflict = 0

		///What type of damage we'll inflict
		var/damage_type = BRUTE

		///If the item we get injured on has is sharp.
		var/is_sharp = FALSE

		///If the item we get injured on has an edge.
		var/has_edge = FALSE

		///What verb we use to describe the injury.
		var/injury_verb = "cuts"

		///What hand we are currently using, so we injure the correct one.
		var/current_hand = BP_R_HAND
		if(unlucky_human.hand)
			current_hand = BP_L_HAND

		if(istype(item, /obj/item/paper))
			injury_verb = "cuts"
			injury_type = "paper cut"
			damage_to_inflict = 2

		else if(istype(item, /obj/item/material/knife))
			var/obj/item/material/knife = item

			injury_verb = "cuts"
			injury_type = "knife"
			is_sharp = knife.sharp
			has_edge = knife.edge
			damage_to_inflict = knife.force

		else if(istype(item, /obj/item/material/shard))
			var/obj/item/material/shard/shard = item

			injury_verb = "cuts"
			injury_type = "shard"
			is_sharp = shard.sharp
			has_edge = shard.edge
			damage_to_inflict = shard.force

		else if(istype(item, /obj/item/flame/lighter))
			var/obj/item/flame/lighter/lighter = item
			if(!lighter.lit)
				return

			injury_verb = "burns"
			injury_type = "lighter"
			damage_type = BURN
			damage_to_inflict = 5

		else if(istype(item, /obj/item/tool/transforming/jawsoflife))
			var/obj/item/tool/transforming/jawsoflife/jaws = item

			injury_verb = "clamps"
			injury_type = "industrial tool"
			is_sharp = jaws.sharp
			has_edge = jaws.edge
			damage_to_inflict = jaws.force

		else if(istype(item, /obj/item/tool/screwdriver))
			var/obj/item/tool/screwdriver/screwdriver = item

			injury_verb = "stabs"
			injury_type = "industrial tool"
			is_sharp = screwdriver.sharp
			has_edge = screwdriver.edge
			damage_to_inflict = screwdriver.force

		else if(istype(item, /obj/item/tool/wirecutters))
			var/obj/item/tool/wirecutters/wirecutters = item

			injury_verb = "nips"
			injury_type = "industrial tool"
			is_sharp = wirecutters.sharp
			has_edge = wirecutters.edge
			damage_to_inflict = wirecutters.force

		if(!damage_to_inflict)
			return

		unlucky_human.visible_message(span_danger("[unlucky_human] accidentally [injury_verb] [unlucky_human.p_their()] hand on [item]!"))
		unlucky_human.apply_damage(damage_to_inflict * damage_mod, damage_type, current_hand, sharp = is_sharp, edge = has_edge, used_weapon = injury_type)

/datum/component/omen/proc/check_stairs(mob/living/unlucky_soul)
	SIGNAL_HANDLER
	if(prob(3 * luck_mod)) /// Bonk!
		playsound(unlucky_soul, 'sound/effects/tableheadsmash.ogg', 90, TRUE)
		unlucky_soul.visible_message(span_danger("One of the stairs give way as [unlucky_soul] steps onto it, tumbling them down to the bottom!"), span_bolddanger("A stair gives way and you trip to the bottom!"))
		var/max_health_coefficient = (unlucky_soul.maxHealth * 0.09)
		for(var/obj/item/organ/external/limb in unlucky_soul.organs) //In total, you should have 11 limbs (generally, unless you have an amputation). The full omen variant we want to leave you at 1 hp, the trait version less. As of writing, the trait version is 25% of the damage, so you take 24.75 across all limbs.
			unlucky_soul.apply_damage(max_health_coefficient * damage_mod, BRUTE, limb.organ_tag, used_weapon = "slipping")
		unlucky_soul.Weaken(5)
		consume_omen()

/datum/component/omen/proc/check_taser(mob/living/unlucky_soul, stun_amount, agony_amount, def_zone, used_weapon, electric)
	SIGNAL_HANDLER
	if(!electric || !evil) //If it's not electric we don't care! Likewise, if we don't have the evil variant, don't care!
		return
	if(!ishuman(unlucky_soul))
		return
	if(prob(3 * luck_mod))
		var/mob/living/carbon/human/human_guy = unlucky_soul
		if(human_guy.should_have_organ(O_HEART))
			for(var/obj/item/organ/internal/heart/heart in human_guy.internal_organs)
				if(heart.robotic)
					continue //Robotic hearts are immune to this.
				heart.take_damage(10 * stun_amount * damage_mod)
				heart.take_damage(0.25 * agony_amount * damage_mod)
			playsound(src, 'sound/effects/singlebeat.ogg', 50, FALSE)
			to_chat(unlucky_soul, span_bolddanger("You feel as though your heart stopped"))
			human_guy.Stun(5)
			consume_omen()
			return

/**
 * The trait omen. Permanent.
 * Has only a 30% chance of bad things happening, and takes only 25% of normal damage.
 * Evil is false, so you get less dramatic things happening.
 */
/datum/component/omen/trait
	incidents_left = INFINITY
	dupe_type = /datum/component/omen/trait
	luck_mod = 0.3 // 30% chance of bad things happening
	damage_mod = 0.25 // 25% of normal damage
	evil = FALSE
	safe_disposals = FALSE

///Major variant of the trait.
/datum/component/omen/trait/major
	evil = TRUE
	damage_mod = 0.75 //75% of normal damage

///Variant trait for downstreams that have safe disposals.
/datum/component/omen/trait/safe_disposals
	safe_disposals = TRUE

/datum/component/omen/trait/safe_disposals/major
	evil = TRUE
	damage_mod = 0.75 //75% of normal damage

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
