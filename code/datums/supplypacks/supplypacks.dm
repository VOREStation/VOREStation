//SUPPLY PACKS
//NOTE: only secure crate types use the access var (and are lockable)
//NOTE: hidden packs only show up when the computer has been hacked.
//ANOTER NOTE: Contraband is obtainable through modified supplycomp circuitboards.
//BIG NOTE: Don't add living things to crates, that's bad, it will break the shuttle.
//NEW NOTE: Do NOT set the price of any crates below 7 points. Doing so allows infinite points.

//var/list/all_supply_groups = list("Operations","Security","Hospitality","Engineering","Atmospherics","Medical","Reagents","Reagent Cartridges","Science","Hydroponics", "Supply", "Miscellaneous")
var/list/all_supply_groups = list("Atmospherics",
								  "Costumes",
								  "Engineering",
								  "Hospitality",
								  "Hydroponics",
								  "Materials",
								  "Medical",
								  "Miscellaneous",
								  "Munitions",
								  "Reagents",
								  "Reagent Cartridges",
								  "Recreation",
								  "Robotics",
								  "Science",
								  "Security",
								  "Supplies",
								  "Voidsuits")

/datum/supply_packs
	var/name = null
	var/list/contains = list()
	var/manifest = ""
	var/cost = null
	var/containertype = null
	var/containername = null
	var/access = null
	var/hidden = 0
	var/contraband = 0
	var/group = "Miscellaneous"

/datum/supply_packs/New()
	manifest += "<ul>"
	for(var/path in contains)
		if(!path || !ispath(path, /atom))
			continue
		var/atom/O = path
		manifest += "<li>[initial(O.name)]</li>"
	manifest += "</ul>"

/datum/supply_packs/randomised
	var/num_contained		//number of items picked to be contained in a randomised crate

/datum/supply_packs/randomised/New()
	manifest += "Contains any [num_contained] of:"
	..()