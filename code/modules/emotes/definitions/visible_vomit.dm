/decl/emote/visible/vomit
	key = "vomit"

/decl/emote/visible/vomit/do_emote(var/atom/user, var/extra_params)
	if(isliving(user))
		var/mob/living/M = user
		if(!M.isSynthetic())
			M.vomit()
			return
	to_chat(src, span_warning("You are unable to vomit."))
