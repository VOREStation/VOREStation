// "Useful" items - I'm guessing things that might be used at work?
/datum/gear/utility
	display_name = "briefcase"
	path = /obj/item/weapon/storage/briefcase
	sort_category = "Utility"

/datum/gear/utility/clipboard
	display_name = "clipboard"
	path = /obj/item/weapon/clipboard

/datum/gear/utility/tts_device
	display_name = "text to speech device"
	path = /obj/item/device/text_to_speech
	cost = 3 //Not extremely expensive, but it's useful for mute chracters.

/datum/gear/utility/communicator
	display_name = "communicator selection"
	path = /obj/item/device/communicator
	cost = 0

/datum/gear/utility/communicator/New()
	..()
	var/list/communicators = list()
	for(var/communicator in typesof(/obj/item/device/communicator) - list(/obj/item/device/communicator/integrated,/obj/item/device/communicator/commlink)) //VOREStation Edit - Remove Commlink
		var/obj/item/device/communicator_type = communicator
		communicators[initial(communicator_type.name)] = communicator_type
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(communicators))

/datum/gear/utility/camera
	display_name = "camera"
	path = /obj/item/device/camera

/datum/gear/utility/codex
	display_name = "the traveler's guide to vir"
	path = /obj/item/weapon/book/codex //VOREStation Edit
	cost = 0

/datum/gear/utility/news
	display_name = "daedalus pocket newscaster"
	path = /obj/item/weapon/book/codex/lore/news
	cost = 0

/* //VORESTATION REMOVAL
/datum/gear/utility/corp_regs
	display_name = "corporate regulations and legal code"
	path = /obj/item/weapon/book/codex/corp_regs
	cost = 0
*/

/datum/gear/utility/robutt
	display_name = "a buyer's guide to artificial bodies"
	path = /obj/item/weapon/book/codex/lore/robutt
	cost = 0

/datum/gear/utility/folder_blue
	display_name = "folder, blue"
	path = /obj/item/weapon/folder/blue

/datum/gear/utility/folder_grey
	display_name = "folder, grey"
	path = /obj/item/weapon/folder

/datum/gear/utility/folder_red
	display_name = "folder, red"
	path = /obj/item/weapon/folder/red

/datum/gear/utility/folder_white
	display_name = "folder, white"
	path = /obj/item/weapon/folder/white

/datum/gear/utility/folder_yellow
	display_name = "folder, yellow"
	path = /obj/item/weapon/folder/yellow

/datum/gear/utility/paicard
	display_name = "personal AI device"
	path = /obj/item/device/paicard

/datum/gear/utility/securecase
	display_name = "secure briefcase"
	path =/obj/item/weapon/storage/secure/briefcase
	cost = 2

/datum/gear/utility/laserpointer
	display_name = "laser pointer"
	path =/obj/item/device/laser_pointer
	cost = 2

/datum/gear/utility/flashlight
	display_name = "flashlight"
	path = /obj/item/device/flashlight

/datum/gear/utility/flashlight_blue
	display_name = "flashlight, blue"
	path = /obj/item/device/flashlight/color

/datum/gear/utility/flashlight_orange
	display_name = "flashlight, orange"
	path = /obj/item/device/flashlight/color/orange

/datum/gear/utility/flashlight_red
	display_name = "flashlight, red"
	path = /obj/item/device/flashlight/color/red

/datum/gear/utility/flashlight_yellow
	display_name = "flashlight, yellow"
	path = /obj/item/device/flashlight/color/yellow

/datum/gear/utility/maglight
	display_name = "flashlight, maglight"
	path = /obj/item/device/flashlight/maglight
	cost = 2

/datum/gear/utility/battery
	display_name = "cell, device"
	path = /obj/item/weapon/cell/device

/datum/gear/utility/implant
	slot = "implant"
	exploitable = 1

/datum/gear/utility/implant/tracking
	display_name = "implant, tracking"
	path = /obj/item/weapon/implant/tracking/weak
	cost = 0 //VOREStation Edit. Changed cost to 0

/datum/gear/utility/implant/neural
	display_name = "implant, neural assistance web"
	description = "A complex web implanted into the subject, medically in order to compensate for neurological disease."
	path = /obj/item/weapon/implant/neural
	cost = 6

/datum/gear/utility/implant/dud1
	display_name = "implant, head"
	description = "An implant with no obvious purpose."
	path = /obj/item/weapon/implant/dud
	cost = 1

/datum/gear/utility/implant/dud2
	display_name = "implant, torso"
	description = "An implant with no obvious purpose."
	path = /obj/item/weapon/implant/dud/torso
	cost = 1

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

/datum/gear/utility/pen
	display_name = "Fountain Pen"
	path = /obj/item/weapon/pen/fountain

/datum/gear/utility/wheelchair/color
	display_name = "wheelchair"
	path = /obj/item/wheelchair
	cost = 4

/datum/gear/utility/wheelchair/color/New()
	..()
	gear_tweaks = list(gear_tweak_free_color_choice)

/datum/gear/utility/umbrella
	display_name = "Umbrella"
	path = /obj/item/weapon/melee/umbrella
	cost = 3

/datum/gear/utility/umbrella/New()
	..()
	gear_tweaks = list(gear_tweak_free_color_choice)

/****************
modular computers
****************/

/datum/gear/utility/cheaptablet
	display_name = "tablet computer: cheap"
	display_name = "tablet computer, cheap"
	path = /obj/item/modular_computer/tablet/preset/custom_loadout/cheap
	cost = 3

/datum/gear/utility/normaltablet
	display_name = "tablet computer: advanced"
	display_name = "tablet computer, advanced"
	path = /obj/item/modular_computer/tablet/preset/custom_loadout/advanced
	cost = 4

/datum/gear/utility/customtablet
	display_name = "tablet computer: custom"
	display_name = "tablet computer, custom"
	path = /obj/item/modular_computer/tablet
	cost = 4

/datum/gear/utility/customtablet/New()
	..()
	gear_tweaks += new /datum/gear_tweak/tablet()

/datum/gear/utility/cheaplaptop
	display_name = "laptop computer, cheap"
	path = /obj/item/modular_computer/laptop/preset/custom_loadout/cheap
	cost = 4

/datum/gear/utility/normallaptop
	display_name = "laptop computer, advanced"
	path = /obj/item/modular_computer/laptop/preset/custom_loadout/advanced
	cost = 5

/datum/gear/utility/customlaptop
	display_name = "laptop computer, custom"
	path = /obj/item/modular_computer/laptop/preset/
	cost = 6 //VOREStation Edit

/datum/gear/utility/customlaptop/New()
	..()
	gear_tweaks += new /datum/gear_tweak/laptop()
