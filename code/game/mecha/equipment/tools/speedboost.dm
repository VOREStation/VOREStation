/obj/item/mecha_parts/mecha_equipment/speedboost
	name = "ripley leg actuator overdrive"
	desc = "System enhancements and overdrives to make a ripley's legs move faster."
	icon_state = "tesla"
	origin_tech = list( TECH_POWER = 5, TECH_MATERIAL = 4, TECH_ENGINEERING = 4)
	required_type = list(/obj/mecha/working/ripley)

	equip_type = EQUIP_HULL

	var/slowdown_multiplier = 0.75	// How much does the exosuit multiply its slowdown by if it's the proper type?

/*
/obj/item/mecha_parts/mecha_equipment/speedboost/attach(obj/mecha/M as obj)
	..()
	if(enable_special)
		chassis.step_in = 3 // As fast as a gygax without overload. Slower than Ody.
	else
		chassis.step_in = 6 // Improper parts slow the mech down
	return
*/

/obj/item/mecha_parts/mecha_equipment/speedboost/get_step_delay()
	if(enable_special)
		return -1
	else
		return 3

/obj/item/mecha_parts/mecha_equipment/speedboost/detach()
	chassis.step_in = initial(chassis.step_in)
	..()
	return
