/mob/living/carbon
	var/list/installed_endoware = list() //TODO: lazylist
	var/list/endoware_planes = list() //TODO: lazylist - not happy about this, but alas recalculate_vis is a bitch
	var/endoware_flags = 0

	var/datum/commandline_network/cmdNetwork //direct hardref to the component's network



/mob/living/carbon/verb/activate_endoware()
	set category = "Abilities.Endoware"
	set desc = "Bring up a menu for the active endoware you can and can not activate"

	if(LAZYLEN(installed_endoware) == 0)
		to_chat(src,span_notice("You think REALLY hard, and do absolutely nothing. You have nothing TO activate."))

	var/list/options = list()

	for(var/obj/item/endoware/larp in installed_endoware)
		if(larp.is_activatable)
			larp.can_activate() //we display it anyway...
			larp.update_radial_image()

		options["\ref[larp]"] = larp.radial_image

	var/choice = show_radial_menu(src, src, options, require_near = TRUE)
	if(choice == null || choice == "")
		return
	var/obj/item/endoware/etc = locate(choice) in installed_endoware
	if(etc)
		etc.attempt_activate()
//radial menu time

/mob/living/carbon/proc/InitNetworkIfNeeded()
	if(!cmdNetwork)
		var/datum/component/commandline_network/cmdNetworkComp = GetComponent(/datum/component/commandline_network)
		cmdNetwork = cmdNetworkComp?.network
		if(!cmdNetwork)
			src.AddComponent(/datum/component/commandline_network/carbon)

/mob/living/carbon/proc/update_endoware_flags()
	endoware_flags = 0
	for(var/obj/item/endoware/source in installed_endoware)
		endoware_flags |= source.endoware_flags

/mob/living/carbon/proc/update_endoware_vision()
	endoware_planes = list()
	for(var/obj/item/endoware/source in installed_endoware) //might be better to move this to base endoware
		var/to_add = source.get_vision_planes()
		if(to_add)
			endoware_planes |= to_add
	recalculate_vis()
