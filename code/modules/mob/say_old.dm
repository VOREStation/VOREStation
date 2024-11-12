// Allows the usage of old style chat inputs even with TG Say enabled
/mob/verb/say_verb_ch()
	set name = "Say Old"
	set category = "IC.Chat"

	client?.start_thinking()
	client?.start_typing()
	var/message = tgui_input_text(usr, "Speak to people in sight.\nType your message:", "Say")
	client?.stop_thinking()

	if(message)
		say_verb(message)

/mob/verb/me_verb_ch()
	set name = "Me Old"
	set category = "IC.Chat"
	set desc = "Emote to nearby people (and your pred/prey)"

	client?.start_thinking()
	client?.start_typing()
	var/message = tgui_input_text(usr, "Emote to people in sight (and your pred/prey).\nType your message:", "Emote", multiline = TRUE)
	client?.stop_thinking()

	if(message)
		me_verb(message)

/mob/verb/whisper_ch()
	set name = "Whisper Old"
	set category = "IC.Subtle"

	var/message = tgui_input_text(usr, "Speak to nearby people.\nType your message:", "Whisper")

	if(message)
		whisper(message)


/mob/verb/me_verb_subtle_ch()
	set name = "Subtle Old"
	set category = "IC.Subtle"
	set desc = "Emote to nearby people (and your pred/prey)"

	var/message = tgui_input_text(usr, "Emote to nearby people (and your pred/prey).\nType your message:", "Subtle", multiline = TRUE)

	if(message)
		me_verb_subtle(message)

/mob/verb/me_verb_subtle_custom_ch()
	set name = "Subtle (Custom) Old"
	set category = "IC.Subtle"
	set desc = "Emote to nearby people, with ability to choose which specific portion of people you wish to target."

	var/message = tgui_input_text(usr, "Emote to nearby people, with ability to choose which specific portion of people you wish to target.\nType your message:", "Subtle (Custom)", multiline = TRUE)

	if(message)
		me_verb_subtle_custom(message)

/mob/verb/psay_ch()
	set name = "Psay Old"
	set category = "IC.Subtle"

	var/message = tgui_input_text(usr, "Talk to people affected by complete absorbed or dominate predator/prey.\nType your message:", "Psay")

	if(message)
		psay(message)

/mob/verb/pme_ch()
	set name = "Pme Old"
	set category = "IC.Subtle"

	var/message = tgui_input_text(usr, "Emote to people affected by complete absorbed or dominate predator/prey.\nType your message:", "Pme")

	if(message)
		pme(message)

/mob/living/verb/player_narrate_ch()
	set name = "Narrate (Player) Old"
	set category = "IC.Chat"

	var/message = tgui_input_text(usr, "Narrate an action or event! An alternative to emoting, for when your emote shouldn't start with your name!\nType your message:", "Narrate (Player)")

	if(message)
		player_narrate(message)
