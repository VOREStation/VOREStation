/*
Eventkit verb to be used to spawn the obj/effect/landmarks defined under code\game\objects\effects\landmarks_events.dm
*/
ADMIN_VERB(manage_event_triggers, R_FUN, "Manage Event Triggers", "Open dialogue to create or delete narration/notification triggers", ADMIN_CATEGORY_FUN_EVENT_KIT)
	var/mode = tgui_input_list(user, "What do you wish to do?", "Manage Event Triggers", \
	list(
		"Create Notification Trigger",
		"Create Narration Trigger",
		"Manage Personal Triggers",
		"Manage Other's Triggers",
		"Cancel"
	), "Cancel" )
	if(!mode || mode == "Cancel") return

	feedback_add_details("admin_verb","EventTriggerManage")
	switch(mode)

		if("Create Notification Trigger")
			var/obj/effect/landmark/event_trigger/ET = new /obj/effect/landmark/event_trigger(user.mob.loc)
			ET.set_vars(user)

		if("Create Narration Trigger")

			var/obj/effect/landmark/event_trigger/auto_narrate/AN = new /obj/effect/landmark/event_trigger/auto_narrate(user.mob.loc)
			AN.set_vars(user)

		if("Manage Personal Triggers")
			var/personal_list = GLOB.event_triggers[user.ckey]
			if(!LAZYLEN(personal_list))
				to_chat(user, span_notice("You don't have any landmarks to manage!"))
				return
			personal_list |= list("Cancel", "Delete All")
			var/choice = tgui_input_list(user, "Select a landmark to choose between teleporting to it or deleting it, select delete all to clear them.", \
			"Manage Personal Triggers", personal_list)
			if(!choice || choice == "Cancel")
				return
			if(choice == "Delete All")
				var/confirm = tgui_alert(user, "ARE YOU SURE? THERE IS NO GOING BACK", "CONFIRM", list("Go Back", "Delete all my event triggers"), autofocus = FALSE)
				if(!confirm || confirm == "Go Back")
					return
				for(var/obj/effect/landmark/event_trigger/ET in personal_list)
					ET.delete_me = TRUE
					qdel(ET)
			else if(istype(choice, /obj/effect/landmark/event_trigger))
				var/obj/effect/landmark/event_trigger/ET = choice
				var/decision = tgui_alert(user, "Teleport to Landmark or Delete it?", "Manage [ET.name]", list("Teleport", "Delete"), autofocus = FALSE)
				if(decision == "Teleport")
					var/mob/user_mob = user.mob
					if(isobserver(user_mob))
						var/confirm_teleport = tgui_alert(user, "You're not a ghost! Admin-ghost?", "You're not a ghost", \
							list("Cancel", "Teleport me with my character"))
						if(confirm_teleport == "Cancel")
							return
					user_mob.forceMove(get_turf(ET))
				if(decision == "Delete")
					var/confirm = tgui_alert(user, "ARE YOU SURE? THERE IS NO GOING BACK FROM DELETING [ET.name]", "CONFIRM", list("Go Back", "Delete it!"), autofocus = FALSE)
					if(!confirm || confirm == "Go Back")
						return
					ET.delete_me = TRUE
					qdel(ET)
		if("Manage Other's Triggers")
			var/other_ckey = tgui_input_text(user, "input trigger owner's ckey", "CKEY", "", MAX_MESSAGE_LEN)
			var/others_list = GLOB.event_triggers[other_ckey]
			if(!LAZYLEN(others_list))
				to_chat(user, span_notice("[other_ckey] doesn't have any landmarks to manage!"))
				return
			others_list |= list("Cancel", "Delete All")
			var/choice = tgui_input_list(user, "Select a landmark to choose between teleporting to it or deleting it, select delete all to clear them.", \
			"Manage Personal Triggers", others_list)
			if(!choice || choice == "Cancel")
				return
			if(choice == "Delete All")
				if(other_ckey && GLOB.directory[other_ckey])
					var/client/C = GLOB.directory[other_ckey]
					var/mob/stat_mob = C.statobj
					if(stat_mob.client?.inactivity < 30 MINUTES)
						if(tgui_alert(user, "[stat_mob] has only been inactive for [stat_mob.client.inactivity / (1 MINUTE)] minutes.\n \
							If you want to delete their event triggers, ask them in asay or discord to do it themselves or wait 30 minutes. \n \
							Only proceed if you are absolutely certain.", "Force Delete", list("Confirm", "Cancel")) == "Confirm")
							for(var/obj/effect/landmark/event_trigger/ET in others_list)
								ET.delete_me = TRUE
								qdel(ET)
							log_and_message_admins("[user.ckey] deleted all of [other_ckey]'s event triggers while [other_ckey] was active", user)
							return
				var/confirm = tgui_alert(user, "ARE YOU SURE? THERE IS NO GOING BACK", "CONFIRM", list("Go Back", "Delete all my event triggers"), autofocus = FALSE)
				if(!confirm || confirm == "Go Back")
					return
				for(var/obj/effect/landmark/event_trigger/ET in others_list)
					ET.delete_me = TRUE
					qdel(ET)
				log_and_message_admins("[user.ckey] deleted all of [other_ckey]'s event triggers. [other_ckey] was either inactive or disconnected at this time.", user)
			else if(istype(choice, /obj/effect/landmark/event_trigger))
				var/obj/effect/landmark/event_trigger/ET = choice
				var/decision = tgui_alert(user, "Teleport to Landmark or Delete it?", "Manage [ET]", list("Teleport", "Delete"), autofocus = FALSE)
				if(decision == "Teleport")
					var/mob/user_mob = user.mob
					if(isobserver(user_mob))
						var/confirm_teleport = tgui_alert(user, "You're not a ghost! Admin-ghost?", "You're not a ghost", \
							list("Cancel", "Teleport me with my character"))
						if(!confirm_teleport || confirm_teleport == "Cancel")
							return
					user_mob.forceMove(get_turf(ET))
				if(decision == "Delete")
					if(other_ckey && GLOB.directory[other_ckey])
						var/client/C = GLOB.directory[other_ckey]
						var/mob/stat_mob = C.statobj
						if(stat_mob?.client.inactivity < 30 MINUTES)
							if(tgui_alert(user, "[stat_mob] has only been inactive for [stat_mob.client.inactivity / (1 MINUTE)] minutes.\n \
								If you want to delete their event triggers, ask them in asay or discord to do it themselves or wait 30 minutes. \n \
								Only proceed if you are absolutely certain.", "Force Delete", list("Confirm", "Cancel")) == "Confirm")
								ET.delete_me = TRUE
								qdel(ET)
								log_and_message_admins("[user.ckey] tried to delete event trigger [ET.name] while [other_ckey] is active.", user)
								return
					var/confirm = tgui_alert(user, "ARE YOU SURE? THERE IS NO GOING BACK FROM DELETING [ET.name]", "CONFIRM", list("Go Back", "Delete it!"), autofocus = FALSE)
					if(!confirm || confirm == "Go Back")
						return
					ET.delete_me = TRUE
					qdel(ET)
					log_and_message_admins("[user.ckey] tried to deleted event trigger [ET.name], [other_ckey] is either disconnected or inactive.", user)
