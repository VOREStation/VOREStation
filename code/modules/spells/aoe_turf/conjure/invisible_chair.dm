/datum/spell/aoe_turf/conjure/invisible_chair
	name = "Invisible chair"
	desc = "The mime's performance transmutates a chair into physical reality."
	invocation_type = SpI_EMOTE
	invocation = "pulls out an invisible chair and sits down."
	charge_max = 30 SECONDS
	cast_sound = null
	duration = 25 SECONDS
	override_base = "grey"
	hud_state = "chair"
	school = "mime"

/datum/spell/aoe_turf/conjure/invisible_chair/cast(list/targets, mob/user)
	if(!HAS_MIND_TRAIT(user, TRAIT_MIMING))
		to_chat(user, "Your performance is not good enough!")
		return

	var/obj/structure/bed/chair/mime/chair = new /obj/structure/bed/chair/mime(get_turf(user))
	chair.set_dir(user.dir)
	chair.buckle_mob(user)

	if(duration)
		QDEL_IN(chair, duration)
