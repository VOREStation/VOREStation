/mob/living/simple_mob/vore
	mob_class = MOB_CLASS_ANIMAL
	mob_bump_flag = 0

/mob/living/simple_mob
	var/nameset
	var/limit_renames = TRUE

/mob/living/simple_mob/Login()
	. = ..()
	verbs |= /mob/living/simple_mob/proc/set_name
	verbs |= /mob/living/simple_mob/proc/set_desc

	ooc_notes = client.prefs.metadata
	digestable = client.prefs_vr.digestable
	devourable = client.prefs_vr.devourable
	absorbable = client.prefs_vr.absorbable
	feeding = client.prefs_vr.feeding
	can_be_drop_prey = client.prefs_vr.can_be_drop_prey
	can_be_drop_pred = client.prefs_vr.can_be_drop_pred
	allow_inbelly_spawning = client.prefs_vr.allow_inbelly_spawning
	allow_spontaneous_tf = client.prefs_vr.allow_spontaneous_tf
	digest_leave_remains = client.prefs_vr.digest_leave_remains
	allowmobvore = client.prefs_vr.allowmobvore
	permit_healbelly = client.prefs_vr.permit_healbelly
	noisy = client.prefs_vr.noisy

	drop_vore = client.prefs_vr.drop_vore
	stumble_vore = client.prefs_vr.stumble_vore
	slip_vore = client.prefs_vr.slip_vore

	resizable = client.prefs_vr.resizable
	show_vore_fx = client.prefs_vr.show_vore_fx
	step_mechanics_pref = client.prefs_vr.step_mechanics_pref
	pickup_pref = client.prefs_vr.pickup_pref


/mob/living/simple_mob/proc/set_name()
	set name = "Set Name"
	set desc = "Sets your mobs name. You only get to do this once."
	set category = "Abilities"
	if(limit_renames && nameset)
		to_chat(src, "<span class='userdanger'>You've already set your name. Ask an admin to toggle \"nameset\" to 0 if you really must.</span>")
		return
	var/newname
	newname = sanitizeSafe(tgui_input_text(src,"Set your name. You only get to do this once. Max 52 chars.", "Name set","", MAX_NAME_LEN), MAX_NAME_LEN)
	if (newname)
		name = newname
		voice_name = newname
		nameset = 1

/mob/living/simple_mob/proc/set_desc()
	set name = "Set Description"
	set desc = "Set your description."
	set category = "Abilities"
	var/newdesc
	newdesc = sanitizeSafe(tgui_input_text(src,"Set your description. Max 4096 chars.", "Description set","", prevent_enter = TRUE), MAX_MESSAGE_LEN)
	if(newdesc)
		desc = newdesc

/mob/living/simple_mob/vore/aggressive
	mob_bump_flag = HEAVY
