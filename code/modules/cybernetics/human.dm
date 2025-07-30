/mob/living/carbon
	var/list/installed_endoware = list()

/mob/living/carbon/human/verb/activate_endoware()
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
