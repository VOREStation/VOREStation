//This only exists to be abused, so it's highly recommended to ensure this file is unchecked.
/datum/power/changeling/lsd_sting
	name = "Hallucination Sting"
	desc = "We evolve the ability to sting a target with a powerful hallunicationary chemical."
	helptext = "The target does not notice they have been stung.  The effect occurs after 30 to 60 seconds."
	genomecost = 3
	verbpath = /mob/proc/changeling_lsdsting

/mob/proc/changeling_lsdsting()
	set category = "Changeling"
	set name = "Hallucination Sting (15)"
	set desc = "Causes terror in the target."

	var/mob/living/carbon/T = changeling_sting(15,/mob/proc/changeling_lsdsting)
	if(!T)
		return FALSE
	add_attack_logs(src,T,"Hallucination sting (changeling)")
	addtimer(VARSET_CALLBACK(T, hallucination, min(T.hallucination+400, 400)), rand(30 SECONDS, 60 SECONDS), TIMER_DELETE_ME) //No going ABOVE 400 hallucinations.
	feedback_add_details("changeling_powers","HS")
	return TRUE
