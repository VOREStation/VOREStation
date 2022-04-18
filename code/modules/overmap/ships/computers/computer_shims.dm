/*
**
** HELLO! DON'T COPY THINGS FROM HERE - READ THIS!
**
** The ship machines/computers ported from baystation expect certain procs and infrastruture that we don't have.
** I /could/ just port those computers to our code, but I actually *like* that infrastructure. But I
** don't have time (yet) to implement it fully in our codebase, so I'm shimming it here experimentally as a test
** bed for later implementing it on /obj/machinery and /obj/machinery/computer for everything.  ~Leshana (March 2020)
*/

//
// Power
//

// Change one of the power consumption vars
/obj/machinery/proc/change_power_consumption(new_power_consumption, use_power_mode = USE_POWER_IDLE)
	switch(use_power_mode)
		if(USE_POWER_IDLE)
			update_idle_power_usage(new_power_consumption)
		if(USE_POWER_ACTIVE)
			update_active_power_usage(new_power_consumption)
	// No need to do anything else in our power scheme.

// Defining directly here to avoid conflicts with existing set_broken procs in our codebase that behave differently.
/obj/machinery/atmospherics/unary/engine/proc/set_broken(var/new_state, var/cause)
	if(!(stat & BROKEN) == !new_state)
		return // Nothing changed
	stat ^= BROKEN
	update_icon()


//
// Compoenents
//

/obj/machinery/proc/total_component_rating_of_type(var/part_type)
	. = 0
	for(var/thing in component_parts)
		if(istype(thing, part_type))
			var/obj/item/stock_parts/part = thing
			. += part.rating
	// Now isn't THIS a cool idea?
	// for(var/path in uncreated_component_parts)
	// 	if(ispath(path, part_type))
	// 		var/obj/item/stock_parts/comp = path
	// 		. += initial(comp.rating) * uncreated_component_parts[path]

//
// Skills
//
/obj/machinery/computer/ship
	var/core_skill = /datum/skill/devices //The skill used for skill checks for this machine (mostly so subtypes can use different skills).
	var/ai_control = TRUE	//VOREStation Edit

//
// Topic
//
/obj/machinery/computer/ship/tgui_state()
	return GLOB.tgui_default_state

//
// Interaction
//

// If you want to have interface interactions handled for you conveniently, use this.
// Return TRUE for handled.
// If you perform direct interactions in here, you are responsible for ensuring that full interactivity checks have been made (i.e CanInteract).
// The checks leading in to here only guarantee that the user should be able to view a UI.
/obj/machinery/computer/ship/proc/interface_interact(var/mob/user)
	tgui_interact(user)
	return TRUE

/obj/machinery/computer/ship/attack_ai(mob/user)
	//VOREStation Addition Start
	if(!ai_control && issilicon(user))
		to_chat(user, "<span class='warning'>Access Denied.</span>")
		return
	//VOREStation Addition End
	if(tgui_status(user, tgui_state()) > STATUS_CLOSE)
		return interface_interact(user)

// After a recent rework this should mostly be safe.
/obj/machinery/computer/ship/attack_ghost(mob/user)
	interface_interact(user)

// If you don't call parent in this proc, you must make all appropriate checks yourself.
// If you do, you must respect the return value.
/obj/machinery/computer/ship/attack_hand(mob/user)
	if((. = ..()))
		return
	//VOREStation Addition Start
	if(!ai_control && issilicon(user))
		to_chat(user, "<span class='warning'>Access Denied.</span>")
		return TRUE
	//VOREStation Addition End
	if(!allowed(user))
		to_chat(user, "<span class='warning'>Access Denied.</span>")
		return TRUE
	if(tgui_status(user, tgui_state()) > STATUS_CLOSE)
		return interface_interact(user)
