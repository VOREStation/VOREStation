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
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/ears/skrell/colored/chain
	display_name = "Colored chain (Skrell)"
	path = /obj/item/clothing/ears/skrell/colored/chain
	sort_category = "Xenowear"
	whitelisted = SPECIES_SKRELL

/datum/gear/ears/skrell/colored/chain/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/uniform/smock
	display_name = "smock selection (Teshari)"
	path = /obj/item/clothing/under/teshari/smock
	whitelisted = SPECIES_TESHARI
	sort_category = "Xenowear"

/datum/gear/uniform/smock/New()
	..()
	var/list/smocks = list()
	for(var/smock in typesof(/obj/item/clothing/under/teshari/smock))
		var/obj/item/clothing/under/teshari/smock/smock_type = smock
		smocks[initial(smock_type.name)] = smock_type
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(smocks))

/datum/gear/uniform/undercoat
	display_name = "undercoat selection (Teshari)"
	path = /obj/item/clothing/under/teshari/undercoat/standard
	whitelisted = SPECIES_TESHARI
	sort_category = "Xenowear"

/datum/gear/uniform/undercoat/New()
	..()
	var/list/undercoats = list()
	for(var/undercoat in typesof(/obj/item/clothing/under/teshari/undercoat/standard))
		var/obj/item/clothing/under/teshari/undercoat/standard/undercoat_type = undercoat
		undercoats[initial(undercoat_type.name)] = undercoat_type
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(undercoats))

/datum/gear/suit/cloak
	display_name = "cloak selection (Teshari)"
	path = /obj/item/clothing/suit/storage/teshari/cloak/standard
	whitelisted = SPECIES_TESHARI
	sort_category = "Xenowear"

/datum/gear/suit/cloak/New()
	..()
	var/list/cloaks = list()
	for(var/cloak in typesof(/obj/item/clothing/suit/storage/teshari/cloak/standard))
		var/obj/item/clothing/suit/storage/teshari/cloak/standard/cloak_type = cloak
		cloaks[initial(cloak_type.name)] = cloak_type
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(cloaks))

/datum/gear/uniform/harness
	display_name = "gear harness (Full Body Prosthetic, Diona)"
	path = /obj/item/clothing/under/harness
	sort_category = "Xenowear"

/datum/gear/shoes/footwraps
	display_name = "cloth footwraps"
	path = /obj/item/clothing/shoes/footwraps
	sort_category = "Xenowear"
	cost = 1

/datum/gear/shoes/footwraps/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice

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

/datum/gear/uniform/dept/undercoat/cap
	display_name = "site manager undercoat (Teshari)"
	path = /obj/item/clothing/under/teshari/undercoat/jobs/cap
	allowed_roles = list(JOB_SITE_MANAGER)

/datum/gear/uniform/dept/undercoat/hop
	display_name = "head of personnel undercoat (Teshari)"
	path = /obj/item/clothing/under/teshari/undercoat/jobs/hop
	allowed_roles = list(JOB_HEAD_OF_PERSONNEL)

/datum/gear/uniform/dept/undercoat/rd
	display_name = "research director undercoat (Teshari)"
	path = /obj/item/clothing/under/teshari/undercoat/jobs/rd
	allowed_roles = list(JOB_RESEARCH_DIRECTOR)

/datum/gear/uniform/dept/undercoat/hos
	display_name = "head of security undercoat (Teshari)"
	path = /obj/item/clothing/under/teshari/undercoat/jobs/hos
	allowed_roles = list(JOB_HEAD_OF_SECURITY)

/datum/gear/uniform/dept/undercoat/ce
	display_name = "chief engineer undercoat (Teshari)"
	path = /obj/item/clothing/under/teshari/undercoat/jobs/ce
	allowed_roles = list(JOB_CHIEF_ENGINEER)

/datum/gear/uniform/dept/undercoat/cmo
	display_name = "chief medical officer undercoat (Teshari)"
	path = /obj/item/clothing/under/teshari/undercoat/jobs/cmo
	allowed_roles = list(JOB_CHIEF_MEDICAL_OFFICER)

/datum/gear/uniform/dept/undercoat/qm
	display_name = "quartermaster undercoat (Teshari)"
	path = /obj/item/clothing/under/teshari/undercoat/jobs/qm
	allowed_roles = list(JOB_QUARTERMASTER)

/datum/gear/uniform/dept/undercoat/cargo
	display_name = "cargo undercoat (Teshari)"
	path = /obj/item/clothing/under/teshari/undercoat/jobs/cargo
	allowed_roles = list(JOB_CARGO_TECHNICIAN,JOB_QUARTERMASTER,JOB_SHAFT_MINER)

/datum/gear/uniform/dept/undercoat/mining
	display_name = "mining undercoat (Teshari)"
	path = /obj/item/clothing/under/teshari/undercoat/jobs/mining
	allowed_roles = list(JOB_QUARTERMASTER,JOB_SHAFT_MINER)

/datum/gear/uniform/dept/undercoat/security
	display_name = "security undercoat (Teshari)"
	path = /obj/item/clothing/under/teshari/undercoat/jobs/sec
	allowed_roles = list(JOB_HEAD_OF_SECURITY,JOB_DETECTIVE,JOB_WARDEN,JOB_SECURITY_OFFICER)

/datum/gear/uniform/dept/undercoat/service
	display_name = "service undercoat (Teshari)"
	path = /obj/item/clothing/under/teshari/undercoat/jobs/service
	allowed_roles = list(JOB_HEAD_OF_PERSONNEL,"Bartender","Botanist","Janitor","Chef","Librarian","Chaplain")

/datum/gear/uniform/dept/undercoat/engineer
	display_name = "engineering undercoat (Teshari)"
	path = /obj/item/clothing/under/teshari/undercoat/jobs/engineer
	allowed_roles = list(JOB_CHIEF_ENGINEER,JOB_ENGINEER)

/datum/gear/uniform/dept/undercoat/atmos
	display_name = "atmospherics undercoat (Teshari)"
	path = /obj/item/clothing/under/teshari/undercoat/jobs/atmos
	allowed_roles = list(JOB_CHIEF_ENGINEER,JOB_ATMOSPHERIC_TECHNICIAN)

/datum/gear/uniform/dept/undercoat/research
	display_name = "scientist undercoat (Teshari)"
	path = /obj/item/clothing/under/teshari/undercoat/jobs/sci
	allowed_roles = list(JOB_RESEARCH_DIRECTOR,JOB_SCIENTIST, JOB_ROBOTICIST, JOB_XENOBIOLOGIST)

/datum/gear/uniform/dept/undercoat/robo
	display_name = "roboticist undercoat (Teshari)"
	path = /obj/item/clothing/under/teshari/undercoat/jobs/robo
	allowed_roles = list(JOB_RESEARCH_DIRECTOR,JOB_ROBOTICIST)

/datum/gear/uniform/dept/undercoat/medical
	display_name = "medical undercoat (Teshari)"
	path = /obj/item/clothing/under/teshari/undercoat/jobs/medical
	allowed_roles = list(JOB_CHIEF_MEDICAL_OFFICER,JOB_MEDICAL_DOCTOR,JOB_CHEMIST,JOB_PARAMEDIC,JOB_GENETICIST,JOB_PSYCHIATRIST)

/datum/gear/uniform/dept/undercoat/chemistry
	display_name = "chemist undercoat (Teshari)"
	path = /obj/item/clothing/under/teshari/undercoat/jobs/chemistry
	allowed_roles = list(JOB_CHIEF_MEDICAL_OFFICER,JOB_CHEMIST)

/datum/gear/uniform/dept/undercoat/virology
	display_name = "virologist undercoat (Teshari)"
	path = /obj/item/clothing/under/teshari/undercoat/jobs/viro
	allowed_roles = list(JOB_CHIEF_MEDICAL_OFFICER,JOB_MEDICAL_DOCTOR)

/datum/gear/uniform/dept/undercoat/psych
	display_name = "psychiatrist undercoat (Teshari)"
	path = /obj/item/clothing/under/teshari/undercoat/jobs/psych
	allowed_roles = list(JOB_CHIEF_MEDICAL_OFFICER,JOB_PSYCHIATRIST)

/datum/gear/uniform/dept/undercoat/paramedic
	display_name = "paramedic undercoat (Teshari)"
	path = /obj/item/clothing/under/teshari/undercoat/jobs/para
	allowed_roles = list(JOB_CHIEF_MEDICAL_OFFICER,JOB_PARAMEDIC)

/datum/gear/uniform/dept/undercoat/iaa
	display_name = "internal affairs undercoat (Teshari)"
	path = /obj/item/clothing/under/teshari/undercoat/jobs/iaa
	allowed_roles = list("Internal Affairs Agent")

/datum/gear/suit/dept/cloak
	whitelisted = SPECIES_TESHARI
	sort_category = "Xenowear"

/datum/gear/suit/dept/cloak/cap
	display_name = "site manager cloak (Teshari)"
	path = /obj/item/clothing/suit/storage/teshari/cloak/jobs
	allowed_roles = list(JOB_SITE_MANAGER)

/datum/gear/suit/dept/cloak/hop
	display_name = "head of personnel cloak (Teshari)"
	path = /obj/item/clothing/suit/storage/teshari/cloak/jobs/hop
	allowed_roles = list(JOB_HEAD_OF_PERSONNEL)

/datum/gear/suit/dept/cloak/rd
	display_name = "research director cloak (Teshari)"
	path = /obj/item/clothing/suit/storage/teshari/cloak/jobs/rd
	allowed_roles = list(JOB_RESEARCH_DIRECTOR)

/datum/gear/suit/dept/cloak/hos
	display_name = "head of security cloak (Teshari)"
	path = /obj/item/clothing/suit/storage/teshari/cloak/jobs/hos
	allowed_roles = list(JOB_HEAD_OF_SECURITY)

/datum/gear/suit/dept/cloak/hos/New()
	..()
	var/list/cloaks = list()
	for(var/cloak in typesof(/obj/item/clothing/suit/storage/teshari/cloak/jobs/hos,/obj/item/clothing/suit/storage/teshari/beltcloak/jobs/hos))
		var/obj/item/clothing/suit/storage/teshari/beltcloak/jobs/cloak_type = cloak
		cloaks[initial(cloak_type.name)] = cloak_type
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(cloaks))

/datum/gear/suit/cloak/dept/ce
	display_name = "chief engineer cloak (Teshari)"
	path = /obj/item/clothing/suit/storage/teshari/cloak/jobs/ce
	allowed_roles = list(JOB_CHIEF_ENGINEER)

/datum/gear/suit/dept/cloak/ce/New()
	..()
	var/list/cloaks = list()
	for(var/cloak in typesof(/obj/item/clothing/suit/storage/teshari/cloak/jobs/ce,/obj/item/clothing/suit/storage/teshari/beltcloak/jobs/ce))
		var/obj/item/clothing/suit/storage/teshari/beltcloak/jobs/cloak_type = cloak
		cloaks[initial(cloak_type.name)] = cloak_type
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(cloaks))

/datum/gear/suit/dept/cloak/cmo
	display_name = "chief medical officer cloak (Teshari)"
	path = /obj/item/clothing/suit/storage/teshari/cloak/jobs/cmo
	allowed_roles = list(JOB_CHIEF_MEDICAL_OFFICER)

/datum/gear/suit/dept/cloak/cmo/New()
	..()
	var/list/cloaks = list()
	for(var/cloak in typesof(/obj/item/clothing/suit/storage/teshari/cloak/jobs/cmo,/obj/item/clothing/suit/storage/teshari/beltcloak/jobs/cmo))
		var/obj/item/clothing/suit/storage/teshari/beltcloak/jobs/cloak_type = cloak
		cloaks[initial(cloak_type.name)] = cloak_type
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(cloaks))

/datum/gear/suit/dept/cloak/qm
	display_name = "quartermaster cloak (Teshari)"
	path = /obj/item/clothing/suit/storage/teshari/cloak/jobs/qm
	allowed_roles = list(JOB_CHIEF_MEDICAL_OFFICER)

/datum/gear/suit/dept/cloak/qm/New()
	..()
	var/list/cloaks = list()
	for(var/cloak in typesof(/obj/item/clothing/suit/storage/teshari/cloak/jobs/qm,/obj/item/clothing/suit/storage/teshari/beltcloak/jobs/qm))
		var/obj/item/clothing/suit/storage/teshari/beltcloak/jobs/cloak_type = cloak
		cloaks[initial(cloak_type.name)] = cloak_type
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(cloaks))

/datum/gear/suit/dept/cloak/cargo
	display_name = "cargo cloak (Teshari)"
	path = /obj/item/clothing/suit/storage/teshari/cloak/jobs/cargo
	allowed_roles = list(JOB_QUARTERMASTER,JOB_SHAFT_MINER,JOB_CARGO_TECHNICIAN)

/datum/gear/suit/dept/cloak/cargo/New()
	..()
	var/list/cloaks = list()
	for(var/cloak in typesof(/obj/item/clothing/suit/storage/teshari/cloak/jobs/cargo,/obj/item/clothing/suit/storage/teshari/beltcloak/jobs/cargo))
		var/obj/item/clothing/suit/storage/teshari/beltcloak/jobs/cloak_type = cloak
		cloaks[initial(cloak_type.name)] = cloak_type
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(cloaks))

/datum/gear/suit/dept/cloak/mining
	display_name = "mining cloak (Teshari)"
	path = /obj/item/clothing/suit/storage/teshari/cloak/jobs/mining
	allowed_roles = list(JOB_QUARTERMASTER,JOB_SHAFT_MINER)

/datum/gear/suit/dept/cloak/mining/New()
	..()
	var/list/cloaks = list()
	for(var/cloak in typesof(/obj/item/clothing/suit/storage/teshari/cloak/jobs/mining,/obj/item/clothing/suit/storage/teshari/beltcloak/jobs/mining))
		var/obj/item/clothing/suit/storage/teshari/beltcloak/jobs/cloak_type = cloak
		cloaks[initial(cloak_type.name)] = cloak_type
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(cloaks))

/datum/gear/suit/dept/cloak/security
	display_name = "security cloak (Teshari)"
	path = /obj/item/clothing/suit/storage/teshari/cloak/jobs/sec
	allowed_roles = list(JOB_HEAD_OF_SECURITY,JOB_DETECTIVE,JOB_WARDEN,JOB_SECURITY_OFFICER)

/datum/gear/suit/dept/cloak/security/New()
	..()
	var/list/cloaks = list()
	for(var/cloak in typesof(/obj/item/clothing/suit/storage/teshari/cloak/jobs/sec,/obj/item/clothing/suit/storage/teshari/beltcloak/jobs/sec))
		var/obj/item/clothing/suit/storage/teshari/beltcloak/jobs/cloak_type = cloak
		cloaks[initial(cloak_type.name)] = cloak_type
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(cloaks))

/datum/gear/suit/dept/cloak/service
	display_name = "service cloak (Teshari)"
	path = /obj/item/clothing/suit/storage/teshari/cloak/jobs/service
	allowed_roles = list(JOB_HEAD_OF_PERSONNEL,"Bartender","Botanist","Janitor","Chef","Librarian","Chaplain")

/datum/gear/suit/dept/cloak/service/New()
	..()
	var/list/cloaks = list()
	for(var/cloak in typesof(/obj/item/clothing/suit/storage/teshari/cloak/jobs/service,/obj/item/clothing/suit/storage/teshari/beltcloak/jobs/service))
		var/obj/item/clothing/suit/storage/teshari/beltcloak/jobs/cloak_type = cloak
		cloaks[initial(cloak_type.name)] = cloak_type
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(cloaks))

/datum/gear/suit/dept/cloak/engineer
	display_name = "engineering cloak (Teshari)"
	path = /obj/item/clothing/suit/storage/teshari/cloak/jobs/engineer
	allowed_roles = list(JOB_CHIEF_ENGINEER,JOB_ENGINEER)

/datum/gear/suit/dept/cloak/engineer/New()
	..()
	var/list/cloaks = list()
	for(var/cloak in typesof(/obj/item/clothing/suit/storage/teshari/cloak/jobs/engineer,/obj/item/clothing/suit/storage/teshari/beltcloak/jobs/engineer))
		var/obj/item/clothing/suit/storage/teshari/beltcloak/jobs/cloak_type = cloak
		cloaks[initial(cloak_type.name)] = cloak_type
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(cloaks))

/datum/gear/suit/dept/cloak/atmos
	display_name = "atmospherics cloak (Teshari)"
	path = /obj/item/clothing/suit/storage/teshari/cloak/jobs/atmos
	allowed_roles = list(JOB_CHIEF_ENGINEER,JOB_ATMOSPHERIC_TECHNICIAN)

/datum/gear/suit/dept/cloak/atmos/New()
	..()
	var/list/cloaks = list()
	for(var/cloak in typesof(/obj/item/clothing/suit/storage/teshari/cloak/jobs/atmos,/obj/item/clothing/suit/storage/teshari/beltcloak/jobs/atmos))
		var/obj/item/clothing/suit/storage/teshari/beltcloak/jobs/cloak_type = cloak
		cloaks[initial(cloak_type.name)] = cloak_type
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(cloaks))

/datum/gear/suit/dept/cloak/research
	display_name = "scientist cloak (Teshari)"
	path = /obj/item/clothing/suit/storage/teshari/cloak/jobs/sci
	allowed_roles = list(JOB_RESEARCH_DIRECTOR,JOB_SCIENTIST,JOB_ROBOTICIST,JOB_XENOBIOLOGIST)

/datum/gear/suit/dept/cloak/research/New()
	..()
	var/list/cloaks = list()
	for(var/cloak in typesof(/obj/item/clothing/suit/storage/teshari/cloak/jobs/sci,/obj/item/clothing/suit/storage/teshari/beltcloak/jobs/sci))
		var/obj/item/clothing/suit/storage/teshari/beltcloak/jobs/cloak_type = cloak
		cloaks[initial(cloak_type.name)] = cloak_type
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(cloaks))

/datum/gear/suit/dept/cloak/robo
	display_name = "roboticist cloak (Teshari)"
	path = /obj/item/clothing/suit/storage/teshari/cloak/jobs/robo
	allowed_roles = list(JOB_RESEARCH_DIRECTOR,JOB_ROBOTICIST)

/datum/gear/suit/dept/cloak/robo/New()
	..()
	var/list/cloaks = list()
	for(var/cloak in typesof(/obj/item/clothing/suit/storage/teshari/cloak/jobs/robo,/obj/item/clothing/suit/storage/teshari/beltcloak/jobs/robo))
		var/obj/item/clothing/suit/storage/teshari/beltcloak/jobs/cloak_type = cloak
		cloaks[initial(cloak_type.name)] = cloak_type
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(cloaks))

/datum/gear/suit/dept/cloak/medical
	display_name = "medical cloak (Teshari)"
	path = /obj/item/clothing/suit/storage/teshari/cloak/jobs/medical
	allowed_roles = list(JOB_CHIEF_MEDICAL_OFFICER,JOB_MEDICAL_DOCTOR,JOB_CHEMIST,JOB_PARAMEDIC,JOB_GENETICIST, JOB_PSYCHIATRIST)

/datum/gear/suit/dept/cloak/medical/New()
	..()
	var/list/cloaks = list()
	for(var/cloak in typesof(/obj/item/clothing/suit/storage/teshari/cloak/jobs/medical,/obj/item/clothing/suit/storage/teshari/beltcloak/jobs/medical))
		var/obj/item/clothing/suit/storage/teshari/beltcloak/jobs/cloak_type = cloak
		cloaks[initial(cloak_type.name)] = cloak_type
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(cloaks))

/datum/gear/suit/dept/cloak/chemistry
	display_name = "chemist cloak (Teshari)"
	path = /obj/item/clothing/suit/storage/teshari/cloak/jobs/chemistry
	allowed_roles = list(JOB_CHEMIST)

/datum/gear/suit/dept/cloak/chemistry/New()
	..()
	var/list/cloaks = list()
	for(var/cloak in typesof(/obj/item/clothing/suit/storage/teshari/cloak/jobs/chemistry,/obj/item/clothing/suit/storage/teshari/beltcloak/jobs/chemistry))
		var/obj/item/clothing/suit/storage/teshari/beltcloak/jobs/cloak_type = cloak
		cloaks[initial(cloak_type.name)] = cloak_type
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(cloaks))

/datum/gear/suit/dept/cloak/virology
	display_name = "virologist cloak (Teshari)"
	path = /obj/item/clothing/suit/storage/teshari/cloak/jobs/viro
	allowed_roles = list(JOB_MEDICAL_DOCTOR)

/datum/gear/suit/dept/cloak/virology/New()
	..()
	var/list/cloaks = list()
	for(var/cloak in typesof(/obj/item/clothing/suit/storage/teshari/cloak/jobs/viro,/obj/item/clothing/suit/storage/teshari/beltcloak/jobs/viro))
		var/obj/item/clothing/suit/storage/teshari/beltcloak/jobs/cloak_type = cloak
		cloaks[initial(cloak_type.name)] = cloak_type
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(cloaks))

/datum/gear/suit/dept/cloak/psych
	display_name = "psychiatrist cloak (Teshari)"
	path = /obj/item/clothing/suit/storage/teshari/cloak/jobs/psych
	allowed_roles = list(JOB_CHIEF_MEDICAL_OFFICER,JOB_PSYCHIATRIST)

/datum/gear/suit/dept/cloak/paramedic
	display_name = "paramedic cloak (Teshari)"
	path = /obj/item/clothing/suit/storage/teshari/cloak/jobs/para
	allowed_roles = list(JOB_CHIEF_MEDICAL_OFFICER,JOB_PARAMEDIC)

/datum/gear/suit/dept/cloak/paramedic/New()
	..()
	var/list/cloaks = list()
	for(var/cloak in typesof(/obj/item/clothing/suit/storage/teshari/cloak/jobs/para,/obj/item/clothing/suit/storage/teshari/beltcloak/jobs/para))
		var/obj/item/clothing/suit/storage/teshari/beltcloak/jobs/cloak_type = cloak
		cloaks[initial(cloak_type.name)] = cloak_type
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(cloaks))

/datum/gear/suit/dept/cloak/iaa
	display_name = "internal affairs cloak (Teshari)"
	path = /obj/item/clothing/suit/storage/teshari/cloak/jobs/iaa
	allowed_roles = list("Internal Affairs Agent")

/datum/gear/suit/dept/cloak/iaa/New()
	..()
	var/list/cloaks = list()
	for(var/cloak in typesof(/obj/item/clothing/suit/storage/teshari/cloak/jobs/iaa,/obj/item/clothing/suit/storage/teshari/beltcloak/jobs/iaa))
		var/obj/item/clothing/suit/storage/teshari/beltcloak/jobs/cloak_type = cloak
		cloaks[initial(cloak_type.name)] = cloak_type
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(cloaks))

/datum/gear/uniform/smockcolor
	display_name = "smock, recolorable (Teshari)"
	path = /obj/item/clothing/under/teshari/smock/white
	whitelisted = SPECIES_TESHARI
	sort_category = "Xenowear"

/datum/gear/uniform/smockcolor/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/suit/beltcloak
	display_name = "belted cloak selection (Teshari)"
	path = /obj/item/clothing/suit/storage/teshari/beltcloak/standard
	whitelisted = SPECIES_TESHARI
	sort_category = "Xenowear"

/datum/gear/suit/beltcloak/New()
	..()
	var/list/cloaks = list()
	for(var/cloak in typesof(/obj/item/clothing/suit/storage/teshari/beltcloak/standard))
		var/obj/item/clothing/suit/storage/teshari/beltcloak/standard/cloak_type = cloak
		cloaks[initial(cloak_type.name)] = cloak_type
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(cloaks))

/datum/gear/suit/beltcloak_color
	display_name = "belted cloak, recolorable (Teshari)"
	path = /obj/item/clothing/suit/storage/teshari/beltcloak/standard/white_grey
	whitelisted = SPECIES_TESHARI
	sort_category = "Xenowear"

/datum/gear/suit/beltcloak_color/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/suit/dept/beltcloak/wrdn
	display_name = "warden belted cloak (Teshari)"
	path = /obj/item/clothing/suit/storage/teshari/beltcloak/jobs/wrdn
	allowed_roles = list(JOB_HEAD_OF_SECURITY,JOB_WARDEN)
	sort_category = "Xenowear"

/datum/gear/suit/dept/beltcloak/jani
	display_name = "janitor belted cloak (Teshari)"
	path = /obj/item/clothing/suit/storage/teshari/beltcloak/jobs/jani
	allowed_roles = list("Janitor")
	sort_category = "Xenowear"

/datum/gear/suit/dept/beltcloak/cmd
	display_name = "command belted cloak (Teshari)"
	path = /obj/item/clothing/suit/storage/teshari/beltcloak/jobs/command
	allowed_roles = list(JOB_SITE_MANAGER,JOB_HEAD_OF_PERSONNEL,JOB_HEAD_OF_SECURITY,JOB_CHIEF_ENGINEER,JOB_CHIEF_MEDICAL_OFFICER,JOB_RESEARCH_DIRECTOR)
	sort_category = "Xenowear"

/datum/gear/suit/cloak_hood
	display_name = "hooded cloak selection (Teshari)"
	path = /obj/item/clothing/suit/storage/hooded/teshari/standard
	whitelisted = SPECIES_TESHARI
	sort_category = "Xenowear"

/datum/gear/suit/cloak_hood/New()
	..()
	var/list/cloaks = list()
	for(var/cloak in typesof(/obj/item/clothing/suit/storage/hooded/teshari/standard))
		var/obj/item/clothing/suit/storage/teshari/cloak/cloak_type = cloak
		cloaks[initial(cloak_type.name)] = cloak_type
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(cloaks))

/datum/gear/uniform/worksuit
	display_name = "worksuit selection (Teshari)"
	path = /obj/item/clothing/under/teshari/undercoat/standard/worksuit
	whitelisted = SPECIES_TESHARI
	sort_category = "Xenowear"

/datum/gear/uniform/worksuit/New()
	..()
	var/list/worksuits = list()
	for(var/worksuit in typesof(/obj/item/clothing/under/teshari/undercoat/standard/worksuit))
		var/obj/item/clothing/under/teshari/undercoat/standard/worksuit/worksuit_type = worksuit
		worksuits[initial(worksuit_type.name)] = worksuit_type
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(worksuits))

/datum/gear/uniform/undercoatcolor
	display_name = "undercoat, recolorable (Teshari)"
	path = /obj/item/clothing/under/teshari/undercoat/standard/white_grey
	whitelisted = SPECIES_TESHARI
	sort_category = "Xenowear"

/datum/gear/uniform/undercoatcolor/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/suit/cloakcolor
	display_name = "cloak, recolorable (Teshari)"
	path = /obj/item/clothing/suit/storage/teshari/cloak/standard/white_grey
	whitelisted = SPECIES_TESHARI
	sort_category = "Xenowear"

/datum/gear/suit/cloakcolor/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/suit/labcoat_tesh
	display_name = "labcoat, colorable (Teshari)"
	path = /obj/item/clothing/suit/storage/toggle/labcoat/teshari
	whitelisted = SPECIES_TESHARI
	sort_category = "Xenowear"

/datum/gear/suit/labcoat_tesh/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/suit/teshcoat
	display_name = "small black coat, recolorable stripes (Teshari)"
	path = /obj/item/clothing/suit/storage/toggle/tesharicoat
	whitelisted = SPECIES_TESHARI
	sort_category = "Xenowear"

/datum/gear/suit/teshcoat/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/suit/teshcoatwhite
	display_name = "smallcoat, recolorable (Teshari)"
	path = /obj/item/clothing/suit/storage/toggle/tesharicoatwhite
	whitelisted = SPECIES_TESHARI
	sort_category = "Xenowear"

/datum/gear/suit/teshcoatwhite/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/accessory/teshneckscarf
	display_name = "neckscarf, recolorable (Teshari)"
	path = /obj/item/clothing/accessory/scarf/teshari/neckscarf
	whitelisted = SPECIES_TESHARI
	sort_category = "Xenowear"

/datum/gear/accessory/teshneckscarf/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/shoes/toelessjack
	display_name = "toe-less jackboots"
	path = /obj/item/clothing/shoes/boots/jackboots/toeless

/datum/gear/shoes/toelessknee
	display_name = "toe-less jackboots, knee-length"
	path = /obj/item/clothing/shoes/boots/jackboots/toeless/knee

/datum/gear/shoes/toelessthigh
	display_name = "toe-less jackboots, thigh-length"
	path = /obj/item/clothing/shoes/boots/jackboots/toeless/thigh

/datum/gear/eyes/aerogelgoggles
	display_name = "airtight orange goggles (Teshari)"
	path = /obj/item/clothing/glasses/aerogelgoggles
	whitelisted = SPECIES_TESHARI
	sort_category = "Xenowear"

/datum/gear/utility/teshchair
	display_name = "small electric wheelchair (Teshari)"
	path = /obj/item/wheelchair/motor/small
	whitelisted = SPECIES_TESHARI
	sort_category = "Xenowear"
	cost = 4

/datum/gear/shoes/teshwrap
	display_name = "Teshari legwraps"
	path = /obj/item/clothing/shoes/footwraps/teshari
	sort_category = "Xenowear"
	whitelisted = SPECIES_TESHARI
	cost = 1

/datum/gear/shoes/teshwrap/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice
