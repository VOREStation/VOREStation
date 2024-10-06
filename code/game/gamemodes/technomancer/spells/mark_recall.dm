/datum/technomancer/spell/mark
	name = "Mark"
	desc = "This function places a specific 'mark' beacon under you, which is used by the Recall function as a destination.  \
	Note that using Mark again will move the destination instead of creating a second destination, and only one destination \
	can exist, regardless of who casted Mark."
	cost = 25
	obj_path = /obj/item/spell/mark
	ability_icon_state = "tech_mark"
	category = UTILITY_SPELLS
//VOREStation Add - Multiple technomancer support
/datum/technomancer_marker
	var/datum/weakref/U
	var/image/I
	var/turf/T

/datum/technomancer_marker/New(var/mob/user)
	U = WEAKREF(user)
	T = get_turf(user)
	I = image('icons/goonstation/featherzone.dmi', T, "spawn-wall")
	I.plane = TURF_PLANE
	I.layer = ABOVE_TURF_LAYER
	user.client?.images |= I
	spawn(23) //That's just how long the animation is
		I.icon_state = "spawn-wall-loop"

/datum/technomancer_marker/Destroy()
	var/mob/user = U?.resolve()
	user?.client?.images -= I
	I?.loc = null
	U = T = I = null
	return ..()

//This is global, to avoid looping through a list of all objects, or god forbid, looping through world.
GLOBAL_LIST_INIT(mark_spells, list())
//VOREStation Add End
/obj/item/spell/mark
	name = "mark"
	icon_state = "mark"
	desc = "Marks a specific location to be used by Recall."
	cast_methods = CAST_USE
	aspect = ASPECT_TELE

/obj/item/spell/mark/on_use_cast(var/mob/living/user)
	if(!allowed_to_teleport()) // Otherwise you could teleport back to the admin Z-level.
		to_chat(user, span_warning("You can't teleport here!"))
		return 0
	if(pay_energy(1000))
		//VOREStation Add - Multiple technomancer support
		var/datum/technomancer_marker/marker = GLOB.mark_spells[WEAKREF(user)]
		//They have one in the list
		if(istype(marker))
			qdel(marker)
			to_chat(user, span_notice("Your mark is moved from its old position to \the [get_turf(user)] under you."))
		//They don't have one yet
		else
			to_chat(user, span_notice("You mark \the [get_turf(user)] under you."))
		GLOB.mark_spells[WEAKREF(user)] = new /datum/technomancer_marker(user)
		//VOREStation Add End
		adjust_instability(5)
		return 1
	else
		to_chat(user, span_warning("You can't afford the energy cost!"))
		return 0

//Recall

/datum/technomancer/spell/recall
	name = "Recall"
	desc = "This function teleports you to where you placed a mark using the Mark function.  Without the Mark function, this \
	function is useless.  Note that teleporting takes three seconds.  Being incapacitated while teleporting will cancel it."
	enhancement_desc = "Recall takes two seconds instead of three."
	cost = 25
	obj_path = /obj/item/spell/recall
	ability_icon_state = "tech_recall"
	category = UTILITY_SPELLS

/obj/item/spell/recall
	name = "recall"
	icon_state = "recall"
	desc = "This will bring you to your Mark."
	cast_methods = CAST_USE
	aspect = ASPECT_TELE

/obj/item/spell/recall/on_use_cast(var/mob/living/user)
	if(pay_energy(3000))
		var/datum/technomancer_marker/marker = GLOB.mark_spells[WEAKREF(user)] //VOREStation Add - Multiple technomancer support
		if(!istype(marker))
			to_chat(user, span_danger("There's no Mark!"))
			return 0
		else
			if(!allowed_to_teleport())
				to_chat(user, span_warning("Teleportation doesn't seem to work here."))
				return
			visible_message(span_warning("\The [user] starts glowing!"))
			var/light_intensity = 2
			var/time_left = 3
			if(check_for_scepter())
				time_left = 2
			while(time_left)
				if(user.incapacitated())
					visible_message(span_notice("\The [user]'s glow fades."))
					to_chat(user, span_danger("You cannot Recall while incapacitated!"))
					return 0
				light_intensity++
				set_light(light_intensity, light_intensity, l_color = "#006AFF")
				time_left--
				sleep(1 SECOND)

			var/turf/target_turf = marker.T //VOREStation Edit - Multiple technomancer support
			var/turf/old_turf = get_turf(user)

			for(var/obj/item/grab/G in user.contents) // People the Technomancer is grabbing come along for the ride.
				if(G.affecting)
					G.affecting.forceMove(locate( target_turf.x+rand(-1,1), target_turf.y+rand(-1,1), target_turf.z))
					to_chat(G.affecting, span_warning("You are teleported along with [user]!"))

			user.forceMove(target_turf)
			to_chat(user, span_notice("You are teleported to your Mark."))

			playsound(target_turf, 'sound/effects/phasein.ogg', 25, 1)
			playsound(target_turf, 'sound/effects/sparks2.ogg', 50, 1)

			playsound(old_turf, 'sound/effects/sparks2.ogg', 50, 1)

			adjust_instability(25)
			qdel(src)
			return 1
	else
		to_chat(user, span_warning("You can't afford the energy cost!"))
		return 0
