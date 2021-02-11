

/mob/living
	var/meat_amount = 0				// How much meat to drop from this mob when butchered
	var/obj/meat_type				// The meat object to drop

	var/gib_on_butchery = FALSE

	var/list/butchery_loot			// Associated list, path = number.

// Harvest an animal's delicious byproducts
/mob/living/proc/harvest(var/mob/user, var/obj/item/I)
	if(meat_type && meat_amount>0 && (stat == DEAD))
		while(meat_amount > 0 && do_after(user, 0.5 SECONDS * (mob_size / 10), src))
			var/obj/item/meat = new meat_type(get_turf(src))
			meat.name = "[src.name] [meat.name]"
			new /obj/effect/decal/cleanable/blood/splatter(get_turf(src))
			meat_amount--

	if(!meat_amount)
		handle_butcher(user, I)

/mob/living/proc/can_butcher(var/mob/user, var/obj/item/I)	// Override for special butchering checks.
	if(((meat_type && meat_amount) || LAZYLEN(butchery_loot)) && stat == DEAD)
		return TRUE

	return FALSE

/mob/living/proc/handle_butcher(var/mob/user, var/obj/item/I)
	if(!user || do_after(user, 2 SECONDS * mob_size / 10, src))
		if(LAZYLEN(butchery_loot))
			if(LAZYLEN(butchery_loot))
				for(var/path in butchery_loot)
					while(butchery_loot[path])
						butchery_loot[path] -= 1
						var/obj/item/loot = new path(get_turf(src))
						loot.pixel_x = rand(-12, 12)
						loot.pixel_y = rand(-12, 12)

				butchery_loot.Cut()
				butchery_loot = null

		if(LAZYLEN(organs))
			organs_by_name.Cut()

			for(var/path in organs)
				if(ispath(path))
					var/obj/item/organ/external/neworg = new path(src)
					neworg.name = "[name] [neworg.name]"
					neworg.meat_type = meat_type

					if(istype(src, /mob/living/simple_mob))
						var/mob/living/simple_mob/SM = src
						if(SM.limb_icon)
							neworg.force_icon = SM.limb_icon
							neworg.force_icon_key = SM.limb_icon_key

					organs |= neworg
					organs -= path

			for(var/obj/item/organ/OR in organs)
				OR.removed()
				organs -= OR

		if(LAZYLEN(internal_organs))
			internal_organs_by_name.Cut()

			for(var/path in internal_organs)
				if(ispath(path))
					var/obj/item/organ/neworg = new path(src, TRUE)
					neworg.name = "[name] [neworg.name]"
					neworg.meat_type = meat_type
					internal_organs |= neworg
					internal_organs -= path

			for(var/obj/item/organ/OR in internal_organs)
				OR.removed()
				internal_organs -= OR

		if(!ckey)
			if(issmall(src))
				user?.visible_message("<span class='danger'>[user] chops up \the [src]!</span>")
				new /obj/effect/decal/cleanable/blood/splatter(get_turf(src))
				if(gib_on_butchery)
					qdel(src)
			else
				user?.visible_message("<span class='danger'>[user] butchers \the [src] messily!</span>")
				if(gib_on_butchery)
					gib()
