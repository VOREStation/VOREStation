/*
	Cyborg ClickOn()

	Cyborgs have no range restriction on attack_robot(), because it is basically an AI click.
	However, they do have a range restriction on item use, so they cannot do without the
	adjacency code.
*/

/mob/living/silicon/robot/ClickOn(var/atom/A, var/params)
	if(!checkClickCooldown())
		return

	setClickCooldown(1)

	if(client.buildmode) // comes after object.Click to allow buildmode gui objects to be clicked
		build_click(src, client.buildmode, params, A)
		return

	var/list/modifiers = params2list(params)
	if(modifiers["shift"] && modifiers["ctrl"])
		CtrlShiftClickOn(A)
		return
	if(modifiers["shift"] && modifiers["middle"])
		ShiftMiddleClickOn(A)
		return
	if(modifiers["middle"])
		MiddleClickOn(A)
		return
	if(modifiers["shift"])
		ShiftClickOn(A)
		return
	if(modifiers["alt"]) // alt and alt-gr (rightalt)
		AltClickOn(A)
		return
	if(modifiers["ctrl"])
		CtrlClickOn(A)
		return

	if(stat || lockdown || weakened || stunned || paralysis)
		return

	face_atom(A) // change direction to face what you clicked on

	if(aiCamera && aiCamera.in_camera_mode)
		aiCamera.camera_mode_off()
		if(is_component_functioning("camera"))
			aiCamera.captureimage(A, usr)
		else
			to_chat(src, "<span class='userdanger'>Your camera isn't functional.</span>")
		return

	/*
	cyborg restrained() currently does nothing
	if(restrained())
		RestrainedClickOn(A)
		return
	*/

	var/obj/item/W = get_active_hand()

	// Cyborgs have no range-checking unless there is item use
	if(!W)
		if(bolt && !bolt.malfunction && A.loc != module)
			return
		A.add_hiddenprint(src)
		A.attack_robot(src)
		return

	// buckled cannot prevent machine interlinking but stops arm movement
	if( buckled )
		return

	if(W == A)

		W.attack_self(src)
		return

	// cyborgs are prohibited from using storage items so we can I think safely remove (A.loc in contents)
	if(A == loc || (A in loc) || (A in contents))
		// No adjacency checks

		var/resolved = A.attackby(W, src, 1)
		if(!resolved && A && W)
			W.afterattack(A,src,1,params)
		return

	if(!isturf(loc))
		return

	// cyborgs are prohibited from using storage items so we can I think safely remove (A.loc && isturf(A.loc.loc))
	if(isturf(A) || isturf(A.loc))
		if(A.Adjacent(src) || (W && W.attack_can_reach(src, A, W.reach))) // see adjacent.dm, allows robots to use ranged melee weapons

			var/resolved = A.attackby(W, src, 1)
			if(!resolved && A && W)
				W.afterattack(A, src, 1, params)
			return
		else
			W.afterattack(A, src, 0, params)
			return
	return

//Middle click cycles through selected modules.
/mob/living/silicon/robot/MiddleClickOn(var/atom/A)
	cycle_modules()
	return

//Give cyborgs hotkey clicks without breaking existing uses of hotkey clicks
// for non-doors/apcs
/mob/living/silicon/robot/CtrlShiftClickOn(var/atom/A)
	A.BorgCtrlShiftClick(src)

/mob/living/silicon/robot/ShiftClickOn(var/atom/A)
	A.BorgShiftClick(src)

/mob/living/silicon/robot/CtrlClickOn(var/atom/A)
	A.BorgCtrlClick(src)

/mob/living/silicon/robot/AltClickOn(var/atom/A)
	A.BorgAltClick(src)

/atom/proc/BorgCtrlShiftClick(var/mob/living/silicon/robot/user) //forward to human click if not overriden
	CtrlShiftClick(user)

/obj/machinery/door/airlock/BorgCtrlShiftClick(var/mob/living/silicon/robot/user)
	if(user.bolt && !user.bolt.malfunction)
		return

	AICtrlShiftClick(user)

/atom/proc/BorgShiftClick(var/mob/living/silicon/robot/user) //forward to human click if not overriden
	ShiftClick(user)

/obj/machinery/door/airlock/BorgShiftClick(var/mob/living/silicon/robot/user)  // Opens and closes doors! Forwards to AI code.
	if(user.bolt && !user.bolt.malfunction)
		return

	AIShiftClick(user)

/atom/proc/BorgCtrlClick(var/mob/living/silicon/robot/user) //forward to human click if not overriden
	CtrlClick(user)

/obj/machinery/door/airlock/BorgCtrlClick(var/mob/living/silicon/robot/user) // Bolts doors. Forwards to AI code.
	if(user.bolt && !user.bolt.malfunction)
		return

	AICtrlClick(user)

/obj/machinery/power/apc/BorgCtrlClick(var/mob/living/silicon/robot/user) // turns off/on APCs. Forwards to AI code.
	if(user.bolt && !user.bolt.malfunction)
		return

	AICtrlClick(user)

/obj/machinery/turretid/BorgCtrlClick(var/mob/living/silicon/robot/user) //turret control on/off. Forwards to AI code.
	if(user.bolt && !user.bolt.malfunction)
		return

	AICtrlClick(user)

/atom/proc/BorgAltClick(var/mob/living/silicon/robot/user)
	AltClick(user)
	return

/obj/machinery/door/airlock/BorgAltClick(var/mob/living/silicon/robot/user) // Eletrifies doors. Forwards to AI code.
	if(user.bolt && !user.bolt.malfunction)
		return

	AIAltClick(user)

/obj/machinery/turretid/BorgAltClick(var/mob/living/silicon/robot/user) //turret lethal on/off. Forwards to AI code.
	if(user.bolt && !user.bolt.malfunction)
		return

	AIAltClick(user)

/*
	As with AI, these are not used in click code,
	because the code for robots is specific, not generic.

	If you would like to add advanced features to robot
	clicks, you can do so here, but you will have to
	change attack_robot() above to the proper function
*/
/mob/living/silicon/robot/UnarmedAttack(atom/A)
	A.attack_robot(src)
/mob/living/silicon/robot/RangedAttack(atom/A)
	A.attack_robot(src)

/atom/proc/attack_robot(mob/user as mob)
	attack_ai(user)
	return
