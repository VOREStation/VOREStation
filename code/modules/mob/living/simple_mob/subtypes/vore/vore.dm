/mob/living/simple_mob/vore
	mob_class = MOB_CLASS_ANIMAL
	mob_bump_flag = 0

/mob/living/simple_mob
	var/nameset
	var/limit_renames = TRUE
	var/copy_prefs_to_mob = TRUE

/mob/living/simple_mob/Login()
	. = ..()
	add_verb(src, /mob/living/simple_mob/proc/set_name)
	add_verb(src, /mob/living/simple_mob/proc/set_desc)

	if(copy_prefs_to_mob)
		login_prefs()

/mob/living/proc/login_prefs()

	ooc_notes = client.prefs.read_preference(/datum/preference/text/living/ooc_notes)
	ooc_notes_likes = client.prefs.read_preference(/datum/preference/text/living/ooc_notes_likes)
	ooc_notes_dislikes = client.prefs.read_preference(/datum/preference/text/living/ooc_notes_dislikes)
	private_notes = client.prefs.read_preference(/datum/preference/text/living/private_notes)
	digestable = client.prefs_vr.digestable
	devourable = client.prefs_vr.devourable
	absorbable = client.prefs_vr.absorbable
	feeding = client.prefs_vr.feeding
	can_be_drop_prey = client.prefs_vr.can_be_drop_prey
	can_be_drop_pred = client.prefs_vr.can_be_drop_pred
	throw_vore = client.prefs_vr.throw_vore
	food_vore = client.prefs_vr.food_vore
	allow_inbelly_spawning = client.prefs_vr.allow_inbelly_spawning
	allow_spontaneous_tf = client.prefs_vr.allow_spontaneous_tf
	digest_leave_remains = client.prefs_vr.digest_leave_remains
	allowmobvore = client.prefs_vr.allowmobvore
	permit_healbelly = client.prefs_vr.permit_healbelly
	noisy = client.prefs_vr.noisy
	selective_preference = client.prefs_vr.selective_preference
	eating_privacy_global = client.prefs_vr.eating_privacy_global
	allow_mimicry = client.prefs_vr.allow_mimicry

	drop_vore = client.prefs_vr.drop_vore
	stumble_vore = client.prefs_vr.stumble_vore
	slip_vore = client.prefs_vr.slip_vore
	digest_pain = client.prefs_vr.digest_pain

	resizable = client.prefs_vr.resizable
	show_vore_fx = client.prefs_vr.show_vore_fx
	step_mechanics_pref = client.prefs_vr.step_mechanics_pref
	pickup_pref = client.prefs_vr.pickup_pref
	allow_mind_transfer = client.prefs_vr.allow_mind_transfer

/mob/living/simple_mob/proc/set_name()
	set name = "Set Name"
	set desc = "Sets your mobs name. You only get to do this once."
	set category = "Abilities.Settings"
	if(limit_renames && nameset)
		to_chat(src, span_userdanger("You've already set your name. Ask an admin to toggle \"nameset\" to 0 if you really must."))
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
	set category = "Abilities.Settings"
	var/newdesc
	newdesc = sanitizeSafe(tgui_input_text(src,"Set your description. Max 4096 chars.", "Description set","", prevent_enter = TRUE), MAX_MESSAGE_LEN)
	if(newdesc)
		desc = newdesc

/mob/living/simple_mob/vore/aggressive
	mob_bump_flag = HEAVY
