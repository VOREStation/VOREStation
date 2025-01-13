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

/datum/gear/utility/communicator/New()
	..()
	var/list/communicators = list()
	for(var/obj/item/communicator_type as anything in typesof(/obj/item/communicator) - list(/obj/item/communicator/integrated,/obj/item/communicator/commlink)) //VOREStation Edit - Remove Commlink
		communicators[initial(communicator_type.name)] = communicator_type
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(communicators))

/datum/gear/utility/camera
	display_name = "camera"
	path = /obj/item/camera

/datum/gear/utility/codex
	display_name = "the traveler's guide to Virgo-Erigone"
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

/datum/gear/utility/flashlight/color/New()
	..()
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
	path = /obj/item/flashlight/lantern
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

//////////Language Translators

/datum/gear/utility/translator
	display_name = "handheld translator (selection)"
	path = /obj/item/universal_translator/limited
	cost = 4

/datum/gear/utility/translator/New()
	..()
	var/list/translators = list(
	"galcom" = /obj/item/universal_translator/limited,
	"solcom" = /obj/item/universal_translator/limited/sol,
	"terminus" = /obj/item/universal_translator/limited/terminus,
	"tradeband" = /obj/item/universal_translator/limited/tradeband,
	"gutterband" = /obj/item/universal_translator/limited/gutterband,
	"skrellian" = /obj/item/universal_translator/limited/skrellian,
	"sinta'unathi" = /obj/item/universal_translator/limited/unathi,
	"siik" = /obj/item/universal_translator/limited/siik,
	"schechi" = /obj/item/universal_translator/limited/schechi,
	"vedaqh" = /obj/item/universal_translator/limited/vedaqh,
	"birdsong" = /obj/item/universal_translator/limited/birdsong,
	"sagaru" = /obj/item/universal_translator/limited/sagaru,
	"canilunzt" = /obj/item/universal_translator/limited/canilunzt,
	"ecureuilian" = /obj/item/universal_translator/limited/ecureuilian,
	"daemon" = /obj/item/universal_translator/limited/daemon,
	"enochian" = /obj/item/universal_translator/limited/enochian,
	"vespinae" = /obj/item/universal_translator/limited/vespinae,
	"d'rudak'ar" = /obj/item/universal_translator/limited/dragon,
	"spacer" = /obj/item/universal_translator/limited/spacer,
	"tavan" = /obj/item/universal_translator/limited/tavan,
	"echo song" = /obj/item/universal_translator/limited/echosong,
	"akhani" = /obj/item/universal_translator/limited/akhani,
	"alai" = /obj/item/universal_translator/limited/alai
	)
	gear_tweaks += new/datum/gear_tweak/path(translators)

/datum/gear/utility/saddlebag
	display_name = "saddle bag, horse"
	path = /obj/item/storage/backpack/saddlebag
	slot = slot_back
	cost = 2

/datum/gear/utility/saddlebag_common
	display_name = "saddle bag, common"
	path = /obj/item/storage/backpack/saddlebag_common
	slot = slot_back
	cost = 2

/datum/gear/utility/saddlebag_common/robust
	display_name = "saddle bag, robust"
	path = /obj/item/storage/backpack/saddlebag_common/robust
	slot = slot_back
	cost = 2

/datum/gear/utility/saddlebag_common/vest
	display_name = "taur duty vest (backpack)"
	path = /obj/item/storage/backpack/saddlebag_common/vest
	slot = slot_back
	cost = 1

/datum/gear/utility/dufflebag
	display_name = "dufflebag"
	path = /obj/item/storage/backpack/dufflebag
	slot = slot_back
	cost = 2

/datum/gear/utility/dufflebag/black
	display_name = "black dufflebag"
	path = /obj/item/storage/backpack/dufflebag/fluff

/datum/gear/utility/dufflebag/med
	display_name = "medical dufflebag"
	path = /obj/item/storage/backpack/dufflebag/med
	allowed_roles = list(JOB_MEDICAL_DOCTOR,JOB_CHIEF_MEDICAL_OFFICER,JOB_CHEMIST,JOB_PARAMEDIC,JOB_GENETICIST,JOB_PSYCHIATRIST)

/datum/gear/utility/dufflebag/med/emt
	display_name = "EMT dufflebag"
	path = /obj/item/storage/backpack/dufflebag/emt

/datum/gear/utility/dufflebag/sec
	display_name = "security Dufflebag"
	allowed_roles = list(JOB_HEAD_OF_SECURITY,JOB_WARDEN,JOB_DETECTIVE,JOB_SECURITY_OFFICER)
	path = /obj/item/storage/backpack/dufflebag/sec

/datum/gear/utility/dufflebag/eng
	display_name = "engineering dufflebag"
	allowed_roles = list(JOB_CHIEF_ENGINEER,JOB_ATMOSPHERIC_TECHNICIAN,JOB_ENGINEER)
	path = /obj/item/storage/backpack/dufflebag/eng

/datum/gear/utility/dufflebag/sci
	display_name = "science dufflebag"
	allowed_roles = list(JOB_RESEARCH_DIRECTOR,JOB_SCIENTIST,JOB_ROBOTICIST,JOB_XENOBIOLOGIST,JOB_XENOBOTANIST)
	path = /obj/item/storage/backpack/dufflebag/sci

/datum/gear/utility/dufflebag/explorer
	display_name = "away team dufflebag"
	path = /obj/item/storage/backpack/dufflebag/explorer

/datum/gear/utility/dufflebag/talon
	display_name = "Talon dufflebag"
	path = /obj/item/storage/backpack/dufflebag/explorer

/datum/gear/utility/ID
	display_name = "contractor identification card"
	path = /obj/item/card/id/event/polymorphic/altcard
	cost = 1

/datum/gear/utility/bs_bracelet
	display_name = "bluespace bracelet"
	path = /obj/item/clothing/gloves/bluespace
	cost = 2

/datum/gear/utility/walkpod
	display_name = "podzu music player"
	path = /obj/item/walkpod
	cost = 2
