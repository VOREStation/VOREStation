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
					   "mechoid-Combat-roll"
					   )					//List of all used sprites that are in robots_vr.dmi


/mob/living/silicon/robot/verb/robot_nom(var/mob/living/T in living_mobs(1))
	set name = "Robot Nom"
	set category = "IC"
	set desc = "Allows you to eat someone."

	if (stat != CONSCIOUS)
		return
	return feed_grabbed_to_self(src,T)

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
			icon_state = "[module_sprites[icontype]]-rest"
		else
			icon_state = "[module_sprites[icontype]]"
	if(dogborg == TRUE && stat == DEAD)
		icon_state = "[module_sprites[icontype]]-wreck"
		add_overlay("wreck-overlay")

/mob/living/silicon/robot/Move(a, b, flag)
	. = ..()
	if(scrubbing)
		var/datum/matter_synth/water = water_res
		if(water && water.energy >= 1)
			var/turf/tile = loc
			if(isturf(tile))
				water.use_charge(1)
				tile.clean_blood()
				if(istype(tile, /turf/simulated))
					var/turf/simulated/T = tile
					T.dirt = 0
				for(var/A in tile)
					if(istype(A,/obj/effect/rune) || istype(A,/obj/effect/decal/cleanable) || istype(A,/obj/effect/overlay))
						qdel(A)
					else if(istype(A, /mob/living/carbon/human))
						var/mob/living/carbon/human/cleaned_human = A
						if(cleaned_human.lying)
							if(cleaned_human.head)
								cleaned_human.head.clean_blood()
								cleaned_human.update_inv_head(0)
							if(cleaned_human.wear_suit)
								cleaned_human.wear_suit.clean_blood()
								cleaned_human.update_inv_wear_suit(0)
							else if(cleaned_human.w_uniform)
								cleaned_human.w_uniform.clean_blood()
								cleaned_human.update_inv_w_uniform(0)
							if(cleaned_human.shoes)
								cleaned_human.shoes.clean_blood()
								cleaned_human.update_inv_shoes(0)
							cleaned_human.clean_blood(1)
							cleaned_human << "<span class='warning'>[src] cleans your face!</span>"
	return

/mob/living/silicon/robot/proc/vr_sprite_check()
	if(wideborg == TRUE)
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
				to_chat(src, "You refill the extinguisher using your water reserves.")
			else
				to_chat(src, "Insufficient water reserves.")

//RIDING
/datum/riding/dogborg
	keytype = /obj/item/weapon/material/twohanded/fluff/riding_crop // Crack!
	nonhuman_key_exemption = FALSE	// If true, nonhumans who can't hold keys don't need them, like borgs and simplemobs.
	key_name = "a riding crop"		// What the 'keys' for the thing being rided on would be called.
	only_one_driver = TRUE			// If true, only the person in 'front' (first on list of riding mobs) can drive.

/datum/riding/dogborg/handle_vehicle_layer()
	if(ridden.has_buckled_mobs())
		if(ridden.dir != NORTH)
			ridden.layer = ABOVE_MOB_LAYER
		else
			ridden.layer = initial(ridden.layer)
	else
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

	var/list/values = list(
		"[NORTH]" = list(0, 8*scale, ABOVE_MOB_LAYER),
		"[SOUTH]" = list(0, 8*scale, BELOW_MOB_LAYER),
		"[EAST]" = list(-5*scale, 8*scale, ABOVE_MOB_LAYER),
		"[WEST]" = list(5*scale, 8*scale, ABOVE_MOB_LAYER))

	return values

//Human overrides for taur riding
/mob/living/silicon/robot
	max_buckled_mobs = 1 //Yeehaw
	can_buckle = TRUE
	buckle_movable = TRUE
	buckle_lying = FALSE

/mob/living/silicon/robot/New()
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
		to_chat(src,"<span class='warning'>This isn't a pony show! You need to be bigger for them to ride.</span>")
		return FALSE

	var/mob/living/carbon/human/H = M

	if(isTaurTail(H.tail_style))
		to_chat(src,"<span class='warning'>Too many legs. TOO MANY LEGS!!</span>")
		return FALSE
	if(M.loc != src.loc)
		if(M.Adjacent(src))
			M.forceMove(get_turf(src))

	. = ..()
	if(.)
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