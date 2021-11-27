/obj/item/capture_crystal
	name = "curious crystal"
	desc = "A silent, unassuming crystal in what appears to be some kind of steel housing."
	icon = 'icons/obj/capture_crystal_vr.dmi'
	icon_state = "inactive"
	drop_sound = 'sound/items/drop/ring.ogg'
	pickup_sound = 'sound/items/pickup/ring.ogg'
	var/active = FALSE
	var/owner
	var/mob/living/bound_mob
	var/stored_mob = FALSE
	var/spawn_mob_type
	var/activate_cooldown = 30 SECONDS
	var/last_activate

/obj/item/capture_crystal/Initialize()
	. = ..()
	if(spawn_mob_type)
		icon_state = "full"

/obj/item/capture_crystal/attack_self(mob/living/user)
	if(world.time < last_activate + activate_cooldown)
		to_chat(user, "<span class='notice'>\The [src] emits an unpleasant tone... It is not ready yet.</span>")
		return
	last_activate = world.time
	if(user == bound_mob)
		to_chat(user, "<span class='notice'>\The [src] emits an unpleasant tone... It does not activate for you.</span>")
		return
	if(!active)
		activate(user)
		return
	if(bound_mob && stored_mob)
		unleash(user)
	else if(bound_mob)
		recall(user)
	else
		to_chat(user, "<span class='notice'>\The [src] clicks unsatisfyingly.</span>")
		active = FALSE
		icon_state = "inactive"
		owner = null

/obj/item/capture_crystal/proc/knowyoursignals(mob/living/M, mob/living/U)
	RegisterSignal(M, COMSIG_PARENT_QDELETING, .proc/mob_was_deleted)
	RegisterSignal(U, COMSIG_PARENT_QDELETING, .proc/owner_was_deleted)

/obj/item/capture_crystal/proc/capture(mob/living/M, mob/living/U)
	knowyoursignals(M, U)
	owner = U
	if(!bound_mob)
		bound_mob = M

/obj/item/capture_crystal/proc/mob_was_deleted()
	UnregisterSignal(bound_mob, COMSIG_PARENT_QDELETING)
	bound_mob = null
	owner = null
	active = FALSE
	icon_state = "inactive"

/obj/item/capture_crystal/proc/owner_was_deleted()
	UnregisterSignal(owner, COMSIG_PARENT_QDELETING)
	owner = null
	active = FALSE
	icon_state = "inactive"

/obj/item/capture_crystal/proc/activate(mob/living/user)
	if(spawn_mob_type && !bound_mob)
		bound_mob = new spawn_mob_type(src)
		bound_mob.faction = user.faction
		stored_mob = TRUE
		spawn_mob_type = null
		capture(bound_mob, user)
	if(bound_mob)
		user.visible_message("\The [src] clicks, and then emits a small chime.", "\The [src] grows warm in your hand, something inside is awake.")
		active = TRUE
		unleash(user)
	else
		to_chat(user, "<span class='notice'>\The [src] clicks unsatisfyingly.</span>")

/obj/item/capture_crystal/proc/recall(mob/living/user)
	if(bound_mob in view(user))
		//flick_overlay_view(coolanimation, bound_mob.loc, 11, FALSE)
		var/turf/turfmemory = get_turf(bound_mob)
		if(isanimal(bound_mob))
			var/mob/living/simple_mob/M = bound_mob
			M.ai_holder.go_sleep()
		bound_mob.forceMove(src)
		icon_state = "full"
		stored_mob = TRUE
		bound_mob.visible_message("\The [user]'s [src] flashes, disappearing [bound_mob] in an instant!!!", "\The [src] pulls you back into confinement in a flash of light!!!")
		animate_action(turfmemory)
	else
		to_chat(user, "<span class='notice'>\The [src] clicks and emits a small, unpleasant tone. \The [bound_mob] cannot be recalled.</span>")

/obj/item/capture_crystal/proc/unleash(mob/living/user, atom/target)
	if(!target)
		bound_mob.forceMove(user.drop_location())
	else
		bound_mob.forceMove(target)
	icon_state = "empty"
	stored_mob = FALSE
	//flick_overlay_view(coolanimation, bound_mob, 11, FALSE)
	if(isanimal(bound_mob))
		var/mob/living/simple_mob/M = bound_mob
		M.ai_holder.go_wake()
	bound_mob.visible_message("\The [user]'s [src] flashes, \the [bound_mob] appears in an instant!!!", "The world around you rematerialize as you are unleashed from the [src] next to \the [user].")
	animate_action(get_turf(bound_mob))

/obj/item/capture_crystal/proc/animate_action(atom/thing)
	var/image/coolanimation = image('icons/obj/capture_crystal_vr.dmi', null, "animation")
	coolanimation.plane = PLANE_LIGHTING_ABOVE
	thing.overlays += coolanimation
	sleep(11)
	thing.overlays -= coolanimation

/obj/item/capture_crystal/digest_act(var/atom/movable/item_storage = null)
	if(bound_mob && bound_mob.digestable)
		return TRUE
	else
		return FALSE

/obj/item/capture_crystal/throw_at(atom/target, range, speed, mob/thrower, spin = TRUE, datum/callback/callback)
	. = ..()
	if(!stored_mob || !bound_mob)
		return
	sleep(10)
	unleash(thrower, target)

/obj/item/capture_crystal/woof
	spawn_mob_type = /mob/living/simple_mob/vore/woof/cass
/obj/item/capture_crystal/adg
	spawn_mob_type = /mob/living/simple_mob/mechanical/mecha/combat/gygax/dark/advanced
