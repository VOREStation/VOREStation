/datum/power/changeling/unfat_sting
	name = "Unfat Sting"
	desc = "We silently sting a human, forcing them to rapidly metabolize their fat."
	genomecost = 1
	verbpath = /mob/proc/changeling_unfat_sting

/mob/proc/changeling_unfat_sting()
	set category = "Changeling"
	set name = "Unfat sting (5)"
	set desc = "Sting target"

	var/mob/living/carbon/T = changeling_sting(5,/mob/proc/changeling_unfat_sting)
	if(!T)	return 0
	T.attack_log += text("\[[time_stamp()]\] <font color='red'>Was unfat stung by [key_name(src)]</font>")
	src.attack_log += text("\[[time_stamp()]\] <font color='orange'> Used unfat sting on [key_name(T)]</font>")
	msg_admin_attack("[key_name(T)] was unfat stung by [key_name(src)]")
	T << "<span class='danger'>you feel a small prick as stomach churns violently and you become to feel skinnier.</span>"
	T.overeatduration = 0
	T.nutrition -= 100
	feedback_add_details("changeling_powers","US")
	return 1