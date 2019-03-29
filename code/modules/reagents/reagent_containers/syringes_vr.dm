#define SYRINGE_CAPPED 10

/obj/item/weapon/reagent_containers/syringe
	icon = 'icons/goonstation/objects/syringe_vr.dmi'
	mode = SYRINGE_CAPPED //Override
	var/used = FALSE
	var/dirtiness = 0
	var/list/targets
	var/list/datum/disease2/disease/viruses

/obj/item/weapon/reagent_containers/syringe/Initialize()
	. = ..()
	update_icon()

/obj/item/weapon/reagent_containers/syringe/Destroy()
	QDEL_LIST_NULL(viruses)
	LAZYCLEARLIST(targets)
	return ..()

/obj/item/weapon/reagent_containers/syringe/process()
	dirtiness = min(dirtiness + targets.len,75)
	if(dirtiness >= 75)
		STOP_PROCESSING(SSobj, src)
	return 1

/obj/item/weapon/reagent_containers/syringe/proc/dirty(var/mob/living/carbon/human/target, var/obj/item/organ/external/eo)
	if(!ishuman(loc))
		return //Avoid borg syringe problems.
	LAZYINITLIST(targets)

	//We can't keep a mob reference, that's a bad idea, so instead name+ref should suffice.
	var/name_to_use = ismob(target) ? target.real_name : target.name
	var/hash = md5(name_to_use + "\ref[target]")

	//Just once!
	targets |= hash

	//Grab any viruses they have
	if(iscarbon(target) && LAZYLEN(target.virus2.len))
		LAZYINITLIST(viruses)
		var/datum/disease2/disease/virus = pick(target.virus2.len)
		viruses[hash] = virus.getcopy()

	//Dirtiness should be very low if you're the first injectee. If you're spam-injecting 4 people in a row around you though,
	//This gives the last one a 30% chance of infection.
	var/infect_chance = dirtiness        //Start with dirtiness
	if(infect_chance <= 10 && (hash in targets)) //Extra fast uses on target is free
		infect_chance = 0
	infect_chance += (targets.len-1)*10    //Extra 10% per extra target
	if(prob(infect_chance))
		log_and_message_admins("[loc] infected [target]'s [eo.name] with \the [src].")
		infect_limb(eo)

	//75% chance to spread a virus if we have one
	if(LAZYLEN(viruses) && prob(75))
		var/old_hash = pick(viruses)
		if(hash != old_hash) //Same virus you already had?
			var/datum/disease2/disease/virus = viruses[old_hash]
			infect_virus2(target,virus.getcopy())

	if(!used)
		START_PROCESSING(SSobj, src)

/obj/item/weapon/reagent_containers/syringe/proc/infect_limb(var/obj/item/organ/external/eo)
	src = null
	var/weakref/limb_ref = weakref(eo)
	spawn(rand(5 MINUTES,10 MINUTES))
		var/obj/item/organ/external/found_limb = limb_ref.resolve()
		if(istype(found_limb))
			eo.germ_level += INFECTION_LEVEL_ONE+30

//Allow for capped syringe mode
/obj/item/weapon/reagent_containers/syringe/attack_self(mob/user as mob)
	switch(mode)
		if(SYRINGE_CAPPED)
			mode = SYRINGE_DRAW
			to_chat(user,"<span class='notice'>You uncap the syringe.</span>")
		if(SYRINGE_DRAW)
			mode = SYRINGE_INJECT
		if(SYRINGE_INJECT)
			mode = SYRINGE_DRAW
		if(SYRINGE_BROKEN)
			return
	update_icon()

//Allow for capped syringes
/obj/item/weapon/reagent_containers/syringe/update_icon()
	cut_overlays(src)

	var/matrix/tf = matrix()
	if(isstorage(loc))
		tf.Turn(-90) //Vertical for storing compact-ly
		tf.Translate(-3,0) //Could do this with pixel_x but let's just update the appearance once.
	transform = tf

	if(mode == SYRINGE_BROKEN)
		icon_state = "broken"
		return

	if(mode == SYRINGE_CAPPED)
		icon_state = "capped"
		return

	var/list/new_overlays = list()
	var/rounded_vol = round(reagents.total_volume, round(reagents.maximum_volume / 3))
	if(reagents.total_volume)
		filling = image(icon, src, "filler[rounded_vol]")
		filling.color = reagents.get_color()
		new_overlays += filling

	if(ismob(loc))
		var/injoverlay
		switch(mode)
			if (SYRINGE_DRAW)
				injoverlay = "draw"
			if (SYRINGE_INJECT)
				injoverlay = "inject"
		new_overlays += injoverlay

	add_overlay(new_overlays)
	icon_state = "[rounded_vol]"
	item_state = "syringe_[rounded_vol]"

#undef SYRINGE_CAPPED
