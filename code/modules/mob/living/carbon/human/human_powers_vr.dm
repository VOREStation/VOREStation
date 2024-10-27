/mob/living/carbon/human/proc/reagent_purge()
	set name = "Purge Reagents"
	set desc = "Empty yourself of any reagents you may have consumed or come into contact with."
	set category = "IC"

	if(stat == DEAD) return

	to_chat(src, span_notice("Performing reagent purge, please wait..."))
	sleep(50)
	src.bloodstr.clear_reagents()
	src.ingested.clear_reagents()
	src.touching.clear_reagents()
	to_chat(src, span_notice("Reagents purged!"))

	return TRUE

/mob/living/carbon/human/verb/toggle_eyes_layer()
	set name = "Switch Eyes/Monitor Layer"
	set desc = "Toggle rendering of eyes/monitor above markings."
	set category = "IC"

	if(stat)
		to_chat(src, span_warning("You must be awake and standing to perform this action!"))
		return
	var/obj/item/organ/external/head/H = organs_by_name[BP_HEAD]
	if(!H)
		to_chat(src, span_warning("You don't seem to have a head!"))
		return

	H.eyes_over_markings = !H.eyes_over_markings
	update_icons_body()

	if(H.robotic)
		var/datum/robolimb/robohead = all_robolimbs[H.model]
		if(robohead.monitor_styles && robohead.monitor_icon)
			to_chat(src, span_notice("You reconfigure the rendering order of your facial display."))

	return TRUE
