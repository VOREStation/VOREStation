/datum/lore/system
	var/name = "" //the system's name
	var/desc = "" // short description probably stolen from places on the wiki
	var/history = "" //unused, but included for parity with /lore/organizations
	var/autogenerate_destinations = TRUE // should probably be true for most systems, might be false for Sif or weird shit like Isavau's / Terminus / Silk
	var/planets = list() //planetary destinations will automatically pick an inhabited terrestrial planet to be on. no planet == no planetary destinations. major planets only
	var/space_destinations = list("a dockyard", "a station", "a vessel", "a waystation", "a satellite", "a spaceport", "an anomaly", "a habitat", "an outpost", "a facility", "a derelict", "a wreck", "a Skathari hotspot") // should be just fine for most systems, some might want individual entries culled from the autogen
	var/planetary_destinations = list("a colony", "a dome", "an outpost", "a city", "a facility", "a ruin") //likewise
	var/locations = list() // locations within the system. list of strings for now, might involve fancier logic later

/datum/lore/system/New()
	..()
	if(!autogenerate_destinations)
		return
	for(var/i in 1 to 3)// three random places per system per round should be plenty
		var/initial = ""
		var/mission = list()
		if(rand(length(planets))) // equal chance of an event in local space or any individual planet
			initial = pick(planetary_destinations)
			if(initial in list("an outpost", "a facility", "a commune", "a settlement")) //some of these aren't in the default list but are used down the line
				mission = list(ATC_TYPICAL)
			else if(initial in list("a ruin"))
				mission = list(ATC_SALVAGE)
			else
				mission = list(ATC_ALL_CIV)
			locations += new /datum/lore/location((initial + " on " + pick(planets) + ", " + name), mission)
		else
			initial = pick(space_destinations)
			if(initial in list("a waystation", "a satellite"))
				mission = list(ATC_TRANS, ATC_FREIGHT, ATC_DEF, ATC_INDU) //generally unmanned so no medical or science jobs
			else if(initial in list("an anomaly"))
				mission = list(ATC_DEF, ATC_SCI) //theres kinda only two things to do about mysterious space wedgies)
			else if(initial in list("a skathari hotspot"))
				mission = list(ATC_DEF, ATC_MED)
			else if(initial in list("a dockyard", "a station", "a vessel", "a spaceport", "an outpost", "a facility"))
				mission = list(ATC_TYPICAL)
			else if(initial in list("a derelict", "a wreck"))
				mission = list(ATC_SALVAGE)
			else
				mission = list(ATC_ALL_CIV)
			locations += new /datum/lore/location("[initial] in [name]", mission)

//some of the locations with identical mission types could be compressed with pick expressions in a single location datum to improve weighting
//this usually isn't super necessary and is often outright counterproductive so I haven't really done it

//for reference: ATC_TYPICAL is medical, defense, freight, transport, and industrial missions-- the kind of traffic you'd see to a small settlement or independent colony of little note
//ATC_ALL_CIV has ATC_TYPICAL plus luxury and scientific missions too, so it's the kind of traffic you'd see to a major cultural center
//ATC_ALL has ATC_ALL_CIV plus diplomatic and salvage missions and really isn't appropriate for use in most places

//ATC_SCI might need to get split into academic stuff and 'weird space wedgies'

//SCG major systems
/datum/lore/system/sol
	name = "Sol"
	desc = "Humanity's heartland. The most densely settled system in space. You know. Sol." //desc isn't currently used for anything so I'm being sparse for all of these in hopes of like, actually completing the project.
	autogenerate_destinations = FALSE // it has more sites than literally anywhere else
	planets = list("Earth", "Mars", "Luna", "Venus", "Titan", "Pluto") //not used but whatever
	locations = list(
		new /datum/lore/location("Baghdad on Earth, Sol", list(ATC_LUX)),
		new /datum/lore/location("Paradise Bay on Earth, Sol", list(ATC_TYPICAL)),
		new /datum/lore/location("Atlantis on Earth, Sol", list(ATC_INDU, ATC_SCI)),
		new /datum/lore/location("Elevator City on Earth, Sol", list(ATC_TYPICAL)),
		new /datum/lore/location("Antanavario on Earth, Sol", list(ATC_TYPICAL, ATC_DIPLO)), //they independent baybe
		new /datum/lore/location("Paris on Earth, Sol", list(ATC_ALL_CIV, ATC_DIPLO)), //just a reasonable number of existing world cities that would not be underwater or desertified. by which i mean god please check my work on this.
		new /datum/lore/location("Detroit on Earth, Sol", list(ATC_ALL_CIV, ATC_DIPLO)), //it's not clear which parts of earth are independent now so let's just assume the diplomatic corps is working on all of them
		new /datum/lore/location("Dubai on Earth, Sol", list(ATC_ALL_CIV, ATC_DIPLO)),
		new /datum/lore/location("Beijing on Earth, Sol", list(ATC_ALL_CIV, ATC_DIPLO)),
		new /datum/lore/location("Dakar on Earth, Sol", list(ATC_ALL_CIV, ATC_DIPLO)),
		new /datum/lore/location("Sao Paulo on Earth, Sol", list(ATC_ALL_CIV, ATC_DIPLO)),
		new /datum/lore/location("Mojave University on Earth, Sol", list(ATC_SCI)),
		new /datum/lore/location("a station orbitting Earth, Sol", list(ATC_ALL_CIV)),
		new /datum/lore/location("a colony in Earth-Luna Lagrange Orbit in Sol", list(ATC_ALL_CIV)),
		new /datum/lore/location("Tycho on Luna, Sol", list(ATC_ALL_CIV)),
		new /datum/lore/location("the Pearlshield Coalition embassy in Tycho, Luna, Sol", list(ATC_DIPLO)), // a lot of embassy spam but most orgs don't do diplomatic missions so they'll be ignored
		new /datum/lore/location("the Moghes Hegemony embassy in Tycho, Luna, Sol", list(ATC_DIPLO)),
		new /datum/lore/location("the Five Arrows embassy in Tycho, Luna, Sol", list(ATC_DIPLO)),
		new /datum/lore/location("the Almach Protectorate embassy in Tycho, Luna, Sol", list(ATC_DIPLO)),
		new /datum/lore/location("a skrellian embassy in Little Qerrbalak, Luna, Sol", list(ATC_DIPLO)),
		new /datum/lore/location("an independent embassy on Luna, Sol", list(ATC_DIPLO)),
		new /datum/lore/location("a dome on Luna, Sol", list(ATC_ALL_CIV)), //padding -- Luna's kind of a big deal relative to its number of named sites
		new /datum/lore/location("a city on Luna, Sol", list(ATC_ALL_CIV)),
		new /datum/lore/location("a Fleet base on Luna, Sol", list(ATC_TRANS, ATC_FREIGHT, ATC_INDU)), //fleet does their own defense and medical
		new /datum/lore/location("the Armstrong Museum and Gift Shop on Luna, Sol", list(ATC_LUX)),
		new /datum/lore/location("a Second Cold War battlefield on Luna, Sol", list(ATC_LUX)),
		new /datum/lore/location("Tharsis on Mars, Sol", list(ATC_ALL_CIV)), //more padding
		new /datum/lore/location("a facility in Tharsis, Mars, Sol", list(ATC_ALL_CIV)),
		new /datum/lore/location("Tharsis University on Mars, Sol", list(ATC_SCI)),
		new /datum/lore/location("Olympus Mon on Mars, Sol", list(ATC_TYPICAL)),
		new /datum/lore/location("Shudra's Retreat on Venus, Sol", list(ATC_LUX, ATC_TRANS, ATC_MED)),
		new /datum/lore/location("Persephone on Venus, Sol", list(ATC_ALL_CIV)),
		new /datum/lore/location("Mariner University on Venus, Sol", list(ATC_SCI)),
		new /datum/lore/location("an aerostat on Venus, Sol", list(ATC_ALL_CIV)),
		new /datum/lore/location("Nyborg on Pluto, Sol", list(ATC_TYPICAL)),
		new /datum/lore/location("Makom Kal on Pluto, Sol", list(ATC_TYPICAL)),
		new /datum/lore/location("Novy Krasnoyarsk on Pluto, Sol", list(ATC_TYPICAL)),
		new /datum/lore/location("Xanadu on Titan, Saturn subsystem, Sol", list(ATC_ALL_CIV)),
		new /datum/lore/location("Seledon on Titan, Saturn subsystem, Sol", list(ATC_TYPICAL)),
		new /datum/lore/location("Hammar on Titan, Saturn subsystem, Sol", list(ATC_TYPICAL)),
		new /datum/lore/location("Bolsena on Titan, Saturn subsystem, Sol", list(ATC_TYPICAL)),
		new /datum/lore/location("Sotra on Titan, Saturn subsystem, Sol", list(ATC_TYPICAL)),
		new /datum/lore/location("Mercury, Sol", list(ATC_TYPICAL)),
		new /datum/lore/location("Callisto, Jupiter subsystem, Sol", list(ATC_TYPICAL)),
		new /datum/lore/location("Ganymede, Jupiter subsystem, Sol", list(ATC_TYPICAL)),
		new /datum/lore/location("Io, Jupiter subsystem, Sol", list(ATC_TYPICAL)),
		new /datum/lore/location("a detention facility on Io, Jupiter subsystem, Sol", list(ATC_MED, ATC_TRANS)),
		new /datum/lore/location("Europa, Jupiter subsystem, Sol", list(ATC_ALL_CIV)),
		new /datum/lore/location("Titania, Uranus subsystem, Sol", list(ATC_TYPICAL)),
		new /datum/lore/location("Oberon, Uranus subsystem, Sol", list(ATC_TYPICAL, ATC_SCI)), //there's ancient discord lore that has a school here??
		new /datum/lore/location("Neptune, Sol", list(ATC_TYPICAL))
		)

/datum/lore/system/vir
	name = "Vir"
	desc = "You Are Here. A crossroads system with a tendency towards sleepy isolation."
	autogenerate_destinations = FALSE
	planets = list("Sif")
	locations = list(
		new /datum/lore/location("New Rekjavik", list(ATC_ALL_CIV)), //sivian locations don't need 'on sif' and virite locations dont need 'in vir'-- theyre local
		new /datum/lore/location("Kalmar", list(ATC_ALL_CIV)),
		new /datum/lore/location("Ekmanshalvo", list(ATC_ALL_CIV)),
		new /datum/lore/location("a settlement on the Thorvaldsson Plains", list(ATC_TYPICAL)), //padding
		new /datum/lore/location("a mining outpost in the Dauthabrekka Mountains", list(ATC_TYPICAL)),
		new /datum/lore/location("a corporate facility in Stockholm-Skargard", list(ATC_TYPICAL, ATC_SCI)),
		new /datum/lore/location("a site in the Ullran Expanse", list(ATC_MED, ATC_DEF, ATC_INDU)),
		new /datum/lore/location("a location in the Anomalous Region", list(ATC_SCI)),
		new /datum/lore/location("the NLS Southern Cross", list(ATC_DEF, ATC_INDU)),
		new /datum/lore/location("the NCS Northern Star", list(ATC_TYPICAL, ATC_SCI)),
		new /datum/lore/location("Vir Interstellar Spaceport", list(ATC_TYPICAL)),
		new /datum/lore/location("Firnir", list(ATC_TYPICAL)),
		new /datum/lore/location("Tyr", list(ATC_TYPICAL)),
		new /datum/lore/location("Magnai", list(ATC_TYPICAL)),
		new /datum/lore/location("the rings of Kara", list(ATC_LUX)),
		new /datum/lore/location("the rings of Rota", list(ATC_LUX)),
		new /datum/lore/location("the Radiance Energy Chain", list(ATC_FREIGHT, ATC_DEF, ATC_INDU)),
		new /datum/lore/location("a corporate colony in the Kara subsystem", list(ATC_ALL_CIV)), //padding-- there should probably be more than one named kara colony anyway
		new /datum/lore/location("an independent colony in the Kara subsystem", list(ATC_ALL_CIV)),
		new /datum/lore/location("a phoron mine in the Kara subsystem", list(ATC_TYPICAL)),
		new /datum/lore/location("a xenoarcheological dig in the Kara subsystem", list(ATC_TYPICAL, ATC_SCI)),
		new /datum/lore/location("an Incursion derelict in local space", list(ATC_SALVAGE, ATC_DEF, ATC_SCI, ATC_INDU)),
		new /datum/lore/location("Colony Bright", list(ATC_TYPICAL, ATC_DIPLO))
		)

/datum/lore/system/alpha_centauri
	name = "Alpha Centauri"
	desc = "The stars closest to Sol and the site of the first extrasolar colonies. The worlds orbitting Proxima Centauri were colonized by stateless refugees\
	 as part of an early SCG migration program.The habitats orbitting Alpha Centauri proper were colonized by radical terrorists fleeing Solar law enforcement.\
	 There is some tension."
	planets = list("Kishar", "Anshar")
	locations = list(
		new /datum/lore/location("Kanondaga on Kishar, Alpha Centauri", list(ATC_ALL_CIV)),
		new /datum/lore/location("Putiya Nadu on Kishar, Alpha Centauri", list(ATC_ALL_CIV)),
		new /datum/lore/location("Oyo-ni-aaye on Kishar, Alpha Centauri", list(ATC_ALL_CIV)),
		new /datum/lore/location("Valhalla in Heaven, Alpha Centauri", list(ATC_TYPICAL)),
		new /datum/lore/location("Elyisum in Heaven, Alpha Centauri", list(ATC_TYPICAL)),
		new /datum/lore/location("the remains of Ragnarok, Alpha Centauri", list(ATC_INDU, ATC_FREIGHT, ATC_SCI)),
		new /datum/lore/location("The Rings in Heaven, Alpha Centauri", list(ATC_ALL_CIV)),
		new /datum/lore/location("The Angelic College at Heaven, Alpha Centauri", list(ATC_SCI))
		)

/datum/lore/system/tau_ceti
	name = "Tau Ceti"
	desc = "Home to the first discovered garden world other than Earth and the second largest population. Tends to be kind of isolationist and independently minded."
	planets = list("Binma", "New Gibson")
	locations = list(
		new /datum/lore/location("Pelamance, Binma, Tau Ceti", list(ATC_ALL_CIV)), //pulling the list of city states from the Binma page was An Effort. may have missed some
		new /datum/lore/location("New Florence, Binma, Tau Ceti", list(ATC_ALL_CIV)),
		new /datum/lore/location("Mandala Sur, Binma, Tau Ceti", list(ATC_ALL_CIV)),
		new /datum/lore/location("the Kesalon, Binma, Tau Ceti", list(ATC_SCI, ATC_TRANS, ATC_LUX)),
		new /datum/lore/location("the Hyperion Orbital Scaffhold around Binma, Tau Ceti", list(ATC_ALL_CIV)),
		new /datum/lore/location("Ceti Technical Institute, Binma, Tau Ceti", list(ATC_SCI)),
		new /datum/lore/location("Aria, Tau Ceti", list(ATC_INDU, ATC_FREIGHT, ATC_LUX)),
		new /datum/lore/location("LL1, Tau Ceti", list(ATC_INDU, ATC_FREIGHT, ATC_TRANS)),
		new /datum/lore/location("LL2, Tau Ceti", list(ATC_INDU, ATC_FREIGHT, ATC_TRANS))
		)

/datum/lore/system/tau_ceti/New()
	planetary_destinations -= "a dome" //binma is fully habitable. i think new gibson also is
	..()

/datum/lore/system/kess_gendar
	name = "Kess-Gendar"
	desc = "A cosmopolitan system hosting the jungle world Nisp and a large orbital economy."
	planets = list("Nisp")
	locations = list(
		new /datum/lore/location("Gorovan on Nisp, Kess-Gendar", list(ATC_ALL_CIV)),
		new /datum/lore/location("Janthir on Nisp, Kess-Gendar", list(ATC_ALL_CIV)),
		new /datum/lore/location("al-Dubad on Nisp, Kess-Gendar", list(ATC_ALL_CIV)),
		new /datum/lore/location("Qixiang on Nisp, Kess-Gendar", list(ATC_ALL_CIV)),
		new /datum/lore/location("Theveste on Nisp, Kess-Gendar", list(ATC_TYPICAL, ATC_SCI)),
		new /datum/lore/location("Eta Kess, Nisp orbit, Kess-Gendar", list(ATC_TYPICAL)),
		new /datum/lore/location("Elysium, Kess-Gendar", list(ATC_TYPICAL)),
		new /datum/lore/location("Colony Heedful, Kess-Gendar", list(ATC_TYPICAL, ATC_DIPLO))
		)

/datum/lore/system/el
	name = "El"
	desc = "Home system of the positronics and birthplace of the Positronic Rights Movement."
	locations = list(
		new /datum/lore/location("the First Factory in Sophia, El", list(ATC_LUX, ATC_FREIGHT)),
		new /datum/lore/location("Gilthari Casino in Sophia, El", list(ATC_LUX, ATC_TRANS)),
		new /datum/lore/location("the Old City in Sophia, El", list(ATC_FREIGHT, ATC_TRANS, ATC_DEF, ATC_SCI, ATC_LUX)),
		new /datum/lore/location("the Pleroman Cathedral in Sophia, El", list(ATC_LUX, ATC_TRANS)),
		new /datum/lore/location("a habitat block in Sophia, El", list(ATC_FREIGHT, ATC_TRANS, ATC_DEF)), //Sophia doesn't really get medical ships because it's all fucking robots
		new /datum/lore/location("a Morpheus Sol facility in Sophia, El", list(ATC_FREIGHT, ATC_TRANS, ATC_DEF, ATC_SCI)), //padding -- autogenerated locations aren't going to play nicely with Sophia's topography
		new /datum/lore/location("a datacenter in Sophia, El", list(ATC_FREIGHT, ATC_TRANS, ATC_DEF, ATC_SCI)),
		new /datum/lore/location("a dig site in Sophia, El", list(ATC_TYPICAL, ATC_SCI)),
		new /datum/lore/location("the MAS Sophia Jr. in El", list(ATC_TYPICAL, ATC_SCI))
		)

//it is objectively weird as hell that these are "major systems" but they have words on
/datum/lore/system/nyx
	name = "Nyx"
	desc = "Human-colonized system furthest from Sol. Covered in weird phoron anomalies. Was not treated very nicely by the Incursion."
	planets = list("Brinkburn", "Yulecite")
	locations = list(
		new /datum/lore/location("Moros, Nyx", list(ATC_TYPICAL)),
		new /datum/lore/location("Erebus, Nyx", list(ATC_TYPICAL, ATC_SCI)),
		new /datum/lore/location("Roanoke, Erebus subsystem, Nyx", list(ATC_TYPICAL)),
		new /datum/lore/location("the NSS Exodus in Nyx", list(ATC_TYPICAL, ATC_SCI)),
		new /datum/lore/location("the NAS Crescent in Nyx", list(ATC_TYPICAL)),
		new /datum/lore/location("Talon's Bull in Nyx", list(ATC_TYPICAL)),
		new /datum/lore/location("Emerald Habitation in Nyx", list(ATC_TYPICAL)),
		new /datum/lore/location("the Void Star in Nyx", list(ATC_TRANS, ATC_FREIGHT, ATC_LUX)),
		new /datum/lore/location("Euthenia, Nyx", list(ATC_TYPICAL)),
		new /datum/lore/location("an Incursion wreck", list(ATC_SALVAGE))
		)

/datum/lore/system/altair //hey do you think altair like. survived the incursion actually
	name = "Altair"
	desc = "Once a promising nearby colonization site, Altair is now a very, very large prison."
	space_destinations = list("a station", "a vessel", "a waystation", "an outpost", "an anomaly","a facility")
	locations = list(
		new /datum/lore/location("The Stack in Altair", list(ATC_TRANS, ATC_MED, ATC_DEF)),
		new /datum/lore/location("Becquerel Station in Altair", list(ATC_TYPICAL))
		)

/datum/lore/system/altair/New()
	space_destinations -= list("a dockyard", "a sattelite", "a spaceport", "a habitat") // altair kind of sucks
	..()

//SolGov minor systems
//limiting to systems that are at least, like, kind of described -- stuff like Ganesha and Stove which just have names and map points aren't making it until someone writes them up

/datum/lore/system/jahans_post
	name = "Jahan's Post"
	desc = "Home to the biggest SCG observation post and an enormous Fleet base. Huge positronic population."
	locations = list(
		new /datum/lore/location("a weapons platform in Jahan's Post", list(ATC_INDU, ATC_FREIGHT, ATC_TRANS)),
		new /datum/lore/location("a dreadnought in Jahan's Post", list(ATC_MED, ATC_INDU, ATC_TRANS, ATC_FREIGHT)), // no sense sending defense assets to a warship at dock
		new /datum/lore/location("a battlecruiser in Jahan's Post", list(ATC_MED, ATC_INDU, ATC_TRANS, ATC_FREIGHT)),
		new /datum/lore/location("a Fleet construction site in Jahan's Post", list(ATC_MED, ATC_INDU, ATC_TRANS, ATC_FREIGHT)),
		new /datum/lore/location("an observatory in Jahan's Post", list(ATC_MED, ATC_INDU, ATC_TRANS, ATC_FREIGHT, ATC_SCI)),
		new /datum/lore/location("a classified location in Jahan's Post", list(ATC_TYPICAL)),
		new /datum/lore/location("a First Contact derelict in Jahan's Post", list(ATC_SALVAGE))
		)
/datum/lore/system/oasis
	name = "Oasis"
	desc = "A resort system controlled by Gilthari Industries and catering to Skrellian clientele. Part of the GCAB with Vir and Gavel. Famous for hate crimes against the Unathi."
	planets = list("Mandrake")
	locations = list(
		new /datum/lore/location("a vista on Mandrake, Oasis", list(ATC_LUX)),
		new /datum/lore/location("a resort on Mandrake, Oasis", list(ATC_LUX, ATC_TRANS, ATC_FREIGHT, ATC_MED)),
		new /datum/lore/location("Gilthari Casino in orbit around Mandrake, Oasis", list(ATC_LUX, ATC_TRANS)),
		new /datum/lore/location("a Golden Crescent Alliance base in Oasis", list(ATC_TYPICAL)),
		new /datum/lore/location("Colony Ardent, Oasis", list(ATC_TYPICAL, ATC_DIPLO))
		)

/datum/lore/system/saint_columbia
	name = "Saint Columbia"
	desc = "Famous for constant attempted secessions, most recently as part of the Almach Crisis. Currently home to an enormous fleet base and a government that is totally not a junta."
	locations = list( //transparently this is going to be pretty much identical to the Jahan's Post list with Almach-specific stuff afterwards
		new /datum/lore/location("the Iserlohn platform in Saint Columbia", list(ATC_INDU, ATC_FREIGHT, ATC_TRANS)),
		new /datum/lore/location("a dreadnought in Saint Columbia", list(ATC_MED, ATC_INDU, ATC_TRANS, ATC_FREIGHT)),
		new /datum/lore/location("a battlecruiser in Saint Columbia", list(ATC_MED, ATC_INDU, ATC_TRANS, ATC_FREIGHT)),
		new /datum/lore/location("a Fleet construction site in Saint Columbia", list(ATC_MED, ATC_INDU, ATC_TRANS, ATC_FREIGHT)),
		new /datum/lore/location("a demonstration in Saint Columbia", list(ATC_DEF, ATC_MED)), // woof
		new /datum/lore/location("Barrueco habitation dome, Saint Columbia", list(ATC_TYPICAL)), //ancient, ancient ic-news lore
		new /datum/lore/location("a classified location in Saint Columbia", list(ATC_TYPICAL)),
		new /datum/lore/location("a caravan in Saint Columbia", list(ATC_TYPICAL)),
		new /datum/lore/location("Almach War wreckage in Saint Columbia", list(ATC_SALVAGE))
		)

/datum/lore/system/raphael
	name = "Raphael"
	desc = "Positronic voter farms in the Crypt."
	locations = list( //discord indicates they had some Troubles during the incursion but IDK anything fun to give them as a result
		new /datum/lore/location("Yod habitation complex, Raphael", list(ATC_ALL_CIV)),
		new /datum/lore/location("He habitation complex, Raphael", list(ATC_ALL_CIV)),
		new /datum/lore/location("Waw habitation complex, Raphael", list(ATC_ALL_CIV))
		)

/datum/lore/system/love
	name = "Love"
	desc = "Government is basically owned by a bunch of triads. Wellfare's really good though. Home to the ZMR."
	planets = list("the planet") // ...ok. so. wiki indicates Love has a habitable world. there is no sense at all what it is called. this will generate locations in the form of "a dome on the planet in Love", which is bizzarely circumspect but basically fine. the alternative is giving them only space sites until someone names the planet.
	locations = list(
		new /datum/lore/location("a 'facility' in Love", list(ATC_ALL_CIV)), //i find this funny but you can nyx it if you want
		new /datum/lore/location("a pharmacy in Love", list(ATC_ALL_CIV)), // this is probably the more serious version of the above
		new /datum/lore/location("an independent mecenary outpost in Love", list(ATC_TYPICAL)),
		new /datum/lore/location("Colony Daring in Love", list(ATC_TYPICAL, ATC_DIPLO))
		)

/datum/lore/system/terminus
	name = "Terminus Station"
	desc = "A deep space outpost. Major academic institution, inventor of the Terminus language, kind of racist." //super super super needs an Incursion pass lol
	autogenerate_destinations = FALSE //its just one really big station
	locations = list(
		new /datum/lore/location("Terminus Station", list(ATC_ALL_CIV)),
		new /datum/lore/location("the Stream Terminus", list(ATC_SCI)),
		new /datum/lore/location("a caravan gathering around Terminus Station", list(ATC_TYPICAL, ATC_SCI)),
		new /datum/lore/location("an academy on Terminus Station", list(ATC_SCI)),
		new /datum/lore/location("an observatory on Terminus Station", list(ATC_SCI))
		)

//these are the minimally-detailed not-on-the-wiki systems i could find enough discord / code / timeline lore on to be worth including
//might comment these out if you want though I think Gavel has enough stuff to be worth including (and also like written up)
/datum/lore/system/gavel
	name = "Gavel"
	desc = "Formerly an independent seccessionist nation during the Golden Hour, Gavel is now known mostly for being invaded and kind of wrecked by Almachi forces during the Almach War. Ironic. Part of the GCAB with Vir and Oasis."
	planets = list("New Xanadu")
	locations = list(
		new /datum/lore/location("the NLS Aquarius in Gavel", list(ATC_TYPICAL)),
		new /datum/lore/location("a Grayson Manufactories plant in Gavel", list(ATC_TYPICAL)),
		new /datum/lore/location("an Almach War derelict in Gavel", list(ATC_SALVAGE)),
		new /datum/lore/location("the old Boiling Point stronghold in Gavel", list(ATC_SCI, ATC_LUX, ATC_DEF)),
		new /datum/lore/location("Requiem in Gavel", list(ATC_SCI, ATC_LUX)),
		new /datum/lore/location("a Fleet base in Gavel", list(ATC_TRANS, ATC_INDU, ATC_FREIGHT)),
		new /datum/lore/location("a Golden Crescent Alliance base in Gavel", list(ATC_TYPICAL)),
		new /datum/lore/location("Colony Itinerant in Gavel", list(ATC_MED, ATC_TRANS, ATC_FREIGHT, ATC_INDU, ATC_DIPLO))
		)
/datum/lore/system/new_ohio
	name = "New Ohio"
	desc = "Not even being well-placed as the only Sagitarius Heights system to have avoided becoming part of the Five Arrows could have prevented this system from succumbing to the curse of its namesake and becoming the most profoundly boring place anyone has ever seen."
	locations = list(
		new /datum/lore/location("Colony Intrepid in New Ohio", list(ATC_MED, ATC_TRANS, ATC_FREIGHT, ATC_INDU, ATC_DIPLO)),
		new /datum/lore/location("Toledo in New Ohio", list(ATC_ALL_CIV)),
		new /datum/lore/location("a Fleet base in New Ohio", list(ATC_TRANS, ATC_INDU, ATC_FREIGHT))
		)

/datum/lore/system/abels_rest
	name = "Abel's Rest"
	desc = "The Hegemony invaded and occupied this system in 2508 and somehow has resisted all human efforts to detail it further"
	locations = list(
		new /datum/lore/location("a Fleet base in Abel's Rest", list(ATC_TRANS, ATC_INDU, ATC_FREIGHT)),
		new /datum/lore/location("an unathi exclave in Abel's Rest", list(ATC_TYPICAL, ATC_DIPLO)),
		new /datum/lore/location("a First Contact derelict in Abel's Rest", list(ATC_SALVAGE))
		)

/datum/lore/system/zhu_que
	name = "Zhu Que"
	desc = "It's in the Inner Bowl and, likewise, has resisted all efforts to detail it further."
	planets = list("Jade")
	locations = list(
		new /datum/lore/location("Urgia in Zhu Que", list(ATC_ALL_CIV)), //ancient notes
		new /datum/lore/location("a Ward-Takahashi plant in Zhu Que", list(ATC_TYPICAL))
		)

/datum/lore/system/zhu_que/New()
	planetary_destinations -= "a dome" //Jade is fully habitable
	..()

//Almach Protectorate
/datum/lore/system/relan
	name = "Relan"
	desc = "The first colonized system in the Almach Rim and defacto leader of the floudering Protectorate. Politically divided between Taron, the system's main planet, and Relan, its spacebound population"
	planets = list("Taron")
	locations = list(
		new /datum/lore/location("Maruya in Relan", list(ATC_INDU)),
		new /datum/lore/location("New Dayton on Taron, Relan", list(ATC_ALL_CIV)),
		new /datum/lore/location("New Garissa on Taron, Relan", list(ATC_TYPICAL)),
		new /datum/lore/location("Perez Rest on Taron, Relan", list(ATC_TYPICAL)),
		new /datum/lore/location("Parker in Relan", list(ATC_TYPICAL)),
		new /datum/lore/location("Abhayaranya in Relan", list(ATC_TYPICAL)),
		new /datum/lore/location("Carter Interstellar Spaceport, Relan", list(ATC_ALL_CIV, ATC_DIPLO)),
		new /datum/lore/location("a pirate base in Relan", list(ATC_DEF)),
		new /datum/lore/location("a Protectorate laboratory in Relan", list(ATC_SCI)),
		new /datum/lore/location("a Kaleidoscope Cosmetics office in Relan", list(ATC_TRANS, ATC_SCI)),
		new /datum/lore/location("an Almach War derelict in Relan", list(ATC_SALVAGE))
		)

/datum/lore/system/relan/New()
	locations += list(
		new /datum/lore/location("[pick("Fu Xi", "Nuwa", "Shennong")], Xia subsystem, Relan", list(ATC_TYPICAL)), //identically undetailed sattelites get compressed
		new /datum/lore/location("[pick("Ubaid", "Badari", "Harappan", "Olmec", "Caral")], Zegev subsystem, Relan", list(ATC_TYPICAL))
		)
	..()

/datum/lore/system/vounna
	name = "Vounna"
	desc = "Home system of the Prometheans and member of the Protectorate."
	planets = list("Aetolus")
	locations = list(
		new /datum/lore/location("the Spear of Agrafa in Vounna", list(ATC_TYPICAL)),
		new /datum/lore/location("the Prometheus in Vounna", list(ATC_TYPICAL, ATC_DIPLO)),
		new /datum/lore/location("the remains of the SGWP Delilah in Vounna", list(ATC_SALVAGE)),
		new /datum/lore/location("the Sisyphus in Vounna", list(ATC_TYPICAL))
		)

/datum/lore/system/exalts_light
	name = "Exalt's Light"
	desc = "But everyone just calls it after its planet. A theocratic technocratic autocracy run by Angessa Martei, it lead the push for Almachi independence and has remained recalcitrant ever since."
	planets = list("Angessa's Pearl")
	locations = list(
		new /datum/lore/location("Skylight on Angessa's Pearl", list(ATC_ALL_CIV, ATC_DIPLO)),
		new /datum/lore/location("Melt on Angessa's Pearl", list(ATC_TRANS, ATC_FREIGHT)), // melt doesn't get emergency responders
		new /datum/lore/location("Angessa's Grave on Angessa's Pearl", list(ATC_TYPICAL, ATC_SCI, ATC_DIPLO)),
		new /datum/lore/location("Tsunami on Angessa's Pearl", list(ATC_ALL_CIV, ATC_DIPLO)),
		new /datum/lore/location("a demonstration on Angessa's Pearl", list(ATC_DEF, ATC_MED)),
		new /datum/lore/location("a Far Kingdoms wreck in Exalt's Light", list(ATC_SALVAGE, ATC_SCI))
		)

//Five Arrows
//might need lore ppl to weigh in here

/datum/lore/system/new_seoul
	name = "New Seoul"
	desc = "The capital system of Five Arrows. Historically wealthy."
	locations = list(
		new /datum/lore/location("the Five Arrows capital in New Seoul", list(ATC_ALL_CIV, ATC_DIPLO)),
		new /datum/lore/location("NSAIST main campus in New Seoul", list(ATC_SCI))
		)

/datum/lore/system/sidhe
	name = "Sidhe"
	desc = "A university and mining town in the Heights, decimated by the Incursion and subsequent Ue'Katish invasions. An ongoing refugee crisis."
	planets = list("Abhartach")
	locations = list(
		new /datum/lore/location("Daoine Institute in Sidhe", list(ATC_TYPICAL, ATC_SCI)),
		new /datum/lore/location("Sidhe Alsace Fleet Base", list(ATC_TYPICAL)), //it's not really a permenant installation so def and med missions there make sense
		new /datum/lore/location("Qux'Xinu on Abhartach, Sidhe", list(ATC_ALL_CIV, ATC_DIPLO)),
		new /datum/lore/location("Colony Impossible in Sidhe", list(ATC_TYPICAL)),
		new /datum/lore/location("the remains of the Colony Possible in Sidhe", list(ATC_SALVAGE)),
		new /datum/lore/location("the School of Tachyon Physics in Sidhe", list(ATC_DEF, ATC_SCI)),
		new /datum/lore/location("the XIS Hawthorn in Sidhe", list(ATC_FREIGHT, ATC_TRANS, ATC_DEF)),
		new /datum/lore/location("Xe'xi in Sidhe", list(ATC_TYPICAL))
		)

/datum/lore/system/kauqxum
	name = "Kauq'xum"
	desc = "The Skrellian monarchies closest to Sol. Joined the Five Arrows for mutual defense."

/datum/lore/system/mahimahi
	name = "Mahi-Mahi"
	desc = "Primarily an organic agricultural world, the planet is divided into two distinct economic and cultural sectors."
	planets = list("the planet") //its the same dumb thing as Love

//human independents
/datum/lore/system/natuna
	name = "Natuna Barisal" //we have unicode support but i think radio might still shit itself
	desc = "Seceeded from SolGov over all the racism and casteism. Now it's home to pirates and also got invaded by the Hegemony"
	planets = list("Natuna Barisal c") //its this or 'the planet' or 'natuna barisal, natuna barisal'-- the planet and the system share a name
	locations = list(
		new /datum/lore/location("Dhana in Natuna Barisal", list(ATC_TYPICAL)),
		new /datum/lore/location("a human settlement on Natuna Barisal c", list(ATC_TYPICAL, ATC_DIPLO)),
		new /datum/lore/location("an Ue-Katish settlement on Natuna Barisal c", list(ATC_TYPICAL, ATC_DIPLO)),
		new /datum/lore/location("an abandoned Hegemony outpost on Natuna Barisal c", list(ATC_SALVAGE, ATC_SCI)),
		new /datum/lore/location("a Ue-Katish trade ship in Natuna Barisal", list(ATC_TYPICAL, ATC_DIPLO)), //"trade ship"
		new /datum/lore/location("an orbital dockyard in Natuna Barisal", list(ATC_TYPICAL)), // "dockyard"
		new /datum/lore/location("a survey site on Natuna Barisal c", list(ATC_SCI))
		)
/datum/lore/system/natuna/New()
	planetary_destinations -= list("a colony", "a city")
	planetary_destinations += "a settlement" //this is the language used on the natuna page and i think that makes for fun regional flavor
	..()


/datum/lore/system/phact
	name = "Phact"
	desc = "They built a replica of Edo Castle in a dome. That's really all there is to say on the matter."
	planets = list("New Kyoto", "Hokkaido", "Ryukyu")
	locations = list(
		new /datum/lore/location("the Imperial Palace in New Kyoto, Phact", list(ATC_LUX, ATC_DIPLO))
		)

/datum/lore/system/casinis_reach
	name = "Casini's Reach"
	desc = "Anarchists who have managed to frame-perfect parry every terrible thing to have happened to humanity in the last 100 years."
	planets = list("Santiago, Pontes subsystem", "Cotopaxi, Pontes subsystem") //theyre not planets but i think this will work fine
	locations = list(
		new /datum/lore/location("Rey Pedro, Pontes subsystem, Casini's Reach", list(ATC_TYPICAL)),
		new /datum/lore/location("Santa Maria, Pontes subystem, Casini's Reach", list(ATC_TYPICAL)),
		new /datum/lore/location("Aconcagua, Pontes subsystem, Casini's Reach", list(ATC_TYPICAL)),
		new /datum/lore/location("Campinas, Pontes subsystem, Casini's Reach", list(ATC_TYPICAL)),
		new /datum/lore/location("a commune in the Diego Belt, Casini's Reach", list(ATC_TYPICAL)),
		new /datum/lore/location("a large commune on Santiago, Pontes subsystem, Casini's Reach", list(ATC_ALL_CIV, ATC_DIPLO)), //kinda kludgy but that lets ppl run diplomatic missions here
		new /datum/lore/location("an abandoned mineshaft on Santa Maria, Pontes subsystem, Casini's Reach", list(ATC_MED, ATC_SALVAGE)),
		new /datum/lore/location("the Unbound colony on Santa Maria, Pontes subsystem, Casini's Reach", list(ATC_TYPICAL))
		)

/datum/lore/system/casinis_reach/New()
	planetary_destinations -= list("a colony", "a city")
	planetary_destinations += "a commune" //likewise, this is the language used on the casini's reach page
	..()

/datum/lore/system/eutopia
	name = "Eutopia" //the system is technically called 'Smith' but like. nobody calls it that.
	desc = "It's Eutopia baybeee! Slavery is legal! Ancaps will use their power transmission infrastructure to shoot you if you try to violate the NAP by taking them away! Casinos!"
	locations = list(
		new /datum/lore/location("an automated mine on Friedman, Eutopia", list(ATC_FREIGHT, ATC_DEF, ATC_INDU)),
		new /datum/lore/location("a mining complex on Rand, Eutopia", list(ATC_TYPICAL)),
		new /datum/lore/location("a farm on Malthus, Ricardo subsystem, Eutopia", list(ATC_TYPICAL)),
		new /datum/lore/location("a plastics plant on Malthus, Ricardo subsystem, Eutopia", list(ATC_TYPICAL)),
		new /datum/lore/location("The Halo, Eutopia", list(ATC_INDU, ATC_FREIGHT)),
		new /datum/lore/location("Kroptkin, Eutopia", list(ATC_TYPICAL, ATC_LUX)), //rich people are weird
		new /datum/lore/location("a casino in Eutopia", list(ATC_TYPICAL, ATC_LUX)),
		new /datum/lore/location("a resort in Eutopia", list(ATC_TYPICAL, ATC_LUX)),
		new /datum/lore/location("a five-star restaurant in Eutopia", list(ATC_TYPICAL)),
		new /datum/lore/location("a financial institute in Eutopia", list(ATC_TYPICAL)),
		new /datum/lore/location("an auction in Eutopia", list(ATC_TRANS, ATC_MED, ATC_DEF)) //eat the rich
		)

/datum/lore/system/neon_light
	name = "Neon Light"
	desc = "An independent black-market trade ship run by a series of matriarchies. Used to be in Almach. The person responsible for that decision is now a corpse!"
	autogenerate_destinations = FALSE // it's just one ship
	locations = list(
		new /datum/lore/location("the Neon Light", list(ATC_TYPICAL, ATC_LUX, ATC_DIPLO)) //it's just one ship! too much grandularity would be weird here!
		)

// nobody should be going to shelf or vystholm so we're skipping them for now

//Pearlshield Coalition
//Will probably want more details from the Catlord
//and lorestaff general since theyre like half human now

/datum/lore/system/rarkajar
	name = "Rarkajar"
	desc = "The home system of the Tajaran race."
	planets = list("Meralar")
	locations = list(
		new /datum/lore/location("a helium-3 extractor on Keoalar, Rarkajar", list(ATC_TYPICAL)),
		new /datum/lore/location("a geological survey site on Aipira, Rarkajar", list(ATC_TYPICAL, ATC_SCI)),
		new /datum/lore/location("the SolGov embassy on Meralar, Rarkajar", list(ATC_DIPLO, ATC_TRANS)),
		new /datum/lore/location("Nalyar on Meralar, Rarkajar", list(ATC_ALL_CIV)),
		new /datum/lore/location("Jormitar on Meralar, Rarkajar", list(ATC_ALL_CIV)),
		new /datum/lore/location("Mi'dynh Al'Manq on Meralar, Rarkajar", list(ATC_ALL_CIV))
		)

/datum/lore/system/rarkajar/New()
	planetary_destinations -= list("a dome", "a colony") //its the core it doesn't have colonies
	planetary_destinations += "a town"
	..()

/datum/lore/system/arrathiir
	name = "Arrathiir"
	desc = "The first exo-Rarkajaran Tajaran colony"
	planets = list("Alar-Selna")

/datum/lore/system/mesomori
	name = "Mesomori"
	desc = "The second exo-Rarkajaran Tajaran colony. Technically not even part of the PCA but like. Come on."

//humans aren't generally allowed to go to uueoa-esa or Vengeful Father so we're skipping those
//Skrell stuff

/datum/lore/system/qerrvalis
	name = "Qerr'Valis"
	desc = "The home system of the Skrell, and some less important aliens."
	autogenerate_destinations = FALSE //qerrvalis is a truly stupidly long distance away so a random medical mission to a minor colony isn't going to happen
	locations = list( //teshari who?
		new /datum/lore/location("a historical site in Qarr'kloa, Qerr'balak, Qerr'Valis", list(ATC_LUX, ATC_TRANS)),
		new /datum/lore/location("a historical site in Mi'qoxi, Qerr'balak, Qerr'Valis", list(ATC_LUX, ATC_TRANS)),
		new /datum/lore/location("a historical site in Kal'lo, Qerr'balak, Qerr'Valis", list(ATC_LUX, ATC_TRANS)),
		new /datum/lore/location("an archeological dig in Qarr'kloa, Qerr'balak, Qerr'Valis", list(ATC_TRANS, ATC_SCI)),
		new /datum/lore/location("a bulk phoron distibutor in Mo'glar, Qerr'balak, Qerr'Valis", list(ATC_FREIGHT)),
		new /datum/lore/location("the Academy on Gli'morr, Qerr'balak, Qerr'Valis", list(ATC_SCI, ATC_TRANS)),
		new /datum/lore/location("a SolGov embassy on Qerr'balak, Qerr'Valis", list(ATC_DIPLO))
		)

//skipping Ue-Orsi unless I hear that they have returned to being a place you could go

//weird shit
/datum/lore/system/isavaus_gamble
	name = "Isavau's Gamble" // pleas do not give this system to anyone who does not have very serious reasons to be here
	desc = "Destroyed completely by the Skathari Incursion. Was previously a totally failed state consisting of one large spaceport, which was very very briefly part of a backroads route from Almach to Sol."
	autogenerate_destinations = FALSE //its just wreckage
	locations = list(
		new /datum/lore/location("an Incursion site in Isavau's Gamble", list(ATC_DEF, ATC_MED)),
		new /datum/lore/location("Isavau International Spaceport, Isavau's Gamble", list(ATC_SALVAGE)),
		new /datum/lore/location("the Brazen Bull escort fleet in Isavau's Gamble", list(ATC_SALVAGE)), //wiki indicates salvage missions here are common but illegal so they PROBABLY wouldn't be declared on atc. i think its more interesting to do this and imagine tracon either doesn't know, doesn't care, or has been presented legitimate-seeming paperwork
		new /datum/lore/location("the wreckage of the XIV Sri Chamarajendra in Isavau's Gamble", list(ATC_SALVAGE)),
		new /datum/lore/location("the last known position of the IIV Reimarus in Isavau's Gamble", list(ATC_SALVAGE)),
		new /datum/lore/location("debris in Isavau's Gamble", list(ATC_SALVAGE))
		)

/datum/lore/system/whythe
	name = "Whythe" //SUPER dont give this system to anyone who doesn't have reasons to be here
	desc = "Atom bombs and dying stars. Whythe was home to the Wythe Superweapon, the firing of which caused the Far Kingdoms invasion and the Skathari Incursion. Woops. Currently decimated by the Incursion and considered uninhabitable."
	autogenerate_destinations = FALSE
	locations = list(
		new /datum/lore/location("a skathari incursion in Whythe", list(ATC_DEF)),
		new /datum/lore/location("the remains of Vigilance Station in Whythe", list(ATC_SALVAGE, ATC_SCI)),
		new /datum/lore/location("a classified site in Whythe", list(ATC_DEF, ATC_SALVAGE, ATC_SCI))
		)

/datum/lore/system/new_cairo
	name = "New Cairo"
	desc = "Home to the only known pre-FTL species in contact with the broader galactic community."
	autogenerate_destinations = FALSE
	locations = list(
		new /datum/lore/location("the Embassy to the Khepri People in New Cairo orbit", list(ATC_DIPLO)) //there is nothing to do here but talk to the bugs
		)