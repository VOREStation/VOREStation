/obj/item/marsh_stick
	name = "marshmallow on a stick"
	desc = "A simple marshmallow on a stick, ready to cook over a fire."
	icon = 'icons/obj/food.dmi'
	icon_state = "marsh_stick"
	w_class = ITEMSIZE_NORMAL
	var/obj/item/reagent_containers/food/snacks/marshmallow/marsh

/obj/item/marsh_stick/Initialize(mapload)
	. = ..()
	marsh = new /obj/item/reagent_containers/food/snacks/marshmallow

/obj/item/marsh_stick/afterattack(atom/target, mob/user, proximity_flag, click_parameters)
	if(istype(target, /obj/structure/bonfire))
		var/obj/structure/bonfire/fire = target
		if(fire.burning)
			user.balloon_alert(user, "roasting marshmallow")
			if(do_after(user, 5 SECONDS, target = fire))
				marsh.name = "roasted marshmallow"
				marsh.nutriment_desc = list("gooey sugar" = 2)
				marsh.icon_state = "marsh_r"
				if(do_after(user, 5 SECONDS, target = fire))
					marsh.name = "burnt marshmallow"
					marsh.desc = "What used to be a delicious treat, now well done."
					marsh.nutriment_desc = list("burnt sugar" = 5)
					marsh.icon_state = "marsh_b"

/obj/item/marsh_stick/attack_hand(mob/living/user)
	. = ..()
	if(marsh)
		marsh.forceMove(get_turf(src))
		marsh = null
		new /obj/item/stack/material/stick(get_turf(src))
		qdel(src)
