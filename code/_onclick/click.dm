/*
	Click code cleanup
	~Sayu
*/

// 1 decisecond click delay (above and beyond mob/next_move)
/mob/var/next_click = 0

/*
	Before anything else, defer these calls to a per-mobtype handler.  This allows us to
	remove istype() spaghetti code, but requires the addition of other handler procs to simplify it.

	Alternately, you could hardcode every mob's variation in a flat ClickOn() proc; however,
	that's a lot of code duplication and is hard to maintain.

	Note that this proc can be overridden, and is in the case of screen objects.
*/

/atom/Click(var/location, var/control, var/params) // This is their reaction to being clicked on (standard proc)
	if(src)
		SEND_SIGNAL(src, COMSIG_CLICK, location, control, params, usr)
		usr.ClickOn(src, params)

/atom/DblClick(var/location, var/control, var/params)
	if(src)
		usr.DblClickOn(src, params)

/*
	Standard mob ClickOn()
	Handles exceptions: Buildmode, middle click, modified clicks, mech actions

	After that, mostly just check your state, check whether you're holding an item,
	check whether you're adjacent to the target, then pass off the click to whoever
	is recieving it.
	The most common are:
	* mob/UnarmedAttack(atom,adjacent) - used here only when adjacent, with no item in hand; in the case of humans, checks gloves
	* atom/attackby(item,user) - used only when adjacent
	* item/afterattack(atom,user,adjacent,params) - used both ranged and adjacent
	* mob/RangedAttack(atom,params) - used only ranged, only used for tk and laser eyes but could be changed
*/
/mob/proc/ClickOn(var/atom/A, var/params)
	if(!checkClickCooldown()) // Hard check, before anything else, to avoid crashing
		return

	setClickCooldown(1)

	if(client && client.buildmode)
		build_click(src, client.buildmode, params, A)
		return

	var/list/modifiers = params2list(params)
	if(modifiers["shift"] && modifiers["ctrl"])
		CtrlShiftClickOn(A)
		return 1
	if(modifiers["shift"] && modifiers["middle"])
		ShiftMiddleClickOn(A)
		return 1
	if(modifiers["middle"])
		MiddleClickOn(A)
		return 1
	if(modifiers["shift"])
		ShiftClickOn(A)
		return 0
	if(modifiers["alt"]) // alt and alt-gr (rightalt)
		AltClickOn(A)
		return 1
	if(modifiers["ctrl"])
		CtrlClickOn(A)
		return 1

	if(stat || paralysis || stunned || weakened)
		return

	face_atom(A) // change direction to face what you clicked on

	if(istype(loc, /obj/mecha))
		if(!locate(/turf) in list(A, A.loc)) // Prevents inventory from being drilled
			return
		var/obj/mecha/M = loc
		return M.click_action(A, src, params)

	if(restrained())
		setClickCooldown(10)
		RestrainedClickOn(A)
		return 1

	if(in_throw_mode && (isturf(A) || isturf(A.loc)) && throw_item(A))
		trigger_aiming(TARGET_CAN_CLICK)
		throw_mode_off()
		return TRUE

	var/obj/item/W = get_active_hand()

	if(W == A) // Handle attack_self
		W.attack_self(src)
		trigger_aiming(TARGET_CAN_CLICK)
		update_inv_active_hand(0)
		return 1

	//Atoms on your person
	// A is your location but is not a turf; or is on you (backpack); or is on something on you (box in backpack); sdepth is needed here because contents depth does not equate inventory storage depth.
	var/sdepth = A.storage_depth(src)
	if((!isturf(A) && A == loc) || (sdepth != -1 && sdepth <= 1))
		if(W)
			var/resolved = W.resolve_attackby(A, src, click_parameters = params)
			if(!resolved && A && W)
				W.afterattack(A, src, 1, params) // 1 indicates adjacency
		else
			if(ismob(A)) // No instant mob attacking
				setClickCooldown(get_attack_speed())
			UnarmedAttack(A, 1)

		trigger_aiming(TARGET_CAN_CLICK)
		return 1

	// VOREStation Addition Start: inbelly item interaction
	if(isbelly(loc) && (loc == A.loc))
		if(W)
			var/resolved = W.resolve_attackby(A,src)
			if(!resolved && A && W)
				W.afterattack(A, src, 1, params) // 1: clicking something Adjacent
		else
			if(ismob(A)) // No instant mob attacking
				setClickCooldown(get_attack_speed())
			UnarmedAttack(A, 1)
		return
	// VOREStation Addition End

	if(!isturf(loc)) // This is going to stop you from telekinesing from inside a closet, but I don't shed many tears for that
		return

	//Atoms on turfs (not on your person)
	// A is a turf or is on a turf, or in something on a turf (pen in a box); but not something in something on a turf (pen in a box in a backpack)
	sdepth = A.storage_depth_turf()
	if(isturf(A) || isturf(A.loc) || (sdepth != -1 && sdepth <= 1))
		if(A.Adjacent(src) || (W && W.attack_can_reach(src, A, W.reach)) ) // see adjacent.dm
			if(W)
				// Return 1 in attackby() to prevent afterattack() effects (when safely moving items for example)
				var/resolved = W.resolve_attackby(A,src, click_parameters = params)
				if(!resolved && A && W)
					W.afterattack(A, src, 1, params) // 1: clicking something Adjacent
			else
				if(ismob(A)) // No instant mob attacking
					setClickCooldown(get_attack_speed())
				UnarmedAttack(A, 1)
			trigger_aiming(TARGET_CAN_CLICK)
			return
		else // non-adjacent click
			if(W)
				W.afterattack(A, src, 0, params) // 0: not Adjacent
			else
				RangedAttack(A, params)

			trigger_aiming(TARGET_CAN_CLICK)
	return 1

/mob/proc/setClickCooldown(var/timeout)
	next_click = max(world.time + timeout, next_click)

/mob/proc/checkClickCooldown()
	if(next_click > world.time && !config.no_click_cooldown)
		return FALSE
	return TRUE

// Default behavior: ignore double clicks, the second click that makes the doubleclick call already calls for a normal click
/mob/proc/DblClickOn(var/atom/A, var/params)
	return

/*
	Translates into attack_hand, etc.

	Note: proximity_flag here is used to distinguish between normal usage (flag=1),
	and usage when clicking on things telekinetically (flag=0).  This proc will
	not be called at ranged except with telekinesis.

	proximity_flag is not currently passed to attack_hand, and is instead used
	in human click code to allow glove touches only at melee range.
*/
/mob/proc/UnarmedAttack(var/atom/A, var/proximity_flag)
	return

/mob/living/UnarmedAttack(var/atom/A, var/proximity_flag)

	if(is_incorporeal())
		return 0

	if(!ticker)
		to_chat(src, "You cannot attack people before the game has started.")
		return 0

	if(stat)
		return 0

	// prevent picking up items while being in them
	if(istype(A, /obj/item) && A == loc)
		return 0

	return 1

/*
	Ranged unarmed attack:

	This currently is just a default for all mobs, involving
	laser eyes and telekinesis.  You could easily add exceptions
	for things like ranged glove touches, spitting alien acid/neurotoxin,
	animals lunging, etc.
*/
/mob/proc/RangedAttack(var/atom/A, var/params)
	if(!mutations.len) return
	if((LASER in mutations) && a_intent == I_HURT)
		LaserEyes(A) // moved into a proc below
	else if(TK in mutations)
		if(get_dist(src, A) > tk_maxrange)
			return
		A.attack_tk(src)
/*
	Restrained ClickOn

	Used when you are handcuffed and click things.
	Not currently used by anything but could easily be.
*/
/mob/proc/RestrainedClickOn(var/atom/A)
	return

/*
	Middle click
	Only used for swapping hands
*/
/mob/proc/MiddleClickOn(var/atom/A)
	swap_hand()
	return

// In case of use break glass
/*
/atom/proc/MiddleClick(var/mob/M as mob)
	return
*/

/*
	Shift middle click
	Used for pointing.
*/

/mob/proc/ShiftMiddleClickOn(atom/A)
	pointed(A)
	return

/*
	Shift click
	For most mobs, examine.
	This is overridden in ai.dm
*/
/mob/proc/ShiftClickOn(var/atom/A)
	A.ShiftClick(src)
	return
/atom/proc/ShiftClick(var/mob/user)
	if(user.client && user.client.eye == user)
		user.examinate(src)
	return

/*
	Ctrl click
	For most objects, pull
*/
/mob/proc/CtrlClickOn(var/atom/A)
	A.CtrlClick(src)
	return
/atom/proc/CtrlClick(var/mob/user)
	return

/atom/movable/CtrlClick(var/mob/user)
	if(Adjacent(user))
		user.start_pulling(src)

/turf/CtrlClick(var/mob/user)
	user.stop_pulling()

/*
	Alt click
	Unused except for AI
*/
/mob/proc/AltClickOn(var/atom/A)
	A.AltClick(src)
	return

/atom/proc/AltClick(var/mob/user)
	var/turf/T = get_turf(src)
	if(T && user.TurfAdjacent(T))
		user.set_listed_turf(T)
	return 1

/mob/proc/TurfAdjacent(var/turf/T)
	return T.AdjacentQuick(src)

/*
	Control+Shift click
	Unused except for AI
*/
/mob/proc/CtrlShiftClickOn(var/atom/A)
	A.CtrlShiftClick(src)
	return

/atom/proc/CtrlShiftClick(var/mob/user)
	return

/*
	Misc helpers

	Laser Eyes: as the name implies, handles this since nothing else does currently
	face_atom: turns the mob towards what you clicked on
*/
/mob/proc/LaserEyes(atom/A, params)
	return

/mob/living/LaserEyes(atom/A, params)
	setClickCooldown(4)
	var/turf/T = get_turf(src)

	var/obj/item/projectile/beam/LE = new (T)
	LE.icon = 'icons/effects/genetics.dmi'
	LE.icon_state = "eyelasers"
	playsound(src, 'sound/weapons/taser2.ogg', 75, 1)
	LE.firer = src
	LE.preparePixelProjectile(A, src, params)
	LE.fire()

/mob/living/carbon/human/LaserEyes(atom/A, params)
	if(nutrition>0)
		..()
		nutrition = max(nutrition - rand(1,5),0)
		handle_regular_hud_updates()
	else
		to_chat(src, span_warning("You're out of energy!  You need food!"))

// Simple helper to face what you clicked on, in case it should be needed in more than one place
/mob/proc/face_atom(var/atom/A)
	if(!A || !x || !y || !A.x || !A.y) return
	var/dx = A.x - x
	var/dy = A.y - y
	if(!dx && !dy) return

	var/direction
	if(abs(dx) < abs(dy))
		if(dy > 0)	direction = NORTH
		else		direction = SOUTH
	else
		if(dx > 0)	direction = EAST
		else		direction = WEST
	if(direction != dir)
		facedir(direction)

/obj/screen/click_catcher
	name = "" // Empty string names don't show up in context menu clicks
	icon = 'icons/mob/screen_gen.dmi'
	icon_state = "click_catcher"
	plane = CLICKCATCHER_PLANE
	layer = LAYER_HUD_UNDER
	mouse_opacity = 2
	screen_loc = "SOUTHWEST to NORTHEAST"

/obj/screen/click_catcher/Initialize(mapload, ...)
	. = ..()
	verbs.Cut()

/obj/screen/click_catcher/Click(location, control, params)
	var/list/modifiers = params2list(params)
	if(modifiers["middle"] && istype(usr, /mob/living/carbon))
		var/mob/living/carbon/C = usr
		C.swap_hand()
	else
		var/list/P = params2list(params)
		var/turf/T = screen_loc2turf(P["screen-loc"], get_turf(usr))
		if(T)
			if(modifiers["shift"])
				usr.face_atom(T)
				return 1
			T.Click(location, control, params)
	return 1
