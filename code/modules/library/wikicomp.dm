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
	VAR_PRIVATE/sub_category = null //sublists for food menu
	VAR_PRIVATE/crash = FALSE
	VAR_PRIVATE/datum/internal_wiki/page/P

/obj/machinery/librarywikicomp/Initialize(mapload)
	. = ..()

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


/obj/machinery/librarywikicomp/tgui_close(mob/user)
	. = ..()
	P = null
	sub_category= null
	searchmode = null

/obj/machinery/librarywikicomp/tgui_data(mob/user)
	var/data = list()
	if(SSinternal_wiki)
		data["crash"] = crash
		data["material_data"] = null
		data["particle_data"] = null
		data["catalog_data"] = null
		data["sub_categories"] = null
		if(!crash)
			// search page
			data["errorText"] = ""
			data["searchmode"] = searchmode
			// get searches
			switch(searchmode)
				if("Food Recipes")
					data["sub_categories"] = SSinternal_wiki.get_appliances()
					data["search"] = list()
					if(sub_category)
						data["search"] = SSinternal_wiki.get_searchcache_food(sub_category)

				if("Drink Recipes")
					data["search"] = SSinternal_wiki.get_searchcache_drink()

				if("Chemistry")
					data["search"] = SSinternal_wiki.get_searchcache_chem()

				if("Botany")
					data["search"] = SSinternal_wiki.get_searchcache_seed()

				if("Catalogs")
					data["sub_categories"] = SSinternal_wiki.get_catalogs()
					data["search"] = list()
					if(sub_category)
						data["search"] = SSinternal_wiki.get_searchcache_catalog(sub_category)
						if(P)
							data["catalog_data"] = P.get_data()

				if("Materials")
					data["search"] = SSinternal_wiki.get_searchcache_material()
					if(P)
						data["material_data"] = P.get_data()

				if("Particle Physics")
					data["search"] = SSinternal_wiki.get_searchcache_particle()
					if(P)
						data["particle_data"] = P.get_data()

				if("Ores")
					data["search"] = SSinternal_wiki.get_searchcache_ore()

				else
					data["search"] = list()

			// display message
			data["print"] = (doc_body && length(doc_body) > 0)
		else
			// intentional TGUI crash, amazingly awful
			data["searchmode"] = "Error"
			data["search"] = null
	else
		data["errorText"] = "Database unreachable."
	return data

/obj/machinery/librarywikicomp/tgui_act(action, params, datum/tgui/ui)
	if(..())
		return TRUE
	add_fingerprint(usr)
	playsound(src, "keyboard", 40) // into console

	switch(action)
		if("closesearch")
			if(!crash)
				P = null
				searchmode = null
				sub_category = null
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
			if(issilicon(ui.user) && ui.user.client)
				ui.user.client.create_fake_ad_popup_multiple(/obj/screen/popup/default, rand(4,10))
			if(!crash)
				crash = TRUE
				// crashes till it fixes itself
				VARSET_IN(src, crash, FALSE, rand(1000, 4000))
			. = TRUE

		if("print")
			if(!crash && doc_title && doc_body)
				visible_message(span_notice("[src] rattles and prints out a sheet of paper."))
				// playsound(loc, 'sound/goonstation/machines/printer_dotmatrix.ogg', 50, 1)

				var/obj/item/paper/paper = new /obj/item/paper(loc)
				paper.name = doc_title
				paper.info = doc_body
			. = TRUE

		if("setsubcat")
			if(!crash)
				sub_category = params["data"] // have not selected it yet
			. = TRUE
		// final search
		if("search")
			if(!crash)
				var/search = params["data"]
				var/setpage = TRUE
				P = null
				if(searchmode == "Food Recipes")
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
						doc_body = P.get_print() // TODO - pass get_data() instead, as only printing should use get_print()
					else
						doc_title = "Error"
						doc_body = "Invalid data."
			. = TRUE


// mapper varient for dorms and residences
/obj/machinery/librarywikicomp/personal
	name = "personal datacore computer"
	desc = "Have you Bingled THAT today?"
