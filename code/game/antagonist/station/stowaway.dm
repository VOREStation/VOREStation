var/global/datum/antagonist/stowaway/stowaways

/datum/antagonist/STOWAWAY
	id = MODE_STOWAWAY
	role_type = BE_RENEGADE
	role_text = "Stowaway"
	role_text_plural = "Stowaways"
	bantype = "renegade"
	avoid_silicons = TRUE // This was previously allowing cyborgs to be stowaways, but given that they would just connect to the AI, it didn't make much sense
	welcome_text = "People are known to run from many things, or to many things, for many different reasons. You happen to be one of those people."
	antag_text = "You are a <b>minor</b> antagonist! Within the server rules, do whatever it is \
		that you came to the station to do. Espionage, thievery, or just running from the law are all examples. \
		Try to make sure other players have <i>fun</i>! If you are confused or at a loss, always adminhelp, \
		and before taking extreme actions, please try to also contact the administration! \
		Think through your actions and make the roleplay immersive! <b>Please remember all \
		rules aside from those with explicit exceptions apply to antagonists.</b>"
	flags = ANTAG_SUSPICIOUS | ANTAG_IMPLANT_IMMUNE | ANTAG_RANDSPAWN | ANTAG_VOTABLE
	can_speak_aooc = FALSE
