//Updated
/datum/power/changeling/paralysis_sting
	name = "Paralysis Sting"
	desc = "We silently sting a human, paralyzing them for a short time."
	genomecost = 3
	verbpath = /mob/proc/changeling_paralysis_sting

/mob/proc/changeling_paralysis_sting()
	set category = "Changeling"
	set name = "Paralysis sting (30)"
	set desc="Sting target"

	var/mob/living/carbon/T = changeling_sting(30,/mob/proc/changeling_paralysis_sting)
	if(!T)
		return FALSE
	add_attack_logs(src,T,"Paralysis sting (changeling)")
	to_chat(T, span_danger("Your muscles begin to painfully tighten."))
	T.Weaken(20)
	feedback_add_details("changeling_powers","PS")
	return TRUE
