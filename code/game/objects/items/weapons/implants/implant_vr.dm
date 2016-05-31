/obj/item/weapon/implant/language
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
			source.add_language("Chimpanzee")
			source.add_language("Neaera")
			source.add_language("Stok")
			source.add_language("Farwa")
			source.add_language("Sinta'unathi")
			source.add_language("Siik'tajr")
			source.add_language("Skrellian")
			source.add_language("Schechi")
			source.add_language("Sinta'unathi")
			source.add_language("Birdsong")
			source.add_language("Sagaru")
			source.add_language("Canilunzt")
			source.add_language("Sol Common") //In case they're giving a xenomorph an implant or something.


		return


	implanted(mob/source)
		source.mind.store_memory("A implant can be activated by using the smile emote, <B>say *smile</B> to attempt to activate.", 0, 0)
		source << "The implanted language implant can be activated by using the smile emote, <B>say *smile</B> to attempt to activate."
		return 1
