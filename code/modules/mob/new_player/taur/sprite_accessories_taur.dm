/datum/sprite_accessory/tail/taur
	name = DEVELOPER_WARNING_NAME
	do_colouration = TRUE // Yes color, using tail color
	color_blend_mode = ICON_MULTIPLY  // The sprites for taurs are designed for ICON_MULTIPLY

	var/can_ride = TRUE			//whether we're real rideable taur or just in that category
	offset_x = -16
	em_block = TRUE

	var/icon/suit_sprites = null //File for suit sprites, if any.
	var/icon/under_sprites = null

	var/icon_sprite_tag			// This is where we put stuff like _Horse, so we can assign icons easier.

	//Could do nested lists but it started becoming a nightmare. It'd be more fun for lookups of a_intent and m_intent, but then subtypes need to
	//duplicate all the messages, and it starts getting awkward. These are singletons, anyway!

	//Messages to owner when stepping on/over
	var/msg_owner_help_walk		= "You carefully step over %prey."
	var/msg_owner_help_run		= "You carefully step over %prey."
	var/msg_owner_harm_walk		= "You methodically place your foot down upon %prey's body, slowly applying pressure, crushing them against the floor below!"
	var/msg_owner_harm_run		= "You carelessly step down onto %prey, crushing them!"
	var/msg_owner_disarm_walk	= "You firmly push your foot down on %prey, painfully but harmlessly pinning them to the ground!"
	var/msg_owner_disarm_run	= "You quickly push %prey to the ground with your foot!"
	var/msg_owner_grab_fail		= "You step down onto %prey, squishing them and forcing them down to the ground!"
	var/msg_owner_grab_success	= "You pin %prey down onto the floor with your foot and curl your toes up around their body, trapping them inbetween them!"

	//Messages to prey when stepping on/over
	var/msg_prey_help_walk		= "%owner steps over you carefully!"
	var/msg_prey_help_run		= "%owner steps over you carefully!"
	var/msg_prey_harm_walk		= "%owner methodically places their foot upon your body, slowly applying pressure, crushing you against the floor below!"
	var/msg_prey_harm_run		= "%owner steps carelessly on your body, crushing you!"
	var/msg_prey_disarm_walk	= "%owner firmly pushes their foot down on you, quite painfully but harmlessly pinning you to the ground!"
	var/msg_prey_disarm_run		= "%owner pushes you down to the ground with their foot!"
	var/msg_prey_grab_fail		= "%owner steps down and squishes you with their foot, forcing you down to the ground!"
	var/msg_prey_grab_success	= "%owner pins you down to the floor with their foot and curls their toes up around your body, trapping you inbetween them!"

	//Messages for smalls moving under larges
	var/msg_owner_stepunder		= "%owner runs between your legs." //Weird becuase in the case this is used, %owner is the 'bumper' (src)
	var/msg_prey_stepunder		= "You run between %prey's legs." //Same, inverse
	hide_body_parts	= list(BP_L_LEG, BP_L_FOOT, BP_R_LEG, BP_R_FOOT) //Exclude pelvis just in case.
	clip_mask_state = "taur_clip_mask_def" //Used to clip off the lower part of suits & uniforms.

/datum/riding/taur
	keytype = /obj/item/material/twohanded/riding_crop // Crack!
	nonhuman_key_exemption = FALSE	// If true, nonhumans who can't hold keys don't need them, like borgs and simplemobs.
	key_name = "a riding crop"		// What the 'keys' for the thing being rided on would be called.
	only_one_driver = TRUE			// If true, only the person in 'front' (first on list of riding mobs) can drive.

/datum/riding/taur/handle_vehicle_layer()
	if(ridden.has_buckled_mobs())
		ridden.layer = initial(ridden.layer)
	else
		var/mob/living/L = ridden
		if(!(istype(L) && (L.status_flags & HIDING)))
			ridden.layer = initial(ridden.layer)

/datum/riding/taur/ride_check(mob/living/M)
	var/mob/living/L = ridden
	if(L.stat)
		force_dismount(M)
		return FALSE
	return TRUE

/datum/riding/taur/force_dismount(mob/M)
	. = ..()
	ridden.visible_message(span_notice("[M] stops riding [ridden]!"))

//Hoooo boy.
/datum/riding/taur/get_offsets(pass_index) // list(dir = x, y, layer)
	var/mob/living/L = ridden
	var/scale_x = L.icon_scale_x * L.size_multiplier //VOREStation Edit Start
	var/scale_y = L.icon_scale_y * L.size_multiplier
	var/scale_difference = (L.size_multiplier - rider_size) * 10

	var/list/values = list(
		"[NORTH]" = list(0, 8*scale_y + scale_difference, ABOVE_MOB_LAYER),
		"[SOUTH]" = list(0, 8*scale_y + scale_difference, BELOW_MOB_LAYER),
		"[EAST]" = list(-10*scale_x, 8*scale_y + scale_difference, ABOVE_MOB_LAYER),
		"[WEST]" = list(10*scale_x, 8*scale_y + scale_difference, ABOVE_MOB_LAYER)) //VOREStation Edit End

	return values

//Human overrides for taur riding
/mob/living/carbon/human
	max_buckled_mobs = 1 //Yeehaw
	can_buckle = TRUE
	buckle_movable = TRUE
	buckle_lying = FALSE

/mob/living/carbon/human/buckle_mob(mob/living/M, forced = FALSE, check_loc = TRUE)
	if(forced)
		return ..() // Skip our checks
	if(is_incorporeal(src) || is_incorporeal(M))
		return FALSE
	if(!istaurtail(tail_style))
		return FALSE
	else
		var/datum/sprite_accessory/tail/taur/taurtype = tail_style
		if(!taurtype.can_ride)
			return FALSE
	if(lying)
		return FALSE
	if(!ishuman(M))
		return FALSE
	if(M in buckled_mobs)
		return FALSE
//	if(M.size_multiplier > size_multiplier * 1.2)
//		to_chat(M,span_warning("This isn't a pony show! You need to be bigger for them to ride."))
//		return FALSE
	if(M.loc != src.loc)
		if(M.Adjacent(src))
			M.forceMove(get_turf(src))

	var/mob/living/carbon/human/H = M

	if(istaurtail(H.tail_style))
		to_chat(src,span_warning("Too many legs. TOO MANY LEGS!!"))
		return FALSE

	. = ..()
	if(.)
		riding_datum.rider_size = M.size_multiplier
		buckled_mobs[M] = "riding"

/mob/living/carbon/human/MouseDrop_T(mob/living/M, mob/living/user) //Prevention for forced relocation caused by can_buckle. Base proc has no other use.
	return

/mob/living/carbon/human/proc/taur_mount(mob/living/M in living_mobs(1))
	set name = "Taur Mount/Dismount"
	set category = "Abilities.General"
	set desc = "Let people ride on you."

	if(LAZYLEN(buckled_mobs) && riding_datum)
		var/datum/riding/R = riding_datum
		for(var/rider in buckled_mobs)
			R.force_dismount(rider)
		return
	if (stat != CONSCIOUS)
		return
	if(!can_buckle || !istype(M) || !M.Adjacent(src) || M.buckled)
		return
	if(buckle_mob(M))
		visible_message(span_notice("[M] starts riding [name]!"))

/mob/living/carbon/human/attack_hand(mob/user as mob)
	if(LAZYLEN(buckled_mobs) && riding_datum)
		//We're getting off!
		if(user in buckled_mobs)
			riding_datum.force_dismount(user)
		//We're kicking everyone off!
		if(user == src)
			for(var/rider in buckled_mobs)
				riding_datum.force_dismount(rider)
	else
		. = ..()
