var/datum/antagonist/shipwreck_survivor/survivors

//Shipwreck survivors can only spawn from ghost_pods at time of this commit.
//These are NOT meant to be real antagonists
//They are, at best, comparable to ERT.
/datum/antagonist/SURVIVOR
	id = MODE_SURVIVOR
	role_type = BE_SURVIVOR
	role_text = "Shipwreck Survivor"
	role_text_plural = "Shipwreck Survivors"
	bantype = "Shipwreck Survivor" //also blocked by GhostRoles ban, in current implementation at least
	welcome_text = "Something disastrous happened to the ship you were on! You awaken to your supposed rescuers in pain..."
	antag_text = "You are a <b>NOT</b> an antagonist! All rules apply to you as well. Your job is to help make the world seem more alive. \n \
	You are not an existing station character, but some average person who has suffered a terrible accident. \
	Feel free to make up what happened to the ship you awakened on as you please, \
	but listening to your rescuers for context might help improve your mutual immersion! \n \
	Please play along. It is OK to not be co-operative, but <i>'yes, and'</i> and \
	<i>'no, but'</i> are better ways to approach things than to shut them down outright.\n\n \
	Please ahelp if you are uncertain about anything pertaining to this role. \
	It is always better to be safe than sorry! \n\n \
	You will receive the option to set your ambitions. Please remember the server rules \
	abuse can mean being banned from ghost roles \n \
	You should use your ambitions to flesh out why your ship got wrecked \
	and how you wish to proceed now that you were rescued. \n \
	You <b>DON'T</b> need to set your ambitions. Feel free to ignore them."

	antag_sound = 'sound/voice/hiss1.ogg'

	can_speak_aooc = FALSE
	can_hear_aooc = FALSE

/datum/antagonist/SURVIVOR/greet(var/datum/mind/player)
	to_chat(player.current, SPAN_WARNING("You are a <b>NOT</b> an antagonist! All rules apply to you as well. Your job is to help make the world seem more alive. \n \
	You are not an existing station character, but some average person who has suffered a terrible accident. \
	Feel free to make up what happened to the ship you awakened on as you please, \
	but listening to your rescuers for context might help improve your mutual immersion! \n \
	Please play along. It is OK to not be co-operative, but <i>'yes, and'</i> and \
	<i>'no, but'</i> are better ways to approach things than to shut them down outright.\n\n \
	Please ahelp if you are uncertain about anything pertaining to this role. \
	It is always better to be safe than sorry! \n\n \
	You will receive the option to set your ambitions. Please remember the server rules \
	abuse can mean being banned from ghost roles \n \
	You should use your ambitions to flesh out why your ship got wrecked \
	and how you wish to proceed now that you were rescued. \n \
	You <b>DON'T</b> need to set your ambitions. Feel free to ignore them."))
