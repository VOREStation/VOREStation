/obj/item/weapon/spell/aspect
	name = "aspect template"
	desc = "Combine this with another spell to finish the function."
	cast_methods = CAST_COMBINE
	aspect = ASPECT_CHROMATIC
	var/fire_result = null
	var/frost_result = null
	var/shock_result = null
	var/air_result = null
	var/force_result = null
	var/tele_result = null
	var/biomed_result = null
	var/dark_result = null
	var/light_result = null
	var/unstable_result = null

/obj/item/weapon/spell/aspect/on_combine_cast(obj/item/W, mob/user)
	if(istype(W, /obj/item/weapon/spell))
		var/obj/item/weapon/spell/spell = W
		if(!spell.aspect || spell.aspect == ASPECT_CHROMATIC)
			user << "<span class='warning'>You cannot combine \the [spell] with \the [src], as the aspects are incompatable.</span>"
			return
		user.drop_item(src)
		src.loc = null
		switch(spell.aspect)
			if(ASPECT_FIRE)
				user.put_in_hands(fire_result)
			if(ASPECT_FROST)
				user.put_in_hands(frost_result)
			if(ASPECT_SHOCK)
				user.put_in_hands(shock_result)
			if(ASPECT_AIR)
				user.put_in_hands(air_result)
			if(ASPECT_FORCE)
				user.put_in_hands(force_result)
			if(ASPECT_TELE)
				user.put_in_hands(tele_result)
			if(ASPECT_BIOMED)
				user.put_in_hands(biomed_result)
			if(ASPECT_DARK)
				user.put_in_hands(dark_result)
			if(ASPECT_LIGHT)
				user.put_in_hands(light_result)
			if(ASPECT_UNSTABLE)
				user.put_in_hands(unstable_result)
		qdel(src)