/datum/spell/aoe_turf/conjure/invisible_box
	name = "Invisible box"
	desc = "The mime's performance transmutates a box into physical reality."
	cast_sound = null
	charge_max = 30 SECONDS
	duration = 50 SECONDS
	charge_max = 300
	override_base = "grey"
	hud_state = "box"
	school = "mime"

/datum/spell/aoe_turf/conjure/invisible_box/cast(list/targets, mob/user)
	if(!HAS_MIND_TRAIT(user, TRAIT_MIMING))
		to_chat(user, "Your performance is not good enough!")
		return

	var/obj/item/storage/box/mime/mimebox = new /obj/item/storage/box/mime(get_turf(user))
	user.put_in_any_hand_if_possible(mimebox)
	mimebox.alpha = 255
	addtimer(CALLBACK(src, PROC_REF(cleanup_box), mimebox), duration)

/datum/spell/aoe_turf/conjure/invisible_box/proc/cleanup_box(obj/item/storage/box/box)
	if(QDELETED(box) || !istype(box))
		return

	for(var/obj/thing in box)
		thing.forceMove(get_turf(thing))
	qdel(box)
