/obj/item/reagent_scanner
	name = "reagent scanner"
	desc = "A hand-held reagent scanner which identifies chemical agents."
	icon_state = "spectrometer"
	item_state = "analyzer"
	w_class = ITEMSIZE_SMALL
	slot_flags = SLOT_BELT
	throwforce = 5
	throw_speed = 4
	throw_range = 20
	matter = list(MAT_STEEL = 30,MAT_GLASS = 20)

	origin_tech = list(TECH_MAGNET = 2, TECH_BIO = 2)
	var/details = 0
	var/recent_fail = 0

/obj/item/reagent_scanner/afterattack(obj/O, mob/living/user, proximity)
	if(!proximity || user.stat || !istype(O))
		return
	if(!istype(user))
		return

	if(!isnull(O.reagents))
		if(!(O.flags & OPENCONTAINER)) // The idea is that the scanner has to touch the reagents somehow. This is done to prevent cheesing unidentified autoinjectors.
			to_chat(user, span("warning", "\The [O] is sealed, and cannot be scanned by \the [src] until unsealed."))
			return

		var/dat = ""
		if(O.reagents.reagent_list.len > 0)
			var/one_percent = O.reagents.total_volume / 100
			for (var/datum/reagent/R in O.reagents.reagent_list)
				dat += "\n \t " + span("notice", "[R][details ? ": [R.volume / one_percent]%" : ""]")
		if(dat)
			to_chat(user, span("notice", "Chemicals found: [dat]"))
		else
			to_chat(user, span("notice", "No active chemical agents found in [O]."))
	else
		to_chat(user, span("notice", "No significant chemical agents found in [O]."))

	return

/obj/item/reagent_scanner/adv
	name = "advanced reagent scanner"
	icon_state = "adv_spectrometer"
	details = 1
	origin_tech = list(TECH_MAGNET = 4, TECH_BIO = 2)
