// Contains the 'raw' lore data.
/datum/lore/codex
	var/name = null // Title displayed
	var/data = null // The actual words.
	var/datum/lore/codex/parent = null // Category above us
	var/list/keywords = list() // Used for searching.
	var/datum/codex_tree/holder = null

/datum/lore/codex/New(var/new_holder, var/new_parent)
	..()
	holder = new_holder
	parent = new_parent
	add_content()
	if(name)
		keywords.Add(name)

/datum/lore/codex/Topic(href, href_list)
	. = ..()
	if(.)
		return

	holder.Topic(href, href_list) // Redirect to the physical object

/datum/lore/codex/page

// Returns an assoc list of keywords binded to a ref of this page.  If it's a category, it will also recursively call this on its children.
/datum/lore/codex/proc/index_page()
	var/list/results = list()
	for(var/keyword in keywords)
		results[keyword] = src
	return results

// This gets called in New(), which is helpful for inserting quick_link()s.
/datum/lore/codex/proc/add_content()
	return

// Use this to quickly link to a different page
/datum/lore/codex/proc/quick_link(var/target, var/word_to_display)
	if(isnull(word_to_display))
		word_to_display = target
	return "<a href='?src=\ref[src];quick_link=[target]'>[word_to_display]</a>"

// Can only be found by specifically searching for it.
/datum/lore/codex/page/ultimate_answer
	name = "Answer to the Ultimate Question of Life, the Universe, and Everything"
	data = "42"
	keywords = list("Ultimate Question", "Ultimate Question of Life, the Universe, and Everything", "Life, the Universe, and Everything", "Everything", "42")

// Organizes pages together.
/datum/lore/codex/category
	var/list/children = list() // Pages or more categories relevant to this category.  Self initializes from types to refs in New()

/datum/lore/codex/category/Initialize()
	. = ..()
	var/list/new_children_list = list()
	for(var/type in children)
		new_children_list.Add(new type(holder, src))
	children = new_children_list

/datum/lore/codex/category/index_page()
	// First, get our own keywords.
	var/list/results = ..()
	// Now get our children.  If a child is also a category, it will get their children too.
	for(var/datum/lore/codex/child in children)
		results += child.index_page()
	return results
