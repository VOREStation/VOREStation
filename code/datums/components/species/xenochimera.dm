/datum/component/xenochimera
	VAR_PRIVATE/laststress = 0
	VAR_PRIVATE/mob/living/carbon/human/owner
	var/feral = 0
	var/revive_ready = REVIVING_READY
	var/revive_finished = FALSE
	VAR_PRIVATE/regen_sounds = list(
		'sound/effects/mob_effects/xenochimera/regen_1.ogg',
		'sound/effects/mob_effects/xenochimera/regen_2.ogg',
		'sound/effects/mob_effects/xenochimera/regen_4.ogg',
		'sound/effects/mob_effects/xenochimera/regen_3.ogg',
		'sound/effects/mob_effects/xenochimera/regen_5.ogg'
	)
	VAR_PRIVATE/datum/transhuman/body_record/revival_record

/datum/component/xenochimera/Initialize()
	if(!ishuman(parent))
		return COMPONENT_INCOMPATIBLE
	owner = parent
	RegisterSignal(owner, COMSIG_XENOCHIMERA_COMPONENT, PROC_REF(handle_comp))
	RegisterSignal(owner, COMSIG_HUMAN_DNA_FINALIZED, PROC_REF(handle_record))
	add_verb(owner, /mob/living/carbon/human/proc/reconstitute_form)

/datum/component/xenochimera/Destroy(force)
	UnregisterSignal(owner, COMSIG_XENOCHIMERA_COMPONENT)
	UnregisterSignal(owner, COMSIG_HUMAN_DNA_FINALIZED)
	remove_verb(owner, /mob/living/carbon/human/proc/reconstitute_form)
	qdel_null(revival_record)
	owner = null
	. = ..()

/datum/component/xenochimera/proc/handle_record()
	SIGNAL_HANDLER
	if(QDELETED(owner))
		return
	qdel_null(revival_record)
	revival_record = new(owner)

/datum/component/xenochimera/proc/handle_comp()
	SIGNAL_HANDLER
	if(QDELETED(owner))
		return
	handle_feralness()
	handle_regeneration()

/datum/component/xenochimera/proc/handle_regeneration()
	if(revive_ready == REVIVING_NOW || revive_ready == REVIVING_DONE)
		owner.stunned = 5
		owner.canmove = 0
		owner.does_not_breathe = TRUE
		if(prob(2)) // 2% chance of playing squelchy noise while reviving, which is run roughly every 2 seconds/tick while regenerating.
			playsound(owner, pick(regen_sounds), 30)
			owner.visible_message(span_danger("<p>" + span_huge("[owner.name]'s motionless form shudders grotesquely, rippling unnaturally.") + "</p>"))
		if(!owner.lying)
			owner.lay_down()

/datum/component/xenochimera/proc/set_revival_delay(var/time)
	revive_ready = REVIVING_NOW
	revive_finished = (world.time + time SECONDS) // When do we finish reviving? Allows us to find out when we're done, called by the alert currently.

/datum/component/xenochimera/proc/trigger_revival(var/from_save_slot)
	ASSERT(revival_record)
	if(owner.isSynthetic())
		revival_record.revive_xenochimera(owner,TRUE,from_save_slot)
	else
		revival_record.revive_xenochimera(owner,FALSE,from_save_slot)
	if(from_save_slot)
		handle_record() // Update record

/datum/component/xenochimera/proc/handle_feralness()
	//first, calculate how stressed the chimera is

	//Low-ish nutrition has messages and can eventually cause feralness
	var/hunger = max(0, 150 - owner.nutrition)

	//pain makes feralness a thing
	var/shock = 0.75*owner.traumatic_shock

	//Caffeinated or otherwise overexcited xenochimera can become feral and have special messages
	var/jittery = max(0, owner.jitteriness - 100)

	//Are we in danger of ferality?
	var/danger = FALSE
	var/feral_state = FALSE

	//finally, calculate the current stress total the chimera is operating under, and the cause
	var/currentstress = (hunger + shock + jittery)
	var/cause = "stress"
	if(hunger > shock && hunger > jittery)
		cause = "hunger"
	else if (shock > hunger && shock > jittery)
		cause = "shock"
	else if (jittery > shock && jittery > hunger)
		cause = "jittery"

	//check to see if they go feral if they weren't before
	if(!feral && !isbelly(owner.loc))
		// if stress is below 15, no chance of snapping. Also if they weren't feral before, they won't suddenly become feral unless they get MORE stressed
		if((currentstress > laststress) && prob(clamp(currentstress-15, 0, 100)) )
			go_feral(currentstress, cause)
			feral = currentstress //update the local var

		//they didn't go feral, give 'em a chance of hunger messages
		else if(owner.nutrition <= 200 && prob(0.5))
			switch(owner.nutrition)
				if(150 to 200)
					to_chat(owner,span_info("You feel rather hungry. It might be a good idea to find some some food..."))
				if(100 to 150)
					to_chat(owner,span_warning("You feel like you're going to snap and give in to your hunger soon... It would be for the best to find some [pick("food","prey")] to eat..."))
					danger = TRUE

	//now the check's done, update their brain so it remembers how stressed they were
	if(!isbelly(owner.loc)) //another sanity check for brain implant shenanigans, also no you don't get to hide in a belly and get your laststress set to a huge amount to skip rolls
		laststress = currentstress

	// Handle being feral
	if(feral)
		//We're feral
		feral_state = TRUE

		//If they're still stressed, they stay feral
		if(currentstress >= 15)
			danger = TRUE
			feral = max(feral, currentstress)

		else
			feral = max(0,--feral)

			// Being in a belly or in the darkness decreases stress further. Helps mechanically reward players for staying in darkness + RP'ing appropriately. :9
			var/turf/T = get_turf(owner)
			if(feral && (isbelly(owner.loc) || T.get_lumcount() <= 0.1))
				feral = max(0,--feral)

		//Did we just finish being feral?
		if(!feral)
			feral_state = FALSE
			to_chat(owner,span_info("Your thoughts start clearing, your feral urges having passed - for the time being, at least."))
			log_and_message_admins("is no longer feral.", owner)
			update_xenochimera_hud(owner, danger, feral_state)
			return

		//If they lose enough health to hit softcrit, handle_shock() will keep resetting this. Otherwise, pissed off critters will lose shock faster than they gain it.
		owner.shock_stage = max(owner.shock_stage-(feral/20), 0)

		//Handle light/dark areas
		var/turf/T = get_turf(owner)
		if(!T)
			update_xenochimera_hud(owner, danger, feral_state)
			return //Nullspace
		var/darkish = T.get_lumcount() <= 0.1

		//Don't bother doing heavy lifting if we weren't going to give emotes anyway.
		if(!prob(1))

			//This is basically the 'lite' version of the below block.
			var/list/nearby = owner.living_mobs(world.view)

			//Not in the dark, or a belly, and out in the open.
			if(!darkish && isturf(owner.loc) && !isbelly(owner.loc)) // Added specific check for if in belly

				//Always handle feral if nobody's around and not in the dark.
				if(!nearby.len)
					handle_feral()

				//Rarely handle feral if someone is around
				else if(prob(1))
					handle_feral()

			//And bail
			update_xenochimera_hud(owner, danger, feral_state)
			return

		// In the darkness, or "hidden", or in a belly. No need for custom scene-protection checks as it's just an occational infomessage.
		if(darkish || !isturf(owner.loc) || isbelly(owner.loc)) // Specific check for if in belly. !isturf should do this, but JUST in case.
			// If hurt, tell 'em to heal up
			if (cause == "shock")
				to_chat(owner,span_info("This place seems safe, secure, hidden, a place to lick your wounds and recover..."))

			//If hungry, nag them to go and find someone or something to eat.
			else if(cause == "hunger")
				to_chat(owner,span_info("Secure in your hiding place, your hunger still gnaws at you. You need to catch some food..."))

			//If jittery, etc
			else if(cause == "jittery")
				to_chat(owner,span_info("sneakysneakyyesyesyescleverhidingfindthingsyessssss"))

			//Otherwise, just tell them to keep hiding.
			else
				to_chat(owner,span_info("...safe..."))

		// NOT in the darkness
		else

			//Twitch twitch
			if(!owner.stat)
				owner.emote("twitch")

			var/list/nearby = owner.living_mobs(world.view)

			// Someone/something nearby
			if(nearby.len)
				var/M = pick(nearby)
				if(cause == "shock")
					to_chat(owner,span_danger("You're hurt, in danger, exposed, and [M] looks to be a little too close for comfort..."))
				else
					to_chat(owner,span_danger("Every movement, every flick, every sight and sound has your full attention, your hunting instincts on high alert... In fact, [M] looks extremely appetizing..."))

			// Nobody around
			else
				if(cause == "hunger")
					to_chat(owner,span_danger("Confusing sights and sounds and smells surround you - scary and disorienting it may be, but the drive to hunt, to feed, to survive, compels you."))
				else if(cause == "jittery")
					to_chat(owner,span_danger("yesyesyesyesyesyesgetthethingGETTHETHINGfindfoodsfindpreypounceyesyesyes"))
				else
					to_chat(owner,span_danger("Confusing sights and sounds and smells surround you, this place is wrong, confusing, frightening. You need to hide, go to ground..."))

	// HUD update time
	update_xenochimera_hud(danger, feral_state)

/datum/component/xenochimera/proc/update_xenochimera_hud(var/danger, var/feral)
	if(owner.xenochimera_danger_display)
		owner.xenochimera_danger_display.invisibility = INVISIBILITY_NONE
		if(danger && feral)
			owner.xenochimera_danger_display.icon_state = "danger11"
		else if(danger && !feral)
			owner.xenochimera_danger_display.icon_state = "danger10"
		else if(!danger && feral)
			owner.xenochimera_danger_display.icon_state = "danger01"
		else
			owner.xenochimera_danger_display.icon_state = "danger00"

	return

/datum/component/xenochimera/proc/go_feral(var/stress, var/cause)
	// Going feral due to hunger
	if(cause == "hunger")
		to_chat(owner,span_danger(span_large("Something in your mind flips, your instincts taking over, no longer able to fully comprehend your surroundings as survival becomes your primary concern - you must feed, survive, there is nothing else. Hunt. Eat. Hide. Repeat.")))
		log_and_message_admins("has gone feral due to hunger.", owner)

	// If they're hurt, chance of snapping.
	else if(cause == "shock")
		//If the majority of their shock is due to halloss, give them a different message (3x multiplier on check as halloss is 2x - meaning t_s must be at least 3x for other damage sources to be the greater part)
		if(3*owner.halloss >= owner.traumatic_shock)
			to_chat(owner,span_danger(span_large("The pain! It stings! Got to get away! Your instincts take over, urging you to flee, to hide, to go to ground, get away from here...")))
			log_and_message_admins("has gone feral due to halloss.", owner)

		//Majority due to other damage sources
		else
			to_chat(owner,span_danger(span_large("Your fight-or-flight response kicks in, your injuries too much to simply ignore - you need to flee, to hide, survive at all costs - or destroy whatever is threatening you.")))
			log_and_message_admins("has gone feral due to injury.", owner)

	//No hungry or shock, but jittery
	else if(cause == "jittery")
		to_chat(owner,span_warning(span_large("Suddenly, something flips - everything that moves is... potential prey. A plaything. This is great! Time to hunt!")))
		log_and_message_admins("has gone feral due to jitteriness.", owner)

	else // catch-all just in case something weird happens
		to_chat(owner,span_warning(span_large("The stress of your situation is too much for you, and your survival instincts kick in!")))
		log_and_message_admins("has gone feral for unknown reasons.", owner)
	//finally, set their feral var
	feral = stress
	if(!owner.stat)
		owner.emote("twitch")

/datum/component/xenochimera/proc/handle_feral()
	if(QDELETED(owner) || owner.get_hallucination_component() || !owner.client || feral < XENOCHIFERAL_THRESHOLD)
		return
	owner.LoadComponent(/datum/component/hallucinations/xenochimera)

/obj/screen/xenochimera
	icon = 'icons/mob/chimerahud.dmi'
	invisibility = INVISIBILITY_ABSTRACT

/obj/screen/xenochimera/danger_level
	name = "danger level"
	icon_state = "danger00"		//first number is bool of whether or not we're in danger, second is whether or not we're feral
	alpha = 200

/mob/living/carbon/human/proc/reconstitute_form() //Scree's race ability.in exchange for: No cloning.
	set name = "Reconstitute Form"
	set category = "Abilities.Xenochimera"
	var/datum/component/xenochimera/xc = get_xenochimera_component()
	if(!xc)
		return
	if(is_incorporeal())
		to_chat(src, "You cannot regenerate while incorporeal.")
		return
	// Sanity is mostly handled in chimera_regenerate()
	if(stat == DEAD)
		var/confirm = tgui_alert(src, "Are you sure you want to regenerate your corpse? This process can take up to thirty minutes. Additionally, you may regenerate your appearance based on your current form or the appearance of the currently loaded slot.", "Confirm Regeneration", list("Yes", "No"))
		if(confirm == "Yes")
			xc.chimera_regenerate()
	else if(quickcheckuninjured())
		var/confirm = tgui_alert(src, "Are you sure you want to regenerate? As you are uninjured this will only take 30 seconds. Additionally, you may regenerate your appearance based on your current form or the appearance of the currently loaded slot.", "Confirm Regeneration", list("Yes", "No"))
		if(confirm == "Yes")
			xc.chimera_regenerate()
	else
		var/confirm = tgui_alert(src, "Are you sure you want to completely reconstruct your form? This process can take up to fifteen minutes, depending on how hungry you are, and you will be unable to move. Additionally, you may regenerate your appearance based on your current form or the appearance of the currently loaded slot", "Confirm Regeneration", list("Yes", "No"))
		if(confirm == "Yes")
			xc.chimera_regenerate()

/datum/component/xenochimera/proc/chimera_regenerate()
	if(!owner)
		return
	//If they're already regenerating
	switch(revive_ready)
		if(REVIVING_NOW)
			to_chat(owner, "You are already reconstructing, just wait for the reconstruction to finish!")
			return
		if(REVIVING_DONE)
			to_chat(owner, "Your reconstruction is done, but you need to hatch now.")
			return
	if(revive_ready > world.time)
		to_chat(owner, "You can't use that ability again so soon!")
		return

	var/time = min(900, (120+780/(1 + owner.nutrition/100))) //capped at 15 mins, roughly 6 minutes at 250 (yellow) nutrition, 4.1 minutes at 500 (grey), cannot be below 2 mins
	if (owner.quickcheckuninjured()) //if you're completely uninjured, then you get a speedymode - check health first for quickness
		time = 30

	//Clicked regen while dead.
	if(owner.stat == DEAD)

		//reviving from dead takes extra nutriment to be provided from outside OR takes twice as long and consumes extra at the end
		if(!owner.hasnutriment())
			time = time*2

		to_chat(owner, "You begin to reconstruct your form. You will not be able to move during this time. It should take aproximately [round(time)] seconds.")

		//Scary spawnerization.
		set_revival_delay(time)
		owner.throw_alert("regen", /obj/screen/alert/xenochimera/reconstitution)
		addtimer(CALLBACK(src, PROC_REF(chimera_regenerate_ready)), time SECONDS, TIMER_DELETE_ME)

	//Clicked regen while NOT dead
	else
		to_chat(owner, "You begin to reconstruct your form. You will not be able to move during this time. It should take aproximately [round(time)] seconds.")

		//Waiting for regen after being alive
		set_revival_delay(time)
		owner.throw_alert("regen", /obj/screen/alert/xenochimera/reconstitution)
		addtimer(CALLBACK(src, PROC_REF(chimera_regenerate_nutrition)), time SECONDS, TIMER_DELETE_ME)
	owner.lying = TRUE
	// open_appearance_editor()

/datum/component/xenochimera/proc/chimera_regenerate_nutrition()
	if(!owner)
		return
	//Slightly different flavour messages
	if(owner.stat != DEAD || owner.hasnutriment())
		to_chat(owner, span_notice("Consciousness begins to stir as your new body awakens, ready to hatch.."))
	else
		to_chat(owner, span_warning("Consciousness begins to stir as your battered body struggles to recover from its ordeal.."))
	add_verb(owner, /mob/living/carbon/human/proc/hatch)
	revive_ready = REVIVING_DONE
	owner << sound('sound/effects/mob_effects/xenochimera/hatch_notification.ogg',0,0,0,30)
	owner.clear_alert("regen")
	owner.throw_alert("hatch", /obj/screen/alert/xenochimera/readytohatch)

/datum/component/xenochimera/proc/chimera_regenerate_ready()
	if(!owner)
		return
	// check to see if they've been fixed by outside forces in the meantime such as defibbing
	if(owner.stat != DEAD)
		to_chat(owner, span_notice("Your body has recovered from its ordeal, ready to regenerate itself again."))
		revive_ready = REVIVING_READY //reset their cooldown
		owner.clear_alert("regen")
		owner.throw_alert("hatch", /obj/screen/alert/xenochimera/readytohatch)

	// Was dead, still dead.
	else
		to_chat(owner, span_notice("Consciousness begins to stir as your new body awakens, ready to hatch."))
		add_verb(owner, /mob/living/carbon/human/proc/hatch)
		revive_ready = REVIVING_DONE
		owner << sound('sound/effects/mob_effects/xenochimera/hatch_notification.ogg',0,0,0,30)
		owner.clear_alert("regen")
		owner.throw_alert("hatch", /obj/screen/alert/xenochimera/readytohatch)

/mob/living/carbon/human/proc/hatch()
	set name = "Hatch"
	set category = "Abilities.Xenochimera"
	var/datum/component/xenochimera/xc = get_xenochimera_component()
	if(!xc)
		return
	if(xc.revive_ready != REVIVING_DONE)
		return //Hwhat?

	// Default is use internal record, even if closes menu
	var/reload_slot = tgui_alert(src, "Regenerate from your current form, or from the appearance of your current character slot(This will not change your current species or traits.)", "Regenerate Form", list("Current Form", "From Slot"))

	// Check if valid to load from this slot
	var/from_slot = ""
	from_slot = "You'll hatch using your current appearance"
	if(reload_slot == "From Slot" && client)
		if(client.prefs.species == SPECIES_PROTEAN) // Exploit protection
			to_chat(src,span_warning("You cannot copy nanoform prosthetic limbs from this species. Please try another character."))
			return
		var/slot_is_synth = ((O_BRAIN in client.prefs.organ_data) && client.prefs.organ_data[O_BRAIN])
		if(slot_is_synth && !isSynthetic()) // Prevents some pretty weird situations
			to_chat(src,span_warning("Cannot apply character appearance. [slot_is_synth ? "The slot's character is synthetic." : "The slot's character is organic."] Slot must match the current body's synthetic state. Please try another character."))
			return
		from_slot = "You'll hatch using [client.prefs.real_name]'s appearance"

	var/confirm = tgui_alert(src, "Are you sure you want to hatch right now? This will be very obvious to anyone in view. [from_slot]! Are you sure?", "Confirm Regeneration", list("Yes", "No"))
	if(confirm == "Yes")

		///This makes xenochimera shoot out their robotic limbs if they're not a FBP.
		if(!isSynthetic()) //If we aren't repairing robotic limbs (FBP) we reject any robot limbs we have and kick them out!
			for(var/O in organs_by_name)
				var/obj/item/organ/external/organ = organs_by_name[O]
				if(!istype(organ, /obj/item/organ/external))
					continue
				if(!organ.robotic)
					continue
				else
					organ.removed()
		///End of xenochimera limb rejection code.

		//Dead when hatching
		var/sickness_duration = 10 MINUTES
		var/has_braindamage = FALSE
		if(stat == DEAD)
			//Reviving from ded takes extra nutrition - if it isn't provided from outside sources, it comes from you
			if(!hasnutriment())
				nutrition=nutrition * 0.75
				sickness_duration = 20 MINUTES
			has_braindamage = TRUE

		// Finalize!
		remove_verb(src, /mob/living/carbon/human/proc/hatch)
		clear_alert("hatch")
		xc.chimera_hatch((reload_slot == "From Slot" && client))
		visible_message(span_warning(span_huge("[src] rises to \his feet."))) //Bloody hell...
		if(has_braindamage)
			add_modifier(/datum/modifier/resleeving_sickness/chimera, sickness_duration)
			adjustBrainLoss(5) // if they're reviving from dead, they come back with 5 brainloss on top of whatever's unhealed.

/datum/component/xenochimera/proc/chimera_hatch(var/from_save_slot)
	if(!owner)
		return

	remove_verb(owner, /mob/living/carbon/human/proc/hatch)
	to_chat(owner, span_notice("Your new body awakens, bursting free from your old skin."))
	//Modify and record values (half nutrition and braindamage)
	var/old_nutrition = owner.nutrition
	var/braindamage = min(5, max(0, (owner.brainloss-1) * 0.5)) //brainloss is tricky to heal and might take a couple of goes to get rid of completely.
	var/uninjured=owner.quickcheckuninjured()
	trigger_revival(from_save_slot)

	owner.mutations.Remove(HUSK)
	owner.setBrainLoss(braindamage)
	owner.species.update_vore_belly_def_variant()

	if(!uninjured)
		owner.nutrition = old_nutrition * 0.5
		//Drop everything
		for(var/obj/item/W in owner)
			owner.drop_from_inventory(W)
		//Visual effects
		var/T = get_turf(owner)
		var/blood_color = owner.species.blood_color
		var/flesh_color = owner.species.flesh_color
		new /obj/effect/gibspawner/human/xenochimera(T, null, flesh_color, blood_color)
		owner.visible_message(span_danger(span_huge("The lifeless husk of [owner] bursts open, revealing a new, intact copy in the pool of viscera."))) //Bloody hell...
		playsound(T, 'sound/effects/mob_effects/xenochimera/hatch.ogg', 50)
	else //lower cost for doing a quick cosmetic revive
		owner.nutrition = old_nutrition * 0.9

	//Unfreeze some things
	owner.does_not_breathe = FALSE
	owner.update_canmove()
	owner.AdjustStunned(2)

	revive_ready = world.time + 10 MINUTES //set the cooldown, Reduced this to 10 minutes, you're playing with fire if you're reviving that often.

/datum/modifier/resleeving_sickness/chimera //near identical to the regular version, just with different flavortexts
	name = "imperfect regeneration"
	desc = "You feel rather weak and unfocused, having just regrown your body not so long ago."

	on_created_text = span_warning(span_large("You feel weak and unsteady, that regeneration having been rougher than most."))
	on_expired_text = span_notice(span_large("You feel your strength and focus return to you."))

/obj/effect/gibspawner/human/xenochimera
	fleshcolor = "#14AD8B"
	bloodcolor = "#14AD8B"


///This is bad and should not be done this way, but xenochimera was hardcoded in SO many places that it's going to be a hassle to completely undo.
/mob/proc/get_feralness()
	var/datum/component/xenochimera/xc = GetComponent(/datum/component/xenochimera)
	if(xc)
		return xc.feral

/mob/proc/get_xenochimera_component()
	var/datum/component/xenochimera/xc = GetComponent(/datum/component/xenochimera)
	if(xc)
		return xc
