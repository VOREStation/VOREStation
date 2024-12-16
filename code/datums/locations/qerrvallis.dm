//Qerrbalak

/datum/locations/qerrvallis
	name = "Qerr'Vallis"
	desc = "The home system of the Skrell, which translates to 'Star of the royals' or 'Light of the Crown'."

/datum/locations/qerrvallis/New(var/creator)
	contents.Add(
		new /datum/locations/qerrbalak(src)
		)
	..(creator)

/datum/locations/qerrbalak
	name = "Qerrbalak"
	desc = "The homeworld of the Skrell. It is a planet with a humid atmosphere, featuring plenty of swamps and jungles. \
	The world is filled with Skrellian cities which often sit on stilts."

/datum/locations/qerrbalak/New(var/creator)
	contents.Add(
		new /datum/locations/qarrkloa(src),
		new /datum/locations/moglar(src),
		new /datum/locations/miqoxi(src),
		new /datum/locations/kallo(src),
		new /datum/locations/glimorr(src)
		)
	..(creator)

/datum/locations/qarrkloa
	name = "Qarr'kloa"
	desc = "Mythically considered the first State-City ever built by Skrellkind, Qarr'kloa attracts thousands of tourists and archeologists \
	every year thanks to the ancestral structures, built thousands of years ago by the Skrell, scattered in its vicinity."

/datum/locations/moglar
	name = "Mo'glar"
	desc = "Built on the northern coast of Qorr'gloa, Mo'glar was, at the time of Xi'Krri'oal's colonization, a major port of trade between \
	the two continents of the planet. It has kept that role to this day, although it never truly adapted to inter-planetary trade, leaving the \
	task of exporting Qerrbalak's goods to other planets to other cities, mainly on Xi'Krri'oal."

/datum/locations/miqoxi
	name = "Mi'qoxi"
	desc = "This city, built on the small patch of islands north of Xi'Krri'oal, owes most of its current status to the infamous Qerr-Skria \
	Glo'morr Krrixi who, in the 23th century BCE, built a large empire spanning from the Qo'rria Sea to the current city of Qal'krrea, mostly \
	through military conquests. As the center of his empire, Mi'qoxi became a large center of population and industry and while the fall of \
	the empire at Krrixi's death did put a halt to the city's growth, it is still today one of the biggest cities of the continent."

/datum/locations/kallo
	name = "Kal'lo"
	desc = "A relatively recent city compared to the other major cities of the planet, Kal'lo quickly rose in status by fathering some of the most \
	important figures of modern skrellian society. It is notably the birthplace of Xikrra Kol'goa, who wrote the Lo'glo'mog'rri in 46 BCE, \
	the constitutional code that is still used by most of the skrellian states in the galaxy."

/datum/locations/glimorr
	name = "Gli'morr"
	desc = "While Gli'morr is not as heavily-populated than its continental counterparts, its touristic potential made it rich enough to finance \
	the biggest research center of the planet, covering dozens of scientific fields. Its Academy is just as much renowned, and even the lowest \
	Qrri-Mog (although most of its students prefer to continue their studies until they become Qerr-Mog) coming out of its classrooms is \
	considered part of the elite."
