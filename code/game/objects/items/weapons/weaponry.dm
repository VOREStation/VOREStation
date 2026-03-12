/obj/item/nullrod
	name = "null rod"
	desc = "A rod of pure obsidian, its very presence disrupts and dampens the powers of paranormal phenomenae."
	icon_state = "nullrod"
	item_state = "nullrod"
	slot_flags = SLOT_BELT
	force = 15
	throw_speed = 1
	throw_range = 4
	throwforce = 10
	w_class = ITEMSIZE_SMALL
	drop_sound = 'sound/items/drop/sword.ogg'
	pickup_sound = 'sound/items/pickup/sword.ogg'

/obj/item/nullrod/attack(mob/M as mob, mob/living/user as mob)

	add_attack_logs(user,M,"Hit with [src] (nullrod)")

	user.setClickCooldown(user.get_attack_speed(src))
	user.do_attack_animation(M)

	if(!user.IsAdvancedToolUser())
		to_chat(user, span_danger("You don't have the dexterity to do this!"))
		return

	if(CLUMSY_HARM_CHANCE(user))
		to_chat(user, span_danger("The rod slips out of your hand and hits your head."))
		user.take_organ_damage(10)
		user.Paralyse(20)
		return

	if(M.stat != DEAD)
		if(user?.mind?.assigned_role != JOB_CHAPLAIN)
			to_chat(user, span_danger("You feel that only a chaplain can wield the null rod's true power!"))
			..()
			return

		if(ishuman(M))
			var/mob/living/carbon/human/infected = M
			if(infected.has_modifier_of_type(/datum/modifier/redspace_corruption))
				infected.remove_modifiers_of_type(/datum/modifier/redspace_corruption)
				to_chat(user, "You wave [src] over [infected]'s head, and feel a dark presence leave [M.p_their()] body.")
				to_chat(infected, "[user] waves [src] over your head and you feel a dark presence leave your body.")

			if(infected.HasDisease(/datum/disease/fleshy_spread))
				for(var/datum/disease/fleshy_spread/disease in infected.GetViruses())
					disease.cure()
					break
				to_chat(user, "You wave [src] over [infected]'s head, curing them of their infection.")
				to_chat(infected, "[user] waves [src] over your head, curing you of your infection.")

		//Chaplain null rod removes ALL unholy traits.
		REMOVE_TRAITS_IN(M, UNHOLY_TRAIT)

		if(GLOB.cult && (M.mind in GLOB.cult.current_antagonists) && prob(33))
			to_chat(M, span_danger("The power of [src] clears your mind of the cult's influence!"))
			to_chat(user, span_danger("You wave [src] over [M]'s head and see their eyes become clear, their mind returning to normal."))
			GLOB.cult.remove_antagonist(M.mind)
			M.visible_message(span_danger("\The [user] waves \the [src] over \the [M]'s head."))
		else
			to_chat(user, span_danger("The rod appears to do nothing."))
			M.visible_message(span_danger("\The [user] waves \the [src] over \the [M]'s head."))
			return

/obj/item/nullrod/afterattack(atom/A, mob/user as mob, proximity)
	if(!proximity)
		return
	if (istype(A, /turf/simulated/floor))
		to_chat(user, span_notice("You hit the floor with the [src]."))
		call(/obj/effect/rune/proc/revealrunes)(src)

/obj/item/energy_net
	name = "energy net"
	desc = "It's a net made of green energy."
	icon = 'icons/effects/effects.dmi'
	icon_state = "energynet"
	throwforce = 0
	force = 0
	var/net_type = /obj/effect/energy_net

/obj/item/energy_net/dropped(mob/user)
	..()
	spawn(10)
		if(src) qdel(src)

/obj/item/energy_net/throw_impact(atom/hit_atom)
	..()

	var/mob/living/M = hit_atom

	if(!istype(M) || locate(/obj/effect/energy_net) in M.loc)
		qdel(src)
		return 0

	var/turf/T = get_turf(M)
	if(T)
		var/obj/effect/energy_net/net = new net_type(T)
		if(net.buckle_mob(M))
			T.visible_message("[M] was caught in an energy net!")
		qdel(src)

	// If we miss or hit an obstacle, we still want to delete the net.
	spawn(10)
		if(src) qdel(src)

/obj/effect/energy_net
	name = "energy net"
	desc = "It's a net made of green energy."
	icon = 'icons/effects/effects.dmi'
	icon_state = "energynet"

	density = TRUE
	opacity = 0
	mouse_opacity = 1
	anchored = FALSE

	can_buckle = TRUE
	buckle_lying = 0
	buckle_dir = SOUTH

	var/escape_time = 8 SECONDS

/obj/effect/energy_net/Initialize(mapload)
	. = ..()
	START_PROCESSING(SSobj, src)

/obj/effect/energy_net/Destroy()
	if(has_buckled_mobs())
		for(var/A in buckled_mobs)
			to_chat(A, span_notice("You are free of the net!"))
			unbuckle_mob(A)

	STOP_PROCESSING(SSobj, src)
	return ..()

/obj/effect/energy_net/process()
	if(!has_buckled_mobs())
		qdel(src)

/obj/effect/energy_net/user_unbuckle_mob(mob/living/buckled_mob, mob/user)
	user.setClickCooldown(user.get_attack_speed())
	visible_message(span_danger("[user] begins to tear at \the [src]!"))
	if(do_after(user, escape_time, target = src, timed_action_flags = IGNORE_INCAPACITATED))
		if(!has_buckled_mobs())
			return
		visible_message(span_danger("[user] manages to tear \the [src] apart!"))
		unbuckle_mob(buckled_mob)

/obj/effect/energy_net/post_buckle_mob(mob/living/M)
	if(M.buckled == src) //Just buckled someone
		..()
		layer = M.layer+1
		M.can_pull_size = 0
	else //Just unbuckled someone
		M.can_pull_size = initial(M.can_pull_size)
		qdel(src)

/obj/item/energy_net/shrink
	name = "compactor energy net"
	desc = "It's a net made of cyan energy."
	icon_state = "shrinkenergynet"
	net_type = /obj/effect/energy_net/shrink

/obj/effect/energy_net/shrink
	name = "compactor energy net"
	desc = "It's a net made of cyan energy."
	icon_state = "shrinkenergynet"

	var/size_increment = 0.01

/obj/effect/energy_net/shrink/process()
	..()
	for(var/A in buckled_mobs)
		if(istype(A, /mob/living))
			var/mob/living/L = A
			L.resize((L.size_multiplier - size_increment), uncapped = L.has_large_resize_bounds(), aura_animation = FALSE)
