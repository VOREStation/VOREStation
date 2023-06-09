/mob/living/silicon/robot
	var/sleeper_g
	var/sleeper_r
	var/leaping = 0
	var/pounce_cooldown = 0
	var/pounce_cooldown_time = 40
	var/leap_at
	var/dogborg = FALSE //Dogborg special features (overlays etc.)
	var/wideborg = FALSE //When the borg simply doesn't use standard 32p size.
	var/scrubbing = FALSE //Floor cleaning enabled
	var/datum/matter_synth/water_res = null
	var/notransform
	var/original_icon = 'icons/mob/robots.dmi'
	var/ui_style_vr = FALSE //Do we use our hud icons?
	var/sitting = FALSE
	var/bellyup = FALSE
	does_spin = FALSE
	var/wideborg_dept = 'icons/mob/widerobot_vr.dmi'
	var/vr_icons = list(
					   "handy-hydro",
					   "handy-service",
					   "handy-clerk",
					   "handy-janitor",
					   "handy-miner",
					   "handy-standard",
					   "handy-sec",
					   "mechoid-Standard",
					   "mechoid-Medical",
					   "mechoid-Security",
					   "mechoid-Science",
					   "mechoid-Engineering",
					   "mechoid-Miner",
					   "mechoid-Service",
					   "mechoid-Janitor",
					   "mechoid-Combat",
					   "mechoid-Combat-roll",
					   "mechoid-Combat-shield",
					   "Noble-CLN",
					   "Noble-SRV",
					   "Noble-DIG",
					   "Noble-MED",
					   "Noble-SEC",
					   "Noble-ENG",
					   "Noble-STD",
					   "zoomba-standard",
					   "zoomba-clerical",
					   "zoomba-engineering",
					   "zoomba-janitor",
					   "zoomba-medical",
					   "zoomba-crisis",
					   "zoomba-miner",
					   "zoomba-research",
					   "zoomba-security",
					   "zoomba-service",
					   "zoomba-combat",
					   "zoomba-combat-roll",
					   "zoomba-combat-shield",
					   "spiderscience",
					   "uptall-standard",
					   "uptall-standard2",
					   "uptall-medical",
					   "uptall-janitor",
					   "uptall-crisis",
					   "uptall-service",
					   "uptall-engineering",
					   "uptall-miner",
					   "uptall-security",
					   "uptall-science",
					   "worm-standard",
					   "worm-engineering",
					   "worm-janitor",
					   "worm-crisis",
					   "worm-miner",
					   "worm-security",
					   "worm-combat",
					   "worm-surgeon",
					   "worm-service"
					   )					//List of all used sprites that are in robots_vr.dmi


/mob/living/silicon/robot/verb/robot_nom(var/mob/living/T in living_mobs(1))
	set name = "Robot Nom"
	set category = "IC"
	set desc = "Allows you to eat someone."

	if (stat != CONSCIOUS)
		return
	return feed_grabbed_to_self(src,T)

/mob/living/silicon/robot/lay_down()
	 . = ..()
	 updateicon()

/mob/living/silicon/robot/proc/rest_style()
	set name = "Switch Rest Style"
	set category = "IC"
	set desc = "Select your resting pose."
	sitting = FALSE
	bellyup = FALSE
	var/choice = tgui_alert(src, "Select resting pose", "Resting Pose", list("Resting", "Sitting", "Belly up"))
	switch(choice)
		if("Resting")
			return 0
		if("Sitting")
			sitting = TRUE
		if("Belly up")
			bellyup = TRUE

/mob/living/silicon/robot/updateicon()
	vr_sprite_check()
	..()
	if(dogborg == TRUE && stat == CONSCIOUS)
		if(sleeper_g == TRUE)
			add_overlay("[module_sprites[icontype]]-sleeper_g")
		if(sleeper_r == TRUE)
			add_overlay("[module_sprites[icontype]]-sleeper_r")
		if(istype(module_active,/obj/item/weapon/gun/energy/laser/mounted))
			add_overlay("laser")
		if(istype(module_active,/obj/item/weapon/gun/energy/taser/mounted/cyborg))
			add_overlay("taser")
		if(lights_on)
			add_overlay("eyes-[module_sprites[icontype]]-lights")
		if(resting)
			cut_overlays() // Hide that gut for it has no ground sprite yo.
			if(sitting)
				icon_state = "[module_sprites[icontype]]-sit"
			if(bellyup)
				icon_state = "[module_sprites[icontype]]-bellyup"
			else if(!sitting && !bellyup)
				icon_state = "[module_sprites[icontype]]-rest"
		else
			icon_state = "[module_sprites[icontype]]"
	if(dogborg == TRUE && stat == DEAD)
		icon_state = "[module_sprites[icontype]]-wreck"
		add_overlay("wreck-overlay")

/mob/living/silicon/robot/proc/vr_sprite_check()
	if(custom_sprite == TRUE)
		return
	if(wideborg == TRUE)
		if(icontype == "Drake") // Why, Why can't we have normal nice things
			icon = 'icons/mob/drakeborg/drakeborg_vr.dmi'
		else if(icontype == "Raptor V-4" || icontype == "Raptor V-4000") //Added for raptor sprites
			icon = 'icons/mob/raptorborg/raptor.dmi'
		else
			icon = wideborg_dept
		return
	if((!(original_icon == icon)) && (!(icon == 'icons/mob/robots_vr.dmi')))
		original_icon = icon
	if((icon_state in vr_icons) && (icon == 'icons/mob/robots.dmi'))
		icon = 'icons/mob/robots_vr.dmi'
	else if(!(icon_state in vr_icons))
		icon = original_icon

/mob/living/silicon/robot/proc/ex_reserve_refill()
	set name = "Refill Extinguisher"
	set category = "Object"
	var/datum/matter_synth/water = water_res
	for(var/obj/item/weapon/extinguisher/E in module.modules)
		if(E.reagents.total_volume < E.max_water)
			if(water && water.energy > 0)
				var/amount = E.max_water - E.reagents.total_volume
				if(water.energy < amount)
					amount = water.energy
				water.use_charge(amount)
				E.reagents.add_reagent("water", amount)
				to_chat(src, "<span class='filter_notice'>You refill the extinguisher using your water reserves.</span>")
			else
				to_chat(src, "<span class='filter_notice'>Insufficient water reserves.</span>")

//RIDING
/datum/riding/dogborg
	keytype = /obj/item/weapon/material/twohanded/riding_crop // Crack!
	nonhuman_key_exemption = FALSE	// If true, nonhumans who can't hold keys don't need them, like borgs and simplemobs.
	key_name = "a riding crop"		// What the 'keys' for the thing being rided on would be called.
	only_one_driver = TRUE			// If true, only the person in 'front' (first on list of riding mobs) can drive.

/datum/riding/dogborg/handle_vehicle_layer()
	ridden.layer = initial(ridden.layer)

/datum/riding/dogborg/ride_check(mob/living/M)
	var/mob/living/L = ridden
	if(L.stat)
		force_dismount(M)
		return FALSE
	return TRUE

/datum/riding/dogborg/force_dismount(mob/M)
	. =..()
	ridden.visible_message("<span class='notice'>[M] stops riding [ridden]!</span>")

//Hoooo boy.
/datum/riding/dogborg/get_offsets(pass_index) // list(dir = x, y, layer)
	var/mob/living/L = ridden
	var/scale = L.size_multiplier
	var/scale_difference = (L.size_multiplier - rider_size) * 10

	var/list/values = list(
		"[NORTH]" = list(0, 10*scale + scale_difference, ABOVE_MOB_LAYER),
		"[SOUTH]" = list(0, 10*scale + scale_difference, BELOW_MOB_LAYER),
		"[EAST]" = list(-5*scale, 10*scale + scale_difference, ABOVE_MOB_LAYER),
		"[WEST]" = list(5*scale, 10*scale + scale_difference, ABOVE_MOB_LAYER))

	return values

//Human overrides for taur riding
/mob/living/silicon/robot
	max_buckled_mobs = 1 //Yeehaw
	can_buckle = TRUE
	buckle_movable = TRUE
	buckle_lying = FALSE

/mob/living/silicon/robot/New(loc,var/unfinished = 0)
	..()
	riding_datum = new /datum/riding/dogborg(src)

/mob/living/silicon/robot/buckle_mob(mob/living/M, forced = FALSE, check_loc = TRUE)
	if(forced)
		return ..() // Skip our checks
	if(!dogborg)
		return FALSE
	if(lying)
		return FALSE
	if(!ishuman(M))
		return FALSE
	if(M in buckled_mobs)
		return FALSE
	if(M.size_multiplier > size_multiplier * 1.2)
		to_chat(src, "<span class='warning'>This isn't a pony show! You need to be bigger for them to ride.</span>")
		return FALSE

	var/mob/living/carbon/human/H = M

	if(istaurtail(H.tail_style))
		to_chat(src, "<span class='warning'>Too many legs. TOO MANY LEGS!!</span>")
		return FALSE
	if(M.loc != src.loc)
		if(M.Adjacent(src))
			M.forceMove(get_turf(src))

	. = ..()
	if(.)
		riding_datum.rider_size = M.size_multiplier
		buckled_mobs[M] = "riding"

/mob/living/silicon/robot/MouseDrop_T(mob/living/M, mob/living/user) //Prevention for forced relocation caused by can_buckle. Base proc has no other use.
	return

/mob/living/silicon/robot/attack_hand(mob/user as mob)
	if(LAZYLEN(buckled_mobs))
		//We're getting off!
		if(user in buckled_mobs)
			riding_datum.force_dismount(user)
		//We're kicking everyone off!
		if(user == src)
			for(var/rider in buckled_mobs)
				riding_datum.force_dismount(rider)
	else
		. = ..()

/mob/living/silicon/robot/proc/robot_mount(var/mob/living/M in living_mobs(1))
	set name = "Robot Mount/Dismount"
	set category = "Abilities"
	set desc = "Let people ride on you."

	if(LAZYLEN(buckled_mobs))
		for(var/rider in buckled_mobs)
			riding_datum.force_dismount(rider)
		return
	if (stat != CONSCIOUS)
		return
	if(!can_buckle || !istype(M) || !M.Adjacent(src) || M.buckled)
		return
	if(buckle_mob(M))
		visible_message("<span class='notice'>[M] starts riding [name]!</span>")

/mob/living/silicon/robot/onTransitZ(old_z, new_z)
	if(shell)
		if(deployed && using_map.ai_shell_restricted && !(new_z in using_map.ai_shell_allowed_levels))
			to_chat(src, "<span class='warning'>Your connection with the shell is suddenly interrupted!</span>")
			undeploy()
	..()
