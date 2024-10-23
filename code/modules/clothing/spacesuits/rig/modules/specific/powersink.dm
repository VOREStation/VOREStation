/obj/item/rig_module/power_sink
	name = "hardsuit power sink"
	desc = "An heavy-duty power sink."
	icon_state = "powersink"
	toggleable = 1
	activates_on_touch = 1
	disruptive = 0

	activate_string = "Enable Power Sink"
	deactivate_string = "Disable Power Sink"

	interface_name = "niling d-sink"
	interface_desc = "Colloquially known as a power siphon, this module drains power through the suit hands into the suit battery."

	var/atom/interfaced_with // Currently draining power from this device.
	var/total_power_drained = 0
	var/drain_loc

/obj/item/rig_module/power_sink/deactivate()

	if(interfaced_with)
		if(holder && holder.wearer)
			to_chat(holder.wearer, span_warning("Your power sink retracts as the module deactivates."))
		drain_complete()
	interfaced_with = null
	total_power_drained = 0
	return ..()

/obj/item/rig_module/power_sink/activate()
	interfaced_with = null
	total_power_drained = 0
	return ..()

/obj/item/rig_module/power_sink/engage(atom/target)

	if(!..())
		return 0

	//Target wasn't supplied or we're already draining.
	if(interfaced_with)
		return 0

	if(!target)
		return 1

	// Are we close enough?
	var/mob/living/carbon/human/H = holder.wearer
	if(!target.Adjacent(H))
		return 0

	// Is it a valid power source?
	if(target.drain_power(1) <= 0)
		return 0

	to_chat(H, span_danger("You begin draining power from [target]!"))
	interfaced_with = target
	drain_loc = interfaced_with.loc

	holder.spark_system.start()
	playsound(H, 'sound/effects/sparks2.ogg', 50, 1)

	return 1

/obj/item/rig_module/power_sink/accepts_item(var/obj/item/input_device, var/mob/living/user)
	var/can_drain = input_device.drain_power(1)
	if(can_drain > 0)
		engage(input_device)
		return 1
	return 0

/obj/item/rig_module/power_sink/process()

	if(!interfaced_with)
		return ..()

	var/mob/living/carbon/human/H
	if(holder && holder.wearer)
		H = holder.wearer

	if(!H || !istype(H))
		return 0

	holder.spark_system.start()
	playsound(H, 'sound/effects/sparks2.ogg', 50, 1)

	H.break_cloak()

	if(!holder.cell)
		to_chat(H, span_danger("Your power sink flashes an error; there is no cell in your rig."))
		drain_complete(H)
		return

	if(!interfaced_with || !interfaced_with.Adjacent(H) || !(interfaced_with.loc == drain_loc))
		to_chat(H, span_warning("Your power sink retracts into its casing."))
		drain_complete(H)
		return

	if(holder.cell.fully_charged())
		to_chat(H, span_warning("Your power sink flashes an amber light; your rig cell is full."))
		drain_complete(H)
		return

	// Attempts to drain up to 12.5*cell-capacity kW, determines this value from remaining cell capacity to ensure we don't drain too much.
	// 1Ws/(12.5*CELLRATE) = 40s to charge
	var/to_drain = min(12.5*holder.cell.maxcharge, ((holder.cell.maxcharge - holder.cell.charge) / CELLRATE))
	var/target_drained = interfaced_with.drain_power(0,0,to_drain)
	if(target_drained <= 0)
		to_chat(H, span_danger("Your power sink flashes a red light; there is no power left in [interfaced_with]."))
		drain_complete(H)
		return

	holder.cell.give(target_drained * CELLRATE)
	total_power_drained += target_drained

	return

/obj/item/rig_module/power_sink/proc/drain_complete(var/mob/living/M)

	if(!interfaced_with)
		if(M)
			to_chat(M, span_notice(span_bold("Total power drained:") + " [round(total_power_drained*CELLRATE)] cell units."))
	else
		if(M)
			to_chat(M, span_notice(span_bold("Total power drained from [interfaced_with]:") + " [round(total_power_drained*CELLRATE)] cell units."))
		interfaced_with.drain_power(0,1,0) // Damage the victim.

	drain_loc = null
	interfaced_with = null
	total_power_drained = 0
