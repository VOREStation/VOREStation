/obj/structure/morgue/crematorium/vr
	var/list/allowed_items = list(/obj/item/organ,
			/obj/item/implant,
			/obj/item/material/shard/shrapnel,
			/mob/living)


/obj/structure/morgue/crematorium/vr/cremate(atom/A, mob/user as mob)
	if(cremating)
		return //don't let you cremate something twice or w/e

	if(contents.len <= 0)
		for (var/mob/M in viewers(src))
			M.show_message(span_warning("You hear a hollow crackle."), 1)
			return
	else
		if(!isemptylist(src.search_contents_for(/obj/item/disk/nuclear)))
			to_chat(usr, "You get the feeling that you shouldn't cremate one of the items in the cremator.")
			return

		for(var/I in contents)
			if(!(I in allowed_items))
				to_chat(user, span_notice("\The [src] cannot cremate while there are items inside!"))
				return
			if(istype(I, /mob/living))
				var/mob/living/cremated = I
				for(var/Z in cremated.contents)
					if(!(Z in allowed_items))
						to_chat(user, span_notice("\The [src] cannot cremate while there are items inside!"))
						return

		for (var/mob/M in viewers(src))
			M.show_message(span_warning("You hear a roar as the crematorium activates."), 1)

		cremating = 1
		locked = 1

		for(var/mob/living/M in contents)
			if (M.stat!=2)
				if (!iscarbon(M))
					M.emote("scream")
				else
					var/mob/living/carbon/C = M
					if (C.can_feel_pain())
						C.emote("scream")

			M.death(1)
			M.ghostize()
			qdel(M)

		for(var/obj/O in contents) //obj instead of obj/item so that bodybags and ashes get destroyed. We dont want tons and tons of ash piling up
			qdel(O)

		new /obj/effect/decal/cleanable/ash(src)
		sleep(30)
		cremating = 0
		locked = 0
		playsound(src, 'sound/machines/ding.ogg', 50, 1)
	return
