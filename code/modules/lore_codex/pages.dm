// Contains the 'raw' lore data.
/datum/lore/codex
	var/name = null // Title displayed
	var/data = null // The actual words.
	var/datum/lore/codex/parent = null // Category above us
	var/list/keywords = list() // Used for searching.
	var/atom/movable/holder = null

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

/datum/lore/codex/category/New()
	..()
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

/datum/lore/codex/category/main // The top-level categories
	name = "Index"
	data = "Don't panic!\
	<br><br>\
	The many star systems inhabitied by humanity and friends can seem bewildering to the uninitiated. \
	This guide seeks to provide valuable information to anyone new in the system.  This edition is tailored for visitors to the VIR system, \
	however it also contains useful general information about human space, such as locations you may hear about, the current (as of 2561) political climate, various aliens you \
	may meet in your travels, the big Trans-Stellars, and more."
	children = list(
		/datum/lore/codex/category/important_locations,
		/datum/lore/codex/category/species,
		/datum/lore/codex/category/auto_org/tsc,
		/datum/lore/codex/category/auto_org/gov,
	//	/datum/lore/codex/category/auto_org/mil, // Add when we finish military stuff,
		/datum/lore/codex/category/political_factions,
		/datum/lore/codex/page/about
		)

// We're a bird.
/datum/lore/codex/page/about
	name = "About"
	data = "<i>The Traveler's Guide to Human Space</i> is a series of books detailing a specific location inside a location colonized by humans.  \
	This book is for the system Vir, and was written by Eshi Tache, an explorer whom has visited many star systems, and \
	has personally visited and seen many of the locations described inside this book.  Two other people have also assisted in the creation of this \
	book, being Qooqr Volquum, whom is an expert on synthetics, and Damian Fischer, a historian. Together, they provide valuable information and facts that lie outside of Tache's expertise.\
	<br><br>\
	The writings inside this edition are intended to be useful to anyone visiting it for the first time, from someone taking a vacation to beautiful Sif, \
	to an immigrant from another system or even from outside human space, and anyone inbetween.  The publisher wishes to note that any opinions expressed \
	in this text does not reflect the opinions of the publisher, and are instead the author's.\
	<br><br>\
	Eshi Tache has also written other <i>The Traveler's Guide</i> books, including <i>Sol Edition</i>, <i>Tau Ceti Edition</i>, <i>Sirius Edition</i>, and more, \
	which you can find in your local book store, library, or e-reader device."
