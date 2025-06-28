ADMIN_VERB_AND_CONTEXT_MENU(possess, R_POSSESS, "Possess Obj", "Possess an object.", ADMIN_CATEGORY_OBJECT, obj/O as obj in world)
	if(istype(O,/obj/singularity))
		if(CONFIG_GET(flag/forbid_singulo_possession))
			to_chat(user, "It is forbidden to possess singularities.")
			return

	var/turf/T = get_turf(O)

	if(T)
		log_admin("[key_name(user)] has possessed [O] ([O.type]) at ([T.x], [T.y], [T.z])")
		message_admins("[key_name(user)] has possessed [O] ([O.type]) at ([T.x], [T.y], [T.z])", 1)
	else
		log_admin("[key_name(user)] has possessed [O] ([O.type]) at an unknown location")
		message_admins("[key_name(user)] has possessed [O] ([O.type]) at an unknown location", 1)

	if(!user.mob.control_object) //If you're not already possessing something...
		user.mob.name_archive = user.mob.real_name

	user.mob.loc = O
	user.mob.real_name = O.name
	user.mob.name = O.name
	user.eye = O
	user.mob.control_object = O
	feedback_add_details("admin_verb","PO") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

ADMIN_VERB(release, R_POSSESS, "Release Object", "Stop possessing an object.", ADMIN_CATEGORY_OBJECT, obj/O as obj in world)
	if(user.mob.control_object && user.mob.name_archive) //if you have a name archived and if you are actually relassing an object
		user.mob.real_name = user.mob.name_archive
		user.mob.name = user.mob.real_name
		if(ishuman(user))
			var/mob/living/carbon/human/H = user
			H.name = H.get_visible_name()

	user.mob.loc = O.loc // Appear where the object you were controlling is -- TLE
	user.eye = user
	user.mob.control_object = null
	feedback_add_details("admin_verb","RO") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
