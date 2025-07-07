//Non-Canon on Virgo. Used downstream.

/datum/power/shadekin/dark_tunneling
	name = "Dark Tunneling (100) (Once)"
	desc = "Make a passage to the dark."
	verbpath = /mob/living/proc/dark_tunneling
	ability_icon_state = "minion0"

/mob/living/proc/dark_tunneling()
	set name = "Dark Tunneling (100) (Once)"
	set desc = "Make a passage to the dark."
	set category = "Abilities.Shadekin"

	var/template_id = "dark_portal"
	var/datum/map_template/shelter/template

	var/ability_cost = 100
	var/tunnel_time = 60 SECONDS

	var/datum/component/shadekin/SK = get_shadekin_component()
	if(!SK)
		return FALSE
	if(stat)
		to_chat(src, span_warning("Can't use that ability in your state!"))
		return FALSE

	if(SK.in_phase)
		to_chat(src, span_warning("You can't use that while phase shifted!"))
		return FALSE

	if(SK.created_dark_tunnel)
		to_chat(src, span_warning("You have already made a tunnel to the Dark!"))
		return FALSE

	if(!template)
		template = SSmapping.shelter_templates[template_id]
		if(!template)
			throw EXCEPTION("Shelter template ([template_id]) not found!")
			return FALSE

	var/turf/deploy_location = get_turf(src)
	var/status = template.check_deploy(deploy_location)

	switch(status)
		//Not allowed due to /area technical reasons
		if(SHELTER_DEPLOY_BAD_AREA)
			to_chat(src, span_warning("A tunnel to the Dark will not function in this area."))

		//Anchored objects or no space
		if(SHELTER_DEPLOY_BAD_TURFS, SHELTER_DEPLOY_ANCHORED_OBJECTS)
			var/width = template.width
			var/height = template.height
			to_chat(src, span_warning("There is not enough open area for a tunnel to the Dark to form! You need to clear a [width]x[height] area!"))

	if(status != SHELTER_DEPLOY_ALLOWED)
		return FALSE

	var/turf/T = deploy_location
	var/datum/effect/effect/system/smoke_spread/smoke = new /datum/effect/effect/system/smoke_spread()
	smoke.attach(T)
	smoke.set_up(10, 0, T)
	smoke.start()

	src.visible_message(span_notice("[src] begins pulling dark energies around themselves."))
	if(do_after(src, tunnel_time))
		playsound(src, 'sound/effects/phasein.ogg', 100, 1)
		src.visible_message(span_notice("[src] finishes pulling dark energies around themselves, creating a portal."))

		log_and_message_admins("[key_name_admin(src)] created a tunnel to the dark at [get_area(T)]!")
		template.annihilate_plants(deploy_location)
		template.load(deploy_location, centered = TRUE)
		template.update_lighting(deploy_location)
		SK.created_dark_tunnel = TRUE
		SK.shadekin_adjust_energy(-(ability_cost - 10)) //Leaving enough energy to actually activate the portal
		return TRUE
	return FALSE


/datum/map_template/shelter/dark_portal
	name = "Dark Portal"
	shelter_id = "dark_portal"
	description = "A portal to a section of the Dark"
	mappath = "maps/submaps/shelters/dark_portal.dmm"

/datum/map_template/shelter/dark_portal/New()
	. = ..()
	blacklisted_turfs = typecacheof(list(/turf/unsimulated))
	GLOB.blacklisted_areas = typecacheof(list(/area/centcom, /area/shadekin))
