/datum/power/changeling/fleshmend
	name = "Fleshmend"
	desc = "Begins a slow regeneration of our form.  Does not effect stuns or chemicals."
	helptext = "Can be used while unconscious."
	enhancedtext = "Healing is twice as effective."
	ability_icon_state = "ling_fleshmend"
	genomecost = 1
	verbpath = /mob/proc/changeling_fleshmend

//Starts healing you every second for 50 seconds. Can be used whilst unconscious.
/mob/proc/changeling_fleshmend()
	set category = "Changeling"
	set name = "Fleshmend (10)"
	set desc = "Begins a slow rengeration of our form.  Does not effect stuns or chemicals."

	var/mob/living/C = src
	var/datum/component/antag/changeling/changeling = changeling_power(10,0,100,UNCONSCIOUS)
	if(!changeling)
		return FALSE
	if(C.has_modifier_of_type(/datum/modifier/fleshmend))
		to_chat(src, span_notice("We are already under the effect of fleshmend."))
		return FALSE

	changeling.chem_charges -= 10

	if(changeling.recursive_enhancement)
		to_chat(src, span_notice("We will heal much faster."))
		C.add_modifier(/datum/modifier/fleshmend/recursive, 50 SECONDS)
	else
		C.add_modifier(/datum/modifier/fleshmend, 50 SECONDS)

	feedback_add_details("changeling_powers","FM")
	return TRUE

/datum/modifier/fleshmend
	name = "Fleshmend"
	desc = "We are regenerating"

// For changelings who bought the Recursive Enhancement evolution.
/datum/modifier/fleshmend/recursive
	name = "Advanced Fleshmend"
	desc = "We are regenerating more rapidly."

//These were previously 2 or 4 per second, now it's 4 or 8 per 2 seconds
/datum/modifier/fleshmend/tick()
	holder.adjustBruteLoss(-4)
	holder.adjustOxyLoss(-4)
	holder.adjustFireLoss(-4)

/datum/modifier/fleshmend/recursive/tick()
	holder.adjustBruteLoss(-8)
	holder.adjustOxyLoss(-8)
	holder.adjustFireLoss(-8)
