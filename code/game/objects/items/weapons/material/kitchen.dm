/obj/item/weapon/material/kitchen
	icon = 'icons/obj/kitchen.dmi'

/*
 * Utensils
 */
/obj/item/weapon/material/kitchen/utensil
	drop_sound = 'sound/items/drop/knife.ogg'
	pickup_sound = 'sound/items/pickup/knife.ogg'
	w_class = ITEMSIZE_TINY
	thrown_force_divisor = 1
	origin_tech = list(TECH_MATERIAL = 1)
	attack_verb = list("attacked", "stabbed", "poked")
	sharp = TRUE
	edge = TRUE
	force_divisor = 0.1 // 6 when wielded with hardness 60 (steel)
	thrown_force_divisor = 0.25 // 5 when thrown with weight 20 (steel)
	var/weakref/loaded //Weakref for currently loaded food object.

/obj/item/weapon/material/kitchen/utensil/New()
	..()
	if (prob(60))
		src.pixel_y = rand(0, 4)
	create_reagents(5)
	return

/obj/item/weapon/material/kitchen/utensil/update_icon()
	. = ..()
	cut_overlays()
	var/obj/item/weapon/reagent_containers/food/snacks/eaten = loaded?.resolve()
	if(eaten)
		var/image/I = new(icon, "loadedfood")
		I.color = eaten.filling_color
		add_overlay(I)

/obj/item/weapon/material/kitchen/utensil/attack(mob/living/carbon/M as mob, mob/living/carbon/user as mob)
	if(!istype(M))
		return ..()

	if(user.a_intent != I_HELP)
		if(user.zone_sel.selecting == BP_HEAD || user.zone_sel.selecting == O_EYES)
			if((CLUMSY in user.mutations) && prob(50))
				M = user
			return eyestab(M,user)
		else
			return ..()

	if (loaded && reagents.total_volume > 0)
		var/atom/movable/eaten = loaded?.resolve()
		reagents.trans_to_mob(M, reagents.total_volume, CHEM_INGEST)
		if(eaten)	
			if(M == user)
				if(!M.can_eat(eaten))
					return
				M.visible_message(SPAN_NOTICE("\The [user] eats some of \the [eaten] with \the [src]."))
			else
				user.visible_message(SPAN_WARNING("\The [user] begins to feed \the [M]!"))
				if(!(M.can_force_feed(user, eaten) && do_mob(user, M, 5 SECONDS)))
					return
				M.visible_message(SPAN_NOTICE("\The [user] feeds some of \the [eaten] to \the [M] with \the [src]."))
			playsound(src,'sound/items/eatfood.ogg', rand(10,40), 1)
		update_icon()
		return
	else
		to_chat(user, SPAN_WARNING("You don't have anything on \the [src]."))	//if we have help intent and no food scooped up DON'T STAB OURSELVES WITH THE FORK
		return

/obj/item/weapon/material/kitchen/utensil/fork
	name = "fork"
	desc = "It's a fork. Sure is pointy."
	icon_state = "fork"
	sharp = TRUE
	edge = FALSE

/obj/item/weapon/material/kitchen/utensil/fork/plastic
	default_material = "plastic"

/obj/item/weapon/material/kitchen/utensil/spoon
	name = "spoon"
	desc = "It's a spoon. You can see your own upside-down face in it."
	icon_state = "spoon"
	attack_verb = list("attacked", "poked")
	edge = FALSE
	sharp = FALSE
	force_divisor = 0.1 //2 when wielded with weight 20 (steel)

/obj/item/weapon/material/kitchen/utensil/spoon/plastic
	default_material = "plastic"

/*
 * Knives
 */

/* From the time of Clowns. Commented out for posterity, and sanity.
/obj/item/weapon/material/knife/attack(target as mob, mob/living/user as mob)
	if ((CLUMSY in user.mutations) && prob(50))
		to_chat(user, "<span class='warning'>You accidentally cut yourself with \the [src].</span>")
		user.take_organ_damage(20)
		return
	return ..()
*/
/obj/item/weapon/material/knife/plastic
	default_material = "plastic"

/*
 * Rolling Pins
 */

/obj/item/weapon/material/kitchen/rollingpin
	name = "rolling pin"
	desc = "Used to knock out the Bartender."
	icon_state = "rolling_pin"
	attack_verb = list("bashed", "battered", "bludgeoned", "thrashed", "whacked")
	default_material = "wood"
	force_divisor = 0.7 // 10 when wielded with weight 15 (wood)
	dulled_divisor = 0.75	// Still a club
	thrown_force_divisor = 1 // as above
	drop_sound = 'sound/items/drop/wooden.ogg'
	pickup_sound = 'sound/items/pickup/wooden.ogg'

/obj/item/weapon/material/kitchen/rollingpin/attack(mob/living/M as mob, mob/living/user as mob)
	if ((CLUMSY in user.mutations) && prob(50))
		to_chat(user, "<span class='warning'>\The [src] slips out of your hand and hits your head.</span>")
		user.take_organ_damage(10)
		user.Paralyse(2)
		return
	return ..()
