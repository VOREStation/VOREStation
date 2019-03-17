//The base 'prop' for PoIs or other large junk.

/obj/structure/prop
	name = "something"
	desc = "My description is broken, bug a developer."
	icon = 'icons/obj/structures.dmi'
	icon_state = "safe"
	density = TRUE
	anchored = TRUE
	var/interaction_message = null

/obj/structure/prop/attack_hand(mob/living/user) // Used to tell the player that this isn't useful for anything.
	if(!istype(user))
		return FALSE
	if(!interaction_message)
		return ..()
	else
		to_chat(user, interaction_message)
