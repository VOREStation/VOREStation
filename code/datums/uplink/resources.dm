
/datum/uplink_item/crated/resources
	name = "Resource Crate"
	desc = "A crate routed from an in-system trading post, containing various valuable materials."
	item_cost = 60
	category = /datum/uplink_category/services

	paths = list(\
	/obj/fiftyspawner/uranium,\
	/obj/fiftyspawner/phoron,\
	/obj/fiftyspawner/gold,\
	/obj/fiftyspawner/silver,\
	/obj/fiftyspawner/osmium,\
	/obj/fiftyspawner/plasteel\
	)

/datum/uplink_item/crated/seeds
	name = "Exotic Plantlife Crate"
	desc = "A crate routed from an in-system trading post, containing various exotic plants."
	item_cost = 20
	category = /datum/uplink_category/services

	paths = list(\
	/obj/item/seeds/random,\
	/obj/item/seeds/random,\
	/obj/item/seeds/random,\
	/obj/item/seeds/random,\
	/obj/item/seeds/random,\
	/obj/item/seeds/random,\
	/obj/item/seeds/random,\
	/obj/item/seeds/random\
	)

/datum/uplink_item/crated/spare_organs
	name = "Spare Organ Crate"
	desc = "A crate stolen from a medical relief ship, containing various bioprinted organs."
	item_cost = 20
	category = /datum/uplink_category/services
	crate_path = /obj/structure/closet/crate/freezer

	paths = list(\
	/obj/item/organ/internal/eyes/replicant,\
	/obj/item/organ/internal/heart/replicant,\
	/obj/item/organ/internal/kidneys/replicant,\
	/obj/item/organ/internal/liver/replicant,\
	/obj/item/organ/internal/lungs/replicant,\
	/obj/item/organ/internal/voicebox/replicant\
	)
