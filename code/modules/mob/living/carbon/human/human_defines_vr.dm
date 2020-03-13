/mob/living/carbon/human
	r_skin = 238 // TO DO: Set defaults for other races.
	g_skin = 206
	b_skin = 179

	var/wagging = 0 //UGH.
	var/flapping = 0
	var/vantag_pref = VANTAG_NONE //What's my status?
	var/impersonate_bodytype //For impersonating a bodytype
	var/ability_flags = 0	//Shadekin abilities/potentially other species-based?
	var/sensorpref = 5		//Suit sensor loadout pref

/mob/living/carbon/human/proc/shadekin_get_energy()
	var/datum/species/shadekin/SK = species

	if(!istype(SK))
		return 0

	return SK.get_energy(src)

/mob/living/carbon/human/proc/shadekin_get_max_energy()
	var/datum/species/shadekin/SK = species

	if(!istype(SK))
		return 0

	return SK.get_max_energy(src)

/mob/living/carbon/human/proc/shadekin_set_energy(var/new_energy)
	var/datum/species/shadekin/SK = species

	if(!istype(SK))
		return 0

	SK.set_energy(src, new_energy)

/mob/living/carbon/human/proc/shadekin_set_max_energy(var/new_max_energy)
	var/datum/species/shadekin/SK = species

	if(!istype(SK))
		return 0

	SK.set_max_energy(src, new_max_energy)

/mob/living/carbon/human/proc/shadekin_adjust_energy(var/amount)
	var/datum/species/shadekin/SK = species

	if(!istype(SK))
		return 0

	SK.set_energy(src, SK.get_energy(src) + amount)