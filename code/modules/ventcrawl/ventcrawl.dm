/mob/living/var/list/icon/pipes_shown = list()
/mob/living/var/last_played_vent
/mob/living/var/is_ventcrawling = FALSE
/mob/living/var/prepping_to_ventcrawl = FALSE
/mob/var/next_play_vent = 0

/mob/living/proc/can_ventcrawl()
	if(!client)
		return FALSE
	if(!(/mob/living/proc/ventcrawl in verbs))
		to_chat(src, span_warning("You don't possess the ability to ventcrawl!"))
		return FALSE
	if(pulling)
		to_chat(src, span_warning("You cannot bring \the [pulling] into the vent with you!"))
		return FALSE
	if(incapacitated())
		to_chat(src, span_warning("You cannot ventcrawl in your current state!"))
		return FALSE
	if(buckled)
		to_chat(src, span_warning("You cannot ventcrawl while buckled!"))
		return FALSE
	if(restrict_vore_ventcrawl)
		var/foundstuff = FALSE
		for(var/obj/belly/B in vore_organs)
			if(B.contents.len)
				foundstuff = TRUE
				break
		if(foundstuff)
			to_chat(src, span_warning("You cannot ventcrawl while full!"))
			return FALSE
	return ventcrawl_carry()

/mob/living/Login()
	. = ..()
	//login during ventcrawl
	if(is_ventcrawling && istype(loc, /obj/machinery/atmospherics)) //attach us back into the pipes
		remove_ventcrawl()
		add_ventcrawl(loc)
		client.screen += GLOB.global_hud.centermarker

/mob/living/simple_mob/slime/xenobio/can_ventcrawl()
	if(victim)
		to_chat(src, span_warning("You cannot ventcrawl while feeding."))
		return FALSE
	. = ..()

/mob/living/proc/is_allowed_vent_crawl_item(var/obj/carried_item)
	//Ability master easy test for allowed (cheaper than istype)
	if(carried_item == ability_master)
		return TRUE
	if(isanimal(src))
		var/mob/living/simple_mob/S = src
		if(carried_item == S.myid)
			return TRUE
	//Try to find it in our allowed list (istype includes subtypes)
	var/listed = FALSE
	var/list/vent_allow = ventcrawl_get_item_whitelist()
	if(islist(ventcraw_item_admin_allow)) // If mob has a list varedited onto it, we allow anything in this list as well
		vent_allow += ventcraw_item_admin_allow
	for(var/test_type in vent_allow)
		if(istype(carried_item,test_type))
			listed = TRUE
			break

	//Only allow it if it's "IN" the mob, not equipped on/being held. //Disabled, as it's very annoying that, for example, Pun Pun has no way to ventcrawl with his suit if given the verb, since the list of allowed items is ignored for worn items.
	if(listed/* && !get_inventory_slot(carried_item)*/)
		return TRUE

/mob/living/carbon/is_allowed_vent_crawl_item(var/obj/item/carried_item)
	if(carried_item in internal_organs)
		return TRUE
	return ..()

/mob/living/carbon/human/is_allowed_vent_crawl_item(var/obj/item/carried_item)
	if(carried_item in organs)
		return TRUE
	if(species.name == SPECIES_REPLICANT_CREW)
		if(istype(carried_item, /obj/item/clothing/under))
			return TRUE //Allow them to not vent crawl naked
		if(istype(carried_item, /obj/item))
			var/obj/item/I = carried_item
			if(I.w_class <= ITEMSIZE_SMALL)
				return TRUE //Allow them to carry items that fit in pockets
	return ..()

/mob/living/proc/ventcrawl_carry()
	for(var/atom/A in contents)
		if(!is_allowed_vent_crawl_item(A))
			to_chat(src, span_warning("You can't carry \the [A] while ventcrawling!"))
			return FALSE
	return TRUE

/mob/living/proc/ventcrawl_get_item_whitelist()
	return list(
		VENTCRAWL_BASE_WHITELIST,
		VENTCRAWL_VORE_WHITELIST,
		VENTCRAWL_SMALLITEM_WHITELIST
		)

/mob/living/simple_mob/protean_blob/ventcrawl_carry()
	for(var/atom/A in contents)
		if(!is_allowed_vent_crawl_item(A))
			to_chat(src, span_warning("You can't carry \the [A] while ventcrawling!"))
			return FALSE
	if(humanform)
		for(var/atom/B in humanform.get_contents())
			if(!is_allowed_vent_crawl_item(B))
				to_chat(src, span_warning("You can't carry \the [B] while ventcrawling!"))
				return FALSE
	return TRUE

/mob/living/simple_mob/protean_blob/is_allowed_vent_crawl_item(var/obj/item/carried_item)
	if((carried_item in humanform.organs) || (carried_item in humanform.internal_organs))
		return TRUE
	if(istype(carried_item, /obj/item/clothing/under))
		return TRUE //Allow jumpsuits only
	if(istype(carried_item, /obj/item))
		var/obj/item/I = carried_item
		if(I.w_class <= ITEMSIZE_SMALL)
			return TRUE //Allow them to carry items that fit in pockets
	return ..()

/mob/living/AltClickOn(var/atom/A)
	if(is_type_in_list(A, GLOB.ventcrawl_machinery))
		handle_ventcrawl(A)
		return 1
	return ..()

/mob/proc/start_ventcrawl()
	var/atom/pipe
	var/list/pipes = list()
	for(var/obj/machinery/atmospherics/unary/U in range(1))
		if(is_type_in_list(U, GLOB.ventcrawl_machinery) && Adjacent(U) && !U.welded)
			pipes |= U
	if(!pipes || !pipes.len)
		to_chat(src, "There are no pipes that you can ventcrawl into within range!")
		return
	if(pipes.len == 1)
		pipe = pipes[1]
	else
		pipe = tgui_input_list(src, "Crawl Through Vent", "Pick a pipe", pipes)
	if(canmove && pipe)
		return pipe

/mob/living/carbon/alien/ventcrawl_carry()
	return TRUE

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
			if(is_type_in_list(machine, GLOB.ventcrawl_machinery))
				vent_found = machine

			if(!vent_found || !vent_found.can_crawl_through())
				vent_found = null

			if(vent_found)
				break

	if(vent_found)
		if(SEND_SIGNAL(src,COMSIG_MOB_VENTCRAWL_CHECK,vent_found) & VENT_CRAWL_BLOCK_ENTRY)
			return
		if(SEND_SIGNAL(vent_found,COMSIG_VENT_CRAWLER_CHECK,src) & VENT_CRAWL_BLOCK_ENTRY)
			return

		if(vent_found.network && (vent_found.network.normal_members.len || vent_found.network.line_members.len))
			to_chat(src, "You begin climbing into the ventilation system...")
			if(vent_found.air_contents && !issilicon(src))

				switch(vent_found.air_contents.temperature)
					if(0 to BODYTEMP_COLD_DAMAGE_LIMIT)
						to_chat(src, span_danger("You feel a painful freeze coming from the vent!"))
					if(BODYTEMP_COLD_DAMAGE_LIMIT to T0C)
						to_chat(src, span_warning("You feel an icy chill coming from the vent."))
					if(T0C + 40 to BODYTEMP_HEAT_DAMAGE_LIMIT)
						to_chat(src, span_warning("You feel a hot wash coming from the vent."))
					if(BODYTEMP_HEAT_DAMAGE_LIMIT to INFINITY)
						to_chat(src, span_danger("You feel a searing heat coming from the vent!"))

				switch(vent_found.air_contents.return_pressure())
					if(0 to HAZARD_LOW_PRESSURE)
						to_chat(src, span_danger("You feel a rushing draw pulling you into the vent!"))
					if(HAZARD_LOW_PRESSURE to WARNING_LOW_PRESSURE)
						to_chat(src, span_warning("You feel a strong drag pulling you into the vent."))
					if(WARNING_HIGH_PRESSURE to HAZARD_HIGH_PRESSURE)
						to_chat(src, span_warning("You feel a strong current pushing you away from the vent."))
					if(HAZARD_HIGH_PRESSURE to (HAZARD_HIGH_PRESSURE*2))
						to_chat(src, span_danger("You feel a roaring wind pushing you away from the vent!"))
					if((HAZARD_HIGH_PRESSURE*2) to INFINITY) // A little too crazy to enter
						to_chat(src, span_danger("You're pushed away by the extreme pressure in the vent!"))
						return

			// Handle animation delay
			fade_towards(vent_found, vent_crawl_time)
			prepping_to_ventcrawl = TRUE
			if(!do_after(src, vent_crawl_time, target = src))
				prepping_to_ventcrawl = FALSE
				return
			prepping_to_ventcrawl = FALSE

			if(!can_ventcrawl())
				return

			visible_message(span_infoplain(span_bold("[src] scrambles into the ventilation ducts!")), span_infoplain("You climb into the ventilation system."))

			forceMove(vent_found)
			add_ventcrawl(vent_found)
			SEND_SIGNAL(src,COMSIG_MOB_VENTCRAWL_START,vent_found)
			SEND_SIGNAL(vent_found,COMSIG_VENT_CRAWLER_ENTERED,src)
		else
			to_chat(src, "This vent is not connected to anything.")

	else
		to_chat(src, "You must be standing on or beside an air vent to enter it.")

/mob/living/proc/add_ventcrawl(obj/machinery/atmospherics/starting_machine)
	is_ventcrawling = TRUE
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
		client.screen += GLOB.global_hud.centermarker

/mob/living/proc/remove_ventcrawl()
	is_ventcrawling = FALSE
	//candrop = 1
	if(client)
		for(var/image/current_image in pipes_shown)
			client.images -= current_image
		client.screen -= GLOB.global_hud.centermarker
		reset_perspective(src)

	pipes_shown.len = 0
