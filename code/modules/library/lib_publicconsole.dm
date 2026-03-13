/*
 * Library Public Computer
 */
#define SCREEN_PUBLICONLINE "publiconline"
#define SCREEN_PUBLICARCHIVE "publicarchive"

/obj/machinery/librarypubliccomp
	name = "visitor computer"
	icon = 'icons/obj/library.dmi'
	icon_state = "computer"
	anchored = TRUE
	density = TRUE
	var/screenstate = SCREEN_PUBLICARCHIVE

/obj/machinery/librarypubliccomp/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "LibraryPublicComp", name)
		ui.open()

/obj/machinery/librarypubliccomp/tgui_data(mob/user)
	var/data[0]
	data["admin_mode"] = FALSE
	data["is_public"] = TRUE
	data["screenstate"] = screenstate
	return data

/obj/machinery/librarypubliccomp/tgui_static_data(mob/user)
	var/list/data = ..()
	var/list/inv = list()
	switch(screenstate)
		if(SCREEN_PUBLICARCHIVE) // external archive (SSpersistance database)
			if(CONFIG_GET(flag/sql_enabled))
				to_chat(world, "TODO DATABASE") //-=================================================================================================== TODO HERE
			else
				for(var/token_id in SSpersistence.all_books)
					var/list/token = SSpersistence.all_books[token_id]
					if(token)
						inv += list(tgui_add_library_token(token))

		if(SCREEN_PUBLICONLINE) // internal archive (hardcoded books)
			for(var/BP in GLOB.all_books)
				var/obj/item/book/B = GLOB.all_books[BP]
				inv += list(tgui_add_library_book(B))

	data["inventory"] = inv
	return data

/obj/machinery/librarypubliccomp/tgui_act(action, list/params, datum/tgui/ui)
	if(..())
		return TRUE
	switch(action)
		if("switchscreen")
			playsound(src, "keyboard", 40)
			screenstate = params["switchscreen"]
			if(screenstate == SCREEN_PUBLICARCHIVE || screenstate == SCREEN_PUBLICONLINE)
				update_tgui_static_data(ui.user)
			. = TRUE

		if("inv_page")
			playsound(src, "keyboard", 40)
	if(.)
		SStgui.update_uis(src)

/obj/machinery/librarypubliccomp/attack_hand(mob/user as mob)
	add_fingerprint(user)
	tgui_interact(user)

#undef SCREEN_PUBLICONLINE
#undef SCREEN_PUBLICARCHIVE
