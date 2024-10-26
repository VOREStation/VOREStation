/obj/item/hailer
	name = "hailer"
	desc = "Used by obese officers to save their breath for running."
	icon_state = "voice0"
	item_state = "flashbang"	//looks exactly like a flash (and nothing like a flashbang)
	w_class = ITEMSIZE_TINY
	slot_flags = SLOT_EARS

	var/use_message = "Halt! Security!"
	var/spamcheck = 0
	var/insults

	pickup_sound = 'sound/items/pickup/device.ogg'
	drop_sound = 'sound/items/drop/device.ogg'

/obj/item/hailer/verb/set_message()
	set name = "Set Hailer Message"
	set category = "Object"
	set desc = "Alter the message shouted by your hailer."

	if(!isnull(insults))
		to_chat(usr, "The hailer is fried. The tiny input screen just shows a waving ASCII penis.")
		return

	var/new_message = tgui_input_text(usr, "Please enter new message (leave blank to reset).")
	if(!new_message || new_message == "")
		use_message = "Halt! Security!"
	else
		use_message = capitalize(copytext(sanitize(new_message), 1, MAX_MESSAGE_LEN))

	to_chat(usr, "You configure the hailer to shout \"[use_message]\".")

/obj/item/hailer/attack_self(mob/living/carbon/user as mob)
	if (spamcheck)
		return

	if(isnull(insults))
		playsound(src, 'sound/voice/halt.ogg', 100, 1, vary = 0)
		user.audible_message(span_warning("[user]'s [name] rasps, \"[use_message]\""), span_warning("\The [user] holds up \the [name]."), runemessage = "\[TTS Voice\] [use_message]")
	else
		if(insults > 0)
			playsound(src, 'sound/voice/binsult.ogg', 100, 1, vary = 0)
			// Yes, it used to show the transcription of the sound clip. That was a) inaccurate b) immature as shit.
			user.audible_message(span_warning("[user]'s [name] gurgles something indecipherable and deeply offensive."), span_warning("\The [user] holds up \the [name]."), runemessage = "\[TTS Voice\] #&@&^%(*")
			insults--
		else
			to_chat(user, span_danger("*BZZZZZZZZT*"))

	spamcheck = 1
	spawn(20)
		spamcheck = 0

/obj/item/hailer/emag_act(var/remaining_charges, var/mob/user)
	if(isnull(insults))
		to_chat(user, span_danger("You overload \the [src]'s voice synthesizer."))
		insults = rand(1, 3)//to prevent dickflooding
		return 1
	else
		to_chat(user, "The hailer is fried. You can't even fit the sequencer into the input slot.")
