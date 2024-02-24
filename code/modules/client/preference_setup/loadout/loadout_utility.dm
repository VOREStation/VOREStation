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
	for(var/obj/item/device/communicator_type as anything in typesof(/obj/item/device/communicator) - list(/obj/item/device/communicator/integrated,/obj/item/device/communicator/commlink)) //VOREStation Edit - Remove Commlink
		communicators[initial(communicator_type.name)] = communicator_type
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(communicators))

/datum/gear/utility/camera
	display_name = "camera"
	path = /obj/item/device/camera

/datum/gear/utility/codex
	display_name = "the traveler's guide to Virgo-Erigone"
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
	display_name = "personal AI device (classic)"
	path = /obj/item/device/paicard

/datum/gear/utility/paicard_b
	display_name = "personal AI device (new)"
	path = /obj/item/device/paicard/typeb

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

/datum/gear/utility/maglight
	display_name = "flashlight, maglight"
	path = /obj/item/device/flashlight/maglight
	cost = 2

/datum/gear/utility/flashlight/color
	display_name = "flashlight, small (selection)"
	path = /obj/item/device/flashlight/color

/datum/gear/utility/flashlight/color/New()
	..()
	var/list/flashlights = list(
	"Blue Flashlight" = /obj/item/device/flashlight/color,
	"Red Flashlight" = /obj/item/device/flashlight/color/red,
	"Green Flashlight" = /obj/item/device/flashlight/color/green,
	"Yellow Flashlight" = /obj/item/device/flashlight/color/yellow,
	"Purple Flashlight" = /obj/item/device/flashlight/color/purple,
	"Orange Flashlight" = /obj/item/device/flashlight/color/orange
	)
	gear_tweaks += new/datum/gear_tweak/path(flashlights)

/datum/gear/utility/battery
	display_name = "cell, device"
	path = /obj/item/weapon/cell/device

/datum/gear/utility/pen
	display_name = "fountain pen"
	path = /obj/item/weapon/pen/fountain

/datum/gear/utility/umbrella
	display_name = "umbrella"
	path = /obj/item/weapon/melee/umbrella
	cost = 3

/datum/gear/utility/umbrella/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/utility/wheelchair
	display_name = "wheelchair selection"
	path = /obj/item/wheelchair
	cost = 4

/datum/gear/utility/wheelchair/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice
	var/list/wheelchairs = list(
		"wheelchair" = /obj/item/wheelchair,
		"motorized wheelchair" = /obj/item/wheelchair/motor
	)
	gear_tweaks += new/datum/gear_tweak/path(wheelchairs)

/datum/gear/utility/lantern
	display_name = "lantern"
	path = /obj/item/device/flashlight/lantern
	cost = 2

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
