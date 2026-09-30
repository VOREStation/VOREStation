/*
	Animals
*/
/mob/living/simple_mob/UnarmedAttack(atom/A, proximity)
	if(!(. = ..()))
		return

//	setClickCooldown(get_attack_speed())

	if(has_hands && istype(A,/obj) && a_intent != I_HURT)
		var/obj/O = A
		return O.attack_hand(src)

	switch(a_intent)
		if(I_HELP)

			if(isliving(A))
				var/mob/living/L = A
				if(istype(L) && (!has_hands || !L.attempt_to_scoop(src)))
					if(src.zone_sel.selecting == BP_GROIN)
						if(src.vore_bellyrub(A))
							return
					automatic_custom_emote(VISIBLE_MESSAGE,"[pick(friendly)] \the [A]!", check_stat = TRUE)
			if(istype(A,/obj/structure/micro_tunnel))	//Allows simplemobs to click on mouse holes, mice should be allowed to go in mouse holes, and other mobs
				var/obj/structure/micro_tunnel/t = A	//should be allowed to drag the mice out of the mouse holes!
				t.tunnel_interact(src)
			if(istype(A,/obj/item/reagent_containers/food/snacks))
				var/obj/item/reagent_containers/food/snacks/snack = A
				snack.attack_generic(src)
				setClickCooldown(get_attack_speed(src))

		if(I_HURT)
			if(can_special_attack(A) && special_attack_target(A))
				return

			else if(melee_damage_upper == 0 && isliving(A))
				automatic_custom_emote(VISIBLE_MESSAGE,"[pick(friendly)] \the [A]!", check_stat = TRUE)

			else
				attack_target(A)

		if(I_GRAB)
			if(has_hands)
				A.attack_hand(src)
			else if(isliving(A) && src.client && !vore_attack_override)
				animal_nom(A)
			else if(isitem(A))
				var/obj/item/snack = A
				if(!snack.check_item_devourability(src))
					return
				visible_message(span_warning("\The [src] is attempting to [vore_selected.vore_verb] \the [snack]"))
				do_windup_animation(A, 1 SECOND) //Mlaaaah...
				setClickCooldown(get_attack_speed(src))
				if(!do_after(src, 1 SECOND, A))
					animate(src) //Cancel the windup animation if we're interrupted
					return
				do_attack_animation(A, TRUE) //Homph.~
				eat_trash_proc(A)

		if(I_DISARM)
			if(has_hands)
				A.attack_hand(src)

/mob/living/simple_mob/RangedAttack(atom/A)
//	setClickCooldown(get_attack_speed())

	if(can_special_attack(A) && special_attack_target(A))
		return

	if(projectiletype)
		shoot_target(A)
