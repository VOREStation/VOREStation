#define RMS_STEEL 1
#define RMS_GLASS 2
#define RMS_CLOTH 3
#define RMS_PLASTIC 4
#define RMS_STONE 5
#define RMS_RAND 6

var/list/RMS_random_malfunction = list(/obj/item/fbp_backup_cell,
									/obj/item/trash/rkibble,
									/obj/item/clothing/gloves/bluespace/deluxe,
									/obj/item/flame/lighter/supermatter/syndismzippo,
									/obj/item/instrument/trumpet/spectral,
									/obj/item/storage/smolebrickcase,
									/obj/item/stack/tile/grass,
									/obj/item/stack/tile/carpet,
									/obj/item/reagent_containers/spray/waterflower,
									/obj/item/bikehorn,
									/obj/item/storage/backpack/clown,
									/obj/item/clothing/under/rank/clown,
									/obj/item/clothing/shoes/clown_shoes,
									/obj/item/clothing/mask/gas/clown_hat,
									/obj/item/pda/clown,
									/mob/living/simple_mob/vore/catgirl)

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
	var/max_charge = 1000000 //large storage, equivalent to a little over 33 GIGA batteries.
	var/charge_cost = 1000
	/// Cost of 'basic' things such as glass or steel. Un-upgraded chargers charge at ~40 charge a second, meaning 15 seconds per sheet. 22.5 for 'advanced' sheets (overcharged). This becomes ~10 seconds and ~15 seconds with a heavily upgraded charger.
	var/charge_cost_basic = 1000
	var/charge_cost_random = 3333 //Cost of 'random' things. Used by RMS_RAND. This takes ~85 seconds a sheet on a basic charger and ~33 seconds a sheet on an upgraded charger.
	var/charge_stage = 0
	var/overcharge = 0
	var/overcharge_modifier = 1.5 //Multiplier in price for using the overcharge mode.
	var/datum/effect/effect/system/spark_spread/spark_system

	var/static/image/radial_image_steel = image(icon = 'icons/mob/radial_vr.dmi', icon_state = "sheet-metal")
	var/static/image/radial_image_glass = image(icon= 'icons/mob/radial_vr.dmi', icon_state = "sheet-glass")
	var/static/image/radial_image_cloth = image(icon = 'icons/mob/radial_vr.dmi', icon_state = "sheet-cloth")
	var/static/image/radial_image_plastic = image(icon = 'icons/mob/radial_vr.dmi', icon_state = "sheet-plastic")
	var/static/image/radial_image_stone = image(icon = 'icons/mob/radial_vr.dmi', icon_state = "sheet-sandstone")
	var/static/image/radial_image_random = image(icon = 'icons/mob/radial_vr.dmi', icon_state = "sheet-random")


/obj/item/rms/Initialize(mapload)
	. = ..()
	src.spark_system = new /datum/effect/effect/system/spark_spread
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
	var/charge_needed = max_charge - stored_charge
	if(stored_charge == max_charge)
		to_chat(user, span_notice("The Rapid Material Synthesizer is full on charge!."))
	if(C.charge == 0)
		to_chat(user, span_notice("The battery has no charge."))
	else
		playsound(get_turf(src), 'sound/machines/click.ogg', 50, 1)
		if(do_after(user, 2,target = C))
			stored_charge += C.charge
			if(C.charge > charge_needed) //We only drain what we need!
				C.use(charge_needed)
			else
				C.use(C.charge)
			C.update_icon()
			to_chat(user, span_notice("You drain [C]."))
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
			to_chat(user, span_notice("There is not enough charge to use this mode."))
			return
		consume_resources(charge_cost)
	else
		if(!can_afford(charge_cost * overcharge_modifier))
			to_chat(user, span_notice("There is not enough charge to use the overcharged mode."))
			return
		consume_resources(charge_cost * overcharge_modifier)
	playsound(src.loc, 'sound/machines/click.ogg', 50, 1)
	if(do_after(user, 5, target = A))
		if(overcharge)
			if(prob(5)) //5% chance for malfunction
				var/thing_to_spawn = pick(RMS_random_malfunction)
				product = new thing_to_spawn
			else
				product = choose_overcharge(user)
		else
			product = choose_normal(user)

	spark_system.start()
	product.loc = get_turf(A)

/obj/item/rms/proc/choose_overcharge(mob/living/user)
	var/final_product
	switch(mode_index)
		if(RMS_STEEL)
			final_product = new /obj/item/stack/material/plasteel
		if(RMS_GLASS)
			final_product = new /obj/item/stack/material/glass/phoronglass
		if(RMS_CLOTH)
			final_product = new /obj/item/stack/material/leather
		if(RMS_PLASTIC)
			final_product = new /obj/item/stack/material/cardboard
		if(RMS_STONE)
			final_product = new /obj/item/stack/material/marble
		if(RMS_RAND)
			final_product = randomize(user)
	return final_product

/obj/item/rms/proc/choose_normal(mob/living/user)
	var/final_product
	switch(mode_index)
		if(RMS_STEEL)
			final_product = new /obj/item/stack/material/steel
		if(RMS_GLASS)
			final_product = new /obj/item/stack/material/glass
		if(RMS_CLOTH)
			final_product = new /obj/item/stack/material/cloth
		if(RMS_PLASTIC)
			final_product = new /obj/item/stack/material/plastic
		if(RMS_STONE)
			final_product = new /obj/item/stack/material/sandstone
		if(RMS_RAND)
			final_product = randomize(user)
	return final_product

/obj/item/rms/proc/randomize(mob/living/user)
	var/obj/item/stack/final_product
	var/possible_object_paths = list()
	possible_object_paths += subtypesof(/obj/item/stack/material)
	possible_object_paths -= typesof(/obj/item/stack/material/cyborg)
	//I looked through the code for any materials that should be banned...Most of the "DO NOT EVER GIVE THESE TO ANYONE EVER" materials are only in their /datum form and the ones that have sheets spawn in as normal sheets (ex: hull datums) so...This is here in case it's needed in the future.
	var/list/banned_sheet_materials = list(
		/obj/item/stack/material/supermatter,
		/obj/item/stack/material/glamour,
		/obj/item/stack/material/morphium
		// Include if you enable in the .dme /obj/item/stack/material/debug
		)
	var/obj/item/stack/new_metal = /obj/item/stack/material/supermatter
	for(var/x=1;x<=10;x++) //You got 10 chances to hit a metal that is NOT banned.
		var/picked_metal = pick(possible_object_paths) //We select
		if(picked_metal in banned_sheet_materials)
			continue
		else
			new_metal = picked_metal
			break
	if(prob(1) && prob(1) && prob(1)) //1 in a million...Feeling lucky?
		if(prob(50))
			new_metal = /obj/item/stack/material/morphium
		else
			new_metal = /obj/item/stack/material/supermatter
		visible_message(span_giganteus(span_boldwarning("The [src] glows blazing hot for a moment before spitting out a glowing material!")))
		if(overcharge) //uh oh...
			to_chat(user, span_extramassive(span_boldwarning("The [src] heats up to the point that you are immediately vaporized!")))
			user.dust()
	final_product = new new_metal
	if(overcharge && (charge_cost_random > 0)) //We use ALL our energy in one go while overcharged! Also has a charge_cost_random sanity check in case of badmins.
		final_product.amount = max(1, 1+round(stored_charge/charge_cost_random))
		consume_resources(stored_charge)
	return final_product

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
		to_chat(user, span_notice("Invalid target for the device."))
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

	var/choice = show_radial_menu(user, src, choices, custom_check = CALLBACK(src, PROC_REF(check_menu), user), require_near = TRUE, tooltips = TRUE)
	if(!check_menu(user))
		return
	switch(choice)
		if("Steel")
			mode_index = modes.Find(RMS_STEEL)
			charge_cost = charge_cost_basic
		if("Glass")
			mode_index = modes.Find(RMS_GLASS)
			charge_cost = charge_cost_basic
		if("Cloth")
			mode_index = modes.Find(RMS_CLOTH)
			charge_cost = charge_cost_basic
		if("Plastic")
			mode_index = modes.Find(RMS_PLASTIC)
			charge_cost = charge_cost_basic
		if("Stone")
			mode_index = modes.Find(RMS_STONE)
			charge_cost = charge_cost_basic
		if("Random")
			mode_index = modes.Find(RMS_RAND)
			charge_cost = charge_cost_random
		else
			return

	to_chat(user, span_notice("Changed mode to '[choice]'."))
	playsound(src.loc, 'sound/effects/pop.ogg', 50, 0)
	return ..()

/obj/item/rms/attackby(obj/item/W, mob/user)
	if(W.has_tool_quality(TOOL_MULTITOOL))
		overcharge = !overcharge
	if(overcharge)
		to_chat(user, span_notice("The Rapid Material Synthesizer quietly whirrs..."))
	else
		to_chat(user, span_notice("The Rapid Material Synthesizer resumes normal operation."))
	return ..()


#undef RMS_STEEL
#undef RMS_GLASS
#undef RMS_CLOTH
#undef RMS_PLASTIC
#undef RMS_STONE
#undef RMS_RAND
