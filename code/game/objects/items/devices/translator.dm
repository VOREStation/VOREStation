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
				to_chat(user, span_warning("\The [src] cannot output that language."))
				return
			else
				listening = 1
				listening_objects |= src
				if(mult_icons)
					icon_state = "[initial(icon_state)]1"
				to_chat(user, span_notice("You enable \the [src], translating into [langset.name]."))
	else	//Turning OFF
		listening = 0
		listening_objects -= src
		langset = null
		icon_state = "[initial(icon_state)]"
		to_chat(user, span_notice("You disable \the [src]."))

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

	to_chat(L, span_filter_say("<i><b>[src]</b> translates, </i>\"<span class='[langset.colour]'>[new_message]</span>\""))

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

//////////////Single language translators


/obj/item/universal_translator/limited
	name = "handheld translator (galcom)"
	desc = "This handy device appears to translate specific languages that it hears into onscreen text for a user."
	var/list/known_languages = list(LANGUAGE_GALCOM)
	icon_state = "translator_small"

/obj/item/universal_translator/limited/hear_talk(mob/M, list/message_pieces, verb)
	if(!listening || !istype(M))
		return

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
	var/confirm = 0

	for(var/datum/multilingual_say_piece/S in message_pieces)
		if(S.speaking.name in known_languages)
			confirm = 1
			new_message += (S.message + " ")

	if(!L.say_understands(null, langset))
		new_message = langset.scramble(new_message)

	//Show the "I heard something" animation, only if it's an appropriate language!
	if(mult_icons && confirm)
		flick("[initial(icon_state)]2",src)

	if(confirm) //Don't show a message at all if there's no recognised language, that'd just be annoying.
		to_chat(L, span_filter_say("<i><b>[src]</b> translates, </i>\"<span class='[langset.colour]'>[new_message]</span>\""))

/obj/item/universal_translator/limited/sol
	name = "handheld translator (solcom)"
	known_languages = list(LANGUAGE_SOL_COMMON)

/obj/item/universal_translator/limited/terminus
	name = "handheld translator (terminus)"
	known_languages = list(LANGUAGE_TERMINUS)

/obj/item/universal_translator/limited/tradeband
	name = "handheld translator (tradeband)"
	known_languages = list(LANGUAGE_TRADEBAND)

/obj/item/universal_translator/limited/gutterband
	name = "handheld translator (gutterband)"
	known_languages = list(LANGUAGE_GUTTER)

/obj/item/universal_translator/limited/skrellian
	name = "handheld translator (skrellian)"
	known_languages = list(LANGUAGE_SKRELLIAN)

/obj/item/universal_translator/limited/unathi
	name = "handheld translator (sinta'unathi)"
	known_languages = list(LANGUAGE_UNATHI)

/obj/item/universal_translator/limited/siik
	name = "handheld translator (siik)"
	known_languages = list(LANGUAGE_SIIK)

/obj/item/universal_translator/limited/schechi
	name = "handheld translator (schechi)"
	known_languages = list(LANGUAGE_SCHECHI)

/obj/item/universal_translator/limited/vedaqh
	name = "handheld translator (vedaqh)"
	known_languages = list(LANGUAGE_ZADDAT)

/obj/item/universal_translator/limited/birdsong
	name = "handheld translator (birdsong)"
	known_languages = list(LANGUAGE_BIRDSONG)

/obj/item/universal_translator/limited/sagaru
	name = "handheld translator (sagaru)"
	known_languages = list(LANGUAGE_SAGARU)

/obj/item/universal_translator/limited/canilunzt
	name = "handheld translator (canilunzt)"
	known_languages = list(LANGUAGE_CANILUNZT)

/obj/item/universal_translator/limited/ecureuilian
	name = "handheld translator (ecureuilian)"
	known_languages = list(LANGUAGE_ECUREUILIAN)

/obj/item/universal_translator/limited/daemon
	name = "handheld translator (daemon)"
	known_languages = list(LANGUAGE_DAEMON)

/obj/item/universal_translator/limited/enochian
	name = "handheld translator (enochian)"
	known_languages = list(LANGUAGE_ENOCHIAN)

/obj/item/universal_translator/limited/vespinae
	name = "handheld translator (vespinae)"
	known_languages = list(LANGUAGE_VESPINAE)

/obj/item/universal_translator/limited/dragon
	name = "handheld translator (d'rudak'ar)"
	known_languages = list(LANGUAGE_DRUDAKAR)

/obj/item/universal_translator/limited/spacer
	name = "handheld translator (spacer)"
	known_languages = list(LANGUAGE_SPACER)

/obj/item/universal_translator/limited/tavan
	name = "handheld translator (tavan)"
	known_languages = list(LANGUAGE_TAVAN)

/obj/item/universal_translator/limited/echosong
	name = "handheld translator (echo song)"
	known_languages = list(LANGUAGE_ECHOSONG)

/obj/item/universal_translator/limited/akhani
	name = "handheld translator (akhani)"
	known_languages = list(LANGUAGE_AKHANI)

/obj/item/universal_translator/limited/alai
	name = "handheld translator (alai)"
	known_languages = list(LANGUAGE_ALAI)

/obj/item/universal_translator/limited/glamour  //Admin spawn only, just here for utility
	name = "handheld translator (glamourspeak)"
	known_languages = list(LANGUAGE_LLEILL)

/obj/item/universal_translator/limited/teppi  //Admin spawn only, just here for utility
	name = "handheld translator (teppi)"
	known_languages = list(LANGUAGE_TEPPI)
