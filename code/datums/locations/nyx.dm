//Nyx

/datum/locations/nyx
	name = "Nyx"
	desc = "Nyx is most certainly considered an outer system, being on the edge of colonized space.  It's a red dwarf flare star far out in the \
	frontier. There are four planets orbiting it, not including its sub-stellar companion, Erebus."

/datum/locations/nyx/New(var/creator)
	contents.Add(
		new /datum/locations/erebus(src),
		new /datum/locations/moros(src),
		new /datum/locations/brinkburn(src),
		new /datum/locations/haulers_tragedy(src),
		new /datum/locations/void_star(src),
		new /datum/locations/yulcite(src),
		new /datum/locations/emerald_habitation(src),
		new /datum/locations/euthenia(src)
		)
	..(creator)

/datum/locations/erebus
	name = "Erebus"
	desc = "Erebus was regarded for centuries as an uninteresting substellar companion to Nyx, itself a relatively uninteresting red dwarf. \
	Massing at 44.7 times that of Jupiter, Erebus is a T-Class brown dwarf with a surface temperature of 963K, just above the melting point \
	of aluminium. However, the presence of Phoron in and around Erebus has driven much of the activity of the first half of the 26th century \
	in the Nyx system. Orbiting 39.8 AU from Nyx with an eccentricity of 4%, it takes a bit more than 315 standard years for Erebus to orbit Nyx. \
	With over 80 moons with diameters more than 5 kilometers and hundreds smaller than that, Erebus is a hub of mining and corporate warfare. \
	The most notable moon, but not the largest, is Roanake, a dwarf planet in its own right, which orbits with a high enough eccentricity to \
	have significant volcanic activity due to tidal heating."

/datum/locations/erebus/New(var/creator)
	contents.Add(
		new /datum/locations/talons_bull(src),
		new /datum/locations/exodus(src),
		new /datum/locations/crescent(src)
	)
	..(creator)

/datum/locations/talons_bull
	name = "Talon's Bull"
	desc = "A well visited Free Trade Union space station where a large amount of the independent trade outside of the Hauler's Tragedy is done. \
	It is currently stationed on one of the smaller moons that orbits Erebus and has extensive facilities all across the moon's surface."

/datum/locations/exodus
	name = "NSS Exodus"
	desc = "A highly profitable research, mining, and supply dock for NanoTrasen that serves as one of their many facilities in exploiting the \
	wonders of phoron. It is currently orbiting around Erebus and maintains close contact with the NAS Crescent. The station itself has been \
	a target for a large number of Mercenaries and other companies wishing to steal NanoTrasen's secrets."

/datum/locations/crescent
	name = "NAS Crescent"
	desc = "The main hub for NanoTrasen in the Nyx system and is commonly referred to it by their workers as central command or \"CentCom\". \
	The Crescent refines and stores much of the products that stations (such as the Exodus) bring in. It is also a large refueling and supply \
	station of phoron and tritium in the Nyx system due to NanoTrasen being able to outsell almost any other company."

/datum/locations/emerald_habitation
	name = "Emerald Habitation"
	desc = "A relatively sub-par housing station that has a large population of aliens. The facility has areas for shopping, \
	a few restaurants, and multiple blocks for living arrangements. The station is crowded, busy, and the air quality is a recurring issue. \
	Nonetheless, it allows lower income spacers the means to travel in the Nyx system."

/datum/locations/void_star
	name = "The Void Star"
	desc = "No one quite knows who founded the Void Star, or indeed who actually manages the place. Theories range from a corporate money-laundry \
	operation to interstellar mobsters, with the more far-fetched even suggesting the place has always been there, like some kind of haunt. \
	Theories about the station's management are just as varied, though those who have been deep \"behind the scenes\" generally claim \
	they've spoken to shrouded figures, ranging from one to a whole panel of three to eight. \
	The Void Star is best described as a casino, complete with all the garish neon, advertisements and flashing lights such a description would entail. \
	Orbiting at the edge of the Hauler's Tragedy, the Void Star can sometimes even be spotted with the naked eye - flashing and pulsing through \
	the dull, dark asteroid belt like a beacon, broadcasting all manner of advertisements and promises for the gullible on just about any unencrypted \
	frequency - occasionally bleeding over into encrypted frequencies, too. \
	Despite the Star's remote location, traffic tends to be heavy. Despite the proximity to Brinkburn, the Star remains a relatively safe \
	place - as safe as anywhere in Nyx would be, anyway. The Star employs a well-equipped fleet of defense craft, mercenaries and sophisticated \
	drones, all ruthlessly enforcing the peace. As long as you have money you're willing to spend, the Void Star welcomes just about anyone.  \
	Some even call the Star home, as the sprawling asteroid-station offers hotel services; luxurious or spartan. Addicts, smugglers, pirates and \
	privateers - you'll find them all at the Void Star, ostensibly at their best behavior."

/datum/locations/moros
	name = "Moros"
	desc = "A mercurial planet, Moros is tidally locked to Nyx with a dayside surface temperature of 980K. Unsettled, although several geological \
	surveys have been performed on the night side. Undergoing orbital decay due to the influence of Euthenia; expected to break apart due to tidal \
	forces within 50 million years."

/datum/locations/brinkburn
	name = "Brinkburn"
	desc = "A martian planet, Brinkburn is small and dry yet is hot enough to be habitable. Possesses a dense ring system, theorised to be the fate of \
	primordial moons, which makes it difficult to enter or exit orbit."

/datum/locations/haulers_tragedy
	name = "Hauler's Tragedy"
	desc = "A thick asteroid belt that's full of pirate activity, mining operations, and trade depots. Very few corporate interests are active in the area."

/datum/locations/yulcite
	name = "Yulcite"
	desc = "A superearth near the outer edge of the habitable zone, Yulcite has 40% higher surface gravity than Earth. \
	Has been a hotbed of xenoarcheology for decades, due to the remains of a civilization that existed on this world approximately 570 million years ago."

/datum/locations/euthenia
	name = "Euthenia"
	desc = "A superneptune massing at 46 time that of Earth, Euthenia is one of the few planets still commonly called it's original survey designation. \
	(The surveyor is noted to have a preference for ancient Greek mythology) As an ice giant, Euthenia has had consistent economic stability thanks to \
	the presence of fuel depots supplied by the giants atmosphere."