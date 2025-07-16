//Updated
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
	if(!T)
		return FALSE
	add_attack_logs(src,T,"Unfat sting (changeling)")
	to_chat(T, span_danger("you feel a small prick as stomach churns violently and you become to feel skinnier."))
	T.adjust_nutrition(-max(100, T.nutrition/1.15)) //Decrease their nutrition by 100 or 85%, whatever is higher. Ex: 1000 nutrition becomes ~130. 6000 nutrition becomes 800.
	feedback_add_details("changeling_powers","US")
	return TRUE
