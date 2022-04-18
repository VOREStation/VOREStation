/obj/item/multitool/hacktool
	var/is_hacking = 0
	var/max_known_targets

	var/in_hack_mode = 0
	var/list/known_targets
	var/list/supported_types
	var/datum/tgui_state/default/must_hack/hack_state

<<<<<<< HEAD
/obj/item/device/multitool/hacktool/New()
	..()
=======
/obj/item/multitool/hacktool/Initialize()
	. = ..()
>>>>>>> 61084723c7b... Merge pull request #8317 from Atermonera/remove_weapon
	known_targets = list()
	max_known_targets = 5 + rand(1,3)
	supported_types = list(/obj/machinery/door/airlock)
	hack_state = new(src)

<<<<<<< HEAD
/obj/item/device/multitool/hacktool/Destroy()
	for(var/atom/target as anything in known_targets)
=======
/obj/item/multitool/hacktool/Destroy()
	for(var/T in known_targets)
		var/atom/target = T
>>>>>>> 61084723c7b... Merge pull request #8317 from Atermonera/remove_weapon
		target.unregister(OBSERVER_EVENT_DESTROY, src)
	known_targets.Cut()
	qdel(hack_state)
	hack_state = null
	return ..()

/obj/item/multitool/hacktool/attackby(var/obj/item/W, var/mob/user)
	if(W.is_screwdriver())
		in_hack_mode = !in_hack_mode
		playsound(src, W.usesound, 50, 1)
	else
		..()

/obj/item/multitool/hacktool/afterattack(atom/A, mob/user)
	sanity_check()

	if(!in_hack_mode)
		return ..()

	if(!attempt_hack(user, A))
		return 0

	// Note, if you ever want to expand supported_types, you must manually add the custom state argument to their tgui_interact
	A.tgui_interact(user, custom_state = hack_state)
	return 1

/obj/item/multitool/hacktool/proc/attempt_hack(var/mob/user, var/atom/target)
	if(is_hacking)
		to_chat(user, "<span class='warning'>You are already hacking!</span>")
		return 0
	if(!is_type_in_list(target, supported_types))
		to_chat(user, "[bicon(src)] <span class='warning'>Unable to hack this target!</span>")
		return 0
	var/found = known_targets.Find(target)
	if(found)
		known_targets.Swap(1, found)	// Move the last hacked item first
		return 1

	to_chat(user, "<span class='notice'>You begin hacking \the [target]...</span>")
	is_hacking = 1
	// On average hackin takes ~30 seconds. Fairly small random span to avoid people simply aborting and trying again
	var/hack_result = do_after(user, (20 SECONDS + rand(0, 10 SECONDS) + rand(0, 10 SECONDS)))
	is_hacking = 0

	if(hack_result && in_hack_mode)
		to_chat(user, "<span class='notice'>Your hacking attempt was succesful!</span>")
		user.playsound_local(get_turf(src), 'sound/instruments/piano/An6.ogg', 50)
	else
		to_chat(user, "<span class='warning'>Your hacking attempt failed!</span>")
		return 0

	known_targets.Insert(1, target)	// Insert the newly hacked target first,
	target.register(OBSERVER_EVENT_DESTROY, src, /obj/item/multitool/hacktool/proc/on_target_destroy)
	return 1

/obj/item/multitool/hacktool/proc/sanity_check()
	if(max_known_targets < 1) max_known_targets = 1
	// Cut away the oldest items if the capacity has been reached
	if(known_targets.len > max_known_targets)
		for(var/i = (max_known_targets + 1) to known_targets.len)
			var/atom/A = known_targets[i]
			A.unregister(OBSERVER_EVENT_DESTROY, src)
		known_targets.Cut(max_known_targets + 1)

/obj/item/multitool/hacktool/proc/on_target_destroy(var/target)
	known_targets -= target

<<<<<<< HEAD
/datum/tgui_state/default/must_hack
	var/obj/item/device/multitool/hacktool/hacktool
=======
/datum/topic_state/default/must_hack
	var/obj/item/multitool/hacktool/hacktool
>>>>>>> 61084723c7b... Merge pull request #8317 from Atermonera/remove_weapon

/datum/tgui_state/default/must_hack/New(var/hacktool)
	src.hacktool = hacktool
	..()

/datum/tgui_state/default/must_hack/Destroy()
	hacktool = null
	return ..()

/datum/tgui_state/default/must_hack/can_use_topic(src_object, mob/user)
	if(!hacktool || !hacktool.in_hack_mode || !(src_object in hacktool.known_targets))
		return STATUS_CLOSE
	return ..()
