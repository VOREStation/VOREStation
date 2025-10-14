/obj/item/material/fishing_net
	name = "fishing net"
	desc = "A crude fishing net."
	icon = 'icons/obj/items.dmi'
	icon_state = "net"
	item_state = "net"
	description_info = "This object can be used to capture certain creatures easily, most commonly fish. \
	It has a reach of two tiles, and can be emptied by activating it in-hand. \
	This version will not keep creatures inside in stasis, and will be heavier if it contains a mob."

	var/empty_state = "net"
	var/contain_state = "net_full"

	w_class = ITEMSIZE_SMALL
	flags = NOBLUDGEON

	slowdown = 0.5

	reach = 2

	default_material = MAT_CLOTH

	var/list/accepted_mobs = list(/mob/living/simple_mob/animal/passive/fish)

/obj/item/material/fishing_net/Initialize(mapload)
	. = ..()
	update_icon()

/obj/item/material/fishing_net/afterattack(var/atom/A, var/mob/user, var/proximity)
	if(get_dist(get_turf(src), A) > reach)
		return

	if(istype(A, /turf))
		var/mob/living/Target
		for(var/type in accepted_mobs)
			Target = locate(type) in A.contents
			if(Target)
				afterattack(Target, user, proximity)
				break

	if(istype(A, /mob))
		var/accept = FALSE
		for(var/D in accepted_mobs)
			if(istype(A, D))
				accept = TRUE
		for(var/atom/At in src.contents)
			if(isliving(At))
				to_chat(user, span_notice("Your net is already holding something!"))
				accept = FALSE
		if(!accept)
			to_chat(user, span_filter_notice("[A] can't be trapped in \the [src]."))
			return
		var/mob/L = A
		user.visible_message(span_notice("[user] snatches [L] with \the [src]."), span_notice("You snatch [L] with \the [src]."))
		L.forceMove(src)
		update_icon()
		update_weight()
		return
	return ..()

/obj/item/material/fishing_net/attack_self(var/mob/user)
	for(var/mob/M in src)
		M.forceMove(get_turf(src))
		user.visible_message(span_notice("[user] releases [M] from \the [src]."), span_notice("You release [M] from \the [src]."))
	for(var/obj/item/I in src)
		I.forceMove(get_turf(src))
		user.visible_message(span_notice("[user] dumps \the [I] out of \the [src]."), span_notice("You dump \the [I] out of \the [src]."))
	update_icon()
	update_weight()
	return

/obj/item/material/fishing_net/attackby(var/obj/item/W, var/mob/user)
	if(contents)
		for(var/mob/living/L in contents)
			if(prob(25))
				L.attackby(W, user)
	..()

/obj/item/material/fishing_net/update_icon() // Also updates name and desc
	underlays.Cut()
	cut_overlays()

	..()

	name = initial(name)
	desc = initial(desc)
	var/contains_mob = FALSE
	for(var/mob/M in src)
		var/image/victim = image(M.icon, M.icon_state)
		underlays += victim
		name = "filled net"
		desc = "A net with [M] inside."
		contains_mob = TRUE

	if(contains_mob)
		icon_state = contain_state

	else
		icon_state = empty_state

	return

/obj/item/material/fishing_net/proc/update_weight()
	if(icon_state == contain_state)	// Let's not do a for loop just to see if a mob is in here.
		slowdown = initial(slowdown) * 2
		reach = 1
	else
		slowdown = initial(slowdown)
		reach = initial(reach)

/obj/item/material/fishing_net/butterfly_net
	name = "butterfly net"
	desc = "A butterfly net, it can be used to catch small critters, such as butterflies, but perhaps also friends?"
	icon = 'icons/obj/items.dmi'
	icon_state = "butterfly_net"
	item_state = "butterfly_net"
	description_info = "This object can be used to capture certain creatures easily, most commonly butterflies. \
	It can be emptied by activating it in-hand."

	empty_state = "butterfly_net"
	contain_state = "butterfly_net_full"

	w_class = ITEMSIZE_SMALL
	flags = NOBLUDGEON

	reach = 1

	default_material = MAT_CLOTH

	accepted_mobs = list(/mob/living/simple_mob/animal/sif/glitterfly, /mob/living/carbon/human)

/obj/item/material/fishing_net/butterfly_net/afterattack(var/atom/A, var/mob/user, var/proximity)
	if(get_dist(get_turf(src), A) > reach)
		return

	if(istype(A, /turf))
		var/mob/living/Target
		for(var/type in accepted_mobs)
			Target = locate(type) in A.contents
			if(Target)
				afterattack(Target, user, proximity)
				break

	if(istype(A, /mob))
		var/accept = FALSE
		for(var/D in accepted_mobs)
			if(istype(A, D))
				var/mob/M = A
				if(ishuman(M) && M.size_multiplier > 0.5)
					accept = FALSE
				else if(A == user)
					accept = FALSE
				else
					accept = TRUE
		for(var/atom/At in src.contents)
			if(isliving(At))
				to_chat(user, span_notice("Your net is already holding something!"))
				accept = FALSE
		if(!accept)
			to_chat(user, span_filter_notice("[A] can't be trapped in \the [src]."))
			return
		var/mob/L = A
		user.visible_message(span_notice("[user] snatches [L] with \the [src]."), span_notice("You snatch [L] with \the [src]."))
		L.forceMove(src)
		playsound(src, 'sound/effects/plop.ogg', 50, 1)
		update_icon()
		update_weight()
		return
	return ..()

/obj/item/material/fishing_net/butterfly_net/attack_self(var/mob/user)
	for(var/mob/living/M in src)
		if(!user.get_inactive_hand()) //Check if the inactive hand is empty
			M.forceMove(get_turf(src))
			M.attempt_to_scoop(user)
			user.visible_message(span_notice("[user] scoops [M] out from \the [src]."), span_notice("You pull [M] from \the [src]."))
		else
			M.forceMove(get_turf(src))
			user.visible_message(span_notice("[user] releases [M] from \the [src]."), span_notice("You release [M] from \the [src]."))
	for(var/obj/item/I in src)
		I.forceMove(get_turf(src))
		user.visible_message(span_notice("[user] dumps \the [I] out of \the [src]."), span_notice("You dump \the [I] out of \the [src]."))
	update_icon()
	update_weight()
	return

/obj/item/material/fishing_net/butterfly_net/container_resist(mob/living/M)
	if(prob(20))
		M.forceMove(get_turf(src))
		to_chat(M, span_warning("You climb out of \the [src]."))
		update_icon()
		update_weight()
	else
		to_chat(M, span_warning("You fail to escape \the [src]."))

/obj/item/material/fishing_net/butterfly_net/update_icon() // Also updates name and desc
	underlays.Cut()
	cut_overlays()

	name = initial(name)
	desc = initial(desc)
	var/contains_mob = FALSE
	for(var/mob/M in src)
		name = "filled butterfly net"
		desc = "A net with [M] inside."
		contains_mob = TRUE

	if(contains_mob)
		icon_state = contain_state

	else
		icon_state = empty_state

	return

/datum/crafting_recipe/butterfly_net
	name = "butterfly net"
	result = /obj/item/material/fishing_net/butterfly_net
	reqs = list(
		list(/obj/item/stack/material/cloth = 2)
	)
	time = 20
	category = CAT_MISC
