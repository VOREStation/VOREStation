//Updated
/datum/power/changeling/boost_range
	name = "Boost Range"
	desc = "We evolve the ability to shoot our stingers at humans, with some preperation."
	helptext = "Allows us to prepare the next sting to have a range of two tiles."
	enhancedtext = "The range is extended to five tiles."
	ability_icon_state = "ling_sting_boost_range"
	genomecost = 1
	allowduringlesserform = TRUE
	verbpath = /mob/proc/changeling_boost_range

//Boosts the range of your next sting attack by 1
/mob/proc/changeling_boost_range()
	set category = "Changeling"
	set name = "Ranged Sting (10)"
	set desc="Your next sting ability can be used against targets 2 squares away."

	var/datum/component/antag/changeling/changeling = changeling_power(10,0,100)
	if(!changeling)
		return FALSE
	if(!changeling.recursive_enhancement && changeling.sting_range > 1)
		to_chat(src, span_notice("We have already empowered our sting!"))
		return
	else if(changeling.recursive_enhancement && changeling.sting_range > 2)
		to_chat(src, span_notice("We have already empowered our sting!"))
		return
	changeling.chem_charges -= 10
	to_chat(src, span_notice("Your throat adjusts to launch the sting."))
	var/range = 2
	if(changeling.recursive_enhancement)
		range = range + 3
		to_chat(src, span_notice("We can fire our next sting from five squares away."))
	changeling.sting_range = range
	feedback_add_details("changeling_powers","RS")
	return TRUE
