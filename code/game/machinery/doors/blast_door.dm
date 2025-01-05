// BLAST DOORS
//
// Refactored 27.12.2014 by Atlantis
//
// Blast doors are suposed to be reinforced versions of regular doors. Instead of being manually
// controlled they use buttons or other means of remote control. This is why they cannot be emagged
// as they lack any ID scanning system, they just handle remote control signals. Subtypes have
// different icons, which are defined by set of variables. Subtypes are on bottom of this file.

// UPDATE 06.04.2018
// The emag thing wasn't working as intended, manually overwrote it.

#define BLAST_DOOR_CRUSH_DAMAGE 40
#define SHUTTER_CRUSH_DAMAGE 0 // VOREStation Edit - Shutter damage 0.

/obj/machinery/door/blast
	name = "Blast Door"
	desc = "That looks like it doesn't open easily."
	icon = 'icons/obj/doors/rapid_pdoor.dmi'
	icon_state = null
	min_force = 20 //minimum amount of force needed to damage the door with a melee weapon
	var/datum/material/implicit_material
	// Icon states for different shutter types. Simply change this instead of rewriting the update_icon proc.
	var/icon_state_open = null
	var/icon_state_opening = null
	var/icon_state_closed = null
	var/icon_state_closing = null
	var/open_sound = 'sound/machines/door/blastdooropen.ogg'
	var/close_sound = 'sound/machines/door/blastdoorclose.ogg'
	var/damage = BLAST_DOOR_CRUSH_DAMAGE
	var/multiplier = 1 // The multiplier for how powerful our YEET is.
	var/istransparent = 0

	closed_layer = ON_WINDOW_LAYER // Above airlocks when closed
	var/id = 1.0
	dir = 1
	explosion_resistance = 25

	//Most blast doors are infrequently toggled and sometimes used with regular doors anyways,
	//turning this off prevents awkward zone geometry in places like medbay lobby, for example.
	block_air_zones = 0

/obj/machinery/door/blast/Initialize()
	. = ..()
	implicit_material = get_material_by_name(MAT_PLASTEEL)

/obj/machinery/door/blast/get_material()
	return implicit_material

// Proc: Bumped()
// Parameters: 1 (AM - Atom that tried to walk through this object)
// Description: If we are open returns zero, otherwise returns result of parent function.
/obj/machinery/door/blast/Bumped(atom/AM)
	if(!density)
		return ..()
	else
		return 0

// Proc: update_icon()
// Parameters: None
// Description: Updates icon of this object. Uses icon state variables.
/obj/machinery/door/blast/update_icon()
	if(density)
		icon_state = icon_state_closed
	else
		icon_state = icon_state_open
	SSradiation.resistance_cache.Remove(get_turf(src))
	return

// Proc: emag_act()
// Description: Emag action to allow blast doors to double their yeet distance and speed.
/obj/machinery/door/blast/emag_act()
	if(!emagged)
		emagged = 1
		multiplier = 2 // Haha emag go yeet
		return 1

// Blast doors are triggered remotely, so nobody is allowed to physically influence it.
/obj/machinery/door/blast/allowed(mob/M)
	return FALSE

// Proc: force_open()
// Parameters: None
// Description: Opens the door. No checks are done inside this proc.
/obj/machinery/door/blast/proc/force_open()
	src.operating = 1
	playsound(src, open_sound, 100, 1)
	flick(icon_state_opening, src)
	src.density = FALSE
	update_nearby_tiles()
	src.update_icon()
	src.set_opacity(0)
	sleep(15)
	src.layer = open_layer
	src.operating = 0

// Proc: force_close()
// Parameters: None
// Description: Closes the door. No checks are done inside this proc.
/obj/machinery/door/blast/proc/force_close()
	// Blast door turf checks. We do this before the door closes to prevent it from failing after the door is closed, because obv a closed door will block any adjacency checks.
	var/turf/T = get_turf(src)
	var/list/yeet_turfs = T.CardinalTurfs(TRUE)

	src.operating = 1
	playsound(src, close_sound, 100, 1)
	src.layer = closed_layer
	flick(icon_state_closing, src)
	src.density = TRUE
	update_nearby_tiles()
	src.update_icon()
	if(src.istransparent)
		src.set_opacity(0)
	else
		src.set_opacity(1)
	sleep(15)
	src.operating = 0

	// Blast door crushing.
	for(var/turf/turf in locs)
		for(var/atom/movable/AM in turf)
			if(AM.airlock_crush(damage))
				if(LAZYLEN(yeet_turfs))
					AM.throw_at(get_edge_target_turf(src, get_dir(src, pick(yeet_turfs))), (rand(1,3) * multiplier), (rand(2,4) * multiplier)) // YEET.
				take_damage(damage*0.2)

// Proc: force_toggle()
// Parameters: None
// Description: Opens or closes the door, depending on current state. No checks are done inside this proc.
/obj/machinery/door/blast/proc/force_toggle(var/forced = 0, mob/user as mob)
	if (forced)
		playsound(src, 'sound/machines/door/airlock_creaking.ogg', 100, 1)

	if(src.density)
		src.force_open()
	else
		src.force_close()

//Proc: attack_hand
//Description: Attacked with empty hand. Only to allow special attack_bys.
/obj/machinery/door/blast/attack_hand(mob/user as mob)
	if(ishuman(user))
		var/mob/living/carbon/human/X = user
		if(istype(X.species, /datum/species/xenos))
			src.attack_alien(user)
			return
	..()


// Proc: attackby()
// Parameters: 2 (C - Item this object was clicked with, user - Mob which clicked this object)
// Description: If we are clicked with crowbar, wielded fire axe, or armblade, try to manually open the door.
// This only works on broken doors or doors without power. Also allows repair with Plasteel.
/obj/machinery/door/blast/attackby(obj/item/C as obj, mob/user as mob)
	src.add_fingerprint(user)
	if(istype(C, /obj/item)) // For reasons unknown, sometimes C is actually not what it is advertised as, like a mob.
		if(C.pry == 1 && (user.a_intent != I_HURT || (stat & BROKEN))) // Can we pry it open with something, like a crowbar/fireaxe/lingblade?
			if(istype(C,/obj/item/material/twohanded/fireaxe)) // Fireaxes need to be in both hands to pry.
				var/obj/item/material/twohanded/fireaxe/F = C
				if(!F.wielded)
					to_chat(user, span_warning("You need to be wielding \the [F] to do that."))
					return

			// If we're at this point, it's a fireaxe in both hands or something else that doesn't care for twohanding.
			if(((stat & NOPOWER) || (stat & BROKEN)) && !( src.operating ))
				force_toggle(1, user)

			else
				to_chat(user, span_notice("[src]'s motors resist your effort."))
			return


		else if(src.density && (user.a_intent == I_HURT)) //If we can't pry it open and it's a weapon, let's hit it.
			var/obj/item/W = C
			user.setClickCooldown(user.get_attack_speed(W))
			if(W.damtype == BRUTE || W.damtype == BURN)
				user.do_attack_animation(src)
				if(W.force < min_force)
					user.visible_message(span_danger("\The [user] hits \the [src] with \the [W] with no visible effect."))
				else
					user.visible_message(span_danger("\The [user] forcefully strikes \the [src] with \the [W]!"))
					playsound(src, hitsound, 100, 1)
					take_damage(W.force*0.35) //it's a blast door, it should take a while. -Luke
				return

	else if(istype(C, /obj/item/stack/material) && C.get_material_name() == MAT_PLASTEEL) // Repairing.
		var/amt = CEILING((maxhealth - health)/150, 1)
		if(!amt)
			to_chat(user, span_notice("\The [src] is already fully repaired."))
			return
		var/obj/item/stack/P = C
		if(P.get_amount() < amt)
			to_chat(user, span_warning("You don't have enough sheets to repair this! You need at least [amt] sheets."))
			return
		to_chat(user, span_notice("You begin repairing [src]..."))
		if(do_after(user, 30))
			if(P.use(amt))
				to_chat(user, span_notice("You have repaired \The [src]"))
				src.repair()
			else
				to_chat(user, span_warning("You don't have enough sheets to repair this! You need at least [amt] sheets."))

	else if(src.density && (user.a_intent == I_HURT)) //If we can't pry it open and it's not a weapon.... Eh, let's attack it anyway.
		var/obj/item/W = C
		user.setClickCooldown(user.get_attack_speed(W))
		if(istype(W) && (W.damtype == BRUTE || W.damtype == BURN))
			user.do_attack_animation(src)
			if(W.force < min_force) //No actual non-weapon item shouls have a force greater than the min_force, but let's include this just in case.
				user.visible_message(span_danger("\The [user] hits \the [src] with \the [W] with no visible effect."))
			else
				user.visible_message(span_danger("\The [user] forcefully strikes \the [src] with \the [W]!"))
				playsound(src, hitsound, 100, 1)
				take_damage(W.force*0.15) //If the item isn't a weapon, let's make this take longer than usual to break it down.
			return

// Proc: attack_alien()
// Parameters: Attacking Xeno mob.
// Description: Forces open the door after a delay.
/obj/machinery/door/blast/attack_alien(var/mob/user) //Familiar, right? Doors.
	if(ishuman(user))
		var/mob/living/carbon/human/X = user
		if(istype(X.species, /datum/species/xenos))
			if(src.density)
				visible_message(span_alium("\The [user] begins forcing \the [src] open!"))
				if(do_after(user, 15 SECONDS,src))
					playsound(src, 'sound/machines/door/airlock_creaking.ogg', 100, 1)
					visible_message(span_danger("\The [user] forces \the [src] open!"))
					force_open(1)
			else
				visible_message(span_alium("\The [user] begins forcing \the [src] closed!"))
				if(do_after(user, 5 SECONDS,src))
					playsound(src, 'sound/machines/door/airlock_creaking.ogg', 100, 1)
					visible_message(span_danger("\The [user] forces \the [src] closed!"))
					force_close(1)
		else
			visible_message(span_notice("\The [user] strains fruitlessly to force \the [src] [density ? "open" : "closed"]."))
			return
	..()

// Proc: attack_generic()
// Parameters: Attacking simple mob, incoming damage.
// Description: Checks the power or integrity of the blast door, if either have failed, chekcs the damage to determine if the creature would be able to open the door by force. Otherwise, super.
/obj/machinery/door/blast/attack_generic(mob/living/user, damage)
	if(stat & (BROKEN|NOPOWER))
		if(damage >= STRUCTURE_MIN_DAMAGE_THRESHOLD)
			user.set_AI_busy(TRUE) // If the mob doesn't have an AI attached, this won't do anything.
			if(src.density)
				visible_message(span_danger("\The [user] starts forcing \the [src] open!"))
				if(do_after(user, 5 SECONDS, src))
					visible_message(span_danger("\The [user] forces \the [src] open!"))
					force_open(1)
			else
				visible_message(span_danger("\The [user] starts forcing \the [src] closed!"))
				if(do_after(user, 2 SECONDS, src))
					visible_message(span_danger("\The [user] forces \the [src] closed!"))
					force_close(1)
			user.set_AI_busy(FALSE)
		else
			visible_message(span_notice("\The [user] strains fruitlessly to force \the [src] [density ? "open" : "closed"]."))
		return
	..()

// Proc: open()
// Parameters: None
// Description: Opens the door. Does necessary checks. Automatically closes if autoclose is true
/obj/machinery/door/blast/open(var/forced = 0)
	if(forced)
		force_open()
		return 1
	else
		if (src.operating || (stat & BROKEN || stat & NOPOWER))
			return 1
		force_open()

	if(autoclose && src.operating && !(stat & BROKEN || stat & NOPOWER))
		addtimer(CALLBACK(src, PROC_REF(close), 15 SECONDS))
	return 1

// Proc: close()
// Parameters: None
// Description: Closes the door. Does necessary checks.
/obj/machinery/door/blast/close()

	if (src.operating || (stat & BROKEN || stat & NOPOWER))
		return

	force_close()
	return 1

// Proc: repair()
// Parameters: None
// Description: Fully repairs the blast door.
/obj/machinery/door/blast/proc/repair()
	health = maxhealth
	if(stat & BROKEN)
		stat &= ~BROKEN

/*
// This replicates the old functionality coded into CanPass() for this object, however it appeared to have made blast doors not airtight.
// If for some reason this is actually needed for something important, uncomment this.
/obj/machinery/door/blast/CanZASPass(turf/T, is_zone)
	if(is_zone)
		return TRUE
	return ..()
*/

// SUBTYPE: Regular
// Your classical blast door, found almost everywhere.
/obj/machinery/door/blast/regular
	icon_state_open = "pdoor0"
	icon_state_opening = "pdoorc0"
	icon_state_closed = "pdoor1"
	icon_state_closing = "pdoorc1"
	icon_state = "pdoor1"
	maxhealth = 600

/obj/machinery/door/blast/regular/open
	icon_state = "pdoor0"
	density = FALSE
	opacity = 0


// SUBTYPE: Shuttle
// Slightly weaker, intergrated shutters - open state is hidden from view. Found on fancy_shuttles
/obj/machinery/door/blast/shuttle
	name = "shuttle blast doors"
	icon_state_open = "spdoor0"
	icon_state_opening = "spdoorc0"
	icon_state_closed = "spdoor1"
	icon_state_closing = "spdoorc1"
	icon_state = "spdoor1"
	maxhealth = 400

/obj/machinery/door/blast/shuttle/open
	icon_state = "spdoor0"
	density = FALSE
	opacity = 0

// SUBTYPE: Shutters
// Nicer looking, and also weaker, shutters. Found in kitchen and similar areas.
/obj/machinery/door/blast/shutters
	icon_state_open = "shutter0"
	icon_state_opening = "shutterc0"
	icon_state_closed = "shutter1"
	icon_state_closing = "shutterc1"
	icon_state = "shutter1"
	damage = SHUTTER_CRUSH_DAMAGE

// SUBTYPE: Transparent
// Not technically a blast door but operates like one. Allows air and light.
/obj/machinery/door/blast/gate
	name = "thick gate"
	icon_state_open = "tshutter0"
	icon_state_opening = "tshutterc0"
	icon_state_closed = "tshutter1"
	icon_state_closing = "tshutterc1"
	icon_state = "tshutter1"
	damage = SHUTTER_CRUSH_DAMAGE
	maxhealth = 400
	block_air_zones = 0
	opacity = 0
	istransparent = 1

/obj/machinery/door/blast/gate/open
	icon_state = "tshutter0"
	density = FALSE

/obj/machinery/door/blast/gate/thin
	name = "thin gate"
	icon_state_open = "shutter2_0"
	icon_state_opening = "shutter2_c0"
	icon_state_closed = "shutter2_1"
	icon_state_closing = "shutter2_c1"
	icon_state = "shutter2_1"
	maxhealth = 200
	opacity = 0

/obj/machinery/door/blast/gate/thin/open
	icon_state = "shutter2_1"
	density = FALSE

/obj/machinery/door/blast/gate/bars
	name = "prison bars"
	icon_state_open = "bars_0"
	icon_state_opening = "bars_c0"
	icon_state_closed = "bars_1"
	icon_state_closing = "bars_c1"
	icon_state = "bars_1"
	maxhealth = 600
	opacity = 0

/obj/machinery/door/blast/gate/bars/open
	icon_state = "bars_1"
	density = FALSE

// SUBTYPE: Multi-tile
// Pod doors ported from Paradise

 // Whoever wrote the old code for multi-tile spesspod doors needs to burn in hell. - Unknown
 // Wise words. - Bxil
/obj/machinery/door/blast/multi_tile
	name = "large blast door"

/obj/machinery/door/blast/multi_tile/Initialize(mapload)
	. = ..()
	apply_opacity_to_my_turfs(opacity)

/obj/machinery/door/blast/multi_tile/set_opacity()
	. = ..()
	apply_opacity_to_my_turfs(opacity)

/obj/machinery/door/blast/multi_tile/proc/apply_opacity_to_my_turfs(new_opacity)
	for(var/turf/T in locs)
		T.set_opacity(new_opacity)
	update_nearby_tiles()

/obj/machinery/door/blast/multi_tile
	icon_state_open = "open"
	icon_state_opening = "opening"
	icon_state_closed = "closed"
	icon_state_closing = "closing"
	icon_state = "closed"

/obj/machinery/door/blast/multi_tile/four_tile_ver_sec
	icon = 'icons/obj/doors/1x4blast_vert_sec.dmi'
	bound_height = 128
	width = 4
	dir = NORTH
	autoclose = TRUE

/obj/machinery/door/blast/multi_tile/four_tile_ver
	icon = 'icons/obj/doors/1x4blast_vert.dmi'
	bound_height = 128
	width = 4
	dir = NORTH

/obj/machinery/door/blast/multi_tile/three_tile_ver
	icon = 'icons/obj/doors/1x3blast_vert.dmi'
	bound_height = 96
	width = 3
	dir = NORTH

/obj/machinery/door/blast/multi_tile/two_tile_ver
	icon = 'icons/obj/doors/1x2blast_vert.dmi'
	bound_height = 64
	width = 2
	dir = NORTH

/obj/machinery/door/blast/multi_tile/four_tile_hor_sec
	icon = 'icons/obj/doors/1x4blast_hor_sec.dmi'
	bound_width = 128
	width = 4
	dir = EAST
	autoclose = TRUE

/obj/machinery/door/blast/multi_tile/four_tile_hor
	icon = 'icons/obj/doors/1x4blast_hor.dmi'
	bound_width = 128
	width = 4
	dir = EAST

/obj/machinery/door/blast/multi_tile/three_tile_hor
	icon = 'icons/obj/doors/1x3blast_hor.dmi'
	bound_width = 96
	width = 3
	dir = EAST

/obj/machinery/door/blast/multi_tile/two_tile_hor
	icon = 'icons/obj/doors/1x2blast_hor.dmi'
	bound_width = 64
	width = 2
	dir = EAST


#undef BLAST_DOOR_CRUSH_DAMAGE
#undef SHUTTER_CRUSH_DAMAGE
