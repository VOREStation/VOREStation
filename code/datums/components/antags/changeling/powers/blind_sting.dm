//Updated
/datum/power/changeling/blind_sting
	name = "Blind Sting"
	desc = "We silently sting a human, completely blinding them for a short time."
	enhancedtext = "Duration is extended."
	ability_icon_state = "ling_sting_blind"
	genomecost = 2
	allowduringlesserform = TRUE
	verbpath = /mob/proc/changeling_blind_sting

/mob/proc/changeling_blind_sting()
	set category = "Changeling"
	set name = "Blind sting (20)"
	set desc="Sting target"
	var/datum/component/antag/changeling/comp = is_changeling(src)
	var/mob/living/carbon/T = changeling_sting(20,/mob/proc/changeling_blind_sting)
	if(!T)
		return FALSE
	add_attack_logs(src,T,"Blind sting (changeling)")
	to_chat(T, span_danger("Your eyes burn horrificly!"))
	T.disabilities |= NEARSIGHTED
	var/duration = 30 SECONDS
	if(comp.recursive_enhancement)
		duration = duration + 15 SECONDS
		to_chat(src, span_notice("They will be deprived of sight for longer."))
	addtimer(CALLBACK(T, PROC_REF(nearsighted_sting_complete),T), duration, TIMER_DELETE_ME)
	T.Blind(10)
	T.eye_blurry = 20
	feedback_add_details("changeling_powers","BS")
	return TRUE

/mob/proc/nearsighted_sting_complete(mob/target, mode)
	if(!target)
		return
	target.disabilities &= ~NEARSIGHTED
