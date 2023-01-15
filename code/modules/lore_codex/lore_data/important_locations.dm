<<<<<<< HEAD
/datum/lore/codex/category/important_locations
	name = "Important Locations"
	data = "There are several locations of interest that you may come across when visiting the system Vir."
	children = list(
		/datum/lore/codex/page/vir,
		/datum/lore/codex/page/radiance_energy_chain,
		/datum/lore/codex/page/firnir,
		/datum/lore/codex/page/tyr,
		/datum/lore/codex/page/sif,
		/datum/lore/codex/page/vir_interstellar_spaceport,
		/datum/lore/codex/page/southern_cross,
		/datum/lore/codex/page/magni,
		/datum/lore/codex/page/kara,
		/datum/lore/codex/page/northern_star,
		/datum/lore/codex/page/rota
		)

/datum/lore/codex/page/virgo_erigone/add_content()
	name = "Vir (Star)"
	keywords += list("Vir")
	data = "Vir is an A-type main sequence star with 81% more mass than Sol (the humans' home star), and almost nine times as bright.  It \
	has a white glow, and a diameter that is about 34% larger than Sol. It has six major planets in its orbit.\
	<br><br>\
	Vir is mainly administered on [quick_link("Sif")] by the [quick_link("Sif Governmental Authority")], as Sif \
	was the first planet to be colonized, however VGA lays claim to all planets orbiting Vir.  The planets \
	are named after figures in ancient human mythology (Norse), due to the original surveyor for the system deciding to do so. \
	Some installations carry on this tradition."

/datum/lore/codex/page/radiance_energy_chain/add_content()
	name = "Radiance Energy Chain (Artificial Satellites)"
	keywords += list("Radiance Energy Chain")
	data = "A sparse government-owned chain of automated stations exists between Firnir and the star itself. The idea is based on \
	an ancient design that was pioneered at Sol. The stations are heavily shielded from the stellar radiation, and feature massive \
	arrays of photo-voltaic panels. Each station harvests energy from Vir using the solar panels, and sends it to other areas of \
	the system by beaming the energy to several relay stations farther away from the star, typically with a large laser.\
	<br><br>\
	These stations are generally devoid of life, instead, they are operated mainly by [quick_link("drones")], with maintenance performed \
	by [quick_link("positronic")] equipped units in shielded chassis, or very brave humans in voidsuits that protect from extreme heat, and radiation. There are \
	currently 19 stations in operation."

/datum/lore/codex/page/firnir/add_content()
	name = "Firnir (Terrestrial Planet)"
	keywords += list("Firnir")
	data = "Firnir is the first planet of Vir, tidally locked to it, and having temperatures in excess of 570 degrees \
	kelvin (299캜) on the day side has caused this planet to go mostly ignored."

/datum/lore/codex/page/tyr/add_content()
	name = "Tyr (Terrestrial Planet)"
	keywords += list("Tyr")
	data = "The second closest planet to [quick_link("Vir")], this planet has a high concentration of minerals inside its crust, as well as active volcanism and plate tectonics.  \
	The temperature on the surface can reach up to 405 degrees kelvin (132캜), which has deterred most people from the planet, except for two [quick_link("TSC", "TSCs")], \
	Greyson Manufactories and [quick_link("Xion Manufacturing Group")].  In orbit, the two companies each have a space station, used to coordinate and \
	control their stations on the surface without having to suffer the intense heat.  Xion's station also doubles as a control and oversight facility for their \
	[quick_link("drones","autonomous mining drones")].\
	<br><br>\
	Remnants of both Greyson and Xion's mining operations dot the surface, as well as ruins of mining \
	outposts build by an unknown alien civilization, which researchers have noted it appears to be similar to ruins found inside the rings of [quick_link("Kara")] \
	and on [quick_link("Sif")] itself.  Below the surface of Tyr are many natural cave systems, dangerous and easy to get lost inside, which both companies make heavy \
	use of.  A noted rivalry exists between the two mining giants, as well as with smaller groups more interested in the xenoarcheological value of the alien ruins.\
	<br><br>\
	The very high temperatures, dangerous (sometimes magma-filled) caves, and the only presence of civilization being mining operations has made tourism \
	for Tyr mostly non-existent, with the exception of explorers who specifically seek out hellish landscapes, which are plentiful with all the ruins, \
	volcanoes, twisting caves, and general lawlessness.  The occasional remains of previous explorers near certain hotspots somehow does not deter them."

/datum/lore/codex/page/sif/add_content()
	name = "Sif (Terrestrial Planet)"
	keywords += list("Sif")
	data = "Sif is a terrestrial planet and third closest planet to Vir. It possesses oceans, a breathable atmosphere, \
	a magnetic field, weather, and acceptable gravity. It is currently the capital planet of Vir. Its center of government is the \
	equatorial city and site of the first settlement, New Reykjavik, which houses the [quick_link("Sif Governmental Authority")].\
	<br><br>\
	Sif has many desirable traits which made it the first planet to be colonized in Vir, however it also has various quirks which \
	may disorient humans used to conditions on planet Earth.  Atmospheric pressure is lower than 'normal', which may cause difficulty \
	breathing if you are used to climate controlled artifical habitats or higher pressure planets.  The gravity is also slightly lower, at \
	only 90% the strength of planet Earth's gravity. You may need to keep two clocks if you plan to visit \
	or live on Sif, as the planet takes over 32 hours to complete one day.  A Sif year also takes just under five Earth years."

/datum/lore/codex/page/vir_interstellar_spaceport/add_content()
	name = "Vir Interstellar Spaceport (Artificial Satellite)"
	keywords += list("Vir Interstellar Spaceport")
	data = "The Vir Interstellar Spaceport is a large facility in orbit of the planet [quick_link("Sif")] which handles the loading and \
	unloading, refuelling, and general maintenance of large spacecraft. The main structure is owned by the \
	[quick_link("Sif Governmental Authority")], but individual offices, docking/loading bays, and warehouses are often leased to individuals \
	or organisations.  The position of the spaceport allows it to function not only as a key node for transport inside the Vir \
	system, especially to and from the planet Sif, but also as a key stopping point interstellar craft travelling via Vir which need refuelling. \
	<br><br>\
	The station itself is mostly designed around its logistical and commercial needs, and although other strategically-placed \
	nearby facilities owned by a mixture of corporations and entities may possess habitation space, the port itself is not \
	designed to be a living habitat - its proximity to the surface of Sif makes transport of people and materials to and from \
	the facility and the planet via shuttle extremely cost-efficient."

/datum/lore/codex/page/southern_cross/add_content()
	name = "Southern Cross (Artificial Satellite)"
	keywords += list("Southern Cross", "NLS Southern Cross")
	data = "The Southern Cross is a telecommunications and supply hub for [quick_link("NanoTrasen")], named after it's companion satellite, the \
	[quick_link("Northern Star")].  It acts as a logistics hub for the smaller installations NanoTrasen has in Sif orbit and on the surface."

/datum/lore/codex/page/magni/add_content()
	name = "Magni (Terrestrial Planet)"
	keywords += list("Magni")
	data = "Outside of the habitable zone, the barren world Magni is generally at 202 kelvin (-71캜)."

/datum/lore/codex/page/kara/add_content()
	name = "Kara (Gas Giant)"
	keywords += list("Kara")
	data = "A gas giant, with a large number of moons. Captured asteroids, to be specific. Many of the asteroids are theorized \
	to be the remnants of a much larger moon that was ripped apart by Kara, long ago. Curerntly, a large number of these \
	asteroids are being used by many different businesses, and some governmental infrastructure has been built. The most prominent \
	asteroid installation is the [quick_link("Northern Star", "NCS Northern Star")], a general purpose colony owned and operated by \
	[quick_link("NanoTrasen")]. The mid-atmospheric temperature of the gas giant averages to around 150 kelvin (-108캜)."

/datum/lore/codex/page/northern_star/add_content()
	name = "Northern Star (Artificial Satellite)"
	keywords += list("Northern Star", "NCS Northern Star")
	data = "One of the most prominent installations in the [quick_link("Kara")] subsystem, the Northern Star is owned \
	and operated by [quick_link("NanoTrasen")].  It was originally built to service the various mining operations \
	occurring within Kara's ring, however it has grown into what it is today due to what was discovered inside \
	the interior of the rock.  Both phoron and alien artifacts were found inside, catapulting the asteroid outpost \
	into the main attraction inside the subsystem.\
	<br><br>\
	Today it houses a population of civilians, whom work to maintain \
	the colony and support the local mining industry.  The colony also has managed to achieve a degree of \
	self-sufficiency, and possesses many amenities and features that most other asteroid bases in the \
	subsystem lack."

/datum/lore/codex/page/rota/add_content()
	name = "Rota (Gas Giant)"
	keywords += list("Rota")
	data = "An ice giant, with a beautiful ring system circling it. The average temperature for it is 165 kelvin (-157캜)."
=======
/datum/lore/codex/category/important_locations
	name = "Important Locations"
	data = "There are several locations of interest that you may come across when visiting the system Vir."
	children = list(
		/datum/lore/codex/page/vir,
		/datum/lore/codex/page/radiance_energy_chain,
		/datum/lore/codex/page/firnir,
		/datum/lore/codex/page/tyr,
		/datum/lore/codex/page/sif,
		/datum/lore/codex/page/vir_interstellar_spaceport,
		/datum/lore/codex/page/southern_cross,
		/datum/lore/codex/page/magni,
		/datum/lore/codex/page/kara,
		/datum/lore/codex/page/northern_star,
		/datum/lore/codex/page/rota
		)

/datum/lore/codex/page/vir/add_content()
	name = "Vir (Star)"
	keywords += list("Vir")
	data = "Vir is an A-type main sequence star with 81% more mass than Sol (the humans' home star), and almost nine times as bright.  It \
	has a white glow, and a diameter that is about 34% larger than Sol. It has six major planets in its orbit.\
	<br><br>\
	Vir is mainly administered on [quick_link("Sif")] by the [quick_link("Vir Governmental Authority")], as Sif \
	was the first planet to be colonized, however VGA lays claim to all planets orbiting Vir.  The planets \
	are named after figures in ancient human mythology (Norse), due to the original surveyor for the system deciding to do so. \
	Some installations carry on this tradition."

/datum/lore/codex/page/radiance_energy_chain/add_content()
	name = "Radiance Energy Chain (Artificial Satellites)"
	keywords += list("Radiance Energy Chain")
	data = "A sparse government-owned chain of automated stations exists between Firnir and the star itself. The idea is based on \
	an ancient design that was pioneered at Sol. The stations are heavily shielded from the stellar radiation, and feature massive \
	arrays of photo-voltaic panels. Each station harvests energy from Vir using the solar panels, and sends it to other areas of \
	the system by beaming the energy to several relay stations farther away from the star, typically with a large laser.\
	<br><br>\
	These stations are generally devoid of life, instead, they are operated mainly by [quick_link("drones")], with maintenance performed \
	by [quick_link("positronic")] equipped units in shielded chassis, or very brave humans in voidsuits that protect from extreme heat, and radiation. There are \
	currently 19 stations in operation."

/datum/lore/codex/page/firnir/add_content()
	name = "Firnir (Terrestrial Planet)"
	keywords += list("Firnir")
	data = "Firnir is the first planet of Vir, tidally locked to it, and having temperatures in excess of 570 degrees \
	kelvin (299째C) on the day side has caused this planet to go mostly ignored."

/datum/lore/codex/page/tyr/add_content()
	name = "Tyr (Terrestrial Planet)"
	keywords += list("Tyr")
	data = "The second closest planet to [quick_link("Vir")], this planet has a high concentration of minerals inside its crust, as well as active volcanism and plate tectonics.  \
	The temperature on the surface can reach up to 405 degrees kelvin (132째C), which has deterred most people from the planet, except for two [quick_link("TSC", "TSCs")], \
	Greyson Manufactories and [quick_link("Xion Manufacturing Group")].  In orbit, the two companies each have a space station, used to coordinate and \
	control their stations on the surface without having to suffer the intense heat.  Xion's station also doubles as a control and oversight facility for their \
	[quick_link("drones","autonomous mining drones")].\
	<br><br>\
	Remnants of both Greyson and Xion's mining operations dot the surface, as well as ruins of mining \
	outposts build by an unknown alien civilization, which researchers have noted it appears to be similar to ruins found inside the rings of [quick_link("Kara")] \
	and on [quick_link("Sif")] itself.  Below the surface of Tyr are many natural cave systems, dangerous and easy to get lost inside, which both companies make heavy \
	use of.  A noted rivalry exists between the two mining giants, as well as with smaller groups more interested in the xenoarcheological value of the alien ruins.\
	<br><br>\
	The very high temperatures, dangerous (sometimes magma-filled) caves, and the only presence of civilization being mining operations has made tourism \
	for Tyr mostly non-existent, with the exception of explorers who specifically seek out hellish landscapes, which are plentiful with all the ruins, \
	volcanoes, twisting caves, and general lawlessness.  The occasional remains of previous explorers near certain hotspots somehow does not deter them."

/datum/lore/codex/page/sif/add_content()
	name = "Sif (Terrestrial Planet)"
	keywords += list("Sif")
	data = "Sif is a terrestrial planet and third closest planet to Vir. It possesses oceans, a breathable atmosphere, \
	a magnetic field, weather, and acceptable gravity. It is currently the capital planet of Vir. Its center of government is the \
	equatorial city and site of the first settlement, New Reykjavik, which houses the [quick_link("Vir Governmental Authority")].\
	<br><br>\
	Sif has many desirable traits which made it the first planet to be colonized in Vir, however it also has various quirks which \
	may disorient humans used to conditions on planet Earth.  Atmospheric pressure is lower than 'normal', which may cause difficulty \
	breathing if you are used to climate controlled artifical habitats or higher pressure planets.  The gravity is also slightly lower, at \
	only 90% the strength of planet Earth's gravity. You may need to keep two clocks if you plan to visit \
	or live on Sif, as the planet takes over 32 hours to complete one day.  A Sif year also takes just under five Earth years."

/datum/lore/codex/page/vir_interstellar_spaceport/add_content()
	name = "Vir Interstellar Spaceport (Artificial Satellite)"
	keywords += list("Vir Interstellar Spaceport")
	data = "The Vir Interstellar Spaceport is a large facility in orbit of the planet [quick_link("Sif")] which handles the loading and \
	unloading, refuelling, and general maintenance of large spacecraft. The main structure is owned by the \
	[quick_link("Vir Governmental Authority")], but individual offices, docking/loading bays, and warehouses are often leased to individuals \
	or organisations.  The position of the spaceport allows it to function not only as a key node for transport inside the Vir \
	system, especially to and from the planet Sif, but also as a key stopping point interstellar craft travelling via Vir which need refuelling. \
	<br><br>\
	The station itself is mostly designed around its logistical and commercial needs, and although other strategically-placed \
	nearby facilities owned by a mixture of corporations and entities may possess habitation space, the port itself is not \
	designed to be a living habitat - its proximity to the surface of Sif makes transport of people and materials to and from \
	the facility and the planet via shuttle extremely cost-efficient."

/datum/lore/codex/page/southern_cross/add_content()
	name = "Southern Cross (Artificial Satellite)"
	keywords += list("Southern Cross", "NLS Southern Cross")
	data = "The Southern Cross is a mostly automated telecommunications and supply hub for [quick_link("NanoTrasen")], named after it's companion satellite, the \
	[quick_link("Northern Star")].  It acts as a logistics hub for the smaller installations NanoTrasen has in Sif orbit and on the surface."

/datum/lore/codex/page/magni/add_content()
	name = "Magni (Terrestrial Planet)"
	keywords += list("Magni")
	data = "Outside of the habitable zone, the barren world Magni is generally at 202 kelvin (-71째C)."

/datum/lore/codex/page/kara/add_content()
	name = "Kara (Gas Giant)"
	keywords += list("Kara")
	data = "A gas giant, with a large number of moons. Captured asteroids, to be specific. Many of the asteroids are theorized \
	to be the remnants of a much larger moon that was ripped apart by Kara, long ago. Curerntly, a large number of these \
	asteroids are being used by many different businesses, and some governmental infrastructure has been built. The most prominent \
	asteroid installation is the [quick_link("Northern Star", "NCS Northern Star")], a general purpose colony owned and operated by \
	[quick_link("NanoTrasen")]. The mid-atmospheric temperature of the gas giant averages to around 150 kelvin (-108째C)."

/datum/lore/codex/page/northern_star/add_content()
	name = "Northern Star (Artificial Satellite)"
	keywords += list("Northern Star", "NCS Northern Star")
	data = "One of the most prominent installations in the [quick_link("Kara")] subsystem, the Northern Star is owned \
	and operated by [quick_link("NanoTrasen")].  It was originally built to service the various mining operations \
	occurring within Kara's ring, however it has grown into what it is today due to what was discovered inside \
	the interior of the rock.  Both phoron and alien artifacts were found inside, catapulting the asteroid outpost \
	into the main attraction inside the subsystem.\
	<br><br>\
	Today it houses a population of civilians, whom work to maintain \
	the colony and support the local mining industry.  The colony also has managed to achieve a degree of \
	self-sufficiency, and possesses many amenities and features that most other asteroid bases in the \
	subsystem lack."

/datum/lore/codex/page/rota/add_content()
	name = "Rota (Gas Giant)"
	keywords += list("Rota")
	data = "An ice giant, with a beautiful ring system circling it. The average temperature for it is 165 kelvin (-157째C)."
>>>>>>> d212ca1a926... Merge pull request #8881 from Cerebulon/no-sga
