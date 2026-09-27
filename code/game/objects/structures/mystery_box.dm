// the different states of the mystery box
/// Closed, can't interact
#define MYSTERY_BOX_COOLING_DOWN 0
/// Closed, ready to be interacted with
#define MYSTERY_BOX_STANDBY 1
/// The box is choosing the prize
#define MYSTERY_BOX_CHOOSING 2
/// The box is presenting the prize, for someone to claim it
#define MYSTERY_BOX_PRESENTING 3

// delays for the different stages of the box's state, the visuals, and the audio
/// How long the box takes to decide what the prize is
#define MBOX_DURATION_CHOOSING (5 SECONDS)
/// How long the box takes to start expiring the offer, though it's still valid until MBOX_DURATION_EXPIRING finishes. Timed to the sound clips
#define MBOX_DURATION_PRESENTING (3.5 SECONDS)
/// How long the box takes to start lowering the prize back into itself. When this finishes, the prize is gone
#define MBOX_DURATION_EXPIRING (4.5 SECONDS)
/// How long after the box closes until it can go again
#define MBOX_DURATION_STANDBY (2.7 SECONDS)

/obj/structure/mystery_box
	name = "mystery box"
	desc = "A wooden crate that seems equally magical and mysterious, capable of granting the user all kinds of different pieces of gear."
	icon = 'icons/obj/closets/wooden.dmi'
	icon_state = ""
	pixel_y = -4
	anchored = TRUE
	density = TRUE
	max_integrity = 9999
	damage_deflection = 100

	var/crate_open_sound = 'sound/effects/wooden_closet_open.ogg'
	var/crate_close_sound = 'sound/effects/wooden_closet_close.ogg'
	var/open_sound = 'sound/effects/mbox_full.ogg'
	var/grant_sound = 'sound/effects/mbox_end.ogg'
	/// The box's current state, and whether it can be interacted with in different ways
	var/box_state = MYSTERY_BOX_STANDBY
	/// The object that represents the rapidly changing item that will be granted upon being claimed. Is not, itself, an item.
	var/obj/effect/abstract/mystery_box_item/presented_item
	/// A timer for how long it takes for the box to start its expire animation
	var/box_expire_timer
	/// A timer for how long it takes for the box to close itself
	var/box_close_timer
	/// Every type that's a child of this that has an icon, icon_state, and isn't ABSTRACT is fair game. More granularity to come
	var/selectable_base_type = /obj/item
	/// The instantiated list that contains all of the valid items that can be chosen from. Generated in [/obj/structure/mystery_box/proc/generate_valid_types]
	var/list/valid_types
	/// Stores the current sound channel we're using so we can cut off our own sounds as needed. Randomized after each roll
	var/current_sound_channel
	/// How many time can it still be used?
	var/uses_left = INFINITY
	/// A list of weakrefs to mind datums of people that opened it and how many times.
	var/list/datum/weakref/minds_that_opened_us

/obj/structure/mystery_box/Initialize(mapload)
	. = ..()
	generate_valid_types()

/obj/structure/mystery_box/Destroy()
	QDEL_NULL(presented_item)
	if(current_sound_channel)
		SSsounds.free_sound_channel(current_sound_channel)
	minds_that_opened_us = null
	return ..()

/obj/structure/mystery_box/attack_hand(mob/living/user, list/modifiers)
	. = ..()
	switch(box_state)
		if(MYSTERY_BOX_STANDBY)
			activate(user)

		if(MYSTERY_BOX_PRESENTING)
			if(presented_item.claimable)
				grant_weapon(user)

/obj/structure/mystery_box/update_icon()
	icon_state = "[initial(icon_state)][box_state > MYSTERY_BOX_STANDBY ? "open" : ""]"
	return ..()

/// This proc is used to define what item types valid_types is filled with
/obj/structure/mystery_box/proc/generate_valid_types()
	valid_types = get_sane_item_types(selectable_base_type)

/obj/structure/mystery_box/proc/activate(mob/living/user)
	box_state = MYSTERY_BOX_CHOOSING
	update_icon()
	presented_item = new(src)
	presented_item.vis_flags = VIS_INHERIT_PLANE
	vis_contents += presented_item
	presented_item.start_animation(src)
	current_sound_channel = SSsounds.reserve_sound_channel(src)
	playsound(src, open_sound, 70, FALSE, channel = current_sound_channel, falloff = 10)
	playsound(src, crate_open_sound, 80)
	if(user.mind)
		LAZYINITLIST(minds_that_opened_us)
		var/datum/weakref/ref = WEAKREF(user.mind)
		minds_that_opened_us[ref] += 1
	uses_left--

/// The box has finished choosing, mark it as available for grabbing
/obj/structure/mystery_box/proc/present_weapon()
	visible_message(span_notice("[src] presents [presented_item]!"))
	box_state = MYSTERY_BOX_PRESENTING
	box_expire_timer = addtimer(CALLBACK(src, PROC_REF(start_expire_offer)), MBOX_DURATION_PRESENTING, TIMER_STOPPABLE)

/// The prize is still claimable, but the animation will show it start to recede back into the box
/obj/structure/mystery_box/proc/start_expire_offer()
	presented_item.expire_animation()
	box_close_timer = addtimer(CALLBACK(src, PROC_REF(close_box)), MBOX_DURATION_EXPIRING, TIMER_STOPPABLE)

/// The box is closed, whether because the prize fully expired, or it was claimed. Start resetting all of the state stuff
/obj/structure/mystery_box/proc/close_box()
	box_state = MYSTERY_BOX_COOLING_DOWN
	update_icon()
	QDEL_NULL(presented_item)
	deltimer(box_close_timer)
	deltimer(box_expire_timer)
	playsound(src, crate_close_sound, 100)
	box_close_timer = null
	box_expire_timer = null
	addtimer(CALLBACK(src, PROC_REF(ready_again)), MBOX_DURATION_STANDBY)
	if(uses_left <= 0)
		visible_message(span_danger("[src] breaks down."))
		qdel(src)

/// The cooldown between activations has finished, shake to show that
/obj/structure/mystery_box/proc/ready_again()
	SSsounds.free_sound_channel(current_sound_channel)
	current_sound_channel = null
	box_state = MYSTERY_BOX_STANDBY
	Shake(3, 0, 0.5 SECONDS)

/// Someone attacked the box with an empty hand, spawn the shown prize and give it to them, then close the box
/obj/structure/mystery_box/proc/grant_weapon(mob/living/user)
	var/atom/movable/instantiated_weapon = new presented_item.selected_path(loc)
	user.visible_message(span_notice("[user] takes [presented_item] from [src]."), span_notice("You take [presented_item] from [src]."))
	playsound(src, grant_sound, 70, FALSE, channel = current_sound_channel, falloff = 10)
	close_box()

	if(!isitem(instantiated_weapon))
		return
	if(istype(instantiated_weapon, /obj/item/clothing/head) && prob(1))
		var/obj/item/clothing/head/hat = instantiated_weapon
		hat.AddComponent(/datum/component/unusual_effect, color = "#FFEA0030", include_particles = TRUE)
		hat.name = "unusual [hat.name]"
	user.put_in_hands(instantiated_weapon)

/obj/effect/abstract/mystery_box_item
	name = "???"
	desc = "Who knows what it'll be??"
	icon = 'icons/obj/weapons.dmi'
	icon_state = "sord"
	pixel_z = -4
	uses_integrity = FALSE

	/// The currently selected item. Constantly changes while choosing, determines what is spawned if the prize is claimed, and its current icon
	var/selected_path = /obj/item/toy/plushie/generic
	/// The box that spawned this
	var/obj/structure/mystery_box/parent_box
	/// Whether this prize is currently claimable
	var/claimable = FALSE

/obj/effect/abstract/mystery_box_item/Initialize(mapload)
	. = ..()
	var/matrix/starting = matrix()
	starting.Scale(0.5, 0.5)
	transform = starting
	add_filter("weapon_rays", 3, list("type" = "rays", "size" = 28, "color" = COLOR_YELLOW))

/obj/effect/abstract/mystery_box_item/Destroy(force)
	parent_box = null
	return ..()

// this way, clicking on the prize will work the same as clicking on the box
/obj/effect/abstract/mystery_box_item/attack_hand(mob/living/user, list/modifiers)
	. = ..()
	if(claimable)
		parent_box.grant_weapon(user)

/// Start pushing the prize up
/obj/effect/abstract/mystery_box_item/proc/start_animation(atom/parent)
	parent_box = parent
	loop_icon_changes()

/// Keep changing the icon and selected path
/obj/effect/abstract/mystery_box_item/proc/loop_icon_changes()
	var/change_delay = 1 // the running count of the delay
	var/change_delay_delta = 1 // How much to increment the delay per step so the changing slows down
	var/change_counter = 0 // The running count of the running count

	var/matrix/starting = matrix()
	animate(src, pixel_z = 10, transform = starting, time = MBOX_DURATION_CHOOSING, easing = QUAD_EASING | EASE_OUT)

	while((change_counter + change_delay_delta + change_delay) < MBOX_DURATION_CHOOSING)
		change_delay += change_delay_delta
		change_counter += change_delay
		selected_path = pick(parent_box.valid_types)
		addtimer(CALLBACK(src, PROC_REF(update_random_icon), selected_path), change_counter)

	addtimer(CALLBACK(src, PROC_REF(present_item)), MBOX_DURATION_CHOOSING)

/// animate() isn't up to the task for queueing up icon changes, so this is the proc we call with timers to update our icon
/obj/effect/abstract/mystery_box_item/proc/update_random_icon(new_item_type)
	var/atom/movable/new_item = new_item_type
	icon = new_item::icon
	icon_state = new_item::icon_state

/obj/effect/abstract/mystery_box_item/proc/present_item()
	var/atom/movable/selected_item = selected_path
	add_filter("ready_outline", 2, list("type" = "outline", "color" = COLOR_YELLOW, "size" = 0.2))
	name = selected_item::name
	parent_box.present_weapon()
	claimable = TRUE

/// Sink back into the box
/obj/effect/abstract/mystery_box_item/proc/expire_animation()
	var/matrix/shrink_back = matrix()
	shrink_back.Scale(0.5,0.5)
	animate(src, pixel_z = -4, transform = shrink_back, time = MBOX_DURATION_EXPIRING)

/obj/structure/mystery_box/mothroach/generate_valid_types()
	valid_types = list(/mob/living/simple_mob/animal/passive/mothroach)

/obj/structure/mystery_box/fishing
	name = "treasure chest"
	desc = "A piratey coffer equally magical and mysterious, capable of granting different pieces of gear to whoever opens it."
	icon_state = "treasure"
	uses_left = 18
	max_integrity = 100
	damage_deflection = 30
	anchored = FALSE

/obj/structure/mystery_box/fishing/activate(mob/living/user)
	if(user.mind && minds_that_opened_us?[WEAKREF(user.mind)] >= 3)
		to_chat(user, span_warning("[src] refuses to open to you anymore. Perhaps you should present it to someone else..."))
		return
	return ..()

/obj/structure/mystery_box/fishing/generate_valid_types()
	valid_types = list(
		/obj/item/material/sword/sabre,
		/obj/item/reagent_containers/food/drinks/bottle/rum,
		/obj/item/clothing/suit/pirate,
		/obj/item/clothing/suit/hgpirate,
		/obj/item/clothing/head/pirate,
		/obj/item/clothing/head/hgpiratecap,
		/obj/item/clothing/head/bandana,
		/obj/item/material/fishing_rod/modern
	)

/obj/structure/mystery_box/hat
	name = "hat box"
	desc = "A wooden crate, filled with hats. There's a sticker on the side that says \"May contain an exceedingly rare special hat!\""
	uses_left = 5
	anchored = FALSE

/obj/structure/mystery_box/hat/generate_valid_types()
	valid_types = subtypesof(/obj/item/clothing/head)
	for(var/obj/item/hat as anything in valid_types)
		if(ispath(hat, /obj/item/clothing/head/helmet) || ispath(hat, /obj/item/clothing/head/hood) || ispath(hat, /obj/item/clothing/head/tesh_hood || ispath(hat, /obj/item/clothing/head/chameleon)))
			valid_types -= hat

#undef MYSTERY_BOX_COOLING_DOWN
#undef MYSTERY_BOX_STANDBY
#undef MYSTERY_BOX_CHOOSING
#undef MYSTERY_BOX_PRESENTING
#undef MBOX_DURATION_CHOOSING
#undef MBOX_DURATION_PRESENTING
#undef MBOX_DURATION_EXPIRING
#undef MBOX_DURATION_STANDBY
