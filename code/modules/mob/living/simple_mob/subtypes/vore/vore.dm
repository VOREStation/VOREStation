/mob/living/simple_mob/vore
	mob_class = MOB_CLASS_ANIMAL
	mob_bump_flag = 0
	var/nameset

/mob/living/simple_mob/vore/Login()
	. = ..()
	verbs |= /mob/living/simple_mob/vore/proc/set_name
	verbs |= /mob/living/simple_mob/vore/proc/set_desc

/mob/living/simple_mob/vore/proc/set_name()
	set name = "Set Name"
	set desc = "Sets your mobs name. You only get to do this once."
	set category = "Abilities"
	if(nameset)
		to_chat(src, "<span class='userdanger'>You've already set your name. Ask an admin to toggle \"nameset\" to 0 if you really must.</span>")
		return
	var/newname
	newname = sanitizeSafe(input(src,"Set your name. You only get to do this once. Max 52 chars.", "Name set","") as text, MAX_NAME_LEN)
	if (newname)
		name = newname
		voice_name = newname
		nameset = 1

/mob/living/simple_mob/vore/proc/set_desc()
	set name = "Set Description"
	set desc = "Set your description."
	set category = "Abilities"
	var/newdesc
	newdesc = sanitizeSafe(input(src,"Set your description. Max 4096 chars.", "Description set","") as text, MAX_MESSAGE_LEN)
	if(newdesc)
		desc = newdesc

/mob/living/simple_mob/vore/aggressive
	mob_bump_flag = HEAVY