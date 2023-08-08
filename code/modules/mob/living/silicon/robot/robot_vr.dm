/mob/living/silicon/robot
	var/datum/matter_synth/water_res = null

/mob/living/silicon/robot/verb/robot_nom(var/mob/living/T in living_mobs(1))
	set name = "Robot Nom"
	set category = "IC"
	set desc = "Allows you to eat someone."

	if (stat != CONSCIOUS)
		return
	return feed_grabbed_to_self(src,T)

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
