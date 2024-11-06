//////////////////////Scrying orb//////////////////////

/obj/item/scrying
	name = "scrying orb"
	desc = "An incandescent orb of otherworldly energy, staring into it gives you vision beyond mortal means."
	icon = 'icons/obj/projectiles.dmi'
	icon_state = "bluespace"
	throw_speed = 3
	throw_range = 7
	throwforce = 10
	damtype = BURN
	force = 10
	hitsound = 'sound/items/welder2.ogg'

/obj/item/scrying/attack_self(mob/user as mob)
	if((user.mind && !wizards.is_antagonist(user.mind)))
		to_chat(user, span_warning("You stare into the orb and see nothing but your own reflection."))
		return

	to_chat(user, span_info("You can see... everything!"))
	visible_message(span_danger("[user] stares into [src], their eyes glazing over."))

	user.teleop = user.ghostize(1)
	announce_ghost_joinleave(user.teleop, 1, "You feel that they used a powerful artifact to [pick("invade","disturb","disrupt","infest","taint","spoil","blight")] this place with their presence.")
	return
