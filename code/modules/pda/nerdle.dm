#define NERDLE_NO 0
#define NERDLE_YES 1
#define NERDLE_CLOSE 2

/datum/data/pda/app/nerdle
	name = "Nerdle"
	icon = "child-reaching" //yipee!
	notify_icon = "child-combatant"
	title = "Nerdle™️ V0.8"
	template = "pda_nerdle"

	var/target_word
	var/list/guesses = list() //raw text input for guesses

	var/list/serialized_guesses = list() //shortcut for tgui serialization

	var/max_guesses = 6

	var/completed = FALSE
	var/failure = FALSE


/datum/data/pda/app/nerdle/start()
	. = ..()
	target_word = SSnerdle.target_word

/datum/data/pda/app/nerdle/proc/try_guess(var/guess)
	if(completed)
		return FALSE

	if(LAZYLEN(guess) != 5)
		return FALSE

	var/actual_guess = lowertext(guess)

	serialize_guess(actual_guess)
	LAZYADD(guesses,actual_guess)

	if(actual_guess == target_word)
		pda.audible_message("[pda] says, \"congratulations! You WON! A real NERDLE™️ Champ!\"")
		playsound(pda, 'sound/arcade/win.ogg', 50, 1, extrarange = -3, falloff = 0.1, ignore_walls = FALSE)
		report_guesses()
		return TRUE

	if(LAZYLEN(guesses) >= max_guesses)
		pda.audible_message("[pda] says, \"Sorry! You lose! Try again next shift!\"")
		failure = TRUE
		playsound(pda, 'sound/arcade/lose.ogg', 50, 1, extrarange = -3, falloff = 0.1, ignore_walls = FALSE)
		report_guesses()
		return FALSE

	return TRUE

/datum/data/pda/app/nerdle/proc/report_guesses()
	SSnerdle.report_winner_or_loser(LAZYLEN(guesses),failure)

/datum/data/pda/app/nerdle/proc/serialize_guess(var/guess)
	// We assume that there's 5 letters here, both for the guess and the target word.
	// If we're getting runtimes and someone forwarded "butt" to here I'm going to smite them down.
	var/list/out[5]
	var/list/letter_counts = list() // Track occurrences of each letter in the target word

	// Count count of each letter in the target word
	for(var/i in 1 to 5)
		var/them = target_word[i]
		letter_counts[them] = (letter_counts[them] || 0) + 1

	// First pass: Mark exact matches (NERDLE_YES)
	for(var/i in 1 to 5)
		var/us = guess[i]
		var/them = target_word[i]

		if(us == them)
			out[i] = NERDLE_YES
			letter_counts[them] -= 1 // Reduce the count for this letter

	// Second pass: Mark close matches (NERDLE_CLOSE) and invalid matches (NERDLE_NO)
	for(var/i in 1 to 5)
		if(out[i]) // Skip already marked letters
			continue

		var/us = guess[i]

		if(letter_counts[us] && letter_counts[us] > 0)
			out[i] = NERDLE_CLOSE
			letter_counts[us] -= 1 // Reduce the count for this letter
		else
			out[i] = NERDLE_NO

	LAZYADD(serialized_guesses, list(out)) // Wrap it in a list so it stays a list

/datum/data/pda/app/nerdle/update_ui(mob/user as mob, list/data)
	data["guesses"] = serialized_guesses
	data["guesses_raw"] = guesses
	data["max"] = max_guesses
	data["used_guesses"] = LAZYLEN(guesses)
	data["target_word"] = target_word //if people fuck around with tgui to cheat at nerdle then I can't really be assed enough to care. we'll know who you are.

/datum/data/pda/app/nerdle/tgui_act(action, list/params, datum/tgui/ui, datum/tgui_state/state)
	if(..())
		return TRUE

	unnotify()

	. = TRUE

	if(action == "guess")
		var/guess = params["lastword"]
		var/did_we_guess = try_guess(guess)
		return did_we_guess

#undef NERDLE_YES
#undef NERDLE_NO
#undef NERDLE_CLOSE
