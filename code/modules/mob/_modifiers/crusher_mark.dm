/datum/modifier/crusher_mark
    name = "destabilized"
    desc = "You've been struck by a destabilizing bolt. By all accounts, this is probably a bad thing."
    stacks = MODIFIER_STACK_EXTEND
    on_created_text = "You feel destabilized."
    on_expired_text = "You feel stable again."
    var/mutable_appearance/marked_underlay
    var/obj/item/weapon/kinetic_crusher/hammer_synced

/*
/datum/modifier/New(var/new_holder, var/new_origin)
	holder = new_holder
	if(new_origin)
		origin = weakref(new_origin)
	else // We assume the holder caused the modifier if not told otherwise.
		origin = weakref(holder)
	..()
/mob/living/proc/add_modifier(var/modifier_type, var/expire_at = null, var/mob/living/origin = null, var/suppress_failure = FALSE)
*/

/datum/modifier/crusher_mark/New(var/new_holder, var/new_origin)
    . = ..()
    if(isliving(new_origin))
        var/mob/living/origin = new_origin
        var/obj/item/weapon/kinetic_crusher/to_sync = locate(/obj/item/weapon/kinetic_crusher) in origin
        if(to_sync)
            hammer_synced = to_sync
        if(hammer_synced? hammer_synced.can_mark(holder) : TRUE)
            marked_underlay = mutable_appearance('icons/effects/effects.dmi', "shield2")
            marked_underlay.pixel_x = -holder.pixel_x
            marked_underlay.pixel_y = -holder.pixel_y
            holder.underlays += marked_underlay

/datum/modifier/crusher_mark/Destroy()
	hammer_synced = null
	if(holder)
		holder.underlays -= marked_underlay
	QDEL_NULL(marked_underlay)
	return ..()

/datum/modifier/crusher_mark/on_expire()
	holder.underlays -= marked_underlay //if this is being called, we should have a holder at this point.
	..()