/datum/action/innate/vow_of_silence
	name = "Break Vow"
	desc = "Break your vow of silence. Permanently."
	button_icon = 'icons/inventory/face/item.dmi'
	button_icon_state = "mime"

/datum/action/innate/vow_of_silence/Grant(mob/grant_to)
	. = ..()
	ADD_TRAIT(grant_to, TRAIT_MIMING, "[type]")

/datum/action/innate/vow_of_silence/Remove(mob/remove_from)
	. = ..()
	REMOVE_TRAIT(remove_from, TRAIT_MIMING, "[type]")

/datum/action/innate/vow_of_silence/Activate()
	if(tgui_alert(target, "Are you sure? There's no going back.", "Break Vow", list("I'm Sure", "Abort")) != "I'm Sure")
		return
	break_silence()

/datum/action/innate/vow_of_silence/proc/break_silence()
	to_chat(target, span_notice("You break your vow of silence."))
	REMOVE_TRAIT(target, TRAIT_MIMING, "[type]")
	var/datum/job/mime/mime_job = SSjob.get_job(JOB_MIME)
	mime_job.total_positions += 1
	remove_mimery(target)
	qdel(src)

/datum/action/innate/vow_of_silence/proc/remove_mimery(mob/living/user)
	for(var/datum/spell/spell in user.mind.learned_spells)
		if(spell.school == "mime")
			user.remove_spell(spell)
