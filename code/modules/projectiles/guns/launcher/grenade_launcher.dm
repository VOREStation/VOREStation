/obj/item/gun/launcher/grenade
	name = "grenade launcher"
	desc = "A bulky pump-action grenade launcher. Holds up to 6 grenades in a revolving magazine."
	icon_state = "riotgun"
	item_state = "riotgun"
	w_class = ITEMSIZE_LARGE
	force = 10

	fire_sound = 'sound/weapons/grenade_launcher.ogg'
	fire_sound_text = "a metallic thunk"
	recoil = 0
	throw_distance = 7
	release_force = 5

	var/obj/item/grenade/chambered
	var/list/grenades = new/list()
	var/max_grenades = 5 //holds this + one in the chamber
	matter = list(MAT_STEEL = 2000)

//revolves the magazine, allowing players to choose between multiple grenade types
/obj/item/gun/launcher/grenade/proc/pump(mob/M as mob)
	playsound(M, 'sound/weapons/shotgunpump.ogg', 60, 1)

	var/obj/item/grenade/next
	if(grenades.len)
		next = grenades[1] //get this first, so that the chambered grenade can still be removed if the grenades list is empty
	if(chambered)
		grenades += chambered //rotate the revolving magazine
		chambered = null
	if(next)
		grenades -= next //Remove grenade from loaded list.
		chambered = next
		to_chat(M, span_warning("You pump [src], loading \a [next] into the chamber."))
	else
		to_chat(M, span_warning("You pump [src], but the magazine is empty."))
	update_icon()

/obj/item/gun/launcher/grenade/examine(mob/user)
	. = ..()
	if(get_dist(user, src) <= 2)
		var/grenade_count = grenades.len + (chambered? 1 : 0)
		. += "Has [grenade_count] grenade\s remaining."
		if(chambered)
			. += "\A [chambered] is chambered."

/obj/item/gun/launcher/grenade/proc/load(obj/item/grenade/G, mob/user)
	if(G.loadable)
		if(grenades.len >= max_grenades)
			to_chat(user, span_warning("[src] is full."))
			return
		user.remove_from_mob(G)
		G.loc = src
		grenades.Insert(1, G) //add to the head of the list, so that it is loaded on the next pump
		user.visible_message("[user] inserts \a [G] into [src].", span_notice("You insert \a [G] into [src]."))
		return
	to_chat(user, span_warning("[G] doesn't seem to fit in the [src]!"))

/obj/item/gun/launcher/grenade/proc/unload(mob/user)
	if(grenades.len)
		var/obj/item/grenade/G = grenades[grenades.len]
		grenades.len--
		user.put_in_hands(G)
		user.visible_message("[user] removes \a [G] from [src].", span_notice("You remove \a [G] from [src]."))
		playsound(src, 'sound/weapons/empty.ogg', 50, 1)
	else
		to_chat(user, span_warning("[src] is empty."))

/obj/item/gun/launcher/grenade/attack_self(mob/user)
	pump(user)

/obj/item/gun/launcher/grenade/attackby(obj/item/I, mob/user)
	if((istype(I, /obj/item/grenade)))
		load(I, user)
	else
		..()

/obj/item/gun/launcher/grenade/attack_hand(mob/user)
	if(user.get_inactive_hand() == src)
		unload(user)
	else
		..()

/obj/item/gun/launcher/grenade/consume_next_projectile()
	if(chambered)
		chambered.det_time = 10
		chambered.activate(null)
	return chambered

/obj/item/gun/launcher/grenade/handle_post_fire(mob/user)
	message_admins("[key_name_admin(user)] fired a grenade ([chambered.name]) from a grenade launcher ([src.name]).")
	log_game("[key_name_admin(user)] used a grenade ([chambered.name]).")
	chambered = null

//Underslung grenade launcher to be used with the Z8
/obj/item/gun/launcher/grenade/underslung
	name = "underslung grenade launcher"
	desc = "Not much more than a tube and a firing mechanism, this grenade launcher is designed to be fitted to a rifle."
	w_class = ITEMSIZE_NORMAL
	force = 5
	max_grenades = 0

/obj/item/gun/launcher/grenade/underslung/attack_self()
	return

//load and unload directly into chambered
/obj/item/gun/launcher/grenade/underslung/load(obj/item/grenade/G, mob/user)
	if(G.loadable)
		if(chambered)
			to_chat(user, span_warning("[src] is already loaded."))
			return
		user.remove_from_mob(G)
		G.loc = src
		chambered = G
		user.visible_message("[user] load \a [G] into [src].", span_notice("You load \a [G] into [src]."))
		return
	to_chat(user, span_warning("[G] doesn't seem to fit in the [src]!"))

/obj/item/gun/launcher/grenade/underslung/unload(mob/user)
	if(chambered)
		user.put_in_hands(chambered)
		user.visible_message("[user] removes \a [chambered] from [src].", span_notice("You remove \a [chambered] from [src]."))
		playsound(src, 'sound/weapons/empty.ogg', 50, 1)
		chambered = null
	else
		to_chat(user, span_warning("[src] is empty."))
