/datum/nano_module/program/ship
	var/obj/effect/overmap/visitable/ship/linked
	var/list/viewers
	var/extra_view = 0

/datum/nano_module/program/ship/New()
	..()
	sync_linked()
	if(linked)
		name = "[linked.name] [name]"

/datum/nano_module/program/ship/Destroy()
	if(LAZYLEN(viewers))
		for(var/weakref/W in viewers)
			var/M = W.resolve()
			if(M)
				unlook(M)
	. = ..()

/datum/nano_module/program/ship/proc/sync_linked()
	var/obj/effect/overmap/visitable/ship/sector = get_overmap_sector(get_z(nano_host()))
	if(!sector)
		return
	return attempt_hook_up_recursive(sector)

/datum/nano_module/program/ship/proc/attempt_hook_up_recursive(obj/effect/overmap/visitable/ship/sector)
	if(attempt_hook_up(sector))
		return sector
	for(var/obj/effect/overmap/visitable/ship/candidate in sector)
		if((. = .(candidate)))
			return

/datum/nano_module/program/ship/proc/attempt_hook_up(obj/effect/overmap/visitable/ship/sector)
	if(!istype(sector))
		return
	if(sector.check_ownership(nano_host()))
		linked = sector
		return 1

/datum/nano_module/program/ship/proc/look(var/mob/user)
	if(linked)
		user.machine = nano_host()
		user.reset_view(linked)
	user.set_viewsize(world.view + extra_view)
	GLOB.moved_event.register(user, src, /datum/nano_module/program/ship/proc/unlook)
	LAZYDISTINCTADD(viewers, weakref(user))

/datum/nano_module/program/ship/proc/unlook(var/mob/user)
	user.reset_view()
	user.set_viewsize() // reset to default
	GLOB.moved_event.unregister(user, src, /datum/nano_module/program/ship/proc/unlook)
	LAZYREMOVE(viewers, weakref(user))

/datum/nano_module/program/ship/proc/viewing_overmap(mob/user)
	return (weakref(user) in viewers)

/datum/nano_module/program/ship/proc/DefaultTopicState()
	return global.default_state

/datum/nano_module/program/ship/Topic(var/href, var/href_list = list(), var/datum/topic_state/state)
	if((. = ..()))
		return
	state = state || DefaultTopicState() || global.default_state
	if(CanUseTopic(usr, state, href_list) == STATUS_INTERACTIVE)
		CouldUseTopic(usr)
		return OnTopic(usr, href_list, state)
	CouldNotUseTopic(usr)
	return TRUE

/datum/nano_module/program/ship/proc/OnTopic(var/mob/user, var/href_list, var/datum/topic_state/state)
	return TOPIC_NOACTION

/datum/nano_module/program/ship/proc/CouldNotUseTopic(mob/user)
	. = ..()
	unlook(user)

/datum/nano_module/program/ship/proc/CouldUseTopic(mob/user)
	. = ..()
	if(viewing_overmap(user))
		look(user)

/datum/nano_module/program/ship/check_eye(var/mob/user)
	if (!get_dist(user, nano_host()) > 1 || user.blinded || !linked )
		unlook(user)
		return -1
	else
		return 0