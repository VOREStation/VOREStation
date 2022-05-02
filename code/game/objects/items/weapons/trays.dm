/*
 * Trays - Agouri
 */
/obj/item/weapon/tray
	name = "tray"
	icon = 'icons/obj/food.dmi'
	icon_state = "tray"
	desc = "A metal tray to lay food on."
	throwforce = 12.0
	throwforce = 10.0
	throw_speed = 1
	throw_range = 5
	w_class = ITEMSIZE_NORMAL
	matter = list(MAT_STEEL = 3000)
	var/list/carrying = list() // List of things on the tray. - Doohl
	var/max_carry = 10
	drop_sound = 'sound/items/trayhit1.ogg'

<<<<<<< HEAD
/obj/item/weapon/tray/attack(mob/living/carbon/M as mob, mob/living/carbon/user as mob)
=======
/obj/item/tray/attack(mob/living/human/M as mob, mob/living/human/user as mob)
>>>>>>> 666428014d2... Merge pull request #8546 from Atermonera/surgery_refactor
	user.setClickCooldown(user.get_attack_speed(src))
	// Drop all the things. All of them.
	cut_overlays()
	for(var/obj/item/I in carrying)
		I.loc = M.loc
		carrying.Remove(I)
		if(isturf(I.loc))
			spawn()
				for(var/i = 1, i <= rand(1,2), i++)
					if(I)
						step(I, pick(NORTH,SOUTH,EAST,WEST))
						sleep(rand(2,4))


	if((CLUMSY in user.mutations) && prob(50))              //What if he's a clown?
		to_chat(M, "<span class='warning'>You accidentally slam yourself with the [src]!</span>")
		M.Weaken(1)
		user.take_organ_damage(2)
		if(prob(50))
			playsound(src, 'sound/items/trayhit1.ogg', 50, 1)
			return
		else
			playsound(src, 'sound/items/trayhit2.ogg', 50, 1) //sound playin'
			return //it always returns, but I feel like adding an extra return just for safety's sakes. EDIT; Oh well I won't :3

	var/mob/living/human/H = M      ///////////////////////////////////// /Let's have this ready for later.


	if(!(user.zone_sel.selecting == (O_EYES || BP_HEAD))) //////////////hitting anything else other than the eyes
		if(prob(33))
			src.add_blood(H)
			var/turf/location = H.loc
			if (istype(location, /turf/simulated))
				location.add_blood(H)     ///Plik plik, the sound of blood

		add_attack_logs(user,M,"Hit with [src]")

		if(prob(15))
			M.Weaken(3)
			M.take_organ_damage(3)
		else
			M.take_organ_damage(5)
		if(prob(50))
			playsound(src, 'sound/items/trayhit1.ogg', 50, 1)
			for(var/mob/O in viewers(M, null))
				O.show_message(text("<span class='danger'>[] slams [] with the tray!</span>", user, M), 1)
			return
		else
			playsound(src, 'sound/items/trayhit2.ogg', 50, 1)  //we applied the damage, we played the sound, we showed the appropriate messages. Time to return and stop the proc
			for(var/mob/O in viewers(M, null))
				O.show_message(text("<span class='danger'>[] slams [] with the tray!</span>", user, M), 1)
			return


	var/protected = 0
	for(var/slot in list(slot_head, slot_wear_mask, slot_glasses))
		var/obj/item/protection = M.get_equipped_item(slot)
		if(istype(protection) && (protection.body_parts_covered & FACE))
			protected = 1
			break

	if(protected)
		to_chat(M, "<span class='warning'>You get slammed in the face with the tray, against your mask!</span>")
		if(prob(33))
			src.add_blood(H)
			if (H.wear_mask)
				H.wear_mask.add_blood(H)
			if (H.head)
				H.head.add_blood(H)
			if (H.glasses && prob(33))
				H.glasses.add_blood(H)
			var/turf/location = H.loc
			if (istype(location, /turf/simulated))     //Addin' blood! At least on the floor and item :v
				location.add_blood(H)

		if(prob(50))
			playsound(src, 'sound/items/trayhit1.ogg', 50, 1)
			for(var/mob/O in viewers(M, null))
				O.show_message(text("<span class='danger'>[] slams [] with the tray!</span>", user, M), 1)
		else
			playsound(src, 'sound/items/trayhit2.ogg', 50, 1)  //sound playin'
			for(var/mob/O in viewers(M, null))
				O.show_message(text("<span class='danger'>[] slams [] with the tray!</span>", user, M), 1)
		if(prob(10))
			M.Stun(rand(1,3))
			M.take_organ_damage(3)
			return
		else
			M.take_organ_damage(5)
			return

	else //No eye or head protection, tough luck!
		to_chat(M, "<span class='warning'>You get slammed in the face with the tray!</span>")
		if(prob(33))
			src.add_blood(M)
			var/turf/location = H.loc
			if (istype(location, /turf/simulated))
				location.add_blood(H)

		if(prob(50))
			playsound(src, 'sound/items/trayhit1.ogg', 50, 1)
			for(var/mob/O in viewers(M, null))
				O.show_message(text("<span class='danger'>[] slams [] in the face with the tray!</span>", user, M), 1)
		else
			playsound(src, 'sound/items/trayhit2.ogg', 50, 1)  //sound playin' again
			for(var/mob/O in viewers(M, null))
				O.show_message(text("<span class='danger'>[] slams [] in the face with the tray!</span>", user, M), 1)
		if(prob(30))
			M.Stun(rand(2,4))
			M.take_organ_damage(4)
			return
		else
			M.take_organ_damage(8)
			if(prob(30))
				M.Weaken(2)
				return
			return

/obj/item/weapon/tray/var/cooldown = 0	//shield bash cooldown. based on world.time

/obj/item/weapon/tray/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(istype(W, /obj/item/weapon/material/kitchen/rollingpin))
		if(cooldown < world.time - 25)
			user.visible_message("<span class='warning'>[user] bashes [src] with [W]!</span>")
			playsound(src, 'sound/effects/shieldbash.ogg', 50, 1)
			cooldown = world.time
	else
		..()

/*
===============~~~~~================================~~~~~====================
=																			=
=  Code for trays carrying things. By Doohl for Doohl erryday Doohl Doohl~  =
=																			=
===============~~~~~================================~~~~~====================
*/
/obj/item/weapon/tray/proc/calc_carry()
	// calculate the weight of the items on the tray
	var/val = 0 // value to return

	for(var/obj/item/I in carrying)
		if(I.w_class == ITEMSIZE_TINY)
			val ++
		else if(I.w_class == ITEMSIZE_SMALL)
			val += 3
		else
			val += 5

	return val

/obj/item/weapon/tray/pickup(mob/user)

	if(!isturf(loc))
		return

	for(var/obj/item/I in loc)
		if( I != src && !I.anchored && !istype(I, /obj/item/clothing/under) && !istype(I, /obj/item/clothing/suit) && !istype(I, /obj/item/projectile) )
			var/add = 0
			if(I.w_class == ITEMSIZE_TINY)
				add = 1
			else if(I.w_class == ITEMSIZE_SMALL)
				add = 3
			else
				add = 5
			if(calc_carry() + add >= max_carry)
				break
			var/image/Img = new(src.icon)
			I.loc = src
			carrying.Add(I)
			Img.icon = I.icon
			Img.icon_state = I.icon_state
			Img.layer = layer + I.layer*0.01
			if(istype(I, /obj/item/weapon/material))
				var/obj/item/weapon/material/O = I
				if(O.applies_material_colour)
					Img.color = O.color
			add_overlay(Img)

/obj/item/weapon/tray/dropped(mob/user)
	var/noTable = null

	spawn() //Allows the tray to udpate location, rather than just checking against mob's location
		if(isturf(src.loc) && !(locate(/obj/structure/table) in src.loc))
			noTable = 1

		if(isturf(loc) && !(locate(/mob/living) in src.loc))
			cut_overlays()
			for(var/obj/item/I in carrying)
				I.forceMove(src.loc)
				carrying.Remove(I)
				if(noTable)
					for(var/i = 1, i <= rand(1,2), i++)
						if(I)
							step(I, pick(NORTH,SOUTH,EAST,WEST))
							sleep(rand(2,4))
