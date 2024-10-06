/datum/vote/crew_transfer
	question = "End the shift"
	choices = list("Initiate Crew Transfer", "Extend The Shift")
	vote_type_text = "crew transfer"
	vote_result_type = VOTE_RESULT_TYPE_SKEWED

/datum/vote/crew_transfer/New()
	if(SSticker.current_state < GAME_STATE_PLAYING)
		CRASH("Attempted to call a shutle vote before the game starts!")
	..()

/datum/vote/crew_transfer/handle_result(result)
	if(result == "Initiate Crew Transfer")
		init_shift_change(null, TRUE)
