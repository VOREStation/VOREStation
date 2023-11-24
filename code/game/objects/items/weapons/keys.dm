/obj/item/weapon/simple_key
	name = "key"
	desc = "A plain, old-timey key, as one might use to unlock a door."
	icon = 'icons/obj/keys.dmi'
	icon_state = "key_basetype"
	drop_sound = 'sound/items/drop/ring.ogg'
	pickup_sound = 'sound/items/pickup/ring.ogg'
	w_class = ITEMSIZE_TINY
	var/keyverb = "uses"				//so simple_keys can be keycards instead, if desired
	var/key_id = "placeholder_DONOTUSE"	//needs to match the associated door's LOCK_ID var