var/datum/ai_icon/default_ai_icon = new/datum/ai_icon/blue()
var/list/datum/ai_icon/ai_icons

/datum/ai_icon
	var/name
	var/alive_icon
	var/alive_light = "#FFFFFF"
	var/nopower_icon = "4"
	var/nopower_light = "#FFFFFF"
	var/dead_icon = "ai-crash"
	var/dead_light = "#000099"

/datum/ai_icon/New(var/name, var/alive_icon, var/nopower_icon, var/dead_icon, var/alive_light, var/nopower_light, var/dead_light)
	if(name)
		src.name = name
		src.alive_icon = alive_icon
		src.nopower_icon = nopower_icon
		src.dead_icon = dead_icon
		src.alive_light = alive_light
		src.nopower_light = nopower_light
		src.dead_light = dead_light
	if(!ai_icons)
		ai_icons = list()
		init_subtypes(/datum/ai_icon, ai_icons)
	..()

/datum/ai_icon/red
	name = "Red"
	alive_icon = "ai-red"
	alive_light = "#F04848"
	dead_icon = "ai-red-crash"
	dead_light = "#F04848"

/datum/ai_icon/green
	name = "Green"
	alive_icon = "ai-wierd"
	alive_light = "#00FF99"
	dead_icon = "ai-weird-crash"

/datum/ai_icon/blue
	name = "Blue"
	alive_icon = "ai"
	alive_light = "#81DDFF"

/datum/ai_icon/angry
	name = "Angry"
	alive_icon = "ai-angryface"
	alive_light = "#FFFF33"

/datum/ai_icon/angel
	name = "Angel"
	alive_icon = "ai-angel"
	dead_icon = "ai-angel-crash"

/datum/ai_icon/bliss
	name = "Bliss"
	alive_icon = "ai-bliss"
	alive_light = "#5C7A4A"

/datum/ai_icon/chatterbox
	name = "Chatterbox"
	alive_icon = "ai-president"
	alive_light = "#40666B"

/datum/ai_icon/database
	name = "Database"
	alive_icon = "ai-database"
	dead_icon = "ai-database-crash"

/datum/ai_icon/dorf
	name = "Dorf"
	alive_icon = "ai-dorf"

/datum/ai_icon/dugtodeep
	name = "Dug Too Deep"
	alive_icon = "ai-toodeep"
	alive_light = "#81DDFF"

/datum/ai_icon/firewall
	name = "Firewall"
	alive_icon = "ai-magma"
	alive_light = "#FF4126"

/datum/ai_icon/glitchman
	name = "Glitchman"
	alive_icon = "ai-glitchman"
	dead_icon = "ai-glitchman-crash"

/datum/ai_icon/goon
	name = "Goon"
	alive_icon = "ai-goon"
	alive_light = "#3E5C80"
	dead_icon = "ai-goon-crash"
	dead_light = "#3E5C80"

/datum/ai_icon/heartline
	name = "Heartline"
	alive_icon = "ai-heartline"
	dead_icon = "ai-heartline-crash"

/datum/ai_icon/helios
	name = "Helios"
	alive_icon = "ai-helios"
	alive_light = "#F2CF73"

/datum/ai_icon/hourglass
	name = "Hourglass"
	alive_icon = "ai-hourglass"

/datum/ai_icon/inverted
	name = "Inverted"
	alive_icon = "ai-u"
	alive_light = "#81DDFF"
	dead_icon = "ai-u-crash"

/datum/ai_icon/lonestar
	name = "Lonestar"
	alive_icon = "ai-lonestar"
	alive_light = "#58751C"
	dead_icon = "ai-lonestar-crash"

/datum/ai_icon/matrix
	name = "Matrix"
	alive_icon = "ai-matrix"
	alive_light = "#449944"

/datum/ai_icon/monochrome
	name = "Monochrome"
	alive_icon = "ai-mono"
	alive_light = "#585858"
	dead_icon = "ai-mono-crash"

/datum/ai_icon/nanotrasen
	name = "NanoTrasen"
	alive_icon = "ai-nanotrasen"
	alive_light = "#000029"

/datum/ai_icon/rainbow
	name = "Rainbow"
	alive_icon = "ai-clown"
	alive_light = "#E50213"

/datum/ai_icon/smiley
	name = "Smiley"
	alive_icon = "ai-smiley"
	alive_light = "#F3DD00"

/datum/ai_icon/soviet
	name = "Soviet"
	alive_icon = "ai-soviet"
	alive_light = "#FF4307"
	dead_icon = "ai-soviet-crash"
	dead_light = "#FF4307"

/datum/ai_icon/Static
	name = "Static"
	alive_icon = "ai-static"
	alive_light = "#4784C1"
	alive_icon = "ai-static-crash"

/datum/ai_icon/text
	name = "Text"
	alive_icon = "ai-text"

/datum/ai_icon/trapped
	name = "Trapped"
	alive_icon = "ai-hades"
	dead_icon = "ai-hades-crash"

/datum/ai_icon/triumvirate
	name = "Triumvirate"
	alive_icon = "ai-triumvirate"
	alive_light = "#020B2B"

/datum/ai_icon/triumvirate_static
	name = "Triumvirate Static"
	alive_icon = "ai-triumvirate-malf"
	alive_light = "#020B2B"

/datum/ai_icon/bored
	name = "Bored"
	alive_icon = "ai-bored"
	dead_icon = "ai-eager-crash"

//Eros Research Platform Ports

/datum/ai_icon/clown2
	name = "Honk"
	alive_icon = "ai-clown2"
	dead_icon = "ai-clown2-crash"

/*
/datum/ai_icon/boxfort
	name = "Boxfort"
	alive_icon = "ai-boxfort"
	dead_icon = "ai-boxfort_dead"
*/

/datum/ai_icon/ravensdale
	name = "Integration"
	alive_icon = "ai-ravensdale"
	dead_icon = "ai-ravensdale-crash"

/datum/ai_icon/gentoo
	name = "Gentoo"
	alive_icon = "ai-gentoo"
	dead_icon = "ai-gentoo-crash"

/datum/ai_icon/serithi
	name = "Mechanicus"
	alive_icon = "ai-serithi"
	dead_icon = "ai-serithi-crash"

/*
/datum/ai_icon/alien
	name = "Xenomorph"
	alive_icon = "ai-alien"
	dead_icon = "ai-alien-crash"
*/

/datum/ai_icon/syndicat
	name = "Syndi-cat"
	alive_icon = "ai-syndicatmeow"

/datum/ai_icon/wasp
	name = "Wasp"
	alive_icon = "ai-wasp"

/datum/ai_icon/sheltered
	name = "Doctor"
	alive_icon = "ai-sheltered"

/datum/ai_icon/fabulous
	name = "Fabulous"
	alive_icon = "ai-fabulous"

/datum/ai_icon/eager
	name = "Eager"
	alive_icon = "ai-eager"
	dead_icon = "ai-eager-crash"

/datum/ai_icon/royal
	name = "Royal"
	alive_icon = "ai-royal"

/datum/ai_icon/pirate
	name = "Pirate"
	alive_icon = "ai-pirate"

/datum/ai_icon/bloodylove
	name = "Love"
	alive_icon = "ai-bloodylove"

/datum/ai_icon/ahasuerus
	name = "Ahasuerus"
	alive_icon = "ai-ahasuerus"

/datum/ai_icon/godfrey
	name = "Godfrey"
	alive_icon = "ai-godfrey"
