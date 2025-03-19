/*
 * Library Public Computer
 * Outpost 21 edit - Complete recode of this into a search engine for recipes and reagents
 */
/obj/machinery/librarywikicomp
	name = "datacore computer"
	icon = 'icons/obj/library.dmi'
	icon_state = "computer"
	anchored = TRUE
	density = TRUE

	desc = "Used for research, I swear!"

	VAR_PRIVATE/doc_title = "Click a search entry!"
	VAR_PRIVATE/doc_body = ""
	VAR_PRIVATE/searchmode = null
	VAR_PRIVATE/appliance = null //sublists for food menu
	VAR_PRIVATE/crash = FALSE

	VAR_PRIVATE/current_ad1 = ""
	VAR_PRIVATE/current_ad2 = ""

/obj/machinery/librarywikicomp/Initialize(mapload)
	. = ..()
	current_ad1 = get_ad()
	current_ad2 = get_ad()

/obj/machinery/librarywikicomp/attack_hand(mob/user)
	if(..())
		return 1
	if(crash)
		user.visible_message("[user] performs percussive maintenance on \the [src].", "You try to smack some sense into \the [src].")
		if(prob(10))
			crash = FALSE
	if(!crash)
		tgui_interact(user)
		playsound(src, "keyboard", 40) // into console

/obj/machinery/librarywikicomp/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "PublicLibraryWiki", name)
		ui.open()

/obj/machinery/librarywikicomp/tgui_data(mob/user)
	var/data = list()
	if(SSinternal_wiki)
		if(!crash)
			// search page
			data["errorText"] = ""
			data["searchmode"] = searchmode
			data["ad_string1"] = current_ad1
			data["ad_string2"] = current_ad2
			data["appliance"] = appliance
			// get searches
			switch(searchmode)
				if("Food Recipes")
					if(appliance)
						data["search"] = SSinternal_wiki.get_searchcache_food(appliance)
					else
						var/list/options = list()
						for(var/app in SSinternal_wiki.get_appliances())
							if(!isnull(SSinternal_wiki.get_searchcache_food("[app]")))
								options.Add("[app]")
						data["search"] = options

				if("Drink Recipes")
					data["search"] = SSinternal_wiki.get_searchcache_drink()

				if("Chemistry")
					data["search"] = SSinternal_wiki.get_searchcache_chem()

				if("Botany")
					data["search"] = SSinternal_wiki.get_searchcache_seed()

				if("Catalogs")
					data["search"] = SSinternal_wiki.get_searchcache_catalog()

				if("Materials")
					data["search"] = SSinternal_wiki.get_searchcache_material()

				if("Particle Physics")
					data["search"] = SSinternal_wiki.get_searchcache_particle()

				if("Ores")
					data["search"] = SSinternal_wiki.get_searchcache_ore()

				else
					data["search"] = list()

			// display message
			data["title"] = doc_title
			data["body"] = doc_body
			data["print"] = (doc_body && length(doc_body) > 0)
		else
			// intentional TGUI crash, amazingly awful
			data["searchmode"] = "Error"
			data["search"] = -1
	else
		data["errorText"] = "Database unreachable."
	return data

/obj/machinery/librarywikicomp/tgui_act(action, params)
	if(..())
		return TRUE
	add_fingerprint(usr)
	playsound(src, "keyboard", 40) // into console

	current_ad1 = get_ad()
	current_ad2 = get_ad()

	switch(action)
		if("closesearch")
			if(!crash)
				searchmode = null
				appliance = null
				doc_title = "Click a search entry!"
				doc_body = ""
			. = TRUE

		if("foodsearch")
			if(!crash)
				searchmode = "Food Recipes"
			. = TRUE

		if("drinksearch")
			if(!crash)
				searchmode = "Drink Recipes"
			. = TRUE

		if("oresearch")
			if(!crash)
				searchmode = "Ores"
			. = TRUE

		if("matsearch")
			if(!crash)
				searchmode = "Materials"
			. = TRUE

		if("smashsearch")
			if(!crash)
				searchmode = "Particle Physics"
			. = TRUE

		if("chemsearch")
			if(!crash)
				searchmode = "Chemistry"
			. = TRUE

		if("botsearch")
			if(!crash)
				searchmode = "Botany"
			. = TRUE

		if("catalogsearch")
			if(!crash)
				searchmode = "Catalogs"
			. = TRUE

		if("crash")
			// intentional TGUI crash, amazingly awful
			if(issilicon(usr) && usr.client)
				usr.client.create_fake_ad_popup_multiple(/obj/screen/popup/default, rand(4,10))
			if(!crash)
				crash = TRUE
				spawn(rand(1000,4000))
					// crashes till it fixes itself
					crash = FALSE
			. = TRUE

		if("print")
			if(!crash && doc_title && doc_body)
				visible_message(span_notice("[src] rattles and prints out a sheet of paper."))
				// playsound(loc, 'sound/goonstation/machines/printer_dotmatrix.ogg', 50, 1)

				var/obj/item/paper/P = new /obj/item/paper(loc)
				P.name = doc_title
				P.info = doc_body
			. = TRUE

		// final search
		if("search")
			if(!crash)
				var/search = params["data"]
				var/datum/internal_wiki/page/P
				var/setpage = TRUE
				if(searchmode == "Food Recipes")
					if(!appliance)
						appliance = params["data"] // have not selected it yet
						setpage = FALSE
					else
						P = SSinternal_wiki.get_page_food(search)
				if(searchmode == "Drink Recipes")
					P = SSinternal_wiki.get_page_drink(search)
				if(searchmode == "Chemistry")
					P = SSinternal_wiki.get_page_chem(search)
				if(searchmode == "Botany")
					P = SSinternal_wiki.get_page_seed(search)
				if(searchmode == "Catalogs")
					P = SSinternal_wiki.get_page_catalog(search)
				if(searchmode == "Materials")
					P = SSinternal_wiki.get_page_material(search)
				if(searchmode == "Particle Physics")
					P = SSinternal_wiki.get_page_particle(search)
				if(searchmode == "Ores")
					P = SSinternal_wiki.get_page_ore(search)

				if(setpage)
					if(P)
						doc_title = P.title
						doc_body = P.get_data()
					else
						doc_title = "Error"
						doc_body = "Invalid data."
			. = TRUE

/obj/machinery/librarywikicomp/proc/get_ad()
	switch(rand(1,20))
		if(1)
			return "Inferior ears? Teshari enhancement surgeries might be for you!"
		if(2)
			return "Phoron huffers anonymous group chat. Join Today!"
		if(3)
			return "Hot and single Vox raiders near your system!"
		if(4)
			return "Need company? Holographic NIF friends! FREE DOWNLOAD!"
		if(5)
			return "LostSpagetti.sol your one stop SYNX DATING website!"
		if(6)
			return "HONK.bonk clown-only social media. Sign up TODAY!"
		if(7)
			return "FREE ORGANS! FREE ORGANS! FREE ORGANS! Terms apply."
		if(8)
			return "Smile.me.com.net.skrell.node.exe.js DOWNLOAD NOW!"
		if(9)
			return "Bankrupt? We can help! Buy uranium coins today!"
		if(10)
			return "CONGRATULATIONS, you're our [rand(1,10000)]TH visitor! DOWNLOAD!"
		if(11)
			return "Your system is out of date, DOWNLOAD DRIVERS!"
		if(12)
			return "Ms.Kitty can't hang in there long, click here to support FELINE INDEPENDENCE!"
		if(13)
			return "Cortical borer therapy! Treats anxiety, stress, and impending sense of univeral collapse!"
		if(14)
			return "Help I licked the supermatter! And other strange stories from Nanotrasen. FREE PDF!"
		if(15)
			return "TIME IS COMING TO AN END, BUY GOLD NOW!"
		if(16)
			return "Your own pet clown? It sounds too REAL to be TRUE! VIEW ARTICLE!"
		if(17)
			return "Are you a BIGSHOT? Investment opportunities inside!"
		if(18)
			return "Spacestation13.exe FREE DOWNLOAD NOW!"
		if(19)
			return "Bored and alone? Date a wizard today! WIZZBIZZ.KAZAM!"
		else
			return "Hot skrell babes in your area!"

// mapper varient for dorms and residences
/obj/machinery/librarywikicomp/personal
	name = "personal datacore computer"
	desc = "Have you Bingled THAT today?"
