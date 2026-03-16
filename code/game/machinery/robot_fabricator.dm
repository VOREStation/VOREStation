/obj/machinery/robotic_fabricator
	name = "robotic fabricator"
	icon = 'icons/obj/robotics.dmi'
	icon_state = "fab-idle"
	density = TRUE
	anchored = TRUE
	var/metal_amount = 0
	var/operating = FALSE
	var/obj/item/robot_parts/being_built = null
	use_power = USE_POWER_IDLE
	idle_power_usage = 40
	active_power_usage = 10000
	var/inserting = FALSE

/obj/machinery/robotic_fabricator/attackby(obj/item/O, mob/user)
	if(istype(O, /obj/item/stack/material) && O.get_material_name() == MAT_STEEL && !inserting)
		if(metal_amount < 150000)
			var/obj/item/stack/supplied_stack = O
			if(!supplied_stack.get_amount())
				return
			add_overlay("fab-load-metal")
			inserting = TRUE
			addtimer(CALLBACK(src, PROC_REF(complete_insertion), user, supplied_stack),  0.9 SECONDS, TIMER_DELETE_ME)
			return
		to_chat(user, "The robot part maker is full. Please remove metal from the robot part maker in order to insert more.")

/obj/machinery/robotic_fabricator/proc/complete_insertion(mob/user, obj/item/stack/supplied_stack)
	var/count = 0
	while(metal_amount < 150000 && supplied_stack.get_amount())
		metal_amount += supplied_stack.matter[MAT_STEEL]
		supplied_stack.use(1)
		count++

	to_chat(user, "You insert [count] metal sheet\s into the fabricator.")
	cut_overlay("fab-load-metal")
	inserting = FALSE

/obj/machinery/robotic_fabricator/attack_hand(mob/user)
	if(..())
		return

	tgui_interact(user)

/obj/machinery/robotic_fabricator/tgui_interact(mob/user, datum/tgui/ui, datum/tgui/parent_ui, custom_state)
	. = ..()
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "AncientDroneFab", name)
		ui.open()

/obj/machinery/robotic_fabricator/tgui_data(mob/user, datum/tgui/ui, datum/tgui_state/state)
	return list(
		"operating" = operating,
		"metal_amount" = metal_amount
	)

/obj/machinery/robotic_fabricator/tgui_act(action, list/params, datum/tgui/ui, datum/tgui_state/state)
	. = ..()
	if(.)
		return

	if(operating)
		return FALSE

	add_fingerprint(ui.user)
	switch(action)
		if("build_l_arm")
			return try_start_building("/obj/item/robot_parts/l_arm", 20 SECONDS, 25000)
		if("build_r_arm")
			return try_start_building("/obj/item/robot_parts/r_arm", 20 SECONDS, 25000)
		if("build_l_leg")
			return try_start_building("/obj/item/robot_parts/l_leg", 20 SECONDS, 25000)
		if("build_r_leg")
			return try_start_building("/obj/item/robot_parts/r_leg", 20 SECONDS, 25000)
		if("build_chest")
			return try_start_building("/obj/item/robot_parts/chest", 35 SECONDS, 50000)
		if("build_head")
			return try_start_building("/obj/item/robot_parts/head", 35 SECONDS, 50000)
		if("build_frame")
			return try_start_building("/obj/item/robot_parts/robot_suit", 60 SECONDS, 75000)

/obj/machinery/robotic_fabricator/proc/try_start_building(build_type, build_time, build_cost)
	var/building = text2path(build_type)
	if(isnull(building))
		return FALSE

	if(metal_amount < build_cost)
		return FALSE

	operating = TRUE
	update_use_power(USE_POWER_ACTIVE)
	metal_amount = max(0, metal_amount - build_cost)
	add_overlay("fab-active")

	addtimer(CALLBACK(src, PROC_REF(complete_building), building), build_time, TIMER_DELETE_ME)
	return TRUE

/obj/machinery/robotic_fabricator/proc/complete_building(building)
	being_built = new building(src)
	being_built.forceMove(get_turf(src))
	being_built = null
	update_use_power(USE_POWER_IDLE)
	operating = FALSE
	cut_overlay("fab-active")
