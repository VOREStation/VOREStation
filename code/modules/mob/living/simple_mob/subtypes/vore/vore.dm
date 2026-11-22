/mob/living/simple_mob/vore
	mob_class = MOB_CLASS_ANIMAL
	mob_bump_flag = 0
	can_be_drop_pred = TRUE

/mob/living/simple_mob
	var/nameset
	var/limit_renames = TRUE
	var/copy_prefs_to_mob = TRUE

/mob/living/simple_mob/Login()
	. = ..()
	add_verb(src, /mob/living/simple_mob/proc/set_name)
	add_verb(src, /mob/living/simple_mob/proc/set_desc)
	add_verb(src, /mob/living/simple_mob/proc/set_gender)

	if(copy_prefs_to_mob)
		login_prefs()

/mob/living/proc/login_prefs()

	ooc_notes = client.prefs.read_preference(/datum/preference/text/living/ooc_notes)
	ooc_notes_likes = client.prefs.read_preference(/datum/preference/text/living/ooc_notes_likes)
	ooc_notes_dislikes = client.prefs.read_preference(/datum/preference/text/living/ooc_notes_dislikes)
	ooc_notes_favs = read_preference(/datum/preference/text/living/ooc_notes_favs)
	ooc_notes_maybes = read_preference(/datum/preference/text/living/ooc_notes_maybes)
	ooc_notes_style = read_preference(/datum/preference/toggle/living/ooc_notes_style)
	private_notes = client.prefs.read_preference(/datum/preference/text/living/private_notes)
	VORE_PREF_TRANSFER(src, client.prefs_vr)

/mob/living/simple_mob/proc/set_name()
	set name = "Set Name"
	set desc = "Sets your mobs name. You only get to do this once."
	set category = "Abilities.Settings"
	if(limit_renames && nameset)
		to_chat(src, span_userdanger("You've already set your name. Ask an admin to toggle \"nameset\" to 0 if you really must."))
		return
	var/newname
	newname = sanitizeSafe(tgui_input_text(src,"Set your name. You only get to do this once. Max 52 chars.", "Name set","", MAX_NAME_LEN, encode = FALSE), MAX_NAME_LEN)
	if (newname)
		name = newname
		voice_name = newname
		nameset = 1

/mob/living/simple_mob/proc/set_desc()
	set name = "Set Description"
	set desc = "Set your description."
	set category = "Abilities.Settings"
	var/newdesc
	newdesc = sanitizeSafe(tgui_input_text(src,"Set your description. Max 4096 chars.", "Description set","", prevent_enter = TRUE, encode = FALSE), MAX_MESSAGE_LEN)
	if(newdesc)
		desc = newdesc

/mob/living/simple_mob/proc/set_gender()
	set name = "Set Gender"
	set desc = "Set your gender."
	set category = "Abilities.Settings"
	var/newgender
	newgender = tgui_input_list(src, "Please select a gender:", "Set Gender", list(FEMALE, MALE, NEUTER, PLURAL))
	if(newgender)
		gender = newgender

/mob/living/simple_mob/vore/aggressive
	mob_bump_flag = HEAVY

	export_research_value = TECHWEB_TIER_1_POINTS
	export_research_diminished_max = 5
