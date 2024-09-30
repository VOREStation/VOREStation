//Universal translator
/obj/item/universal_translator
	name = "handheld translator"
	desc = "This handy device appears to translate the languages it hears into onscreen text for a user."
	icon = 'icons/obj/device.dmi'
	icon_state = "translator"
	w_class = ITEMSIZE_NORMAL
	origin_tech = list(TECH_DATA = 3, TECH_ENGINEERING = 3)
	var/mult_icons = 1	//Changes sprite when it translates
	var/visual = 1		//If you need to see to get the message
	var/audio = 0		//If you need to hear to get the message
	var/listening = 0
	var/datum/language/langset

/obj/item/universal_translator/attack_self(mob/user)
	if(!listening) //Turning ON
		langset = tgui_input_list(user,"Translate to which of your languages?","Language Selection", user.languages)
		if(langset)
			if(langset && ((langset.flags & NONVERBAL) || (langset.flags & HIVEMIND) || (!langset.machine_understands)))
				//Nonverbal means no spoken words to translate, so I didn't see the need to remove it.
				to_chat(user, "<span class='warning'>\The [src] cannot output that language.</span>")
				return
			else
				listening = 1
				listening_objects |= src
				if(mult_icons)
					icon_state = "[initial(icon_state)]1"
				to_chat(user, "<span class='notice'>You enable \the [src], translating into [langset.name].</span>")
	else	//Turning OFF
		listening = 0
		listening_objects -= src
		langset = null
		icon_state = "[initial(icon_state)]"
		to_chat(user, "<span class='notice'>You disable \the [src].</span>")

/obj/item/universal_translator/hear_talk(mob/M, list/message_pieces, verb)
	if(!listening || !istype(M))
		return

	//Show the "I heard something" animation.
	if(mult_icons)
		flick("[initial(icon_state)]2",src)

	//Handheld or pocket only.
	if(!isliving(loc))
		return

	var/mob/living/L = loc
	if(visual && ((L.sdisabilities & BLIND) || L.eye_blind))
		return
	if(audio && ((L.sdisabilities & DEAF) || L.ear_deaf))
		return

	// Using two for loops kinda sucks, but I think it's more efficient
	// to shortcut past string building if we're just going to discard the string
	// anyways.
	if(user_understands(M, L, message_pieces))
		return

	var/new_message = ""

	for(var/datum/multilingual_say_piece/S in message_pieces)
		if(S.speaking.flags & NONVERBAL)
			continue
		if(!S.speaking.machine_understands)
			new_message += stars(S.message) + " "
			continue

		new_message += (S.message + " ")

	if(!L.say_understands(null, langset))
		new_message = langset.scramble(new_message)

	to_chat(L, "<span class='filter_say'><i><b>[src]</b> translates, </i>\"<span class='[langset.colour]'>[new_message]</span>\"</span>")

/obj/item/universal_translator/proc/user_understands(mob/M, mob/living/L, list/message_pieces)
	for(var/datum/multilingual_say_piece/S in message_pieces)
		if(S.speaking && !L.say_understands(M, S.speaking))
			return FALSE
	return TRUE

//Let's try an ear-worn version
/obj/item/universal_translator/ear
	name = "translator earpiece"
	desc = "This handy device appears to translate the languages it hears into another language for a user."
	icon_state = "earpiece"
	w_class = ITEMSIZE_TINY
	slot_flags = SLOT_EARS
	visual = 0
	audio = 1