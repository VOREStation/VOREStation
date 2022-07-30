#define RMS_STEEL 1
#define RMS_GLASS 2
#define RMS_CLOTH 3
#define RMS_PLASTIC 4
#define RMS_STONE 5
#define RMS_RAND 6

/obj/item/rms
	name = "Rapid Material Synthesizer"
	desc = "A tool that converts battery charge to materials."
	icon = 'icons/obj/tools_vr.dmi'
	icon_state = "rms"
	item_state = "rms"
	item_icons = list(
		slot_l_hand_str = 'icons/mob/items/lefthand_vr.dmi',
		slot_r_hand_str = 'icons/mob/items/righthand_vr.dmi',
	)
	force = 7
	throwforce = 10
	throw_speed = 1
	throw_range = 5
	w_class = ITEMSIZE_NORMAL
	origin_tech = list(TECH_ENGINEERING = 3, TECH_MATERIAL = 3)
	matter = list(DEFAULT_WALL_MATERIAL = 5000)
	preserve_item = FALSE

	var/mode_index = RMS_STEEL //start at steel creation
	var/list/modes = list(RMS_STEEL, RMS_GLASS, RMS_CLOTH, RMS_PLASTIC, RMS_STONE, RMS_RAND)
	var/stored_charge = 0
	var/max_charge = 1000000 //large storage, equivalent to 50 steel sheets
	var/charge_cost = 20000
	var/charge_cost_o = 50000
	var/charge_cost_r = 100000
	var/charge_stage = 0
	var/overcharge = 0
	var/emagged = 0
	var/datum/effect_system/spark_spread/spark_system

	var/static/image/radial_image_steel = image(icon = 'icons/mob/radial_vr.dmi', icon_state = "sheet-metal")
	var/static/image/radial_image_glass = image(icon= 'icons/mob/radial_vr.dmi', icon_state = "sheet-glass")
	var/static/image/radial_image_cloth = image(icon = 'icons/mob/radial_vr.dmi', icon_state = "sheet-cloth")
	var/static/image/radial_image_plastic = image(icon = 'icons/mob/radial_vr.dmi', icon_state = "sheet-plastic")
	var/static/image/radial_image_stone = image(icon = 'icons/mob/radial_vr.dmi', icon_state = "sheet-sandstone")
	var/static/image/radial_image_random = image(icon = 'icons/mob/radial_vr.dmi', icon_state = "sheet-random")


/obj/item/rms/Initialize()
	. = ..()
	src.spark_system = new /datum/effect_system/spark_spread
	spark_system.set_up(5, 0, src)
	spark_system.attach(src)
	add_overlay("rms_charge[charge_stage]")

/obj/item/pipe_dispenser/Destroy()
	qdel_null(spark_system)
	return ..()

/obj/item/rms/update_icon()
	charge_stage = round((stored_charge/max_charge)*4)
	if(charge_stage >= 4)
		charge_stage = 4
	cut_overlays()
	add_overlay("rms_charge[charge_stage]")

/obj/item/rms/examine(mob/user)
	. = ..()
	. += display_resources()

/obj/item/rms/proc/display_resources()
	return "It currently holds [round(stored_charge/1000)]/[max_charge/1000] kW charge."

/obj/item/rms/proc/drain_battery(user, battery)
	var/obj/item/cell/C = battery
	if(stored_charge == max_charge)
		to_chat(user, "<span class='notice'>The Rapid Material Synthesizer is full on charge!.</span>")
	if(C.charge == 0)
		to_chat(user, "<span class='notice'>The battery has no charge.</span>")
	else
		playsound(get_turf(src), 'sound/machines/click.ogg', 50, 1)
		if(do_after(user, 2,target = C))
			stored_charge += C.charge
			C.charge = 0
			C.update_icon()
			to_chat(user, "<span class='notice'>You drain [C].</span>")
	stored_charge = CLAMP(stored_charge, 0, max_charge)
	update_icon()

/obj/item/rms/proc/consume_resources(amount)
	stored_charge -= amount
	update_icon()
	return


/obj/item/rms/proc/can_afford(amount)
	if(stored_charge < amount)
		return FALSE
	else
		return TRUE

/obj/item/rms/proc/use_rms(atom/A, mob/living/user)
	var/obj/product
	if(!overcharge)
		if(!can_afford(charge_cost))
			to_chat(user, "<span class='notice'>There is not enough charge to use this mode.</span>")
			return
		else
			consume_resources(charge_cost)
	else
		if(!can_afford(charge_cost_o))
			to_chat(user, "<span class='notice'>There is not enough charge to use the overcharged mode.</span>")
			return
		else
			consume_resources(charge_cost_o)
	playsound(src.loc, 'sound/machines/click.ogg', 50, 1)
	if(do_after(user, 5, target = A))
		switch(mode_index)
			if(RMS_STEEL)
				if(overcharge)
					product = new /obj/item/stack/material/plasteel  // can only create one sheet at max charge, and uses five times more charge
					spark_system.start()
				else
					product = new /obj/item/stack/material/steel
			if(RMS_GLASS)
				if(overcharge)
					product= new /obj/item/stack/material/glass/phoronglass // can only create one sheet at max charge, and uses five times more charge
					spark_system.start()
				else
					product = new /obj/item/stack/material/glass
			if(RMS_CLOTH)
				if(overcharge)
					product= new /obj/item/stack/material/leather // can only create one sheet at max charge, and uses five times more charge
					spark_system.start()
				else
					product = new /obj/item/stack/material/cloth
			if(RMS_PLASTIC)
				if(overcharge)
					product= new /obj/item/stack/material/cardboard // can only create one sheet at max charge, and uses five times more charge
					spark_system.start()
				else
					product = new /obj/item/stack/material/plastic
			if(RMS_STONE)
				if(overcharge)
					product= new /obj/item/stack/material/marble // can only create one sheet at max charge, and uses five times more charge
					spark_system.start()
				else
					product = new /obj/item/stack/material/sandstone
			if(RMS_RAND)
				if(!overcharge && !emagged)
					product = pick(10;new /obj/item/trash/material/metal,
									10;new /obj/item/material/shard,
									10;new /obj/item/stack/cable_coil/random,
									10;new /obj/item/stack/material/wood,
									10;new /obj/item/stack/material/wood/sif,
									10;new /obj/item/stack/material/snow)
				if(overcharge && !emagged)
					product = pick(1;new /obj/item/stack/rods,
									5;new /obj/item/fbp_backup_cell,
									5;new /obj/item/trash/rkibble,
									10;new /obj/item/stack/tile/grass,
									10;new /obj/item/stack/tile/carpet)
					spark_system.start()
				if(!overcharge && emagged)
					product = pick(10;new /obj/item/trash/material/metal,
									10;new /obj/item/material/shard,
									10;new /obj/item/stack/cable_coil/random,
									10;new /obj/item/stack/material/wood,
									10;new /obj/item/stack/material/wood/sif,
									10;new /obj/item/stack/material/snow,
									5;new /obj/item/stack/material/phoron,
									5;new /obj/item/stack/material/silver,
									5;new /obj/item/stack/material/gold,
									1;new /obj/item/stack/material/diamond)
				if(overcharge && emagged)
					product = pick(1;new /obj/item/stack/rods,
									5;new /obj/item/fbp_backup_cell,
									5;new /obj/item/trash/rkibble,
									10;new /obj/item/stack/tile/grass,
									10;new /obj/item/stack/tile/carpet,
									10;new /obj/item/reagent_containers/spray/waterflower,
									10;new /obj/item/bikehorn,
									10;new /obj/item/storage/backpack/clown,
									10;new /obj/item/clothing/under/rank/clown,
									10;new /obj/item/clothing/shoes/clown_shoes,
									10;new /obj/item/clothing/mask/gas/clown_hat,
									10;new /obj/item/pda/clown,
									1;new /mob/living/simple_mob/vore/catgirl)
					spark_system.start()
	product.loc = get_turf(A)

/obj/item/rms/proc/check_menu(mob/living/user)
	if(!istype(user))
		return FALSE
	if(user.incapacitated() || !user.Adjacent(src))
		return FALSE
	return TRUE

//Start of attack functions

/obj/item/rms/afterattack(atom/target, mob/user, proximity)
	if(!proximity)
		return
	if(istype(target, /obj/item/cell)) //Check for a battery on-click
		drain_battery(user, target)
		return
	if(istype(target, /turf/simulated)) // Check for a proper area on-click to spawn items
		use_rms(target, user)
		return
	else
		to_chat(user, "<span class='notice'>Invalid target for the device.</span>")
		return

/obj/item/rms/attack_self(mob/user)
	var/list/choices = list(
		"Steel" = radial_image_steel,
		"Glass" = radial_image_glass,
		"Cloth" = radial_image_cloth,
		"Plastic" = radial_image_plastic,
		"Stone" = radial_image_stone,
		"Random" = radial_image_random
	)

	var/choice = show_radial_menu(user, src, choices, custom_check = CALLBACK(src, .proc/check_menu, user), require_near = TRUE, tooltips = TRUE)
	if(!check_menu(user))
		return
	switch(choice)
		if("Steel")
			mode_index = modes.Find(RMS_STEEL)
		if("Glass")
			mode_index = modes.Find(RMS_GLASS)
		if("Cloth")
			mode_index = modes.Find(RMS_CLOTH)
		if("Plastic")
			mode_index = modes.Find(RMS_PLASTIC)
		if("Stone")
			mode_index = modes.Find(RMS_STONE)
		if("Random")
			mode_index = modes.Find(RMS_RAND)
		else
			return

	to_chat(user, span("notice", "Changed mode to '[choice]'."))
	playsound(src.loc, 'sound/effects/pop.ogg', 50, 0)
	return ..()

/obj/item/rms/emag_act(var/remaining_charges, var/mob/user)
	emagged = !emagged
	playsound(src.loc, "sparks", 100, 1)
	return 1

/obj/item/rms/attackby(obj/item/W, mob/user)
	if(W.is_multitool())
		overcharge = !overcharge
	if(overcharge)
		to_chat(user, "<span class='notice'>The Rapid Material Synthesizer quietly whirrs...</span>")
	else
		to_chat(user, "<span class='notice'>The Rapid Material Synthesizer resumes normal operation.</span>")
	return ..()


#undef RMS_STEEL
#undef RMS_GLASS
#undef RMS_CLOTH
#undef RMS_PLASTIC
#undef RMS_STONE
#undef RMS_RAND
