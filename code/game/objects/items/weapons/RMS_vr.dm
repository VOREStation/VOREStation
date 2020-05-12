#define RMS_STEEL "Steel"
#define RMS_GLASS "Glass"
#define RMS_BATT "Battery"
#define RMS_RAND "Random Material"

/obj/item/weapon/rms
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

	var/mode_index = 1 //start at steel creation
	var/list/modes = list(RMS_STEEL, RMS_GLASS, RMS_BATT, RMS_RAND)
	var/stored_charge = 0
	var/max_charge = 1000000 //large storage, equivalent to 50 steel sheets
	var/charge_cost = 20000
	var/charge_cost_r = 50000
	var/charge_cost_m = 100000
	var/charge_stage = 0
	var/emagged = 0
	var/datum/effect/effect/system/spark_spread/spark_system

/obj/item/weapon/rms/Initialize()
	. = ..()
	src.spark_system = new /datum/effect/effect/system/spark_spread
	spark_system.set_up(5, 0, src)
	spark_system.attach(src)
	update_icon()

/obj/item/weapon/pipe_dispenser/Destroy()
	qdel_null(spark_system)
	return ..()

/obj/item/weapon/rms/update_icon()
	charge_stage = round((stored_charge/max_charge)*4)
	if(charge_stage >= 4)
		charge_stage = 4
	add_overlay("rms_charge[charge_stage]")

/obj/item/weapon/rms/examine(mob/user)
	. = ..()
	. += display_resources()

/obj/item/weapon/rms/proc/display_resources()
	return "It currently holds [round(stored_charge/1000)]/[max_charge/1000] kW charge."

/obj/item/weapon/rms/proc/drain_battery(user, battery)
	var/obj/item/weapon/cell.C = battery
	if(stored_charge == max_charge)
		to_chat(user, "<span class='notice'>The Rapid Material Synthesizer is full on charge!.</span>")
		update_icon()
		return
	if(C.charge == 0)
		to_chat(user, "<span class='notice'>The battery has no charge.</span>")
		update_icon()
		return
	else
		playsound(get_turf(src), 'sound/machines/click.ogg', 50, 1)
		if(do_after(user, 2,target = C))
			stored_charge += C.charge
			C.charge = 0
			C.update_icon()
			to_chat(user, "<span class='notice'>You drain [C].</span>")
			if(stored_charge > max_charge)
				stored_charge = max_charge
			update_icon()
			return

/obj/item/weapon/rms/proc/consume_resources(amount)
	stored_charge -= amount
	update_icon()
	return


/obj/item/weapon/rms/proc/can_afford(amount)
	if(mode_index != modes.len)
		if(stored_charge >= charge_cost)
			return TRUE
		else
			return FALSE
	else
		if(stored_charge >= charge_cost_r)
			return TRUE
		else
			return FALSE

/obj/item/weapon/rms/proc/use_rms(atom/A, mob/living/user)
	var/obj/product
	if(!can_afford())
		to_chat(user, "<span class='notice'>There is not enough charge to use this mode.</span>")
		return
	playsound(src.loc, 'sound/machines/click.ogg', 50, 1)
	if(do_after(user, 5, target = A))
		switch(mode_index)
			if(1)
				if(charge_stage >= 4)
					product = new /obj/item/stack/material/plasteel  // can only create one sheet at max charge, and uses five times more charge
					consume_resources(charge_cost_m)
					spark_system.start()
				else
					product = new /obj/item/stack/material/steel
					consume_resources(charge_cost)
			if(2)
				if(charge_stage >= 4)
					product= new /obj/item/stack/material/glass/phoronglass // can only create one sheet at max charge, and uses five times more charge
					consume_resources(charge_cost_m)
					spark_system.start()
				else
					product = new /obj/item/stack/material/glass
					consume_resources(charge_cost)
			if(3)
				switch(charge_stage)
					if(4)
						product = pick(50; new /obj/item/weapon/cell/secborg/empty,
										20; new /obj/item/weapon/cell/high/empty,
										15; new /obj/item/weapon/cell/super/empty,
										10; new /obj/item/weapon/cell/hyper/empty,
										4; new /obj/item/device/fbp_backup_cell,
										100; new /obj/item/weapon/cell/infinite)
					if(3)
						product = pick(50; new /obj/item/weapon/cell/secborg/empty,
										20; new /obj/item/weapon/cell/high/empty,
										15; new /obj/item/weapon/cell/super/empty,
										10; new /obj/item/weapon/cell/hyper/empty,
										5; new /obj/item/device/fbp_backup_cell)
					if(2)
						product = pick(50; new /obj/item/weapon/cell/secborg/empty,
										20; new /obj/item/weapon/cell/high/empty,
										20; new /obj/item/weapon/cell/super/empty,
										5; new /obj/item/weapon/cell/hyper/empty,
										5; new /obj/item/device/fbp_backup_cell)
					if(1)
						product = pick(50; new /obj/item/weapon/cell/secborg/empty,
										25; new /obj/item/weapon/cell/high/empty,
										20; new /obj/item/weapon/cell/super/empty,
										5; new /obj/item/device/fbp_backup_cell)
					if(0)
						product = pick(50; new /obj/item/weapon/cell/secborg/empty,
										30; new /obj/item/weapon/cell/high/empty,
										15; new /obj/item/weapon/cell/super/empty,
										5; new /obj/item/device/fbp_backup_cell)
				if(istype(product,/obj/item/weapon/cell/infinite))
					consume_resources(max_charge)
					spark_system.start()
				else
					consume_resources(charge_cost)
			if(4)
				if(!emagged)
					product = pick(30;new /obj/item/stack/material/steel,
									20;new /obj/item/stack/material/glass,
									10;new /obj/item/stack/cable_coil/random,
									10;new /obj/item/stack/material/plastic,
									10;new /obj/item/stack/material/wood,
									10;new /obj/item/stack/material/wood/sif,
									10;new /obj/item/stack/material/log,
									10;new /obj/item/stack/material/log/sif,
									10;new /obj/item/stack/material/cloth,
									10;new /obj/item/stack/material/cardboard,
									10;new /obj/item/trash/rkibble)
					consume_resources(charge_cost_r)
					spark_system.start()
				else
					product = pick(10;new /obj/item/stack/cable_coil/random,
									10;new /obj/item/stack/material/plastic,
									10;new /obj/item/stack/material/wood,
									10;new /obj/item/stack/material/wood/sif,
									10;new /obj/item/stack/material/log,
									10;new /obj/item/stack/material/log/sif,
									10;new /obj/item/stack/material/cloth,
									10;new /obj/item/stack/material/cardboard,
									10;new /obj/item/trash/rkibble,
									10;new /obj/item/weapon/reagent_containers/spray/waterflower,
									10;new /obj/item/weapon/bikehorn,
									10;new /obj/item/weapon/storage/backpack/clown,
									10;new /obj/item/clothing/under/rank/clown,
									10;new /obj/item/clothing/shoes/clown_shoes,
									10;new /obj/item/clothing/mask/gas/clown_hat,
									1;new /mob/living/simple_mob/vore/catgirl)
					consume_resources(charge_cost)
					spark_system.start()
	product.loc = get_turf(A)

//Start of attack functions

/obj/item/weapon/rms/afterattack(atom/target, mob/user, proximity)
	if(!proximity)
		return
	if(istype(target, /obj/item/weapon/cell)) //Check for a battery on-click
		drain_battery(user, target)
		return
	if(istype(target, /turf/simulated)) // Check for a proper area on-click to spawn items
		use_rms(target, user)
		return
	else
		to_chat(user, "<span class='notice'>Invalid target for the device.</span>")
		return

/obj/item/weapon/rms/attack_self(mob/user)
	if(mode_index >= modes.len)
		mode_index = 1
	else
		mode_index++

	to_chat(user, span("notice", "Changed mode to '[modes[mode_index]]'."))
	playsound(src.loc, 'sound/effects/pop.ogg', 50, 0)
	return ..()

/obj/item/weapon/rms/emag_act(var/remaining_charges, var/mob/user)
	emagged = !emagged
	playsound(src.loc, "sparks", 100, 1)
	return 1



#undef RMS_STEEL
#undef RMS_GLASS
#undef RMS_BATT
#undef RMS_RAND