SUBSYSTEM_DEF(inactivity)
	name = "Inactivity"
	wait = 1 MINUTE
	flags = SS_NO_INIT | SS_BACKGROUND
	var/tmp/list/client_list
	var/number_kicked = 0

/datum/controller/subsystem/inactivity/fire(resumed = FALSE)
	if (!CONFIG_GET(number/kick_inactive))
		can_fire = FALSE
		return
	if (!resumed)
		client_list = GLOB.clients.Copy()

	while(client_list.len)
		var/client/C = client_list[client_list.len]
		client_list.len--
		if(C.is_afk(CONFIG_GET(number/kick_inactive) MINUTES) && can_kick(C))
			to_chat_immediate(C, span_warning("You have been inactive for more than [CONFIG_GET(number/kick_inactive)] minute\s and have been disconnected."))

			var/information
			if(C.mob)
				if(ishuman(C.mob))
					var/job
					var/mob/living/carbon/human/H = C.mob
					var/datum/data/record/R = find_general_record("name", H.real_name)
					if(R)
						job = R.fields["real_rank"]
					if(!job && H.mind)
						job = H.mind.assigned_role
					if(!job && H.job)
						job = H.job
					if(job)
						information = " while [job]."

				else if(isobserver(C.mob))
					information = " while a ghost."

				else if(issilicon(C.mob))
					information = " while a silicon."
					if(isAI(C.mob))
						var/mob/living/silicon/ai/A = C.mob
						GLOB.empty_playable_ai_cores += new /obj/structure/AIcore/deactivated(A.loc)
						global_announcer.autosay("[A] has been moved to intelligence storage.", "Artificial Intelligence Oversight")
						A.clear_client()
						information = " while an AI."

			var/adminlinks
			adminlinks = " (<A href='byond://?_src_=holder;[HrefToken()];adminplayerobservecoodjump=1;X=[C.mob.x];Y=[C.mob.y];Z=[C.mob.z]'>JMP</a>|<A href='byond://?_src_=holder;[HrefToken()];cryoplayer=\ref[C.mob]'>CRYO</a>)"

			log_and_message_admins("being kicked for AFK[information][adminlinks]", C.mob)

			qdel(C)
			number_kicked++

		if (MC_TICK_CHECK)
			return

/datum/controller/subsystem/inactivity/stat_entry(msg)
	msg = "Kicked: [number_kicked]"
	return ..()

/datum/controller/subsystem/inactivity/proc/can_kick(var/client/C)
	if(C.holder) return FALSE //VOREStation Add - Don't kick admins.
	return TRUE
