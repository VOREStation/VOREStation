/datum/gear/utility/implant
	display_name = "implant, neural assistance web"
	description = "A complex web implanted into the subject, medically in order to compensate for neurological disease."
	path = /obj/item/weapon/implant/neural
	slot = "implant"
	exploitable = 1
	sort_category = "Cyberware"
	cost = 6

/datum/gear/utility/implant/tracking
	display_name = "implant, tracking"
	path = /obj/item/weapon/implant/tracking/weak
	cost = 10

// Remove these after generic implant has been in for awhile and everyone has had a reasonable period to copy their old descs.
/datum/gear/utility/implant/dud1
	display_name = "implant, head"
	description = "An implant with no obvious purpose (DEPRECATED, USE GENERIC IMPLANT)."
	path = /obj/item/weapon/implant/dud
	cost = 1
/datum/gear/utility/implant/dud2
	display_name = "implant, torso"
	description = "An implant with no obvious purpose (DEPRECATED, USE GENERIC IMPLANT)."
	path = /obj/item/weapon/implant/dud/torso
	cost = 1
// End removal marker.

/datum/gear/utility/implant/generic
	display_name = "implant, generic, primary"
	description = "An implant with no obvious purpose."
	path = /obj/item/weapon/implant
	cost = 1

/datum/gear/utility/implant/generic/second
	display_name = "implant, generic, secondary"

/datum/gear/utility/implant/generic/third
	display_name = "implant, generic, tertiary"

/datum/gear/utility/implant/generic/New()
	..()
	gear_tweaks += global.gear_tweak_implant_location

/datum/gear/utility/implant/language
	cost = 2
	exploitable = 0

/datum/gear/utility/implant/language/eal
	display_name = "vocal synthesizer, EAL"
	description = "A surgically implanted vocal synthesizer which allows the owner to speak EAL, if they know it."
	path = /obj/item/weapon/implant/language/eal

/datum/gear/utility/implant/language/skrellian
	display_name = "vocal synthesizer, Skrellian"
	description = "A surgically implanted vocal synthesizer which allows the owner to speak Common Skrellian, if they know it."
	path = /obj/item/weapon/implant/language/skrellian
