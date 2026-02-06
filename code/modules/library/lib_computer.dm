/*
 * Library Computer
 */
#define SCREEN_HOME "home"
#define SCREEN_INVENTORY "inventory"
#define SCREEN_CHECKING "checking"
#define SCREEN_CHECKOUT "checkedout"
#define SCREEN_ONLINE "online"
#define SCREEN_ARCHIVE "archive"
#define SCREEN_ARCANE "arcane"

// TODO: Make this an actual /obj/machinery/computer that can be crafted from circuit boards and such
// It is August 22nd, 2012... This TODO has already been here for months.. I wonder how long it'll last before someone does something about it. // Nov 2019. Nope.
/obj/machinery/librarycomp
	name = "Check-In/Out Computer"
	desc = "Print books from the archives! (You aren't quite sure how they're printed by it, though.)"
	icon = 'icons/obj/library.dmi'
	icon_state = "computer"
	anchored = TRUE
	density = TRUE
	var/screenstate = SCREEN_HOME
	var/sortby = "author"
	var/buffer_book
	var/buffer_mob
	var/list/checkouts = list()
	var/list/inventory = list()
	var/checkoutperiod = 5 // In minutes
	var/obj/machinery/libraryscanner/scanner // Book scanner that will be used when uploading books to the Archive

	var/bibledelay = 0 // LOL NO SPAM (1 minute delay) -- Doohl

/obj/machinery/librarycomp/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "LibraryPublicComp", name)
		ui.open()

/obj/machinery/librarycomp/tgui_data(mob/user)
	var/data[0]
	data["admin_mode"] = check_rights_for(user.client, (R_ADMIN|R_MOD))
	data["is_public"] = FALSE
	data["screenstate"] = screenstate
	data["emagged"] = emagged
	// Book storage
	var/list/inv = list()
	var/list/checks = list()
	switch(screenstate)
		if(SCREEN_CHECKOUT) // books checked out of the library
			for(var/datum/borrowbook/BB in checkouts)
				// for returns
				var/list/book = list()
				book["bookname"] = BB.bookname
				book["mobname"] = BB.mobname
				var/timetaken = world.time - BB.getdate
				timetaken /= 600
				timetaken = round(timetaken)
				var/timedue = BB.duedate - world.time
				timedue /= 600
				book["timetaken"] = round(timetaken)
				book["timedue"] = round(timedue)
				book["overdue"] = round(timedue) <= 0
				book["ref"] = REF(BB)
				checks += list(book)
	data["checks"] = checks
	// Book scanner
	data["scanned"] = null
	data["scanner_error"] = ""
	if(!scanner)
		for(var/obj/machinery/libraryscanner/S in range(9))
			scanner = S
			break
	if(!scanner)
		data["scanner_error"] = "No scanner found within wireless network range."
	else if(!scanner.cache)
		data["scanner_error"] = "No data found in scanner memory."
	else
		data["scanned"] = tgui_add_library_book(scanner.cache)
	// Checkout entrys
	data["checkoutperiod"] = checkoutperiod
	data["world_time"] = world.time
	data["buffer_book"] = buffer_book
	data["buffer_mob"] = buffer_mob
	return data

/obj/machinery/librarycomp/tgui_static_data(mob/user)
	var/list/data = ..()
	var/list/inv = list()
	switch(screenstate)
		if(SCREEN_INVENTORY) // barcode scanned books for checkout
			for(var/obj/item/book/B in inventory)
				inv += list(tgui_add_library_book(B))

		if(SCREEN_ONLINE) // internal archive (hardcoded books)
			for(var/BP in GLOB.all_books)
				var/obj/item/book/B = GLOB.all_books[BP]
				inv += list(tgui_add_library_book(B))

		if(SCREEN_ARCHIVE) // external archive (SSpersistance database)
			if(CONFIG_GET(flag/sql_enabled))
				to_chat(world, "TODO DATABASE") //-=================================================================================================== TODO HERE
			else
				for(var/token_id in SSpersistence.all_books)
					var/list/token = SSpersistence.all_books[token_id]
					if(token)
						inv += list(tgui_add_library_token(token))

	data["inventory"] = inv
	return data

/obj/machinery/librarycomp/tgui_act(action, list/params, datum/tgui/ui)
	if(..())
		return TRUE
	switch(action)
		if("switchscreen")
			playsound(src, "keyboard", 40)
			if(params["switchscreen"] != "bible")
				screenstate = params["switchscreen"]
				if(screenstate == SCREEN_INVENTORY || screenstate == SCREEN_ONLINE || screenstate == SCREEN_ARCHIVE)
					update_tgui_static_data(ui.user)
			else
				// don't change screens if printing a bible
				if(!bibledelay)
					new /obj/item/storage/bible(get_turf(src))
					bibledelay = 1
					spawn(60)
						bibledelay = 0
				else
					visible_message(span_infoplain(span_bold("[src]") + "'s monitor flashes, \"Bible printer currently unavailable, please wait a moment.\""))
			// Prevent access to forbidden lore vault if emag is fixed somehow
			if(params["switchscreen"] == SCREEN_ARCANE)
				if(!emagged)
					screenstate = SCREEN_INVENTORY
					update_tgui_static_data(ui.user)
			. = TRUE

		if("increasetime")
			playsound(src, "keyboard", 40)
			checkoutperiod += 1
			. = TRUE

		if("decreasetime")
			playsound(src, "keyboard", 40)
			checkoutperiod -= 1
			if(checkoutperiod < 5)
				checkoutperiod = 5
			. = TRUE

		if("editbook")
			playsound(src, "keyboard", 40)
			buffer_book = tgui_input_text(ui.user, "Enter the book's title:")
			. = TRUE

		if("editmob")
			playsound(src, "keyboard", 40)
			buffer_mob = tgui_input_text(ui.user, "Enter the recipient's name:", null, null, MAX_NAME_LEN)
			. = TRUE

		if("checkout")
			playsound(src, "keyboard", 40)
			var/datum/borrowbook/b = new /datum/borrowbook
			b.bookname = sanitizeSafe(buffer_book)
			b.mobname = sanitize(buffer_mob)
			b.getdate = world.time
			b.duedate = world.time + (checkoutperiod * 600)
			checkouts.Add(b)
			screenstate = SCREEN_CHECKOUT
			. = TRUE

		if("checkin")
			playsound(src, "keyboard", 40)
			var/datum/borrowbook/b = locate(params["checkin"]) in checkouts
			checkouts.Remove(b)
			. = TRUE

		if("delbook")
			playsound(src, "keyboard", 40)
			var/obj/item/book/b = locate(params["delbook"]) in inventory
			inventory.Remove(b)
			. = TRUE

		if("quickcheck")
			playsound(src, "keyboard", 40)
			var/obj/item/book/b = locate(params["delbook"]) in inventory
			buffer_book = sanitize(b.title)
			screenstate = SCREEN_CHECKING
			. = TRUE

		if("inv_page")
			playsound(src, "keyboard", 40)

		if("setauthor")
			playsound(src, "keyboard", 40)
			var/newauthor = tgui_input_text(ui.user, "Enter the author's name: ")
			if(newauthor)
				scanner.cache.author = newauthor
			. = TRUE

		if("setcategory")
			playsound(src, "keyboard", 40)
			var/newcategory = tgui_input_list(ui.user, "Choose a category: ", "Category", list("Fiction", "Non-Fiction", "Adult", "Reference", "Religion"))
			if(newcategory)
				scanner.cache.libcategory = newcategory
			. = TRUE

		if("upload")
			if(scanner)
				if(scanner.cache)
					if(!scanner.cache.unique)
						playsound(src, "keyboard", 40)
						if(CONFIG_GET(flag/sql_enabled))
							to_chat(world, "TODO DATABASE") //-=================================================================================================== TODO HERE
						else
							var/datum/persistent/library_books/SSBooks = SSpersistence.persistence_datums[/datum/persistent/library_books]
							var/status = SSBooks.add_new_book(scanner.cache,ui.user.client)
							switch(status)
								if(LIBRARY_UPLOAD_STATUS_ISPROTECTED)
									tgui_alert_async(ui.user, "Uploaded book \"[scanner.cache.name]\" by \"[scanner.cache.author]\" already exists, and is protected .")
								if(LIBRARY_UPLOAD_STATUS_SUCCESSFUL)
									tgui_alert_async(ui.user, "\"[scanner.cache.name]\" by \"[scanner.cache.author]\", Upload Complete!")
								if(LIBRARY_UPLOAD_STATUS_REPLACED)
									tgui_alert_async(ui.user, "Replaced book \"[scanner.cache.name]\" by \"[scanner.cache.author]\".")
								if(LIBRARY_UPLOAD_STATUS_FAILPARSE)
									tgui_alert_async(ui.user, "Upload failed to parse \"[scanner.cache.name]\" by \"[scanner.cache.author]\".")
								if(LIBRARY_UPLOAD_STATUS_TIMEOUT)
									tgui_alert_async(ui.user, "Please wait, still processing.")
			. = TRUE

		if("hardprint")
			playsound(src, "sound/machines/printer.ogg", 50, 1)
			var/newpath = params["hardprint"]
			var/obj/item/book/NewBook = new newpath(get_turf(src))
			NewBook.name = "Book: [NewBook.name]"
			NewBook.unique = TRUE
			. = TRUE

		if("import_external")
			playsound(src, "sound/machines/printer.ogg", 50, 1)
			var/get_id = params["import_external"]
			if(CONFIG_GET(flag/sql_enabled))
				to_chat(world, "TODO DATABASE") //-=================================================================================================== TODO HERE
			else
				var/datum/persistent/library_books/SSBooks = SSpersistence.persistence_datums[/datum/persistent/library_books]
				if(isnull(SSBooks.get_stored_book(get_id,get_turf(src))))
					tgui_alert_async(ui.user, "This book's data is invalid, please try another from the catalogue.")
			. = TRUE

		if("delete_external")
			playsound(src, "keyboard", 40)
			if(CONFIG_GET(flag/sql_enabled))
				to_chat(world, "TODO DATABASE") //-=================================================================================================== TODO HERE
			else
				var/get_id = params["delete_external"]
				var/datum/persistent/library_books/SSBooks = SSpersistence.persistence_datums[/datum/persistent/library_books]
				SSBooks.delete_stored_book(get_id)
			. = TRUE

		if("restore_external")
			playsound(src, "keyboard", 40)
			if(CONFIG_GET(flag/sql_enabled))
				to_chat(world, "TODO DATABASE") //-=================================================================================================== TODO HERE
			else
				var/get_id = params["restore_external"]
				var/datum/persistent/library_books/SSBooks = SSpersistence.persistence_datums[/datum/persistent/library_books]
				SSBooks.restore_stored_book(get_id)
			. = TRUE

		if("protect_external")
			if(check_rights_for(ui.user.client, (R_ADMIN|R_MOD)))
				playsound(src, "keyboard", 40)
				if(CONFIG_GET(flag/sql_enabled))
					to_chat(world, "TODO DATABASE") //-=================================================================================================== TODO HERE
				else
					var/get_id = params["protect_external"]
					var/datum/persistent/library_books/SSBooks = SSpersistence.persistence_datums[/datum/persistent/library_books]
					SSBooks.protect_stored_book(get_id)
			. = TRUE

		if("arcane_checkout")
			playsound(src, "keyboard", 40)
			new /obj/item/book/tome(get_turf(src))
			to_chat(ui.user, span_warning("Your sanity barely endures the seconds spent in the vault's browsing window. The only thing to remind you of this when you stop browsing is a dusty old tome sitting on the desk. You don't really remember printing it."))
			ui.user.visible_message(span_infoplain(span_bold("\The [ui.user]") + " stares at the blank screen for a few moments, [ui.user.p_their()] expression frozen in fear. When [ui.user.p_they()] finally awaken from it, [ui.user.p_they()] look a lot older."), 2)
			screenstate = SCREEN_HOME
			emagged = FALSE // used up
			. = TRUE
	if(.)
		SStgui.update_uis(src)

/obj/machinery/librarycomp/attack_hand(mob/user)
	add_fingerprint(user)
	tgui_interact(user)

/obj/machinery/librarycomp/emag_act(remaining_charges, mob/user)
	if (density && !emagged)
		emagged = 1
		return 1

/obj/machinery/librarycomp/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/barcodescanner))
		var/obj/item/barcodescanner/scanner = W
		scanner.computer = src
		to_chat(user, "[scanner]'s associated machine has been set to [src].")
		for (var/mob/V in hearers(src))
			V.show_message("[src] lets out a low, short blip.", 2)
	else
		..()

#undef SCREEN_HOME
#undef SCREEN_INVENTORY
#undef SCREEN_CHECKING
#undef SCREEN_CHECKOUT
#undef SCREEN_ONLINE
#undef SCREEN_ARCHIVE
#undef SCREEN_ARCANE
