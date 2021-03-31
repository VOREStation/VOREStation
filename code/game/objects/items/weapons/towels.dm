/obj/item/weapon/towel
	name = "towel"
	icon = 'icons/obj/weapons.dmi'
	icon_state = "towel"
	slot_flags = SLOT_HEAD | SLOT_BELT | SLOT_OCLOTHING
	force = 3.0
	w_class = ITEMSIZE_NORMAL
	attack_verb = list("whipped")
	hitsound = 'sound/weapons/towelwhip.ogg'
	desc = "A soft cotton towel."
	drop_sound = 'sound/items/drop/cloth.ogg'
	pickup_sound = 'sound/items/pickup/cloth.ogg'

/obj/item/weapon/towel/equipped(var/M, var/slot)
	..()
	switch(slot)
		if(slot_head)
			sprite_sheets = list(SPECIES_TESHARI = 'icons/mob/species/teshari/head.dmi')
		if(slot_wear_suit)
			sprite_sheets = list(SPECIES_TESHARI = 'icons/mob/species/teshari/suit.dmi')
		if(slot_belt)
			sprite_sheets = list(SPECIES_TESHARI = 'icons/mob/species/teshari/belt.dmi')

/obj/item/weapon/towel/attack_self(mob/living/user as mob)
	user.visible_message(text("<span class='notice'>[] uses [] to towel themselves off.</span>", user, src))
	playsound(src, 'sound/weapons/towelwipe.ogg', 25, 1)
	if(user.fire_stacks > 0)
		user.fire_stacks = (max(0, user.fire_stacks - 1.5))
	else if(user.fire_stacks < 0)
		user.fire_stacks = (min(0, user.fire_stacks + 1.5))

/obj/item/weapon/towel/random/New()
	..()
	color = "#"+get_random_colour()