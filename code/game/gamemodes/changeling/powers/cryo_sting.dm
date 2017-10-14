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

	var/mob/living/carbon/T = changeling_sting(20,/mob/proc/changeling_cryo_sting)
	if(!T)
		return 0
	T.attack_log += text("\[[time_stamp()]\] <font color='red'>Was cryo stung by [key_name(src)]</font>")
	src.attack_log += text("\[[time_stamp()]\] <font color='orange'> Used cryo sting on [key_name(T)]</font>")
	msg_admin_attack("[key_name(T)] was cryo stung by [key_name(src)]")
	var/inject_amount = 10
	if(src.mind.changeling.recursive_enhancement)
		inject_amount = inject_amount * 1.5
		src << "<span class='notice'>We inject extra chemicals.</span>"
	if(T.reagents)
		T.reagents.add_reagent("cryotoxin", inject_amount)
	feedback_add_details("changeling_powers","CS")
	src.verbs -= /mob/proc/changeling_cryo_sting
	spawn(3 MINUTES)
		src << "<span class='notice'>Our cryogenic string is ready to be used once more.</span>"
		src.verbs |= /mob/proc/changeling_cryo_sting
	return 1