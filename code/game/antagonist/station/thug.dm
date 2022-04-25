var/global/datum/antagonist/thug/thugs

/datum/antagonist/THUG
	id = MODE_THUG
	role_type = BE_RENEGADE
	role_text = "Thug"
	role_text_plural = "Thugs"
	bantype = "renegade"
	avoid_silicons = TRUE
	welcome_text = "Sometimes, people just need to get messed up. Luckily, that's what you're here to do."
	antag_text = "You are a <b>minor</b> antagonist! Within the server rules, do whatever it is \
		that you came to the station to do, be it violence, theft, or just extreme self-defense. \
		Try to make sure other players have <i>fun</i>! If you are confused or at a loss, always adminhelp, \
		and before taking extreme actions, please try to also contact the administration! \
		Think through your actions and make the roleplay immersive! <b>Please remember all \
		rules aside from those with explicit exceptions apply to antagonists.</b>"
	flags = ANTAG_SUSPICIOUS | ANTAG_IMPLANT_IMMUNE | ANTAG_RANDSPAWN | ANTAG_VOTABLE
	can_speak_aooc = FALSE
