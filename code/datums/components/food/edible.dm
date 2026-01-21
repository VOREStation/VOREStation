/datum/component/edible
	dupe_mode = COMPONENT_DUPE_ALLOWED
	var/bitesize = 1
	var/bitecount = 0
	var/list/eatverbs
	var/datum/callback/after_eat
	var/datum/callback/on_consume

/datum/component/edible/Initialize(
	list/initial_reagents,
	bitesize = 1,
	list/eatverbs = list("bite", "chew", "nibble", "gnaw", "gobble", "chomp"),
	datum/callback/after_eat,
	datum/callback/on_consume
)
	if(!isatom(parent))
		return COMPONENT_INCOMPATIBLE

	src.bitesize = bitesize
	src.eatverbs = eatverbs

/datum/component/edible/RegisterWithParent()
	RegisterSignal(parent, COMSIG_ITEM_ATTACK, PROC_REF(TryToEat))

/datum/component/edible/UnregisterFromParent()
	UnregisterSignal(parent, COMSIG_ITEM_ATTACK)

/datum/component/edible/proc/TryToEat(datum/source, mob/living/eater, mob/user)
	SIGNAL_HANDLER

	return TryToFeed(eater, user)

/datum/component/edible/proc/TryToFeed(mob/living/eater, mob/user)
	if(!isfood(parent))
		return FALSE
	var/obj/item/food/owner = parent
	if(owner.reagents && !owner.reagents.total_volume)
		owner.balloon_alert(user, "none of \the [parent] left!")
		user.drop_from_inventory(parent)
		qdel(parent)
		return FALSE

	if(owner.package)
		owner.balloon_alert(user, "the package is in the way!")
		return FALSE

	if(istype(eater, /mob/living/carbon))
		//TODO: replace with standard_feed_mob() call.

		if(!eater.consume_liquid_belly)
			if(owner.liquid_belly_check())
				to_chat(user, span_infoplain("[user == eater ? "You can't" : "\The [eater] can't"] consume that, it contains something produced from a belly!"))
				return FALSE
		var/swallow_whole = FALSE
		var/obj/belly/belly_target				// These are surprise tools that will help us later

		var/fullness = eater.nutrition + (eater.reagents.get_reagent_amount(REAGENT_ID_NUTRIMENT) * 25)
		if(eater == user)								//If you're eating it yourself
			if(ishuman(eater))
				var/mob/living/carbon/human/human_eater = eater
				if(!human_eater.check_has_mouth())
					owner.balloon_alert(user, "you don't have a mouth!")
					return
				var/obj/item/blocked = null
				if(owner.survivalfood)
					blocked = human_eater.check_mouth_coverage_survival()
				else
					blocked = human_eater.check_mouth_coverage()
				if(blocked)
					owner.balloon_alert(user, "\the [blocked] is in the way!")
					return

			user.setClickCooldown(user.get_attack_speed(parent)) //puts a limit on how fast people can eat/drink things
			if (fullness <= 50)
				to_chat(eater, span_danger("You hungrily chew out a piece of [parent] and gobble it!"))
			if (fullness > 50 && fullness <= 150)
				to_chat(eater, span_notice("You hungrily begin to eat [parent]."))
			if (fullness > 150 && fullness <= 350)
				to_chat(eater, span_notice("You take a bite of [parent]."))
			if (fullness > 350 && fullness <= 550)
				to_chat(eater, span_notice("You chew a bit of [parent], despite feeling rather full."))
			if (fullness > 550 && fullness <= 650)
				to_chat(eater, span_notice("You swallow some more of the [parent], causing your belly to swell out a little."))
			if (fullness > 650 && fullness <= 1000)
				to_chat(eater, span_notice("You stuff yourself with the [parent]. Your stomach feels very heavy."))
			if (fullness > 1000 && fullness <= 3000)
				to_chat(eater, span_notice("You swallow down the hunk of [parent]. Surely you have to have some limits?"))
			if (fullness > 3000 && fullness <= 5500)
				to_chat(eater, span_danger("You force the piece of [parent] down. You can feel your stomach getting firm as it reaches its limits."))
			if (fullness > 5500 && fullness <= 6000)
				to_chat(eater, span_danger("You glug down the bite of [parent], you are reaching the very limits of what you can eat, but maybe a few more bites could be managed..."))
			if (fullness > 6000) // There has to be a limit eventually.
				to_chat(eater, span_danger("Nope. That's it. You literally cannot force any more of [parent] to go down your throat. It's fair to say you're full."))
				return FALSE

		else if(user.a_intent == I_HURT)
			return FALSE

		else
			if(ishuman(eater))
				var/mob/living/carbon/human/human_eater = eater
				if(!human_eater.check_has_mouth())
					owner.balloon_alert(user, "\the [human_eater] doesn't have a mouth!")
					return
				var/obj/item/blocked = null
				var/unconcious = FALSE
				blocked = human_eater.check_mouth_coverage()
				if(owner.survivalfood)
					blocked = human_eater.check_mouth_coverage_survival()
					if(human_eater.stat && human_eater.check_mouth_coverage())
						unconcious = TRUE
						blocked = human_eater.check_mouth_coverage()

				if(isliving(user))	// We definitely are, but never hurts to check
					var/mob/living/feeder = user
					swallow_whole = feeder.stuffing_feeder
				if(swallow_whole)
					belly_target = tgui_input_list(user, "Choose Belly", "Belly Choice", human_eater.feedable_bellies())

				if(unconcious)
					to_chat(user, span_warning("You can't feed [human_eater] through \the [blocked] while they are unconcious!"))
					return

				if(blocked)
					// to_chat(user, span_warning("\The [blocked] is in the way!"))
					owner.balloon_alert(user, "\the [blocked] is in the way!")
					return

				if(swallow_whole)
					if(!(human_eater.feeding))
						owner.balloon_alert(user, "you can't feed [human_eater] a whole [parent] as they refuse to be fed whole things!")
						return
					if(!belly_target)
						owner.balloon_alert(user, "you can't feed [human_eater] a whole [parent] as they don't appear to have a belly to fit it!")
						return

				if(swallow_whole)
					user.balloon_alert_visible("[user] attempts to make [human_eater] consume [parent] whole into their [belly_target].")
				else
					user.balloon_alert_visible("[user] attempts to feed [human_eater] [parent].")

				var/feed_duration = 3 SECONDS
				if(swallow_whole)
					feed_duration = 5 SECONDS

				user.setClickCooldown(user.get_attack_speed(parent))
				if(!do_after(user, feed_duration, human_eater)) return
				if(!owner.reagents || (owner.reagents && !owner.reagents.total_volume)) return

				if(swallow_whole && !belly_target) return			// Just in case we lost belly mid-feed

				if(swallow_whole)
					add_attack_logs(user, human_eater,"Whole-fed with [owner.name] containing [owner.reagentlist(parent)] into [belly_target]", admin_notify = FALSE)
					user.visible_message("[user] successfully forces [parent] into [human_eater]'s [belly_target].")
					user.balloon_alert_visible("forces [parent] into [human_eater]'s [belly_target]")
				else
					add_attack_logs(user, human_eater,"Fed with [owner.name] containing [owner.reagentlist(parent)]", admin_notify = FALSE)
					user.visible_message("[user] feeds [human_eater] [parent].")
					user.balloon_alert_visible("feeds [human_eater] [parent].")

			else
				owner.balloon_alert(user, "this creature does not seem to have a mouth!")
				return

		if(swallow_whole)
			user.drop_item()
			owner.forceMove(belly_target)
			return TRUE
		else if(owner.reagents)								//Handle ingestion of the reagent.
			owner.feed_sound(eater)
			if(owner.reagents.total_volume)
				var/bite_mod = 1
				var/mob/living/carbon/human/human_eater = eater
				if(istype(human_eater))
					bite_mod = human_eater.species.bite_mod
				if(owner.reagents.total_volume > bitesize * bite_mod)
					owner.reagents.trans_to_mob(eater, bitesize * bite_mod, CHEM_INGEST)
				else
					owner.reagents.trans_to_mob(eater, owner.reagents.total_volume, CHEM_INGEST)
				owner.bitecount++
				owner.On_Consume(eater, user)
			return TRUE

	return FALSE
