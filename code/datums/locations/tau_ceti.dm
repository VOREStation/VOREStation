//Tau Ceti

/datum/locations/tau_ceti
	name = "Tau Ceti"
	desc = "Tau Ceti is a relatively populated system that sits between the inner and outer systems of human colonized space."

/datum/locations/tau_ceti/New(var/creator)
	contents.Add(
		new /datum/locations/tau_ceti_i(src),
		new /datum/locations/luthien(src),
		new /datum/locations/bimna(src),
		new /datum/locations/new_gibson(src),
		new /datum/locations/reade(src),
		new /datum/locations/tau_ceti_vi(src)
		)
	..(creator)

/datum/locations/tau_ceti_i
	name = "Tau Ceti I"
	desc = "Tau Ceti I is a small, hot world with a thick and toxic atmosphere reminiscent of Sol's Venus. The close proximity to Tau Ceti renders any activity \
	on this world too dangerous to consider, although heavy heat and radiation shielding mitigate the risk enough for a single stellar observation post in the \
	upper equatorial region, which has the shortest day period on the planet."

/datum/locations/luthien
	name = "Luthien"
	desc = "A small colony established on a feral, untamed world largely comprised of jungles with some savannah around the lower equatorial regions. \
	Human inhabitants are outnumbered by feral native species and wild beasts, which attack the outpost regularly, The Tau Ceti government maintains tight \
	military control over the few tiny population centres located near the poles."

/datum/locations/bimna
	name = "Bimna"
	desc = "A medium sized planet with a strong economy and stable populace, Bimna is noteworthy for very little beyond having a large academic population, \
	and having one of the largest shipyards in the sector."

/datum/locations/new_gibson
	name = "New Gibson"
	desc = "New Gibson is a medium sized, rocky planet that is covered in rampant industrialisation. Containing the majority of the planet-bound \
	resources in the system, New Gibson is torn by unrest and has very little wealth to call it's own."

/datum/locations/reade
	name = "Reade"
	desc = "A small, cold, metal-deficient world, the Tau Ceti government maintains agricultural pastures in whatever available space in an attempt to salvage some \
	worth from this profitless colony, after a clerical error in the late 2400s resulted in significant expenditure in settlement and infrastructure. \
	Nowadays, what remains of that misguided re-colonisation project makes up several cavernous, ruined cities (some of which are visible from orbit)."

/datum/locations/tau_ceti_vi
	name = "Tau Ceti VI"
	desc = "A small, cold world with a thin and unbreathable atmosphere and notably low gravity. Geological surveys over the centuries have catalogued \
	an anomalous network of cavities within the middle and lower crust of the planet that result in remarkably low gravity, and a complete lack of \
	seismic activity. The planet is completely void of anything making settlement worthwhile, but recently there have been rumours of illegitimate \
	shipping here. Security patrols have thus far turned up nothing, but some parties hypothesize that any smugglers or bandits could hide in the dense \
	molecular band in a median orbit around Tau Ceti to fool in-system sensors."