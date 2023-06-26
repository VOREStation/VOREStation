//TODO: Make this match current lore

//S'randarr

/datum/locations/s_randarr
	name = "S'randarr"
	desc = "An orange star, associated with the Tajaran god of life and mercy."

/datum/locations/s_randarr/New(var/creator)
	contents.Add(
		new /datum/locations/ahdomai(src),
		new /datum/locations/sranjir(src),
		new /datum/locations/messa(src),
		new /datum/locations/al_benj_sri(src)
		)
	..(creator)

//BEGIN AHDOMAI

/datum/locations/ahdomai
	name = "Ahdomai"
	desc = "The Tajaran home planet. It is the smaller of its twin-planet alignment.  Its atmosphere is not dissimilar to that of Earth. \
	Its geography is largely mountainous, with a number of tundras, frozen plains, semi-frozen lakes, and icy seas."

/datum/locations/ahdomai/New(var/creator)
	contents.Add(
		new /datum/locations/ahdomai_northern_plains(src),
		new /datum/locations/ahdomai_snowy_mountains(src)
		)
	..(creator)

/datum/locations/ahdomai_northern_plains
	name = "The Northern Plains"
	desc = "One of the regions of Ahdomai."

/datum/locations/ahdomai_northern_plains/New(var/creator)
	contents.Add(
		new /datum/locations/mijri_peninsula(src),
		new /datum/locations/the_slavemaster_strip(src)
		)
	..(creator)

/datum/locations/mijri_peninsula
	name = "Mi'jri Peninsula"
	desc = "The peninsula is an area that remains sloped down to the shores due to freezing and thawing constantly chewing away at the land. \
	Much of the sediment is then collected to the shore lines which most of the year are frozen beaches. This area is popular for fishing for \
	the Nazkiin, and is a major source of most of their food."

/datum/locations/the_slavemaster_strip
	name = "The Slavemaster Strip"
	desc = "Previously referred to as the Overseer Artery. Much of this area is composed of more rugged plain lands, with a few craters \
	and small mountains dotting the landscape. One specific area of note is what is referred to as the \"Crater of Light.\" In the Slavemaster era, \
	the Crater was used as a mine for most of the raw minerals the Slavemaster's had, and was the main site of the Nothern Plains Mining Network. \
	Since the fall of the Slavemasters, the Hadii have fought tooth and nail to preserve hold of it, believing S'randarr gave it to them, \
	and those of Tajr-kii S'randarr must keep it away from the followers of Messa."

/datum/locations/the_slavemaster_strip/New(var/creator)
	contents.Add(
		new /datum/locations/northern_plains_mining_network(src),
		new /datum/locations/mi_dynh_al_manq(src),
		new /datum/locations/contai(src)
		)
	..(creator)

/datum/locations/northern_plains_mining_network
	name = "Northern Plains Mining Network"
	desc = "A Slavemaster-era mining complex, now owned, operated, and supplied by NT. The Slavemasters cleared out a large portion of the area's \
	mineral wealth, but not all was depleted prior to their leaving.  Tajaran employed from nearby towns hail mostly from those days and are glad to \
	see the improvements, safety regulations, and supplies provided by NT (which is to say, any)."

/datum/locations/mi_dynh_al_manq
	name = "Mi'dynh Al'Manq"
	desc = "a large NT-funded city, providing (cramped) housing for less-fortunate Tajaran, hospitals, schooling, job training, \
	job certification, space ports, and more. Many humans also live here, and operate many facilities."

/datum/locations/contai
	name = "Contai"
	desc = "a smaller village whose miners all remember the slave days. The relative size of the village is such that they have no local \
	school, and must attend academy in the nearby city of Mi'dynh Al'Manq."

/datum/locations/ahdomai_snowy_mountains
	name = "The Snowy Mountains"
	desc = "One of the regions of Ahdomai."

/datum/locations/ahdomai_snowy_mountains/New(var/creator)
	contents.Add(
		new /datum/locations/rhezars_crown(src),
		new /datum/locations/rrhazkal_ice_maw(src),
		new /datum/locations/ah_fralak_landing(src),
		new /datum/locations/ahdomai_ruined_land(src)
		)
	..(creator)

/datum/locations/rhezars_crown
	name = "Rhezar's Crown"
	desc = "An area that is separate from the rest of the region by a large glacier between the continents, Has very jagged, icy, and unforgiving peaks, \
	crevasses, and a vast networks of mountain caves."

/datum/locations/rrhazkal_ice_maw
	name = "Rrhazkal Ice Maw"
	desc = "The area between the main continent and the Rhezar's Crown Continent. It is a large, permanently frozen sea with islands forming \
	mountains poking up around. This strip is filled with cracks, and hidden ravines in the glacier. This path is a major breaking point for \
	separation of culture from the rest of Ahdomai, and Rhezar's Crown"

/datum/locations/ah_fralak_landing
	name = "Ah'Fralak Landing"
	desc = "A large area of more rugged terrain than the plains to the south. Near the coast to the Rrhazkal Ice Maw, the area has a \
	long cliff face that steeply falls down to the Maw. Tribes looking to work their way to the Crown may make the sides of \
	these cliffs their home, many times."

/datum/locations/ahdomai_ruined_land
	name = "Ruined Land"
	desc = "The area in the northeast corner of the main continent of Ahdomai is a barren, almost lifeless strip of land. Flora and \
	fauna on the surface are hard to find, even with most of the land flat and white as far as the eye can see, when heavy fogs and \
	blizzards are not present."

//END AHDOMAI


/datum/locations/sranjir
	name = "S'ranjir"
	desc = "The larger world that Ahdomai orbits. It is often mythologically associated as S'randarr's Shield, and is informally known \
	as Shield among the Tajaran and formally among the humans. It is uninhabitable, as it has a largely methane atmosphere and lacks water \
	or other features necessary to life. Nonetheless, a domed, underdeveloped colony exists, called Hran'vasa, heavily funded by Osiris Atmospherics, \
	practically the only non-Ahdomain official holding for the Tajaran race. It is incredibly dependent on outside support and imports for life, \
	but has a high export of noble gasses for corporate use."

/datum/locations/messa
	name = "Messa"
	desc = "The blue unstably-ringed gas planet, associated with the Tajaran goddess of death and change. By the superstitious and religious, \
	it is considered a bad omen when Messa is the only one in the sky. It is also said the rings are the souls Messa has clung on to, and is consuming."

/datum/locations/al_benj_sri
	name = "Al-Benj S'ri"
	desc = "An asteroid belt separating S'randarr and Messa from Ahdomai. This is known also as \"The Sea of Souls\". Those sold in Al-Benj S'ri \
	are said to be in limbo between S'randarr and Messa, as they both fight over them."
