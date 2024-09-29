/obj/mecha/combat
	force = 30
	var/melee_cooldown = 10
	var/melee_can_hit = 1
	//var/list/destroyable_obj = list(/obj/mecha, /obj/structure/window, /obj/structure/grille, /turf/simulated/wall, /obj/structure/girder)
	internal_damage_threshold = 50
	maint_access = 0
	//add_req_access = 0
	//operation_req_access = list(access_hos)
	var/am = "d3c2fbcadca903a41161ccc9df9cf948"

	max_hull_equip = 2
	max_weapon_equip = 2
	max_utility_equip = 1
	max_universal_equip = 1
	max_special_equip = 1
	cargo_capacity = 1

	encumbrance_gap = 1.5

	starting_components = list(
		/obj/item/mecha_parts/component/hull/durable,
		/obj/item/mecha_parts/component/actuator,
		/obj/item/mecha_parts/component/armor/reinforced,
		/obj/item/mecha_parts/component/gas,
		/obj/item/mecha_parts/component/electrical
		)

/*
/obj/mecha/combat/range_action(target as obj|mob|turf)
	if(internal_damage&MECHA_INT_CONTROL_LOST)
		target = pick(view(3,target))
	if(selected_weapon)
		selected_weapon.fire(target)
	return
*/

/obj/mecha/combat/melee_action(atom/T)
	if(internal_damage&MECHA_INT_CONTROL_LOST)
		T = safepick(oview(1,src))
	if(!melee_can_hit)
		return
	if(istype(T, /mob/living))
		var/mob/living/M = T
		if(src.occupant.a_intent == I_HURT || istype(src.occupant, /mob/living/carbon/brain)) //Brains cannot change intents; Exo-piloting brains lack any form of physical feedback for control, limiting the ability to 'play nice'.
			playsound(src, 'sound/weapons/heavysmash.ogg', 50, 1)
			if(damtype == "brute")
				step_away(M,src,15)
			/*
			if(M.stat>1)
				M.gib()
				melee_can_hit = 0
				if(do_after(melee_cooldown))
					melee_can_hit = 1
				return
			*/
			if(ishuman(T))
				var/mob/living/carbon/human/H = T
	//			if (M.health <= 0) return

				var/obj/item/organ/external/temp = H.get_organ(pick(BP_TORSO, BP_TORSO, BP_TORSO, BP_HEAD))
				if(temp)
					var/update = 0
					switch(damtype)
						if("brute")
							H.Paralyse(1)
							update |= temp.take_damage(rand(force/2, force), 0)
						if("fire")
							update |= temp.take_damage(0, rand(force/2, force))
						if("tox")
							if(H.reagents)
								if(H.reagents.get_reagent_amount("carpotoxin") + force < force*2)
									H.reagents.add_reagent("carpotoxin", force)
								if(H.reagents.get_reagent_amount("cryptobiolin") + force < force*2)
									H.reagents.add_reagent("cryptobiolin", force)
						if("halloss")
							H.stun_effect_act(1, force / 2, BP_TORSO, src)
						else
							return
					if(update)	H.UpdateDamageIcon()
				H.updatehealth()

			else
				switch(damtype)
					if("brute")
						M.Paralyse(1)
						M.take_overall_damage(rand(force/2, force))
					if("fire")
						M.take_overall_damage(0, rand(force/2, force))
					if("tox")
						if(M.reagents)
							if(M.reagents.get_reagent_amount("carpotoxin") + force < force*2)
								M.reagents.add_reagent("carpotoxin", force)
							if(M.reagents.get_reagent_amount("cryptobiolin") + force < force*2)
								M.reagents.add_reagent("cryptobiolin", force)
					else
						return
				M.updatehealth()
			src.occupant_message("You hit [T].")
			src.visible_message(span_red("<b>[src.name] hits [T].</b>"))
		else
			step_away(M,src)
			src.occupant_message("You push [T] out of the way.")
			src.visible_message("[src] pushes [T] out of the way.")

		melee_can_hit = 0
		if(do_after(melee_cooldown))
			melee_can_hit = 1
		return

	else
		if(istype(T, /obj/machinery/disposal)) // Stops mechs from climbing into disposals
			return
		if(src.occupant.a_intent == I_HURT || istype(src.occupant, /mob/living/carbon/brain)) // Don't smash unless we mean it
			if(damtype == "brute")
				src.occupant_message("You hit [T].")
				src.visible_message(span_red("<b>[src.name] hits [T]</b>"))
				playsound(src, 'sound/weapons/heavysmash.ogg', 50, 1)

				if(istype(T, /obj/structure/girder))
					T:take_damage(force * 3) //Girders have 200 health by default. Steel, non-reinforced walls take four punches, girders take (with this value-mod) two, girders took five without.
				else
					T:take_damage(force)

				melee_can_hit = 0

				if(do_after(melee_cooldown))
					melee_can_hit = 1
	return

/obj/mecha/combat/moved_inside(var/mob/living/carbon/human/H as mob)
	if(..())
		if(H.client)
			H.client.mouse_pointer_icon = file("icons/mecha/mecha_mouse.dmi")
		return 1
	else
		return 0

/obj/mecha/combat/mmi_moved_inside(var/obj/item/mmi/mmi_as_oc as obj,mob/user as mob)
	if(..())
		if(occupant.client)
			occupant.client.mouse_pointer_icon = file("icons/mecha/mecha_mouse.dmi")
		return 1
	else
		return 0

/obj/mecha/combat/go_out()
	if(src.occupant && src.occupant.client)
		src.occupant.client.mouse_pointer_icon = initial(src.occupant.client.mouse_pointer_icon)
	..()
	return

/obj/mecha/combat/Topic(href,href_list)
	..()
	var/datum/topic_input/top_filter = new (href,href_list)
	if(top_filter.get("close"))
		am = null
		return
