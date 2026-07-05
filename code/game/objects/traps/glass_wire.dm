/obj/item/material/barbedwire/glass
	name = "glass wire"
	desc = "Thin webs of strewn glass, very easy to break."
	icon = 'icons/obj/traps/abberations.dmi'
	icon_state = "abb_glass"
	default_material = MAT_GLASS
	applies_material_colour = FALSE
	named_from_material = FALSE
	drops_debris = FALSE

/obj/item/material/barbedwire/glass/start_active
	anchored = TRUE

/obj/item/material/barbedwire/glass/start_active/Initialize(mapload, material_key)
	. = ..()
	update_icon()

/obj/item/material/barbedwire/glass/attack_hand(mob/user)
	playsound(src, 'sound/effects/glass_step.ogg', 50, 1)
	user.visible_message(
		span_danger("[user] touches \the [src] and it shatters."),
		span_notice("You touch \the [src] and it shatters!")
		)
	//also cut hands if gloves are not thick, TODO.
	health = 0 //Instantly shatters.
	check_health()
	return

/obj/item/material/barbedwire/glass/attackby(obj/item/W, mob/user)
	if(!istype(W))
		return

	user.setClickCooldown(user.get_attack_speed(W))
	user.do_attack_animation(src)
	playsound(src, 'sound/effects/grillehit.ogg', 40, 1)
	health = 0 //Instantly shatters.
	check_health()

/obj/item/material/barbedwire/glass/update_icon()
	..()
	icon_state = "abb_glass"

/obj/item/material/barbedwire/glass/Crossed(atom/movable/AM)
	if(AM.is_incorporeal())
		return
	if(anchored)
		if(isliving(AM))
			var/mob/living/L = AM
			L.visible_message(
				span_danger("[L] steps in \the [src]."),
				span_danger("You step in \the [src]!"),
				span_infoplain(span_bold("You hear a sharp rustling!"))
				)
			attack_mob(L)
			update_icon()
		else
			health = 0
			check_health()

/obj/item/material/barbedwire/glass/attack_mob(mob/living/L)
	L.add_modifier(/datum/modifier/entangled, 3 SECONDS)

	var/target_zone = ran_zone()
	var/obj/item/organ/external/affecting = L.get_organ(target_zone)

	//armour
	var/blocked = L.run_armor_check(target_zone, "melee")
	if(!affecting) //touched a limb that doesn't exist
		break_wire()
		to_chat(L, span_danger("You narrowly avoid being cut by \the [src]!"))
		return

	//Check the list of clothing for thick materials.
	var/list/our_clothing = affecting.get_covering_clothing()
	for(var/obj/item/clothing/gear in our_clothing)
		if(gear.item_flags & THICKMATERIAL)
			break_wire()
			to_chat(L, span_danger("Your [gear] snags on \the [src], shattering it and protecting you!"))
			return

	if(blocked >= 100)
		break_wire()
		to_chat(L, span_danger("Your equipment protects you from \the [src]!"))
		return

	if(!L.apply_damage(force * (issilicon(L) ? 0.25 : 1), BRUTE, target_zone, blocked, sharp, edge, src))
		break_wire()
		to_chat(L, span_danger("You narrowly avoid being cut by \the [src]!"))
		return

	to_chat(L, span_danger("You're cut by \the [src]!"))

	if(ishuman(L))
		var/mob/living/carbon/human/human_target = L
		if(affecting && (affecting.robotic < ORGAN_ROBOT))
			affecting.take_damage(brute = force, sharp = TRUE, edge = TRUE, used_weapon = "Glass strands")
			affecting.open = TRUE
			human_target.UpdateDamageIcon()
			human_target.updatehealth()

	break_wire()
	return

/obj/item/material/barbedwire/glass/proc/break_wire()
	playsound(src, 'sound/effects/glass_step.ogg', 50, 1)
	health = 0
	check_health()
