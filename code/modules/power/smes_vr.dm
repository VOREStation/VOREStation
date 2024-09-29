/obj/machinery/power/smes/buildable/hybrid
	name = "hybrid power storage unit"
	desc = "A high-capacity superconducting magnetic energy storage (SMES) unit, modified with alien technology to generate small amounts of power from seemingly nowhere."
	icon = 'icons/obj/power_vr.dmi'
	var/recharge_rate = 10000
	var/overlay_icon = 'icons/obj/power_vr.dmi'

/obj/machinery/power/smes/buildable/hybrid/attackby(var/obj/item/W as obj, var/mob/user as mob)
	if(W.has_tool_quality(TOOL_SCREWDRIVER) || W.has_tool_quality(TOOL_WIRECUTTER))
		to_chat(user,"<span class='warning'>\The [src] full of weird alien technology that's best not messed with.</span>")
		return 0

/obj/machinery/power/smes/buildable/hybrid/update_icon()
	cut_overlays()
	if(stat & BROKEN)	return

	add_overlay("smes-op[outputting]")

	if(inputting == 2)
		add_overlay("smes-oc2")
	else if (inputting == 1)
		add_overlay("smes-oc1")
	else
		if(input_attempt)
			add_overlay("smes-oc0")

	var/clevel = chargedisplay()
	if(clevel>0)
		add_overlay("smes-og[clevel]")
	return

/obj/machinery/power/smes/buildable/hybrid/process()
	charge += min(recharge_rate, capacity - charge)
	..()

//hey travis wake up