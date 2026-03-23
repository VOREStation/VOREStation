/*
 * Trays - Agouri
 */
/obj/item/tray
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
	var/min_bonus_damage = 3
	var/max_bonus_damage = 5
	COOLDOWN_DECLARE(shield_bash)
	drop_sound = 'sound/items/trayhit1.ogg'

/obj/item/tray/attack(mob/living/carbon/M, mob/living/carbon/user)
	var/tray_sound = pick('sound/items/trayhit1.ogg', 'sound/items/trayhit2.ogg')
	//var/attack_area = user.zone_sel.selecting
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


	if(CLUMSY_FAIL_CHANCE(user))              //What if he's a clown?
		to_chat(M, span_warning("You accidentally slam yourself with the [src]!"))
		M.Weaken(1)
		user.take_organ_damage(2)
		playsound(src, tray_sound, 50, 1)
		return

	var/face_hit = FALSE

	if(!(user.zone_sel.selecting == O_EYES) && !(user.zone_sel.selecting == BP_HEAD) && !(user.zone_sel.selecting == O_MOUTH))
		add_attack_logs(user,M,"Hit with [src]")
		if(prob(15))
			M.Weaken(3)

	else
		//attack_area = BP_HEAD //Ensure we're hitting a valid area.
		face_hit = TRUE //Our head is being hit! Let's presume we got hit in the face until we are told otherwise.
		for(var/slot in list(slot_head, slot_wear_mask, slot_glasses))
			var/obj/item/protection = M.get_equipped_item(slot)
			if(istype(protection) && (protection.body_parts_covered & FACE))
				face_hit = FALSE
				break


		if(face_hit) //No eye or head protection, tough luck!
			to_chat(M, span_warning("You get slammed in the face with the tray!"))
			//user.apply_damage(rand(min_bonus_damage, max_bonus_damage), BRUTE, attack_area) //How to make it take armor into account.
			M.take_organ_damage(rand(min_bonus_damage, max_bonus_damage)) //This gets double damage. One here and one below.
			if(prob(30))
				M.Stun(rand(2,4))
			else if(prob(30))
				M.Weaken(2)
		else
			to_chat(M, span_warning("You get slammed in the face with the tray, against your mask!"))
			if(M.wear_mask && prob(33))
				M.wear_mask.add_blood(M)
			if(ishuman(M))
				var/mob/living/carbon/human/H = M
				if(H.head && prob(33))
					H.head.add_blood(H)
				if(H.glasses && prob(33))
					H.glasses.add_blood(H)

			if(prob(10))
				M.Stun(rand(1,3))
	if(prob(33))
		add_blood(M)
		var/turf/location = get_turf(M)
		if(issimulatedturf(location))
			location.add_blood(M)

	playsound(src, tray_sound, 50, 1)
	user.visible_message(span_danger("[user] slams [M] [face_hit ? "" : "in the face "]with the tray!"), runemessage = "CLANG!")
	//user.apply_damage(rand(min_bonus_damage, max_bonus_damage), BRUTE, attack_area)
	M.take_organ_damage(rand(min_bonus_damage, max_bonus_damage))
	return

/obj/item/tray/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W, /obj/item/material/kitchen/rollingpin))
		if(!COOLDOWN_FINISHED(src, shield_bash))
			return
		user.visible_message(span_warning("[user] bashes [src] with [W]!"))
		playsound(src, 'sound/effects/shieldbash.ogg', 50, 1)
		COOLDOWN_START(src, shield_bash, 2.5 SECONDS)
	else
		..()

/*
===============~~~~~================================~~~~~====================
=																			=
=  Code for trays carrying things. By Doohl for Doohl erryday Doohl Doohl~  =
=																			=
===============~~~~~================================~~~~~====================
*/
/obj/item/tray/proc/calc_carry()
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

/obj/item/tray/pickup(mob/user)

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
			if(istype(I, /obj/item/material))
				var/obj/item/material/O = I
				if(O.applies_material_colour)
					Img.color = O.color
			add_overlay(Img)

/obj/item/tray/dropped(mob/user)
	..()
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
