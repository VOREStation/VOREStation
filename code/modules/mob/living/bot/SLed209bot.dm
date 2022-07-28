/mob/living/bot/secbot/ed209/slime
	name = "SL-ED-209 Security Robot"
	desc = "A security robot.  He looks less than thrilled."
	icon = 'icons/obj/aibots.dmi'
	icon_state = "sled2090"
	density = TRUE
	health = 200
	maxHealth = 200

	is_ranged = 1
	preparing_arrest_sounds = new()

	a_intent = I_HURT
	mob_bump_flag = HEAVY
	mob_swap_flags = ~HEAVY
	mob_push_flags = HEAVY

	used_weapon = /obj/item/weapon/gun/energy/taser/xeno

	stun_strength = 10
	xeno_harm_strength = 9
	req_one_access = list(access_research, access_robotics)
	botcard_access = list(access_research, access_robotics, access_xenobiology, access_xenoarch, access_tox, access_tox_storage, access_maint_tunnels)
	retaliates = FALSE
	var/xeno_stun_strength = 6

/mob/living/bot/secbot/ed209/slime/update_icons()
	if(on && busy)
		icon_state = "sled209-c"
	else
		icon_state = "sled209[on]"

/mob/living/bot/secbot/ed209/slime/RangedAttack(var/atom/A)
	if(last_shot + shot_delay > world.time)
		to_chat(src, "You are not ready to fire yet!")
		return

	last_shot = world.time

	var/projectile = /obj/item/projectile/beam/stun/xeno
	if(emagged)
		projectile = /obj/item/projectile/beam/shock

	playsound(src, emagged ? 'sound/weapons/laser3.ogg' : 'sound/weapons/Taser.ogg', 50, 1)
	var/obj/item/projectile/P = new projectile(loc)

	P.firer = src
	P.old_style_target(A)
	P.fire()

/mob/living/bot/secbot/ed209/slime/UnarmedAttack(var/mob/living/L, var/proximity)
	..()

	if(istype(L, /mob/living/simple_mob/slime/xenobio))
		var/mob/living/simple_mob/slime/xenobio/S = L
		S.slimebatoned(src, xeno_stun_strength)

// Assembly

/obj/item/weapon/secbot_assembly/ed209_assembly/slime
	name = "SL-ED-209 assembly"
	desc = "Some sort of bizarre assembly."
	icon = 'icons/obj/aibots.dmi'
	icon_state = "ed209_frame"
	item_state = "buildpipe"
	created_name = "SL-ED-209 Security Robot"

/obj/item/weapon/secbot_assembly/ed209_assembly/slime/attackby(var/obj/item/weapon/W as obj, var/mob/user as mob) // Here in the event it's added into a PoI or some such. Standard construction relies on the standard ED up until taser.
	if(istype(W, /obj/item/weapon/pen))
		var/t = sanitizeSafe(tgui_input_text(user, "Enter new robot name", name, created_name, MAX_NAME_LEN), MAX_NAME_LEN)
		if(!t)
			return
		if(!in_range(src, usr) && src.loc != usr)
			return
		created_name = t
		return

	switch(build_step)
		if(0, 1)
			if(istype(W, /obj/item/robot_parts/l_leg) || istype(W, /obj/item/robot_parts/r_leg) || (istype(W, /obj/item/organ/external/leg) && ((W.name == "robotic right leg") || (W.name == "robotic left leg"))))
				user.drop_item()
				qdel(W)
				build_step++
				to_chat(user, "<span class='notice'>You add the robot leg to [src].</span>")
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
				to_chat(user, "<span class='notice'>You add the armor to [src].</span>")
				name = "vest/legs/frame assembly"
				item_state = "ed209_shell"
				icon_state = "ed209_shell"

		if(3)
			if(istype(W, /obj/item/weapon/weldingtool))
				var/obj/item/weapon/weldingtool/WT = W
				if(WT.remove_fuel(0, user))
					build_step++
					name = "shielded frame assembly"
					to_chat(user, "<span class='notice'>You welded the vest to [src].</span>")
		if(4)
			if(istype(W, /obj/item/clothing/head/helmet))
				user.drop_item()
				qdel(W)
				build_step++
				to_chat(user, "<span class='notice'>You add the helmet to [src].</span>")
				name = "covered and shielded frame assembly"
				item_state = "ed209_hat"
				icon_state = "ed209_hat"

		if(5)
			if(isprox(W))
				user.drop_item()
				qdel(W)
				build_step++
				to_chat(user, "<span class='notice'>You add the prox sensor to [src].</span>")
				name = "covered, shielded and sensored frame assembly"
				item_state = "ed209_prox"
				icon_state = "ed209_prox"

		if(6)
			if(istype(W, /obj/item/stack/cable_coil))
				var/obj/item/stack/cable_coil/C = W
				if (C.get_amount() < 1)
					to_chat(user, "<span class='warning'>You need one coil of wire to wire [src].</span>")
					return
				to_chat(user, "<span class='notice'>You start to wire [src].</span>")
				if(do_after(user, 40) && build_step == 6)
					if(C.use(1))
						build_step++
						to_chat(user, "<span class='notice'>You wire the ED-209 assembly.</span>")
						name = "wired ED-209 assembly"
				return

		if(7)
			if(istype(W, /obj/item/weapon/gun/energy/taser/xeno))
				name = "xenotaser SL-ED-209 assembly"
				item_state = "sled209_taser"
				icon_state = "sled209_taser"
				build_step++
				to_chat(user, "<span class='notice'>You add [W] to [src].</span>")
				user.drop_item()
				qdel(W)

		if(8)
			if(W.is_screwdriver())
				playsound(src, W.usesound, 100, 1)
				var/turf/T = get_turf(user)
				to_chat(user, "<span class='notice'>Now attaching the gun to the frame...</span>")
				sleep(40)
				if(get_turf(user) == T && build_step == 8)
					build_step++
					name = "armed [name]"
					to_chat(user, "<span class='notice'>Taser gun attached.</span>")

		if(9)
			if(istype(W, /obj/item/weapon/cell))
				build_step++
				to_chat(user, "<span class='notice'>You complete the ED-209.</span>")
				var/turf/T = get_turf(src)
				new /mob/living/bot/secbot/ed209/slime(T,created_name,lasercolor)
				user.drop_item()
				qdel(W)
				user.drop_from_inventory(src)
				qdel(src)

