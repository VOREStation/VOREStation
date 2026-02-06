/datum/trait/autohiss_unathi
	name = "Autohiss (Unathi)"
	desc = "You roll your S's and x's"
	cost = 0
	custom_only = FALSE
	category = TRAIT_TYPE_NEUTRAL
	var_changes = list(
	autohiss_basic_map = list(
			"s" = list("ss", "sss", "ssss")
		),
	autohiss_extra_map = list(
			"x" = list("ks", "kss", "ksss")
		),
	autohiss_exempt = list(LANGUAGE_UNATHI))
	excludes = list(
		/datum/trait/autohiss_tajaran,
		/datum/trait/autohiss_zaddat,
		/datum/trait/autohiss_vassilian,
		/datum/trait/autohiss_yingish,
		/datum/trait/autohiss_unathi/xenochimera,
		/datum/trait/autohiss_tajaran/xenochimera,
		/datum/trait/autohiss_zaddat/xenochimera,
		/datum/trait/autohiss_vassilian/xenochimera,
		/datum/trait/autohiss_yingish/xenochimera)

/datum/trait/autohiss_tajaran
	name = "Autohiss (Tajaran)"
	desc = "You roll your R's."
	cost = 0
	custom_only = FALSE
	category = TRAIT_TYPE_NEUTRAL
	var_changes = list(
	autohiss_basic_map = list(
			"r" = list("rr", "rrr", "rrrr")
		),
	autohiss_exempt = list(LANGUAGE_SIIK,LANGUAGE_AKHANI,LANGUAGE_ALAI))
	excludes = list(
		/datum/trait/autohiss_unathi,
		/datum/trait/autohiss_zaddat,
		/datum/trait/autohiss_vassilian,
		/datum/trait/autohiss_yingish,
		/datum/trait/autohiss_unathi/xenochimera,
		/datum/trait/autohiss_tajaran/xenochimera,
		/datum/trait/autohiss_zaddat/xenochimera,
		/datum/trait/autohiss_vassilian/xenochimera,
		/datum/trait/autohiss_yingish/xenochimera)

/datum/trait/autohiss_zaddat
	name = "Autohiss (Zaddat)"
	desc = "You buzz your S's and F's."
	cost = 0
	custom_only = FALSE
	category = TRAIT_TYPE_NEUTRAL
	var_changes = list(
	autohiss_basic_map = list(
			"f" = list("v","vh"),
			"ph" = list("v", "vh")
		),
	autohiss_extra_map = list(
			"s" = list("z", "zz", "zzz"),
			"ce" = list("z", "zz"),
			"ci" = list("z", "zz"),
			"v" = list("vv", "vvv")
		),
	autohiss_exempt = list(LANGUAGE_ZADDAT,LANGUAGE_VESPINAE))
	excludes = list(
		/datum/trait/autohiss_tajaran,
		/datum/trait/autohiss_unathi,
		/datum/trait/autohiss_vassilian,
		/datum/trait/autohiss_yingish,
		/datum/trait/autohiss_unathi/xenochimera,
		/datum/trait/autohiss_tajaran/xenochimera,
		/datum/trait/autohiss_zaddat/xenochimera,
		/datum/trait/autohiss_vassilian/xenochimera,
		/datum/trait/autohiss_yingish/xenochimera)

/datum/trait/autohiss_vassilian
	name = "Autohiss (Vassilian)"
	desc = "You buzz your S's, F's, Th's, and R's."
	cost = 0
	custom_only = FALSE
	category = TRAIT_TYPE_NEUTRAL
	var_changes = list(
	autohiss_basic_map = list(
		"s" = list("sz", "z", "zz"),
		"f" = list("zk")
		),
	autohiss_extra_map = list(
		"th" = list("zk", "szk"),
		"r" = list("rk")
	),
	autohiss_exempt = list(LANGUAGE_VESPINAE))
	excludes = list(
		/datum/trait/autohiss_tajaran,
		/datum/trait/autohiss_unathi,
		/datum/trait/autohiss_zaddat,
		/datum/trait/autohiss_yingish,
		/datum/trait/autohiss_unathi/xenochimera,
		/datum/trait/autohiss_tajaran/xenochimera,
		/datum/trait/autohiss_zaddat/xenochimera,
		/datum/trait/autohiss_vassilian/xenochimera,
		/datum/trait/autohiss_yingish/xenochimera)

/datum/trait/autohiss_yingish
	name = "Autohiss (Yingish)"
	desc = "You pronounce th's with a lisp, a bit like zhis!"
	cost = 0
	custom_only = FALSE
	category = TRAIT_TYPE_NEUTRAL
	var_changes = list(
	autohiss_basic_map = list(
			"thi" = list("z"),
			"shi" = list("z"),
			"tha" = list("z"),
			"tho" = list("z")
		),
	autohiss_extra_map = list(
			"the" = list("z"),
			"so" = list("z")
		),
	autohiss_exempt = list())
	excludes = list(
		/datum/trait/autohiss_tajaran,
		/datum/trait/autohiss_unathi,
		/datum/trait/autohiss_zaddat,
		/datum/trait/autohiss_vassilian,
		/datum/trait/autohiss_unathi/xenochimera,
		/datum/trait/autohiss_tajaran/xenochimera,
		/datum/trait/autohiss_zaddat/xenochimera,
		/datum/trait/autohiss_vassilian/xenochimera,
		/datum/trait/autohiss_yingish/xenochimera)


//Xenochimera stuff
/datum/trait/autohiss_unathi/xenochimera
	sort = TRAIT_SORT_SPECIES
	allowed_species = list(SPECIES_XENOCHIMERA)
	name = "Xenochimera: Autohiss (Unathi)"
	desc = "You roll your S's and x's"
	cost = 0
	custom_only = FALSE
	category = TRAIT_TYPE_NEUTRAL
	var_changes = list(
	autohiss_basic_map = list(
			"s" = list("ss", "sss", "ssss")
		),
	autohiss_extra_map = list(
			"x" = list("ks", "kss", "ksss")
		),
	autohiss_exempt = list("Sinta'unathi"))
	excludes = list(
		/datum/trait/autohiss_unathi,
		/datum/trait/autohiss_tajaran,
		/datum/trait/autohiss_zaddat,
		/datum/trait/autohiss_vassilian,
		/datum/trait/autohiss_yingish,
		/datum/trait/autohiss_tajaran/xenochimera,
		/datum/trait/autohiss_zaddat/xenochimera,
		/datum/trait/autohiss_vassilian/xenochimera,
		/datum/trait/autohiss_yingish/xenochimera)

/datum/trait/autohiss_tajaran/xenochimera
	sort = TRAIT_SORT_SPECIES
	allowed_species = list(SPECIES_XENOCHIMERA)
	name = "Xenochimera: Autohiss (Tajaran)"
	desc = "You roll your R's."
	cost = 0
	custom_only = FALSE
	category = TRAIT_TYPE_NEUTRAL
	var_changes = list(
	autohiss_basic_map = list(
			"r" = list("rr", "rrr", "rrrr")
		),
	autohiss_exempt = list("Siik"))
	excludes = list(
		/datum/trait/autohiss_unathi,
		/datum/trait/autohiss_tajaran,
		/datum/trait/autohiss_zaddat,
		/datum/trait/autohiss_vassilian,
		/datum/trait/autohiss_yingish,
		/datum/trait/autohiss_unathi/xenochimera,
		/datum/trait/autohiss_zaddat/xenochimera,
		/datum/trait/autohiss_vassilian/xenochimera,
		/datum/trait/autohiss_yingish/xenochimera)

/datum/trait/autohiss_zaddat/xenochimera
	sort = TRAIT_SORT_SPECIES
	allowed_species = list(SPECIES_XENOCHIMERA)
	name = "Xenochimera: Autohiss (Zaddat)"
	desc = "You buzz your S's and F's."
	cost = 0
	custom_only = FALSE
	category = TRAIT_TYPE_NEUTRAL
	var_changes = list(
	autohiss_basic_map = list(
			"f" = list("v","vh"),
			"ph" = list("v", "vh")
		),
	autohiss_extra_map = list(
			"s" = list("z", "zz", "zzz"),
			"ce" = list("z", "zz"),
			"ci" = list("z", "zz"),
			"v" = list("vv", "vvv")
		),
	autohiss_exempt = list(LANGUAGE_ZADDAT,LANGUAGE_VESPINAE))
	excludes = list(
		/datum/trait/autohiss_tajaran,
		/datum/trait/autohiss_unathi,
		/datum/trait/autohiss_zaddat,
		/datum/trait/autohiss_vassilian,
		/datum/trait/autohiss_yingish,
		/datum/trait/autohiss_unathi/xenochimera,
		/datum/trait/autohiss_tajaran/xenochimera,
		/datum/trait/autohiss_vassilian/xenochimera,
		/datum/trait/autohiss_yingish/xenochimera)

/datum/trait/autohiss_vassilian/xenochimera
	sort = TRAIT_SORT_SPECIES
	allowed_species = list(SPECIES_XENOCHIMERA)
	name = "Xenochimera: Autohiss (Vassilian)"
	desc = "You buzz your S's, F's, Th's, and R's."
	cost = 0
	custom_only = FALSE
	category = TRAIT_TYPE_NEUTRAL
	var_changes = list(
	autohiss_basic_map = list(
		"s" = list("sz", "z", "zz"),
		"f" = list("zk")
		),
	autohiss_extra_map = list(
		"th" = list("zk", "szk"),
		"r" = list("rk")
	),
	autohiss_exempt = list(LANGUAGE_VESPINAE))
	excludes = list(
		/datum/trait/autohiss_tajaran,
		/datum/trait/autohiss_unathi,
		/datum/trait/autohiss_zaddat,
		/datum/trait/autohiss_vassilian,
		/datum/trait/autohiss_yingish,
		/datum/trait/autohiss_unathi/xenochimera,
		/datum/trait/autohiss_tajaran/xenochimera,
		/datum/trait/autohiss_zaddat/xenochimera,
		/datum/trait/autohiss_yingish/xenochimera)

/datum/trait/autohiss_yingish/xenochimera
	sort = TRAIT_SORT_SPECIES
	allowed_species = list(SPECIES_XENOCHIMERA)
	name = "Xenochimera: Autohiss (Yingish)"
	desc = "You pronounce th's with a lisp, a bit like zhis!"
	cost = 0
	custom_only = FALSE
	category = TRAIT_TYPE_NEUTRAL
	var_changes = list(
	autohiss_basic_map = list(
			"thi" = list("z"),
			"shi" = list("z"),
			"tha" = list("z"),
			"tho" = list("z")
		),
	autohiss_extra_map = list(
			"the" = list("z"),
			"so" = list("z")
		),
	autohiss_exempt = list())
	excludes = list(
		/datum/trait/autohiss_tajaran,
		/datum/trait/autohiss_unathi,
		/datum/trait/autohiss_zaddat,
		/datum/trait/autohiss_vassilian,
		/datum/trait/autohiss_yingish,
		/datum/trait/autohiss_unathi/xenochimera,
		/datum/trait/autohiss_tajaran/xenochimera,
		/datum/trait/autohiss_zaddat/xenochimera,
		/datum/trait/autohiss_vassilian/xenochimera)
