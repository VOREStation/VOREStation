// Contains old mediciation, most of it unidentified and has a good chance of being useless.
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/datum/element/lootable/expired_medicine
	chance_uncommon = 0
	chance_rare = 0
	common_loot = list(
		/obj/random/unidentified_medicine/old_medicine,
		/obj/item/storage/pill_bottle/maintenance,
		/obj/item/reagent_containers/pill/maintenance
	)

// Like the above but has way better odds, in exchange for being in a place still inhabited (or was recently).
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/datum/element/lootable/fresh_medicine
	chance_uncommon = 0
	chance_rare = 0
	common_loot = list(
		/obj/random/unidentified_medicine/fresh_medicine
	)
