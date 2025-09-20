/// Code (OBJECTS) in here gets used by the unit tests, but also regular code to test specific things.
/// But because unit_tests are rather late in the loading order, we have to put objects that get shared in here.
/// Else OpenDream gets very angry.

// Used to test distillations without hacking the other machinery's code up
/obj/distilling_tester
	icon = 'icons/obj/weapons.dmi'
	icon_state = "cartridge"
	var/datum/gas_mixture/GM = new()
	var/current_temp = 0
	var/datum/reagents/instant_catcher
	var/had_instant_reaction = FALSE

/obj/distilling_tester/Initialize(mapload)
	create_reagents(5000,/datum/reagents/distilling)
	instant_catcher = new /datum/reagents(5000, src)
	#ifdef UNIT_TESTS
	RegisterSignal(instant_catcher, COMSIG_UNITTEST_DATA, PROC_REF(get_signal_data))
	#endif
	. = ..()

/obj/distilling_tester/return_air()
	return GM

/obj/distilling_tester/proc/check_instants()
	had_instant_reaction = FALSE
	instant_catcher.clear_reagents()
	reagents.trans_to_holder(instant_catcher,reagents.maximum_volume,1,TRUE) // Copy them
	instant_catcher.handle_reactions()
	return had_instant_reaction

/obj/distilling_tester/proc/test_distilling(var/decl/chemical_reaction/distilling/D, var/temp_prog)
	// Do the actual test
	QDEL_SWAP(GM,new())
	if(D.require_xgm_gas)
		GM.gas[D.require_xgm_gas] = 100
	else
		if(D.rejects_xgm_gas == GAS_N2)
			GM.gas[GAS_O2] = 100
		else
			GM.gas[GAS_N2] = 100
	if(D.minimum_xgm_pressure)
		GM.temperature = (D.minimum_xgm_pressure * CELL_VOLUME) / (GM.gas[D.require_xgm_gas] * R_IDEAL_GAS_EQUATION)

	// Try this 10 times, We need to know if something is blocking at multiple temps.
	// If it passes unit test, it might still be awful to make though, gotta find the right gas mix!
	current_temp = LERP( D.temp_range[1], D.temp_range[2], temp_prog)
	reagents.handle_reactions()

/obj/distilling_tester/proc/get_signal_data()
	SIGNAL_HANDLER
	had_instant_reaction = TRUE

/obj/distilling_tester/Destroy(force, ...)
	QDEL_NULL(GM)
	#ifdef UNIT_TESTS
	UnregisterSignal(instant_catcher, COMSIG_UNITTEST_DATA)
	#endif
	QDEL_NULL(instant_catcher)
	. = ..()
