/datum/power/changeling/EngorgedGlands
	name = "Engorged Chemical Glands"
	desc = "Our chemical glands swell, permitting us to store more chemicals inside of them."
	helptext = "Allows us to store an extra 30 units of chemicals, and doubles production rate."
	genomecost = 1
	isVerb = 0
	verbpath = /mob/proc/changeling_engorgedglands

//Increases macimum chemical storage
/mob/proc/changeling_engorgedglands()
	var/datum/component/antag/changeling/comp = GetComponent(/datum/component/antag/changeling)
	comp.chem_storage += 30
	comp.chem_recharge_rate *= 2
	return 1
