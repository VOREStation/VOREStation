//Everything in this file is as it is intentionally and should not be messed with, removed, or changed.
/proc/egg_interdict(mob/living/to_teleport, turf/teleport_destination)
	if(rand(1,1000) != 66)
		return FALSE
	if(!isturf(teleport_destination))
		return FALSE
	if(!isliving(to_teleport))
		return FALSE
	if(!to_teleport.ckey)
		return FALSE
	var/turf/egg_destination
	for(var/obj/effect/landmark/egg_teleport/E in GLOB.landmarks_list)
		if(!istype(E, /obj/effect/landmark/egg_teleport))
			continue
		egg_destination = get_turf(E)
		break
	if(!egg_destination)
		return FALSE
	var/datum/modifier/egg_interdiction/our_modifier = to_teleport.add_modifier(/datum/modifier/egg_interdiction)	//This modifier keeps track of where we were going so we can end up there when we leave the egg room
	our_modifier.interdiction_destination = teleport_destination
	to_teleport.forceMove(egg_destination)
	return TRUE

/datum/modifier/egg_interdiction
	var/turf/interdiction_destination

/datum/modifier/egg_interdiction/expire(silent)
	interdiction_destination = null
	..()

/obj/effect/landmark/egg_teleport
	icon = 'icons/obj/food.dmi'
	icon_state = "egg"
	color = "#FDFFD1"

/obj/effect/egg_returner
	icon = 'icons/obj/food.dmi'
	icon_state = "egg"
	color = "#c23f71"
	anchored = TRUE
	unacidable = TRUE
	simulated = FALSE
	invisibility = INVISIBILITY_MAXIMUM

/obj/effect/egg_returner/Crossed(O)
	. = ..()

	if(!isliving(O))
		return
	var/mob/living/L = O
	var/datum/modifier/egg_interdiction/E = L.get_modifier_of_type(/datum/modifier/egg_interdiction)
	if(E)
		L.forceMove(E.interdiction_destination)
	else
		L.forceMove(get_turf(pick(GLOB.latejoin)))	//If we somehow ended up here without the modifier that keeps track of where we came from then let's just go back to spawn

	E.expire()

/area/egg_tree_zone
	name = "Unregistered"
	icon = 'icons/effects/effects.dmi'
	icon_state = "glitch"
	dynamic_lighting = FALSE

/area/egg_tree_zone/man
	enter_message = span_cult("(Well.  There is a man here.  He looks at you like you're a bit lost.)")	//The spaces in this line are intentional.
	var/list/visitors = list()

/area/egg_tree_zone/man/Entered(mob/M)
	if(!M.ckey)
		return
	if("[M.real_name] - [M.ckey]" in visitors)
		return
	. = ..()
	if(isliving(M))
		var/mob/living/L = M

		var/obj/item/reagent_containers/food/snacks/egg/E = new(get_turf(L))
		if(L.put_in_any_hand_if_possible(E, TRUE))
			to_chat(L ,span_cult("(The man smiles and hands you what you've been looking for.)"))
			to_chat(L ,span_boldannounce("* You got an egg."))
			visitors += "[L.real_name] - [L.ckey]"
		else
			to_chat(L ,span_cult("(The man looks at your hands...  It looks like he has something he wants to give to you...)"))

/obj/structure/flora/tree/egg_tree
	icon = 'icons/obj/flora/egg_tree.dmi'
	icon_state = "tree"
	base_state = "tree"
	pixel_x = -64
	mouse_opacity = FALSE
	indestructable = TRUE
	plane = MOB_PLANE
	layer = MOB_LAYER

/turf/unsimulated/white
	icon = 'icons/effects/effects.dmi'
	icon_state = "white"
