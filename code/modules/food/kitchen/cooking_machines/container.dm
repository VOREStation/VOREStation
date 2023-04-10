//Cooking containers are used in ovens and fryers, to hold multiple ingredients for a recipe.
//They work fairly similar to the microwave - acting as a container for objects and reagents,
//which can be checked against recipe requirements in order to cook recipes that require several things

/obj/item/weapon/reagent_containers/cooking_container
	icon = 'icons/obj/cooking_machines.dmi'
	var/shortname
	var/max_space = 20//Maximum sum of w-classes of foods in this container at once
	var/max_reagents = 80//Maximum units of reagents
	var/food_items = 0 // Used for icon updates
	flags = OPENCONTAINER | NOREACT
	var/list/insertable = list(
		/obj/item/weapon/reagent_containers/food/snacks,
		/obj/item/weapon/holder,
		/obj/item/weapon/paper,
		/obj/item/clothing/head/wizard,
		/obj/item/clothing/head/cakehat,
		/obj/item/clothing/mask/gas/clown_hat,
		/obj/item/clothing/head/beret
	)

/obj/item/weapon/reagent_containers/cooking_container/Initialize()
	. = ..()
	create_reagents(max_reagents)
	flags |= OPENCONTAINER | NOREACT


/obj/item/weapon/reagent_containers/cooking_container/examine(var/mob/user)
	. = ..()
	if (contents.len)
		var/string = "It contains....</br>"
		for (var/atom/movable/A in contents)
			string += "[A.name] </br>"
		. += "<span class='notice'>[string]</span>"
	if (reagents.total_volume)
		. += "<span class='notice'>It contains [reagents.total_volume]u of reagents.</span>"


/obj/item/weapon/reagent_containers/cooking_container/attackby(var/obj/item/I as obj, var/mob/user as mob)
	if(istype(I, /obj/item/weapon/gripper))
		var/obj/item/weapon/gripper/GR = I
		if(GR.wrapped)
			GR.wrapped.forceMove(get_turf(src))
			attackby(GR.wrapped, user)
			if(QDELETED(GR.wrapped))
				GR.wrapped = null

			if(GR?.wrapped.loc != src)
				GR.wrapped = null

			return

	for (var/possible_type in insertable)
		if (istype(I, possible_type))
			if (!can_fit(I))
				to_chat(user, "<span class='warning'>There's no more space in the [src] for that!</span>")
				return 0

			if(!user.unEquip(I) && !isturf(I.loc))
				return
			I.forceMove(src)
			to_chat(user, "<span class='notice'>You put the [I] into the [src].</span>")
			food_items += 1
			update_icon()
			return

/obj/item/weapon/reagent_containers/cooking_container/verb/empty()
	set src in oview(1)
	set name = "Empty Container"
	set category = "Object"
	set desc = "Removes items from the container, excluding reagents."

	do_empty(usr)

/obj/item/weapon/reagent_containers/cooking_container/proc/do_empty(mob/user)
	if (!isliving(user))
		//Here we only check for ghosts. Animals are intentionally allowed to remove things from oven trays so they can eat it
		return

	if (user.stat || user.restrained())
		to_chat(user, "<span class='notice'>You are in no fit state to do this.</span>")
		return

	if (!Adjacent(user))
		to_chat(user, "<span class='filter_notice'>You can't reach [src] from here.</span>")
		return

	if (!contents.len)
		to_chat(user, "<span class='warning'>There's nothing in the [src] you can remove!</span>")
		return

	for (var/atom/movable/A in contents)
		A.forceMove(get_turf(src))

	to_chat(user, "<span class='notice'>You remove all the solid items from the [src].</span>")

/obj/item/weapon/reagent_containers/cooking_container/proc/check_contents()
	if (contents.len == 0)
		if (!reagents || reagents.total_volume == 0)
			return 0//Completely empty
	else if (contents.len == 1)
		if (!reagents || reagents.total_volume == 0)
			return 1//Contains only a single object which can be extracted alone
	return 2//Contains multiple objects and/or reagents

/obj/item/weapon/reagent_containers/cooking_container/AltClick(var/mob/user)
	do_empty(user)
	food_items = 0
	update_icon()

//Deletes contents of container.
//Used when food is burned, before replacing it with a burned mess
/obj/item/weapon/reagent_containers/cooking_container/proc/clear()
	for (var/atom/a in contents)
		qdel(a)

	if (reagents)
		reagents.clear_reagents()

/obj/item/weapon/reagent_containers/cooking_container/proc/label(var/number, var/CT = null)
	//This returns something like "Fryer basket 1 - empty"
	//The latter part is a brief reminder of contents
	//This is used in the removal menu
	. = shortname
	if (!isnull(number))
		.+= " [number]"
	.+= " - "
	if (CT)
		.+=CT
	else if (contents.len)
		for (var/obj/O in contents)
			.+=O.name//Just append the name of the first object
			return
	else if (reagents && reagents.total_volume > 0)
		var/datum/reagent/R = reagents.get_master_reagent()
		.+=R.name//Append name of most voluminous reagent
		return
	else
		. += "empty"


/obj/item/weapon/reagent_containers/cooking_container/proc/can_fit(var/obj/item/I)
	var/total = 0
	for (var/obj/item/J in contents)
		total += J.w_class

	if((max_space - total) >= I.w_class)
		return 1


//Takes a reagent holder as input and distributes its contents among the items in the container
//Distribution is weighted based on the volume already present in each item
/obj/item/weapon/reagent_containers/cooking_container/proc/soak_reagent(var/datum/reagents/holder)
	var/total = 0
	var/list/weights = list()
	for (var/obj/item/I in contents)
		if (I.reagents && I.reagents.total_volume)
			total += I.reagents.total_volume
			weights[I] = I.reagents.total_volume

	if (total > 0)
		for (var/obj/item/I in contents)
			if (weights[I])
				holder.trans_to(I, weights[I] / total)

/obj/item/weapon/reagent_containers/cooking_container/update_icon()
	overlays.Cut()

	if(food_items)
		var/image/filling = image('icons/obj/cooking_machines.dmi', src, "[icon_state]10")

		var/percent = round((food_items / max_space) * 100)
		switch(percent)
			if(0 to 2)	        filling.icon_state = "[icon_state]"
			if(3 to 24)         filling.icon_state = "[icon_state]1"
			if(25 to 49)        filling.icon_state = "[icon_state]2"
			if(50 to 74)        filling.icon_state = "[icon_state]3"
			if(75 to 79)        filling.icon_state = "[icon_state]4"
			if(80 to INFINITY)  filling.icon_state = "[icon_state]5"

		overlays += filling

/obj/item/weapon/reagent_containers/cooking_container/oven
	name = "oven dish"
	shortname = "shelf"
	desc = "Put ingredients in this; designed for use with an oven. Warranty void if used incorrectly. Alt click to remove contents."
	icon_state = "ovendish"
	max_space = 30
	max_reagents = 120

/obj/item/weapon/reagent_containers/cooking_container/oven/Initialize()
	. = ..()

	// We add to the insertable list specifically for the oven trays, to allow specialty cakes.
	insertable += list(
		/obj/item/clothing/head/cakehat, // This is because we want to allow birthday cakes to be makeable.
		/obj/item/organ/internal/brain // As before, needed for braincake
	)

/obj/item/weapon/reagent_containers/cooking_container/fryer
	name = "fryer basket"
	shortname = "basket"
	desc = "Put ingredients in this; designed for use with a deep fryer. Warranty void if used incorrectly. Alt click to remove contents."
	icon_state = "basket"

/obj/item/weapon/reagent_containers/cooking_container/grill
	name = "grill rack"
	shortname = "rack"
	desc = "Put ingredients 'in'/on this; designed for use with a grill. Warranty void if used incorrectly. Alt click to remove contents."
	icon_state = "grillrack"
