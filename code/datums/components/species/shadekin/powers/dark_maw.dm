/datum/power/shadekin/dark_maw
	name = "Dark Maw (20)"
	desc = "Create a trap to capture others, or steal people from phase"
	verbpath = /mob/living/proc/dark_maw
	ability_icon_state = "dark_maw_ic"

/mob/living/proc/dark_maw()
	set name = "Dark Maw (20)"
	set desc = "Create a trap to capture others, or steal people from phase"
	set category = "Abilities.Shadekin"

	var/ability_cost = 20

	var/datum/component/shadekin/SK = get_shadekin_component()
	if(!SK)
		return FALSE
	if(stat)
		to_chat(src, span_warning("Can't use that ability in your state!"))
		return FALSE

	if(SK.shadekin_get_energy() < ability_cost)
		to_chat(src, span_warning("Not enough energy for that ability!"))
		return FALSE

	var/turf/T = get_turf(src)
	if(!istype(T))
		to_chat(src, span_warning("You don't seem to be able to set a trap here!"))
		return FALSE

	if(T.get_lumcount() >= 0.5)
		to_chat(src, span_warning("There is too much light here for your trap to last!"))
		return FALSE

	if(do_after(src, 10))
		if(SK.in_phase)
			new /obj/effect/abstract/dark_maw(loc, src, TRUE)
		else
			new /obj/effect/abstract/dark_maw(loc, src)
		SK.shadekin_adjust_energy(-ability_cost)

		return TRUE
	return FALSE

/mob/living/proc/clear_dark_maws()
	set name = "Dispel dark maws"
	set desc = "Dispel any active dark maws in place"
	set category = "Abilities.Shadekin"

	var/datum/component/shadekin/SK = get_shadekin_component()
	if(!SK)
		to_chat(src, span_warning("Only a shadekin can use that!"))
		return FALSE

	for(var/obj/effect/abstract/dark_maw/dm in SK.active_dark_maws)
		dm.dispel()

/obj/effect/abstract/dark_maw
	var/mob/living/owner = null
	var/obj/belly/target = null
	var/has_signal = FALSE
	icon = 'icons/obj/Shadekin_powers.dmi'
	icon_state = "dark_maw_waiting"

/obj/effect/abstract/dark_maw/Initialize(mapload, var/mob/user, var/trigger_now = FALSE)
	. = ..()
	if(!isturf(loc))
		return INITIALIZE_HINT_QDEL
	var/datum/component/shadekin/SK
	if(user && isliving(user))
		owner = user
		if(owner.vore_selected)
			target = owner.vore_selected
		RegisterSignal(owner, COMSIG_PARENT_QDELETING, PROC_REF(drop_everything_and_delete))
		has_signal = TRUE
		SK = owner.get_shadekin_component()

	var/turf/T = loc
	if(T.get_lumcount() >= 0.5)
		visible_message(span_notice("A set of shadowy lines flickers away in the light."))
		icon_state = "dark_maw_used"
		return INITIALIZE_HINT_QDEL


	var/mob/living/target_user = null
	for(var/mob/living/L in T)
		if(L != owner && !L.is_incorporeal())
			target_user = L
			break

	if(istype(target_user))
		triggered_by(target_user, 1)
		// to trigger rebuild
	else if(trigger_now)
		icon_state = "dark_maw_used"
		flick("dark_maw_tr", src)
		visible_message(span_warning("A set of crystals suddenly springs from the ground and shadowy tendrils wrap around nothing before vanishing."))
		QDEL_IN(src, 3 SECONDS)
	else
		if(SK)
			SK.active_dark_maws += src
		flick("dark_maw", src)
		START_PROCESSING(SSobj, src)

///Called when we get a signal that our owner is being qdel'd
/obj/effect/abstract/dark_maw/proc/drop_everything_and_delete()
	SIGNAL_HANDLER
	qdel(src)

/obj/effect/abstract/dark_maw/Destroy()
	STOP_PROCESSING(SSobj, src)
	if(owner)
		if(has_signal)
			UnregisterSignal(owner, COMSIG_PARENT_QDELETING)
		var/datum/component/shadekin/SK = owner.get_shadekin_component()
		if(SK)
			SK.active_dark_maws -= src
	owner = null
	target = null
	return ..()

/obj/effect/abstract/dark_maw/Crossed(O)
	. = ..()
	if(!isliving(O))
		return
	if(icon_state != "dark_maw_waiting")
		return
	var/mob/living/L = O
	if(!L.is_incorporeal() && (!owner || L != owner))
		triggered_by(L)

/obj/effect/abstract/dark_maw/process()
	var/turf/T = get_turf(src)
	if(!istype(T) || T.get_lumcount() >= 0.5)
		dispel()

/obj/effect/abstract/dark_maw/proc/dispel()
	if(icon_state == "dark_maw_waiting")
		visible_message(span_notice("A set of shadowy lines flickers away in the light."))
	else
		visible_message(span_notice("The crystals and shadowy tendrils dissipate with the light shone on it."))
	icon_state = "dark_maw_used"
	qdel(src)

/obj/effect/abstract/dark_maw/proc/triggered_by(var/mob/living/L, var/triggered_instantly = 0)
	STOP_PROCESSING(SSobj, src)
	icon_state = "dark_maw_used"
	flick("dark_maw_tr", src)
	L.AdjustStunned(4)
	visible_message(span_warning("A set of crystals spring out of the ground and shadowy tendrils start wrapping around [L]."))
	if(owner && !triggered_instantly)
		to_chat(owner, span_warning("A dark maw you deployed has triggered!"))
	addtimer(CALLBACK(src, PROC_REF(do_trigger), L), 1 SECOND, TIMER_DELETE_ME)

/obj/effect/abstract/dark_maw/proc/do_trigger(var/mob/living/L)
	var/will_vore = 1

	if(!owner || !(target in owner) || !L.devourable || !L.can_be_drop_prey || !owner.can_be_drop_pred || !L.phase_vore)
		will_vore = 0

	if(!src || src.gc_destroyed)
		//We got deleted probably, do nothing more
		return

	if(L.loc != get_turf(src))
		visible_message(span_notice("The shadowy tendrils fail to catch anything and dissipate."))
		qdel(src)
		return

	if(will_vore)
		visible_message(span_warning("The shadowy tendrils grab around [L] and drag them into the floor, leaving nothing behind."))
		L.forceMove(target)
		qdel(src)
		return

	var/obj/effect/energy_net/dark/net = new /obj/effect/energy_net/dark(get_turf(src))
	if(net.buckle_mob(L))
		visible_message(span_warning("The shadowy tendrils wrap around [L] and traps them in a net of dark energy."))
	else
		visible_message(span_notice("The shadowy tendrils wrap around [L] and then dissipate, leaving them in place."))
	qdel(src)

/obj/effect/energy_net/dark
	name = "dark net"
	desc = "It's a net made of dark energy."
	icon = 'icons/obj/Shadekin_powers.dmi'
	icon_state = "dark_net"

	escape_time = 30 SECONDS

/obj/effect/energy_net/dark/user_unbuckle_mob(mob/living/buckled_mob, mob/user)
	if(isliving(user))
		var/mob/living/unbuckler = user
		var/datum/component/shadekin/SK = unbuckler.get_shadekin_component()
		if(SK)
			visible_message(span_danger("[user] dissipates \the [src] with a touch!"))
			unbuckle_mob(buckled_mob)
			return
	. = ..()

/obj/effect/energy_net/dark/process()
	. = ..()
	var/turf/T = get_turf(src)
	if(!istype(T) || T.get_lumcount() >= 0.6)
		visible_message(span_notice("The tangle of dark tendrils fades away in the light."))
		qdel(src)
