// An item-targeted transformation ray. Load an item into it, then shoot someone to turn them into that item.
// See mob_tf.dm for the transformation code. This is probably garbage!

/obj/item/gun/energy/itemray
	name = "item ray"
	desc = "A strange ray gun with a small loading slot. It seems designed to turn living beings into a loaded item."
	icon = 'icons/obj/mouseray.dmi'
	icon_state = "mouseray"
	item_state = "mouseray"
	fire_sound = 'sound/weapons/wave.ogg'
	projectile_type = /obj/item/projectile/beam/itemlaser
	battery_lock = TRUE

	var/obj/item/loaded_item = null
	var/cooldown = 0
	var/cooldown_time = 15 SECONDS
	var/tf_admin_pref_override = FALSE
	var/tf_allow_emotes = TRUE

/obj/item/gun/energy/itemray/proc/receive_returned_item(obj/item/I, turf/fallback)
	if(!I)
		return
	if(loaded_item && loaded_item != I)
		I.forceMove(fallback)
		I.item_tf_return_to = null
		return
	I.forceMove(src)
	loaded_item = I
	I.item_tf_return_to = null
	visible_message(span_notice("\The [I] pops out of \the [src] with a soft ding."))
	playsound(src.loc, 'sound/machines/ding.ogg', 40, 1)

/obj/item/proc/revert_item_tf(turf/fallback)
	// Return this item to its recorded owner (item ray) or delete it if no owner is set.
	if(!fallback)
		fallback = get_turf(src)
	var/atom/movable/return_to = item_tf_return_to?.resolve()
	if(item_tf_return_to)
		if(istype(return_to, /obj/item/gun/energy/itemray))
			var/obj/item/gun/energy/itemray/gun = return_to
			if(gun)
				gun.receive_returned_item(src, fallback)
		else
			forceMove(return_to || fallback)
		item_tf_return_to = null
		return TRUE
	qdel(src)
	return FALSE

/obj/item/gun/energy/itemray/examine(mob/user)
	. = ..()
	if(loaded_item)
		. += span_notice("It currently has \the [loaded_item] loaded.")
	else
		. += span_notice("It is currently empty. You could insert an item into it.")

/obj/item/gun/energy/itemray/attackby(obj/item/W, mob/user)
	if(!istype(W))
		return ..()
	if(loaded_item)
		to_chat(user, span_warning("\The [src] already has something loaded."))
		return
	if(W == src)
		return
	if(is_type_in_list(W, GLOB.item_vore_blacklist))
		to_chat(user, span_warning("\The [W] resists being loaded into \the [src]."))
		return
	if(W.possessed_voice && W.possessed_voice.len)
		to_chat(user, span_warning("\The [src] detects that \the [W] is inhabited and refuses to accept it."))
		return

	user.drop_from_inventory(W)
	W.forceMove(src)
	W.item_tf_return_to = WEAKREF(src)
	loaded_item = W
	to_chat(user, span_notice("You load [W] into \the [src]."))

/obj/item/gun/energy/itemray/attack_self(mob/user)
	. = ..(user)
	if(.)
		return TRUE
	if(!loaded_item)
		to_chat(user, span_notice("\The [src] is empty."))
		return TRUE
	var/turf/T = get_turf(user)
	loaded_item.forceMove(T)
	loaded_item.item_tf_return_to = null
	to_chat(user, span_notice("You eject [loaded_item] from \the [src]."))
	loaded_item = null
	return TRUE

/obj/item/gun/energy/itemray/Destroy()
	if(loaded_item)
		var/turf/T = get_turf(src)
		if(T)
			loaded_item.forceMove(T)
		loaded_item.item_tf_return_to = null
		loaded_item = null
	return ..()

/obj/item/gun/energy/itemray/Fire(atom/target, mob/living/user, clickparams, pointblank, reflex)
	if(world.time < cooldown)
		to_chat(user, span_warning("\The [src] isn't ready yet."))
		return
	if(!loaded_item)
		to_chat(user, span_warning("\The [src] clicks harmlessly. It has nothing loaded!"))
		return
	if(loaded_item.possessed_voice && loaded_item.possessed_voice.len)
		// The user should never be able to see this but just in case.
		to_chat(user, span_warning("\The [src] refuses to fire while its loaded item is inhabited."))
		return
	. = ..()

/obj/item/gun/energy/itemray/Fire_userless(atom/target)
	if(world.time < cooldown)
		return
	if(!loaded_item)
		return
	if(loaded_item.possessed_voice && loaded_item.possessed_voice.len)
		return
	. = ..()

/obj/item // A weakref back to the gun that loaded this item, so that OOC escape and recombobulation rays can return it properly.
	var/datum/weakref/item_tf_return_to = null

/obj/item/gun/energy/itemray/consume_next_projectile()
	. = ..()
	var/obj/item/projectile/beam/itemlaser/P = .
	cooldown = world.time + cooldown_time
	P.gun_ref = WEAKREF(src)
	if(loaded_item)
		P.loaded_item_ref = WEAKREF(loaded_item)
	P.tf_admin_pref_override = tf_admin_pref_override
	P.tf_allow_emotes = tf_allow_emotes


/obj/item/projectile/beam/itemlaser
	name = "transmutation beam"
	icon_state = "xray"
	nodamage = 1
	damage = 0
	range = 7
	check_armour = "laser"
	can_miss = FALSE

	var/datum/weakref/gun_ref
	var/datum/weakref/loaded_item_ref
	var/tf_admin_pref_override = FALSE

	muzzle_type = /obj/effect/projectile/muzzle/laser_omni
	tracer_type = /obj/effect/projectile/tracer/laser_omni
	impact_type = /obj/effect/projectile/impact/laser_omni

/obj/item/projectile/beam/itemlaser/on_hit(var/atom/target)
	var/mob/living/M = target
	if(!istype(M))
		return
	if(istype(M, /mob/living/carbon) && !M.mind)
		return

	if(target != firer)
		if(!M.allow_spontaneous_tf && !tf_admin_pref_override)
			firer?.visible_message(span_warning("\The [shot_from] buzzes impolitely."))
			return

	var/obj/item/I = loaded_item_ref?.resolve()
	if(!I)
		firer?.visible_message(span_warning("\The [shot_from] sputters uselessly."))
		return

	M.drop_both_hands()
	var/turf/T = get_turf(M)
	if(!T)
		return
	I.forceMove(T)

	M.tf_into(I, TRUE)

	var/obj/item/gun/energy/itemray/gun = gun_ref ? gun_ref.resolve() : null
	if(gun && gun.loaded_item == I)
		gun.loaded_item = null

	return
