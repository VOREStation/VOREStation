/*
 * Borrowbook datum
 */
/datum/borrowbook // Datum used to keep track of who has borrowed what when and for how long.
	var/bookname
	var/mobname
	var/getdate
	var/duedate

/proc/tgui_add_library_book(obj/item/book/B)
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

/proc/tgui_add_library_token(list/token)
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
