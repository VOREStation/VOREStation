//Fire aberration
/obj/effect/abstract/aberration/spawner/lightning
	name = "Lightning aberration"
	effect_to_spawn = /obj/effect/abstract/aberration/lightning

/obj/effect/abstract/aberration/spawner/lightning/small
	range = 2
	percent_drop = 30

/obj/effect/abstract/aberration/lightning //Shares a lot of code with the fire one...Perhaps we could condense a lot of this down into a singular proc they both share?
	icon = 'icons/obj/traps/aberrations.dmi'
	icon_state = "aberr_lightning"
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	COOLDOWN_DECLARE(shock_timer)

/obj/effect/abstract/aberration/lightning/Crossed(atom/movable/AM)
	. = ..()
	if(AM.is_incorporeal() || isobserver(AM) || istype(AM, /obj/effect/abstract))
		return
	if(isitem(AM))
		var/obj/item/item_check = AM
		if(item_check.item_flags & ABSTRACT)
			return
	if(iseffect(AM))
		return
	if(COOLDOWN_FINISHED(src, shock_timer))
		zap_entity(AM)

/obj/effect/abstract/aberration/lightning/proc/reset_trap()
	for(var/mob/living/living_being in get_turf(src))
		if(living_being.is_incorporeal() || (living_being.stat == DEAD))
			continue
		zap_entity(living_being)


/obj/effect/abstract/aberration/lightning/proc/zap_entity(atom/movable/target)

	/* //Alternate lightning visual
	var/turf/our_turf = get_turf(src)
	if(our_turf)
		lightning_strike(our_turf, TRUE) //cosmetic so we don't have it jump to tesla coils and stuff.
	*/
	var/turf/T = get_step(get_step(target, NORTH), NORTH)
	T.Beam(target, icon_state="lightning[rand(1,12)]", time = 5)

	//The below sound code stolen directly from lightning code.
	var/datum/planet/P = null
	P = LAZYACCESS(SSplanets.z_to_planet, T.z)
	if(P)
		var/datum/weather_holder/holder = P.weather_holder
		flick("lightning_flash", holder.special_visuals)
	// For those close up.
	playsound(T, 'sound/effects/lightningbolt.ogg', 100, 1)

	// And for those far away. If the strike happens on a planet, everyone on the planet will hear it.
	// Otherwise only those on the current z-level will hear it.
	var/sound = get_sfx("thunder")
	for(var/mob/M in GLOB.player_list)
		if( (P && (M.z in P.expected_z_levels)) || M.z == T.z)
			if(M.check_sound_preference(/datum/preference/toggle/weather_sounds))
				M.playsound_local(get_turf(M), soundin = sound, vol = 10, vary = FALSE, is_global = TRUE)

	if(isliving(target))
		var/mob/living/living_target = target
		if(living_target.electrocute_act(45, def_zone = BP_TORSO))
			living_target.SetParalysis(2)
			living_target.SetStunned(0) //Get rid of electrocute_act stun
			living_target.stuttering += 20
			living_target.make_jittery(150)
		living_target.emp_act(EMP_HEAVY)
	target.visible_message(span_danger("[target] is struck by lightning!"))
	alpha = 125
	flick("aberr_lightning2", src)
	animate(src, alpha = 255, time = 7 SECONDS)
	addtimer(CALLBACK(src, PROC_REF(reset_trap)), 7 SECONDS, TIMER_DELETE_ME|TIMER_UNIQUE) //Long reset beause it does a long KO.
	COOLDOWN_START(src, shock_timer, 7 SECONDS)
