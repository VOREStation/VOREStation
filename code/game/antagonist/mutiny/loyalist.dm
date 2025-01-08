GLOBAL_DATUM(loyalists, /datum/antagonist/mutineer/loyalist)

/datum/antagonist/mutineer/loyalist
	role_text = "Loyalist"
	role_text_plural = "Loyalists"
	id = MODE_LOYALIST

/datum/antagonist/mutineer/loyalist/New()
	..(1)
	GLOB.loyalists = src
