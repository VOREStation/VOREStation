/datum/species
	//This is used in character setup preview generation (prefences_setup.dm) and human mob
	//rendering (update_icons.dm)
	var/color_mult = 0

	//This is for overriding tail rendering with a specific icon in icobase, for static
	//tails only, since tails would wag when dead if you used this
	var/icobase_tail = 0


	//This is used for egg TF. It decides what type of egg the person will lay when they TF.
	//Default to the normal and bland "egg" just in case a race isn't defined.
	var/egg_type = "egg"