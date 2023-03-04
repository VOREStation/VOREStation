/obj/item/mine/assembly
	name = "mine assembly"
	desc = "A small pressure-triggered device. Accepts grenades and tank transfer valves."

	payload = null

	var/static/list/accepts_items = list(
		/obj/item/transfer_valve = /datum/mine_payload/assembly/tank_transfer_valve,
		/obj/item/grenade        = /datum/mine_payload/assembly/grenade
	)

/obj/item/mine/assembly/attackby(obj/item/W, mob/living/user)
	if(!armed && !triggering)
		var/datum/mine_payload/assembly/attached_payload = payload
		if(attached_payload?.attached)
			if(W.is_screwdriver())
				to_chat(user, "You disconnect \the [src]'s [attached_payload.attached.name] and remove it.")
				attached_payload.attached.forceMove(get_turf(user))
				payload.remove_from_mine()
				QDEL_NULL(payload)
		else
			for(var/loadtype in accepts_items)
				if(istype(W, loadtype))
					user.drop_from_inventory(W)
					W.forceMove(src)
					var/payload_type = accepts_items[loadtype]
					attached_payload = new payload_type
					attached_payload.attached = W
					payload = attached_payload
					return TRUE
	return ..()

/datum/mine_payload/assembly
	var/obj/item/attached

/datum/mine_payload/assembly/New(var/obj/item/_attaching)
	..()
	attached = _attaching

/datum/mine_payload/assembly/Destroy()
	QDEL_NULL(attached)
	. = ..()

/datum/mine_payload/assembly/remove_from_mine()
	attached = null

/datum/mine_payload/assembly/tank_transfer_valve/trigger_payload(var/obj/item/mine/owner, var/atom/trigger)
	..()
	if(istype(attached, /obj/item/transfer_valve))
		var/obj/item/transfer_valve/ttv = attached
		ttv.forceMove(get_turf(owner))
		ttv.toggle_valve()
		remove_from_mine()

/datum/mine_payload/assembly/grenade/trigger_payload(var/obj/item/mine/owner, var/atom/trigger)
	..()
	if(istype(attached, /obj/item/grenade))
		var/obj/item/grenade/grenade = attached
		grenade.forceMove(get_turf(owner))
		if(ismob(trigger))
			var/mob/victim = trigger
			if(victim.ckey)
				msg_admin_attack("[key_name_admin(victim)] stepped on \a [owner], triggering [grenade]")
		grenade.activate()
		remove_from_mine()
