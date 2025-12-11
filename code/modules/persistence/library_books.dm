/datum/persistent/library_books
	name = "library_books"
	//entries_expire_at = 1000 // Basically forever
	var/max_entries = 1000 //1000 paintings is a lot, and will take a long time to cycle through.
	var/ready_to_write = TRUE // Abuse prevention

/datum/persistent/library_books/SetFilename()
	filename = "data/persistent/[lowertext(using_map.name)]-library_books.json"

/datum/persistent/library_books/Initialize()
	. = ..()
	if(fexists(filename))
		SSpersistence.all_books = json_decode(file2text(filename))
		for(var/ID in SSpersistence.all_books)
			var/list/token = SSpersistence.all_books[ID]
			if(!CheckTokenSanity(token))
				SSpersistence.all_books -= token

/datum/persistent/library_books/CheckTokenSanity(var/list/token)
	return ( \
		!isnull(token["uid"]) && \
		!isnull(token["title"]) && \
		!isnull(token["author"]) && \
		!isnull(token["deleted"]) && \
		!isnull(token["protected"])
	)

/datum/persistent/library_books/proc/CheckBookSanity(var/list/token)
	return ( \
		!isnull(token["uid"]) && \
		!isnull(token["name"]) && \
		!isnull(token["title"]) && \
		!isnull(token["dat"]) && \
		!isnull(token["libcategory"]) && \
		!isnull(token["author"]) && \
		!isnull(token["icon_state"])
	)

/datum/persistent/library_books/Shutdown()
	if(SSpersistence.all_books.len > max_entries)
		var/this_many = SSpersistence.all_books.len
		var/over = this_many - max_entries
		log_admin("There are [over] more book(s) stored than the maximum allowed.")
		while(over > 0)
			var/list/d = SSpersistence.all_books[1]
			if(SSpersistence.all_books.Remove(list(d)))
				log_admin("A book was deleted")
			else
				log_and_message_admins("Attempted to delete a book, but failed.")
			over --

	// cleanup list
	var/list/output_list = list()
	for(var/entry_id in SSpersistence.all_books)
		var/list/entry = SSpersistence.all_books[entry_id]
		if(!entry)
			continue
		if(!CheckTokenSanity(entry))
			continue
		if(entry["protected"])
			entry["deleted"] = FALSE // if this somehow happens due to VV meddling
		if(!entry["deleted"])
			entry["protected"] = TRUE // Protect flag book next round. Require admin deletion by default. Current books in the round should be admin protected if abuse happens.
			output_list[entry_id] = entry
		else
			log_admin("A book was deleted during the round")
			var/hash = md5(entry["uid"])
			var/filecheck = "data/persistent/library/[hash]-library_book.json"
			if(fexists(filecheck))
				fdel(filecheck)

	// Saving library index file
	if(fexists(filename))
		fdel(filename)
	to_file(file(filename), json_encode(output_list))
	SSpersistence.all_books = output_list // Update list, for manual debugging

/datum/persistent/library_books/proc/add_new_book(var/obj/item/book/B)
	var/search_id = "[B.name]_[B.author]_[B.libcategory]"
	var/replacing = null

	var/hash_key = md5(search_id)
	var/list/entry = SSpersistence.all_books[hash_key]

	if(!ready_to_write)
		return LIBRARY_UPLOAD_STATUS_TIMEOUT

	if(entry)
		replacing = entry // store the data entry from the list for editing later
		if(replacing["uid"] != search_id || replacing["protected"])
			return LIBRARY_UPLOAD_STATUS_ISPROTECTED

	var/list/data = list(
		"uid" = search_id,
		"title" = B.name,
		"author" = B.author,
		"category" = B.libcategory,
		"deleted" = FALSE,
		"protected" = FALSE // ADMIN deletion prevention
	)

	if(replacing)
		var/was_deleted = FALSE
		if(replacing["deleted"])
			was_deleted = TRUE

		for(var/key in data)
			replacing["[key]"] = data["[key]"] // bulk replace all keys

		if(!save_book_to_file(B))
			replacing["deleted"] = TRUE
			return LIBRARY_UPLOAD_STATUS_FAILPARSE

		if(was_deleted)
			return LIBRARY_UPLOAD_STATUS_SUCCESSFUL

		return LIBRARY_UPLOAD_STATUS_REPLACED

	SSpersistence.all_books[hash_key] = data
	if(!save_book_to_file(B))
		SSpersistence.all_books -= hash_key
		return LIBRARY_UPLOAD_STATUS_FAILPARSE

	return LIBRARY_UPLOAD_STATUS_SUCCESSFUL

/datum/persistent/library_books/proc/get_stored_book(var/uid,var/location,var/unique = TRUE)
	if(!uid) // somehow null ui, possibly bad data used
		return null
	var/hash_key = md5(uid)
	var/list/token = SSpersistence.all_books[hash_key]
	if(!token)
		return null
	if(token["uid"] != uid) // IF SOMEHOW
		return null
	if(token["deleted"])
		return null
	var/list/data = load_book_from_file(token)
	if(!data)
		return null
	var/obj/item/book/NewBook
	if(data["pages"])
		// not false or null, assume a bundle book!
		var/obj/item/book/bundle/bund = new /obj/item/book/bundle(location)
		for(var/page in data["pages"])
			bund.pages.Add(page)
		NewBook = bund
	else
		// normal book
		NewBook = new(location)
	NewBook.name = "[data["name"]]"
	NewBook.title = "[data["title"]]"
	NewBook.dat = "[data["dat"]]"
	NewBook.libcategory = "[data["libcategory"]]"
	NewBook.author = "[data["author"]]"
	NewBook.icon_state = "[data["icon_state"]]"
	NewBook.unique = unique
	return NewBook

/datum/persistent/library_books/proc/delete_stored_book(var/uid)
	if(!uid) // somehow null ui, possibly bad data used
		return FALSE
	var/hash_key = md5(uid)
	var/list/token = SSpersistence.all_books[hash_key]
	if(!token)
		return FALSE
	if(token["uid"] != uid)
		return FALSE // IF SOMEHOW
	if(token["protected"])
		token["deleted"] = FALSE // incase
		return FALSE
	token["deleted"] = TRUE // We remove books during Shutdown, so admins can undelete books using VV before round ends
	return TRUE

/datum/persistent/library_books/proc/restore_stored_book(var/uid)
	if(!uid) // somehow null ui, possibly bad data used
		return FALSE
	var/hash_key = md5(uid)
	var/list/token = SSpersistence.all_books[hash_key]
	if(!token)
		return FALSE
	if(token["uid"] != uid) // IF SOMEHOW
		return FALSE
	token["deleted"] = FALSE
	return TRUE

/datum/persistent/library_books/proc/protect_stored_book(var/uid)
	if(!uid) // somehow null ui, possibly bad data used
		return FALSE
	var/hash_key = md5(uid)
	var/list/token = SSpersistence.all_books[hash_key]
	if(!token)
		return FALSE
	if(token["uid"] != uid) // IF SOMEHOW
		return FALSE
	token["protected"] = !token["protected"] // Undelete+ prevents deletion again.
	token["deleted"] = FALSE
	return TRUE

/datum/persistent/library_books/proc/save_book_to_file(var/obj/item/book/B)
	var/search_id = "[B.name]_[B.author]_[B.libcategory]"
	var/list/data = list(
							"uid" = search_id,
							"name" = B.name,
							"title" = B.name,
							"dat" = B.dat, // Is there any way to base64 encode these keys for safety when storing it? I don't like storing even sanitized raw html
							"libcategory" = B.libcategory,
							"author" = B.author,
							"icon_state" = B.icon_state
						)
	if(istype(B,/obj/item/book/bundle))
		// Collect pages if a bundle
		var/obj/item/book/bundle/bund = B
		var/list/PG = list()
		for(var/page in bund.pages)
			PG.Add(page)
		data["pages"] = PG
	else
		// false otherwise
		data["pages"] = FALSE
	// I sense stupidity
	if(!CheckBookSanity(data))
		return FALSE
	var/hash = md5(data["uid"])
	var/filecheck = "data/persistent/library/[hash]-library_book.json"
	if(fexists(filecheck))
		fdel(filecheck) // remove old
	to_file(file(filecheck), json_encode(data))
	// Prevent file writing abuse
	ready_to_write = FALSE
	VARSET_IN(src, ready_to_write, TRUE, 4 SECONDS)
	return fexists(filecheck) // Check if write failed due to bad encode

/datum/persistent/library_books/proc/load_book_from_file(var/token)
	if(!token)
		return
	if(!CheckTokenSanity(token))
		token["protected"] = FALSE // invalid now
		delete_stored_book(token["uid"]) // Invalid token entry somehow
		return
	var/hash = md5(token["uid"])
	var/filecheck = "data/persistent/library/[hash]-library_book.json"
	if(!fexists(filecheck))
		return
	var/str = file2text(filecheck)
	if(!str)
		token["protected"] = FALSE // invalid now
		delete_stored_book(token["uid"]) // WELP, failed parse.
		return
	var/decode = json_decode(str)
	if(!decode || !CheckBookSanity(decode))
		token["protected"] = FALSE // invalid now
		delete_stored_book(token["uid"]) // Why?... Old format?
		return
	return decode
