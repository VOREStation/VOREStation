/obj/soulgem
	name = "Mind imprintation matrix"
	desc = "A mind storage and processing system capable of capturing and supporting human-level minds in a small VR space."
	var/mob/living/owner
	var/datum/own_mind
	var/obj/belly/linked_belly
	var/taken_over_name

	var/setting_flags = (NIF_SC_ALLOW_EARS|NIF_SC_ALLOW_EYES|NIF_SC_BACKUPS|NIF_SC_PROJECTING)
	var/mob/selected_soul = null
	var/list/brainmobs = list()
	var/inside_flavor = "A small completely white room with a couch, and a window to what seems to be the outside world. A small sign in the corner says 'Configure Me'."
	var/capture_message = "Your vision fades in a haze of static, before returning.\nAround you, you see...\n"
	var/transit_message = "Your surroundings change to..."
	var/release_message = "Release Message"
	var/transfer_message = "Transfer Message"
	var/delete_message = "Delete Message"

// Append the vars to save to our savefile list
/obj/soulgem/vars_to_save()
	var/list/saving = list (
		"setting_flags",
		"inside_flavor",
		"capture_message",
		"transit_message",
		"release_message",
		"transfer_message",
		"delete_message",
		"linked_belly"
	)
	return ..() + saving

// Load the vars_to_save from the savefile
/obj/soulgem/Initialize(mapload)
	. = ..()
	if(ismob(loc))
		owner = loc
		owner.recalculate_vis()

// Store the vars_to_save into the save file
/obj/soulgem/deserialize(list/data)
	. = ..()
	for(var/obj/belly in owner.vore_organs)
		if(belly.name == data["linked_belly"])
			update_linked_belly(belly, TRUE)
			return
	linked_belly = null

// Allows to transfer the soulgem to the given mob
/obj/soulgem/proc/transfer_self(var/mob/target)
	QDEL_NULL(target.soulgem)
	owner.soulgem = null
	forceMove(target)
	owner = target
	target.soulgem = src

// Cleaning up our refs before deletion
/obj/soulgem/Destroy()
	owner = null
	selected_soul = null
	own_mind = null
	QDEL_LIST_NULL(brainmobs)
	if(istype(linked_belly))
		UnregisterSignal(linked_belly, COMSIG_BELLY_UPDATE_VORE_FX)
		linked_belly = null
	. = ..()

// Sends messages to the owner of the soulcatcher
/obj/soulgem/proc/notify_holder(var/message)
	message = span_nif(span_bold("[name]") + " displays, \"" + span_notice("[message]") + "\"")
	to_chat(owner, message)

	for(var/mob/living/carbon/brain/caught_soul/CS as anything in brainmobs)
		to_chat(CS, message)

// Forwards the speech of captured souls
/obj/soulgem/proc/use_speech(var/message, var/mob/living/sender, var/mob/eyeobj, var/whisper)
	var/sender_name = eyeobj ? eyeobj.name : sender.name

	//AR Projecting
	if(eyeobj)
		var/speak_verb = "says"
		message = span_game(span_say(span_bold("[sender_name]") + " [speak_verb], \"[message]\""))
		if(whisper)
			speak_verb = "whispers"
			sender.eyeobj.visible_message(span_italics(message), range = 1)
		else
			sender.eyeobj.visible_message(message)

	//Not AR Projecting
	else
		var/speak_verb = "speaks"
		message = span_nif(span_bold("\[SC\] [sender_name]") + " [speak_verb], \"[message]\"")
		to_chat(owner, message)
		if(whisper)
			speak_verb = "whispers"
			to_chat(sender, span_italics(message))
		else
			for(var/mob/living/carbon/brain/caught_soul/CS as anything in brainmobs)
				to_chat(CS, message)

	log_nsay(message, owner.real_name, sender)

// Forwards the emotes of captured souls
/obj/soulgem/proc/use_emote(var/message, var/mob/living/sender, var/mob/eyeobj, var/whisper)
	var/sender_name = eyeobj ? eyeobj.name : sender.name

	//AR Projecting
	if(eyeobj)
		message = span_emote("[sender_name] [message]")
		if(whisper)
			sender.eyeobj.visible_message(span_italics(message), range = 1)
		else
			sender.eyeobj.visible_message(message)
	//Not AR Projecting
	else
		message = span_nif(span_bold("[sender_name]") + " [message]")
		to_chat(owner, message)
		if(whisper)
			to_chat(sender, span_italics(message))
		else
			for(var/mob/living/carbon/brain/caught_soul/CS as anything in brainmobs)
				to_chat(CS, message)

	log_nme(message, owner.real_name,sender)

// The capture function which transfers the given mob's mind into the soulcatcher
/obj/soulgem/proc/catch_mob(var/mob/M, var/custom_name)
	if(!(M.soulcatcher_pref_flags & SOULCATCHER_ALLOW_CAPTURE) && !isobserver(M)) return // Bypass pref check for observer join
	if(!M.mind)	return
	if(isbrain(owner)) return
	//Create a new brain mob
	var/mob/living/carbon/brain/caught_soul/vore/brainmob = new(src)
	brainmob.gem = src
	brainmob.container = src
	brainmob.stat = 0
	brainmob.silent = FALSE
	dead_mob_list -= brainmob
	brainmob.ext_deaf = !flag_check(NIF_SC_ALLOW_EARS)
	brainmob.ext_blind = !flag_check(NIF_SC_ALLOW_EYES)
	brainmob.add_language(LANGUAGE_GALCOM)
	brainmobs |= brainmob

	//Put the mind and player into the mob
	M.mind.transfer_to(brainmob)
	brainmob.name = custom_name ? custom_name : brainmob.mind.name
	brainmob.real_name = custom_name ? custom_name : brainmob.mind.name

	//If we caught our owner, special settings.
	if(M == owner && !own_mind) // Need some more sanity if we allow takeover
		brainmob.ext_deaf = FALSE
		brainmob.ext_blind = FALSE
		brainmob.parent_mob = TRUE
		own_mind = brainmob.mind
		remove_verb(brainmob, /mob/proc/enter_soulcatcher) //No recursive self capturing...
		add_verb(brainmob, /mob/living/carbon/brain/caught_soul/vore/proc/transfer_self)
		add_verb(brainmob, /mob/living/carbon/brain/caught_soul/vore/proc/reenter_body)

	//If they have these values, apply them
	if(isliving(M))
		var/mob/living/L = M
		brainmob.dna = L.dna
		brainmob.ooc_notes = L.ooc_notes
		brainmob.ooc_notes_likes = L.ooc_notes_likes
		brainmob.ooc_notes_dislikes = L.ooc_notes_dislikes
		/* Not implemented on virgo
		brainmob.ooc_notes_favs = L.ooc_notes_favs
		brainmob.ooc_notes_maybes = L.ooc_notes_maybes
		brainmob.ooc_notes_style = L.ooc_notes_style
		*/
		brainmob.timeofhostdeath = L.timeofdeath
		if(ishuman(L))
			SStranscore.m_backup(brainmob.mind,0) //It does ONE, so medical will hear about it.

	//Else maybe they're a joining ghost
	else if(isobserver(M))
		brainmob.transient = TRUE
		qdel(M) //Bye ghost

	//Give them a flavortext message
	var/message = span_notice("[capture_message][inside_flavor]")

	to_chat(brainmob, message)

	//Reminder on how this works to host
	if(brainmobs.len == 1) //Only spam this on the first one
		to_chat(owner, span_notice("Your occupant's messages/actions can only be seen by you, and you can \
		send messages that only they can hear/see by using the NSay and NMe verbs (or the *nsay and *nme emotes)."))

	//Announce to host and other minds
	notify_holder("New mind loaded: [brainmob.name]")
	show_vore_fx(brainmob, TRUE)
	brainmob.copy_from_prefs_vr(bellies = FALSE)
	return TRUE

// Allows to adjust the interior of the soulcatcher
/obj/soulgem/proc/adjust_interior(var/new_flavor)
	new_flavor = sanitize(new_flavor, MAX_MESSAGE_LEN * 2)
	inside_flavor = new_flavor
	notify_holder("Updating environment...")
	for(var/mob/living/carbon/brain/caught_soul/vore/CS as anything in brainmobs)
		to_chat(CS, span_notice("[transit_message]") + "\n[inside_flavor]")

// Allows to return to the body after being captured by one's own soulcatcher
/obj/soulgem/proc/return_to_body(var/datum/mind)
	if(own_mind != mind)
		to_chat(src, span_warning("You aren't in your own soulcatcher!"))
		return
	var/mob/self = null
	for(var/mob/mob in brainmobs)
		if(mob.mind == mind)
			self = mob
			break
	if(!self)
		return
	if(owner.mind)
		catch_mob(owner, taken_over_name)
	self.mind.transfer_to(owner)
	own_mind = null
	taken_over_name = null
	qdel(self)

// Sets the custom messages depending on the input
/obj/soulgem/proc/set_custom_message(var/message, var/target)
	message = sanitize(message, MAX_MESSAGE_LEN / 4)
	switch(target)
		if("capture")
			capture_message = message
		if("transit")
			transit_message = message
		if("release")
			release_message = message
		if("transfer")
			transfer_message = message
		if("delete")
			delete_message = message

// Allows to rename the soulgem
/obj/soulgem/proc/rename(var/new_name)
	if(length(new_name) < 3 || length(new_name) > 60)
		to_chat(owner, span_warning("Your soulcatcher's name needs to be between 3 and 60 characters long!"))
		return
	new_name = sanitize(new_name, 60)
	name = new_name

// Toggles the given flag
/obj/soulgem/proc/toggle_setting(var/flag)
	setting_flags ^= flag
	if(flag & SOULGEM_SHOW_VORE_SFX)
		soulgem_show_vfx(TRUE)
		soulgem_vfx()
	if(flag & NIF_SC_BACKUPS)
		soulgem_backup()
	if(flag & NIF_SC_ALLOW_EARS)
		soulgem_hear()
	if(flag & NIF_SC_ALLOW_EYES)
		soulgem_sight()
	if(flag & NIF_SC_PROJECTING)
		soulgem_projecting()
	if(flag & SOULGEM_SEE_SR_SOULS)
		owner.recalculate_vis()

// Checks a single flag, or if all combined flags are true
/obj/soulgem/proc/flag_check(var/flag, var/match_all = FALSE)
	if(match_all)
		return (setting_flags & flag) == flag
	return setting_flags & flag

// Updates the selected soul after an interaction which rleased, deleted or transferred the previous one
/obj/soulgem/proc/update_selected_soul()
	if(brainmobs.len > 1)
		selected_soul = brainmobs[1]
	else
		selected_soul = null

// Backup toggling
/obj/soulgem/proc/soulgem_backup()
	if(flag_check(NIF_SC_BACKUPS))
		notify_holder("External backups enabled.")
	else
		notify_holder("External backups disabled.")

// Deaf toggling
/obj/soulgem/proc/soulgem_hear()
	for(var/mob/living/carbon/brain/caught_soul/L in brainmobs)
		L.ext_deaf = !flag_check(NIF_SC_ALLOW_EARS)
	if(flag_check(NIF_SC_ALLOW_EARS))
		notify_holder("External sounds enabled.")
	else
		notify_holder("External sounds disabled.")

// Sight toggling
/obj/soulgem/proc/soulgem_sight()
	for(var/mob/living/carbon/brain/caught_soul/L in brainmobs)
		L.ext_blind = !flag_check(NIF_SC_ALLOW_EYES)
	if(flag_check(NIF_SC_ALLOW_EYES))
		notify_holder("External vision enabled.")
	else
		notify_holder("External vision disabled.")

// Projecting toggling
/obj/soulgem/proc/soulgem_projecting()
	if(flag_check(NIF_SC_PROJECTING))
		notify_holder("AR projecting enabled.")
	else
		notify_holder("AR projecting disabled.")

// VORE FX Section

// Updates the vore FX signal links to the new given belly
/obj/soulgem/proc/update_linked_belly(var/obj/belly, var/skip_unreg = FALSE)
	if(!belly && linked_belly)
		UnregisterSignal(linked_belly, COMSIG_BELLY_UPDATE_VORE_FX)
		linked_belly = null
		return
	if(!isbelly(belly))
		return
	if(!linked_belly)
		linked_belly = belly
		RegisterSignal(linked_belly, COMSIG_BELLY_UPDATE_VORE_FX, PROC_REF(soulgem_show_vfx))
		return
	if(belly != linked_belly)
		if(!skip_unreg)
			UnregisterSignal(linked_belly, COMSIG_BELLY_UPDATE_VORE_FX)
		linked_belly = belly
		RegisterSignal(linked_belly, COMSIG_BELLY_UPDATE_VORE_FX, PROC_REF(soulgem_show_vfx))

// Handles the vore fx updates for the captured souls
/obj/soulgem/proc/soulgem_show_vfx(var/update, var/severity = 0)
	if(linked_belly)
		for(var/mob/living/L in brainmobs)
			if(flag_check(SOULGEM_SHOW_VORE_SFX))
				show_vore_fx(L, update, severity)
			else
				clear_vore_fx(L)

// Function to show the vore fx overlay
/obj/soulgem/proc/show_vore_fx(var/mob/living/L, var/update, var/severity = 0)
	if(!linked_belly || !flag_check(SOULGEM_SHOW_VORE_SFX))
		return
	if(!istype(L) || L.eyeobj)
		return
	linked_belly.vore_fx(L, update, severity)

// Function to clear the vore fx overlay
/obj/soulgem/proc/clear_vore_fx(var/mob/M)
	M.clear_fullscreen("belly")
	if(M.hud_used && !M.hud_used.hud_shown)
		M.toggle_hud_vis(TRUE)

// VFX toggling
/obj/soulgem/proc/soulgem_vfx()
	if(flag_check(SOULGEM_SHOW_VORE_SFX))
		notify_holder("Interior simulation enabled.")
	else
		notify_holder("Interior simulation disabled.")

// Takeover section

// Give control of the body to the current selected soul
/obj/soulgem/proc/take_control_selected()
	if(!selected_soul) return
	take_control(selected_soul)
	if(owner.mind == own_mind)
		own_mind = null
		taken_over_name = null

// Give back control of the body to the owner
/obj/soulgem/proc/take_control_owner()
	var/mob/self = null
	for(var/mob/mob in brainmobs)
		if(mob.mind == own_mind)
			self = mob
			break
	if(!self)
		return
	take_control(self)
	own_mind = null
	taken_over_name = null

/obj/soulgem/proc/take_control(var/mob/M)
	if(!(owner.soulcatcher_pref_flags & SOULCATCHER_ALLOW_CAPTURE) || !(owner.soulcatcher_pref_flags & SOULCATCHER_ALLOW_TAKEOVER)) return
	if(!(M.soulcatcher_pref_flags & SOULCATCHER_ALLOW_CAPTURE) || !(M.soulcatcher_pref_flags & SOULCATCHER_ALLOW_TAKEOVER)) return
	if(!own_mind)
		if(issilicon(owner) || isanimal(owner))
			taken_over_name = owner.name
	catch_mob(owner, taken_over_name)
	taken_over_name = M.name
	M.mind.transfer_to(owner)
	brainmobs -= M
	if(M == selected_soul)
		update_selected_soul()
	qdel(M)

// Funtion to test if the owner's body has been taken over
/obj/soulgem/proc/is_taken_over()
	return (own_mind && owner.mind && owner.mind != own_mind)

// Transfer section to transfer captured souls

// Returns nearby,valid transfer locations as a list
/obj/soulgem/proc/find_transfer_objects()
	var/list/valid_trasfer_objects = list(
		/obj/item/sleevemate,
		/obj/item/mmi
	)
	var/list/valid_objects = list()
	if(isrobot(owner))
		var/mob/living/silicon/robot/R = owner
		if(istype(R.module_active, /obj/item/sleevemate))
			valid_objects += R.module_active
	if(ishuman(owner))
		var/mob/living/carbon/human/H = owner
		if(is_type_in_list(H.get_left_hand(), valid_trasfer_objects))
			valid_objects += H.get_left_hand()
		if(is_type_in_list(H.get_right_hand(), valid_trasfer_objects))
			valid_objects += H.get_right_hand()
	for(var/obj/item/I in range(0, get_turf(owner)))
		if(is_type_in_list(I, valid_trasfer_objects))
			valid_objects += I
	for(var/mob/M in range(1, get_turf(owner)))
		if(M == owner)
			continue
		if(!(M.soulcatcher_pref_flags & SOULCATCHER_ALLOW_TRANSFER))
			continue
		if(M.client && M.soulgem)
			valid_objects += M.soulgem
	if(!valid_objects.len)
		to_chat(owner, span_warning("No valid objects found!"))
		return
	return valid_objects

// Transfer the selected soul to either a valid object or another soulcatcher
/obj/soulgem/proc/transfer_selected()
	if(!selected_soul) return
	if(!(selected_soul.soulcatcher_pref_flags & SOULCATCHER_ALLOW_TRANSFER)) return
	var/list/valid_objects = find_transfer_objects()
	if(!valid_objects || !valid_objects.len)
		return
	var/obj/target = tgui_input_list(owner, "Select where you want to store the mind into.", "Mind Transfer Target", valid_objects)
	transfer_mob_selector(selected_soul, target)

// Transfer selector proc
/obj/soulgem/proc/transfer_mob_selector(var/mob/M, var/obj/target)
	if(!M || !target) return
	if(istype(target, /obj/soulgem))
		transfer_mob_soulcatcher(M, target)
		return
	transfer_mob(M, target)

// Transfers a captured soul to a valid object (sleevemate, mmi)
/obj/soulgem/proc/transfer_mob(var/mob/M, var/obj/target)
	if(is_taken_over()) return
	if(!M || !target) return
	if(istype(target, /obj/item/sleevemate))
		var/obj/item/sleevemate/mate = target
		if(!mate.stored_mind)
			to_chat(owner, span_notice("You scan yourself to transfer the soul into the [target]!"))
			to_chat(M, span_notice("[transfer_message]"))
			if(M.mind == own_mind)
				own_mind = null
			mate.get_mind(M)
	else if(istype(target, /obj/item/mmi))
		var/obj/item/mmi/mm = target
		if(!mm.brainmob || !mm.brainmob.mind)
			if(M.mind == own_mind)
				own_mind = null
			to_chat(owner, span_notice("You transfer the soul into the [target]!"))
			to_chat(M, span_notice("[transfer_message]"))
			mm.transfer_identity(M)
			if(!mm.brainmob.mind && M.mind)
				M.mind.transfer_to(mm.brainmob)
	else
		return
	brainmobs -= M
	if(M == selected_soul)
		update_selected_soul()
	qdel(M)

// Transfers a captured soul to another soulcatcher
/obj/soulgem/proc/transfer_mob_soulcatcher(var/mob/living/carbon/brain/caught_soul/vore/M, var/obj/soulgem/gem)
	if(is_taken_over()) return
	if(!istype(M) || !gem) return
	if(!gem.owner) return
	if((tgui_alert(gem.owner, "Do you want to allow [owner] to transfer [selected_soul] to your soulcatcher?", "Allow Transfer", list("No", "Yes")) != "Yes"))
		return
	if(!in_range(gem.owner, owner))
		return
	if(!(gem.owner.soulcatcher_pref_flags & SOULCATCHER_ALLOW_TRANSFER))
		return
	if(M.mind == own_mind)
		own_mind = null
	brainmobs -= M
	M.gem = gem
	M.container = gem
	gem.brainmobs += M
	if(M == selected_soul)
		update_selected_soul()

// Release section

// Release the selected soul as a ghost
/obj/soulgem/proc/release_selected()
	if(!selected_soul) return
	if(release_mob(selected_soul))
		update_selected_soul()

// Release all captured souls as ghosts
/obj/soulgem/proc/release_mobs()
	selected_soul = null
	if(!brainmobs.len) return
	for(var/mob/M in brainmobs)
		release_mob(M)

// Proc to release the soul as ghost, returns TRUE on success
/obj/soulgem/proc/release_mob(var/mob/M)
	if(is_taken_over()) return FALSE
	to_chat(M, span_notice("[release_message]"))
	brainmobs -= M
	M.ghostize(FALSE)
	qdel(M)
	return TRUE

// Delete section to delete captured souls from the soulcatcher

// Delete the selected mob
/obj/soulgem/proc/delete_selected()
	if(!selected_soul) return
	if(delete_mob(selected_soul))
		update_selected_soul()

// Delete all captured mobs
/obj/soulgem/proc/erase_mobs()
	if(!brainmobs.len) return
	for(var/mob/M in brainmobs)
		delete_mob(M)

// The function handling the actual delete, returns TRUE on success
/obj/soulgem/proc/delete_mob(var/mob/M)
	if(is_taken_over()) return FALSE
	if(!(M.soulcatcher_pref_flags & SOULCATCHER_ALLOW_DELETION))
		return release_mob(M)
	if(!(M.soulcatcher_pref_flags & SOULCATCHER_ALLOW_DELETION_INSTANT))
		if(tgui_alert(M, "Do you really want to allow [owner] to delete you? On decline, you'll be ghosted.", "Allow Deletion", list("No", "Yes"), timeout=1 MINUTES) != "Yes")
			return release_mob(M)
	to_chat(M, span_danger("[delete_message]"))
	brainmobs -= M
	var/mob/observer/dead/ghost = M.ghostize(FALSE)
	ghost.abandon_mob()
	qdel(M)
	return TRUE
