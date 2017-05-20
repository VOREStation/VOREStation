/obj/item/weapon/implant/vrlanguage
	name = "language"
	desc = "Allows the user to understand and speak almost all known languages.."
	var/uses = 1

	get_data()
		var/dat = {"
<b>Implant Specifications:</b><BR>
<b>Name:</b> Language Implant<BR>
<b>Life:</b> One day.<BR>
<b>Important Notes:</b> Personnel with this implant can speak almost all known languages.<BR>
<HR>
<b>Implant Details:</b> Subjects injected with implant can understand and speak almost all known languages.<BR>
<b>Function:</b> Contains specialized nanobots to stimulate the brain so the user can speak and understand previously unknown languages.<BR>
<b>Special Features:</b> Will allow the user to understand almost all languages.<BR>
<b>Integrity:</b> Implant can only be used once before the nanobots are depleted."}
		return dat


	trigger(emote, mob/source as mob)
		if (src.uses < 1)	return 0
		if (emote == "smile")
			src.uses--
			source << "<span class='notice'>You suddenly feel as if you can understand other languages!</span>"
			source.add_language(LANGUAGE_CHIMPANZEE)
			source.add_language(LANGUAGE_NEAERA)
			source.add_language(LANGUAGE_STOK)
			source.add_language(LANGUAGE_FARWA)
			source.add_language(LANGUAGE_UNATHI)
			source.add_language(LANGUAGE_SIIK)
			source.add_language(LANGUAGE_SKRELLIAN)
			source.add_language(LANGUAGE_SCHECHI)
			source.add_language(LANGUAGE_BIRDSONG)
			source.add_language(LANGUAGE_SAGARU)
			source.add_language(LANGUAGE_CANILUNZT)
			source.add_language(LANGUAGE_SOL_COMMON) //In case they're giving a xenomorph an implant or something.


		return


	implanted(mob/source)
		source.mind.store_memory("A implant can be activated by using the smile emote, <B>say *smile</B> to attempt to activate.", 0, 0)
		source << "The implanted language implant can be activated by using the smile emote, <B>say *smile</B> to attempt to activate."
		return 1
