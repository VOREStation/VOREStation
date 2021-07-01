/obj/machinery/appliance/cooker/grill
	name = "grill"
	desc = "Backyard grilling, IN SPACE."
	icon_state = "grill_off"
	cook_type = "grilled"
	appliancetype = GRILL
	food_color = "#A34719"
	on_icon = "grill_on"
	off_icon = "grill_off"
	can_burn_food = TRUE
	var/datum/looping_sound/grill/grill_loop
	circuit = /obj/item/weapon/circuitboard/grill
	active_power_usage = 4 KILOWATTS
	heating_power = 4000
	idle_power_usage = 2 KILOWATTS
	
	optimal_power = 1.2 // Things on the grill cook .6 faster - this is now the fastest appliance to heat and to cook on. BURGERS GO SIZZLE.

	stat = POWEROFF // Starts turned off.

	// Grill is faster to heat and setup than the rest.
	optimal_temp = 120 + T0C
	min_temp = 60 + T0C
	resistance = 8 KILOWATTS // Very fast to heat up.
	
	max_contents = 3 // Arbitrary number, 3 grill 'racks'
	container_type = /obj/item/weapon/reagent_containers/cooking_container/grill
	
/obj/machinery/appliance/cooker/grill/Initialize()
	. = ..()
	grill_loop = new(list(src), FALSE)
	
/obj/machinery/appliance/cooker/grill/Destroy()
	QDEL_NULL(grill_loop)
	return ..()
	
/obj/machinery/appliance/cooker/grill/update_icon() // TODO: Cooking icon
	if(!stat)
		icon_state = on_icon
		if(cooking == TRUE)
			if(grill_loop)
				grill_loop.start(src)
		else
			if(grill_loop)
				grill_loop.stop(src)
	else
		icon_state = off_icon
		if(grill_loop)
			grill_loop.stop(src)
