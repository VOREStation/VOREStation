/*
*	Here is where any supply packs
*	related to hardsuits live.
*/


/datum/supply_pack/hardsuits
	group = "Hardsuits"

/datum/supply_pack/hardsuits/eva_rig
	name = "EVA hardsuit (empty)"
	desc = "An EVA hardsuit with no components. Requires Mining, EVA, or Pilot's access."
	contains = list(
			/obj/item/rig/eva = 1
			)
	cost = 150
	containertype = /obj/structure/closet/crate/secure/gear
	containername = "eva hardsuit crate"
	access = list(access_mining,
				  access_eva,
				  access_pilot)
	one_access = TRUE

/datum/supply_pack/hardsuits/mining_rig
	name = "industrial hardsuit (empty)"
	desc = "A standard mining hardsuit with no components. Requires Mining or EVA access."
	contains = list(
			/obj/item/rig/industrial = 1
			)
	cost = 150
	containertype = /obj/structure/closet/crate/secure/gear
	containername = "industrial hardsuit crate"
	access = list(access_mining,
				  access_eva)
	one_access = TRUE

/datum/supply_pack/hardsuits/medical_rig
	name = "medical hardsuit (empty)"
	desc = "A medical hardsuit with no components. Requires Medical access."
	contains = list(
			/obj/item/rig/medical = 1
			)
	cost = 150
	containertype = /obj/structure/closet/crate/secure/gear
	containername = "medical hardsuit crate"
	access = access_medical

/datum/supply_pack/hardsuits/security_rig
	name = "hazard hardsuit (empty)"
	desc = "A hazardous environment combat hardsuit with no components. Requires Armory access."
	contains = list(
			/obj/item/rig/hazard = 1
			)
	cost = 150
	containertype = /obj/structure/closet/crate/secure/gear
	containername = "hazard hardsuit crate"
	access = access_armory

/datum/supply_pack/hardsuits/science_rig
	name = "ami hardsuit (empty)"
	desc = "An advanced Materials hardsuit, with no components. Requires Research Director authorization."
	contains = list(
			/obj/item/rig/hazmat = 1
			)
	cost = 150
	containertype = /obj/structure/closet/crate/secure/gear
	containername = "ami hardsuit crate"
	access = access_rd

/datum/supply_pack/hardsuits/ce_rig
	name = "advanced hardsuit (empty)"
	desc = "An advanced Engineering hardsuit, with no components. Requires Chief Engineer authorization."
	contains = list(
			/obj/item/rig/ce = 1
			)
	cost = 150
	containertype = /obj/structure/closet/crate/secure/gear
	containername = "advanced hardsuit crate"
	access = access_ce

/datum/supply_pack/hardsuits/com_medical_rig
	name = "commonwealth medical hardsuit (loaded)"
	desc = "A fully-equipped Commonwealth of Sol-Procyon Medical hardsuit. Requires Medical access."
	contains = list(
			/obj/item/rig/baymed/equipped = 1
			)
	cost = 250
	containertype = /obj/structure/closet/crate/secure/gear
	containername = "Commonwealth medical hardsuit crate"
	access = access_medical

/datum/supply_pack/hardsuits/com_engineering_rig
	name = "commonwealth engineering hardsuit (loaded)"
	desc = "A fully-equipped Commonwealth of Sol-Procyon Engineering hardsuit. Requires Engineering access."
	contains = list(
			/obj/item/rig/bayeng/equipped = 1
			)
	cost = 250
	containertype = /obj/structure/closet/crate/secure/gear
	containername = "Commonwealth engineering hardsuit crate"
	access = access_engine

/datum/supply_pack/hardsuits/breacher_rig
	name = "unathi breacher hardsuit (empty)"
	desc = "A Hegemony \'Breacher\' combat hardsuit. Requires Armory access, and can only be worn by unathi."
	contains = list(
			/obj/item/rig/breacher = 1
			)
	cost = 250
	containertype = /obj/structure/closet/crate/secure/gear
	containername = "unathi breacher hardsuit crate"
	access = access_armory

/datum/supply_pack/hardsuits/zero_rig
	name = "null hardsuit (jets)"
	desc = "A low-profile hardsuit with pre-installed maneuvering jets."
	contains = list(
			/obj/item/rig/zero = 1
			)
	cost = 75
	containertype = /obj/structure/closet/crate/secure/gear
	containername = "null hardsuit crate"