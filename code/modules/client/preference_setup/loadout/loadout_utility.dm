// "Useful" items - I'm guessing things that might be used at work?
/datum/gear/utility
	display_name = "briefcase"
	path = /obj/item/storage/briefcase
	sort_category = "Utility"

/datum/gear/utility/clipboard
	display_name = "clipboard"
	path = /obj/item/clipboard

/datum/gear/utility/tts_device
	display_name = "text to speech device"
	path = /obj/item/text_to_speech
	cost = 3 //Not extremely expensive, but it's useful for mute chracters.

/datum/gear/utility/communicator
	display_name = "communicator selection"
	path = /obj/item/communicator
	cost = 0

/datum/gear/utility/communicator/Initialize()
	. = ..()
	var/list/communicators = list()
	for(var/obj/item/communicator_type as anything in typesof(/obj/item/communicator) - list(/obj/item/communicator/integrated,/obj/item/communicator/commlink)) //VOREStation Edit - Remove Commlink
		communicators[initial(communicator_type.name)] = communicator_type
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(communicators))

/datum/gear/utility/camera
	display_name = "camera"
	path = /obj/item/camera

/datum/gear/utility/codex
	display_name = "the traveler's guide to vir"
	path = /obj/item/book/codex //VOREStation Edit
	cost = 0

/datum/gear/utility/news
	display_name = "daedalus pocket newscaster"
	path = /obj/item/book/codex/lore/news
	cost = 0

/* //VORESTATION REMOVAL
/datum/gear/utility/corp_regs
	display_name = "corporate regulations and legal code"
	path = /obj/item/book/codex/corp_regs
	cost = 0
*/

/datum/gear/utility/robutt
	display_name = "a buyer's guide to artificial bodies"
	path = /obj/item/book/codex/lore/robutt
	cost = 0

/datum/gear/utility/folder_blue
	display_name = "folder, blue"
	path = /obj/item/folder/blue

/datum/gear/utility/folder_grey
	display_name = "folder, grey"
	path = /obj/item/folder

/datum/gear/utility/folder_red
	display_name = "folder, red"
	path = /obj/item/folder/red

/datum/gear/utility/folder_white
	display_name = "folder, white"
	path = /obj/item/folder/white

/datum/gear/utility/folder_yellow
	display_name = "folder, yellow"
	path = /obj/item/folder/yellow

/datum/gear/utility/paicard
	display_name = "personal AI device (classic)"
	path = /obj/item/paicard

/datum/gear/utility/paicard_b
	display_name = "personal AI device (new)"
	path = /obj/item/paicard/typeb

/datum/gear/utility/securecase
	display_name = "secure briefcase"
	path =/obj/item/storage/secure/briefcase
	cost = 2

/datum/gear/utility/laserpointer
	display_name = "laser pointer"
	path =/obj/item/laser_pointer
	cost = 2

/datum/gear/utility/flashlight
	display_name = "flashlight"
	path = /obj/item/flashlight

/datum/gear/utility/maglight
	display_name = "flashlight, maglight"
	path = /obj/item/flashlight/maglight
	cost = 2

/datum/gear/utility/flashlight/color
	display_name = "flashlight, small (selection)"
	path = /obj/item/flashlight/color

/datum/gear/utility/flashlight/color/Initialize()
	. = ..()
	var/list/flashlights = list(
	"Blue Flashlight" = /obj/item/flashlight/color,
	"Red Flashlight" = /obj/item/flashlight/color/red,
	"Green Flashlight" = /obj/item/flashlight/color/green,
	"Yellow Flashlight" = /obj/item/flashlight/color/yellow,
	"Purple Flashlight" = /obj/item/flashlight/color/purple,
	"Orange Flashlight" = /obj/item/flashlight/color/orange
	)
	gear_tweaks += new/datum/gear_tweak/path(flashlights)

/datum/gear/utility/battery
	display_name = "cell, device"
	path = /obj/item/cell/device

/datum/gear/utility/pen
	display_name = "fountain pen"
	path = /obj/item/pen/fountain

/datum/gear/utility/umbrella
	display_name = "umbrella"
	path = /obj/item/melee/umbrella
	cost = 3

/datum/gear/utility/umbrella/Initialize()
	. = ..()
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/utility/wheelchair
	display_name = "wheelchair selection"
	path = /obj/item/wheelchair
	cost = 4

/datum/gear/utility/wheelchair/Initialize()
	. = ..()
	gear_tweaks += gear_tweak_free_color_choice
	var/list/wheelchairs = list(
		"wheelchair" = /obj/item/wheelchair,
		"motorized wheelchair" = /obj/item/wheelchair/motor
	)
	gear_tweaks += new/datum/gear_tweak/path(wheelchairs)

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

/datum/gear/utility/customtablet/Initialize()
	. = ..()
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

/datum/gear/utility/customlaptop/Initialize()
	. = ..()
	gear_tweaks += new /datum/gear_tweak/laptop()
