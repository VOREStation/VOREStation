// Holds the various pages and implementations for codex books, so they can be used in more than just books.

/datum/codex_tree
	var/atom/movable/holder = null
	var/root_type = null
	var/datum/lore/codex/home = null // Top-most page.
	var/datum/lore/codex/current_page = null // Current page or category to display to the user.
	var/list/indexed_pages = list() // Assoc list with search terms pointing to a ref of the page.  It's created on New().
	var/list/history = list() // List of pages we previously visited.

/datum/codex_tree/New(var/new_holder, var/new_root_type)
	holder = new_holder
	root_type = new_root_type
	generate_pages()
	..()

/datum/codex_tree/proc/generate_pages()
	home = new root_type(src) // This will also generate the others.
	current_page = home
	indexed_pages = current_page.index_page()

// Changes current_page to its parent, assuming one exists.
/datum/codex_tree/proc/go_to_parent()
	if(current_page && current_page.parent)
		current_page = current_page.parent

// Changes current_page to a specific page or category.
/datum/codex_tree/proc/go_to_page(var/datum/lore/codex/new_page, var/dont_record_history = FALSE)
	if(new_page) // Make sure we're not going to a null page for whatever reason.
		current_page = new_page
		if(!dont_record_history)
			history.Add(new_page)

/datum/codex_tree/proc/quick_link(var/search_word)
	for(var/word in indexed_pages)
		if(lowertext(search_word) == lowertext(word)) // Exact matches unfortunately limit our ability to perform SEOs.
			go_to_page(indexed_pages[word])
			return

/datum/codex_tree/proc/get_page_from_type(var/desired_type)
	for(var/word in indexed_pages)
		var/datum/lore/codex/C = indexed_pages[word]
		if(C.type == desired_type)
			return C
	return null

// Returns to the last visited page, based on the history list.
/datum/codex_tree/proc/go_back()
	if(history.len - 1)
		if(history[history.len] == current_page)
			history.len-- // This gets rid of the current page in the history.
		go_to_page(pop(history), dont_record_history = TRUE) // Where as this will get us the previous page that we want to go to.

/datum/codex_tree/proc/get_tree_position()
	if(current_page)
		var/output = ""
		var/datum/lore/codex/checked = current_page
		output = "<b>[checked.name]</b>"
		while(checked.parent)
			output = "<a href='?src=\ref[src];target=\ref[checked.parent]'>[checked.parent.name]</a> \> [output]"
			checked = checked.parent
		return output

/datum/codex_tree/proc/make_search_bar()
	var/html = {"
	<form id="submitForm" action="?">
	<input type = 'hidden' name = 'src' value = '\ref[src]'>
	<input type = 'hidden' name = 'action' value='search'>
	<label for = 'search_query'>Page Search: </label>
	<input type = 'text' name = 'search_query' id = 'search_query'>
	<input type = 'submit' value = 'Go'>
	</form>
	"}
	return html

/datum/codex_tree/proc/display(mob/user)
//	icon_state = "[initial(icon_state)]-open"
	if(!current_page)
		generate_pages()

	user << browse_rsc('html/browser/codex.css', "codex.css")

	var/dat
	dat =  "<head>"
	dat += "<title>[holder.name] ([current_page.name])</title>"
	dat += "<link rel='stylesheet' href='codex.css' />"
	dat += "</head>"

	dat += "<body>"
	dat += "[get_tree_position()]<br>"
	dat += "[make_search_bar()]<br>"
	dat += "<center>"
	dat += "<h2>[current_page.name]</h2>"
	dat += "<br>"
	if(current_page.data)
		dat += "[current_page.data]<br>"
	dat += "<br>"
	if(istype(current_page, /datum/lore/codex/category))
		dat += "<div class='button-group'>"
		var/datum/lore/codex/category/C = current_page
		for(var/datum/lore/codex/child in C.children)
			dat += "<a href='?src=\ref[src];target=\ref[child]' class='button'>[child.name]</a>"
		dat += "</div>"
	dat += "<hr>"
	if(history.len - 1)
		dat += "<br><a href='?src=\ref[src];go_back=1'>\[Go Back\]</a>"
	if(current_page.parent)
		dat += "<br><a href='?src=\ref[src];go_to_parent=1'>\[Go Up\]</a>"
	if(current_page != home)
		dat += "<br><a href='?src=\ref[src];go_to_home=1'>\[Go To Home\]</a>"
	dat += "</center></body>"
	user << browse(dat, "window=the_empress_protects;size=600x550")
	onclose(user, "the_empress_protects", src)

/datum/codex_tree/Topic(href, href_list)
	. = ..()
	if(.)
		return


	if(href_list["target"]) // Direct link, using a ref
		var/datum/lore/codex/new_page = locate(href_list["target"])
		go_to_page(new_page)
	else if(href_list["search_query"])
		quick_link(href_list["search_query"])
	else if(href_list["go_to_parent"])
		go_to_parent()
	else if(href_list["go_back"])
		go_back()
	else if(href_list["go_to_home"])
		go_to_page(home)
	else if(href_list["quick_link"]) // Indirect link, using a (hopefully) indexed word.
		quick_link(href_list["quick_link"])
	else if(href_list["close"])
		// Close the book, if our holder is actually a book.
		if(istype(holder, /obj/item/book/codex))
			holder.icon_state = initial(holder.icon_state)
		usr << browse(null, "window=the_empress_protects")
		return
	display(usr)