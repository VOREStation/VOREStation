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
	key = "pout"
	mood = "pout"

/decl/emote/slime/sad
	key = "sad"
	mood = "sad"

/decl/emote/slime/angry
	key = "angry"
	mood = "angry"

/decl/emote/slime/frown
	key = "frown"
	mood = "mischevous"

/decl/emote/slime/smile
	key = "smile"
	mood = ":3"
