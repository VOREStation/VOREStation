/obj/screen/lleill
	name = "glamour"
	icon = 'icons/mob/lleill_hud.dmi'
	invisibility = 101


/obj/screen/movable/ability_master/lleill
	name = "Lleill Abilities"
	icon = 'icons/mob/screen_spells.dmi'
	icon_state = "grey_spell_ready"
	ability_objects = list()
	showing = 0

	open_state = "master_open"
	closed_state = "master_closed"

	screen_loc = ui_spell_master

/obj/screen/movable/ability_master/lleill/update_abilities(forced = 0, mob/user)		//Different proc to prevent indexing
	update_icon()
	if(user && user.client)
		if(!(src in user.client.screen))
			user.client.screen += src
	for(var/obj/screen/ability/ability in ability_objects)
		ability.update_icon(forced)

/obj/screen/ability/verb_based/lleill
	icon_state = "grey_spell_base"
	background_base_state = "grey"

/obj/screen/movable/ability_master/proc/add_lleill_ability(var/object_given, var/verb_given, var/name_given, var/ability_icon_given, var/arguments)
	if(!object_given)
		message_admins("ERROR: add_lleill_ability() was not given an object in its arguments.")
	if(!verb_given)
		message_admins("ERROR: add_lleill_ability() was not given a verb/proc in its arguments.")
	if(get_ability_by_proc_ref(verb_given))
		return // Duplicate
	var/obj/screen/ability/verb_based/lleill/A = new /obj/screen/ability/verb_based/lleill()
	A.ability_master = src
	A.object_used = object_given
	A.verb_to_call = verb_given
	A.ability_icon_state = ability_icon_given
	A.name = name_given
	if(arguments)
		A.arguments_to_use = arguments
	ability_objects.Add(A)
	if(my_mob.client)
		toggle_open(2)
