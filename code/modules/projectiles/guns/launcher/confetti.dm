//The confetti cannon is a simple weapon meant to be a toy. You shoot confetti at people and it makes a funny sound. Don't give this any combat use.
/obj/item/weapon/gun/launcher/confetti_cannon
	name = "confetti cannon"
	desc = "For those times when you absolutely need colored paper everywhere."
	icon = 'icons/obj/weapons_vr.dmi'
	icon_state = "confetti_cannon"
	item_state = "confetti_cannon"
	w_class = ITEMSIZE_NORMAL
	origin_tech = list(TECH_COMBAT = 1, TECH_MATERIAL = 2)
	throw_distance = 7
	release_force = 5
	var/obj/item/weapon/grenade/confetti/party_ball/chambered = null

	var/confetti_charge = 0
	var/max_confetti = 20

/obj/item/weapon/gun/launcher/confetti_cannon/examine(mob/user)
	. = ..()
	if(get_dist(user, src) <= 2)
		. += span_blue("It's loaded with [confetti_charge] ball\s of confetti.")

/obj/item/weapon/gun/launcher/confetti_cannon/attackby(obj/item/I as obj, mob/user as mob)
	if(istype(I, /obj/item/weapon/paper) || istype(I, /obj/item/weapon/shreddedp))
		if(confetti_charge < max_confetti)
			user.drop_item()
			++confetti_charge
			to_chat(usr, span_blue("You put the paper in the [src]."))
			qdel(I)
		else
			to_chat(usr, span_red("[src] cannot hold more paper."))

/obj/item/weapon/gun/launcher/confetti_cannon/proc/pump(mob/M as mob)
	playsound(M, 'sound/weapons/shotgunpump.ogg', 60, 1)
	if(!chambered)
		if(confetti_charge)
			chambered = new /obj/item/weapon/grenade/confetti/party_ball
			--confetti_charge
			to_chat(usr, span_blue("You compress a new confetti ball."))
		else
			to_chat(usr, span_red("The [src] is out of confetti!"))
	else
		to_chat(usr, span_red("The [src] is already loaded!"))

/obj/item/weapon/gun/launcher/confetti_cannon/attack_self(mob/user)
	pump(user)

/obj/item/weapon/gun/launcher/confetti_cannon/consume_next_projectile()
	if(chambered)
		chambered.activate(null)
	return chambered

/obj/item/weapon/gun/launcher/confetti_cannon/handle_post_fire(mob/user)
	chambered = null

/obj/item/weapon/gun/launcher/confetti_cannon/overdrive
	name = "overdrive confetti cannon"
	desc = "For those times when you absolutely need colored paper everywhere, EVERYWHERE."
	confetti_charge = 100
	max_confetti = 100

/obj/item/weapon/gun/launcher/confetti_cannon/fake_shottie
	name = "horror movie shotgun"
	desc = "The one necessary for survival of any Final Girl."
	icon = 'icons/obj/gun2.dmi'
	icon_state = "ithaca"
	item_state = "ithaca"
	confetti_charge = 20

/obj/item/weapon/gun/launcher/confetti_cannon/robot
	name = "Party Cannon"
	desc = "Confetti, pies, banana peels, chaos!"

/obj/item/weapon/gun/launcher/confetti_cannon/robot/pump(mob/M as mob)
	playsound(M, 'sound/weapons/shotgunpump.ogg', 60, 1)
	if(!chambered)
		var/choice = tgui_alert(usr, "Load the Party Canon with?", "Change What?", list("Confetti","Banana Peel","Cream Pie"))
		if(!choice)
			return
		playsound(src, 'sound/effects/pop.ogg', 50, 0)
		switch(choice)
			if("Confetti")
				chambered = new /obj/item/weapon/grenade/confetti/party_ball
				to_chat(usr, span_blue("Confetti loaded."))
				if(istype(usr,/mob/living/silicon/robot))
					var/mob/living/silicon/robot/R = usr
					R.cell.charge -= 200
			if("Banana Peel")
				chambered = new /obj/item/weapon/bananapeel
				to_chat(usr, span_blue("Banana peel loaded."))
				if(istype(usr,/mob/living/silicon/robot))
					var/mob/living/silicon/robot/R = usr
					R.cell.charge -= 200
			if("Cream Pie")
				chambered = new /obj/item/weapon/reagent_containers/food/snacks/pie
				to_chat(usr, span_blue("Banana cream pie loaded."))
				if(istype(usr,/mob/living/silicon/robot))
					var/mob/living/silicon/robot/R = usr
					R.cell.charge -= 200
	else
		to_chat(usr, span_red("The [src] is already loaded!"))

/obj/item/weapon/gun/launcher/confetti_cannon/robot/consume_next_projectile()
	if(istype(chambered,/obj/item/weapon/grenade/confetti/party_ball))
		chambered.activate(null)
	return chambered
