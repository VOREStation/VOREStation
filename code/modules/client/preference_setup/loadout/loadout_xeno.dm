// Alien clothing.

/datum/gear/suit/zhan_furs
	display_name = "Zhan-Khazan furs (Tajaran)"
	path = /obj/item/clothing/suit/tajaran/furs
	sort_category = "Xenowear"

/datum/gear/head/zhan_scarf
	display_name = "Zhan headscarf"
	path = /obj/item/clothing/head/tajaran/scarf
	whitelisted = SPECIES_TAJ

/datum/gear/suit/unathi_mantle
	display_name = "hide mantle (Unathi)"
	path = /obj/item/clothing/suit/unathi/mantle
	cost = 1
	sort_category = "Xenowear"

/datum/gear/ears/skrell/chains	//Chains
	display_name = "headtail chain selection (Skrell)"
	path = /obj/item/clothing/ears/skrell/chain
	sort_category = "Xenowear"
	whitelisted = SPECIES_SKRELL

/datum/gear/ears/skrell/chains/New()
	..()
	var/list/chaintypes = list()
	for(var/chain_style in typesof(/obj/item/clothing/ears/skrell/chain))
		var/obj/item/clothing/ears/skrell/chain/chain = chain_style
		chaintypes[initial(chain.name)] = chain
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(chaintypes))

/datum/gear/ears/skrell/bands
	display_name = "headtail band selection (Skrell)"
	path = /obj/item/clothing/ears/skrell/band
	sort_category = "Xenowear"
	whitelisted = SPECIES_SKRELL

/datum/gear/ears/skrell/bands/New()
	..()
	var/list/bandtypes = list()
	for(var/band_style in typesof(/obj/item/clothing/ears/skrell/band))
		var/obj/item/clothing/ears/skrell/band/band = band_style
		bandtypes[initial(band.name)] = band
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(bandtypes))

/datum/gear/ears/skrell/cloth/short
	display_name = "short headtail cloth (Skrell)"
	path = /obj/item/clothing/ears/skrell/cloth_male/black
	sort_category = "Xenowear"
	whitelisted = SPECIES_SKRELL

/datum/gear/ears/skrell/cloth/short/New()
	..()
	var/list/shorttypes = list()
	for(var/short_style in typesof(/obj/item/clothing/ears/skrell/cloth_male))
		var/obj/item/clothing/ears/skrell/cloth_male/short = short_style
		shorttypes[initial(short.name)] = short
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(shorttypes))

/datum/gear/ears/skrell/cloth/long
	display_name = "long headtail cloth (Skrell)"
	path = /obj/item/clothing/ears/skrell/cloth_female/black
	sort_category = "Xenowear"
	whitelisted = SPECIES_SKRELL

/datum/gear/ears/skrell/cloth/long/New()
	..()
	var/list/longtypes = list()
	for(var/long_style in typesof(/obj/item/clothing/ears/skrell/cloth_female))
		var/obj/item/clothing/ears/skrell/cloth_female/long = long_style
		longtypes[initial(long.name)] = long
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(longtypes))

/datum/gear/ears/skrell/colored/band
	display_name = "Colored bands (Skrell)"
	path = /obj/item/clothing/ears/skrell/colored/band
	sort_category = "Xenowear"
	whitelisted = SPECIES_SKRELL

/datum/gear/ears/skrell/colored/band/New()
	..()
	gear_tweaks = list(gear_tweak_free_color_choice)

/datum/gear/ears/skrell/colored/chain
	display_name = "Colored chain (Skrell)"
	path = /obj/item/clothing/ears/skrell/colored/chain
	sort_category = "Xenowear"
	whitelisted = SPECIES_SKRELL

/datum/gear/ears/skrell/colored/chain/New()
	..()
	gear_tweaks = list(gear_tweak_free_color_choice)

/datum/gear/uniform/smock
	display_name = "smock selection (Teshari)"
	path = /obj/item/clothing/under/seromi/smock
	whitelisted = SPECIES_TESHARI
	sort_category = "Xenowear"

/datum/gear/uniform/smock/New()
	..()
	var/list/smocks = list()
	for(var/smock in typesof(/obj/item/clothing/under/seromi/smock))
		var/obj/item/clothing/under/seromi/smock/smock_type = smock
		smocks[initial(smock_type.name)] = smock_type
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(smocks))

/datum/gear/uniform/undercoat
	display_name = "undercoat selection (Teshari)"
	path = /obj/item/clothing/under/seromi/undercoat/standard
	whitelisted = SPECIES_TESHARI
	sort_category = "Xenowear"

/datum/gear/uniform/undercoat/New()
	..()
	var/list/undercoats = list()
	for(var/undercoat in typesof(/obj/item/clothing/under/seromi/undercoat/standard))
		var/obj/item/clothing/under/seromi/undercoat/standard/undercoat_type = undercoat
		undercoats[initial(undercoat_type.name)] = undercoat_type
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(undercoats))

/datum/gear/suit/cloak
	display_name = "cloak selection (Teshari)"
	path = /obj/item/clothing/suit/storage/seromi/cloak/standard
	whitelisted = SPECIES_TESHARI
	sort_category = "Xenowear"

/datum/gear/suit/cloak/New()
	..()
	var/list/cloaks = list()
	for(var/cloak in typesof(/obj/item/clothing/suit/storage/seromi/cloak/standard))
		var/obj/item/clothing/suit/storage/seromi/cloak/standard/cloak_type = cloak
		cloaks[initial(cloak_type.name)] = cloak_type
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(cloaks))

/datum/gear/mask/ipc_monitor
	display_name = "display monitor (Full Body Prosthetic)"
	path = /obj/item/clothing/mask/monitor
	sort_category = "Xenowear"

/datum/gear/uniform/harness
	display_name = "gear harness (Full Body Prosthetic, Diona)"
	path = /obj/item/clothing/under/harness
	sort_category = "Xenowear"

/datum/gear/shoes/footwraps
	display_name = "cloth footwraps"
	path = /obj/item/clothing/shoes/footwraps
	sort_category = "Xenowear"
	cost = 1

/datum/gear/uniform/cohesionsuits
	display_name = "cohesion suit selection (Promethean)"
	path = /obj/item/clothing/under/cohesion
	sort_category = "Xenowear"

/datum/gear/uniform/cohesionsuits/New()
	..()
	var/list/cohesionsuits = list()
	for(var/cohesionsuit in (typesof(/obj/item/clothing/under/cohesion)))
		var/obj/item/clothing/under/cohesion/cohesion_type = cohesionsuit
		cohesionsuits[initial(cohesion_type.name)] = cohesion_type
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(cohesionsuits))

/datum/gear/uniform/dept
	whitelisted = SPECIES_TESHARI
	sort_category = "Xenowear"

/datum/gear/uniform/dept/undercoat/ce
	display_name = "chief engineer undercoat (Teshari)"
	path = /obj/item/clothing/under/seromi/undercoat/jobs/ce
	allowed_roles = list("Chief Engineer")

/datum/gear/uniform/dept/undercoat/ce_w
	display_name = "chief engineer undercoat - white (Teshari)"
	path = /obj/item/clothing/under/seromi/undercoat/jobs/ce_w
	allowed_roles = list("Chief Engineer")

/datum/gear/uniform/dept/undercoat/qm
	display_name = "quartermaster undercoat (Teshari)"
	path = /obj/item/clothing/under/seromi/undercoat/jobs/qm
	allowed_roles = list("Quartermaster")

/datum/gear/uniform/dept/undercoat/command
	display_name = "command undercoat (Teshari)"
	path = /obj/item/clothing/under/seromi/undercoat/jobs/command
	allowed_roles = list("Colony Director","Head of Personnel","Head of Security","Chief Engineer","Chief Medical Officer","Research Director")

/datum/gear/uniform/dept/undercoat/command_g
	display_name = "command undercoat - gold buttons (Teshari)"
	path = /obj/item/clothing/under/seromi/undercoat/jobs/command_g
	allowed_roles = list("Colony Director","Head of Personnel","Head of Security","Chief Engineer","Chief Medical Officer","Research Director")

/datum/gear/uniform/dept/undercoat/cmo
	display_name = "chief medical officer undercoat (Teshari)"
	path = /obj/item/clothing/under/seromi/undercoat/jobs/cmo
	allowed_roles = list("Chief Medical Officer")

/datum/gear/uniform/dept/undercoat/cargo
	display_name = "cargo undercoat (Teshari)"
	path = /obj/item/clothing/under/seromi/undercoat/jobs/cargo
	allowed_roles = list("Cargo Technician","Quartermaster","Shaft Miner")

/datum/gear/uniform/dept/undercoat/mining
	display_name = "mining undercoat (Teshari)"
	path = /obj/item/clothing/under/seromi/undercoat/jobs/mining
	allowed_roles = list("Quartermaster","Shaft Miner")

/datum/gear/uniform/dept/undercoat/security
	display_name = "security undercoat (Teshari)"
	path = /obj/item/clothing/under/seromi/undercoat/jobs/sec
	allowed_roles = list("Head of Security","Detective","Warden","Security Officer",)

/datum/gear/uniform/dept/undercoat/service
	display_name = "service undercoat (Teshari)"
	path = /obj/item/clothing/under/seromi/undercoat/jobs/service
	allowed_roles = list("Head of Personnel","Bartender","Botanist","Janitor","Chef","Librarian")

/datum/gear/uniform/dept/undercoat/engineer
	display_name = "engineering undercoat (Teshari)"
	path = /obj/item/clothing/under/seromi/undercoat/jobs/engineer
	allowed_roles = list("Chief Engineer","Station Engineer")

/datum/gear/uniform/dept/undercoat/atmos
	display_name = "atmospherics undercoat (Teshari)"
	path = /obj/item/clothing/under/seromi/undercoat/jobs/atmos
	allowed_roles = list("Chief Engineer","Atmospheric Technician")

/datum/gear/uniform/dept/undercoat/research
	display_name = "scientist undercoat (Teshari)"
	path = /obj/item/clothing/under/seromi/undercoat/jobs/sci
	allowed_roles = list("Research Director","Scientist", "Roboticist", "Xenobiologist")

/datum/gear/uniform/dept/undercoat/robo
	display_name = "roboticist undercoat (Teshari)"
	path = /obj/item/clothing/under/seromi/undercoat/jobs/robo
	allowed_roles = list("Roboticist")

/datum/gear/uniform/dept/undercoat/medical
	display_name = "medical undercoat (Teshari)"
	path = /obj/item/clothing/under/seromi/undercoat/jobs/medical
	allowed_roles = list("Medical Doctor","Chief Medical Officer","Chemist","Paramedic","Geneticist", "Psychiatrist")

/datum/gear/uniform/dept/undercoat/chemistry
	display_name = "chemist undercoat (Teshari)"
	path = /obj/item/clothing/under/seromi/undercoat/jobs/chemistry
	allowed_roles = list("Chemist")

/datum/gear/uniform/dept/undercoat/virology
	display_name = "virologist undercoat (Teshari)"
	path = /obj/item/clothing/under/seromi/undercoat/jobs/viro
	allowed_roles = list("Medical Doctor")

/datum/gear/uniform/dept/undercoat/paramedic
	display_name = "paramedic undercoat (Teshari)"
	path = /obj/item/clothing/under/seromi/undercoat/jobs/para
	allowed_roles = list("Paramedic")

/datum/gear/uniform/dept/undercoat/iaa
	display_name = "internal affairs undercoat (Teshari)"
	path = /obj/item/clothing/under/seromi/undercoat/jobs/iaa
	allowed_roles = list("Internal Affairs Agent")

/datum/gear/suit/dept/cloak/
	whitelisted = SPECIES_TESHARI
	sort_category = "Xenowear"

/datum/gear/suit/cloak/dept/ce
	display_name = "chief engineer cloak (Teshari)"
	path = /obj/item/clothing/suit/storage/seromi/cloak/jobs/ce
	allowed_roles = list("Chief Engineer")

/datum/gear/suit/dept/cloak/qm
	display_name = "quartermaster cloak (Teshari)"
	path = /obj/item/clothing/suit/storage/seromi/cloak/jobs/qm
	allowed_roles = list("Quartermaster")

/datum/gear/suit/dept/cloak/command
	display_name = "command cloak (Teshari)"
	path = /obj/item/clothing/suit/storage/seromi/cloak/jobs/command
	allowed_roles = list("Colony Director","Head of Personnel","Head of Security","Chief Engineer","Chief Medical Officer","Research Director")

/datum/gear/suit/dept/cloak/cmo
	display_name = "chief medical officer cloak (Teshari)"
	path = /obj/item/clothing/suit/storage/seromi/cloak/jobs/cmo
	allowed_roles = list("Chief Medical Officer")

/datum/gear/suit/dept/cloak/cargo
	display_name = "cargo cloak (Teshari)"
	path = /obj/item/clothing/suit/storage/seromi/cloak/jobs/cargo
	allowed_roles = list("Cargo Technician","Quartermaster","Shaft Miner")

/datum/gear/suit/dept/cloak/mining
	display_name = "mining cloak (Teshari)"
	path = /obj/item/clothing/suit/storage/seromi/cloak/jobs/mining
	allowed_roles = list("Quartermaster","Shaft Miner")

/datum/gear/suit/dept/cloak/security
	display_name = "security cloak (Teshari)"
	path = /obj/item/clothing/suit/storage/seromi/cloak/jobs/sec
	allowed_roles = list("Head of Security","Detective","Warden","Security Officer",)

/datum/gear/suit/dept/cloak/service
	display_name = "service cloak (Teshari)"
	path = /obj/item/clothing/suit/storage/seromi/cloak/jobs/service
	allowed_roles = list("Head of Personnel","Bartender","Botanist","Janitor","Chef","Librarian")

/datum/gear/suit/dept/cloak/engineer
	display_name = "engineering cloak (Teshari)"
	path = /obj/item/clothing/suit/storage/seromi/cloak/jobs/eningeer
	allowed_roles = list("Chief Engineer","Station Engineer")

/datum/gear/suit/dept/cloak/atmos
	display_name = "atmospherics cloak (Teshari)"
	path = /obj/item/clothing/suit/storage/seromi/cloak/jobs/atmos
	allowed_roles = list("Chief Engineer","Atmospheric Technician")

/datum/gear/suit/dept/cloak/research
	display_name = "scientist cloak (Teshari)"
	path = /obj/item/clothing/suit/storage/seromi/cloak/jobs/sci
	allowed_roles = list("Research Director","Scientist", "Roboticist", "Xenobiologist")

/datum/gear/suit/dept/cloak/robo
	display_name = "roboticist cloak (Teshari)"
	path = /obj/item/clothing/suit/storage/seromi/cloak/jobs/robo
	allowed_roles = list("Roboticist")

/datum/gear/suit/dept/cloak/medical
	display_name = "medical cloak (Teshari)"
	path = /obj/item/clothing/suit/storage/seromi/cloak/jobs/medical
	allowed_roles = list("Medical Doctor","Chief Medical Officer","Chemist","Paramedic","Geneticist", "Psychiatrist")

/datum/gear/suit/dept/cloak/chemistry
	display_name = "chemist cloak (Teshari)"
	path = /obj/item/clothing/suit/storage/seromi/cloak/jobs/chemistry
	allowed_roles = list("Chemist")

/datum/gear/suit/dept/cloak/virology
	display_name = "virologist cloak (Teshari)"
	path = /obj/item/clothing/suit/storage/seromi/cloak/jobs/viro
	allowed_roles = list("Medical Doctor")

/datum/gear/suit/dept/cloak/paramedic
	display_name = "paramedic cloak (Teshari)"
	path = /obj/item/clothing/suit/storage/seromi/cloak/jobs/para
	allowed_roles = list("Paramedic")

/datum/gear/suit/dept/cloak/iaa
	display_name = "internal affairs cloak (Teshari)"
	path = /obj/item/clothing/suit/storage/seromi/cloak/jobs/iaa
	allowed_roles = list("Internal Affairs Agent")
