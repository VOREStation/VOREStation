//Universal translator
/obj/item/device/universal_translator
	name = "handheld translator"
	desc = "This handy device appears to translate the languages it hears into onscreen text for a user."
	icon = 'icons/obj/device.dmi'
	icon_state = "translator"
	w_class = ITEMSIZE_SMALL
	origin_tech = list(TECH_DATA = 3, TECH_ENGINEERING = 3)
	var/listening = 0
	var/datum/language/langset

/obj/item/device/universal_translator/attack_self(mob/user)
	if(!listening) //Turning ON
		langset = input(user,"Translate to which of your languages?","Language Selection") as null|anything in user.languages
		if(langset)
			listening = 1
			listening_objects |= src
			icon_state = "[initial(icon_state)]1"
			to_chat(user, "<span class='notice'>You enable \the [src], translating into [langset.name].</span>")
	else	//Turning OFF
		listening = 0
		listening_objects -= src
		langset = null
		icon_state = "[initial(icon_state)]"
		to_chat(user, "<span class='notice'>You disable \the [src].</span>")

/obj/item/device/universal_translator/hear_talk(var/mob/speaker, var/message, var/vrb, var/datum/language/language)
	if(!listening || !istype(speaker))
		return

	//Show the "I heard something" animation.
	flick("[initial(icon_state)]2",src)

	//Handheld or pocket only.
	if(!isliving(loc))
		return

	var/mob/living/L = loc

	if (language && (language.flags & NONVERBAL))
		return //Not gonna translate sign language

	//Only translate if they can't understand, otherwise pointlessly spammy
	//I'll just assume they don't look at the screen in that case

	//They don't understand the spoken language we're translating FROM
	if(!L.say_understands(speaker,language))
		//They understand the PRINTED language
		if(L.say_understands(null,langset))
			to_chat(L, "<i><b>[src]</b> displays, </i>\"<span class='[langset.colour]'>[message]</span>\"")

		//They don't understand the PRINTED language
		else
			to_chat(L, "<i><b>[src]</b> displays, </i>\"<span class='[langset.colour]'>[langset.scramble(message)]</span>\"")
