//Uueoa-Esa

/datum/locations/uueoa_esa
	name = "Uueoa-Esa"
	desc = "The home system of the Unathi.  It roughly translates to 'burning mother'."

/datum/locations/uueoa_esa/New(var/creator)
	contents.Add(
		new /datum/locations/moghes(src),
		new /datum/locations/ouere(src),
		new /datum/locations/yeora(src),
		new /datum/locations/yoos(src)
		)
	..(creator)

/datum/locations/moghes
	name = "Moghes"
	desc = "The planet Moghes is home of the Unathi, and is dominated primarily by deserts as a result of an ancient nuclear disaster. \
	Evidence of this previous, older race manifests itself in the form of ruins that dot themselves across the surface. Traces of \
	swamp-land and jungles are present, showing that, at one time, Moghes was a lush world filled with a thriving ecosystem. \
	The planet is 1/6 smaller than the size of Earth, and it's only sun is close enough to make it uncomfortable for non-natives. \
	It has a single moon. Despite the doomsday event that burned away most of the plant life and water on the planet, \
	Moghes is still home to two large oceans called Malawi and Tanganyika. Sand storms are common at the equator and rain is only semi-common at the polar caps."

/datum/locations/ouere
	name = "Ouere"
	desc = "Second closest planet to the burning mother and somewhat close to Moghes, oddly a planet heavily forested in swamp, \
	jungle and plain with very few lakes and some very harsh, carnivorous flora, most of it's water is underground in sub-geo lakes \
	and rivers... Rumors about colonies of very exploration minded Unathi circle it, but who can tell? Roughly 2/3rds Moghes' size."

/datum/locations/yeora
	name = "Yeora"
	desc = "The planet with the biggest AU gap in the 'Esa system, a large blue gas giant with a trio of moons that's suspected \
	to account for it's distance from the other 3 bodies, some energy corporations wonder if it's worth harvesting for valuable \
	gasses, but aren't hopeful...It doesn't help most city-state councils and warlords wouldn't be happy with Skrell or Human establishment \
	in a system which could be /their/ rightful resource."

/datum/locations/yoos
	name = "Yoos"
	desc = "A tiny (1/8th the size of Moghes) frozen planet at the very edge of the Uueoa-Esa system of very little note."