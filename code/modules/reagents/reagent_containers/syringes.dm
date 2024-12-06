////////////////////////////////////////////////////////////////////////////////
/// Syringes.
////////////////////////////////////////////////////////////////////////////////
#define SYRINGE_DRAW 0
#define SYRINGE_INJECT 1
#define SYRINGE_BROKEN 2

#define SYRINGE_CAPPED 10


/obj/item/reagent_containers/syringe
	name = "syringe"
	desc = "A syringe."
	description_fluff = "This could be used to engrave messages on suitable surfaces if you really put your mind to it! Alt-click a floor or wall to engrave with it." //This way it's not a completely hidden, arcane art to engrave.
	icon = 'icons/goonstation/objects/syringe_vr.dmi'
	item_state = "syringe_0"
	icon_state = "0"
	center_of_mass = list("x" = 16,"y" = 14)
	matter = list(MAT_GLASS = 150)
	amount_per_transfer_from_this = 5
	possible_transfer_amounts = null
	volume = 15
	w_class = ITEMSIZE_TINY
	slot_flags = SLOT_EARS
	sharp = TRUE
	unacidable = TRUE //glass
	var/mode = SYRINGE_CAPPED
	var/image/filling //holds a reference to the current filling overlay
	var/visible_name = "a syringe"
	var/time = 30
	var/drawing = 0
	var/used = FALSE
	var/dirtiness = 0
	var/list/targets
	var/list/datum/disease/viruses
	drop_sound = 'sound/items/drop/glass.ogg'
	pickup_sound = 'sound/items/pickup/glass.ogg'


/obj/item/reagent_containers/syringe/Initialize()
	. = ..()
	update_icon()

/obj/item/reagent_containers/syringe/Destroy()
	QDEL_LIST_NULL(viruses)
	LAZYCLEARLIST(targets)
	return ..()

/obj/item/reagent_containers/syringe/process()
	dirtiness = min(dirtiness + targets.len,75)
	if(dirtiness >= 75)
		STOP_PROCESSING(SSobj, src)
	return 1

/obj/item/reagent_containers/syringe/on_reagent_change()
	update_icon()

/obj/item/reagent_containers/syringe/pickup(mob/user)
	..()
	update_icon()

/obj/item/reagent_containers/syringe/dropped(mob/user)
	..()
	update_icon()

/obj/item/reagent_containers/syringe/attack_self(mob/user as mob)
	switch(mode)
		if(SYRINGE_CAPPED)
			mode = SYRINGE_DRAW
			to_chat(user,span_notice("You uncap the syringe."))
		if(SYRINGE_DRAW)
			mode = SYRINGE_INJECT
		if(SYRINGE_INJECT)
			mode = SYRINGE_DRAW
		if(SYRINGE_BROKEN)
			return
	update_icon()

/obj/item/reagent_containers/syringe/attack_hand()
	..()
	update_icon()

/obj/item/reagent_containers/syringe/attackby(obj/item/I as obj, mob/user as mob)
	return

/obj/item/reagent_containers/syringe/afterattack(obj/target, mob/user, proximity)
	if(!proximity || !target.reagents)
		return

	if(mode == SYRINGE_BROKEN)
		to_chat(user, span_warning("This syringe is broken!"))
		return

	if(user.a_intent == I_HURT && ismob(target))
		if((CLUMSY in user.mutations) && prob(50))
			target = user
		syringestab(target, user)
		return

	var/injtime = time // Calculated 'true' injection time (as added to by hardsuits and whatnot), 66% of this goes to warmup, then every 33% after injects 5u
	switch(mode)
		if(SYRINGE_DRAW)
			if(!reagents.get_free_space())
				to_chat(user, span_warning("The syringe is full."))
				mode = SYRINGE_INJECT
				return

			if(ismob(target))//Blood!
				if(reagents.has_reagent(REAGENT_ID_BLOOD))
					to_chat(user, span_notice("There is already a blood sample in this syringe."))
					return

				if(istype(target, /mob/living/carbon))
					var/amount = reagents.get_free_space()
					var/mob/living/carbon/T = target
					if(!T.dna)
						to_chat(user, span_warning("You are unable to locate any blood. (To be specific, your target seems to be missing their DNA datum)."))
						return
					if(NOCLONE in T.mutations) //target done been et, no more blood in him
						to_chat(user, span_warning("You are unable to locate any blood."))
						return

					if(T.isSynthetic())
						to_chat(user, span_warning("You can't draw blood from a synthetic!"))
						return

					if(drawing)
						to_chat(user, span_warning("You are already drawing blood from [T.name]."))
						return

					var/datum/reagent/B
					drawing = 1
					if(istype(T, /mob/living/carbon/human))
						var/mob/living/carbon/human/H = T
						if(H.species && !H.should_have_organ(O_HEART))
							H.reagents.trans_to_obj(src, amount)
						else
							if(ismob(H) && H != user)
								if(!do_mob(user, target, time))
									drawing = 0
									return
							B = T.take_blood(src, amount)
							drawing = 0
					else
						if(!do_mob(user, target, time))
							drawing = 0
							return
						B = T.take_blood(src,amount)
						drawing = 0

					if (B)
						reagents.reagent_list += B
						reagents.update_total()
						on_reagent_change()
						reagents.handle_reactions()
					to_chat(user, span_notice("You take a blood sample from [target]."))
					for(var/mob/O in viewers(4, user))
						O.show_message(span_notice("[user] takes a blood sample from [target]."), 1)

			else //if not mob
				if(!target.reagents.total_volume)
					to_chat(user, span_notice("[target] is empty."))
					return

				if(!target.is_open_container() && !istype(target, /obj/structure/reagent_dispensers) && !istype(target, /obj/item/slime_extract) && !istype(target, /obj/item/reagent_containers/food))
					to_chat(user, span_notice("You cannot directly remove reagents from this object."))
					return

				var/trans = target.reagents.trans_to_obj(src, amount_per_transfer_from_this)
				to_chat(user, span_notice("You fill the syringe with [trans] units of the solution."))
				update_icon()


			if(!reagents.get_free_space())
				mode = SYRINGE_INJECT
				update_icon()

		if(SYRINGE_INJECT)
			if(!reagents.total_volume)
				to_chat(user, span_notice("The syringe is empty."))
				mode = SYRINGE_DRAW
				return
			if(istype(target, /obj/item/implantcase/chem))
				return

			if(!target.is_open_container() && !ismob(target) && !istype(target, /obj/item/reagent_containers/food) && !istype(target, /obj/item/slime_extract) && !istype(target, /obj/item/clothing/mask/smokable/cigarette) && !istype(target, /obj/item/storage/fancy/cigarettes))
				to_chat(user, span_notice("You cannot directly fill this object."))
				return
			if(!target.reagents.get_free_space())
				to_chat(user, span_notice("[target] is full."))
				return

			var/mob/living/carbon/human/H = target
			var/obj/item/organ/external/affected //VOREStation Edit - Moved this outside this if
			if(istype(H))
				affected = H.get_organ(user.zone_sel.selecting) //VOREStation Edit - See above comment.
				if(!affected)
					to_chat(user, span_danger("\The [H] is missing that limb!"))
					return
				/* since synths have oil/coolant streams now, it only makes sense that you should be able to inject stuff. preserved for posterity.
				else if(affected.robotic >= ORGAN_ROBOT)
					to_chat(user, span_danger("You cannot inject a robotic limb."))
					return
				*/

			var/cycle_time = injtime*0.33 //33% of the time slept between 5u doses
			var/warmup_time = 0	//0 for containers
			if(ismob(target))
				warmup_time = cycle_time //If the target is another mob, this gets overwritten

			if(ismob(target) && target != user)
				warmup_time = injtime*0.66 //66% of the time is warmup

				if(istype(H))
					if(H.wear_suit)
						if(istype(H.wear_suit, /obj/item/clothing/suit/space))
							injtime = injtime * 2

				else if(isliving(target))

					var/mob/living/M = target
					if(!M.can_inject(user, 1))
						return

				if(injtime == time)
					user.visible_message(span_warning("[user] is trying to inject [target] with [visible_name]!"),span_notice("You begin injecting [target] with [visible_name]."))
				else
					user.visible_message(span_warning("[user] begins hunting for an injection port on [target]'s suit!"),span_notice("You begin hunting for an injection port on [target]'s suit!"))

			//The warmup
			user.setClickCooldown(DEFAULT_QUICK_COOLDOWN)
			if(!do_after(user,warmup_time,target))
				return

			var/trans = 0
			var/contained = reagentlist()
			if(ismob(target))
				while(reagents.total_volume)
					trans += reagents.trans_to_mob(target, amount_per_transfer_from_this, CHEM_BLOOD)
					update_icon()
					if(!reagents.total_volume || !do_after(user,cycle_time,target))
						break
			else
				trans += reagents.trans_to_obj(target, amount_per_transfer_from_this)

			if (reagents.total_volume <= 0 && mode == SYRINGE_INJECT)
				mode = SYRINGE_DRAW
				update_icon()

			if(trans)
				to_chat(user, span_notice("You inject [trans] units of the solution. The syringe now contains [src.reagents.total_volume] units."))
				if(ismob(target))
					add_attack_logs(user,target,"Injected with [src.name] containing [contained], trasferred [trans] units")
			else
				to_chat(user, span_notice("The syringe is empty."))

//		dirty(target,affected) //VOREStation Add -- Removed by Request
	return

/obj/item/reagent_containers/syringe/proc/syringestab(mob/living/carbon/target as mob, mob/living/carbon/user as mob)
	if(istype(target, /mob/living/carbon/human))

		var/mob/living/carbon/human/H = target

		var/target_zone = ran_zone(check_zone(user.zone_sel.selecting, target))
		var/obj/item/organ/external/affecting = H.get_organ(target_zone)

		if (!affecting || affecting.is_stump())
			to_chat(user, span_danger("They are missing that limb!"))
			return

		var/hit_area = affecting.name

		if((user != target) && H.check_shields(7, src, user, "\the [src]"))
			return

		if (target != user && H.getarmor(target_zone, "melee") > 5 && prob(50))
			for(var/mob/O in viewers(world.view, user))
				O.show_message(span_bolddanger("[user] tries to stab [target] in \the [hit_area] with [src.name], but the attack is deflected by armor!"), 1)
			user.remove_from_mob(src)
			qdel(src)

			add_attack_logs(user,target,"Syringe harmclick")

			return

		user.visible_message(span_danger("[user] stabs [target] in \the [hit_area] with [src.name]!"))

		if(affecting.take_damage(3))
			H.UpdateDamageIcon()

	else
		user.visible_message(span_danger("[user] stabs [target] with [src.name]!"))
		target.take_organ_damage(3)// 7 is the same as crowbar punch



	var/syringestab_amount_transferred = rand(max(reagents.total_volume - 10, 0), (reagents.total_volume - 5)) //nerfed by popular demand
	var/contained = reagents.get_reagents()
	var/trans = reagents.trans_to_mob(target, syringestab_amount_transferred, CHEM_BLOOD)
	if(isnull(trans)) trans = 0
	add_attack_logs(user,target,"Stabbed with [src.name] containing [contained], trasferred [trans] units")
	if(!issilicon(user))
		break_syringe(target, user)

/obj/item/reagent_containers/syringe/proc/break_syringe(mob/living/carbon/target, mob/living/carbon/user)
	desc += " It is broken."
	mode = SYRINGE_BROKEN
	if(target)
		add_blood(target)
	if(user)
		add_fingerprint(user)
	update_icon()

/obj/item/reagent_containers/syringe/ld50_syringe
	name = "Lethal Injection Syringe"
	desc = "A syringe used for lethal injections."
	amount_per_transfer_from_this = 50
	volume = 50
	visible_name = "a giant syringe"
	time = 300

/obj/item/reagent_containers/syringe/ld50_syringe/afterattack(obj/target, mob/user, flag)
	if(mode == SYRINGE_DRAW && ismob(target)) // No drawing 50 units of blood at once
		to_chat(user, span_notice("This needle isn't designed for drawing blood."))
		return
	if(user.a_intent == "hurt" && ismob(target)) // No instant injecting
		to_chat(user, span_notice("This syringe is too big to stab someone with it."))
	..()

////////////////////////////////////////////////////////////////////////////////
/// Syringes. END
////////////////////////////////////////////////////////////////////////////////

/obj/item/reagent_containers/syringe/inaprovaline
	name = "Syringe (inaprovaline)"
	desc = "Contains inaprovaline - used to stabilize patients."

/obj/item/reagent_containers/syringe/inaprovaline/Initialize()
	. = ..()
	reagents.add_reagent("inaprovaline", 15)
	//mode = SYRINGE_INJECT //VOREStation Edit - Starts capped
	//update_icon()

/obj/item/reagent_containers/syringe/antitoxin
	name = "Syringe (anti-toxin)"
	desc = "Contains anti-toxins."

/obj/item/reagent_containers/syringe/antitoxin/Initialize()
	. = ..()
	reagents.add_reagent("anti_toxin", 15)
	//mode = SYRINGE_INJECT //VOREStation Edit - Starts capped
	//update_icon()

/obj/item/reagent_containers/syringe/antiviral
	name = "Syringe (spaceacillin)"
	desc = "Contains antiviral agents."

/obj/item/reagent_containers/syringe/antiviral/Initialize()
	. = ..()
	reagents.add_reagent("spaceacillin", 15)
	//mode = SYRINGE_INJECT //VOREStation Edit - Starts capped
	//update_icon()

/obj/item/reagent_containers/syringe/drugs
	name = "Syringe (drugs)"
	desc = "Contains aggressive drugs meant for torture."

/obj/item/reagent_containers/syringe/drugs/Initialize()
	. = ..()
	reagents.add_reagent(REAGENT_ID_BLISS,  5)
	reagents.add_reagent("mindbreaker",  5)
	reagents.add_reagent("cryptobiolin", 5)
	//mode = SYRINGE_INJECT //VOREStation Edit - Starts capped
	//update_icon()

/obj/item/reagent_containers/syringe/ld50_syringe/choral/Initialize()
	. = ..()
	reagents.add_reagent("chloralhydrate", 50)
	mode = SYRINGE_INJECT
	update_icon()

/obj/item/reagent_containers/syringe/steroid
	name = "Syringe (anabolic steroids)"
	desc = "Contains drugs for muscle growth."

/obj/item/reagent_containers/syringe/steroid/Initialize()
	..()
	//reagents.add_reagent("adrenaline",5) //VOREStation Edit - No thanks.
	reagents.add_reagent("hyperzine",10)

/obj/item/reagent_containers/syringe/proc/dirty(var/mob/living/carbon/human/target, var/obj/item/organ/external/eo)
	if(!ishuman(loc))
		return //Avoid borg syringe problems.
	LAZYINITLIST(targets)

	//We can't keep a mob reference, that's a bad idea, so instead name+ref should suffice.
	var/name_to_use = ismob(target) ? target.real_name : target.name
	var/hash = md5(name_to_use + "\ref[target]")

	//Just once!
	targets |= hash

	//Grab any viruses they have
	if(iscarbon(target) && LAZYLEN(target.viruses.len))
		LAZYINITLIST(viruses)
		var/datum/disease/virus = pick(target.viruses.len)
		viruses[hash] = virus.Copy()

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
			var/datum/disease/virus = viruses[old_hash]
			target.ContractDisease(virus)

	if(!used)
		START_PROCESSING(SSobj, src)

/obj/item/reagent_containers/syringe/proc/infect_limb(var/obj/item/organ/external/eo)
	src = null
	var/datum/weakref/limb_ref = WEAKREF(eo)
	spawn(rand(5 MINUTES,10 MINUTES))
		var/obj/item/organ/external/found_limb = limb_ref.resolve()
		if(istype(found_limb))
			eo.germ_level += INFECTION_LEVEL_ONE+30

//Allow for capped syringe mode

//Allow for capped syringes
/obj/item/reagent_containers/syringe/update_icon()
	cut_overlays()

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

	var/rounded_vol = round(reagents.total_volume, round(reagents.maximum_volume / 3))
	if(reagents.total_volume)
		filling = image(icon, src, "filler[rounded_vol]")
		filling.color = reagents.get_color()
		add_overlay(filling)

	if(ismob(loc))
		var/injoverlay
		switch(mode)
			if (SYRINGE_DRAW)
				injoverlay = "draw"
			if (SYRINGE_INJECT)
				injoverlay = "inject"
		add_overlay(injoverlay)

	icon_state = "[rounded_vol]"
	item_state = "syringe_[rounded_vol]"

#undef SYRINGE_DRAW
#undef SYRINGE_INJECT
#undef SYRINGE_BROKEN

#undef SYRINGE_CAPPED
