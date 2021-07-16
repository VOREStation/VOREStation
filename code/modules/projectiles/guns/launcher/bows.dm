/obj/item/weapon/arrow/standard
	name = "arrow"
	desc = "It's got a tip for you - get the point?"
	icon = 'icons/obj/guns/projectile/bows.dmi'
	icon_state = "arrow"
	item_state = "bolt"
	throwforce = 8
	w_class = ITEMSIZE_NORMAL
	sharp = 1
	edge = 0

/obj/item/weapon/arrow/energy
	name = "hardlight arrow"
	desc = "An arrow made out of energy! Classic?"
	icon = 'icons/obj/guns/projectile/bows.dmi'
	icon_state = "hardlight"
	item_state = "bolt"
	throwforce = 10
	w_class = ITEMSIZE_NORMAL
	sharp = 0
	edge = 1

/obj/item/weapon/arrow/energy/throw_impact(atom/hit_atom)
	. = ..()
	qdel(src)

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
	tension = 3
	var/drawn = FALSE

/obj/item/weapon/gun/launcher/crossbow/bow/proc/unload(mob/user)
	var/obj/item/weapon/arrow/A = bolt
	bolt = null
	drawn = FALSE
	A.forceMove(get_turf(user))
	user.put_in_hands(A)

/obj/item/weapon/gun/launcher/crossbow/bow/consume_next_projectile(mob/user)
	if(!drawn)
		to_chat(user, "<span class='warning'>\The [src] is not drawn back!</span>")
		return null
	return bolt

/obj/item/weapon/gun/launcher/crossbow/bow/handle_post_fire(mob/user, atom/target)
	bolt = null
	drawn = FALSE
	update_icon()
	..()

/obj/item/weapon/gun/launcher/crossbow/bow/attack_self(mob/living/user)
	if(bolt)
		user.visible_message("[user] relaxes the tension on [src]'s string and removes [bolt].","You relax the tension on [src]'s string and remove [bolt].")
		unload(user)
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

	if(do_after(user, 25, src, exclusive = TASK_ALL_EXCLUSIVE))
		drawn = TRUE
		user.visible_message("<b>[user]</b> draws the string on [src] back fully!", "You draw the string on [src] back fully!")
	else
		user.visible_message("<b>[user]</b> stops drawing and relaxes the string of [src].","<span class='warning'>You stop drawing back and relax the string of [src].</span>")
		drawn = FALSE
	update_icon()

/obj/item/weapon/gun/launcher/crossbow/bow/attackby(obj/item/W as obj, mob/user)
	if(!bolt && istype(W,/obj/item/weapon/arrow/standard))
		user.drop_from_inventory(W, src)
		bolt = W
		user.visible_message("[user] slides [bolt] into [src].","You slide [bolt] into [src].")
		update_icon()

/obj/item/weapon/gun/launcher/crossbow/bow/update_icon()
	if(drawn)
		icon_state = "[initial(icon_state)]_firing"
	else if(bolt)
		icon_state = "[initial(icon_state)]_loaded"
	else
		icon_state = "[initial(icon_state)]"



/obj/item/weapon/gun/launcher/crossbow/bow/hardlight
	name = "hardlight bow"
	icon_state = "bow_hardlight"
	item_state = "bow_hardlight"
	desc = "An energy bow, capable of producing arrows from an internal power supply."

/obj/item/weapon/gun/launcher/crossbow/bow/hardlight/unload(mob/user)
	qdel_null(bolt)

/obj/item/weapon/gun/launcher/crossbow/bow/hardlight/attack_self(mob/living/user)
	if(drawn)
		user.visible_message("<b>[user]</b> relaxes the tension on [src]'s string.","You relax the tension on [src]'s string.")
		drawn = FALSE
		update_icon()
	else if(!bolt)
		user.visible_message("<b>[user]</b> fabricates a new hardlight projectile with [src].","You fabricate a new hardlight projectile with [src].")
		bolt = new /obj/item/weapon/arrow/energy(src)
		update_icon()
	else
		draw(user)
