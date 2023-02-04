/decl/emote/slime
	key = "nomood"
	var/mood

/decl/emote/slime/do_extra(mob/user, atom/target)
	. = ..()
	if(istype(user, /mob/living/simple_mob/slime))
		var/mob/living/simple_mob/slime/user_slime = user
		user_slime.mood = mood
		user_slime.update_icon()

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
