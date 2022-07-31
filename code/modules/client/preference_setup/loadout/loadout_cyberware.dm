/datum/gear/utility/implant
	display_name = "implant, neural assistance web"
	description = "A complex web implanted into the subject, medically in order to compensate for neurological disease."
	path = /obj/item/implant/neural
	slot = "implant"
	exploitable = 1
	sort_category = "Cyberware"
	cost = 6

/datum/gear/utility/implant/tracking
	display_name = "implant, tracking"
	path = /obj/item/implant/tracking/weak
	cost = 0 //VOREStation Edit. Changed cost to 0

/datum/gear/utility/implant/generic
	display_name = "implant, generic, primary"
	description = "An implant with no obvious purpose."
	path = /obj/item/implant
	cost = 1

/datum/gear/utility/implant/generic/second
	display_name = "implant, generic, secondary"

/datum/gear/utility/implant/generic/third
	display_name = "implant, generic, tertiary"

/datum/gear/utility/implant/generic/Initialize()
	. = ..()
	gear_tweaks += global.gear_tweak_implant_location

/datum/gear/utility/implant/language
	cost = 2
	exploitable = 0

/datum/gear/utility/implant/language/eal
	display_name = "vocal synthesizer, EAL"
	description = "A surgically implanted vocal synthesizer which allows the owner to speak EAL, if they know it."
	path = /obj/item/implant/language/eal

/datum/gear/utility/implant/language/skrellian
	display_name = "vocal synthesizer, Skrellian"
	description = "A surgically implanted vocal synthesizer which allows the owner to speak Common Skrellian, if they know it."
	path = /obj/item/implant/language/skrellian
