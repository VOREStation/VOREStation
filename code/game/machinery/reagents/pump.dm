
/obj/machinery/pump
	name = "fluid pump"
	desc = "A fluid pumping machine."

	description_info = "A machine that can pump fluid from certain turfs.<br>\
	Water can be pumped from any body of water. Certain locations or environmental\
	conditions  can cause different byproducts to be produced.<br>\
	Magma or Lava can be pumped to produce mineralized fluid."

	anchored = FALSE
	density = TRUE

	icon = 'icons/obj/machines/reagent.dmi'
	icon_state = "pump"

	circuit = /obj/item/weapon/circuitboard/fluidpump

	var/on = 0
	var/obj/item/weapon/cell/cell = null
	var/use = 200
	var/efficiency = 1
	var/reagents_per_cycle = 40
	var/unlocked = 0
	var/open = 0

	var/obj/item/hose_connector/output/Output

// Overlay cache vars.
	var/icon/liquid
	var/icon/tank
	var/icon/powerlow
	var/icon/glass
	var/icon/open_overlay
	var/icon/cell_overlay

/obj/machinery/pump/Initialize()
	create_reagents(200)
	. = ..()
	default_apply_parts()

	if(ispath(cell))
		cell = new cell(src)

	Output = new(src)

	RefreshParts()
	update_icon()

/obj/machinery/pump/update_icon()
	..()
	if(!tank)
		tank = new/icon(icon, "[icon_state]-volume")

	if(!powerlow)
		powerlow = new/icon(icon, "[icon_state]-lowpower")

	if(!liquid)
		var/icon/cutter = new/icon(icon, "[icon_state]-volume")

		cutter.Blend(rgb(0, 0, 0,), ICON_MULTIPLY)

		liquid = new/icon(icon, "[icon_state]-cutting")

		liquid.Blend(cutter,ICON_AND)

	if(!glass)
		glass = new/icon(icon, "[icon_state]-glass")

		glass.Blend(rgb(1,1,1,0.5), ICON_MULTIPLY)

	if(!open_overlay)
		open_overlay = new/icon(icon, "[icon_state]-open")

	if(!cell_overlay)
		cell_overlay = new/icon(icon, "[icon_state]-cell")

	cut_overlays()
	add_overlay(tank)

	if(cell && cell.charge < (use * CELLRATE / efficiency))
		add_overlay(powerlow)

	if(reagents.total_volume >= 1)
		var/list/hextorgb = hex2rgb(reagents.get_color())
		liquid.GrayScale()

		liquid.Blend(rgb(hextorgb[1],hextorgb[2],hextorgb[3]),ICON_MULTIPLY)

		add_overlay(liquid)

	add_overlay(glass)

	if(open)
		add_overlay(open_overlay)

		if(cell)
			add_overlay(cell_overlay)

	if(on)
		icon_state = "[initial(icon_state)]-running"

	else
		icon_state = "[initial(icon_state)]"

/obj/machinery/pump/process()
	if(Output.get_pairing())
		reagents.trans_to_holder(Output.reagents, Output.reagents.maximum_volume)
		if(prob(5))
			visible_message("<b>\The [src]</b> gurgles as it exports fluid.")

	if(!on)
		return

	if(!cell || (cell.charge < (use * CELLRATE / efficiency)))
		turn_off(TRUE)
		return

	handle_pumping()
	update_icon()

/obj/machinery/pump/RefreshParts()
	for(var/obj/item/weapon/stock_parts/manipulator/SM in component_parts)
		efficiency = SM.rating

	var/total_bin_rating = 0
	for(var/obj/item/weapon/stock_parts/matter_bin/SB in component_parts)
		total_bin_rating += SB.rating

	reagents.maximum_volume = round(initial(reagents.maximum_volume) + 100 * total_bin_rating)

	return

/obj/machinery/pump/power_change()
	if(!cell || cell.charge < (use * CELLRATE) || !anchored)
		return turn_off(TRUE)

	return FALSE


// Returns 0 on failure and 1 on success
/obj/machinery/pump/proc/turn_on(var/loud = 0)
	if(!cell)
		return 0
	if(cell.charge < (use * CELLRATE))
		return 0

	on = 1
	update_icon()
	if(loud)
		visible_message("<b>\The [src]</b> turns on.")
	return 1

/obj/machinery/pump/proc/turn_off(var/loud = 0)
	on = 0
	set_light(0, 0)
	update_icon()
	if(loud)
		visible_message("<b>\The [src]</b> shuts down.")

	if(!on)
		return TRUE

	return FALSE

/obj/machinery/pump/attack_ai(mob/user as mob)
	if(istype(user, /mob/living/silicon/robot) && Adjacent(user))
		return attack_hand(user)

	if(on)
		turn_off(TRUE)
	else
		if(!turn_on(1))
			to_chat(user, "<span class='notice'>You try to turn on \the [src] but it does not work.</span>")

/obj/machinery/pump/attack_hand(mob/user as mob)
	if(open && cell)
		if(ishuman(user))
			if(!user.get_active_hand())
				user.put_in_hands(cell)
				cell.loc = user.loc
		else
			cell.loc = src.loc

		cell.add_fingerprint(user)
		cell.update_icon()

		cell = null
		on = 0
		set_light(0)
		to_chat(user, "<span class='notice'>You remove the power cell.</span>")
		update_icon()
		return

	if(on)
		turn_off(TRUE)
	else if(anchored)
		if(!turn_on(1))
			to_chat(user, "<span class='notice'>You try to turn on \the [src] but it does not work.</span>")

	update_icon()

/obj/machinery/pump/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(W.is_screwdriver())
		if(!open)
			if(unlocked)
				unlocked = 0
				to_chat(user, "<span class='notice'>You screw the battery panel in place.</span>")
			else
				unlocked = 1
				to_chat(user, "<span class='notice'>You unscrew the battery panel.</span>")

	else if(W.is_crowbar())
		if(unlocked)
			if(open)
				open = 0
				overlays = null
				to_chat(user, "<span class='notice'>You crowbar the battery panel in place.</span>")
			else
				if(unlocked)
					open = 1
					to_chat(user, "<span class='notice'>You remove the battery panel.</span>")

	else if(W.is_wrench())
		if(on)
			to_chat(user, "<span class='notice'>\The [src] is active. Turn it off before trying to move it!</span>")
			return
		default_unfasten_wrench(user, W, 2 SECONDS)

	else if(istype(W, /obj/item/weapon/cell))
		if(open)
			if(cell)
				to_chat(user, "<span class='notice'>There is a power cell already installed.</span>")
			else
				user.drop_item()
				W.loc = src
				cell = W
				to_chat(user, "<span class='notice'>You insert the power cell.</span>")
	else
		..()
	RefreshParts()
	update_icon()

/obj/machinery/pump/proc/handle_pumping()
	var/turf/T = get_turf(src)

	if(istype(T, /turf/simulated/floor/water))
		cell.use(use * CELLRATE / efficiency)
		reagents.add_reagent("water", reagents_per_cycle)

		if(T.temperature <= T0C)
			reagents.add_reagent("ice", round(reagents_per_cycle / 2, 0.1))

		if((istype(T,/turf/simulated/floor/water/pool) || istype(T,/turf/simulated/floor/water/deep/pool)))
			reagents.add_reagent("chlorine", round(reagents_per_cycle / 10 * efficiency, 0.1))

		else if(istype(T,/turf/simulated/floor/water/contaminated))
			reagents.add_reagent("vatstabilizer", round(reagents_per_cycle / 2))

		if(T.loc.name == "Sea")	// Saltwater.
			reagents.add_reagent("sodiumchloride", round(reagents_per_cycle / 10 * efficiency, 0.1))

		for(var/turf/simulated/mineral/MT in range(5))
			if(MT.mineral)
				var/obj/effect/mineral/OR = MT.mineral
				reagents.add_reagent(OR.ore_reagent, round(reagents_per_cycle / 20 * efficiency, 0.1))

	else if(istype(T, /turf/simulated/floor/lava))
		cell.use(use * CELLRATE / efficiency * 4)
		reagents.add_reagent("mineralizedfluid", round(reagents_per_cycle * efficiency / 2, 0.1))
