/mob/living/bot/secbot/ed209
	name = "ED-209 Security Robot"
	desc = "A security robot.  He looks less than thrilled."
	icon = 'icons/obj/aibots.dmi'
	icon_state = "ed2090"
	density = TRUE
	health = 200
	maxHealth = 200

	is_ranged = 1
	preparing_arrest_sounds = new()

	a_intent = I_HURT
	mob_bump_flag = HEAVY
	mob_swap_flags = ~HEAVY
	mob_push_flags = HEAVY

	used_weapon = /obj/item/gun/energy/taser

	var/shot_delay = 4
	var/last_shot = 0

/mob/living/bot/secbot/ed209/update_icons()
	if(on && busy)
		icon_state = "ed209-c"
	else
		icon_state = "ed209[on]"

/mob/living/bot/secbot/ed209/explode()
	visible_message(span_warning("[src] blows apart!"))
	var/turf/Tsec = get_turf(src)

	new /obj/item/secbot_assembly/ed209_assembly(Tsec)

	var/obj/item/gun/energy/taser/G = new used_weapon(Tsec)
	G.power_supply.charge = 0
	if(prob(50))
		new /obj/item/robot_parts/l_leg(Tsec)
	if(prob(50))
		new /obj/item/robot_parts/r_leg(Tsec)
	if(prob(50))
		if(prob(50))
			new /obj/item/clothing/head/helmet(Tsec)
		else
			new /obj/item/clothing/suit/storage/vest(Tsec)

	var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
	s.set_up(3, 1, src)
	s.start()

	new /obj/effect/decal/cleanable/blood/oil(Tsec)
	return ..()

/mob/living/bot/secbot/ed209/handleRangedTarget()
	RangedAttack(target)

/mob/living/bot/secbot/ed209/RangedAttack(var/atom/A)
	if(last_shot + shot_delay > world.time)
		to_chat(src, "You are not ready to fire yet!")
		return

	last_shot = world.time

	var/projectile = /obj/item/projectile/beam/stun
	if(emagged)
		projectile = /obj/item/projectile/beam

	playsound(src, emagged ? 'sound/weapons/Laser.ogg' : 'sound/weapons/Taser.ogg', 50, 1)
	var/obj/item/projectile/P = new projectile(loc)

	P.firer = src
	P.old_style_target(A)
	P.fire()

// Assembly

/obj/item/secbot_assembly/ed209_assembly
	name = "ED-209 assembly"
	desc = "Some sort of bizarre assembly."
	icon = 'icons/obj/aibots.dmi'
	icon_state = "ed209_frame"
	item_state = "buildpipe"
	created_name = "ED-209 Security Robot"
	var/lasercolor = ""

/obj/item/secbot_assembly/ed209_assembly/attackby(var/obj/item/W, var/mob/user)
	..()

	if(istype(W, /obj/item/pen))
		var/t = sanitizeSafe(tgui_input_text(user, "Enter new robot name", name, created_name, MAX_NAME_LEN), MAX_NAME_LEN)
		if(!t)
			return
		if(!in_range(src, user) && src.loc != user)
			return
		created_name = t
		return

	switch(build_step)
		if(0, 1)
			if(istype(W, /obj/item/robot_parts/l_leg) || istype(W, /obj/item/robot_parts/r_leg) || (istype(W, /obj/item/organ/external/leg) && ((W.name == "robotic right leg") || (W.name == "robotic left leg"))))
				user.drop_item()
				qdel(W)
				build_step++
				to_chat(user, span_notice("You add the robot leg to [src]."))
				name = "legs/frame assembly"
				if(build_step == 1)
					icon_state = "ed209_leg"
				else
					icon_state = "ed209_legs"

		if(2)
			if(istype(W, /obj/item/clothing/suit/storage/vest))
				user.drop_item()
				qdel(W)
				build_step++
				to_chat(user, span_notice("You add the armor to [src]."))
				name = "vest/legs/frame assembly"
				item_state = "ed209_shell"
				icon_state = "ed209_shell"

		if(3)
			if(W.has_tool_quality(TOOL_WELDER))
				var/obj/item/weldingtool/WT = W.get_welder()
				if(WT.remove_fuel(0, user))
					build_step++
					name = "shielded frame assembly"
					to_chat(user, span_notice("You welded the vest to [src]."))
		if(4)
			if(istype(W, /obj/item/clothing/head/helmet))
				user.drop_item()
				qdel(W)
				build_step++
				to_chat(user, span_notice("You add the helmet to [src]."))
				name = "covered and shielded frame assembly"
				item_state = "ed209_hat"
				icon_state = "ed209_hat"

		if(5)
			if(isprox(W))
				user.drop_item()
				qdel(W)
				build_step++
				to_chat(user, span_notice("You add the prox sensor to [src]."))
				name = "covered, shielded and sensored frame assembly"
				item_state = "ed209_prox"
				icon_state = "ed209_prox"

		if(6)
			if(istype(W, /obj/item/stack/cable_coil))
				var/obj/item/stack/cable_coil/C = W
				if (C.get_amount() < 1)
					to_chat(user, span_warning("You need one coil of wire to wire [src]."))
					return
				to_chat(user, span_notice("You start to wire [src]."))
				if(do_after(user, 40) && build_step == 6)
					if(C.use(1))
						build_step++
						to_chat(user, span_notice("You wire the ED-209 assembly."))
						name = "wired ED-209 assembly"
				return

		if(7)
			if(istype(W, /obj/item/gun/energy/taser/xeno))
				name = "xenotaser SL-ED-209 assembly"
				item_state = "sled209_taser"
				icon_state = "sled209_taser"
				build_step++
				to_chat(user, span_notice("You add [W] to [src]."))
				user.drop_item()
				qdel(W)
				var/turf/T = get_turf(src)
				var/obj/item/secbot_assembly/ed209_assembly/slime/S = new /obj/item/secbot_assembly/ed209_assembly/slime(T)
				S.name = name
				S.item_state = item_state
				S.icon_state = icon_state
				S.build_step = build_step
				S.created_name = created_name
				user.drop_from_inventory(src)
				qdel(src)

			else if(istype(W, /obj/item/gun/energy/taser))
				name = "taser ED-209 assembly"
				item_state = "ed209_taser"
				icon_state = "ed209_taser"
				build_step++
				to_chat(user, span_notice("You add [W] to [src]."))
				user.drop_item()
				qdel(W)

		if(8)
			if(W.has_tool_quality(TOOL_SCREWDRIVER))
				playsound(src, W.usesound, 100, 1)
				var/turf/T = get_turf(user)
				to_chat(user, span_notice("Now attaching the gun to the frame..."))
				sleep(40)
				if(get_turf(user) == T && build_step == 8)
					build_step++
					name = "armed [name]"
					to_chat(user, span_notice("Taser gun attached."))

		if(9)
			if(istype(W, /obj/item/cell))
				build_step++
				to_chat(user, span_notice("You complete the ED-209."))
				var/turf/T = get_turf(src)
				var/mob/living/bot/secbot/ed209/S = new /mob/living/bot/secbot/ed209(T)
				S.name = created_name
				user.drop_item()
				qdel(W)
				user.drop_from_inventory(src)
				qdel(src)
