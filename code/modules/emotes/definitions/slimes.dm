/decl/emote/slime
	key = "nomood"
	var/mood

/decl/emote/slime/do_extra(var/mob/living/simple_mob/slime/user)
	. = ..()
	if(istype(user))
		user.mood = mood
		user.update_icon()

/decl/emote/slime/mob_can_use(var/atom/user)
	return ..() && isslime(user)

/decl/emote/slime/pout
	key = "mpout"
	mood = "pout"

/decl/emote/slime/sad
	key = "msad"
	mood = "sad"

/decl/emote/slime/angry
	key = "mangry"
	mood = "angry"

/decl/emote/slime/frown
	key = "mfrown"
	mood = "mischevous"

/decl/emote/slime/smile
	key = "msmile"
	mood = ":3"
