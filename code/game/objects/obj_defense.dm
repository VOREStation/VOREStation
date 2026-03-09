///Called when the obj is exposed to fire.
/obj/fire_act(exposed_temperature, exposed_volume)
	if(HAS_TRAIT(src, TRAIT_UNDERFLOOR))
		return
	var/potential_damage = 0.02 * exposed_temperature
	if(exposed_temperature && !(resistance_flags & FIRE_PROOF) && (potential_damage > damage_deflection))
		take_damage(clamp(potential_damage, 0, 20), BURN, FIRE, 0)
	if(QDELETED(src)) // take_damage() can send our obj to an early grave, let's stop here if that happens
		return
	if(!(resistance_flags & ON_FIRE) && (resistance_flags & FLAMMABLE) && !(resistance_flags & FIRE_PROOF))
		AddComponent(/datum/component/burning, custom_fire_overlay() || GLOB.fire_overlay, burning_particles)
		SEND_SIGNAL(src, COMSIG_ATOM_FIRE_ACT, exposed_temperature, exposed_volume)
		return TRUE
	return ..()

/// Returns a custom fire overlay, if any
/obj/proc/custom_fire_overlay()
	return custom_fire_overlay

///called when the obj is destroyed by acid.
/obj/proc/acid_melt()
	deconstruct(FALSE)

/// Should be called when the atom is destroyed by fire, comparable to acid_melt() proc
/obj/proc/burn()
	deconstruct(FALSE)

/**
 * Custom behaviour per atom subtype on how they should deconstruct themselves
 * Arguments
 *
 * * disassembled - TRUE means we cleanly took this atom apart using tools. FALSE means this was destroyed in a violent way
 */
/obj/proc/atom_deconstruct(disassembled = TRUE)
	PROTECTED_PROC(TRUE)

	return

/**
 * The interminate proc between deconstruct() & atom_deconstruct(). By default this delegates deconstruction to
 * atom_deconstruct if NO_DEBRIS_AFTER_DECONSTRUCTION is absent but subtypes can override this to handle NO_DEBRIS_AFTER_DECONSTRUCTION in their
 * own unique way. Override this if for example you want to dump out important content like mobs from the
 * atom before deconstruction regardless if NO_DEBRIS_AFTER_DECONSTRUCTION is present or not
 * Arguments
 *
 * * disassembled - TRUE means we cleanly took this atom apart using tools. FALSE means this was destroyed in a violent way
 */
/obj/proc/handle_deconstruct(disassembled = TRUE)
	SHOULD_CALL_PARENT(FALSE)

	if(!(obj_flags & NO_DEBRIS_AFTER_DECONSTRUCTION))
		atom_deconstruct(disassembled)

/obj/proc/deconstruct(disassembled = TRUE)
	SHOULD_NOT_OVERRIDE(TRUE)

	//allow objects to deconstruct themselves
	handle_deconstruct(disassembled)

	//inform objects we were deconstructed
	SEND_SIGNAL(src, COMSIG_OBJ_DECONSTRUCT, disassembled)

	//delete our self
	qdel(src)

///what happens when the obj's integrity reaches zero.
/obj/atom_destruction(damage_flag)
	. = ..()
	if(damage_flag == ACID)
		acid_melt()
	else if(damage_flag == FIRE)
		burn()
	else
		deconstruct(FALSE)
