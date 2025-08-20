/obj/item/endoware/cleaner_leg
	name = "TODO LEG NOZZLE"
	desc = "A subtly implemented nozzle at the base of the calf, it sprays out a thin mist of cleaner as the owner walks."
	icon_state = "implant"
	allowed_in = list(BP_L_LEG,BP_R_LEG)
	var/datum/component/clean_floor/component
	image_text = "CLEAN"
	is_activatable = TRUE
	var/enabled = FALSE
	var/mode = 0 //0 = clean, 1 = wet, 2 = lube


/obj/item/endoware/cleaner_leg/build_human_components(mob/living/carbon/target)
	component = target.AddComponent(/datum/component/clean_floor,src)
	. = ..()

/obj/item/endoware/cleaner_leg/dissolve_human_components(mob/living/carbon/human/human)
	if(component)
		qdel(component)
		component = null
	. = ..()

/obj/item/endoware/cleaner_leg/activate()
	enabled = !enabled
	if(component)
		component.active = enabled
	if(host)
		to_chat(host,span_notice("[src]'s nozzle [enabled ? "slides out its port in the back of your leg" : "retracts quietly into its slot"]."))
	. = ..()


/*
/obj/item/endoware/cleaner_leg/attackby(obj/item/W, mob/user)
	if(W.has_tool_quality(TOOL_MULTITOOL))
		if(mode < 1)
			mode = 1
			to_chat(user,span_notice("You adjust the output pressure of [src]!"))
	if(W.has_tool_quality(TOOL_DRILL))
		if(mode < 2)
			mode = 2
			to_chat(user, span_notice("You widen the nozzle of [src]!"))//get er done cleetur
	if(W.has_tool_quality(TOOL_CAUTERY))
		if(mode < 2)
			mode = 1
			to_chat(user,spam_notice("You melt the nozzle and squish it back into a smaller-ish shape."))
*/ //probably a bad idea tbh
