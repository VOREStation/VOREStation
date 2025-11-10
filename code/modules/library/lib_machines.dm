/* Library Machines
 *
 * Contains:
 *		Borrowbook datum
 *		Library Public Computer
 *		Library Computer
 *		Library Scanner
 *		Book Binder
 */

#define INVPAGESIZE 6
#define INVPAGESIZEPUBLIC 7
var/global/list/all_books // moved to global list so it can be shared by public comps

// Moved to a hook instead of in initilize. The whole pre-packaged book inventory is fully static and isn't meant to be changed anyway
/hook/roundstart/proc/assemble_library_inventory()
	global.all_books = list()
	var/list/base_genre_books = list(
		/obj/item/book/custom_library/fiction,
		/obj/item/book/custom_library/nonfiction,
		/obj/item/book/custom_library/reference,
		/obj/item/book/custom_library/religious,
		/obj/item/book/bundle/custom_library/fiction,
		/obj/item/book/bundle/custom_library/nonfiction,
		/obj/item/book/bundle/custom_library/reference,
		/obj/item/book/bundle/custom_library/religious
		)

	for(var/path in subtypesof(/obj/item/book/codex/lore))
		var/obj/item/book/C = new path(null)
		global.all_books[C.name] = C

	for(var/path in subtypesof(/obj/item/book/custom_library) - base_genre_books)
		var/obj/item/book/B = new path(null)
		global.all_books[B.title] = B

	for(var/path in subtypesof(/obj/item/book/bundle/custom_library) - base_genre_books)
		var/obj/item/book/M = new path(null)
		global.all_books[M.title] = M

	return TRUE

/*
 * Borrowbook datum
 */
/datum/borrowbook // Datum used to keep track of who has borrowed what when and for how long.
	var/bookname
	var/mobname
	var/getdate
	var/duedate

/*
 * Library Public Computer
 */
/obj/machinery/librarypubliccomp
	name = "visitor computer"
	icon = 'icons/obj/library.dmi'
	icon_state = "computer"
	anchored = TRUE
	density = TRUE
	var/inventory_page = 0
	var/screenstate = "publicarchive"

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
	var/list/inv = list()
	var/start_entry = 1 + (inventory_page * INVPAGESIZEPUBLIC) // 6 per page in inventory
	var/entry_count = 0
	var/inv_left = (inventory_page > 0)
	var/inv_right = TRUE
	switch(screenstate)
		if("publicarchive") // external archive (SSpersistance database)
			if(inventory_page + 1 >= SSpersistence.all_books.len / INVPAGESIZEPUBLIC)
				inv_right = FALSE
			for(var/token_id in SSpersistence.all_books)
				entry_count++
				if(entry_count < start_entry)
					continue
				if(entry_count >= start_entry + INVPAGESIZEPUBLIC)
					break
				var/list/token = SSpersistence.all_books[token_id]
				if(token)
					inv += list(tgui_add_library_token(token))
		if("publiconline") // internal archive (hardcoded books)
			if(inventory_page + 1 >= global.all_books.len / INVPAGESIZEPUBLIC)
				inv_right = FALSE
			for(var/BP in global.all_books)
				entry_count++
				if(entry_count < start_entry)
					continue
				if(entry_count >= start_entry + INVPAGESIZEPUBLIC)
					break
				var/obj/item/book/B = global.all_books[BP]
				if(B)
					inv += list(tgui_add_library_book(B))
	data["inventory"] = inv
	data["inv_left"] = inv_left
	data["inv_right"] = inv_right
	return data

/obj/machinery/librarypubliccomp/tgui_act(action, params)
	if(..())
		return TRUE
	switch(action)
		if("switchscreen")
			playsound(src, "keyboard", 40)
			inventory_page = 0 // reset inv menus
			screenstate = params["switchscreen"]
			. = TRUE

		if("inv_prev")
			playsound(src, "keyboard", 40)
			inventory_page--
			if(inventory_page < 0)
				inventory_page = 0

		if("inv_nex")
			playsound(src, "keyboard", 40)
			inventory_page++
			var/siz = 0
			switch(screenstate)
				if("publicarchive") // external archive (SSpersistance database)
					siz = SSpersistence.all_books.len / INVPAGESIZEPUBLIC
				if("publiconline") // internal archive (hardcoded books)
					siz = global.all_books.len / INVPAGESIZEPUBLIC
			if(inventory_page + 1 >= siz)
				inventory_page-- // go back
	if(.)
		SStgui.update_uis(src)

/obj/machinery/librarypubliccomp/attack_hand(var/mob/user as mob)
	usr.set_machine(src)
	add_fingerprint(usr)
	tgui_interact(user)

/*
 * Library Computer
 */
// TODO: Make this an actual /obj/machinery/computer that can be crafted from circuit boards and such
// It is August 22nd, 2012... This TODO has already been here for months.. I wonder how long it'll last before someone does something about it. // Nov 2019. Nope.
/obj/machinery/librarycomp
	name = "Check-In/Out Computer"
	desc = "Print books from the archives! (You aren't quite sure how they're printed by it, though.)"
	icon = 'icons/obj/library.dmi'
	icon_state = "computer"
	anchored = TRUE
	density = TRUE
	var/screenstate = 0
	var/inventory_page = 0
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
	var/start_entry = 1 + (inventory_page * INVPAGESIZE) // 6 per page in inventory
	var/entry_count = 0
	var/inv_left = (inventory_page > 0)
	var/inv_right = TRUE
	switch(screenstate)
		if("inventory") // barcode scanned books for checkout
			if(inventory_page + 1 >= inventory.len / INVPAGESIZE)
				inv_right = FALSE
			for(var/obj/item/book/B in inventory)
				entry_count++
				if(entry_count < start_entry)
					continue
				if(entry_count >= start_entry + INVPAGESIZE)
					break
				if(B)
					inv += list(tgui_add_library_book(B))
		if("online") // internal archive (hardcoded books)
			if(inventory_page + 1 >= global.all_books.len / INVPAGESIZE)
				inv_right = FALSE
			for(var/BP in global.all_books)
				entry_count++
				if(entry_count < start_entry)
					continue
				if(entry_count >= start_entry + INVPAGESIZE)
					break
				var/obj/item/book/B = global.all_books[BP]
				if(B)
					inv += list(tgui_add_library_book(B))
		if("archive") // external archive (SSpersistance database)
			if(inventory_page + 1 >= SSpersistence.all_books.len / INVPAGESIZE)
				inv_right = FALSE
			for(var/token_id in SSpersistence.all_books)
				entry_count++
				if(entry_count < start_entry)
					continue
				if(entry_count >= start_entry + INVPAGESIZE)
					break
				var/list/token = SSpersistence.all_books[token_id]
				if(token)
					inv += list(tgui_add_library_token(token))
		if("checkedout") // books checked out of the library
			if(inventory_page + 1 >= checkouts.len / INVPAGESIZE)
				inv_right = FALSE
			for(var/datum/borrowbook/BB in checkouts)
				entry_count++
				if(entry_count < start_entry)
					continue
				if(entry_count >= start_entry + INVPAGESIZE)
					break
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
	data["inventory"] = inv
	data["checks"] = checks
	data["inv_left"] = inv_left
	data["inv_right"] = inv_right
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

// shared with public pc
/proc/tgui_add_library_book(var/obj/item/book/B)
	var/list/book = list()
	book["id"] = B.type
	book["title"] = B.name
	if(B.author)
		book["author"] = B.author
	else
		book["author"] = "Anonymous"
	book["category"] = B.libcategory
	book["deleted"] = FALSE
	book["protected"] = TRUE
	book["unique"] = B.unique
	book["ref"] = "[REF(B)]"
	book["type"] = "[B.type]"
	return book

/proc/tgui_add_library_token(var/list/token)
	var/list/book = list()
	book["id"] = token["uid"]
	book["title"] = token["title"]
	if(token["author"])
		book["author"] = token["author"]
	else
		book["author"] = "Anonymous"
	book["category"] = token["libcategory"]
	book["deleted"] = token["deleted"]
	book["protected"] = token["protected"] // ADMIN deletion prevention
	book["unique"] = FALSE
	book["ref"] = token["uid"]
	book["type"] = "[/obj/item/book]"
	return book

/obj/machinery/librarycomp/tgui_act(action, params)
	if(..())
		return TRUE
	switch(action)
		if("switchscreen")
			playsound(src, "keyboard", 40)
			if(params["switchscreen"] != "bible")
				inventory_page = 0 // reset inv menus
				screenstate = params["switchscreen"]
			else
				// don't change screens if printing a bible
				if(!bibledelay)
					new /obj/item/storage/bible(src.loc)
					bibledelay = 1
					spawn(60)
						bibledelay = 0
				else
					visible_message(span_infoplain(span_bold("[src]") + "'s monitor flashes, \"Bible printer currently unavailable, please wait a moment.\""))
			// Prevent access to forbidden lore vault if emag is fixed somehow
			if(params["switchscreen"] == "arcane")
				if(!src.emagged)
					screenstate = "inventory"
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
			buffer_book = tgui_input_text(usr, "Enter the book's title:")
			. = TRUE

		if("editmob")
			playsound(src, "keyboard", 40)
			buffer_mob = tgui_input_text(usr, "Enter the recipient's name:", null, null, MAX_NAME_LEN)
			. = TRUE

		if("checkout")
			playsound(src, "keyboard", 40)
			var/datum/borrowbook/b = new /datum/borrowbook
			b.bookname = sanitizeSafe(buffer_book)
			b.mobname = sanitize(buffer_mob)
			b.getdate = world.time
			b.duedate = world.time + (checkoutperiod * 600)
			checkouts.Add(b)
			screenstate = "checkedout" // more clear what happened
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
			screenstate = "checking"
			. = TRUE

		if("inv_prev")
			playsound(src, "keyboard", 40)
			inventory_page--
			if(inventory_page < 0)
				inventory_page = 0

		if("inv_nex")
			playsound(src, "keyboard", 40)
			inventory_page++
			var/siz = 0
			switch(screenstate)
				if("inventory") // barcode scanned books for checkout
					siz = inventory.len / INVPAGESIZE
				if("online") // internal archive (hardcoded books)
					siz = global.all_books.len / INVPAGESIZE
				if("archive") // external archive (SSpersistance database)
					siz = SSpersistence.all_books.len / INVPAGESIZE
				if("checkedout") // books checked out of the library
					siz = checkouts.len / INVPAGESIZE
			if(inventory_page + 1 >= siz)
				inventory_page-- // go back

		if("setauthor")
			playsound(src, "keyboard", 40)
			var/newauthor = tgui_input_text(usr, "Enter the author's name: ")
			if(newauthor)
				scanner.cache.author = newauthor
			. = TRUE

		if("setcategory")
			playsound(src, "keyboard", 40)
			var/newcategory = tgui_input_list(usr, "Choose a category: ", "Category", list("Fiction", "Non-Fiction", "Adult", "Reference", "Religion"))
			if(newcategory)
				scanner.cache.libcategory = newcategory
			. = TRUE

		if("upload")
			if(scanner)
				if(scanner.cache)
					if(!scanner.cache.unique)
						playsound(src, "keyboard", 40)
						spawn(0)
							var/datum/persistent/library_books/SSBooks = SSpersistence.persistence_datums[/datum/persistent/library_books]
							var/status = SSBooks.add_new_book(scanner.cache,usr.client)
							switch(status)
								if(0)
									tgui_alert_async(usr, "Uploaded book \"[scanner.cache.name]\" by \"[scanner.cache.author]\" already exists, and is protected .")
								if(1)
									tgui_alert_async(usr, "\"[scanner.cache.name]\" by \"[scanner.cache.author]\", Upload Complete!")
								if(2)
									tgui_alert_async(usr, "Replaced book \"[scanner.cache.name]\" by \"[scanner.cache.author]\".")
								if(3)
									tgui_alert_async(usr, "Upload failed to parse \"[scanner.cache.name]\" by \"[scanner.cache.author]\".")
								if(4)
									tgui_alert_async(usr, "Please wait, still processing.")
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
			var/datum/persistent/library_books/SSBooks = SSpersistence.persistence_datums[/datum/persistent/library_books]
			if(isnull(SSBooks.get_stored_book(get_id,get_turf(src))))
				tgui_alert_async(usr, "This book's data is invalid, please try another from the catalogue.")
			. = TRUE

		if("delete_external")
			playsound(src, "keyboard", 40)
			var/get_id = params["delete_external"]
			var/datum/persistent/library_books/SSBooks = SSpersistence.persistence_datums[/datum/persistent/library_books]
			SSBooks.delete_stored_book(get_id)
			. = TRUE

		if("restore_external")
			playsound(src, "keyboard", 40)
			var/get_id = params["restore_external"]
			var/datum/persistent/library_books/SSBooks = SSpersistence.persistence_datums[/datum/persistent/library_books]
			SSBooks.restore_stored_book(get_id)
			. = TRUE

		if("protect_external")
			if(check_rights_for(usr.client, (R_ADMIN|R_MOD)))
				playsound(src, "keyboard", 40)
				var/get_id = params["protect_external"]
				var/datum/persistent/library_books/SSBooks = SSpersistence.persistence_datums[/datum/persistent/library_books]
				SSBooks.protect_stored_book(get_id)
			. = TRUE

		if("arcane_checkout")
			playsound(src, "keyboard", 40)
			new /obj/item/book/tome(src.loc)
			SShaunting.intense_world_haunt() // Outpost 21 edit - IT DA SPOOKY STATION!
			to_chat(usr, span_warning("Your sanity barely endures the seconds spent in the vault's browsing window. The only thing to remind you of this when you stop browsing is a dusty old tome sitting on the desk. You don't really remember printing it."))
			usr.visible_message(span_infoplain(span_bold("\The [usr]") + " stares at the blank screen for a few moments, [usr.p_their()] expression frozen in fear. When [usr.p_they()] finally awaken from it, [usr.p_they()] look a lot older."), 2)
			screenstate = "home"
			emagged = FALSE // used up
			. = TRUE
	if(.)
		SStgui.update_uis(src)

/obj/machinery/librarycomp/attack_hand(var/mob/user as mob)
	usr.set_machine(src)
	add_fingerprint(usr)
	tgui_interact(user)

/obj/machinery/librarycomp/emag_act(var/remaining_charges, var/mob/user)
	if (src.density && !src.emagged)
		src.emagged = 1
		return 1

/obj/machinery/librarycomp/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W, /obj/item/barcodescanner))
		var/obj/item/barcodescanner/scanner = W
		scanner.computer = src
		to_chat(user, "[scanner]'s associated machine has been set to [src].")
		for (var/mob/V in hearers(src))
			V.show_message("[src] lets out a low, short blip.", 2)
	else
		..()

/*
 * Library Scanner
 */
/obj/machinery/libraryscanner
	name = "scanner"
	desc = "A scanner for scanning in books and papers."
	icon = 'icons/obj/library.dmi'
	icon_state = "bigscanner"
	anchored = TRUE
	density = TRUE
	var/obj/item/book/cache		// Last scanned book

/obj/machinery/libraryscanner/attackby(var/obj/O as obj, var/mob/user as mob)
	if(cache) // Prevent stacking books in here, unlike the original code.
		to_chat(user,span_warning("\The [src] already has a book inside it!"))
		return
	if(istype(O, /obj/item/book))
		user.drop_item()
		O.loc = src
		cache = O
		visible_message(span_notice("\The [O] was inserted into \the [src]."))

/obj/machinery/libraryscanner/attack_hand(var/mob/user as mob)
	if(cache) // Prevent stacking books in here
		cache = null
		for(var/obj/item/book/B in contents) // The old code allowed stacking, if multiple things end up in here somehow we may as well drop them all out too.
			B.loc = src.loc
		visible_message(span_notice("\The [src] ejects a book."))
		return
	to_chat(user,span_warning("There is nothing to eject from \the [src]!"))


/*
 * Book binder
 */
/obj/machinery/bookbinder
	name = "Book Binder"
	desc = "Bundles up a stack of inserted paper into a convenient book format."
	icon = 'icons/obj/library.dmi'
	icon_state = "binder"
	anchored = TRUE
	density = TRUE

/obj/machinery/bookbinder/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/climbable)

/obj/machinery/bookbinder/attackby(var/obj/O as obj, var/mob/user as mob)
	if(istype(O, /obj/item/paper) || istype(O, /obj/item/paper_bundle))
		if(istype(O, /obj/item/paper))
			user.drop_item()
			O.loc = src
			user.visible_message("[user] loads some paper into [src].", "You load some paper into [src].")
			src.visible_message("[src] begins to hum as it warms up its printing drums.")
			sleep(rand(200,400))
			src.visible_message("[src] whirs as it prints and binds a new book.")
			var/obj/item/book/b = new(src.loc)
			b.dat = O:info
			b.name = "Print Job #" + "[rand(100, 999)]"
			b.icon_state = "book[rand(1,7)]"
			qdel(O)
		else
			user.drop_item()
			O.loc = src
			user.visible_message("[user] loads some paper into [src].", "You load some paper into [src].")
			src.visible_message("[src] begins to hum as it warms up its printing drums.")
			sleep(rand(300,500))
			src.visible_message("[src] whirs as it prints and binds a new book.")
			var/obj/item/book/bundle/b = new(src.loc)
			b.pages = O:pages
			for(var/obj/item/paper/P in O.contents)
				P.forceMove(b)
			for(var/obj/item/photo/P in O.contents)
				P.forceMove(b)
			b.name = "Print Job #" + "[rand(100, 999)]"
			b.icon_state = "book[rand(1,7)]"
			qdel(O)
	else
		..()

#undef INVPAGESIZE
#undef INVPAGESIZEPUBLIC
