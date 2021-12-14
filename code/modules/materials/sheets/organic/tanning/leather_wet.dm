//Step three - drying
/obj/item/stack/wetleather
	name = "wet leather"
	desc = "This leather has been cleaned but still needs to be dried."
	description_info = "To finish tanning the leather, you need to dry it. \
						You could place it under a <b><font color='red'>fire</font></b>, \
						put it in a <b><font color='blue'>drying rack</font></b>, \
						or build a <b><font color='brown'>tanning rack</font></b> from steel or wooden boards."
	singular_name = "wet leather piece"
	icon_state = "sheet-wetleather"
	var/wetness = 30 //Reduced when exposed to high temperautres
	var/drying_threshold_temperature = 500 //Kelvin to start drying
	no_variants = FALSE
	max_amount = 20
	stacktype = "wetleather"

	var/dry_type = /obj/item/stack/material/leather

/obj/item/stack/wetleather/examine(var/mob/user)
	. = ..()
	. += description_info
	. += "\The [src] is [get_dryness_text()]."

/obj/item/stack/wetleather/proc/get_dryness_text()
	if(wetness > 20)
		return "wet"
	if(wetness > 10)
		return "damp"
	if(wetness)
		return "almost dry"
	return "dry"

/obj/item/stack/wetleather/fire_act(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	..()
	if(exposed_temperature >= drying_threshold_temperature)
		wetness--
		if(wetness == 0)
			dry()

/obj/item/stack/wetleather/proc/dry()
	var/obj/item/stack/material/leather/L = new(src.loc, get_amount())
	use(get_amount())
	return L

/obj/item/stack/wetleather/transfer_to(obj/item/stack/S, var/tamount=null, var/type_verified)
	. = ..()
	if(.) // If it transfers any, do a weighted average of the wetness
		var/obj/item/stack/wetleather/W = S
		var/oldamt = W.amount - .
		W.wetness = round(((oldamt * W.wetness) + (. * wetness)) / W.amount)
