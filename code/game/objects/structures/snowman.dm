/obj/structure/snowman
	name = "snowman"
	icon = 'icons/obj/snowman.dmi'
	icon_state = "snowman"
	desc = "A happy little snowman smiles back at you!"
	anchored = TRUE

/obj/structure/snowman/attack_hand(mob/user as mob)
	if(user.a_intent == I_HURT)
		to_chat(user, "<span class='notice'>In one hit, [src] easily crumples into a pile of snow. You monster.</span>")
		var/turf/simulated/floor/F = get_turf(src)
		if (istype(F))
			new /obj/item/stack/material/snow(F)
		qdel(src)

/obj/structure/snowman/borg
	name = "snowborg"
	icon_state = "snowborg"
	desc = "A snowy little robot. It even has a monitor for a head."

/obj/structure/snowman/spider
	name = "snow spider"
	icon_state = "snowspider"
	desc = "An impressively crafted snow spider. Not nearly as creepy as the real thing."