
/*
 * Beartraps.
 * Buckles crossing individuals, doing moderate brute damage.
 */

/obj/item/weapon/beartrap
	name = "mechanical trap"
	throw_speed = 2
	throw_range = 1
	gender = PLURAL
	icon = 'icons/obj/items.dmi'
	icon_state = "beartrap0"
	desc = "A mechanically activated leg trap. Low-tech, but reliable. Looks like it could really hurt if you set it off."
	randpixel = 0
	center_of_mass = null
	throwforce = 0
	w_class = ITEMSIZE_NORMAL
	origin_tech = list(TECH_MATERIAL = 1)
	matter = list(MAT_STEEL = 18750)
	var/deployed = 0
	var/camo_net = FALSE
	var/stun_length = 0.25 SECONDS

/obj/item/weapon/beartrap/proc/can_use(mob/user)
	return (user.IsAdvancedToolUser() && !issilicon(user) && !user.stat && !user.restrained())

/obj/item/weapon/beartrap/attack_self(mob/user as mob)
	..()
	if(!deployed && can_use(user))
		user.visible_message(
			"<span class='danger'>[user] starts to deploy \the [src].</span>",
			"<span class='danger'>You begin deploying \the [src]!</span>",
			"You hear the slow creaking of a spring."
			)

		if (do_after(user, 60))
			user.visible_message(
				"<span class='danger'>[user] has deployed \the [src].</span>",
				"<span class='danger'>You have deployed \the [src]!</span>",
				"You hear a latch click loudly."
				)
			playsound(src, 'sound/machines/click.ogg',70, 1)

			deployed = 1
			user.drop_from_inventory(src)
			update_icon()
			anchored = TRUE

/obj/item/weapon/beartrap/attack_hand(mob/user as mob)
	if(has_buckled_mobs() && can_use(user))
		var/victim = english_list(buckled_mobs)
		user.visible_message(
			"<span class='notice'>[user] begins freeing [victim] from \the [src].</span>",
			"<span class='notice'>You carefully begin to free [victim] from \the [src].</span>",
			)
		if(do_after(user, 60))
			user.visible_message("<span class='notice'>[victim] has been freed from \the [src] by [user].</span>")
			for(var/A in buckled_mobs)
				unbuckle_mob(A)
			anchored = FALSE
	else if(deployed && can_use(user))
		user.visible_message(
			"<span class='danger'>[user] starts to disarm \the [src].</span>",
			"<span class='notice'>You begin disarming \the [src]!</span>",
			"You hear a latch click followed by the slow creaking of a spring."
			)
		playsound(src, 'sound/machines/click.ogg', 50, 1)

		if(do_after(user, 60))
			user.visible_message(
				"<span class='danger'>[user] has disarmed \the [src].</span>",
				"<span class='notice'>You have disarmed \the [src]!</span>"
				)
			deployed = 0
			anchored = FALSE
			update_icon()
	else
		..()

/obj/item/weapon/beartrap/proc/attack_mob(mob/living/L)

	var/target_zone
	if(L.lying)
		target_zone = ran_zone()
	else
		target_zone = pick("l_foot", "r_foot", "l_leg", "r_leg")

	//armour
	var/blocked = L.run_armor_check(target_zone, "melee")
	var/soaked = L.get_armor_soak(target_zone, "melee")

	if(blocked >= 100)
		return

	if(soaked >= 30)
		return

	if(!L.apply_damage(30, BRUTE, target_zone, blocked, soaked, used_weapon=src))
		return 0

	if(ishuman(L))
		var/mob/living/human/H = L
		var/obj/item/organ/external/affected = H.get_organ(check_zone(target_zone))
		if(!affected) // took it clean off!
			to_chat(H, "<span class='danger'>The steel jaws of \the [src] take your limb clean off!</span>")
			L.Stun(stun_length*2)
			deployed = 0
			anchored = FALSE
			return

	//trap the victim in place
	set_dir(L.dir)
	can_buckle = TRUE
	buckle_mob(L)
	L.Stun(stun_length)
	to_chat(L, "<span class='danger'>The steel jaws of \the [src] bite into you, trapping you in place!</span>")
	deployed = 0
	anchored = FALSE
	can_buckle = initial(can_buckle)

/obj/item/weapon/beartrap/Crossed(atom/movable/AM as mob|obj)
	if(AM.is_incorporeal())
		return
	if(deployed && isliving(AM))
		var/mob/living/L = AM
		if(L.m_intent == "run")
			L.visible_message(
				"<span class='danger'>[L] steps on \the [src].</span>",
				"<span class='danger'>You step on \the [src]!</span>",
				"<b>You hear a loud metallic snap!</b>"
				)
			attack_mob(L)
			if(!has_buckled_mobs())
				anchored = FALSE
			deployed = 0
			update_icon()
	..()

/obj/item/weapon/beartrap/update_icon()
	..()

	if(!deployed)
		if(camo_net)
			alpha = 255

		icon_state = "beartrap0"
	else
		if(camo_net)
			alpha = 50

		icon_state = "beartrap1"

/obj/item/weapon/beartrap/hunting
	name = "hunting trap"
	desc = "A mechanically activated leg trap. High-tech and reliable. Looks like it could really hurt if you set it off."
	stun_length = 1 SECOND
	camo_net = TRUE
	color = "#C9DCE1"

	origin_tech = list(TECH_MATERIAL = 4, TECH_BLUESPACE = 3, TECH_MAGNET = 4, TECH_PHORON = 2, TECH_ARCANE = 1)

/*
 * Barbed-Wire.
 * Slows individuals crossing it. Barefoot individuals will be cut. Can be electrified by placing over a cable node.
 */

/obj/item/weapon/material/barbedwire
	name = "barbed wire"
	desc = "A coil of wire."
	icon = 'icons/obj/trap.dmi'
	icon_state = "barbedwire"
	anchored = FALSE
	layer = TABLE_LAYER
	w_class = ITEMSIZE_LARGE
	explosion_resistance = 1
	can_dull = TRUE
	fragile = TRUE
	force_divisor = 0.20
	thrown_force_divisor = 0.25

	sharp = TRUE

/obj/item/weapon/material/barbedwire/set_material(var/new_material)
	..()

	if(!QDELETED(src))
		health = round(material.integrity / 3)
		name = (material.get_edge_damage() * force_divisor > 15) ?  "[material.display_name] razor wire" : "[material.display_name] [initial(name)]"

/obj/item/weapon/material/barbedwire/proc/can_use(mob/user)
	return (user.IsAdvancedToolUser() && !issilicon(user) && !user.stat && !user.restrained())

/obj/item/weapon/material/barbedwire/attack_hand(mob/user as mob)
	if(anchored && can_use(user))
		user.visible_message(
			"<span class='danger'>[user] starts to collect \the [src].</span>",
			"<span class='notice'>You begin collecting \the [src]!</span>",
			"You hear the sound of rustling [material.name]."
			)
		playsound(src, 'sound/machines/click.ogg', 50, 1)

		if(do_after(user, health))
			user.visible_message(
				"<span class='danger'>[user] has collected \the [src].</span>",
				"<span class='notice'>You have collected \the [src]!</span>"
				)
			anchored = FALSE
			update_icon()
	else
		..()

/obj/item/weapon/material/barbedwire/attack_self(mob/user as mob)
	..()
	if(!anchored && can_use(user))
		user.visible_message(
			"<span class='danger'>[user] starts to deploy \the [src].</span>",
			"<span class='danger'>You begin deploying \the [src]!</span>",
			"You hear the rustling of [material.name]."
			)

		if (do_after(user, 60))
			user.visible_message(
				"<span class='danger'>[user] has deployed \the [src].</span>",
				"<span class='danger'>You have deployed \the [src]!</span>",
				"You hear the rustling of [material.name]."
				)
			playsound(src, 'sound/items/Wirecutter.ogg',70, 1)
			spawn(2)
				playsound(src, 'sound/items/Wirecutter.ogg',40, 1)
			user.drop_from_inventory(src)
			forceMove(get_turf(src))
			anchored = TRUE
			update_icon()

/obj/item/weapon/material/barbedwire/attackby(obj/item/W as obj, mob/user as mob)
	if(!istype(W))
		return

	if((W.flags & NOCONDUCT) || !shock(user, 70, pick(BP_L_HAND, BP_R_HAND)))
		user.setClickCooldown(user.get_attack_speed(W))
		user.do_attack_animation(src)
		playsound(src, 'sound/effects/grillehit.ogg', 40, 1)

		var/inc_damage = W.force

		if(W.is_wirecutter())
			if(!shock(user, 100, pick(BP_L_HAND, BP_R_HAND)))
				playsound(src, W.usesound, 100, 1)
				inc_damage *= 3

		if(W.damtype != BRUTE)
			inc_damage *= 0.3

		health -= inc_damage

	check_health()

	..()

/obj/item/weapon/material/barbedwire/update_icon()
	..()

	if(anchored)
		icon_state = "[initial(icon_state)]-out"
	else
		icon_state = "[initial(icon_state)]"

/obj/item/weapon/material/barbedwire/Crossed(atom/movable/AM as mob|obj)
	if(AM.is_incorporeal())
		return
	if(anchored && isliving(AM))
		var/mob/living/L = AM
		if(L.m_intent == "run")
			L.visible_message(
				"<span class='danger'>[L] steps in \the [src].</span>",
				"<span class='danger'>You step in \the [src]!</span>",
				"<b>You hear a sharp rustling!</b>"
				)
			attack_mob(L)
			update_icon()
	..()

/obj/item/weapon/material/barbedwire/proc/shock(mob/user as mob, prb, var/target_zone = BP_TORSO)
	if(!anchored || health == 0)		// anchored/destroyed grilles are never connected
		return 0
	if(material.conductivity <= 0)
		return 0
	if(!prob(prb))
		return 0
	if(!in_range(src, user))//To prevent TK and mech users from getting shocked
		return 0
	var/turf/T = get_turf(src)
	var/obj/structure/cable/C = T.get_cable_node()
	if(C)
		if(C.powernet)
			var/datum/powernet/PN = C.powernet

			if(PN)
				PN.trigger_warning()

				var/PN_damage = PN.get_electrocute_damage() * (material.conductivity / 50)

				var/drained_energy = PN_damage * 10 / CELLRATE

				PN.draw_power(drained_energy)

				if(ishuman(user))
					var/mob/living/human/H = user

					var/obj/item/organ/external/affected = H.get_organ(check_zone(target_zone))

					H.electrocute_act(PN_damage, src, H.get_siemens_coefficient_organ(affected))

				else
					if(isliving(user))
						var/mob/living/L = user
						L.electrocute_act(PN_damage, src, 0.8)

			var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
			s.set_up(3, 1, src)
			s.start()
			if(user.stunned)
				return 1
		else
			return 0
	return 0

/obj/item/weapon/material/barbedwire/proc/attack_mob(mob/living/L)
	var/target_zone
	if(L.lying)
		target_zone = ran_zone()
	else
		target_zone = pick("l_foot", "r_foot", "l_leg", "r_leg")

	//armour
	var/blocked = L.run_armor_check(target_zone, "melee")
	var/soaked = L.get_armor_soak(target_zone, "melee")

	if(blocked >= 100)
		return

	if(soaked >= 30)
		return

	if(L.buckled) //wheelchairs, office chairs, rollerbeds
		return

	shock(L, 100, target_zone)

	L.add_modifier(/datum/modifier/entangled, 3 SECONDS)

	if(!L.apply_damage(force * (issilicon(L) ? 0.25 : 1), BRUTE, target_zone, blocked, soaked, src, sharp, edge))
		return

	playsound(src, 'sound/effects/glass_step.ogg', 50, 1) // not sure how to handle metal shards with sounds
	if(ishuman(L))
		var/mob/living/human/H = L

		if(H.species.siemens_coefficient<0.5) //Thick skin.
			return

		if( H.shoes || ( H.wear_suit && (H.wear_suit.body_parts_covered & FEET) ) )
			return

		if(H.species.flags & NO_MINOR_CUT)
			return

		to_chat(H, "<span class='danger'>You step directly on \the [src]!</span>")

		var/list/check = list("l_foot", "r_foot")
		while(check.len)
			var/picked = pick(check)
			var/obj/item/organ/external/affecting = H.get_organ(picked)
			if(affecting)
				if(affecting.robotic >= ORGAN_ROBOT)
					return
				if(affecting.take_damage(force, 0))
					H.UpdateDamageIcon()
				H.updatehealth()
				if(affecting.organ_can_feel_pain())
					H.Weaken(3)
				return
			check -= picked

	if(material.is_brittle() && prob(material.hardness))
		health = 0
	else if(!prob(material.hardness))
		health--
	check_health()

	return

/obj/item/weapon/material/barbedwire/plastic
	name = "snare wire"
	default_material = MAT_PLASTIC
