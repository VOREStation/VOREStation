/obj/item/spell/aura
	name = "aura template"
	desc = "If you can read me, the game broke!  Yay!"
	icon_state = "generic"
	cast_methods = null
	aspect = null
	var/glow_color = "#FFFFFF"

<<<<<<< HEAD
/obj/item/weapon/spell/aura/New()
	..()
=======
/obj/item/spell/aura/Initialize()
	. = ..()
>>>>>>> 61084723c7b... Merge pull request #8317 from Atermonera/remove_weapon
	set_light(calculate_spell_power(7), calculate_spell_power(4), l_color = glow_color)
	START_PROCESSING(SSobj, src)
	log_and_message_admins("has started casting [src].")

/obj/item/spell/aura/Destroy()
	STOP_PROCESSING(SSobj, src)
	log_and_message_admins("has stopped maintaining [src].")
	return ..()

/obj/item/spell/aura/process()
	return
