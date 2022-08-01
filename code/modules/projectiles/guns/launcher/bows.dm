/obj/item/weapon/arrow/standard
	name = "arrow"
	desc = "It's got a tip for you - get the point?"
	icon = 'icons/obj/guns/projectile/bows.dmi'
	icon_state = "arrow"
	item_state = "bolt"
	throwforce = 8
	w_class = ITEMSIZE_NORMAL
	sharp = TRUE
	edge = FALSE

<<<<<<< HEAD
/obj/item/weapon/arrow/energy
=======
	knock_point = list(9,8)

/obj/item/arrow/wood/chitin
	name = "chitin arrow"
	desc = "A wooden arrow with a hard chitin tip. Simple, but gets the job done."
	color = "#a66008"

/obj/item/arrow/energy
>>>>>>> e072e147a41... Archery Tweaks (#8670)
	name = "hardlight arrow"
	desc = "An arrow made out of energy! Classic?"
	icon = 'icons/obj/guns/projectile/bows.dmi'
	icon_state = "hardlight"
	item_state = "bolt"
	throwforce = 10
	w_class = ITEMSIZE_NORMAL
	sharp = TRUE
	edge = TRUE
	embed_chance = 0 // it fizzles!
	catchable = FALSE // oh god

/obj/item/weapon/arrow/energy/throw_impact(atom/hit_atom)
	. = ..()
	qdel(src)

/obj/item/weapon/arrow/energy/equipped()
	if(isliving(loc))
		var/mob/living/L = loc
		L.drop_from_inventory(src)
	qdel(src) // noh

/obj/item/weapon/gun/launcher/crossbow/bow
	name = "shortbow"
	desc = "A common shortbow, capable of firing arrows at high speed towards a target. Useful for hunting while keeping quiet."
	icon = 'icons/obj/guns/projectile/bows.dmi'
	icon_override = 'icons/obj/guns/projectile/bows.dmi'
	icon_state = "bow"
	item_state = "bow"
	fire_sound = 'sound/weapons/punchmiss.ogg' // TODO: Decent THWOK noise.
	fire_sound_text = "a solid thunk"
	fire_delay = 25
	slot_flags = SLOT_BACK
	release_force = 20
<<<<<<< HEAD
	release_speed = 15
	var/drawn = FALSE
=======
	tension = 3
	drop_sound = 'sound/items/drop/woodweapon.ogg'
	pickup_sound = 'sound/items/pickup/woodweapon.ogg'

	bolt_rotation_transform = 0	// Bows do not rotate their arrows like crossbows, as they face north-east on the ground.
	drawn_knock = list(8,7)
	ready_knock = list(15,14)
>>>>>>> e072e147a41... Archery Tweaks (#8670)

/obj/item/weapon/gun/launcher/crossbow/bow/update_release_force(obj/item/projectile)
	return 0

/obj/item/weapon/gun/launcher/crossbow/bow/proc/unload(mob/user)
	var/obj/item/weapon/arrow/A = bolt
	bolt = null
	tension = FALSE
	A.forceMove(get_turf(user))
	user.put_in_hands(A)
	update_icon()

<<<<<<< HEAD
/obj/item/weapon/gun/launcher/crossbow/bow/consume_next_projectile(mob/user)
	if(!drawn)
=======
/obj/item/gun/launcher/crossbow/bow/consume_next_projectile(mob/user)
	if(!tension)
>>>>>>> e072e147a41... Archery Tweaks (#8670)
		to_chat(user, "<span class='warning'>\The [src] is not drawn back!</span>")
		return null
	return bolt

/obj/item/weapon/gun/launcher/crossbow/bow/handle_post_fire(mob/user, atom/target)
	bolt = null
	tension = FALSE
	update_icon()
	..()

<<<<<<< HEAD
/obj/item/weapon/gun/launcher/crossbow/bow/attack_hand(mob/living/user)
	if(loc == user && bolt && !drawn)
=======
/obj/item/gun/launcher/crossbow/bow/attack_hand(mob/living/user)
	if(loc == user && bolt && !tension)
>>>>>>> e072e147a41... Archery Tweaks (#8670)
		user.visible_message("<b>[user]</b> removes [bolt] from [src].","You remove [bolt] from [src].")
		unload(user)
	else
		return ..()

<<<<<<< HEAD
/obj/item/weapon/gun/launcher/crossbow/bow/attack_self(mob/living/user)
	if(drawn)
=======
/obj/item/gun/launcher/crossbow/bow/attack_self(mob/living/user)
	if(tension)
>>>>>>> e072e147a41... Archery Tweaks (#8670)
		user.visible_message("<b>[user]</b> relaxes the tension on [src]'s string.","You relax the tension on [src]'s string.")
		tension = FALSE
		update_icon()
	else
		draw(user)

/obj/item/weapon/gun/launcher/crossbow/bow/draw(var/mob/user)
	if(!bolt)
		to_chat(user, "You don't have anything nocked to [src].")
		return

	if(user.restrained())
		return

	current_user = user
	user.visible_message("<b>[user]</b> begins to draw back the string of [src].","<span class='notice'>You begin to draw back the string of [src].</span>")
<<<<<<< HEAD
	if(do_after(user, 25, src, exclusive = TASK_ALL_EXCLUSIVE))
		drawn = TRUE
		user.visible_message("<b>[user]</b> draws the string on [src] back fully!", "You draw the string on [src] back fully!")
	update_icon()

/obj/item/weapon/gun/launcher/crossbow/bow/attackby(obj/item/W as obj, mob/user)
	if(!bolt && istype(W,/obj/item/weapon/arrow/standard))
=======
	if(do_after(user, 25))
		tension = TRUE
		user.visible_message("<b>[user]</b> draws the string on [src] back fully!", "You draw the string on [src] back fully!")
	update_icon()

/obj/item/gun/launcher/crossbow/bow/handle_click_empty(mob/user)
		return

/obj/item/gun/launcher/crossbow/bow/attackby(obj/item/W as obj, mob/user)
	if(!bolt && (istype(W,/obj/item/arrow) || istype(W,/obj/item/material/arrow)))
>>>>>>> e072e147a41... Archery Tweaks (#8670)
		user.drop_from_inventory(W, src)
		bolt = W
		user.visible_message("[user] slides [bolt] into [src].","You slide [bolt] into [src].")
		update_icon()

<<<<<<< HEAD
/obj/item/weapon/gun/launcher/crossbow/bow/update_icon()
	if(drawn)
=======
/obj/item/gun/launcher/crossbow/bow/update_icon()
	cut_overlays()
	if(tension)
>>>>>>> e072e147a41... Archery Tweaks (#8670)
		icon_state = "[initial(icon_state)]_firing"
	else if(bolt)
		icon_state = "[initial(icon_state)]_loaded"
	else
		icon_state = "[initial(icon_state)]"

<<<<<<< HEAD
=======
	add_overlay(update_bolt_transform())

/obj/item/gun/launcher/crossbow/bow/dropped(mob/user)
	if(tension)
		to_chat(user, "<span class='warning'>\The [src]'s tension is relaxed as you let go of it!</span>")
		tension = FALSE
	update_icon()
>>>>>>> e072e147a41... Archery Tweaks (#8670)


/obj/item/weapon/gun/launcher/crossbow/bow/hardlight
	name = "hardlight bow"
	icon_state = "bow_hardlight"
	item_state = "bow_hardlight"
	desc = "An energy bow, capable of producing arrows from an internal power supply."

<<<<<<< HEAD
/obj/item/weapon/gun/launcher/crossbow/bow/hardlight/unload(mob/user)
	qdel_null(bolt)
	update_icon()

/obj/item/weapon/gun/launcher/crossbow/bow/hardlight/attack_self(mob/living/user)
	if(drawn)
=======
	var/arrow_type = /obj/item/arrow/energy

/obj/item/gun/launcher/crossbow/bow/hardlight/unload(mob/user)
	if(istype(bolt, /obj/item/arrow/energy))	// Let's not delete a Real Arrow^tm
		qdel_null(bolt)
		update_icon()
	else
		. = ..()

/obj/item/gun/launcher/crossbow/bow/hardlight/attack_self(mob/living/user)
	if(tension)
>>>>>>> e072e147a41... Archery Tweaks (#8670)
		user.visible_message("<b>[user]</b> relaxes the tension on [src]'s string.","You relax the tension on [src]'s string.")
		tension = FALSE
		update_icon()
	else if(!bolt)
		user.visible_message("<b>[user]</b> fabricates a new hardlight projectile with [src].","You fabricate a new hardlight projectile with [src].")
<<<<<<< HEAD
		bolt = new /obj/item/weapon/arrow/energy(src)
=======
		bolt = new arrow_type(src)
>>>>>>> e072e147a41... Archery Tweaks (#8670)
		update_icon()
	else
		draw(user)
