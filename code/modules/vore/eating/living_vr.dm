///////////////////// Mob Living /////////////////////
/mob/living
	var/digestable = 1					// Can the mob be digested inside a belly?
	var/datum/belly/vore_selected		// Default to no vore capability.
	var/list/vore_organs = list()		// List of vore containers inside a mob
	var/absorbed = 0					// If a mob is absorbed into another
	var/weight = 100					// Weight for mobs for weightgain system

//
// Hook for generic creation of stuff on new creatures
//
/hook/living_new/proc/vore_setup(mob/living/M)
	M.verbs += /mob/living/proc/insidePanel
	M.verbs += /mob/living/proc/escapeOOC

	//Creates at least the typical 'stomach' on every mob.
	spawn(20) //Wait a couple of seconds to make sure copy_to or whatever has gone
		//In Polaris, when a character joins (not spawns), it creates some sort of 'Force' /mob/living/silicon/ai
		//then immediately deletes it. I'm not sure why, but we should make sure M is still real 2 seconds later.
		if(M && !M.vore_organs.len)
			var/datum/belly/B = new /datum/belly(M)
			B.immutable = 1
			B.name = "Stomach"
			B.inside_flavor = "It appears to be rather warm and wet. Makes sense, considering it's inside \the [M.name]."
			M.vore_organs[B.name] = B
			M.vore_selected = B.name

			//Simple_animal gets emotes. move this to that hook instead?
			if(istype(src,/mob/living/simple_animal))
				B.emote_lists[DM_HOLD] = list(
					"The insides knead at you gently for a moment.",
					"The guts glorp wetly around you as some air shifts.",
					"Your predator takes a deep breath and sighs, shifting you somewhat.",
					"The stomach squeezes you tight for a moment, then relaxes.",
					"During a moment of quiet, breathing becomes the most audible thing.",
					"The warm slickness surrounds and kneads on you.")

				B.emote_lists[DM_DIGEST] = list(
					"The caustic acids eat away at your form.",
					"The acrid air burns at your lungs.",
					"Without a thought for you, the stomach grinds inwards painfully.",
					"The guts treat you like food, squeezing to press more acids against you.",
					"The onslaught against your body doesn't seem to be letting up; you're food now.",
					"The insides work on you like they would any other food.")

	//Return 1 to hook-caller
	return 1

//
// Handle being clicked, perhaps with something to devour
//
/mob/living/proc/vore_attackby(obj/item/I,mob/user)
	//Things we can eat with vore code
	var/list/vore_items = list(
		/obj/item/weapon/grab,
		/obj/item/weapon/holder)

	if(!(I.type in vore_items))
		return 0

	switch(I.type)
	//Handle case: /obj/item/weappn/grab
		if(/obj/item/weapon/grab)
			var/obj/item/weapon/grab/G = I

			//Has to be aggressive grab, has to be living click-er and non-silicon grabbed
			if((G.state >= GRAB_AGGRESSIVE) && (isliving(user) && !issilicon(G.affecting)))

				var/mob/living/attacker = user  // Typecast to living

				// src is the mob clicked on
				// If grab clicked on grabber
				if(src == G.assailant)
					if (is_vore_predator(src))
						if (src.feed_grabbed_to_self(src, G.affecting))
							qdel(G) //Delete grab
							return 1 //Return 1 to exit upper procs
					else
						log_debug("[attacker] attempted to feed [G.affecting] to [user] ([user.type]) but it is not predator-capable")

				// If grab clicked on grabbed
				if((src == G.affecting) && (user.a_intent == I_GRAB) && (user.zone_sel.selecting == BP_TORSO))
					if (is_vore_predator(G.affecting))
						if (attacker.feed_self_to_grabbed(attacker, G.affecting))
							qdel(G) //Delete grab
							return 1 //Return 1 to exit upper procs
					else
						log_debug("[attacker] attempted to feed [user] to [G.affecting] ([G.affecting.type]) but it is not predator-capable")

				// If grab clicked on anything else
				else
					if (is_vore_predator(src))
						if (attacker.feed_grabbed_to_other(attacker, G.affecting, src))
							qdel(G) //Delete grab
							return 1 //Return 1 to exit upper procs
					else
						log_debug("[attacker] attempted to feed [G.affecting] to [src] ([src.type]) but it is not predator-capable")


	//Handle case: /obj/item/weapon/holder
		if(/obj/item/weapon/holder)
			return 1

	return 0


//
//	Proc for updating vore organs and digestion/healing/absorbing
//
/mob/living/proc/handle_internal_contents()
	for (var/bellytype in vore_organs)
		var/datum/belly/B = vore_organs[bellytype]
		for(var/atom/movable/M in B.internal_contents)
			if(M.loc != src)
				B.internal_contents -= M
				log_debug("Had to remove [M] from belly [B] in [src]")
		B.process_Life()

//
//	Verb for saving vore preferences to save file
//
/mob/living/proc/save_vore_prefs()
	set name = "Save Vore Prefs"
	set category = "Vore"

	var/result = 0

	if(client.prefs)
		result = client.prefs.save_vore_preferences()
	else
		src << "<span class='warning'>You attempted to save your vore prefs but somehow you're in this character without a client.prefs variable. Tell a dev.</span>"
		log_debug("[src] tried to save vore prefs but lacks a client.prefs var.")

	return result

//
//	Proc for applying vore preferences, given bellies
//
/mob/living/proc/apply_vore_prefs(var/list/bellies)
	if(!bellies || bellies.len == 0)
		log_debug("Tried to apply bellies to [src] and failed.")

//
// OOC Escape code for pref-breaking or AFK preds
//
/mob/living/proc/escapeOOC()
	set name = "OOC escape"
	set category = "Vore"

	//You're in an animal!
	if(istype(src.loc,/mob/living/simple_animal))
		var/mob/living/simple_animal/pred = src.loc
		var/confirm = alert(src, "You're in a mob. Don't use this as a trick to get out of hostile animals. This is for escaping from preference-breaking and if you're otherwise unable to escape from endo. If you are in more than one pred, use this more than once.", "Confirmation", "Okay", "Cancel")
		if(confirm == "Okay")
			for(var/I in pred.vore_organs)
				var/datum/belly/B = pred.vore_organs[I]
				B.release_specific_contents(src)

			for(var/mob/living/simple_animal/SA in range(10))
				SA.prey_excludes += src
				spawn(18000)
					if(src && SA)
						SA.prey_excludes -= src

			message_admins("[key_name(src)] used the OOC escape button to get out of [key_name(pred)] (MOB) ([pred ? "<a href='?_src_=holder;adminplayerobservecoodjump=1;X=[pred.x];Y=[pred.y];Z=[pred.z]'>JMP</a>" : "null"])")
			pred.update_icons()

	//You're in a PC!
	else if(istype(src.loc,/mob/living))
		var/mob/living/carbon/pred = src.loc
		var/confirm = alert(src, "You're in a player-character. This is for escaping from preference-breaking and if your predator disconnects/AFKs. If you are in more than one pred, use this more than once. If your preferences were being broken, please admin-help as well.", "Confirmation", "Okay", "Cancel")
		if(confirm == "Okay")
			for(var/O in pred.vore_organs)
				var/datum/belly/CB = pred.vore_organs[O]
				CB.release_specific_contents(src)
			message_admins("[key_name(src)] used the OOC escape button to get out of [key_name(pred)] (PC) ([pred ? "<a href='?_src_=holder;adminplayerobservecoodjump=1;X=[pred.x];Y=[pred.y];Z=[pred.z]'>JMP</a>" : "null"])")

/* POLARISTODO - Depends on dogborgs

	//You're in a dogborg!
	else if(istype(src.loc, /obj/item/device/dogborg/sleeper))
		var/mob/living/silicon/pred = src.loc.loc //Thing holding the belly!
		var/obj/item/device/dogborg/sleeper/belly = src.loc //The belly!

		var/confirm = alert(src, "You're in a dogborg sleeper. This is for escaping from preference-breaking and if your predator disconnects/AFKs. If your preferences were being broken, please admin-help as well.", "Confirmation", "Okay", "Cancel")
		if(confirm == "Okay")
			message_admins("[key_name(src)] used the OOC escape button to get out of [key_name(pred)] (BORG) ([pred ? "<a href='?_src_=holder;adminplayerobservecoodjump=1;X=[pred.x];Y=[pred.y];Z=[pred.z]'>JMP</a>" : "null"])")
			belly.go_out(src) //Just force-ejects from the borg as if they'd clicked the eject button.

*/

	else
		src << "<span class='alert'>You aren't inside anyone, you clod.</span>"

//
// Eating procs depending on who clicked what
//
/mob/living/proc/feed_grabbed_to_self(var/mob/living/user, var/mob/living/prey)
	var/belly = user.vore_selected
	return perform_the_nom(user, prey, user, belly)

/mob/living/proc/eat_held_mob(var/mob/living/user, var/mob/living/prey, var/mob/living/pred)
	var/belly
	if(user != pred)
		belly = input("Choose Belly") in pred.vore_organs
	else
		belly = pred.vore_selected
	return perform_the_nom(user, prey, pred, belly)

/mob/living/proc/feed_self_to_grabbed(var/mob/living/user, var/mob/living/pred)
	var/belly = input("Choose Belly") in pred.vore_organs
	return perform_the_nom(user, user, pred, belly)

/mob/living/proc/feed_grabbed_to_other(var/mob/living/user, var/mob/living/prey, var/mob/living/pred)
	var/belly = input("Choose Belly") in pred.vore_organs
	return perform_the_nom(user, prey, pred, belly)

//
// Master vore proc that actually does vore procedures
//
/mob/living/proc/perform_the_nom(var/mob/living/user, var/mob/living/prey, var/mob/living/pred, var/belly)
	//Sanity
	if(!user || !prey || !pred || !belly || !(belly in pred.vore_organs))
		log_debug("[user] attempted to feed [prey] to [pred], via [belly] but it went wrong.")
		return

	// The belly selected at the time of noms
	var/datum/belly/belly_target = pred.vore_organs[belly]
	var/attempt_msg = "ERROR: Vore message couldn't be created. Notify a dev. (at)"
	var/success_msg = "ERROR: Vore message couldn't be created. Notify a dev. (sc)"

	// Prepare messages
	if(user == pred) //Feeding someone to yourself
		attempt_msg = text("<span class='warning'>[] is attemping to [] [] into their []!</span>",pred,lowertext(belly_target.vore_verb),prey,lowertext(belly_target.name))
		success_msg = text("<span class='warning'>[] manages to [] [] into their []!</span>",pred,lowertext(belly_target.vore_verb),prey,lowertext(belly_target.name))
	else //Feeding someone to another person
		attempt_msg = text("<span class='warning'>[] is attempting to make [] [] [] into their []!</span>",user,pred,lowertext(belly_target.vore_verb),prey,lowertext(belly_target.name))
		success_msg = text("<span class='warning'>[] manages to make [] [] [] into their []!</span>",user,pred,lowertext(belly_target.vore_verb),prey,lowertext(belly_target.name))

	// Announce that we start the attempt!
	user.visible_message(attempt_msg)

	// Now give the prey time to escape... return if they did
	var/swallow_time = istype(prey, /mob/living/carbon/human) ? belly_target.human_prey_swallow_time : belly_target.nonhuman_prey_swallow_time
	/* POLARISTODO - Unnecessary?
	if (!do_mob(user, prey))
		return 0; // User is not able to act upon prey
	*/
	if(!do_after(user, swallow_time))
		return 0 // Prey escpaed (or user disabled) before timer expired.

	// If we got this far, nom successful! Announce it!
	user.visible_message(success_msg)
	playsound(user, belly_target.vore_sound, 100, 1)

	// Actually shove prey into the belly.
	belly_target.nom_mob(prey, user)
	user.update_icons()

	// Inform Admins
	if (pred == user)
		msg_admin_attack("[key_name(pred)] ate [key_name(prey)]. ([pred ? "<a href='?_src_=holder;adminplayerobservecoodjump=1;X=[pred.x];Y=[pred.y];Z=[pred.z]'>JMP</a>" : "null"])")
	else
		msg_admin_attack("[key_name(user)] forced [key_name(pred)] to eat [key_name(prey)]. ([pred ? "<a href='?_src_=holder;adminplayerobservecoodjump=1;X=[pred.x];Y=[pred.y];Z=[pred.z]'>JMP</a>" : "null"])")
	return 1
