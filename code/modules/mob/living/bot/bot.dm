/mob/living/bot
	name = "Bot"
	health = 20
	maxHealth = 20
	icon = 'icons/obj/aibots.dmi'
	layer = MOB_LAYER
	universal_speak = 1
	density = FALSE

	makes_dirt = FALSE	// No more dirt from Beepsky

	var/obj/item/card/id/botcard = null
	var/list/botcard_access = list()
	var/on = 1
	var/open = 0
	var/locked = 1
	var/emagged = 0
	var/light_strength = 3
	var/busy = 0
	var/obj/item/paicard/paicard = null
	var/obj/access_scanner = null
	var/list/req_access = list()
	var/list/req_one_access = list()

	var/atom/target = null
	var/list/ignore_list = list()
	var/list/patrol_path = list()
	var/list/target_path = list()
	var/turf/obstacle = null

	var/wait_if_pulled = 0 // Only applies to moving to the target
	var/will_patrol = 0 // If set to 1, will patrol, duh
	var/patrol_speed = 1 // How many times per tick we move when patrolling
	var/target_speed = 2 // Ditto for chasing the target
	var/panic_on_alert = FALSE	// Will the bot go faster when the alert level is raised?
	var/min_target_dist = 1 // How close we try to get to the target
	var/max_target_dist = 50 // How far we are willing to go
	var/max_patrol_dist = 250

	var/target_patience = 5
	var/frustration = 0
	var/max_frustration = 0

/mob/living/bot/Initialize()
	. = ..()
	update_icons()

	default_language = GLOB.all_languages[LANGUAGE_GALCOM]

	botcard = new /obj/item/card/id(src)
	botcard.access = botcard_access.Copy()

	access_scanner = new /obj(src)
	access_scanner.req_access = req_access.Copy()
	access_scanner.req_one_access = req_one_access.Copy()

	if(!using_map.bot_patrolling)
		will_patrol = FALSE

// Make sure mapped in units start turned on.
/mob/living/bot/Initialize()
	. = ..()
	if(on)
		turn_on() // Update lights and other stuff

/mob/living/bot/Life()
	..()
	if(health <= 0)
		death()
		return
	SetWeakened(0)
	SetStunned(0)
	SetParalysis(0)

	if(on && !client && !busy && !paicard)
		spawn(0)
			handleAI()
/*
/mob/living/bot/examine(mob/user)
	. = ..()
	if(health < maxHealth)
		if(health > maxHealth/3)
			. += "[src]'s parts look loose."
		else
			. += "[src]'s parts look very loose!"
	else
		. += "[src] is in pristine condition."
	. += span_notice("Its maintenance panel is [open ? "open" : "closed"].")
	. += span_info("You can use a <b>screwdriver</b> to [open ? "close" : "open"] it.")
	. += span_notice("Its control panel is [locked ? "locked" : "unlocked"].")
	if(paicard)
		. += span_notice("It has a pAI device installed.")
		if(open)
			. += span_info("You can use a <b>crowbar</b> to remove it.")
*/
/mob/living/bot/updatehealth()
	if(status_flags & GODMODE)
		health = getMaxHealth()
		set_stat(CONSCIOUS)
	else
		health = getMaxHealth() - getFireLoss() - getBruteLoss()
	oxyloss = 0
	toxloss = 0
	cloneloss = 0
	halloss = 0

/mob/living/bot/death()
	explode()

/mob/living/bot/attackby(var/obj/item/O, var/mob/user)
	if(O.GetID())
		if(access_scanner.allowed(user) && !open)
			locked = !locked
			to_chat(user, "<span class='notice'>Controls are now [locked ? "locked." : "unlocked."]</span>")
			attack_hand(user)
			if(emagged)
				to_chat(user, "<span class='warning'>ERROR! SYSTEMS COMPROMISED!</span>")
		else
			if(open)
				to_chat(user, "<span class='warning'>Please close the access panel before locking it.</span>")
			else
				to_chat(user, "<span class='warning'>Access denied.</span>")
		return
	else if(O.is_screwdriver())
		if(!locked)
			open = !open
			to_chat(user, "<span class='notice'>Maintenance panel is now [open ? "opened" : "closed"].</span>")
			playsound(src, O.usesound, 50, 1)
		else
			to_chat(user, "<span class='notice'>You need to unlock the controls first.</span>")
		return
	else if(istype(O, /obj/item/weldingtool))
		if(health < getMaxHealth())
			if(open)
				if(getBruteLoss() < 10)
					bruteloss = 0
				else
					bruteloss = bruteloss - 10
				if(getFireLoss() < 10)
					fireloss = 0
				else
					fireloss = fireloss - 10
				updatehealth()
				user.visible_message("<span class='notice'>[user] repairs [src].</span>","<span class='notice'>You repair [src].</span>")
				playsound(src, O.usesound, 50, 1)
			else
				to_chat(user, "<span class='notice'>Unable to repair with the maintenance panel closed.</span>")
		else
			to_chat(user, "<span class='notice'>[src] does not need a repair.</span>")
		return
	else if(istype(O, /obj/item/assembly/prox_sensor) && emagged)
		if(open)
			to_chat(user, "<span class='notice'>You repair the bot's systems.</span>")
			emagged = 0
			qdel(O)
		else
			to_chat(user, "<span class='notice'>Unable to repair with the maintenance panel closed.</span>")
	else if(istype(O, /obj/item/paicard))
		if(open)
			insertpai(user, O)
			to_chat(user, span_notice("You slot the card into \the [initial(src.name)]."))
		else
			to_chat(user, span_notice("You must open the panel first!"))
	else if(O.is_crowbar())
		if(open && paicard)
			to_chat(user, span_notice("You are attempting to remove the pAI.."))
			if(do_after(user,10 * O.toolspeed))
				ejectpai(user)
	else
		..()

/mob/living/bot/attack_ai(var/mob/user)
	return attack_hand(user)

/mob/living/bot/say_quote(var/message, var/datum/language/speaking = null)
	return "beeps"

/mob/living/bot/speech_bubble_appearance()
	return "machine"

/mob/living/bot/Bump(var/atom/A)
	if(on && botcard && istype(A, /obj/machinery/door))
		var/obj/machinery/door/D = A
		if(!istype(D, /obj/machinery/door/firedoor) && !istype(D, /obj/machinery/door/blast) && !istype(D, /obj/machinery/door/airlock/lift) && D.check_access(botcard))
			D.open()
	else
		..()

/mob/living/bot/emag_act(var/remaining_charges, var/mob/user)
	return 0

/mob/living/bot/proc/handleAI()
	if(ignore_list.len)
		for(var/atom/A in ignore_list)
			if(!A || !A.loc || prob(1))
				ignore_list -= A
	handleRegular()

	var/panic_speed_mod = 0

	if(panic_on_alert)
		panic_speed_mod = handlePanic()

	if(target && confirmTarget(target))
		if(Adjacent(target))
			handleAdjacentTarget()
		else
			handleRangedTarget()
		if(!wait_if_pulled || !pulledby)
			for(var/i = 1 to (target_speed + panic_speed_mod))
				sleep(20 / (target_speed + panic_speed_mod + 1))
				stepToTarget()
		if(max_frustration && frustration > max_frustration * target_speed)
			handleFrustrated(1)
	else
		resetTarget()
		lookForTargets()
		if(will_patrol && !pulledby && !target)
			if(patrol_path && patrol_path.len)
				for(var/i = 1 to (patrol_speed + panic_speed_mod))
					sleep(20 / (patrol_speed + 1))
					handlePatrol()
				if(max_frustration && frustration > max_frustration * patrol_speed)
					handleFrustrated(0)
			else
				startPatrol()
		else
			if((locate(/obj/machinery/door) in loc) && !pulledby) //Don't hang around blocking doors, but don't run off if someone tries to pull us through one.
				var/turf/my_turf = get_turf(src)
				var/list/can_go = my_turf.CardinalTurfsWithAccess(botcard)
				if(LAZYLEN(can_go))
					if(step_towards(src, pick(can_go)))
						return
			for(var/mob in loc)
				if(istype(mob, /mob/living/bot) && mob != src) // Same as above, but we also don't want to have bots ontop of bots. Cleanbots shouldn't stack >:(
					var/turf/my_turf = get_turf(src)
					var/list/can_go = my_turf.CardinalTurfsWithAccess(botcard)
					if(LAZYLEN(can_go))
						if(step_towards(src, pick(can_go)))
							return
			handleIdle()

/mob/living/bot/proc/handleRegular()
	return

/mob/living/bot/proc/handleAdjacentTarget()
	return

/mob/living/bot/proc/handleRangedTarget()
	return

/mob/living/bot/proc/handlePanic()	// Speed modification based on alert level.
	. = 0
	switch(get_security_level())
		if("green")
			. = 0

		if("yellow")
			. = 0

		if("violet")
			. = 0

		if("orange")
			. = 0

		if("blue")
			. = 1

		if("red")
			. = 2

		if("delta")
			. = 2

	return .

/mob/living/bot/proc/stepToTarget()
	if(!target || !target.loc)
		return
	if(get_dist(src, target) > min_target_dist)
		if(!target_path.len || get_turf(target) != target_path[target_path.len])
			calcTargetPath()
		if(makeStep(target_path))
			frustration = 0
		else if(max_frustration)
			++frustration
	return

/mob/living/bot/proc/handleFrustrated(var/targ)
	obstacle = targ ? target_path[1] : patrol_path[1]
	target_path = list()
	patrol_path = list()
	return

/mob/living/bot/proc/lookForTargets()
	return

/mob/living/bot/proc/confirmTarget(var/atom/A)
	if(A.invisibility >= INVISIBILITY_LEVEL_ONE)
		return 0
	if(A in ignore_list)
		return 0
	if(!A.loc)
		return 0
	return 1

/mob/living/bot/proc/handlePatrol()
	makeStep(patrol_path)
	return

/mob/living/bot/proc/startPatrol()
	var/turf/T = getPatrolTurf()
	if(T)
		patrol_path = AStar(get_turf(loc), T, /turf/proc/CardinalTurfsWithAccess, /turf/proc/Distance, 0, max_patrol_dist, id = botcard, exclude = obstacle)
		if(!patrol_path)
			patrol_path = list()
		obstacle = null
	return

/mob/living/bot/proc/getPatrolTurf()
	var/minDist = INFINITY
	var/obj/machinery/navbeacon/targ = locate() in get_turf(src)

	if(!targ)
		for(var/obj/machinery/navbeacon/N in navbeacons)
			if(!N.codes["patrol"])
				continue
			if(get_dist(src, N) < minDist)
				minDist = get_dist(src, N)
				targ = N

	if(targ && targ.codes["next_patrol"])
		for(var/obj/machinery/navbeacon/N in navbeacons)
			if(N.location == targ.codes["next_patrol"])
				targ = N
				break

	if(targ)
		return get_turf(targ)
	return null

/mob/living/bot/proc/handleIdle()
	return

/mob/living/bot/proc/calcTargetPath()
	target_path = AStar(get_turf(loc), get_turf(target), /turf/proc/CardinalTurfsWithAccess, /turf/proc/Distance, 0, max_target_dist, id = botcard, exclude = obstacle)
	if(!target_path)
		if(target && target.loc)
			ignore_list |= target
		resetTarget()
		obstacle = null
	return

/mob/living/bot/proc/makeStep(var/list/path)
	if(!path.len)
		return 0
	var/turf/T = path[1]
	if(get_turf(src) == T)
		path -= T
		return makeStep(path)

	return step_towards(src, T)

/mob/living/bot/proc/resetTarget()
	target = null
	target_path = list()
	frustration = 0
	obstacle = null

/mob/living/bot/proc/turn_on()
	if(stat)
		return 0
	on = 1
	set_light(light_strength)
	update_icons()
	resetTarget()
	patrol_path = list()
	ignore_list = list()
	update_canmove()
	return 1

/mob/living/bot/proc/turn_off()
	on = 0
	busy = 0 // If ever stuck... reboot!
	set_light(0)
	update_icons()
	update_canmove()

/mob/living/bot/proc/explode()
	if(paicard)
		ejectpai()
	release_vore_contents()
	qdel(src)

/mob/living/bot/is_sentient()
	if(paicard)
		return TRUE
	return FALSE

/******************************************************************/
// Navigation procs
// Used for A-star pathfinding


// Returns the surrounding cardinal turfs with open links
// Including through doors openable with the ID
/turf/proc/CardinalTurfsWithAccess(var/obj/item/card/id/ID)
	var/L[] = new()

	//	for(var/turf/simulated/t in oview(src,1))

	for(var/d in cardinal)
		var/turf/T = get_step(src, d)
		if(istype(T) && !T.density)
			if(!LinkBlockedWithAccess(src, T, ID))
				L.Add(T)
	return L


// Similar to above but not restricted to just cardinal directions.
/turf/proc/TurfsWithAccess(var/obj/item/card/id/ID)
	var/L[] = new()

	for(var/d in alldirs)
		var/turf/T = get_step(src, d)
		if(istype(T) && !T.density)
			if(!LinkBlockedWithAccess(src, T, ID))
				L.Add(T)
	return L


// Returns true if a link between A and B is blocked
// Movement through doors allowed if ID has access
/proc/LinkBlockedWithAccess(turf/A, turf/B, obj/item/card/id/ID)

	if(A == null || B == null) return 1
	var/adir = get_dir(A,B)
	var/rdir = get_dir(B,A)
	if((adir & (NORTH|SOUTH)) && (adir & (EAST|WEST)))	//	diagonal
		var/iStep = get_step(A,adir&(NORTH|SOUTH))
		if(!LinkBlockedWithAccess(A,iStep, ID) && !LinkBlockedWithAccess(iStep,B,ID))
			return 0

		var/pStep = get_step(A,adir&(EAST|WEST))
		if(!LinkBlockedWithAccess(A,pStep,ID) && !LinkBlockedWithAccess(pStep,B,ID))
			return 0
		return 1

	if(DirBlockedWithAccess(A,adir, ID))
		return 1

	if(DirBlockedWithAccess(B,rdir, ID))
		return 1

	for(var/obj/O in B)
		if(O.density && !istype(O, /obj/machinery/door) && !(O.flags & ON_BORDER))
			return 1

	return 0

// Returns true if direction is blocked from loc
// Checks doors against access with given ID
/proc/DirBlockedWithAccess(turf/loc,var/dir,var/obj/item/card/id/ID)
	for(var/obj/structure/window/D in loc)
		if(!D.density)			continue
		if(D.dir == SOUTHWEST)	return 1
		if(D.dir == dir)		return 1

	for(var/obj/machinery/door/D in loc)
		if(!D.density)			continue

		if(istype(D, /obj/machinery/door/airlock))
			var/obj/machinery/door/airlock/A = D
			if(!A.can_open())	return 1

		if(istype(D, /obj/machinery/door/window))
			if( dir & D.dir )	return !D.check_access(ID)

			//if((dir & SOUTH) && (D.dir & (EAST|WEST)))		return !D.check_access(ID)
			//if((dir & EAST ) && (D.dir & (NORTH|SOUTH)))	return !D.check_access(ID)
		else return !D.check_access(ID)	// it's a real, air blocking door
	return 0


/mob/living/bot/isSynthetic() //Robots are synthetic, no?
	return 1

/mob/living/bot/update_canmove()
	..()
	canmove = on
	return canmove

/mob/living/bot/proc/insertpai(mob/user, obj/item/paicard/card)
	//var/obj/item/paicard/card = I
	var/mob/living/silicon/pai/AI = card.pai
	if(paicard)
		to_chat(user, span_notice("This bot is already under PAI Control!"))
		return
	if(!istype(card)) // TODO: Add sleevecard support.
		return
	if(client)
		to_chat(user, span_notice("Higher levels of processing are already present!"))
		return
	if(!card.pai)
		to_chat(user, span_notice("This card does not currently have a personality!"))
		return
	paicard = card
	user.unEquip(card)
	card.forceMove(src)
	src.ckey = AI.ckey
	name = AI.name
	ooc_notes = AI.ooc_notes
	to_chat(src, span_notice("You feel a tingle in your circuits as your systems interface with \the [initial(src.name)]."))
	if(AI.idcard.access)
		botcard.access	|= AI.idcard.access

/mob/living/bot/proc/ejectpai(mob/user)
	if(paicard)
		var/mob/living/silicon/pai/AI = paicard.pai
		AI.ckey = src.ckey
		AI.ooc_notes = ooc_notes
		paicard.forceMove(src.loc)
		paicard = null
		name = initial(name)
		botcard.access = botcard_access.Copy()
		to_chat(AI, span_notice("You feel a tad claustrophobic as your mind closes back into your card, ejecting from \the [initial(src.name)]."))

		if(user)
			to_chat(user, span_notice("You eject the card from \the [initial(src.name)]."))

/mob/living/bot/verb/bot_nom(var/mob/living/T in oview(1))
	set name = "Bot Nom"
	set category = "Bot Commands"
	set desc = "Allows you to eat someone. Yum."

	if (stat != CONSCIOUS)
		return
	return feed_grabbed_to_self(src,T)

/mob/living/bot/verb/ejectself()
	set name = "Eject pAI"
	set category = "Bot Commands"
	set desc = "Eject your card, return to smole."

	return ejectpai()

/mob/living/bot/Login()
	no_vore = FALSE // ROBOT VORE
	init_vore() // ROBOT VORE
	verbs |= /mob/living/proc/insidePanel

	return ..()

/mob/living/bot/Logout()
	no_vore = TRUE // ROBOT VORE
	release_vore_contents()
	init_vore() // ROBOT VORE
	verbs -= /mob/living/proc/insidePanel
	no_vore = TRUE
	devourable = FALSE
	feeding = FALSE
	can_be_drop_pred = FALSE

	return ..()
