var/list/ventcrawl_machinery = list(
	/obj/machinery/atmospherics/unary/vent_pump,
	/obj/machinery/atmospherics/unary/vent_scrubber
	)

// Vent crawling whitelisted items, whoo
/mob/living/var/list/can_enter_vent_with = list(
<<<<<<< HEAD
	/obj/item/weapon/implant,
	/obj/item/device/radio/borg,
	/obj/item/device/radio/headset/mob_headset,
	/obj/item/weapon/holder,
=======
	/obj/item/implant,
	/obj/item/radio/borg,
	/obj/item/holder,
>>>>>>> 61084723c7b... Merge pull request #8317 from Atermonera/remove_weapon
	/obj/machinery/camera,
	/obj/belly,
	/obj/screen,
	/atom/movable/emissive_blocker
	)
	//VOREStation Edit : added /obj/belly, to this list, CI is complaining about this in his indentation check. Added mob_headset for those with radios so there's no weirdness.
	//mob/living/simple_mob/borer, //VORESTATION AI TEMPORARY REMOVAL REPLACE BACK IN LIST WHEN RESOLVED //VOREStation Edit

/mob/living/var/list/icon/pipes_shown = list()
/mob/living/var/last_played_vent
/mob/living/var/is_ventcrawling = 0
/mob/living/var/prepping_to_ventcrawl = 0
/mob/var/next_play_vent = 0

/mob/living/proc/can_ventcrawl()
	if(!client)
		return FALSE
	if(!(/mob/living/proc/ventcrawl in verbs))
		to_chat(src, "<span class='warning'>You don't possess the ability to ventcrawl!</span>")
		return FALSE
	if(pulling)
		to_chat(src, "<span class='warning'>You cannot bring \the [pulling] into the vent with you!</span>")
		return FALSE
	if(incapacitated())
		to_chat(src, "<span class='warning'>You cannot ventcrawl in your current state!</span>")
		return FALSE
	if(buckled)
		to_chat(src, "<span class='warning'>You cannot ventcrawl while buckled!</span>")
		return FALSE
	if(restrict_vore_ventcrawl)
		var/foundstuff = FALSE
		for(var/obj/belly/B in vore_organs)
			if(B.contents.len)
				foundstuff = TRUE
				break
		if(foundstuff)
			to_chat(src, "<span class='warning'>You cannot ventcrawl while full!</span>")
			return FALSE
	return ventcrawl_carry()

/mob/living/Login()
	. = ..()
	//login during ventcrawl
	if(is_ventcrawling && istype(loc, /obj/machinery/atmospherics)) //attach us back into the pipes
		remove_ventcrawl()
		add_ventcrawl(loc)
		client.screen += global_hud.centermarker

/mob/living/simple_mob/slime/xenobio/can_ventcrawl()
	if(victim)
		to_chat(src, "<span class='warning'>You cannot ventcrawl while feeding.</span>")
		return FALSE
	. = ..()

/mob/living/proc/is_allowed_vent_crawl_item(var/obj/carried_item)
	//Ability master easy test for allowed (cheaper than istype)
	if(carried_item == ability_master)
		return 1
	if(isanimal(src))
		var/mob/living/simple_mob/S = src
		if(carried_item == S.mobcard)	//VOREStation Edit
			return 1	//VOREStation Edit
	//Try to find it in our allowed list (istype includes subtypes)
	var/listed = FALSE
	for(var/test_type in can_enter_vent_with)
		if(istype(carried_item,test_type))
			listed = TRUE
			break

	//Only allow it if it's "IN" the mob, not equipped on/being held. //Disabled, as it's very annoying that, for example, Pun Pun has no way to ventcrawl with his suit if given the verb, since the list of allowed items is ignored for worn items.
	if(listed/* && !get_inventory_slot(carried_item)*/)
		return 1

/mob/living/carbon/is_allowed_vent_crawl_item(var/obj/item/carried_item)
	if(carried_item in internal_organs)
		return 1
	return ..()

/mob/living/carbon/human/is_allowed_vent_crawl_item(var/obj/item/carried_item)
	if(carried_item in organs)
		return 1
	return ..()

/mob/living/proc/ventcrawl_carry()
	for(var/atom/A in contents)
		if(!is_allowed_vent_crawl_item(A))
			to_chat(src, "<span class='warning'>You can't carry \the [A] while ventcrawling!</span>")
			return FALSE
	return TRUE

/mob/living/AltClickOn(var/atom/A)
	if(is_type_in_list(A,ventcrawl_machinery))
		handle_ventcrawl(A)
		return 1
	return ..()

/mob/proc/start_ventcrawl()
	var/atom/pipe
	var/list/pipes = list()
	for(var/obj/machinery/atmospherics/unary/U in range(1))
		if(is_type_in_list(U,ventcrawl_machinery) && Adjacent(U) && !U.welded)
			pipes |= U
	if(!pipes || !pipes.len)
		to_chat(src, "There are no pipes that you can ventcrawl into within range!")
		return
	if(pipes.len == 1)
		pipe = pipes[1]
	else
		pipe = tgui_input_list(usr, "Crawl Through Vent", "Pick a pipe", pipes)
	if(canmove && pipe)
		return pipe

/mob/living/carbon/alien/ventcrawl_carry()
	return 1

/mob/living/var/ventcrawl_layer = 3

/mob/living/proc/handle_ventcrawl(var/atom/clicked_on)
	if(!can_ventcrawl() || prepping_to_ventcrawl)
		return

	var/obj/machinery/atmospherics/unary/vent_found
	if(clicked_on && Adjacent(clicked_on))
		vent_found = clicked_on
		if(!istype(vent_found) || !vent_found.can_crawl_through())
			vent_found = null

	if(!vent_found)
		for(var/obj/machinery/atmospherics/machine in range(1,src))
			if(is_type_in_list(machine, ventcrawl_machinery))
				vent_found = machine

			if(!vent_found || !vent_found.can_crawl_through())
				vent_found = null

			if(vent_found)
				break

	if(vent_found)
		if(vent_found.network && (vent_found.network.normal_members.len || vent_found.network.line_members.len))

			to_chat(src, "You begin climbing into the ventilation system...")
			if(vent_found.air_contents && !issilicon(src))

				switch(vent_found.air_contents.temperature)
					if(0 to BODYTEMP_COLD_DAMAGE_LIMIT)
						to_chat(src, "<span class='danger'>You feel a painful freeze coming from the vent!</span>")
					if(BODYTEMP_COLD_DAMAGE_LIMIT to T0C)
						to_chat(src, "<span class='warning'>You feel an icy chill coming from the vent.</span>")
					if(T0C + 40 to BODYTEMP_HEAT_DAMAGE_LIMIT)
						to_chat(src, "<span class='warning'>You feel a hot wash coming from the vent.</span>")
					if(BODYTEMP_HEAT_DAMAGE_LIMIT to INFINITY)
						to_chat(src, "<span class='danger'>You feel a searing heat coming from the vent!</span>")

				switch(vent_found.air_contents.return_pressure())
					if(0 to HAZARD_LOW_PRESSURE)
						to_chat(src, "<span class='danger'>You feel a rushing draw pulling you into the vent!</span>")
					if(HAZARD_LOW_PRESSURE to WARNING_LOW_PRESSURE)
						to_chat(src, "<span class='warning'>You feel a strong drag pulling you into the vent.</span>")
					if(WARNING_HIGH_PRESSURE to HAZARD_HIGH_PRESSURE)
						to_chat(src, "<span class='warning'>You feel a strong current pushing you away from the vent.</span>")
					if(HAZARD_HIGH_PRESSURE to INFINITY)
						to_chat(src, "<span class='danger'>You feel a roaring wind pushing you away from the vent!</span>")

			fade_towards(vent_found,45)
			prepping_to_ventcrawl = 1
			spawn(50)
				prepping_to_ventcrawl = 0
			if(!do_after(src, 45, vent_found, 1, 1))
				return
			if(!can_ventcrawl())
				return

			visible_message("<B>[src] scrambles into the ventilation ducts!</B>", "You climb into the ventilation system.")

			forceMove(vent_found)
			add_ventcrawl(vent_found)

		else
			to_chat(src, "This vent is not connected to anything.")

	else
		to_chat(src, "You must be standing on or beside an air vent to enter it.")

/mob/living/proc/add_ventcrawl(obj/machinery/atmospherics/starting_machine)
	is_ventcrawling = 1
	//candrop = 0
	var/datum/pipe_network/network = starting_machine.return_network(starting_machine)
	if(!network)
		return
	for(var/datum/pipeline/pipeline in network.line_members)
		for(var/obj/machinery/atmospherics/A in (pipeline.members || pipeline.edges))
			if(!A.pipe_image)
				A.pipe_image = image(A, A.loc, dir = A.dir)
				A.pipe_image.plane = PLANE_LIGHTING_ABOVE
			pipes_shown += A.pipe_image
			client.images += A.pipe_image
	if(client)
		client.screen += global_hud.centermarker

/mob/living/proc/remove_ventcrawl()
	is_ventcrawling = 0
	//candrop = 1
	if(client)
		for(var/image/current_image in pipes_shown)
			client.images -= current_image
		client.screen -= global_hud.centermarker
		client.eye = src

	pipes_shown.len = 0
