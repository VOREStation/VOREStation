// 'Wire hints' are the pieces of text on the bottom of the window that give you clues on what you're doing.
// E.g. a power light turning on or off.
// They are their own object in order to allow for logic to make them go bold if they change.

/datum/wire_hint
	var/last_state = null	// Current state of the hint. Can be TRUE, FALSE, or null if nobody has interacted yet.
	var/true_text			// Text to display in the hacking window when the current state is true.
	var/false_text			// Ditto, but shown when false.

/datum/wire_hint/New(new_true_text, new_false_text)
	true_text = new_true_text
	false_text = new_false_text

// Returns text based on the state being inputted.
// If that state is different from last time, the text will be bolded.
/datum/wire_hint/proc/show(current_state)
	var/state_changed = FALSE
	if(last_state != null)
		if(last_state != current_state)
			state_changed = TRUE
	last_state = current_state
	if(last_state)
		return state_changed ? "<br><b>[true_text]</b>" : "<br>[true_text]"
	return state_changed ? "<br><b>[false_text]</b>" : "<br>[false_text]"

/datum/wire_hint/proc/reset_memory()
	last_state = null