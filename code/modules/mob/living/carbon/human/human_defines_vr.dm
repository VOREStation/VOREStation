/mob/living/carbon/human
	r_skin = 238 // TO DO: Set defaults for other races.
	g_skin = 206
	b_skin = 179

	//Marking colour and style
	var/list/m_colours = DEFAULT_MARKING_COLOURS //All colours set to #000000.
	var/list/m_styles = DEFAULT_MARKING_STYLES //All markings set to None.

	var/datum/body_accessory/body_accessory = null