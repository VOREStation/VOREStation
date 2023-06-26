// These looping sounds work off of a sequence of things (usually letters or numbers) given to them.

// Base sequencer type.
/datum/looping_sound/sequence
	var/sequence = "The quick brown fox jumps over the lazy dog"	// The string to iterate over.
	var/position = 1				// Where we are inside the sequence. IE the index we're on for the above.
	var/loop_sequence = TRUE		// If it should loop the entire sequence upon reaching the end. Otherwise stop() is called.
	var/repeat_sequnce_delay = 2 SECONDS // How long to wait when reaching the end, if the above var is true, in deciseconds.
	var/next_iteration_delay = 0

/datum/looping_sound/sequence/vv_edit_var(var_name, var_value)
	if(var_name == "sequence")
		set_new_sequence(var_value)
	return ..()

/datum/looping_sound/sequence/proc/iterate_on_sequence()
	var/data = get_data_from_position()
	next_iteration_delay = process_data(data)
	increment_position()

/datum/looping_sound/sequence/proc/get_data_from_position()
	return sequence[position]

// Override to do something based on the input.
/datum/looping_sound/sequence/proc/process_data(input)
	return

// Changes the sequence, and sets the position back to the start.
/datum/looping_sound/sequence/proc/set_new_sequence(new_sequence)
	sequence = new_sequence
	reset_position()

// Called to advance the position, and handle reaching the end if so.
/datum/looping_sound/sequence/proc/increment_position()
	position++
	if(position > get_max_position())
		reached_end_of_sequence()

/datum/looping_sound/sequence/proc/get_max_position()
	return length(sequence)

/datum/looping_sound/sequence/proc/reset_position()
	position = 1

// Called when the sequence is finished being iterated over.
// If looping is on, the position will be reset, otherwise processing will stop.
/datum/looping_sound/sequence/proc/reached_end_of_sequence()
	if(loop_sequence)
		next_iteration_delay += repeat_sequnce_delay
		reset_position()
	else
		stop()

/datum/looping_sound/sequence/sound_loop(starttime)
	iterate_on_sequence()

	timerid = addtimer(CALLBACK(src, PROC_REF(sound_loop), world.time), next_iteration_delay, TIMER_STOPPABLE)

#define MORSE_DOT	"*" // Yes this is an asterisk but its easier to see on a computer compared to a period.
#define MORSE_DASH	"-"
#define MORSE_BASE_DELAY 1 // If you change this you will also need to change [dot|dash]_soundfile variables.

// This implements an automatic conversion of text (the sequence) into audible morse code.
// This can be useful for flavor purposes. For 'real' usage its suggested to also display the sequence in text form, for the benefit of those without sound.
/datum/looping_sound/sequence/morse
	// This is just to pass validation in the base type.
	mid_sounds = list('sound/effects/tones/440_sine_01.ogg')
	mid_length = 1
	opacity_check = TRUE // So we don't have to constantly hear it when out of sight.

	// Dots.
	// In Morse Code, the dot's length is one unit.
	var/dot_soundfile = 'sound/effects/tones/440_sine_01.ogg'	// The sound file to play for a 'dot'.
	var/dot_delay = MORSE_BASE_DELAY // How long the sound above plays for, in deciseconds.

	// Dashes.
	// In Morse Code, a dash's length is equal to three units (or three dots).
	var/dash_soundfile = 'sound/effects/tones/440_sine_03.ogg'	// The sound file to play for a 'dash'.
	var/dash_delay = MORSE_BASE_DELAY * 3 // Same as the dot delay, except for the dash sound.

	// Spaces.
	// In Morse Code, a space's length is equal to one unit (or one dot).
	var/spaces_between_sounds = MORSE_BASE_DELAY	// How many spaces are between parts of the same letter.
	var/spaces_between_letters = MORSE_BASE_DELAY * 3	// How many spaces are between different letters in the same word.
	var/spaces_between_words = MORSE_BASE_DELAY * 7	// How many spaces are between different words.

	// Morse Alphabet.
	// Note that it is case-insensative. 'A' and 'a' will make the same sounds.
	// Unfortunately there isn't a nice way to implement procedure signs w/o the space inbetween the letters.
	// Also some of the punctuation isn't super offical/widespread in real life but its the future so *shrug.
	var/static/list/morse_alphabet = list(
		"A" = list("*", "-"),
		"B" = list("-", "*", "*", "*"),
		"C" = list("-", "*", "-", "*"),
		"D" = list("-", "*", "*"),
		"E" = list("*"),
		"F" = list("*", "*", "-", "*"),
		"G" = list("-", "-", "*"),
		"H" = list("*", "*", "*", "*"),
		"I" = list("*", "*"),
		"J" = list("*", "-", "-", "-"),
		"K" = list("-", "*", "-"),
		"L" = list("*", "-", "*", "*"),
		"M" = list("*", "*"),
		"N" = list("-", "*"),
		"O" = list("-", "-", "-"),
		"P" = list("*", "-", "-", "*"),
		"Q" = list("-", "-", "*", "-"),
		"R" = list("*", "-", "*"),
		"S" = list("*", "*", "*"),
		"T" = list("-"),
		"U" = list("*", "*", "-"),
		"V" = list("*", "*", "*", "-"),
		"W" = list("*", "-", "-"),
		"X" = list("-", "*", "*", "-"),
		"Y" = list("-", "*", "-", "-"),
		"Z" = list("-", "-", "*", "*"),

		"1" = list("*", "-", "-", "-", "-"),
		"2" = list("*", "*", "-", "-", "-"),
		"3" = list("*", "*", "*", "-", "-"),
		"4" = list("*", "*", "*", "*", "-"),
		"5" = list("*", "*", "*", "*", "*"),
		"6" = list("-", "*", "*", "*", "*"),
		"7" = list("-", "-", "*", "*", "*"),
		"8" = list("-", "-", "-", "*", "*"),
		"9" = list("-", "-", "-", "-", "*"),
		"0" = list("-", "-", "-", "-", "-"),

		"." = list("*", "-", "*", "-", "*", "-"),
		"," = list("-", "-", "*", "*", "-", "-"),
		"?" = list("*", "*", "-", "-", "*", "*"),
		"'" = list("*", "-", "-", "-", "-", "*"),
		"!" = list("-", "*", "-", "*", "-", "-"),
		"/" = list("-", "*", "*", "-", "*"),
		"(" = list("-", "*", "-", "-", "*"),
		")" = list("-", "*", "-", "-", "*", "-"),
		"&" = list("*", "-", "*", "*", "*"),
		":" = list("-", "-", "-", "*", "*", "*"),
		";" = list("-", "*", "-", "*", "-", "*"),
		"=" = list("-", "*", "*", "*", "-"),
		"+" = list("*", "-", "*", "-", "*"),
		"-" = list("-", "*", "*", "*", "*", "-"),
		"_" = list("*", "*", "-", "-", "*", "-"),
		"\""= list("*", "-", "*", "*", "-", "*"),
		"$" = list("*", "*", "*", "-", "*", "*", "-"),
		"@" = list("*", "-", "-", "*", "-", "*"),
	)


/datum/looping_sound/sequence/morse/process_data(letter)
	letter = uppertext(letter) // Make it case-insensative.

	// If it's whitespace, treat it as a (Morse) space.
	if(letter == " ")
		return spaces_between_words

	if(!(letter in morse_alphabet))
		CRASH("Encountered invalid character in Morse sequence \"[letter]\".")

	// So I heard you like sequences...
	// Play a sequence of sounds while inside the current iteration of the outer sequence.
	var/list/instructions = morse_alphabet[letter]
	for(var/sound in instructions)
		if(sound == MORSE_DOT)
			play(dot_soundfile)
			sleep(dot_delay)
		else // It's a dash otherwise.
			play(dash_soundfile)
			sleep(dash_delay)
		sleep(spaces_between_sounds)
	return spaces_between_letters

#undef MORSE_DOT
#undef MORSE_DASH
