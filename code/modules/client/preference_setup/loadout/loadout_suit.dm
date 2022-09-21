// Suit slot
/datum/gear/suit
	display_name = "apron, blue"
	path = /obj/item/clothing/suit/storage/apron
	slot = slot_wear_suit
	sort_category = "Suits and Overwear"
	cost = 2

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
	display_name = "bomber jacket"
	path = /obj/item/clothing/suit/storage/toggle/bomber

/datum/gear/suit/bomber_alt
	display_name = "bomber jacket, alt"
	path = /obj/item/clothing/suit/storage/bomber/alt

/datum/gear/suit/bomber_retro
	display_name = "bomber jacket, retro"
	path = /obj/item/clothing/suit/storage/toggle/bomber/retro

/datum/gear/suit/leather_jacket
	display_name = "leather jacket, black"
	path = /obj/item/clothing/suit/storage/toggle/leather_jacket

/datum/gear/suit/leather_jacket_sleeveless
	display_name = "leather vest, black"
	path = /obj/item/clothing/suit/storage/toggle/leather_jacket/sleeveless

/datum/gear/suit/leather_jacket_alt
	display_name = "leather jacket 2, black"
	path = /obj/item/clothing/suit/storage/leather_jacket_alt

/datum/gear/suit/leather_jacket_nt
	display_name = "leather jacket, corporate, black"
	path = /obj/item/clothing/suit/storage/toggle/leather_jacket/nanotrasen

/datum/gear/suit/leather_jacket_nt/sleeveless
	display_name = "leather vest, corporate, black"
	path = /obj/item/clothing/suit/storage/toggle/leather_jacket/nanotrasen/sleeveless

/datum/gear/suit/brown_jacket
	display_name = "leather jacket, brown"
	path = /obj/item/clothing/suit/storage/toggle/brown_jacket

/datum/gear/suit/brown_jacket_sleeveless
	display_name = "leather vest, brown"
	path = /obj/item/clothing/suit/storage/toggle/brown_jacket/sleeveless

/datum/gear/suit/brown_jacket_nt
	display_name = "leather jacket, corporate, brown"
	path = /obj/item/clothing/suit/storage/toggle/brown_jacket/nanotrasen

/datum/gear/suit/brown_jacket_nt/sleeveless
	display_name = "leather vest, corporate, brown"
	path = /obj/item/clothing/suit/storage/toggle/brown_jacket/nanotrasen/sleeveless

/datum/gear/suit/mil
	display_name = "military jacket selection"
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
	allowed_roles = list("Chief Medical Officer")

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
	allowed_roles = list("Medical Doctor","Chief Medical Officer","Chemist","Paramedic","Geneticist", "Psychiatrist")

/datum/gear/suit/labcoat_rd
	display_name = "labcoat, research director"
	path = /obj/item/clothing/suit/storage/toggle/labcoat/rd
	allowed_roles = list("Research Director")

/datum/gear/suit/miscellaneous/labcoat
	display_name = "plague doctor's coat"
	path = /obj/item/clothing/suit/storage/toggle/labcoat/plaguedoctor

/datum/gear/suit/roles/surgical_apron
	display_name = "surgical apron"
	path = /obj/item/clothing/suit/surgicalapron
	allowed_roles = list("Medical Doctor","Chief Medical Officer")

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

/datum/gear/suit/puffycoat/blue
	display_name = "puffy coat, blue"
	path = /obj/item/clothing/suit/storage/puffyblue

/datum/gear/suit/puffycoat/red
	display_name = "puffy coat, red"
	path = /obj/item/clothing/suit/storage/puffyred

/datum/gear/suit/puffycoat/purple
	display_name = "puffy coat, purple"
	path = /obj/item/clothing/suit/storage/puffypurple

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
	allowed_roles = list("Head of Security")
	cost = 1

/datum/gear/suit/roles/cloak_cmo
	display_name = "cloak, chief medical officer"
	path = /obj/item/clothing/accessory/poncho/roles/cloak/cmo
	allowed_roles = list("Chief Medical Officer")
	cost = 1

/datum/gear/suit/roles/cloak_ce
	display_name = "cloak, chief engineer"
	path = /obj/item/clothing/accessory/poncho/roles/cloak/ce
	allowed_roles = list("Chief Engineer")
	cost = 1

/datum/gear/suit/roles/cloak_rd
	display_name = "cloak, research director"
	path = /obj/item/clothing/accessory/poncho/roles/cloak/rd
	allowed_roles = list("Research Director")
	cost = 1

/datum/gear/suit/roles/cloak_qm
	display_name = "cloak, quartermaster"
	path = /obj/item/clothing/accessory/poncho/roles/cloak/qm
	allowed_roles = list("Quartermaster")
	cost = 1

/datum/gear/suit/roles/cloak_captain
	display_name = "cloak, site manager"
	path = /obj/item/clothing/accessory/poncho/roles/cloak/captain
	allowed_roles = list("Site Manager")
	cost = 1

/datum/gear/suit/roles/cloak_hop
	display_name = "cloak, head of personnel"
	path = /obj/item/clothing/accessory/poncho/roles/cloak/hop
	allowed_roles = list("Head of Personnel")
	cost = 1

/datum/gear/suit/cloak_custom //A colorable cloak
	display_name = "cloak, colorable"
	path = /obj/item/clothing/accessory/poncho/roles/cloak/custom
	cost = 1

/datum/gear/suit/cloak_custom/New()
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
	display_name = "forensics uniform selection (Detective)"
	path = /obj/item/clothing/suit/storage/forensics/red/long
	allowed_roles = list("Detective")

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
	allowed_roles = list("Quartermaster")

/datum/gear/suit/cargo_coat
	display_name = "coat, cargo tech"
	path = /obj/item/clothing/suit/storage/cargo
	allowed_roles = list("Quartermaster","Shaft Miner","Cargo Technician","Head of Personnel")

// winter coats go here
/datum/gear/suit/wintercoat
	display_name = "winter coat"
	path = /obj/item/clothing/suit/storage/hooded/wintercoat

/datum/gear/suit/wintercoat/captain
	display_name = "winter coat, site manager"
	path = /obj/item/clothing/suit/storage/hooded/wintercoat/captain
	allowed_roles = list("Site Manager")

/datum/gear/suit/wintercoat/hop
	display_name = "winter coat, head of personnel"
	path = /obj/item/clothing/suit/storage/hooded/wintercoat/hop
	allowed_roles = list("Head of Personnel")

/datum/gear/suit/wintercoat/security
	display_name = "winter coat, security"
	path = /obj/item/clothing/suit/storage/hooded/wintercoat/security
	allowed_roles = list("Security Officer", "Head of Security", "Warden", "Detective")

/datum/gear/suit/wintercoat/security/hos
	display_name = "winter coat, head of security"
	path = /obj/item/clothing/suit/storage/hooded/wintercoat/security/hos
	allowed_roles = list("Head of Security")

/datum/gear/suit/wintercoat/medical
	display_name = "winter coat, medical"
	path = /obj/item/clothing/suit/storage/hooded/wintercoat/medical
	allowed_roles = list("Medical Doctor","Chief Medical Officer","Chemist","Paramedic","Geneticist", "Psychiatrist", "Field Medic")

/datum/gear/suit/wintercoat/medical/alt
	display_name = "winter coat, medical alt"
	path = /obj/item/clothing/suit/storage/hooded/wintercoat/medical/alt
	allowed_roles = list("Medical Doctor","Chief Medical Officer","Chemist","Paramedic","Geneticist", "Psychiatrist", "Field Medic")

/datum/gear/suit/wintercoat/medical/viro
	display_name = "winter coat, virologist"
	path = /obj/item/clothing/suit/storage/hooded/wintercoat/medical/viro
	allowed_roles = list("Medical Doctor","Chief Medical Officer")

/datum/gear/suit/wintercoat/medical/para
	display_name = "winter coat, paramedic"
	path = /obj/item/clothing/suit/storage/hooded/wintercoat/medical/para
	allowed_roles = list("Medical Doctor","Chief Medical Officer","Paramedic","Field Medic")

/datum/gear/suit/wintercoat/medical/chemist
	display_name = "winter coat, chemist"
	path = /obj/item/clothing/suit/storage/hooded/wintercoat/medical/chemist
	allowed_roles = list("Chief Medical Officer","Chemist")

/datum/gear/suit/wintercoat/medical/cmo
	display_name = "winter coat, chief medical officer"
	path = /obj/item/clothing/suit/storage/hooded/wintercoat/medical/cmo
	allowed_roles = list("Chief Medical Officer")

/datum/gear/suit/wintercoat/medical/sar
	display_name = "winter coat, search and rescue"
	path = /obj/item/clothing/suit/storage/hooded/wintercoat/medical/sar
	allowed_roles = list("Chief Medical Officer","Paramedic","Field Medic")

/datum/gear/suit/wintercoat/science
	display_name = "winter coat, science"
	path = /obj/item/clothing/suit/storage/hooded/wintercoat/science
	allowed_roles = list("Research Director","Scientist", "Roboticist", "Xenobiologist", "Xenobotanist")

/datum/gear/suit/wintercoat/science/robotics
	display_name = "winter coat, robotics"
	path = /obj/item/clothing/suit/storage/hooded/wintercoat/science/robotics
	allowed_roles = list("Research Director", "Roboticist")

/datum/gear/suit/wintercoat/science/rd
	display_name = "winter coat, research director"
	path = /obj/item/clothing/suit/storage/hooded/wintercoat/science/rd
	allowed_roles = list("Research Director")

/datum/gear/suit/wintercoat/engineering
	display_name = "winter coat, engineering"
	path = /obj/item/clothing/suit/storage/hooded/wintercoat/engineering
	allowed_roles = list("Chief Engineer","Atmospheric Technician", "Engineer")

/datum/gear/suit/wintercoat/engineering/atmos
	display_name = "winter coat, atmospherics"
	path = /obj/item/clothing/suit/storage/hooded/wintercoat/engineering/atmos
	allowed_roles = list("Chief Engineer", "Atmospheric Technician")

/datum/gear/suit/wintercoat/engineering/ce
	display_name = "winter coat, chief engineer"
	path = /obj/item/clothing/suit/storage/hooded/wintercoat/engineering/ce
	allowed_roles = list("Chief Engineer")

/datum/gear/suit/wintercoat/hydro
	display_name = "winter coat, hydroponics"
	path = /obj/item/clothing/suit/storage/hooded/wintercoat/hydro
	allowed_roles = list("Botanist", "Xenobotanist")

/datum/gear/suit/wintercoat/cargo
	display_name = "winter coat, cargo"
	path = /obj/item/clothing/suit/storage/hooded/wintercoat/cargo
	allowed_roles = list("Quartermaster","Cargo Technician")

/datum/gear/suit/wintercoat/miner
	display_name = "winter coat, mining"
	path = /obj/item/clothing/suit/storage/hooded/wintercoat/miner
	allowed_roles = list("Shaft Miner")

/datum/gear/suit/wintercoat/cargo/qm
	display_name = "winter coat, quartermaster"
	path = /obj/item/clothing/suit/storage/hooded/wintercoat/cargo/qm
	allowed_roles = list("Quartermaster")

/datum/gear/suit/wintercoat/bar
	display_name = "winter coat, bartender"
	path = /obj/item/clothing/suit/storage/hooded/wintercoat/bar
	allowed_roles = list("Bartender")

/datum/gear/suit/wintercoat/janitor
	display_name = "winter coat, janitor"
	path = /obj/item/clothing/suit/storage/hooded/wintercoat/janitor
	allowed_roles = list("Janitor")

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

/datum/gear/suit/denim_jacket
	display_name = "denim jacket"
	path = /obj/item/clothing/suit/storage/toggle/denim_jacket

/datum/gear/suit/denim_jacket/corporate
	display_name = "denim jacket, corporate"
	path = /obj/item/clothing/suit/storage/toggle/denim_jacket/nanotrasen

/datum/gear/suit/denim_vest
	display_name = "denim vest"
	path = /obj/item/clothing/suit/storage/toggle/denim_jacket/sleeveless

/datum/gear/suit/denim_vest/corporate
	display_name = "denim vest, corporate"
	path = /obj/item/clothing/suit/storage/toggle/denim_jacket/nanotrasen/sleeveless

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
	allowed_roles = list("Site Manager","Research Director","Head of Personnel","Head of Security","Chief Engineer","Command Secretary")

/datum/gear/suit/snowsuit/security
	display_name = "snowsuit, security"
	path = /obj/item/clothing/suit/storage/snowsuit/security
	allowed_roles = list("Security Officer", "Head of Security", "Warden", "Detective")

/datum/gear/suit/snowsuit/medical
	display_name = "snowsuit, medical"
	path = /obj/item/clothing/suit/storage/snowsuit/medical
	allowed_roles = list("Medical Doctor","Chief Medical Officer","Chemist","Paramedic","Geneticist", "Psychiatrist", "Search and Rescue")

/datum/gear/suit/snowsuit/science
	display_name = "snowsuit, science"
	path = /obj/item/clothing/suit/storage/snowsuit/science
	allowed_roles = list("Research Director","Scientist", "Roboticist", "Xenobiologist")

/datum/gear/suit/snowsuit/engineering
	display_name = "snowsuit, engineering"
	path = /obj/item/clothing/suit/storage/snowsuit/engineering
	allowed_roles = list("Chief Engineer","Atmospheric Technician", "Engineer")

/datum/gear/suit/snowsuit/cargo
	display_name = "snowsuit, supply"
	path = /obj/item/clothing/suit/storage/snowsuit/cargo
	allowed_roles = list("Quartermaster","Shaft Miner","Cargo Technician","Head of Personnel")

/datum/gear/suit/miscellaneous/cardigan
	display_name = "cardigan, colorable"
	path = /obj/item/clothing/suit/storage/toggle/cardigan

/datum/gear/suit/miscellaneous/cardigan/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/suit/cmddressjacket
	display_name = "command dress jacket"
	path = /obj/item/clothing/suit/storage/toggle/cmddressjacket
	allowed_roles = list("Site Manager", "Head of Personnel", "Command Secretary")

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

/datum/gear/suit/miscellaneous/kimono
	display_name = "kimono selection"
	path = /obj/item/clothing/suit/kimono/red

/datum/gear/suit/miscellaneous/kimono/New()
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
