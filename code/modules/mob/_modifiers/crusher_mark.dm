/datum/modifier/crusher_mark
    name = "destabilized"
    desc = "You've been struck by a destabilizing bolt. By all accounts, this is probably a bad thing."
    stacks = MODIFIER_STACK_EXTEND
    on_created_text = "<span class='warning'>You feel physically unstable.</span>"
    on_expired_text = "<span class='notice'>You feel physically stable again.</span>"
    var/mutable_appearance/marked_underlay
    var/obj/item/kinetic_crusher/hammer_synced

/datum/modifier/crusher_mark/New(var/new_holder, var/new_origin)
    . = ..()
    if(isliving(new_origin))
        var/mob/living/origin = new_origin
        var/obj/item/kinetic_crusher/to_sync
        if(istype(origin.get_active_hand(), /obj/item/kinetic_crusher))
            to_sync = origin.get_active_hand()
        else if (istype(origin.get_inactive_hand(), /obj/item/kinetic_crusher))
            to_sync = origin.get_inactive_hand()
        if(to_sync) // did we find it?
            hammer_synced = to_sync // go ahead
        if(hammer_synced? hammer_synced.can_mark(holder) : TRUE)
            marked_underlay = mutable_appearance('icons/effects/effects.dmi', "shield2")
            marked_underlay.pixel_x = -holder.pixel_x
            marked_underlay.pixel_y = -holder.pixel_y
            holder.underlays += marked_underlay
        else
            Destroy()

/datum/modifier/crusher_mark/Destroy()
	hammer_synced = null
	if(holder)
		holder.underlays -= marked_underlay
	QDEL_NULL(marked_underlay)
	return ..()

/datum/modifier/crusher_mark/on_expire()
	holder.underlays -= marked_underlay //if this is being called, we should have a holder at this point.
	..()