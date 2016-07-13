/mob/living/bot/secbot
	name = "Securitron"
	desc = "A little security robot.  He looks less than thrilled."
	icon_state = "secbot0"
	maxHealth = 50
	health = 50
	req_one_access = list(access_security, access_forensics_lockers)
	botcard_access = list(access_security, access_sec_doors, access_forensics_lockers, access_morgue, access_maint_tunnels)
	patrol_speed = 2
	target_speed = 3

	var/idcheck = 0 // If true, arrests for having weapons without authorization.
	var/check_records = 0 // If true, arrests people without a record.
	var/check_arrest = 1 // If true, arrests people who are set to arrest.
	var/arrest_type = 0 // If true, doesn't handcuff. You monster.
	var/declare_arrests = 0 // If true, announces arrests over sechuds.
	var/auto_patrol = 0 // If true, patrols on its own

	var/is_ranged = 0
	var/awaiting_surrender = 0

	var/list/threat_found_sounds = new('sound/voice/bcriminal.ogg', 'sound/voice/bjustice.ogg', 'sound/voice/bfreeze.ogg')
	var/list/preparing_arrest_sounds = new('sound/voice/bgod.ogg', 'sound/voice/biamthelaw.ogg', 'sound/voice/bsecureday.ogg', 'sound/voice/bradio.ogg', 'sound/voice/binsult.ogg', 'sound/voice/bcreep.ogg')

/mob/living/bot/secbot/beepsky
	name = "Officer Beepsky"
	desc = "It's Officer Beep O'sky! Powered by a potato and a shot of whiskey."
	auto_patrol = 1

/mob/living/bot/secbot/update_icons()
	if(on && busy)
		icon_state = "secbot-c"
	else
		icon_state = "secbot[on]"

	if(on)
		set_light(2, 1, "#FF6A00")
	else
		set_light(0)

/mob/living/bot/secbot/attack_hand(var/mob/user)
	user.set_machine(src)
	var/dat
	dat += "<TT><B>Automatic Security Unit</B></TT><BR><BR>"
	dat += "Status: <A href='?src=\ref[src];power=1'>[on ? "On" : "Off"]</A><BR>"
	dat += "Behaviour controls are [locked ? "locked" : "unlocked"]<BR>"
	dat += "Maintenance panel is [open ? "opened" : "closed"]"
	if(!locked || issilicon(user))
		dat += "<BR>Check for Weapon Authorization: <A href='?src=\ref[src];operation=idcheck'>[idcheck ? "Yes" : "No"]</A><BR>"
		dat += "Check Security Records: <A href='?src=\ref[src];operation=ignorerec'>[check_records ? "Yes" : "No"]</A><BR>"
		dat += "Check Arrest Status: <A href='?src=\ref[src];operation=ignorearr'>[check_arrest ? "Yes" : "No"]</A><BR>"
		dat += "Operating Mode: <A href='?src=\ref[src];operation=switchmode'>[arrest_type ? "Detain" : "Arrest"]</A><BR>"
		dat += "Report Arrests: <A href='?src=\ref[src];operation=declarearrests'>[declare_arrests ? "Yes" : "No"]</A><BR>"
		dat += "Auto Patrol: <A href='?src=\ref[src];operation=patrol'>[auto_patrol ? "On" : "Off"]</A>"
	user << browse("<HEAD><TITLE>Securitron controls</TITLE></HEAD>[dat]", "window=autosec")
	onclose(user, "autosec")
	return

/mob/living/bot/secbot/Topic(href, href_list)
	if(..())
		return

	usr.set_machine(src)
	add_fingerprint(usr)

	if((href_list["power"]) && (access_scanner.allowed(usr)))
		if(on)
			turn_off()
		else
			turn_on()
		return

	switch(href_list["operation"])
		if("idcheck")
			idcheck = !idcheck
		if("ignorerec")
			check_records = !check_records
		if("ignorearr")
			check_arrest = !check_arrest
		if("switchmode")
			arrest_type = !arrest_type
		if("patrol")
			auto_patrol = !auto_patrol
		if("declarearrests")
			declare_arrests = !declare_arrests
	attack_hand(usr)

/mob/living/bot/secbot/emag_act(var/remaining_uses, var/mob/user)
	. = ..()
	if(!emagged)
		if(user)
			user << "<span class='notice'>\The [src] buzzes and beeps.</span>"
		emagged = 1
		patrol_speed = 3
		target_speed = 4
		return 1
	else
		user << "<span class='notice'>\The [src] is already corrupt.</span>"

/mob/living/bot/secbot/attackby(var/obj/item/O, var/mob/user)
	var/curhealth = health
	..()
	if(health < curhealth)
		target = user
		awaiting_surrender = 5

/mob/living/bot/secbot/startPatrol()
	if(!locked) // Stop running away when we set you up
		return
	..()

/mob/living/bot/secbot/confirmTarget(var/atom/A)
	if(!..())
		return 0

	return (check_threat(A) > 3)

/mob/living/bot/secbot/lookForTargets()
	for(var/mob/living/M in view(src))
		if(M.stat == DEAD)
			continue
		if(confirmTarget(M))
			var/threat = check_threat(M)
			target = M
			awaiting_surrender = -1
			say("Level [threat] infraction alert!")
			custom_emote(1, "points at [M.name]!")
			return

/mob/living/bot/secbot/calcTargetPath()
	..()
	if(awaiting_surrender != -1)
		awaiting_surrender = 5 // This implies that a) we have already approached the target and b) it has moved after the warning

/mob/living/bot/secbot/handleAdjacentTarget()
	if(awaiting_surrender < 5 && ishuman(target) && !target:lying)
		if(awaiting_surrender == -1)
			say("Down on the floor, [target]! You have five seconds to comply.")
		++awaiting_surrender
	else
		UnarmedAttack(target)
	if(ishuman(target) && declare_arrests)
		var/area/location = get_area(src)
		broadcast_security_hud_message("[src] is [arrest_type ? "detaining" : "arresting"] a level [check_threat(target)] suspect <b>[target]</b> in <b>[location]</b>.", src)

	//				say("Engaging patrol mode.")

/mob/living/bot/secbot/UnarmedAttack(var/mob/M, var/proximity)
	if(!..())
		return

	if(!istype(M))
		return

	if(istype(M, /mob/living/carbon))
		var/mob/living/carbon/C = M
		var/cuff = 1
		if(istype(C, /mob/living/carbon/human))
			var/mob/living/carbon/human/H = C
			if(istype(H.back, /obj/item/weapon/rig) && istype(H.gloves,/obj/item/clothing/gloves/gauntlets/rig))
				cuff = 0
		if(!C.lying || C.handcuffed || arrest_type)
			cuff = 0
		if(!cuff)
			C.stun_effect_act(0, 60, null)
			playsound(loc, 'sound/weapons/Egloves.ogg', 50, 1, -1)
			do_attack_animation(C)
			busy = 1
			update_icons()
			spawn(2)
				busy = 0
				update_icons()
			visible_message("<span class='warning'>[C] was prodded by [src] with a stun baton!</span>")
		else
			playsound(loc, 'sound/weapons/handcuffs.ogg', 30, 1, -2)
			visible_message("<span class='warning'>[src] is trying to put handcuffs on [C]!</span>")
			busy = 1
			if(do_mob(src, C, 60))
				if(!C.handcuffed)
					C.handcuffed = new /obj/item/weapon/handcuffs(C)
					C.update_inv_handcuffed()
				if(preparing_arrest_sounds.len)
					playsound(loc, pick(preparing_arrest_sounds), 50, 0)
			busy = 0
	else if(istype(M, /mob/living/simple_animal))
		var/mob/living/simple_animal/S = M
		S.AdjustStunned(10)
		S.adjustBruteLoss(15)
		do_attack_animation(M)
		playsound(loc, "swing_hit", 50, 1, -1)
		busy = 1
		update_icons()
		spawn(2)
			busy = 0
			update_icons()
		visible_message("<span class='warning'>[M] was beaten by [src] with a stun baton!</span>")

/mob/living/bot/secbot/explode()
	visible_message("<span class='warning'>[src] blows apart!</span>")
	var/turf/Tsec = get_turf(src)

	var/obj/item/weapon/secbot_assembly/Sa = new /obj/item/weapon/secbot_assembly(Tsec)
	Sa.build_step = 1
	Sa.overlays += image('icons/obj/aibots.dmi', "hs_hole")
	Sa.created_name = name
	new /obj/item/device/assembly/prox_sensor(Tsec)
	new /obj/item/weapon/melee/baton(Tsec)
	if(prob(50))
		new /obj/item/robot_parts/l_arm(Tsec)

	var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
	s.set_up(3, 1, src)
	s.start()

	new /obj/effect/decal/cleanable/blood/oil(Tsec)
	qdel(src)

/mob/living/bot/secbot/proc/check_threat(var/mob/living/M)
	if(!M || !istype(M) || M.stat == DEAD || src == M)
		return 0

	if(emagged)
		return 10

	return M.assess_perp(access_scanner, 0, idcheck, check_records, check_arrest)

//Secbot Construction

/obj/item/clothing/head/helmet/attackby(var/obj/item/device/assembly/signaler/S, mob/user as mob)
	..()
	if(!issignaler(S))
		..()
		return

	if(type != /obj/item/clothing/head/helmet) //Eh, but we don't want people making secbots out of space helmets.
		return

	if(S.secured)
		qdel(S)
		var/obj/item/weapon/secbot_assembly/A = new /obj/item/weapon/secbot_assembly
		user.put_in_hands(A)
		user << "You add the signaler to the helmet."
		user.drop_from_inventory(src)
		qdel(src)
	else
		return

/obj/item/weapon/secbot_assembly
	name = "helmet/signaler assembly"
	desc = "Some sort of bizarre assembly."
	icon = 'icons/obj/aibots.dmi'
	icon_state = "helmet_signaler"
	item_state = "helmet"
	var/build_step = 0
	var/created_name = "Securitron"

/obj/item/weapon/secbot_assembly/attackby(var/obj/item/O, var/mob/user)
	..()
	if(istype(O, /obj/item/weapon/weldingtool) && !build_step)
		var/obj/item/weapon/weldingtool/WT = O
		if(WT.remove_fuel(0, user))
			build_step = 1
			overlays += image('icons/obj/aibots.dmi', "hs_hole")
			user << "You weld a hole in \the [src]."

	else if(isprox(O) && (build_step == 1))
		user.drop_item()
		build_step = 2
		user << "You add \the [O] to [src]."
		overlays += image('icons/obj/aibots.dmi', "hs_eye")
		name = "helmet/signaler/prox sensor assembly"
		qdel(O)

	else if((istype(O, /obj/item/robot_parts/l_arm) || istype(O, /obj/item/robot_parts/r_arm)) && build_step == 2)
		user.drop_item()
		build_step = 3
		user << "You add \the [O] to [src]."
		name = "helmet/signaler/prox sensor/robot arm assembly"
		overlays += image('icons/obj/aibots.dmi', "hs_arm")
		qdel(O)

	else if(istype(O, /obj/item/weapon/melee/baton) && build_step == 3)
		user.drop_item()
		user << "You complete the Securitron! Beep boop."
		var/mob/living/bot/secbot/S = new /mob/living/bot/secbot(get_turf(src))
		S.name = created_name
		qdel(O)
		qdel(src)

	else if(istype(O, /obj/item/weapon/pen))
		var/t = sanitizeSafe(input(user, "Enter new robot name", name, created_name), MAX_NAME_LEN)
		if(!t)
			return
		if(!in_range(src, usr) && loc != usr)
			return
		created_name = t