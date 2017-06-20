/obj/item/weapon/nullrod
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

	suicide_act(mob/user)
		viewers(user) << "<span class='danger'>[user] is impaling \himself with the [src.name]! It looks like \he's trying to commit suicide.</span>"
		return (BRUTELOSS|FIRELOSS)

/obj/item/weapon/nullrod/attack(mob/M as mob, mob/living/user as mob) //Paste from old-code to decult with a null rod.

	M.attack_log += text("\[[time_stamp()]\] <font color='orange'>Has been attacked with [src.name] by [user.name] ([user.ckey])</font>")
	user.attack_log += text("\[[time_stamp()]\] <font color='red'>Used the [src.name] to attack [M.name] ([M.ckey])</font>")

	msg_admin_attack("[user.name] ([user.ckey]) attacked [M.name] ([M.ckey]) with [src.name] (INTENT: [uppertext(user.a_intent)]) (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[user.x];Y=[user.y];Z=[user.z]'>JMP</a>)")

	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	user.do_attack_animation(M)

	if (!(istype(user, /mob/living/carbon/human) || ticker) && ticker.mode.name != "monkey")
		user << "<span class='danger'>You don't have the dexterity to do this!</span>"
		return

	if ((CLUMSY in user.mutations) && prob(50))
		user << "<span class='danger'>The rod slips out of your hand and hits your head.</span>"
		user.take_organ_damage(10)
		user.Paralyse(20)
		return

	if (M.stat !=2)
		if(cult && (M.mind in cult.current_antagonists) && prob(33))
			M << "<span class='danger'>The power of [src] clears your mind of the cult's influence!</span>"
			user << "<span class='danger'>You wave [src] over [M]'s head and see their eyes become clear, their mind returning to normal.</span>"
			cult.remove_antagonist(M.mind)
			M.visible_message("<span class='danger'>\The [user] waves \the [src] over \the [M]'s head.</span>")
		else if(prob(10))
			user << "<span class='danger'>The rod slips in your hand.</span>"
			..()
		else
			user << "<span class='danger'>The rod appears to do nothing.</span>"
			M.visible_message("<span class='danger'>\The [user] waves \the [src] over \the [M]'s head.</span>")
			return

/obj/item/weapon/nullrod/afterattack(atom/A, mob/user as mob, proximity)
	if(!proximity)
		return
	if (istype(A, /turf/simulated/floor))
		user << "<span class='notice'>You hit the floor with the [src].</span>"
		call(/obj/effect/rune/proc/revealrunes)(src)

/obj/item/weapon/energy_net
	name = "energy net"
	desc = "It's a net made of green energy."
	icon = 'icons/effects/effects.dmi'
	icon_state = "energynet"
	throwforce = 0
	force = 0
	var/net_type = /obj/effect/energy_net

/obj/item/weapon/energy_net/dropped()
	spawn(10)
		if(src) qdel(src)

/obj/item/weapon/energy_net/throw_impact(atom/hit_atom)
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

	density = 1
	opacity = 0
	mouse_opacity = 1
	anchored = 0

	can_buckle = 1
	buckle_movable = 1
	buckle_lying = 0
	buckle_dir = SOUTH

	var/escape_time = 8 SECONDS

/obj/effect/energy_net/New()
	..()
	processing_objects |= src

/obj/effect/energy_net/Destroy()
	if(buckled_mob)
		to_chat(buckled_mob,"<span class='notice'>You are free of the net!</span>")
		unbuckle_mob()

	processing_objects -= src
	return ..()

/obj/effect/energy_net/process()
	if(isnull(buckled_mob) || buckled_mob.loc != loc)
		qdel(src)

/obj/effect/energy_net/Move()
	..()
	if(buckled_mob)
		var/mob/living/occupant = buckled_mob
		occupant.buckled = null
		occupant.forceMove(src.loc)
		occupant.buckled = src
		if (occupant && (src.loc != occupant.loc))
			unbuckle_mob()
			qdel(src)

/obj/effect/energy_net/user_unbuckle_mob(mob/user)
	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	visible_message("<span class='danger'>[user] begins to tear at \the [src]!</span>")
	if(do_after(usr, escape_time, src, incapacitation_flags = INCAPACITATION_DEFAULT & ~(INCAPACITATION_RESTRAINED | INCAPACITATION_BUCKLED_FULLY)))
		if(!buckled_mob)
			return
		visible_message("<span class='danger'>[user] manages to tear \the [src] apart!</span>")
		unbuckle_mob()

/obj/effect/energy_net/post_buckle_mob(mob/living/M)
	if(buckled_mob) //Just buckled someone
		..()
		layer = M.layer+1
		M.can_pull_size = 0
	else //Just unbuckled someone
		M.can_pull_size = initial(M.can_pull_size)
		qdel(src)
