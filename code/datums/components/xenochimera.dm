/datum/component/xenochimera
	var/laststress = 0

/datum/component/xenochimera/Initialize()
	if(!ishuman(parent))
		return COMPONENT_INCOMPATIBLE

/* //How to make a check to use things in this component
var/datum/component/xenochimera/comp = GetComponent(/datum/component/xenochimera)
	if (comp)

*/
