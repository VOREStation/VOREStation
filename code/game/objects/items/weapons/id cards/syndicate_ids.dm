/obj/item/card/id/syndicate
	name = "agent card"
	icon_state = "generic-s"
	assignment = "Agent"
	origin_tech = list(TECH_ILLEGAL = 3)
	var/electronic_warfare = 1
	var/mob/registered_user = null

	var/datum/tgui_module/agentcard/agentcard_module

/obj/item/card/id/syndicate/Initialize()
	. = ..()
	agentcard_module = new(src)
	access = syndicate_access.Copy()

/obj/item/card/id/syndicate/station_access/Initialize()
	. = ..() // Same as the normal Syndicate id, only already has all station access
	access |= get_all_station_access()

/obj/item/card/id/syndicate/Destroy()
	QDEL_NULL(agentcard_module)
	unset_registered_user(registered_user)
	return ..()

/obj/item/card/id/syndicate/prevent_tracking()
	return electronic_warfare

/obj/item/card/id/syndicate/afterattack(var/obj/item/O as obj, mob/user as mob, proximity)
	if(!proximity) return
	if(istype(O, /obj/item/card/id))
		var/obj/item/card/id/I = O
		src.access |= I.GetAccess()
		if(player_is_antag(user.mind) || registered_user == user)
			to_chat(user, span_notice("The microscanner activates as you pass it over the ID, copying its access."))

/obj/item/card/id/syndicate/attack_self(mob/user as mob)
	// We use the fact that registered_name is not unset should the owner be vaporized, to ensure the id doesn't magically become unlocked.
	if(!registered_user && register_user(user))
		to_chat(user, span_notice("The microscanner marks you as its owner, preventing others from accessing its internals."))
	if(registered_user == user)
		switch(tgui_alert(usr, "Would you like to edit the ID, or show it?","Show or Edit?", list("Edit","Show")))
			if(null)
				return
			if("Edit")
				agentcard_module.tgui_interact(user)
			if("Show")
				..()
	else
		..()


/obj/item/card/id/syndicate/proc/register_user(var/mob/user)
	if(!istype(user) || user == registered_user)
		return FALSE
	unset_registered_user()
	registered_user = user
	user.set_id_info(src)
	user.register(OBSERVER_EVENT_DESTROY, src, /obj/item/card/id/syndicate/proc/unset_registered_user)
	return TRUE

/obj/item/card/id/syndicate/proc/unset_registered_user(var/mob/user)
	if(!registered_user || (user && user != registered_user))
		return
	registered_user.unregister(OBSERVER_EVENT_DESTROY, src)
	registered_user = null

/var/global/list/id_card_states
/proc/id_card_states()
	if(!id_card_states)
		id_card_states = list()
		for(var/path in typesof(/obj/item/card/id))
			var/obj/item/card/id/ID = new path()
			var/datum/card_state/CS = new()
			CS.icon_state = initial(ID.icon_state)
			CS.item_state = initial(ID.item_state)
			CS.sprite_stack = ID.initial_sprite_stack
			CS.name = initial(ID.name)
			id_card_states += CS
		id_card_states = dd_sortedObjectList(id_card_states)

	return id_card_states

/datum/card_state
	var/name
	var/icon_state
	var/item_state
	var/sprite_stack

/datum/card_state/dd_SortValue()
	return name

/obj/item/card/id/syndicate_command
	name = "operative ID card"
	desc = "An ID straight from a mercenary organisation."
	registered_name = "Operative"
	assignment = "Operative Commander"
	icon_state = "syndicate-id"
	access = list(access_syndicate, access_external_airlocks)
