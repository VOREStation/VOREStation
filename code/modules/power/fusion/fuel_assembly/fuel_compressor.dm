#define FUSION_ROD_SHEET_AMT 15
/obj/machinery/fusion_fuel_compressor
	name = "fuel compressor"
	icon = 'icons/obj/machines/power/fusion.dmi'
	icon_state = "fuel_compressor1"
	density = TRUE
	anchored = TRUE

	circuit = /obj/item/weapon/circuitboard/fusion_fuel_compressor

/obj/machinery/fusion_fuel_compressor/Initialize()
	. = ..()
	default_apply_parts()

/obj/machinery/fusion_fuel_compressor/MouseDrop_T(var/atom/movable/target, var/mob/user)
	if(user.incapacitated() || !user.Adjacent(src))
		return
	return do_special_fuel_compression(target, user)

/obj/machinery/fusion_fuel_compressor/proc/do_special_fuel_compression(var/obj/item/thing, var/mob/user)
	if(istype(thing) && thing.reagents && thing.reagents.total_volume && thing.is_open_container())
		if(thing.reagents.reagent_list.len > 1)
			to_chat(user, "<span class='warning'>The contents of \the [thing] are impure and cannot be used as fuel.</span>")
			return 1
		if(thing.reagents.total_volume < 300)
			to_chat(user, "<span class='warning'>You need at least three hundred units of material to form a fuel rod.</span>")
			return 1
		var/datum/reagent/R = thing.reagents.reagent_list[1]
		visible_message("<b>\The [src]</b> compresses the contents of \the [thing] into a new fuel assembly.")
		var/obj/item/weapon/fuel_assembly/F = new(get_turf(src), R.id, R.color)
		thing.reagents.remove_reagent(R.id, R.volume)
		user.put_in_hands(F)

	else if(istype(thing, /obj/machinery/power/supermatter))
		var/obj/item/weapon/fuel_assembly/F = new(get_turf(src), "supermatter")
		visible_message("<b>\The [src]</b> compresses \the [thing] into a new fuel assembly.")
		qdel(thing)
		user.put_in_hands(F)
		return 1
	return 0

/obj/machinery/fusion_fuel_compressor/attackby(var/obj/item/thing, var/mob/user)

	if(default_deconstruction_screwdriver(user, thing))
		return
	if(default_deconstruction_crowbar(user, thing))
		return
	if(default_part_replacement(user, thing))
		return

	if(istype(thing, /obj/item/stack/material))
		var/obj/item/stack/material/M = thing
		var/datum/material/mat = M.get_material()
		if(!mat.is_fusion_fuel)
			to_chat(user, "<span class='warning'>It would be pointless to make a fuel rod out of [mat.use_name].</span>")
			return
		if(M.get_amount() < FUSION_ROD_SHEET_AMT)
			to_chat(user, "<span class='warning'>You need at least 25 [mat.sheet_plural_name] to make a fuel rod.</span>")
			return
		var/obj/item/weapon/fuel_assembly/F = new(get_turf(src), mat.name)
		visible_message("<b>\The [src]</b> compresses the [mat.use_name] into a new fuel assembly.")
		M.use(FUSION_ROD_SHEET_AMT)
		user.put_in_hands(F)

	else if(do_special_fuel_compression(thing, user))
		return

	return ..()

#undef FUSION_ROD_SHEET_AMT