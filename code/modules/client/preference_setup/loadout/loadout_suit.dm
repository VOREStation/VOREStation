// Suit slot
/datum/gear/suit
	display_name = "apron, blue"
	path = /obj/item/clothing/suit/storage/apron
	slot = slot_wear_suit
	sort_category = "Suits and Overwear"
	cost = 1

/datum/gear/suit/apron_white
	display_name = "apron, colorable"
	path = /obj/item/clothing/suit/storage/apron/white

/datum/gear/suit/apron_white/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/suit/greatcoat
	display_name = "greatcoat"
	path = /obj/item/clothing/suit/greatcoat

/datum/gear/suit/leather_coat
	display_name = "leather coat"
	path = /obj/item/clothing/suit/leathercoat

/datum/gear/suit/puffer_coat
	display_name = "puffer coat"
	path = /obj/item/clothing/suit/jacket/puffer

/datum/gear/suit/puffer_vest
	display_name = "puffer vest"
	path = /obj/item/clothing/suit/jacket/puffer/vest

/datum/gear/suit/bomber
	display_name = "bomber jacket selection"
	description = "Pick from a small selection of bomber jackets."
	path = /obj/item/clothing/suit/storage/toggle/bomber

/datum/gear/suit/bomber/New()
	..()
	var/list/selector_uniforms = list(
		"classic"=/obj/item/clothing/suit/storage/toggle/bomber,
		"classic alternative"=/obj/item/clothing/suit/storage/bomber,
		"retro"=/obj/item/clothing/suit/storage/toggle/bomber/retro
	)
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(selector_uniforms))

/datum/gear/suit/leather_jacket
	display_name = "leather jacket and vest selection"
	description = "Pick from a wide variety of leather vests and jackets."
	path = /obj/item/clothing/suit/storage/toggle/leather_jacket

/datum/gear/suit/leather_jacket/New()
	..()
	var/list/selector_uniforms = list(
		"black jacket"=/obj/item/clothing/suit/storage/toggle/leather_jacket,
		"black vest"=/obj/item/clothing/suit/storage/toggle/leather_jacket/sleeveless,
		"black jacket, alternative"=/obj/item/clothing/suit/storage/leather_jacket_alt,
		"black jacket, corporate"=/obj/item/clothing/suit/storage/toggle/leather_jacket/nanotrasen,
		"black vest, corporate"=/obj/item/clothing/suit/storage/toggle/leather_jacket/nanotrasen/sleeveless,
		"brown jacket"=/obj/item/clothing/suit/storage/toggle/brown_jacket,
		"brown vest"=/obj/item/clothing/suit/storage/toggle/brown_jacket/sleeveless,
		"brown jacket, corporate"=/obj/item/clothing/suit/storage/toggle/brown_jacket/nanotrasen,
		"brown vest, corporate"=/obj/item/clothing/suit/storage/toggle/brown_jacket/nanotrasen/sleeveless
	)
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(selector_uniforms))

/datum/gear/suit/mil
	display_name = "military jacket selection"
	description = "Pick from a modest range of military surplus jackets. They even have some pocket space!"
	path = /obj/item/clothing/suit/storage/miljacket

/datum/gear/suit/mil/New()
	..()
	var/list/mil_jackets = list()
	for(var/military_style in typesof(/obj/item/clothing/suit/storage/miljacket))
		var/obj/item/clothing/suit/storage/miljacket/miljacket = military_style
		mil_jackets[initial(miljacket.name)] = miljacket
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(mil_jackets))

/datum/gear/suit/greyjacket
	display_name = "grey jacket"
	path = /obj/item/clothing/suit/storage/greyjacket

/datum/gear/suit/brown_trenchcoat
	display_name = "trenchcoat, brown"
	path = /obj/item/clothing/suit/storage/trench

/datum/gear/suit/grey_trenchcoat
	display_name = "trenchcoat, grey"
	path = /obj/item/clothing/suit/storage/trench/grey

/datum/gear/suit/duster
	display_name = "cowboy duster, colorable"
	path = /obj/item/clothing/suit/storage/duster

/datum/gear/suit/duster/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/suit/hazard_vest
	display_name = "hazard vest selection"
	path = /obj/item/clothing/suit/storage/hazardvest

/datum/gear/suit/hazard_vest/New()
	..()
	var/list/hazards = list()
	for(var/hazard_style in typesof(/obj/item/clothing/suit/storage/hazardvest))
		if(hazard_style in typesof(/obj/item/clothing/suit/storage/hazardvest/fluff))	//VOREStation addition
			continue																	//VOREStation addition
		var/obj/item/clothing/suit/storage/hazardvest/hazardvest = hazard_style
		hazards[initial(hazardvest.name)] = hazardvest
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(hazards))

/datum/gear/suit/hoodie
	display_name = "hoodie selection"
	path = /obj/item/clothing/suit/storage/toggle/hoodie

/datum/gear/suit/hoodie/New()
	..()
	var/list/hoodies = list()
	for(var/hoodie_style in typesof(/obj/item/clothing/suit/storage/toggle/hoodie))
		var/obj/item/clothing/suit/storage/toggle/hoodie/hoodie = hoodie_style
		hoodies[initial(hoodie.name)] = hoodie
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(hoodies))

/datum/gear/suit/labcoat
	display_name = "labcoat selection, public"
	path = /obj/item/clothing/suit/storage/toggle/labcoat

/datum/gear/suit/labcoat/New()
	..()
	var/list/labcoats = list(
	"White labcoat" = /obj/item/clothing/suit/storage/toggle/labcoat,
	"Blue-edge labcoat" = /obj/item/clothing/suit/storage/toggle/labcoat/blue_edge,
	"Green labcoat" = /obj/item/clothing/suit/storage/toggle/labcoat/green,
	"Orange labcoat" = /obj/item/clothing/suit/storage/toggle/labcoat/orange,
	"Purple labcoat" = /obj/item/clothing/suit/storage/toggle/labcoat/purple,
	"Pink labcoat" = /obj/item/clothing/suit/storage/toggle/labcoat/pink,
	"Red labcoat" = /obj/item/clothing/suit/storage/toggle/labcoat/red,
	"Yellow labcoat" = /obj/item/clothing/suit/storage/toggle/labcoat/yellow
	)
	gear_tweaks += new/datum/gear_tweak/path(labcoats)

/datum/gear/suit/labcoat_cmo
	display_name = "labcoat selection, cmo"
	path = /obj/item/clothing/suit/storage/toggle/labcoat/cmo
	allowed_roles = list(JOB_CHIEF_MEDICAL_OFFICER)
	show_roles = FALSE

/datum/gear/suit/labcoat_cmo/New()
	..()
	var/list/labcoats = list(
	"CMO labcoat" = /obj/item/clothing/suit/storage/toggle/labcoat/cmo,
	"CMO labcoat (alt)" = /obj/item/clothing/suit/storage/toggle/labcoat/cmoalt,
	"CMO labcoat (modern)" = /obj/item/clothing/suit/storage/toggle/labcoat/modern/cmo
	)
	gear_tweaks += new/datum/gear_tweak/path(labcoats)

/datum/gear/suit/labcoat_emt
	display_name = "labcoat, EMT"
	path = /obj/item/clothing/suit/storage/toggle/labcoat/emt
	allowed_roles = list(JOB_MEDICAL_DOCTOR,JOB_CHIEF_MEDICAL_OFFICER,JOB_CHEMIST,JOB_PARAMEDIC,JOB_GENETICIST, JOB_PSYCHIATRIST)

/datum/gear/suit/labcoat_rd
	display_name = "labcoat, research director"
	path = /obj/item/clothing/suit/storage/toggle/labcoat/rd
	allowed_roles = list(JOB_RESEARCH_DIRECTOR)
	show_roles = FALSE

/datum/gear/suit/miscellaneous/labcoat
	display_name = "plague doctor's coat"
	path = /obj/item/clothing/suit/storage/toggle/labcoat/plaguedoctor

/datum/gear/suit/roles/surgical_apron
	display_name = "surgical apron"
	path = /obj/item/clothing/suit/surgicalapron
	allowed_roles = list(JOB_MEDICAL_DOCTOR,JOB_CHIEF_MEDICAL_OFFICER)

/datum/gear/suit/overalls
	display_name = "overalls"
	path = /obj/item/clothing/suit/storage/apron/overalls
	cost = 1

/datum/gear/suit/altevian_apron
	display_name = "crafters pride apron"
	path = /obj/item/clothing/suit/storage/apron/altevian
	cost = 1

/datum/gear/suit/cyberpunk
	display_name = "cyberpunk jacket"
	path = /obj/item/clothing/suit/cyberpunk
	cost = 2

/datum/gear/suit/puffycoat
	display_name = "puffy coat selection"
	description = "Pick from a few different colours of puffy coat."
	path = /obj/item/clothing/suit/storage/puffyblue

/datum/gear/suit/puffycoat/New()
	..()
	var/list/selector_uniforms = list(
		"blue"=/obj/item/clothing/suit/storage/puffyblue,
		"red"=/obj/item/clothing/suit/storage/puffyred,
		"purple"=/obj/item/clothing/suit/storage/puffypurple
	)
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(selector_uniforms))

/datum/gear/suit/poncho
	display_name = "poncho selection"
	path = /obj/item/clothing/accessory/poncho
	cost = 1

/datum/gear/suit/poncho/New()
	..()
	var/list/ponchos = list()
	for(var/poncho_style in (typesof(/obj/item/clothing/accessory/poncho) - typesof(/obj/item/clothing/accessory/poncho/roles)))
		var/obj/item/clothing/accessory/poncho/poncho = poncho_style
		ponchos[initial(poncho.name)] = poncho
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(ponchos))

/datum/gear/suit/roles/poncho
	display_name = "poncho selection, departments"
	path = /obj/item/clothing/accessory/poncho/roles/cargo
	cost = 1

/datum/gear/suit/roles/poncho/New()
	..()
	var/list/ponchos = list(
		"Cargo poncho" = /obj/item/clothing/accessory/poncho/roles/cargo,
		"Security poncho" = /obj/item/clothing/accessory/poncho/roles/security,
		"Medical poncho" = /obj/item/clothing/accessory/poncho/roles/medical,
		"Engineering poncho" = /obj/item/clothing/accessory/poncho/roles/engineering,
		"Science poncho" = /obj/item/clothing/accessory/poncho/roles/science
	)
	gear_tweaks += new/datum/gear_tweak/path(ponchos)

/datum/gear/suit/roles/cloak
	display_name = "cloak selection, departments"
	path = /obj/item/clothing/accessory/poncho/roles/cloak/cargo
	cost = 1

/datum/gear/suit/roles/cloak/New()
	..()
	var/list/cloaks = list(
		"Cargo cloak" = /obj/item/clothing/accessory/poncho/roles/cloak/cargo,
		"Mining cloak" = /obj/item/clothing/accessory/poncho/roles/cloak/mining,
		"Security cloak" = /obj/item/clothing/accessory/poncho/roles/cloak/security,
		"Service cloak" = /obj/item/clothing/accessory/poncho/roles/cloak/service,
		"Engineer cloak" = /obj/item/clothing/accessory/poncho/roles/cloak/engineer,
		"Atmos cloak" = /obj/item/clothing/accessory/poncho/roles/cloak/atmos,
		"Research cloak" = /obj/item/clothing/accessory/poncho/roles/cloak/research,
		"Medical cloak" = /obj/item/clothing/accessory/poncho/roles/cloak/medical
	)
	gear_tweaks += new/datum/gear_tweak/path(cloaks)

/datum/gear/suit/roles/cloak_hos
	display_name = "cloak, head of security"
	path = /obj/item/clothing/accessory/poncho/roles/cloak/hos
	allowed_roles = list(JOB_HEAD_OF_SECURITY)
	show_roles = FALSE
	cost = 1

/datum/gear/suit/roles/cloak_cmo
	display_name = "cloak, chief medical officer"
	path = /obj/item/clothing/accessory/poncho/roles/cloak/cmo
	allowed_roles = list(JOB_CHIEF_MEDICAL_OFFICER)
	show_roles = FALSE
	cost = 1

/datum/gear/suit/roles/cloak_ce
	display_name = "cloak, chief engineer"
	path = /obj/item/clothing/accessory/poncho/roles/cloak/ce
	allowed_roles = list(JOB_CHIEF_ENGINEER)
	show_roles = FALSE
	cost = 1

/datum/gear/suit/roles/cloak_rd
	display_name = "cloak, research director"
	path = /obj/item/clothing/accessory/poncho/roles/cloak/rd
	allowed_roles = list(JOB_RESEARCH_DIRECTOR)
	show_roles = FALSE
	cost = 1

/datum/gear/suit/roles/cloak_qm
	display_name = "cloak, quartermaster"
	path = /obj/item/clothing/accessory/poncho/roles/cloak/qm
	allowed_roles = list(JOB_QUARTERMASTER)
	show_roles = FALSE
	cost = 1

/datum/gear/suit/roles/cloak_captain
	display_name = "cloak, site manager"
	path = /obj/item/clothing/accessory/poncho/roles/cloak/captain
	allowed_roles = list(JOB_SITE_MANAGER)
	show_roles = FALSE
	cost = 1

/datum/gear/suit/roles/cloak_hop
	display_name = "cloak, head of personnel"
	path = /obj/item/clothing/accessory/poncho/roles/cloak/hop
	allowed_roles = list(JOB_HEAD_OF_PERSONNEL)
	show_roles = FALSE
	cost = 1

/datum/gear/suit/cloak_custom //A colorable cloak
	display_name = "cloak, colorable"
	path = /obj/item/clothing/accessory/poncho/roles/cloak/custom
	cost = 1

/datum/gear/suit/cloak_custom/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/suit/ranger_poncho
	display_name = "ranger poncho selection"
	path = /obj/item/clothing/accessory/poncho/roles/ranger
	cost = 1

/datum/gear/suit/ranger_poncho/New()
	..()
	var/list/ranger_ponchos = list(
		"red ranger poncho" = /obj/item/clothing/accessory/poncho/roles/ranger,
		"tan ranger poncho" = /obj/item/clothing/accessory/poncho/roles/ranger/tan,
		"gray ranger poncho" = /obj/item/clothing/accessory/poncho/roles/ranger/gray,
		"green ranger poncho" = /obj/item/clothing/accessory/poncho/roles/ranger/green,
		"blue ranger poncho" = /obj/item/clothing/accessory/poncho/roles/ranger/blue,
		"purple ranger poncho" = /obj/item/clothing/accessory/poncho/roles/ranger/purple,
		"orange ranger poncho" = /obj/item/clothing/accessory/poncho/roles/ranger/orange,
		"charcoal ranger poncho" = /obj/item/clothing/accessory/poncho/roles/ranger/charcoal,
		"white ranger poncho" = /obj/item/clothing/accessory/poncho/roles/ranger/snow
	)
	gear_tweaks += new/datum/gear_tweak/path(ranger_ponchos)

/datum/gear/suit/neo_ranger //colorable ranger poncho
	display_name = "ranger poncho, colorable"
	path = /obj/item/clothing/accessory/poncho/roles/neo_ranger
	cost = 1

/datum/gear/suit/neo_ranger/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/suit/unathi_robe
	display_name = "roughspun robe"
	path = /obj/item/clothing/suit/unathi/robe
	cost = 1

/datum/gear/suit/lawyer_jackets
	display_name = "suit jacket selection"
	path = /obj/item/clothing/suit/storage/toggle/internalaffairs

/datum/gear/suit/lawyer_jackets/New()
	..()
	var/list/jackets = list(
		"Black suit jacket" = /obj/item/clothing/suit/storage/toggle/internalaffairs,
		"Blue suit jacket" = /obj/item/clothing/suit/storage/toggle/lawyer/bluejacket,
		"Purple suit jacket" = /obj/item/clothing/suit/storage/toggle/lawyer/purpjacket
	)
	gear_tweaks += new/datum/gear_tweak/path(jackets)

/datum/gear/suit/suspenders
	display_name = "suspenders"
	path = /obj/item/clothing/suit/suspenders

/datum/gear/suit/forensics
	display_name = "forensics uniform selection"
	path = /obj/item/clothing/suit/storage/forensics/red/long
	allowed_roles = list(JOB_DETECTIVE)

/datum/gear/suit/forensics/New()
	..()
	var/list/uniforms = list(
		"Red, long uniform" = /obj/item/clothing/suit/storage/forensics/red/long,
		"Blue, long uniform" = /obj/item/clothing/suit/storage/forensics/blue/long,
		"Red, short uniform" = /obj/item/clothing/suit/storage/forensics/red,
		"Blue, short uniform" = /obj/item/clothing/suit/storage/forensics/blue
	)
	gear_tweaks += new/datum/gear_tweak/path(uniforms)

/datum/gear/suit/qm_coat
	display_name = "coat, quartermaster"
	path = /obj/item/clothing/suit/storage/qm
	allowed_roles = list(JOB_QUARTERMASTER)
	show_roles = FALSE

/datum/gear/suit/cargo_coat
	display_name = "coat, cargo tech"
	path = /obj/item/clothing/suit/storage/cargo
	allowed_roles = list(JOB_QUARTERMASTER,JOB_SHAFT_MINER,JOB_CARGO_TECHNICIAN,JOB_HEAD_OF_PERSONNEL)
	show_roles = FALSE

// winter coats go here
/datum/gear/suit/wintercoat
	display_name = "winter coat"
	path = /obj/item/clothing/suit/storage/hooded/wintercoat

/datum/gear/suit/wintercoat/captain
	display_name = "winter coat, site manager"
	path = /obj/item/clothing/suit/storage/hooded/wintercoat/captain
	allowed_roles = list(JOB_SITE_MANAGER)
	show_roles = FALSE

/datum/gear/suit/wintercoat/hop
	display_name = "winter coat, head of personnel"
	path = /obj/item/clothing/suit/storage/hooded/wintercoat/hop
	allowed_roles = list(JOB_HEAD_OF_PERSONNEL)
	show_roles = FALSE

/datum/gear/suit/wintercoat/security
	display_name = "winter coat, security"
	path = /obj/item/clothing/suit/storage/hooded/wintercoat/security
	allowed_roles = list(JOB_SECURITY_OFFICER, JOB_HEAD_OF_SECURITY, JOB_WARDEN, JOB_DETECTIVE)
	show_roles = FALSE

/datum/gear/suit/wintercoat/security/hos
	display_name = "winter coat, head of security"
	path = /obj/item/clothing/suit/storage/hooded/wintercoat/security/hos
	allowed_roles = list(JOB_HEAD_OF_SECURITY)
	show_roles = FALSE

/datum/gear/suit/wintercoat/medical
	display_name = "winter coat, medical"
	path = /obj/item/clothing/suit/storage/hooded/wintercoat/medical
	allowed_roles = list(JOB_MEDICAL_DOCTOR,JOB_CHIEF_MEDICAL_OFFICER,JOB_CHEMIST,JOB_PARAMEDIC,JOB_GENETICIST, JOB_PSYCHIATRIST)
	show_roles = FALSE

/datum/gear/suit/wintercoat/medical/alt
	display_name = "winter coat, medical alt"
	path = /obj/item/clothing/suit/storage/hooded/wintercoat/medical/alt
	allowed_roles = list(JOB_MEDICAL_DOCTOR,JOB_CHIEF_MEDICAL_OFFICER,JOB_CHEMIST,JOB_PARAMEDIC,JOB_GENETICIST, JOB_PSYCHIATRIST)
	show_roles = FALSE

/datum/gear/suit/wintercoat/medical/viro
	display_name = "winter coat, virologist"
	path = /obj/item/clothing/suit/storage/hooded/wintercoat/medical/viro
	allowed_roles = list(JOB_MEDICAL_DOCTOR,JOB_CHIEF_MEDICAL_OFFICER)
	show_roles = FALSE

/datum/gear/suit/wintercoat/medical/para
	display_name = "winter coat, paramedic"
	path = /obj/item/clothing/suit/storage/hooded/wintercoat/medical/para
	allowed_roles = list(JOB_MEDICAL_DOCTOR,JOB_CHIEF_MEDICAL_OFFICER,JOB_PARAMEDIC)
	show_roles = FALSE

/datum/gear/suit/wintercoat/medical/chemist
	display_name = "winter coat, chemist"
	path = /obj/item/clothing/suit/storage/hooded/wintercoat/medical/chemist
	allowed_roles = list(JOB_CHIEF_MEDICAL_OFFICER,JOB_CHEMIST)
	show_roles = FALSE

/datum/gear/suit/wintercoat/medical/cmo
	display_name = "winter coat, chief medical officer"
	path = /obj/item/clothing/suit/storage/hooded/wintercoat/medical/cmo
	allowed_roles = list(JOB_CHIEF_MEDICAL_OFFICER)
	show_roles = FALSE

/datum/gear/suit/wintercoat/medical/sar
	display_name = "winter coat, search and rescue"
	path = /obj/item/clothing/suit/storage/hooded/wintercoat/medical/sar
	allowed_roles = list(JOB_CHIEF_MEDICAL_OFFICER,JOB_PARAMEDIC)
	show_roles = FALSE

/datum/gear/suit/wintercoat/science
	display_name = "winter coat, science"
	path = /obj/item/clothing/suit/storage/hooded/wintercoat/science
	allowed_roles = list(JOB_RESEARCH_DIRECTOR,JOB_SCIENTIST, JOB_ROBOTICIST, JOB_XENOBIOLOGIST, JOB_XENOBOTANIST)
	show_roles = FALSE

/datum/gear/suit/wintercoat/science/robotics
	display_name = "winter coat, robotics"
	path = /obj/item/clothing/suit/storage/hooded/wintercoat/science/robotics
	allowed_roles = list(JOB_RESEARCH_DIRECTOR, JOB_ROBOTICIST)
	show_roles = FALSE

/datum/gear/suit/wintercoat/science/rd
	display_name = "winter coat, research director"
	path = /obj/item/clothing/suit/storage/hooded/wintercoat/science/rd
	allowed_roles = list(JOB_RESEARCH_DIRECTOR)
	show_roles = FALSE

/datum/gear/suit/wintercoat/engineering
	display_name = "winter coat, engineering"
	path = /obj/item/clothing/suit/storage/hooded/wintercoat/engineering
	allowed_roles = list(JOB_CHIEF_ENGINEER,JOB_ATMOSPHERIC_TECHNICIAN, JOB_ENGINEER)
	show_roles = FALSE

/datum/gear/suit/wintercoat/engineering/atmos
	display_name = "winter coat, atmospherics"
	path = /obj/item/clothing/suit/storage/hooded/wintercoat/engineering/atmos
	allowed_roles = list(JOB_CHIEF_ENGINEER, JOB_ATMOSPHERIC_TECHNICIAN)
	show_roles = FALSE

/datum/gear/suit/wintercoat/engineering/ce
	display_name = "winter coat, chief engineer"
	path = /obj/item/clothing/suit/storage/hooded/wintercoat/engineering/ce
	allowed_roles = list(JOB_CHIEF_ENGINEER)
	show_roles = FALSE

/datum/gear/suit/wintercoat/hydro
	display_name = "winter coat, hydroponics"
	path = /obj/item/clothing/suit/storage/hooded/wintercoat/hydro
	allowed_roles = list(JOB_BOTANIST, JOB_XENOBOTANIST)
	show_roles = FALSE

/datum/gear/suit/wintercoat/cargo
	display_name = "winter coat, cargo"
	path = /obj/item/clothing/suit/storage/hooded/wintercoat/cargo
	allowed_roles = list(JOB_QUARTERMASTER,JOB_CARGO_TECHNICIAN)
	show_roles = FALSE

/datum/gear/suit/wintercoat/miner
	display_name = "winter coat, mining"
	path = /obj/item/clothing/suit/storage/hooded/wintercoat/miner
	allowed_roles = list(JOB_SHAFT_MINER)
	show_roles = FALSE

/datum/gear/suit/wintercoat/cargo/qm
	display_name = "winter coat, quartermaster"
	path = /obj/item/clothing/suit/storage/hooded/wintercoat/cargo/qm
	allowed_roles = list(JOB_QUARTERMASTER)
	show_roles = FALSE

/datum/gear/suit/wintercoat/bar
	display_name = "winter coat, bartender"
	path = /obj/item/clothing/suit/storage/hooded/wintercoat/bar
	allowed_roles = list(JOB_BARTENDER)
	show_roles = FALSE

/datum/gear/suit/wintercoat/janitor
	display_name = "winter coat, janitor"
	path = /obj/item/clothing/suit/storage/hooded/wintercoat/janitor
	allowed_roles = list(JOB_JANITOR)
	show_roles = FALSE

/datum/gear/suit/wintercoat/aformal
	display_name = "winter coat, assistant formal"
	path = /obj/item/clothing/suit/storage/hooded/wintercoat/aformal

/datum/gear/suit/wintercoat/ratvar
	display_name = "winter coat, brassy"
	path = /obj/item/clothing/suit/storage/hooded/wintercoat/ratvar

/datum/gear/suit/wintercoat/narsie
	display_name = "winter coat, runed"
	path = /obj/item/clothing/suit/storage/hooded/wintercoat/narsie

/datum/gear/suit/wintercoat/cosmic
	display_name = "winter coat, cosmic"
	path = /obj/item/clothing/suit/storage/hooded/wintercoat/cosmic
// winter coats end here

/datum/gear/suit/runner
	display_name = "runner jacket"
	path = /obj/item/clothing/suit/runner

/datum/gear/suit/varsity
	display_name = "varsity jacket selection"
	path = /obj/item/clothing/suit/varsity

/datum/gear/suit/varsity/New()
	..()
	var/list/varsities = list()
	for(var/varsity_style in typesof(/obj/item/clothing/suit/varsity))
		var/obj/item/clothing/suit/varsity/varsity = varsity_style
		varsities[initial(varsity.name)] = varsity
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(varsities))

/datum/gear/suit/track
	display_name = "track jacket selection"
	path = /obj/item/clothing/suit/storage/toggle/track

/datum/gear/suit/track/New()
	..()
	var/list/tracks = list()
	for(var/track_style in typesof(/obj/item/clothing/suit/storage/toggle/track))
		var/obj/item/clothing/suit/storage/toggle/track/track = track_style
		tracks[initial(track.name)] = track
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(tracks))

/datum/gear/suit/flannel
	display_name = "flannel jacket selection"
	path = /obj/item/clothing/suit/storage/flannel

/datum/gear/suit/flannel/New()
	..()
	var/list/flannel = list(
		"Grey flannel" = /obj/item/clothing/suit/storage/flannel,
		"Red flannel" = /obj/item/clothing/suit/storage/flannel/red,
		"Aqua flannel" = /obj/item/clothing/suit/storage/flannel/aqua,
		"Brown flannel" = /obj/item/clothing/suit/storage/flannel/brown
	)
	gear_tweaks += new/datum/gear_tweak/path(flannel)

/datum/gear/suit/flannelrecolour
	display_name = "flannel jacket, recolourable"
	path = /obj/item/clothing/suit/storage/flannel/recolour

/datum/gear/suit/flannelrecolour/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/suit/denim_jacket
	display_name = "denim jacket and vest selection"
	description = "Select from a small range of denim jackets and vests."
	path = /obj/item/clothing/suit/storage/toggle/denim_jacket

/datum/gear/suit/denim_jacket/New()
	..()
	var/list/selector_uniforms = list(
		"denim jacket"=/obj/item/clothing/suit/storage/toggle/denim_jacket,
		"denim jacket, corporate"=/obj/item/clothing/suit/storage/toggle/denim_jacket/nanotrasen,
		"denim vest"=/obj/item/clothing/suit/storage/toggle/denim_jacket/sleeveless,
		"denim vest, corporate"=/obj/item/clothing/suit/storage/toggle/denim_jacket/nanotrasen/sleeveless
	)
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(selector_uniforms))

/datum/gear/suit/miscellaneous/dep_jacket
	display_name = "department jacket selection"
	path = /obj/item/clothing/suit/storage/toggle/sec_dep_jacket

/datum/gear/suit/miscellaneous/dep_jacket/New()
	..()
	var/list/jacket = list(
		"Security department jacket" = /obj/item/clothing/suit/storage/toggle/sec_dep_jacket,
		"Engineering department jacket" = /obj/item/clothing/suit/storage/toggle/engi_dep_jacket,
		"Cargo department jacket" = /obj/item/clothing/suit/storage/toggle/supply_dep_jacket,
		"Science department jacket" = /obj/item/clothing/suit/storage/toggle/sci_dep_jacket,
		"Medical department jacket" = /obj/item/clothing/suit/storage/toggle/med_dep_jacket
	)
	gear_tweaks += new/datum/gear_tweak/path(jacket)

/datum/gear/suit/miscellaneous/light_jacket
	display_name = "light jacket selection"
	path = /obj/item/clothing/suit/storage/toggle/light_jacket

/datum/gear/suit/miscellaneous/light_jacket/New()
	..()
	var/list/jacket = list(
		"grey light jacket" = /obj/item/clothing/suit/storage/toggle/light_jacket,
		"dark blue light jacket" = /obj/item/clothing/suit/storage/toggle/light_jacket/blue
	)
	gear_tweaks += new/datum/gear_tweak/path(jacket)

/datum/gear/suit/miscellaneous/peacoat
	display_name = "peacoat, colorable"
	path = /obj/item/clothing/suit/storage/toggle/peacoat

/datum/gear/suit/miscellaneous/peacoat/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/suit/snowsuit
	display_name = "snowsuit"
	path = /obj/item/clothing/suit/storage/snowsuit

/datum/gear/suit/snowsuit/command
	display_name = "snowsuit, command"
	path = /obj/item/clothing/suit/storage/snowsuit/command
	allowed_roles = list(JOB_SITE_MANAGER,JOB_RESEARCH_DIRECTOR,JOB_HEAD_OF_PERSONNEL,JOB_HEAD_OF_SECURITY,JOB_CHIEF_ENGINEER,JOB_COMMAND_SECRETARY)
	show_roles = FALSE

/datum/gear/suit/snowsuit/security
	display_name = "snowsuit, security"
	path = /obj/item/clothing/suit/storage/snowsuit/security
	allowed_roles = list(JOB_SECURITY_OFFICER, JOB_HEAD_OF_SECURITY, JOB_WARDEN, JOB_DETECTIVE)
	show_roles = FALSE

/datum/gear/suit/snowsuit/medical
	display_name = "snowsuit, medical"
	path = /obj/item/clothing/suit/storage/snowsuit/medical
	allowed_roles = list(JOB_MEDICAL_DOCTOR,JOB_CHIEF_MEDICAL_OFFICER,JOB_CHEMIST,JOB_PARAMEDIC,JOB_GENETICIST, JOB_PSYCHIATRIST, JOB_ALT_SEARCH_AND_RESCUE)
	show_roles = FALSE

/datum/gear/suit/snowsuit/science
	display_name = "snowsuit, science"
	path = /obj/item/clothing/suit/storage/snowsuit/science
	allowed_roles = list(JOB_RESEARCH_DIRECTOR,JOB_SCIENTIST, JOB_ROBOTICIST, JOB_XENOBIOLOGIST)
	show_roles = FALSE

/datum/gear/suit/snowsuit/engineering
	display_name = "snowsuit, engineering"
	path = /obj/item/clothing/suit/storage/snowsuit/engineering
	allowed_roles = list(JOB_CHIEF_ENGINEER,JOB_ATMOSPHERIC_TECHNICIAN, JOB_ENGINEER)
	show_roles = FALSE

/datum/gear/suit/snowsuit/cargo
	display_name = "snowsuit, supply"
	path = /obj/item/clothing/suit/storage/snowsuit/cargo
	allowed_roles = list(JOB_QUARTERMASTER,JOB_SHAFT_MINER,JOB_CARGO_TECHNICIAN,JOB_HEAD_OF_PERSONNEL)
	show_roles = FALSE

/datum/gear/suit/miscellaneous/cardigan
	display_name = "cardigan, colorable"
	path = /obj/item/clothing/suit/storage/toggle/cardigan

/datum/gear/suit/miscellaneous/cardigan/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/suit/cmddressjacket
	display_name = "command dress jacket"
	path = /obj/item/clothing/suit/storage/toggle/cmddressjacket
	allowed_roles = list(JOB_SITE_MANAGER, JOB_HEAD_OF_PERSONNEL, JOB_COMMAND_SECRETARY)
	show_roles = FALSE

/datum/gear/suit/miscellaneous/kimono
	display_name = "traditional kimono, colorable"
	path = /obj/item/clothing/suit/kimono

/datum/gear/suit/miscellaneous/kimono/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/suit/miscellaneous/kamishimo
	display_name = "traditional kamishimo, colorable"
	path = /obj/item/clothing/suit/kamishimo

/datum/gear/suit/miscellaneous/kamishimo/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/suit/miscellaneous/kimono_select
	display_name = "kimono selection"
	path = /obj/item/clothing/suit/kimono/red

/datum/gear/suit/miscellaneous/kimono_select/New()
	..()
	var/list/kimonos = list(
	"Red kimono" = /obj/item/clothing/suit/kimono/red,
	"Orange kimono" = /obj/item/clothing/suit/kimono/orange,
	"Yellow kimono" = /obj/item/clothing/suit/kimono/yellow,
	"Green kimono" = /obj/item/clothing/suit/kimono/green,
	"Blue kimono" = /obj/item/clothing/suit/kimono/blue,
	"Purple kimono" = /obj/item/clothing/suit/kimono/purple,
	"Violet kimono" = /obj/item/clothing/suit/kimono/violet,
	"Pink kimono" = /obj/item/clothing/suit/kimono/pink,
	"Earth kimono" = /obj/item/clothing/suit/kimono/earth
	)
	gear_tweaks += new/datum/gear_tweak/path(kimonos)

//cropped hoodies
/datum/gear/suit/roles/croppedhoodies
	display_name = "cropped hoodie selection"
	path = /obj/item/clothing/suit/storage/croppedhoodie

/datum/gear/suit/roles/croppedhoodies/New()
	..()
	var/list/croppedhoodies = list(
		"cropped hoodie"=/obj/item/clothing/suit/storage/croppedhoodie,
		"high cropped hoodie"=/obj/item/clothing/suit/storage/croppedhoodie/croppier,
		"very high cropped hoodie"=/obj/item/clothing/suit/storage/croppedhoodie/croppierer,
		"super high cropped hoodie"=/obj/item/clothing/suit/storage/croppedhoodie/croppiest
	)
	gear_tweaks += gear_tweak_free_color_choice
	gear_tweaks += new/datum/gear_tweak/path(croppedhoodies)

/datum/gear/suit/drive
    display_name = "relatable jacket"
    path = /obj/item/clothing/suit/storage/drive

/datum/gear/suit/motojacket
    display_name = "motorcycle jacket"
    path = /obj/item/clothing/suit/storage/toggle/moto_jacket

/datum/gear/suit/punkvest
    display_name = "punk vest"
    path = /obj/item/clothing/suit/storage/punkvest

/datum/gear/suit/raincoat
    display_name = "raincoat"
    path = /obj/item/clothing/suit/storage/hooded/raincoat

//hooded cloaks
/datum/gear/suit/roles/hoodedcloaks
	display_name = "hooded cloak selection"
	path = /obj/item/clothing/suit/storage/hooded/cloak

/datum/gear/suit/roles/hoodedcloaks/New()
	..()
	var/list/hoodedcloaks = list(
		"hooded maroon cloak"=/obj/item/clothing/suit/storage/hooded/cloak,
		"hooded winter cloak"=/obj/item/clothing/suit/storage/hooded/cloak/winter,
		"hooded asymmetric cloak"=/obj/item/clothing/suit/storage/hooded/cloak/asymmetric,
		"hooded fancy cloak"=/obj/item/clothing/suit/storage/hooded/cloak/fancy
	)
	gear_tweaks += new/datum/gear_tweak/path(hoodedcloaks)

//oversized shirts
/datum/gear/suit/nerdshirt
    display_name = "nerdy shirt"
    path = /obj/item/clothing/suit/nerdshirt

/datum/gear/suit/ianshirt
    display_name = "worn corgi shirt"
    path = /obj/item/clothing/suit/ianshirt

/datum/gear/suit/wornshirt
    display_name = "worn shirt"
    path = /obj/item/clothing/suit/wornshirt

/datum/gear/suit/bomber_pilot
	display_name = "bomber jacket, pilot"
	path = /obj/item/clothing/suit/storage/toggle/bomber/pilot

/datum/gear/suit/snowsuit/medical
	allowed_roles = list(JOB_MEDICAL_DOCTOR,JOB_CHIEF_MEDICAL_OFFICER,JOB_CHEMIST,JOB_PARAMEDIC,JOB_GENETICIST, JOB_PSYCHIATRIST)

/datum/gear/suit/labcoat_colorable
	display_name = "labcoat, colorable"
	path = /obj/item/clothing/suit/storage/toggle/labcoat

/datum/gear/suit/labcoat_colorable/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/suit/labcoat_old
	display_name = "labcoat, old-school"
	path = /obj/item/clothing/suit/storage/toggle/labcoat/old

/datum/gear/suit/labcoat_cmo_old
	display_name = "labcoat, CMO, oldschool"
	path = /obj/item/clothing/suit/storage/toggle/labcoat/old/cmo
	allowed_roles = list(JOB_CHIEF_MEDICAL_OFFICER)

/datum/gear/suit/roles/labcoat_old
	display_name = "labcoat selection, department, oldschool"
	path = /obj/item/clothing/suit/storage/toggle/labcoat/old/tox

/datum/gear/suit/roles/labcoat_old/New()
	..()
	var/list/labcoats = list(
	"Oldschool Scientist's Labcoat" = /obj/item/clothing/suit/storage/toggle/labcoat/old/tox,
	"Oldschool Virologist's Labcoat" = /obj/item/clothing/suit/storage/toggle/labcoat/old/vir,
	"Oldschool Chemist's Labcoat" = /obj/item/clothing/suit/storage/toggle/labcoat/old/chem
	)
	gear_tweaks += new/datum/gear_tweak/path(labcoats)

/datum/gear/suit/jacket_modular
	display_name = "jacket, modular"
	path = /obj/item/clothing/suit/storage/fluff/jacket

/datum/gear/suit/jacket_modular/New()
	..()
	var/list/the_jackets = list()
	for(var/the_jacket in typesof(/obj/item/clothing/suit/storage/fluff/jacket))
		var/obj/item/clothing/suit/jacket_type = the_jacket
		the_jackets[initial(jacket_type.name)] = jacket_type
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(the_jackets))

/datum/gear/suit/gntop
	display_name = "GN crop jacket"
	path = /obj/item/clothing/suit/storage/fluff/gntop

/datum/gear/suit/old_poncho //This is made from an old sprite which has been here for quite some time. Called old poncho because duplicates
	display_name = "Colorful poncho"
	description = "A Mexican looking poncho. It look like it fits wolf taurs as well."
	path = /obj/item/clothing/suit/poncho

//Detective alternative
/datum/gear/suit/detective_alt
	display_name = "sleek modern coat selection"
	path = /obj/item/clothing/suit/storage/det_trench/alt
	allowed_roles = list(JOB_HEAD_OF_SECURITY, JOB_DETECTIVE)

/datum/gear/suit/detective_alt/New()
	..()
	var/list/coats = list(
		"Modern coat (tan)" = /obj/item/clothing/suit/storage/det_trench/alt,
		"Modern coat (long, tan)" = /obj/item/clothing/suit/storage/det_trench/alt2,
		"Modern coat (black)" = /obj/item/clothing/suit/storage/det_trench/alt/black,
		"Modern coat (long, black)" = /obj/item/clothing/suit/storage/det_trench/alt2/black
	)
	gear_tweaks += new/datum/gear_tweak/path(coats)

//EMT coats, jackets and vest
/datum/gear/suit/paramedic_coat
	display_name = "paramedic outerwear selection"
	path = /obj/item/clothing/suit/storage/toggle/fr_jacket
	allowed_roles = list(JOB_CHIEF_MEDICAL_OFFICER,JOB_PARAMEDIC,JOB_MEDICAL_DOCTOR)

/datum/gear/suit/paramedic_coat/New()
	..()
	var/list/paramedicCoats = list(
		"First responder jacket" = /obj/item/clothing/suit/storage/toggle/fr_jacket,
		"First responder jacket, alt." = /obj/item/clothing/suit/storage/toggle/fr_jacket/ems,
		"Paramedic vest" = /obj/item/clothing/suit/storage/toggle/paramedic,
		"EMT's labcoat" = /obj/item/clothing/suit/storage/toggle/labcoat/neo_emt,
		"High visibility jacket" = /obj/item/clothing/suit/storage/toggle/labcoat/neo_highvis,
		"Red EMT jacket" = /obj/item/clothing/suit/storage/toggle/labcoat/neo_redemt,
		"Dark Blue EMT jacket" = /obj/item/clothing/suit/storage/toggle/labcoat/neo_blueemt
	)
	gear_tweaks += new/datum/gear_tweak/path(paramedicCoats)

//greek thing
/datum/gear/suit/chiton
	display_name = "chiton"
	path = /obj/item/clothing/suit/chiton

//oversized t-shirt
/datum/gear/suit/oversize
	display_name = "oversized t-shirt (colorable)"
	path = /obj/item/clothing/suit/oversize

/datum/gear/suit/oversize/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice

/*
Talon winter coat
*/
/datum/gear/suit/wintercoat/talon
	display_name = "winter coat, Talon"
	path = /obj/item/clothing/suit/storage/hooded/wintercoat/talon

/datum/gear/suit/armor/combat/crusader_explo
	display_name = "knight, explo"
	path = /obj/item/clothing/suit/armor/combat/crusader_explo
	//allowed_roles = list(JOB_EXPLORER,JOB_PATHFINDER)

/datum/gear/suit/armor/combat/crusader_explo/FM
	display_name = "knight, Field Medic"
	path = /obj/item/clothing/suit/armor/combat/crusader_explo/FM
	allowed_roles = list (JOB_PARAMEDIC)

//Long fur coat
/datum/gear/suit/russofurcoat
	display_name = "long fur coat"
	path = /obj/item/clothing/suit/storage/vest/hoscoat/russofurcoat

//Colorable Hoodie
/datum/gear/suit/hoodie_vr
	display_name = "hoodie with hood (colorable)"
	path = /obj/item/clothing/suit/storage/hooded/hoodie

/datum/gear/suit/hoodie_vr/New()
	..()
	var/list/hoodies = list()
	for(var/hoodie_style in typesof(/obj/item/clothing/suit/storage/hooded/hoodie))
		var/obj/item/clothing/suit/storage/toggle/hoodie/hoodie = hoodie_style
		hoodies[initial(hoodie.name)] = hoodie
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(hoodies))
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/suit/cyberpunk_recolorable
	display_name = "cyberpunk jacket (recolorable)"
	path = /obj/item/clothing/suit/cyberpunk/recolorable
	cost = 2 //It's got armor, yo.

/datum/gear/suit/cyberpunk_recolorable/New()
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/suit/shrine_maiden
	display_name = "shrine maiden costume"
	path = /obj/item/clothing/suit/shrine_maiden

//Antediluvian cloak
/datum/gear/suit/cloak_ante
	display_name = "cloak, antediluvian"
	path = /obj/item/clothing/accessory/poncho/roles/cloak/antediluvian
	cost = 1

//Chaplain cloaks
/datum/gear/suit/cloak_chaplain
	display_name = "cloak, chaplain"
	path = /obj/item/clothing/accessory/poncho/roles/cloak/chapel
	cost = 1

/datum/gear/suit/cloak_chaplain/alt
	display_name = "cloak, chaplain, alt"
	path = /obj/item/clothing/accessory/poncho/roles/cloak/chapel/alt
	cost = 1

//Half cloak
/datum/gear/suit/cloak_half
	display_name = "cloak, half, colorable"
	path = /obj/item/clothing/accessory/poncho/roles/cloak/half
	cost = 1

/datum/gear/suit/cloak_half/New()
	gear_tweaks += gear_tweak_free_color_choice

//Shoulder cloak
/datum/gear/suit/cloak_shoulder
	display_name = "cloak, shoulder"
	path = /obj/item/clothing/accessory/poncho/roles/cloak/shoulder
	cost = 1

/datum/gear/suit/cloak_shoulder/New()
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/suit/cloak_shoulder_right
	display_name = "cloak, shoulder right"
	path = /obj/item/clothing/accessory/poncho/roles/cloak/shoulder/right
	cost = 1

/datum/gear/suit/cloak_shoulder_right/New()
	gear_tweaks += gear_tweak_free_color_choice

//Mantles, mostly for heads of staff
/datum/gear/suit/roles/mantle
	display_name = "mantle, colorable"
	path = /obj/item/clothing/accessory/poncho/roles/cloak/mantle
	cost = 1

/datum/gear/suit/roles/mantle/New()
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/suit/roles/mantles
	display_name = "mantle selection"
	path = /obj/item/clothing/accessory/poncho/roles/cloak/mantle/cargo
	cost = 1

/datum/gear/suit/roles/mantles/New()
	..()
	var/list/mantles = list(
		"orange mantle"=/obj/item/clothing/accessory/poncho/roles/cloak/mantle/cargo,
		"black mantle"=/obj/item/clothing/accessory/poncho/roles/cloak/mantle/security,
		"white mantle"=/obj/item/clothing/accessory/poncho/roles/cloak/mantle/engineering,
		"purple mantle"=/obj/item/clothing/accessory/poncho/roles/cloak/mantle/research,
		"cyan mantle"=/obj/item/clothing/accessory/poncho/roles/cloak/mantle/medical,
		"blue mantle"=/obj/item/clothing/accessory/poncho/roles/cloak/mantle/hop,
		"gold mantle"=/obj/item/clothing/accessory/poncho/roles/cloak/mantle/cap
	)
	gear_tweaks += new/datum/gear_tweak/path(mantles)

//Boat cloaks
/datum/gear/suit/roles/boatcloak
	display_name = "boat cloak, colorable"
	path = /obj/item/clothing/accessory/poncho/roles/cloak/boat

/datum/gear/suit/roles/boatcloak/New()
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/suit/roles/capboatcloak
	display_name = "boat cloak, site manager"
	path = /obj/item/clothing/accessory/poncho/roles/cloak/boat/cap
	allowed_roles = list(JOB_SITE_MANAGER)
	show_roles = FALSE

/datum/gear/suit/roles/hopboatcloak
	display_name = "boat cloak, head of personnel"
	path = /obj/item/clothing/accessory/poncho/roles/cloak/boat/hop
	allowed_roles = list(JOB_HEAD_OF_PERSONNEL)
	show_roles = FALSE

/datum/gear/suit/roles/boatcloaks
	display_name = "boat cloak selection"
	path = /obj/item/clothing/accessory/poncho/roles/cloak/boat/security

/datum/gear/suit/roles/boatcloaks/New()
	..()
	var/list/boatcloaks = list(
		"security boat cloak"=/obj/item/clothing/accessory/poncho/roles/cloak/boat/security,
		"engineering boat cloak"=/obj/item/clothing/accessory/poncho/roles/cloak/boat/engineering,
		"atmospherics boat cloak"=/obj/item/clothing/accessory/poncho/roles/cloak/boat/atmos,
		"medical boat cloak"=/obj/item/clothing/accessory/poncho/roles/cloak/boat/medical,
		"service boat cloak"=/obj/item/clothing/accessory/poncho/roles/cloak/boat/service,
		"cargo boat cloak"=/obj/item/clothing/accessory/poncho/roles/cloak/boat/cargo,
		"mining boat cloak"=/obj/item/clothing/accessory/poncho/roles/cloak/boat/mining,
		"research boat cloak"=/obj/item/clothing/accessory/poncho/roles/cloak/boat/science
	)
	gear_tweaks += new/datum/gear_tweak/path(boatcloaks)

//Shrouds
/datum/gear/suit/roles/shroud
	display_name = "shroud, colorable"
	path = /obj/item/clothing/accessory/poncho/roles/cloak/shroud

/datum/gear/suit/roles/shroud/New()
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/suit/roles/capshroud
	display_name = "shroud, site manager"
	path = /obj/item/clothing/accessory/poncho/roles/cloak/shroud/cap
	allowed_roles = list(JOB_SITE_MANAGER)
	show_roles = FALSE

/datum/gear/suit/roles/hopshroud
	display_name = "shroud, head of personnel"
	path = /obj/item/clothing/accessory/poncho/roles/cloak/shroud/hop
	allowed_roles = list(JOB_HEAD_OF_PERSONNEL)
	show_roles = FALSE

/datum/gear/suit/roles/shrouds
	display_name = "shroud selection"
	path = /obj/item/clothing/accessory/poncho/roles/cloak/shroud/security

/datum/gear/suit/roles/shrouds/New()
	..()
	var/list/shrouds = list(
		"security shroud"=/obj/item/clothing/accessory/poncho/roles/cloak/shroud/security,
		"engineering shroud"=/obj/item/clothing/accessory/poncho/roles/cloak/shroud/engineering,
		"atmospherics shroud"=/obj/item/clothing/accessory/poncho/roles/cloak/shroud/atmos,
		"medical shroud"=/obj/item/clothing/accessory/poncho/roles/cloak/shroud/medical,
		"service shroud"=/obj/item/clothing/accessory/poncho/roles/cloak/shroud/service,
		"cargo shroud"=/obj/item/clothing/accessory/poncho/roles/cloak/shroud/cargo,
		"mining shroud"=/obj/item/clothing/accessory/poncho/roles/cloak/shroud/mining,
		"research shroud"=/obj/item/clothing/accessory/poncho/roles/cloak/shroud/science
	)
	gear_tweaks += new/datum/gear_tweak/path(shrouds)

/datum/gear/suit/roles/cropjackets
	display_name = "crop jacket selection"
	path = /obj/item/clothing/accessory/poncho/roles/cloak/crop_jacket

/datum/gear/suit/roles/cropjackets/New()
	..()
	var/list/shrouds = list(
		"white crop jacket"=/obj/item/clothing/accessory/poncho/roles/cloak/crop_jacket,
		"blue crop jacket"=/obj/item/clothing/accessory/poncho/roles/cloak/crop_jacket/blue,
		"red crop jacket"=/obj/item/clothing/accessory/poncho/roles/cloak/crop_jacket/red,
		"green crop jacket"=/obj/item/clothing/accessory/poncho/roles/cloak/crop_jacket/green,
		"purple crop jacket"=/obj/item/clothing/accessory/poncho/roles/cloak/crop_jacket/purple,
		"orange crop jacket"=/obj/item/clothing/accessory/poncho/roles/cloak/crop_jacket/orange,
		"charcoal crop jacket"=/obj/item/clothing/accessory/poncho/roles/cloak/crop_jacket/charcoal,
		"faded reflec crop jacket"=/obj/item/clothing/accessory/poncho/roles/cloak/crop_jacket/marine,
		"drab crop jacket"=/obj/item/clothing/accessory/poncho/roles/cloak/crop_jacket/drab
	)
	gear_tweaks += new/datum/gear_tweak/path(shrouds)

//Actually colorable hoodies
/datum/gear/suit/roles/choodies
	display_name = "hoodie selection, colorable"
	path = /obj/item/clothing/suit/storage/hooded/toggle/colorable

/datum/gear/suit/roles/choodies/New()
	..()
	var/list/choodies = list(
		"normal hoodie"=/obj/item/clothing/suit/storage/hooded/toggle/colorable,
		"sleeveless hoodie"=/obj/item/clothing/suit/storage/hooded/toggle/colorable/sleeveless,
		"cropped hoodie"=/obj/item/clothing/suit/storage/hooded/toggle/colorable/cropped,
		"shortsleeve hoodie"=/obj/item/clothing/suit/storage/hooded/toggle/colorable/shortsleeve
	)
	gear_tweaks += gear_tweak_free_color_choice
	gear_tweaks += new/datum/gear_tweak/path(choodies)

//ABOUT TIME SOMEONE ADDED THIS TO A LOADOUT
/datum/gear/suit/bladerunnercoat
	display_name = "leather coat, massive"
	path = /obj/item/clothing/suit/storage/bladerunner

/datum/gear/suit/martianminer
	display_name = "martian miner's coat, basic"
	path = /obj/item/clothing/suit/storage/vest/martian_miner

//Formerly my custom fluff gear, but free to use for anyone, now.
/datum/gear/suit/purple_robes
	display_name = "purple robes"
	path = /obj/item/clothing/suit/fluff/purp_robes

/datum/gear/suit/pirate_coat
	display_name = "pirate coat"
	path = /obj/item/clothing/suit/pirate
