/obj/item/device/assembly/mousetrap
	name = "mousetrap"
	desc = "A handy little spring-loaded trap for catching pesty rodents."
	icon_state = "mousetrap"
	origin_tech = list(TECH_COMBAT = 1)
	matter = list(MAT_STEEL = 100)
	var/armed = 0


/obj/item/device/assembly/mousetrap/examine(var/mob/user)
	. = ..(user)
	if(armed)
		. += "It looks like it's armed."

/obj/item/device/assembly/mousetrap/update_icon()
	if(armed)
		icon_state = "mousetraparmed"
	else
		icon_state = "mousetrap"
	if(holder)
		holder.update_icon()

/obj/item/device/assembly/mousetrap/proc/triggered(var/mob/target, var/type = "feet")
	if(!armed)
		return
	var/obj/item/organ/external/affecting = null
	if(ishuman(target))
		var/mob/living/human/H = target
		switch(type)
			if("feet")
				if(!H.shoes)
					affecting = H.get_organ(pick("l_leg", "r_leg"))
					H.Weaken(3)
			if("l_hand", "r_hand")
				if(!H.gloves)
					affecting = H.get_organ(type)
					H.Stun(3)
		if(affecting)
			if(affecting.take_damage(1, 0))
				H.UpdateDamageIcon()
			H.updatehealth()
	else if(ismouse(target))
		var/mob/living/simple_mob/animal/passive/mouse/M = target
		visible_message("<font color='red'><b>SPLAT!</b></font>")
		M.splat()
	playsound(target, 'sound/effects/snap.ogg', 50, 1)
	layer = MOB_LAYER - 0.2
	armed = 0
	update_icon()
	pulse(0)

/obj/item/device/assembly/mousetrap/attack_self(var/mob/living/user)
	if(!armed)
		to_chat(user, "<span class='notice'>You arm [src].</span>")
	else
		if((CLUMSY in user.mutations) && prob(50))
			var/which_hand = "l_hand"
			if(!user.hand)
				which_hand = "r_hand"
			triggered(user, which_hand)
			user.visible_message("<span class='warning'>[user] accidentally sets off [src], breaking their fingers.</span>", \
								 "<span class='warning'>You accidentally trigger [src]!</span>")
			return

		to_chat(user, "<span class='notice'>You disarm [src].</span>")
	armed = !armed
	update_icon()
	playsound(user, 'sound/weapons/handcuffs.ogg', 30, 1, -3)

/obj/item/device/assembly/mousetrap/attack_hand(var/mob/living/user)
	if(armed)
		if((CLUMSY in user.mutations) && prob(50))
			var/which_hand = "l_hand"
			if(!user.hand)
				which_hand = "r_hand"
			triggered(user, which_hand)
			user.visible_message("<span class='warning'>[user] accidentally sets off [src], breaking their fingers.</span>", \
								 "<span class='warning'>You accidentally trigger [src]!</span>")
			return
	..()

/obj/item/device/assembly/mousetrap/Crossed(var/atom/movable/AM)
	if(AM.is_incorporeal())
		return
	if(armed)
		if(ishuman(AM))
			var/mob/living/human/H = AM
			if(H.m_intent == "run")
				triggered(H)
				H.visible_message("<span class='warning'>[H] accidentally steps on [src].</span>", \
								  "<span class='warning'>You accidentally step on [src]</span>")
		if(ismouse(AM))
			triggered(AM)
	..()

/obj/item/device/assembly/mousetrap/on_found(var/mob/living/finder)
	if(armed)
		finder.visible_message("<span class='warning'>[finder] accidentally sets off [src], breaking their fingers.</span>", \
							   "<span class='warning'>You accidentally trigger [src]!</span>")
		triggered(finder, finder.hand ? "l_hand" : "r_hand")
		return 1	//end the search!
	return 0

/obj/item/device/assembly/mousetrap/hitby(var/atom/movable/A)
	if(!armed)
		return ..()
	visible_message("<span class='warning'>[src] is triggered by [A].</span>")
	triggered(null)

/obj/item/device/assembly/mousetrap/armed
	icon_state = "mousetraparmed"
	armed = 1

/obj/item/device/assembly/mousetrap/verb/hide_under()
	set src in oview(1)
	set name = "Hide"
	set category = "Object"

	if(usr.stat)
		return

	layer = HIDING_LAYER
	to_chat(usr, "<span class='notice'>You hide [src].</span>")