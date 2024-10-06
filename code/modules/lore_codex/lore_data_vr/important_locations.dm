/datum/lore/codex/category/important_locations
	name = "Important Locations"
	data = "There are several locations of interest that you may come across when visiting the system Virgo-Erigone."
	children = list(
		/datum/lore/codex/page/virgo_erigone,
		/datum/lore/codex/page/radiance_energy_chain,
		/datum/lore/codex/page/virgo_two,
		/datum/lore/codex/page/virgo_three,
		/datum/lore/codex/page/virgo_three_bee,
		/datum/lore/codex/page/nsb_adephagia,
		/datum/lore/codex/page/virgo_central_command,
		/datum/lore/codex/page/virgo_prime,
		/datum/lore/codex/page/virgo_five,
		/datum/lore/codex/page/outer_worlds
		)

/datum/lore/codex/page/virgo_erigone/add_content()
	name = "Virgo-Erigone (Star System)"
	keywords += list("Virgo-Erigone")
	data = "Virgo-Erigone is a dimming and dying star with a warm yellow/orange glow like that of burning candle. It has eight planets in its orbit.\
	<br><br>\
	Also known as 'Virgo', the system is most notable for the presence of one of only two known [quick_link("Phoron")] gas giants, designated [quick_link("Virgo 3")]. This makes the \
	system a popular location for Phoron research and refining.\
	<br><br>\
	Virgo-Erigone is mainly administered by [quick_link("Virgo-Erigone Governmental Authority","the Virgo-Erigone Governmental Authority")], which is owned by [quick_link("NanoTrasen")],\
	as it resides over 30,000 lightyears away from [quick_link("SolGov")]'s sphere of influence. Despite its isolation, it generally abides by Sol's laws, as NanoTrasen is a human-owned \
	company."

/datum/lore/codex/page/radiance_energy_chain/add_content()
	name = "R.E.C. (Artificial Satellites)"
	keywords += list("Radiance Energy Chain", "R.E.C.")
	data = "A sparse government-owned chain of automated stations exists between [quick_link("Virgo 3")] and the star itself, known as the Radiance Energy Chain. The idea is based on \
	an ancient design that was pioneered at Sol. The stations are heavily shielded from the stellar radiation, and feature massive \
	arrays of photo-voltaic panels. Each station harvests energy from Virgo-Erigone using the solar panels, and sends it to other areas of \
	the system by beaming the energy to several relay stations farther away from the star, typically with a large laser.\
	<br><br>\
	These stations are generally devoid of life, instead, they are operated mainly by [quick_link("drones")], with maintenance performed \
	by [quick_link("positronic")] equipped units in shielded chassis, or very brave humans in voidsuits that protect from extreme heat, and radiation. There are \
	currently 19 stations in operation."

/datum/lore/codex/page/virgo_one/add_content()
	name = "Virgo 1 (Hot-Ice Giant)"
	keywords += list("Virgo 1")
	data = "Virgo 1 is a tidally locked hot ice giant located closest to the star. Temperatures soar and drop between 490�K and 120�K. Winds on the planet often surpass \
	supersonic speeds."

/datum/lore/codex/page/virgo_two/add_content()
	name = "Virgo 2 (Metal-Rich Planet)"
	keywords += list("Virgo 2")
	data = "The second closest planet to [quick_link("Virgo-Erigone")], this planet has a high concentration of minerals inside its crust, as well as active volcanism and plate tectonics.  \
	The temperature on the surface can reach up to 405 degrees kelvin (132�C) due to the relatively high albedo of the surface, which has deterred most people from the planet, except for two [quick_link("TSC", "TSCs")], \
	Greyson Manufactories and [quick_link("Xion Manufacturing Group")]. In orbit, the two companies each have a space station, used to coordinate and \
	control their stations on the surface without having to suffer the intense heat. Xion's station also doubles as a control and oversight facility for their \
	[quick_link("drones","autonomous mining drones")].\
	<br><br>\
	Remnants of both Greyson and Xion's mining operations dot the surface, as well as ruins of mining \
	outposts build by an unknown alien civilization, which researchers have noted it appears to be similar to ruins found inside the rings of [quick_link("Kara")]. \
	Below the surface of Virgo 2 are many natural cave systems, dangerous and easy to get lost inside, which both companies make heavy \
	use of. A noted rivalry exists between the two mining giants, as well as with smaller groups more interested in the xenoarcheological value of the alien ruins.\
	<br><br>\
	The very high temperatures, dangerous (sometimes magma-filled) caves, and the only presence of civilization being mining operations has made tourism \
	for Virgo 2 mostly non-existent, with the exception of explorers who specifically seek out hellish landscapes, which are plentiful with all the ruins, \
	volcanoes, twisting caves, and general lawlessness. The occasional remains of previous explorers near certain hotspots somehow does not deter them."

/datum/lore/codex/page/virgo_three/add_content()
	name = "Virgo 3 (Phoron Giant)"
	keywords += list("Virgo 3")
	data = "Virgo 3 is one of only two gas giants composed primarily of [quick_link("Phoron")] in the known galaxy. This fact has attracted several [quick_link("TSC", "TSCs")] into \
	the system to exploit the resources available here for mining and research. Virgo 3 itself has several moons, though the only noteworthy moon is [quick_link("Virgo-3B")] which \
	has native life and an abundance of phoron deposits, as well as a phoron rich atmosphere. \
	<br><br>\
	The largest TSC to exploit this planet is none other than Phoron research giant [quick_link("NanoTrasen")], having built several stations orbiting the planet \
	for both research and phoron refining purposes."

/datum/lore/codex/page/virgo_three_bee/add_content()
	name = "Virgo-3B (Terrestrial Moon)"
	keywords += list("Virgo-3B")
	data = "Virgo-3B is the only moon of [quick_link("Virgo 3")] with any atmosphere to speak of, composed primarily of [quick_link("Phoron")] and carbon dioxide with trace amounts of nitrogen. \
	The atmosphere appears to have given rise to native life, though originally nothing bigger than small insects in terms of fauna. The flora of the planet is rather sizable, though typically blue in hue \
	due to the atmospheric composition.\
	<br><br>\
	Virgo-3B is tidally locked to Virgo 3, and is currently in the 'cold phase' of Virgo 3's orbit. The 'day' consists of reflected light from the surface of Virgo 3, while the 'night' consists of a total eclipse of \
	Virgo-Erigone by Virgo 3, leaving the planet fairly cold for a terrestrial world.\
	<br><br>\
	The presence of several [quick_link("TSC", "TSCs")] on the surface has introduced new life forms to the planet via bioengineering, and now several 'new' species are commonly sighted per year. \
	Currently, [quick_link("NanoTrasen")] is constructing a 'space elevator' for commercial purposes, as the atmosphere of Virgo-3B is inimical to shuttles, and engines in particular."

/datum/lore/codex/page/virgo_prime/add_content() // Virgo 4 technically.
	name = "Virgo 4 / Virgo-Prime (Terrestrial Planet)"
	keywords += list("Virgo 4","Virgo-Prime")
	data = "Virgo 4, also known as Virgo-Prime, is the fourth planet of Virgo-Eirgone. Although primarily desert, temperatures linger around only 287 kelvin (~14�C). \
	It is the only planet in the system with an environment that supports oxygen-breathing lifeforms. \
	<br><br> \
	While being about the size of Earth, it is home to only about 750,000 known residents, most of whom live \
	in the spaceport colony of Anur. The planet has a very shallow ocean, which is only an average of 1000 meters deep.\
	<br><br> \
	One of the most interesting facts about this planet is that it is the native [quick_link("Zorren")] race, who until recently \
	were a primitive and nomadic species.  Due to the arrival of various [quick_link("TSC", "TSCs")] over the last two decades, \
	the Zorren have benefitted greatly from the introduction of advanced technology into their culture. It is not known how many \
	Zorren occupy the planet, but it is believed that at least two million live scattered across the deserts and mountains, where \
	they subsist off of underground water sources, and hunt for prey."

/datum/lore/codex/page/virgo_five/add_content()
	name = "Virgo 5 (Rocky Ice Planet)"
	keywords += list("Virgo 5")
	data = "Virgo 5 is a cold, inhospitable wasteland contaminated with toxic phoron-based compounds. At temperatures around 213 kelvin (-60�C), \
	it can support only the most hardy of phoron-based life, such as space carp, which are unaffected by the frigid temperatures or deadly \
	atmosphere. Scientists believe this planet was once closer to its host star, but over time was pushed out beyond the habitable zone by \
	other large planets."

/datum/lore/codex/page/outer_worlds/add_content()
	name = "The Outer Worlds"
	keywords += list("The Outer Worlds")
	data = "The last three planets in the system are two small rocky worlds, Virgo 6 and 7, and finally Virgo 8 which is a frozen gas giant \
	whose temperatures reach only 49�K. The planet has several moons, but none of these worlds are of any significance. Virgo 6 and 7, as well \
	as 8's moons have no substantial deposits of any useful minerals, nor do they have an abundance of phoron. They are left largely ignored by \
	the local [quick_link("TSC", "TSCs")], though this also makes them a safe haven for various pirate and smuggler stations."

/datum/lore/codex/page/virgo_central_command/add_content()
	name = "Virgo Central Command (Colony)"
	keywords += list("Virgo Central Command")
	data = span_italics("This page has been ripped out. Odd.")
	/*data = "The Virgo Central Command is a large facility on [quick_link("Virgo-3B")] which handles the loading and \
	unloading, refuelling, and general maintenance of large spacecraft. The main structure is owned by \
	[quick_link("NanoTrasen")], but individual offices, docking/loading bays, and warehouses are often leased to individuals \
	or organisations.  The position of the spaceport allows it to function not only as a key node for transport inside the Virgo-Erigone \
	system, especially to and from the planet Virgo 3, but also as a key stopping point for interstellar craft travelling via Virgo-Erigone which need refuelling. \
	<br><br>\
	The station itself is mostly designed around its logistical and commercial needs, and although other strategically-placed \
	nearby facilities owned by a mixture of corporations and entities may possess habitation space, the port itself is not \
	designed to be a living habitat - its proximity to Virgo 3 makes transport of people and materials to and from \
	the facility and the planet's stations via shuttle extremely cost-efficient."*/ // ToDo: ReDo.

/datum/lore/codex/page/nsb_adephagia/add_content()
	name = "NSB Adephagia (Space Elevator)"
	keywords += list("NSB Adephagia", "Tether")
	data = "Also known as the 'Tether', the NSB Adephagia is one of the most prominent installations in the [quick_link("Virgo-Erigone")] star system. \
	Owned and operated by [quick_link("NanoTrasen")], the facility was built on [quick_link("Virgo-3B")] in 2561 to provide easy access to mining \
	operations on the surface. Both phoron and alien artifacts are often found in the rocks, provoking substantial scientific interest into the moon's \
	largely unknown history.\
	<br><br>\
	Today it houses a population of civilians, whom work to maintain the facility and support the local mining industry. Employees often commute to the \
	installation via an underground transit network that links the facility to a neighboring colony." // ToDo: Add link to CentCom colony.
