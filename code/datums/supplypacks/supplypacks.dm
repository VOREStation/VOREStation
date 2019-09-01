//SUPPLY PACKS
//NOTE: only secure crate types use the access var (and are lockable)
//NOTE: hidden packs only show up when the computer has been hacked.
//ANOTER NOTE: Contraband is obtainable through modified supplycomp circuitboards.
//BIG NOTE: Don't add living things to crates, that's bad, it will break the shuttle.
//NEW NOTE: Do NOT set the price of any crates below 7 points. Doing so allows infinite points.
//NOTE NOTE: Hidden var is now deprecated, whoever removed support for it should've removed the var altogether

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

/datum/supply_pack
	var/name = null
	var/list/contains = list() // Typepaths, used to actually spawn the contents
	var/list/manifest = list() // Object names, used to compile manifests
	var/cost = null
	var/containertype = null
	var/containername = null
	var/access = null
	var/one_access = FALSE
	var/contraband = 0
	var/num_contained = 0		//number of items picked to be contained in a /randomised crate
	var/group = "Miscellaneous"

/datum/supply_pack/New()
	for(var/path in contains)
		if(!path || !ispath(path, /atom))
			continue
		var/atom/O = path
		manifest += "\proper[initial(O.name)]"

/datum/supply_pack/proc/get_html_manifest()
	var/dat = ""
	if(num_contained)
		dat +="Contains any [num_contained] of:"
	dat += "<ul>"
	for(var/O in manifest)
		dat += "<li>[O]</li>"
	dat += "</ul>"
	return dat

// Keeping this subtype here for posterity, so it's more apparent that this is the subtype to use if making new randomised packs
/datum/supply_pack/randomised
	num_contained = 1