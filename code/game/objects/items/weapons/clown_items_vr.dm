/obj/item/weapon/storage/box/clown
	name = "clown box"
	desc = "A colorful cardboard box for the clown."
	icon = 'icons/obj/storage_vr.dmi'
	icon_state = "clownbox"

/obj/item/stack/material/cardboard/
	var/result = /obj/item/weapon/storage/box/clown

/obj/item/stack/material/cardboard/attackby(obj/item/I as obj, mob/living/user as mob)
	..()
	if(contents.len)
		return
	if(amount >= 2)
		to_chat(user, "<span class='notice'>Do you really want to stamp all of those? Just grab one.</span>")
	else
		if(istype(I, /obj/item/weapon/stamp/clown))
			if(!user.item_is_in_hands(src))
				to_chat(user, "<span class='notice'>You'll need [src] in your hands to do that.</span>")
			else
				new result(get_turf(src))
				qdel(src)