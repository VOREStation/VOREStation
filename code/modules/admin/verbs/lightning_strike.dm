/client/proc/admin_lightning_strike()
	set name = "Lightning Strike"
	set desc = "Causes lightning to strike on your tile. This can be made to hurt things on or nearby it severely."
	set category = "Fun"

	if(!check_rights(R_FUN))
		return

	var/result = tgui_alert(src, "Really strike your tile with lightning?", "Confirm Badmin" , list("No", "Yes (Cosmetic)", "Yes (Real)"))

	if(result == "No")
		return
	var/fake_lightning = result == "Yes (Cosmetic)"

	lightning_strike(get_turf(usr), fake_lightning)
	log_and_message_admins("[key_name(src)] has caused [fake_lightning ? "cosmetic":"harmful"] lightning to strike at their position ([src.mob.x], [src.mob.y], [src.mob.z]). \
	(<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[src.mob.x];Y=[src.mob.y];Z=[src.mob.z]'>JMP</a>)")

#define LIGHTNING_REDIRECT_RANGE 28 // How far in tiles certain things draw lightning from.
#define LIGHTNING_ZAP_RANGE 3 // How far the tesla effect zaps, as well as the bad effects from a direct strike.
#define LIGHTNING_POWER 20000 // How much 'zap' is in a strike, used for tesla_zap().

// The real lightning proc.
// This is global until I can figure out a better place for it.
// T is the turf that is being struck. If cosmetic is true, the lightning won't actually hurt anything.
/proc/lightning_strike(turf/T, cosmetic = FALSE)
	// First, visuals.

	// Do a lightning flash for the whole planet, if the turf belongs to a planet.
	var/datum/planet/P = null
	P = LAZYACCESS(SSplanets.z_to_planet, T.z)
	if(P)
		var/datum/weather_holder/holder = P.weather_holder
		flick("lightning_flash", holder.special_visuals)

	// Before we do the other visuals, we need to see if something is going to hijack our intended target.
	var/obj/machinery/power/grounding_rod/ground = null // Most of the bad effects of lightning will get negated if a grounding rod is nearby.
	var/obj/machinery/power/tesla_coil/coil = null // However a tesla coil has higher priority and the strike will bounce.

	for(var/obj/machinery/power/thing in range(LIGHTNING_REDIRECT_RANGE, T))
		if(istype(thing, /obj/machinery/power/tesla_coil))
			var/turf/simulated/coil_turf = get_turf(thing)
			if(istype(coil_turf) && thing.anchored && coil_turf.is_outdoors())
				coil = thing
				break

		if(istype(thing, /obj/machinery/power/grounding_rod))
			var/turf/simulated/rod_turf = get_turf(thing)
			if(istype(rod_turf) && thing.anchored && rod_turf.is_outdoors())
				ground = thing

	if(coil) // Coil gets highest priority.
		T = coil.loc
	else if(ground)
		T = ground.loc

	// Now make the lightning strike sprite. It will fade and delete itself in a second.
	new /obj/effect/temporary_effect/lightning_strike(T)

	// For those close up.
	playsound(T, 'sound/effects/lightningbolt.ogg', 100, 1)

	// And for those far away. If the strike happens on a planet, everyone on the planet will hear it.
	// Otherwise only those on the current z-level will hear it.
	var/sound = get_sfx("thunder")
	for(var/mob/M in player_list)
		if( (P && (M.z in P.expected_z_levels)) || M.z == T.z)
			if(M.is_preference_enabled(/datum/client_preference/weather_sounds))
				M.playsound_local(get_turf(M), soundin = sound, vol = 70, vary = FALSE, is_global = TRUE)

	if(cosmetic) // Everything beyond here involves potentially damaging things. If we don't want to do that, stop now.
		return

	if(ground) // All is well.
		ground.tesla_act(LIGHTNING_POWER, FALSE)
		return

	else if(coil) // Otherwise lets bounce off the tesla coil.
		coil.tesla_act(LIGHTNING_POWER, TRUE)

	else // Striking the turf directly.
		tesla_zap(T, zap_range = LIGHTNING_ZAP_RANGE, power = LIGHTNING_POWER, explosive = FALSE, stun_mobs = TRUE)

	// Some extra effects.
	// Some apply to those within zap range, others if they were a bit farther away.
	for(var/mob/living/L in view(5, T))
		if(get_dist(L, T) <= LIGHTNING_ZAP_RANGE) // They probably got zapped.
			L.lightning_act()

		// Deafen them.
		if(L.get_ear_protection() < 2)
			L.AdjustSleeping(-100)
			if(ishuman(L))
				var/mob/living/human/C = L
				C.ear_deaf += 10
			to_chat(L, span("danger", "Lightning struck nearby, and the thunderclap is deafening!"))

#undef LIGHTNING_ZAP_RANGE
#undef LIGHTNING_POWER
