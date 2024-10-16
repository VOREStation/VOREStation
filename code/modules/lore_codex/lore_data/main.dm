/datum/lore/codex/category/main_vir_lore // The top-level categories for the Vir book
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
		/datum/lore/codex/page/about_lore
		)

// We're a bird.
/datum/lore/codex/page/about_lore
	name = "About"
	data = span_italics("The Traveler's Guide to Human Space") + " is a series of books detailing a specific location inside a location colonized by humans.  \
	This book is for the system Vir, and was written by Eshi Tache, an explorer whom has visited many star systems, and \
	has personally visited and seen many of the locations described inside this book.  Two other people have also assisted in the creation of this \
	book, being Qooqr Volquum, whom is an expert on synthetics, and Damian Fischer, a historian. Together, they provide valuable information and facts that lie outside of Tache's expertise.\
	<br><br>\
	The writings inside this edition are intended to be useful to anyone visiting it for the first time, from someone taking a vacation to beautiful Sif, \
	to an immigrant from another system or even from outside human space, and anyone inbetween.  The publisher wishes to note that any opinions expressed \
	in this text does not reflect the opinions of the publisher, and are instead the author's.\
	<br><br>\
	Eshi Tache has also written other " + span_italics("The Traveler's Guide") + " books, including " + span_italics("Sol Edition") + ", " + span_italics("Tau Ceti Edition") + ", " + span_italics("Alpha Centauri Edition") + ", and more, \
	which you can find in your local book store, library, or e-reader device."
