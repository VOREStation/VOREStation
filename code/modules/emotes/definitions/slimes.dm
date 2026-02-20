/datum/decl/emote/slime
	key = "nomood"
	var/mood

/datum/decl/emote/slime/do_extra(var/mob/living/simple_mob/slime/user)
	. = ..()
	if(istype(user))
		user.mood = mood
		user.update_icon()

/datum/decl/emote/slime/mob_can_use(var/atom/user)
	return ..() && isslime(user)

/datum/decl/emote/slime/pout
	key = "mpout"
	mood = "pout"

/datum/decl/emote/slime/sad
	key = "msad"
	mood = "sad"

/datum/decl/emote/slime/angry
	key = "mangry"
	mood = "angry"

/datum/decl/emote/slime/frown
	key = "mfrown"
	mood = "mischevous"

/datum/decl/emote/slime/smile
	key = "msmile"
	mood = ":3"
