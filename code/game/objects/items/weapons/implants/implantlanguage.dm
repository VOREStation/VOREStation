//These allow someone to speak a language they are otherwise physically incapable of speaking or hearing
//They don't, at the moment, grant knowledge of the language
//The can_speak_special checks should check for the presence of the implants.

/obj/item/implant/language
	name = "GalCom language implant"
	desc = "An implant allowing someone to speak the range of frequencies used in Galactic Common, as well as produce any phonemes that they usually cannot. Only helps with producing sounds, not understanding them."
	known_implant = TRUE
	var/list/languages = list(LANGUAGE_GALCOM)	// List of languages that this assists with
	initialize_loc = BP_HEAD

/obj/item/implant/language/post_implant(mob/M)	// Amends the mob's voice organ, then deletes itself
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		var/obj/item/organ/internal/voicebox/V = locate() in H.internal_organs
		if(V)
			var/list/need_amend = list()			// If they've already got all the languages they need, then they don't need this implant to do anything
			for(var/L in languages)
				if(L in V.will_assist_languages)
					continue
				else
					need_amend |= L
			if(LAZYLEN(need_amend))
				if(V.robotic < ORGAN_ASSISTED)
					V.mechassist()
				for(var/L in need_amend)
					V.add_assistable_langs(L)
		QDEL_NULL(src)

/obj/item/implant/language/get_data()
	var/dat = {"
<b>Implant Specifications:</b><BR>
<b>Name:</b> Vey-Med L-1 Galactic Common Implant<BR>
<b>Life:</b> 5 years<BR>
<b>Important Notes:</b> Affects hearing and speech.<BR>
<HR>
<b>Implant Details:</b><BR>
<b>Function:</b> Allows a being otherwise incapable of speaking Galactic Common to produce the phonemes of the language.<BR>
<b>Special Features:</b> None.<BR>
<b>Integrity:</b> Implant will function for expected life, barring physical damage."}
	return dat


// EAL Implant
/obj/item/implant/language/eal
	name = "EAL language implant"
	desc = "An implant allowing an organic to speak Encoded Audio Language passably. Only helps with producing sounds, not understanding them."
	languages = list(LANGUAGE_EAL)

/obj/item/implant/language/eal/get_data()
	var/dat = {"
<b>Implant Specifications:</b><BR>
<b>Name:</b> Vey-Med L-2 Encoded Audio Language Implant<BR>
<b>Life:</b> 5 years<BR>
<b>Important Notes:</b> Affects hearing and speech.<BR>
<HR>
<b>Implant Details:</b><BR>
<b>Function:</b> Allows an organic to accurately speak Encoded Audio Language.<BR>
<b>Special Features:</b> None.<BR>
<b>Integrity:</b> Implant will function for expected life, barring physical damage."}
	return dat

/obj/item/implant/language/skrellian
	name = "Skrellian language implant"
	desc = "An implant allowing someone to speak the range of frequencies used in Skrellian, as well as produce any phonemes that they usually cannot. Only helps with hearing and producing sounds, not understanding them."
	languages = list(LANGUAGE_SKRELLIAN)

/obj/item/implant/language/skrellian/get_data()
	var/dat = {"
<b>Implant Specifications:</b><BR>
<b>Name:</b> Vey-Med L-1 Galactic Common Implant<BR>
<b>Life:</b> 5 years<BR>
<b>Important Notes:</b> Affects hearing and speech.<BR>
<HR>
<b>Implant Details:</b><BR>
<b>Function:</b> Allows a being otherwise incapable of speaking Skrellian to produce the phonemes of the language.<BR>
<b>Special Features:</b> None.<BR>
<b>Integrity:</b> Implant will function for expected life, barring physical damage."}
	return dat
