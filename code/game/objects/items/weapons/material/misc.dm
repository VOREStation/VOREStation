/obj/item/weapon/material/harpoon
	name = "harpoon"
	sharp = 1
	edge = 0
	desc = "Tharr she blows!"
	icon_state = "harpoon"
	item_state = "harpoon"
	force_divisor = 0.3 // 18 with hardness 60 (steel)
	attack_verb = list("jabbed","stabbed","ripped")

/obj/item/weapon/material/knife/machete/hatchet
	name = "hatchet"
	desc = "A very sharp axe blade upon a short fibremetal handle. It has a long history of chopping things, but now it is used for chopping wood."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "hatchet"
	force_divisor = 0.2 // 12 with hardness 60 (steel)
	thrown_force_divisor = 0.75 // 15 with weight 20 (steel)
	w_class = ITEMSIZE_SMALL
	sharp = 1
	edge = 1
	origin_tech = list(TECH_MATERIAL = 2, TECH_COMBAT = 1)
	attack_verb = list("chopped", "torn", "cut")
	applies_material_colour = 0
	drop_sound = 'sound/items/drop/axe.ogg'

/obj/item/weapon/material/knife/machete/hatchet/unathiknife
	name = "duelling knife"
	desc = "A length of leather-bound wood studded with razor-sharp teeth. How crude."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "unathiknife"
	attack_verb = list("ripped", "torn", "cut")
	can_cleave = FALSE
	var/hits = 0

/obj/item/weapon/material/knife/machete/hatchet/unathiknife/attack(mob/M as mob, mob/user as mob)
	if(hits > 0)
		return
	var/obj/item/I = user.get_inactive_hand()
	if(istype(I, /obj/item/weapon/material/knife/machete/hatchet/unathiknife))
		hits ++
		var/obj/item/weapon/W = I
		W.attack(M, user)
		W.afterattack(M, user)
	..()

/obj/item/weapon/material/knife/machete/hatchet/unathiknife/afterattack(mob/M as mob, mob/user as mob)
	hits = initial(hits)
	..()

/obj/item/weapon/material/minihoe // -- Numbers
	name = "mini hoe"
	desc = "It's used for removing weeds or scratching your back."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "hoe"
	force_divisor = 0.25 // 5 with weight 20 (steel)
	thrown_force_divisor = 0.25 // as above
	dulled_divisor = 0.75	//Still metal on a long pole
	w_class = ITEMSIZE_SMALL
	attack_verb = list("slashed", "sliced", "cut", "clawed")

/obj/item/weapon/material/snow/snowball
	name = "loose packed snowball"
	desc = "A fun snowball. Throw it at your friends!"
	icon = 'icons/obj/weapons.dmi'
	icon_state = "snowball"
	default_material = MAT_SNOW
	health = 1
	fragile = 1
	force_divisor = 0.01
	thrown_force_divisor = 0.10
	w_class = ITEMSIZE_SMALL
	attack_verb = list("mushed", "splatted", "splooshed", "splushed") // Words that totally exist.

/obj/item/weapon/material/snow/snowball/attack_self(mob/user as mob)
	if(user.a_intent == I_HURT)
		//visible_message("[user] has smashed the snowball in their hand!", "You smash the snowball in your hand.")
		to_chat(user, "<span class='notice'>You smash the snowball in your hand.</span>")
		var/atom/S = new /obj/item/stack/material/snow(user.loc)
		del(src)
		user.put_in_hands(S)
	else
		//visible_message("[user] starts compacting the snowball.", "You start compacting the snowball.")
		to_chat(user, "<span class='notice'>You start compacting the snowball.</span>")
		if(do_after(user, 2 SECONDS))
			var/atom/S = new /obj/item/weapon/material/snow/snowball/reinforced(user.loc)
			del(src)
			user.put_in_hands(S)

/obj/item/weapon/material/snow/snowball/reinforced
	name = "snowball"
	desc = "A well-formed and fun snowball. It looks kind of dangerous."
	//icon_state = "reinf-snowball"
	force_divisor = 0.20
	thrown_force_divisor = 0.25
