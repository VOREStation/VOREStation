/obj/item/mecha_parts/mecha_equipment/speedboost
	name = "ripley leg actuator overdrive"
	desc = "System enhancements and overdrives to make a ripley's legs move faster."
	icon_state = "tesla"
	origin_tech = list( TECH_POWER = 5, TECH_MATERIAL = 4, TECH_ENGINEERING = 4)
	required_type = list(/obj/mecha/working/ripley)

	equip_type = EQUIP_HULL

/obj/item/mecha_parts/mecha_equipment/speedboost/attach(obj/mecha/M as obj)
	..()
	if(enable_special)
		chassis.step_in = (chassis.step_in-2) // Make the ripley as fast as a durand
	else
		chassis.step_in = (chassis.step_in+1) // Improper parts slow the mech down
	return

/obj/item/mecha_parts/mecha_equipment/speedboost/detach()
	chassis.step_in = initial(chassis.step_in)
	..()
	return