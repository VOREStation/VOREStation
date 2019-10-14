/mob/living/carbon/human
	r_skin = 238 // TO DO: Set defaults for other races.
	g_skin = 206
	b_skin = 179

	var/wagging = 0 //UGH.
	var/flapping = 0
	var/vantag_pref = VANTAG_NONE //What's my status?
	var/impersonate_bodytype //For impersonating a bodytype

	//TFF 5/8/19 - add and set suit sensor setting define to 5 for random setting
	var/sensorpref = 5