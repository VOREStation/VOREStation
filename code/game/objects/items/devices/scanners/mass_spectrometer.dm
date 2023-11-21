/obj/item/device/mass_spectrometer
	name = "mass spectrometer"
	desc = "A hand-held mass spectrometer which identifies trace chemicals in a blood sample."
	icon_state = "spectrometer"
	w_class = ITEMSIZE_SMALL
	flags = OPENCONTAINER
	slot_flags = SLOT_BELT
	throwforce = 5
	throw_speed = 4
	throw_range = 20

	matter = list(MAT_STEEL = 30,MAT_GLASS = 20)

	origin_tech = list(TECH_MAGNET = 2, TECH_BIO = 2)
	var/details = 0
	var/recent_fail = 0

/obj/item/device/mass_spectrometer/New()
	..()
	var/datum/reagents/R = new/datum/reagents(5)
	reagents = R
	R.my_atom = src

/obj/item/device/mass_spectrometer/on_reagent_change()
	if(reagents.total_volume)
		icon_state = initial(icon_state) + "_s"
	else
		icon_state = initial(icon_state)

/obj/item/device/mass_spectrometer/attack_self(mob/user as mob)
	if (user.stat)
		return
	if (!user.IsAdvancedToolUser())
		to_chat(user, "<span class='warning'>You don't have the dexterity to do this!</span>")
		return
	if(reagents.total_volume)
		var/list/blood_traces = list()
		for(var/datum/reagent/R in reagents.reagent_list)
			if(R.id != "blood")
				reagents.clear_reagents()
				to_chat(user, "<span class='warning'>The sample was contaminated! Please insert another sample</span>")
				return
			else
				blood_traces = params2list(R.data["trace_chem"])
				break
		var/dat = "Trace Chemicals Found: "
		for(var/R in blood_traces)
			if(details)
				dat += "[R] ([blood_traces[R]] units) "
			else
				dat += "[R] "
		to_chat(user, "[dat]")
		reagents.clear_reagents()
	return

/obj/item/device/mass_spectrometer/adv
	name = "advanced mass spectrometer"
	icon_state = "adv_spectrometer"
	details = 1
	origin_tech = list(TECH_MAGNET = 4, TECH_BIO = 2)