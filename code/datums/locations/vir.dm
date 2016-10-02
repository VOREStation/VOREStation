//Vir

/datum/locations/vir
	name = "Vir"
	desc = "Vir is a human system that sits between the inner and outer systems of human-controlled space."

/datum/locations/vir/New(var/creator)
	contents.Add(
		new /datum/locations/firnir(src),
		new /datum/locations/tyr(src),
		new /datum/locations/sif(src),
		new /datum/locations/magni(src),
		new /datum/locations/kara(src),
		new /datum/locations/rota(src)
		)
	..(creator)

/datum/locations/firnir
	name = "Firnir"
	desc = "Tidally locked to Vir and having temperatures in excess of 570 degrees kelvin (299°C) on the day side has caused this planet to go mostly ignored."

/datum/locations/tyr
	name = "Tyr"
	desc = "Second closest planet, with a high concentration of minerals in the crust, but otherwise a typical planet. The surface temperature can reach \
	405 degrees kelvin (132°C), which deter most mining operations, except for one, which has a mining base and a few orbitals established, utilizing \
	specialized equipment, chiefly being autonomous synthetic mining drones, to retrieve precious ore in a rather expensive, but safer way, compared to the \
	pirate haven that is asteroid mining."

/datum/locations/sif
	name = "Sif"
	desc = "Falling within Vir's 'habitable zone', the third planet was the first to be colonized, initially by a large group of colonists owing \
	loyalty to their own employers. Unfortunate events discussed previously had forced the settlement to be abandoned, and then reclaimed. \
	The planet's mean temperature is 286 kelvin (13°C), chilly but habitable."

/datum/locations/magni
	name = "Magni"
	desc = "Outside of the habitable zone, Vir D is generally at 202 kelvin (-71°C)."

/datum/locations/kara
	name = "Kara"
	desc = "A gas giant, with a large number of moons.  Captured asteroids, to be specific.  Many of these asteroids are being used by different companies for \
	various purposes.  The temperature of the gas giant is 150 kelvin (-108°C)"

/datum/locations/kara/New(var/creator)
	contents.Add(
		new /datum/locations/northern_star(src)
		)
	..(creator)

/datum/locations/northern_star //Inception joke here
	name = "Northern Star"
	desc = "The Northern Star is an asteroid colony owned and operated by NanoTrasen, among many other asteroid installations. \
	Originally conceived as 'just another pitstop' for weary asteroid miners, it has grown to become a significant installation in the Kara subsystem."

/datum/locations/northern_star/New(var/creator)
	contents.Add(
		new /datum/locations/northern_star_interior(src)
		)
	..(creator)

/datum/locations/northern_star_interior
	name = "Northern Star Inner Level"
	desc = "The Northern Star contains multiple layers, this one being the inner level, also known as the residentual area.  It contains most of the \
	homes for the Northern Star, as well as acting as the heart of commerece, with many shops and markets near the center."

/datum/locations/rota
	name = "Rota"
	desc = "A Neptune-like ice giant, with a beautiful ring system circling it. It is 165 kelvin (-157°C)."