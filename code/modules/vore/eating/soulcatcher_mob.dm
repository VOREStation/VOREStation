/mob/living/carbon/brain/caught_soul/vore
	name = "stored soul"
	desc = "A soul stored within the predator."

	var/obj/soulgem/gem

// Cleaning up the refs during deletion
/mob/living/carbon/brain/caught_soul/vore/Destroy()
	if(gem)
		gem.notify_holder("Mind unloaded: [name]")
		gem.brainmobs -= src
		gem = null
	if(eyeobj)
		QDEL_NULL(eyeobj)
		gem.notify_holder("[name] ended SR projection.")
	container = null
	return ..()

// Handling the automatic transcore backups in a set interval
/mob/living/carbon/brain/caught_soul/vore/Life()
	. = ..()
	if(QDELETED(src))
		return

	if(!parent_mob && !transient &&(life_tick % 150 == 0) && gem.setting_flags & NIF_SC_BACKUPS)
		SStranscore.m_backup(mind,0) //Passed 0 means "Don't touch the nif fields on the mind record"

	if(!client)
		return

	if(ext_blind)
		eye_blind = 5
		client.screen.Remove(global_hud.whitense)
		overlay_fullscreen("blind", /obj/screen/fullscreen/blind)
	else
		eye_blind = 0
		clear_fullscreen("blind")
		if(!gem.flag_check(SOULGEM_SHOW_VORE_SFX))
			client.screen.Add(global_hud.whitense)
	if(gem.flag_check(SOULGEM_SHOW_VORE_SFX))
		client.screen.Remove(global_hud.whitense)

// Say proc for captures souls
/mob/living/carbon/brain/caught_soul/vore/say(var/message, var/datum/language/speaking = null, var/whispering = 0)
	if(silent) return FALSE
	gem.use_speech(message, src, eyeobj)

// Emote proc for captured souls
/mob/living/carbon/brain/caught_soul/vore/custom_emote(var/m_type, var/message)
	if(silent) return FALSE
	gem.use_emote(message,src,eyeobj)

/mob/living/carbon/brain/caught_soul/vore/me_verb_subtle(message as message)
	if(silent) return FALSE
	gem.use_emote(message,src,eyeobj,TRUE)

/mob/living/carbon/brain/caught_soul/vore/whisper(message as text)
	if(silent) return FALSE
	gem.use_speech(message,src,eyeobj,TRUE)

// Resist override, only returning a message that one is stuck for now
/mob/living/carbon/brain/caught_soul/vore/resist()
	set name = "Resist"
	set category = "IC.Game"

	to_chat(src, span_warning("There's no way out! You're stuck inside your predator."))

// Allows the predator to enter their own soulcatcher
/mob/proc/enter_soulcatcher()
	set name = "Enter Soulcatcher"
	set desc = "Enter your own Soulcatcher."
	set category = "IC.Vore"

	if(!soulgem) // Only sanity...
		return
	if(soulgem && soulgem.flag_check(SOULGEM_ACTIVE))
		var/to_use_custom_name = null
		if(issilicon(src) || isanimal(src))
			to_use_custom_name = src.name
		soulgem.catch_mob(src, to_use_custom_name)

// Speak to the captured souls within the own soulcatcher
/mob/proc/nsay_vore(message as message)
	set name = "NSay Vore"
	set desc = "Speak into your Soulcatcher."

	src.nsay_vore_act(message)

/mob/proc/nsay_vore_ch()
	set name = "NSay Vore CH"
	set desc = "Speak into your Soulcatcher."
	set category = "IC.Vore"

	src.nsay_vore_act()

/mob/proc/nsay_vore_act(var/message)
	if(stat != CONSCIOUS)
		to_chat(src, span_warning("You can't use NSay Vore while unconscious."))
		return
	if(!soulgem) // Only sanity...
		return
	var/obj/soulgem/gem = soulgem
	if(!gem.brainmobs.len)
		to_chat(src, span_warning("You need a devoured soul to use NSay Vore."))
		return

	if(!message)
		message = tgui_input_text(usr, "Type a message to say.","Speak into Soulcatcher", multiline=TRUE)
	if(message)
		var/sane_message = sanitize(message)
		gem.use_speech(sane_message, src)

// Emote to the captured souls within the soulcatcher
/mob/proc/nme_vore(message as message)
	set name = "NMe Vore"
	set desc = "Emote into your Soulcatcher."

	src.nme_vore_act(message)

/mob/proc/nme_vore_ch()
	set name = "NMe Vore CH"
	set desc = "Emote into your Soulcatcher."
	set category = "IC.Vore"

	src.nme_vore_act()

/mob/proc/nme_vore_act(var/message)
	if(stat != CONSCIOUS)
		to_chat(src, span_warning("You can't use NMe Vore while unconscious."))
		return
	if(!soulgem) // Only sanity...
		return
	var/obj/soulgem/gem = soulgem
	if(!gem.brainmobs.len)
		to_chat(src, span_warning("You need a devoured soul to use NMe Vore."))
		return

	if(!message)
		message = tgui_input_text(usr, "Type an action to perform.","Emote into Soulcatcher", multiline=TRUE)
	if(message)
		var/sane_message = sanitize(message)
		gem.use_emote(sane_message, src)

// SR projecting mob
/mob/observer/eye/ar_soul/vore
	plane = PLANE_SOULCATCHER

// SR project as captured soul
/mob/living/carbon/brain/caught_soul/vore/ar_project()
	set name = "AR/SR Project"
	set desc = "Project your form into Augmented Reality for those around your predator with the appearance of your loaded character."
	set category = "Soulcatcher"

	if(eyeobj)
		to_chat(src, span_warning("You're already projecting in SR!"))
		return

	if(!(gem.setting_flags & NIF_SC_PROJECTING))
		to_chat(src, span_warning("Projecting from this NIF has been disabled!"))
		return

	if(!client || !client.prefs)
		return //Um...

	eyeobj = new/mob/observer/eye/ar_soul/vore(src, gem.owner)
	gem.notify_holder("[src] now SR projecting.")
	gem.clear_vore_fx(src)

// Jump to the owner as SR projection
/mob/living/carbon/brain/caught_soul/vore/jump_to_owner()
	set name = "Jump to Owner"
	set desc = "Jump your projection back to the owner of the soulcatcher you're inside."
	set category = "Soulcatcher"

	if(!eyeobj)
		to_chat(src, span_warning("You're not projecting into SR!"))
		return

	eyeobj.forceMove(get_turf(gem))

// End SR projecting and return to the soulcatcher containing the soul
/mob/living/carbon/brain/caught_soul/vore/reenter_soulcatcher()
	set name = "Re-enter Soulcatcher"
	set desc = "Leave SR projection and drop back into the soulcatcher."
	set category = "Soulcatcher"

	if(!eyeobj)
		to_chat(src, span_warning("You're not projecting into SR!"))
		return

	QDEL_NULL(eyeobj)
	gem.notify_holder("[src] ended SR projection.")
	gem.show_vore_fx(src, TRUE)

/mob/living/carbon/brain/caught_soul/vore/nsay_brain()
	set name = "NSay"
	set desc = "Speak to your Soulcatcher (circumventing SR speaking)."
	set category = "Soulcatcher"

	var/message = tgui_input_text(usr, "Type a message to say.","Speak into Soulcatcher", multiline=TRUE)
	if(message)
		var/sane_message = sanitize(message)
		gem.use_speech(sane_message, src)

/mob/living/carbon/brain/caught_soul/vore/nme_brain()
	set name = "NMe"
	set desc = "Emote to your Soulcatcher (circumventing SR speaking)."
	set category = "Soulcatcher"

	var/message = tgui_input_text(usr, "Type an action to perform.","Emote into Soulcatcher", multiline=TRUE)
	if(message)
		var/sane_message = sanitize(message)
		gem.use_emote(sane_message, src)

// Allows the captured owner to transfer themselves to valid nearby objects
/mob/living/carbon/brain/caught_soul/vore/proc/transfer_self()
	set name = "Transfer Self"
	set desc = "Transfer youself while being in your own soulcatcher into a nearby Sleevemate or MMI."
	set category = "Soulcatcher"

	if(eyeobj)
		to_chat(src, span_warning("You can't do that while SR projecting!"))
		return
	if(gem.own_mind != mind)
		to_chat(src, span_warning("You aren't in your own soulcatcher!"))
		return

	var/list/valid_objects = gem.find_transfer_objects()
	if(!valid_objects || !valid_objects.len)
		return

	var/obj/target = tgui_input_list(src, "Select where you want to store your own mind into.", "Mind Transfer Target", valid_objects)

	gem.transfer_mob_selector(src, target)

// Allows the owner to reenter the body after being caught or having given away control
/mob/living/carbon/brain/caught_soul/vore/proc/reenter_body()
	set name = "Re-enter Body"
	set desc = "Return to your body after self capturing."
	set category = "Soulcatcher"

	if(eyeobj)
		to_chat(src, span_warning("You can't do that while SR projecting!"))
		return
	gem.return_to_body(mind)
