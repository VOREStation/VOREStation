/datum/design_techweb/board/dna_analyzer
	SET_CIRCUIT_DESIGN_NAMEDESC("DNA analyzer")
	id = "dna_analyzer"
	build_path = /obj/item/circuitboard/dna_analyzer
	category = list(
		RND_CATEGORY_COMPUTER + RND_SUBCATEGORY_MACHINE_SECURITY
	)
	departmental_flags = DEPARTMENT_BITFLAG_SECURITY | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/board/bodycam_monitor
	SET_CIRCUIT_DESIGN_NAMEDESC("security bodycamera monitor")
	id = "bodycam_monitor"
	build_path = /obj/item/circuitboard/security/telescreen/bodycamera
	category = list(
		RND_CATEGORY_COMPUTER + RND_SUBCATEGORY_MACHINE_SECURITY
	)
	departmental_flags = DEPARTMENT_BITFLAG_SECURITY | DEPARTMENT_BITFLAG_SCIENCE
