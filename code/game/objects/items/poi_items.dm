
/obj/item/poi
	icon = 'icons/obj/objects.dmi'
	desc = "This is definitely something cool."

/datum/category_item/catalogue/information/objects/pascalb
	name = "Object - Pascal B Steel Shaft Cap"
	desc = "In the year 1957, the United States of America - an Earth nation - performed a series \
	of earth nuclear weapons tests codenamed 'Operation Plumbbob', which remain the largest and \
	longest running nuclear test series performed on the American continent. Test data included \
	various altitude detonations, effects on several materials and structures at various \
	distances, and the effects of radiation on military hardware and the human body. \
	<br><br>\
	On the 27th of August that year, in a test named 'Pascal-B' a 300t nuclear payload \
	was buried in a shaft capped by a 900kg steel plate cap. The test was intended to \
	verify the safety of underground detonation, but the shaft was not sufficient to \
	contain the shockwave. According to experiment designer Robert Brownlee, the steel \
	cap was propelled upwards at a velocity of 240,000km/h - over six times Earth's \
	escape velocity. The cap appeared in only one frame of high-speed camera recording. \
	<br><br>\
	It had been theorized that the cap had exited earth's atmosphere and entered orbit. \
	It would seem the cap traveled farther than had been possibly imagined."
	value = CATALOGUER_REWARD_MEDIUM

/obj/item/poi/pascalb
	icon_state = "pascalb"
	name = "misshapen manhole cover"
	desc = "The top of this twisted chunk of metal is faintly stamped with a five pointed star. 'Property of US Army, Pascal B - 1957'."
	catalogue_data = list(/datum/category_item/catalogue/information/objects/pascalb)

/obj/item/poi/pascalb/New()
	START_PROCESSING(SSobj, src)
	return ..()

/obj/item/poi/pascalb/process()
	SSradiation.radiate(src, 5)

/obj/item/poi/pascalb/Destroy()
	STOP_PROCESSING(SSobj, src)
	return ..()

/datum/category_item/catalogue/information/objects/oldreactor
	name = "Object - Zorren Fission Reactor Rack"
	desc = "Prior to Humanity's arrival in the virgo-erigone space, introducing advanced phoron technologies, \
	the native Zorren relied upon refurbished, reverse-engineered precursor technology. \
	As much of precursor technology is powered by yet incomprehensible technologies, something reliable was needed. \
	What better to power one's ships - but fission; a technology whose development was driven by war and economic need alike. \
	Stable, requiring only the most minimal supervision - Fission technology soon became ubiqutious.\
	<br><br>\
	However, as accidents were not uncommon due to the inherent dangers of space travel and the \
	nature of reactor racks such as this one fully containing the unstable fuel material, many \
	fission vessels were built capable of jettisoning their entire engine sections as it was seen \
	as preferable to evacuating a ship's crew and potentially losing the entire craft and its cargo. \
	<br><br>\
	Exact details as to where or when this reactor rack hails from are difficult to determine. \
	Based on fissile material ratios, its age can be put between fifty to over a hundred years old. \
	Although not a piece of precursor technology, the various kingdoms of Virgo prime \
	still welcome return of their lost resources and machinery."
	value = CATALOGUER_REWARD_MEDIUM

/obj/structure/closet/crate/oldreactor
	name = "fission reactor rack"
	desc = "Used in older models of nuclear reactors, essentially a cooling rack for high volumes of radioactive material."
	icon = 'icons/obj/closets/poireactor.dmi'
	closet_appearance = null
	catalogue_data = list(/datum/category_item/catalogue/information/objects/oldreactor)
	climbable = FALSE

	starts_with = list(
		/obj/item/weapon/fuel_assembly/deuterium = 6)

/obj/item/poi/brokenoldreactor
	icon_state = "poireactor_broken"
	name = "ruptured fission reactor rack"
	desc = "This broken hunk of machinery looks extremely dangerous."
	catalogue_data = list(/datum/category_item/catalogue/information/objects/oldreactor)

/obj/item/poi/brokenoldreactor/New()
	START_PROCESSING(SSobj, src)
	return ..()

/obj/item/poi/brokenoldreactor/process()
	SSradiation.radiate(src, 25)

/obj/item/poi/brokenoldreactor/Destroy()
	STOP_PROCESSING(SSobj, src)
	return ..()

/datum/category_item/catalogue/information/objects/growthcanister
	name = "Object - Growth Inhibitor 78-1"
	desc = "The production of Vatborn humans is a process which involves the synthesis of over two hundred \
	distinct chemical compounds. While most Vatborn are 'produced' as infants and merely genetically modified \
	to encourage rapid early maturation, the specific development of the controversial 'Expedited' Vatborn calls for \
	a far more intensive process.\
	<br><br>\
	Growth Inhibitor Type 78-1 is used in the rapid artificial maturation process to prevent the 'overdevelopment' of\
	particular cell structures in the Vatborn's body, halting the otherwise inevitable development of aggressive cancerous\
	growths which would be detrimental or lethal to the subject. Exposure to the compound in its pure form can cause\
	devastating damage to living tissue, ceasing all regenerative activity in an organism's cells. While immediate effects\
	can be halted by recent medical innovations, exposure can severely shorten a sapient's life expectancy.\
	<br><br>\
	Although the Sol-Procyon Commonwealth nominally disapproves of the usage of Vatborn slaves, \
	calling it barbaric and citing it as demonstration of the moral corruption distance from the \
	Core can drive the likes of the Elysian Colonies - the Periphery remains a secluded region, \
	a challenge when it comes to proper staffing. Oddly, despite its prowess otherwise, \
	the cataloguer fails to identify the owner or manufacturer of this canister."
	value = CATALOGUER_REWARD_MEDIUM

/obj/structure/prop/poicanister
	name = "Ruptured Chemical Canister"
	desc = "A cracked open chemical canister labelled 'Growth Inhibitor 78-1'"
	icon = 'icons/obj/atmos.dmi'
	icon_state = "yellow-1"
	catalogue_data = list(/datum/category_item/catalogue/information/objects/growthcanister)
	anchored = FALSE
	density = TRUE
