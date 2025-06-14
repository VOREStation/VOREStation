/datum/power/changeling/cryo_sting
	name = "Cryogenic Sting"
	desc = "We silently sting a biological with a cocktail of chemicals that freeze them."
	helptext = "Does not provide a warning to the victim, though they will likely realize they are suddenly freezing.  Has \
	a three minute cooldown between uses."
	enhancedtext = "Increases the amount of chemicals injected."
	ability_icon_state = "ling_sting_cryo"
	genomecost = 1
	verbpath = /mob/proc/changeling_cryo_sting

/mob/proc/changeling_cryo_sting()
	set category = "Changeling"
	set name = "Cryogenic Sting (20)"
	set desc = "Chills and freezes a biological creature."

	var/mob/living/carbon/T = changeling_sting(20,/mob/proc/changeling_cryo_sting, CRYO_STING)
	var/datum/component/antag/changeling/comp = is_changeling(src)
	if(!T)
		return FALSE
	if(comp.is_on_cooldown(CRYO_STING))
		to_chat(src, span_notice("We are still recovering. We will be able to sting again in [(comp.get_cooldown(CRYO_STING) - world.time)/10] seconds."))
		return

	add_attack_logs(src,T,"Cryo sting (changeling)")
	var/inject_amount = 10
	if(comp.recursive_enhancement)
		inject_amount = inject_amount * 1.5
		to_chat(src, span_notice("We inject extra chemicals."))
	if(T.reagents)
		T.reagents.add_reagent(REAGENT_ID_CRYOTOXIN, inject_amount)
	feedback_add_details("changeling_powers","CS")
	comp.set_cooldown(CRYO_STING, 3 MINUTES) //Set the cooldown to 3 minutes.
	addtimer(CALLBACK(src, PROC_REF(changeling_cryo_sting_ready)), 3 MINUTES, TIMER_DELETE_ME) //Calling a proc with arguments
	return TRUE

/mob/proc/changeling_cryo_sting_ready()
	to_chat(src, span_notice("Our cryogenic string is ready to be used once more."))
