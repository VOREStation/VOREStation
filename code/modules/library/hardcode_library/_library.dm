/*
 * Home of the New (NOV 1st, 2019) library books.
 */

/obj/item/book/custom_library
	name = "Book"
	desc = "A hardbound book."
	description_info = "This book is printed from the custom repo. If you can see this, something went wrong."

	icon = 'icons/obj/custom_books.dmi'
	icon_state = "book"

	// This is the ckey of the book's author.
	var/origkey = null
	author = "UNKNOWN"

/obj/item/book/custom_library/fiction
	libcategory = "Fiction"

/obj/item/book/custom_library/nonfiction
	libcategory = "Non-Fiction"

/obj/item/book/custom_library/reference
	libcategory = "Reference"

/obj/item/book/custom_library/religious
	libcategory = "Religious"
/*
/obj/item/book/custom_library/adult
	libcategory = "Adult"
*/
/obj/item/book/bundle/custom_library
	name = "Book"
	desc = "A hardbound book."
	description_info = "This book is printed from the custom repo. If you can see this, something went wrong."

	icon = 'icons/obj/custom_books.dmi'
	icon_state = "book"

	// This is the ckey of the book's author.
	var/origkey = null
	author = "UNKNOWN"

	page = 1 //current page
	pages = list() //the contents of each page

/obj/item/book/bundle/custom_library/fiction
	libcategory = "Fiction"

/obj/item/book/bundle/custom_library/nonfiction
	libcategory = "Non-Fiction"

/obj/item/book/bundle/custom_library/reference
	libcategory = "Reference"

/obj/item/book/bundle/custom_library/religious
	libcategory = "Religious"
/*
/obj/item/book/bundle/custom_library/adult
	libcategory = "Adult"
*/
