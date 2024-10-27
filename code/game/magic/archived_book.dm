//This file was auto-corrected by findeclaration.exe on 29/05/2012 15:03:04

#define BOOK_VERSION_MIN	1
#define BOOK_VERSION_MAX	2
#define BOOK_PATH			"data/books/"

var/global/datum/book_manager/book_mgr = new()

/datum/book_manager/proc/path(id)
	if(isnum(id)) // kill any path exploits
		return "[BOOK_PATH][id].sav"

/datum/book_manager/proc/getall()
	var/list/paths = flist(BOOK_PATH)
	var/list/books = new()

	for(var/path in paths)
		var/datum/archived_book/B = new(BOOK_PATH + path)
		books += B

	return books

/datum/book_manager/proc/freeid()
	var/list/paths = flist(BOOK_PATH)
	var/id = paths.len + 101

	// start at 101+number of books, which will be correct id if none have been deleted, etc
	// otherwise, keep moving forward until we find an open id
	while(fexists(path(id)))
		id++

	return id

/client/proc/delbook()
	set name = "Delete Book"
	set desc = "Permamently deletes a book from the database."
	set category = "Admin"
	if(!src.holder)
		to_chat(src, "Only administrators may use this command.")
		return
//VOREStation Edit Start
	var/obj/machinery/librarycomp/our_comp
	for(var/obj/machinery/librarycomp/l in world)
		if(istype(l, /obj/machinery/librarycomp))
			our_comp = l
			break

	if(!our_comp)
		to_chat(usr, span_warning("Unable to locate a library computer to use for book deleting."))
		return

	var/dat = "<HEAD><TITLE>Book Inventory Management</TITLE></HEAD><BODY>\n" // <META HTTP-EQUIV='Refresh' CONTENT='10'>
		dat += "<h3>ADMINISTRATIVE MANAGEMENT</h3>"
		establish_old_db_connection()

		if(!dbcon_old.IsConnected())
			dat += "<font color=red><b>ERROR</b>: Unable to contact External Archive. Please contact your system administrator for assistance.</font>"
		else
			dat += {"<A href='?our_comp=\ref[our_comp];[HrefToken()];orderbyid=1'>(Order book by SS<sup>13</sup>BN)</A><BR><BR>
			<table>
			<tr><td><A href='?our_comp=\ref[our_comp];[HrefToken()];sort=author>AUTHOR</A></td><td><A href='?our_comp=\ref[our_comp];[HrefToken()];sort=title>TITLE</A></td><td><A href='?our_comp=\ref[our_comp];[HrefToken()];sort=category>CATEGORY</A></td><td></td></tr>"}
			var/DBQuery/query = dbcon_old.NewQuery("SELECT id, author, title, category FROM library ORDER BY [sortby]")
			query.Execute()

			var/show_admin_options = check_rights(R_ADMIN, show_msg = FALSE)

			while(query.NextRow())
				var/id = query.item[1]
				var/author = query.item[2]
				var/title = query.item[3]
				var/category = query.item[4]
				dat += "<tr><td>[author]</td><td>[title]</td><td>[category]</td><td>"
				if(show_admin_options) // This isn't the only check, since you can just href-spoof press this button. Just to tidy things up.
					dat += "<A href='?our_comp=\ref[our_comp];[HrefToken()];delid=[id]'>\[Del\]</A>"
				dat += "</td></tr>"
			dat += "</table>"

	usr << browse(dat, "window=library")
	onclose(usr, "library")
//VOREStation Edit End

// delete a book
/datum/book_manager/proc/remove(var/id)
	fdel(path(id))

/datum/archived_book
	var/author		 // Who wrote the thing, can be changed by pen or PC. It is not automatically assigned
	var/title		 // The real name of the book.
	var/category	 // The category/genre of the book
	var/id			 // the id of the book (like an isbn number)
	var/dat			 // Actual page content

	var/author_real	 // author's real_name
	var/author_key	 // author's byond key
	var/list/icon/photos	 // in-game photos used

// loads the book corresponding by the specified id
/datum/archived_book/New(var/path)
	if(isnull(path))
		return

	var/savefile/F = new(path)

	var/version
	F["version"] >> version

	if (isnull(version) || version < BOOK_VERSION_MIN || version > BOOK_VERSION_MAX)
		fdel(path)
		to_chat(usr, "What book?")
		return 0

	F["author"] >> author
	F["title"] >> title
	F["category"] >> category
	F["id"] >> id
	F["dat"] >> dat

	F["author_real"] >> author_real
	F["author_key"] >> author_key
	F["photos"] >> photos
	if(!photos)
		photos = new()

	// let's sanitize it here too!
	for(var/tag in paper_blacklist)
		if(findtext(dat,"<"+tag))
			dat = ""
			return


/datum/archived_book/proc/save()
	var/savefile/F = new(book_mgr.path(id))

	F["version"] << BOOK_VERSION_MAX
	F["author"] << author
	F["title"] << title
	F["category"] << category
	F["id"] << id
	F["dat"] << dat

	F["author_real"] << author_real
	F["author_key"] << author_key
	F["photos"] << photos

#undef BOOK_VERSION_MIN
#undef BOOK_VERSION_MAX
#undef BOOK_PATH
