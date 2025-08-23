/obj/item/reagent_containers/chem_canister
	name = "chemical canister"
	desc = "Used to refill chemical dispensers. Uses special chemical safety technology to prevent tampering. It will attempt to fully dispense its contents into any container it is connected to."

	icon = 'icons/obj/chemical.dmi'
	icon_state = "container"

	drop_sound = 'sound/items/drop/gascan.ogg'
	pickup_sound = 'sound/items/pickup/gascan.ogg'

	w_class = ITEMSIZE_COST_LARGE

	flags = NOREACT

	volume = CARTRIDGE_VOLUME_LARGE
	amount_per_transfer_from_this = CARTRIDGE_VOLUME_LARGE
	max_transfer_amount = null //Can be null as there was only one value set previously anyway
	unacidable = TRUE

	VAR_PROTECTED/loaded_reagent = null
	VAR_PRIVATE/label = ""

/obj/item/reagent_containers/chem_canister/Initialize(mapload)
	. = ..()
	if(loaded_reagent)
		var/datum/reagent/R = SSchemistry.chemical_reagents[loaded_reagent]
		if(R) // Sanity check the reagent
			set_canister(R.name,R.id)
			reagents.add_reagent(R.id, volume)
	// Can't be set on these
	src.verbs -= /obj/item/reagent_containers/verb/set_APTFT
	update_icon()

/obj/item/reagent_containers/chem_canister/examine(mob/user)
	. = ..()
	if(reagents.total_volume <= 0)
		. += "It is empty."
	else
		. += "It contains [reagents.total_volume] units of liquid."

/obj/item/reagent_containers/chem_canister/proc/set_canister(var/labl,var/reagent_id)
	setLabel(labl)
	loaded_reagent = reagent_id

/obj/item/reagent_containers/chem_canister/proc/setLabel(L)
	PRIVATE_PROC(TRUE)
	if(L)
		label = L
		name = "[initial(name)] - '[L]'"
	else
		label = ""
		name = initial(name)

/obj/item/reagent_containers/chem_canister/afterattack(obj/target, mob/user , flag)
	if (!flag)
		return

	else if(istype(target, /obj/machinery/chemical_dispenser)) //A dispenser. Refill a matching reagent container in it!
		target.add_fingerprint(user)

		if(!reagents.total_volume)
			to_chat(user, span_warning("\The [src] is empty."))
			return

		var/found_any = FALSE
		var/obj/machinery/chemical_dispenser/DISP = target
		for(var/key in DISP.cartridges)
			var/obj/item/reagent_containers/chem_disp_cartridge/C = DISP.cartridges[key]
			if(C && C.label == label) // This allows it to be player configured
				found_any = TRUE
				if(C.reagents.total_volume >= C.reagents.maximum_volume)
					continue
				reagents.trans_to_obj(C, amount_per_transfer_from_this)
				update_icon()
				SStgui.update_uis(DISP)
				to_chat(user, span_notice("You fill \the [target] with '\the [src]."))
				return

		if(found_any)
			to_chat(user, span_notice("The [label] is already full."))
		else
			to_chat(user, span_notice("\The [target] has no [label] cartridges to fill."))

	if(target.is_open_container() && target.reagents) //Something like a glass. Player probably wants to transfer TO it.

		if(!reagents.total_volume)
			to_chat(user, span_warning("\The [src] is empty."))
			return

		if(target.reagents.total_volume >= target.reagents.maximum_volume)
			to_chat(user, span_warning("\The [target] is full."))
			return

		var/trans = src.reagents.trans_to_obj(target, amount_per_transfer_from_this)
		to_chat(user, span_notice("You transfer [trans] units of the solution to \the [target]."))
		update_icon()

	else
		return ..()

/obj/item/reagent_containers/chem_canister/on_reagent_change(changetype)
	update_icon()

/obj/item/reagent_containers/chem_canister/update_icon()
	. = ..()
	cut_overlays()
	if(reagents && reagents.total_volume > 0)
		var/percent = (reagents.total_volume / reagents.maximum_volume) * 100
		switch(percent)
			if(0 to 25)			percent = 25
			if(25 to 50)		percent = 50
			if(50 to 75)		percent = 75
			if(75 to INFINITY)	percent = 100
		var/image/chems = image(icon, icon_state = "[icon_state]_c[percent]", dir = NORTH)
		chems.color = reagents.get_color()
		add_overlay(chems)


// Preloads
/obj/item/reagent_containers/chem_canister/water
	loaded_reagent = REAGENT_ID_WATER
/obj/item/reagent_containers/chem_canister/sugar
	loaded_reagent = REAGENT_ID_SUGAR
/obj/item/reagent_containers/chem_canister/hydrogen
	loaded_reagent = REAGENT_ID_HYDROGEN
/obj/item/reagent_containers/chem_canister/lithium
	loaded_reagent = REAGENT_ID_LITHIUM
/obj/item/reagent_containers/chem_canister/carbon
	loaded_reagent = REAGENT_ID_CARBON
/obj/item/reagent_containers/chem_canister/nitrogen
	loaded_reagent = REAGENT_ID_NITROGEN
/obj/item/reagent_containers/chem_canister/oxygen
	loaded_reagent = REAGENT_ID_OXYGEN
/obj/item/reagent_containers/chem_canister/fluorine
	loaded_reagent = REAGENT_ID_FLUORINE
/obj/item/reagent_containers/chem_canister/sodium
	loaded_reagent = REAGENT_ID_SODIUM
/obj/item/reagent_containers/chem_canister/aluminum
	loaded_reagent = REAGENT_ID_ALUMINIUM
/obj/item/reagent_containers/chem_canister/silicon
	loaded_reagent = REAGENT_ID_SILICON
/obj/item/reagent_containers/chem_canister/phosphorus
	loaded_reagent = REAGENT_ID_PHOSPHORUS
/obj/item/reagent_containers/chem_canister/sulfur
	loaded_reagent = REAGENT_ID_SULFUR
/obj/item/reagent_containers/chem_canister/chlorine
	loaded_reagent = REAGENT_ID_CHLORINE
/obj/item/reagent_containers/chem_canister/potassium
	loaded_reagent = REAGENT_ID_POTASSIUM
/obj/item/reagent_containers/chem_canister/iron
	loaded_reagent = REAGENT_ID_IRON
/obj/item/reagent_containers/chem_canister/copper
	loaded_reagent = REAGENT_ID_COPPER
/obj/item/reagent_containers/chem_canister/mercury
	loaded_reagent = REAGENT_ID_MERCURY
/obj/item/reagent_containers/chem_canister/radium
	loaded_reagent = REAGENT_ID_RADIUM
/obj/item/reagent_containers/chem_canister/ethanol
	loaded_reagent = REAGENT_ID_ETHANOL
/obj/item/reagent_containers/chem_canister/sacid
	loaded_reagent = REAGENT_ID_SACID
/obj/item/reagent_containers/chem_canister/tungsten
	loaded_reagent = REAGENT_ID_TUNGSTEN
/obj/item/reagent_containers/chem_canister/calcium
	loaded_reagent = REAGENT_ID_CALCIUM
