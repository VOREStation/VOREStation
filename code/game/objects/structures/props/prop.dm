/**
 * Decorative items for PoIs etc.
 * These are generally sprites ported from other servers, which don't have any unique code.
 * They can be used by mappers for decorating their maps. They're mostly here so people who aren't
 * rummaging around in the sprites can be aware of some neat sprites they can use.
 *
 * Obviously you can swipe the sprites for real structures and add code, but please don't add any code
 * (beyond decorative things like maybe light) directly to these types or this file!
 * Take the icon and state and make your own type under /obj/structure.
 *
 * Some of these do have a SMIDGE of code to allow a mapper to twirl them through states/animations without
 * much effort, but beyond 'visuals logic', I'd rather keep all the logic out of here.
 */

/obj/structure/prop
	name = "mysterious structure"
	desc = "You're not sure what this is."
	icon = 'icons/obj/structures.dmi'
	icon_state = "safe"
	density = TRUE
	anchored = TRUE
	var/interaction_message = null
	var/state

/// Used to tell the player that this isn't useful for anything.
/obj/structure/prop/attack_hand(mob/living/user)
	if(!istype(user))
		return FALSE
	if(!interaction_message)
		return ..()
	else
		to_chat(user, interaction_message)

/obj/structure/prop/proc/change_state(state)
	SHOULD_CALL_PARENT(TRUE)
	src.state = state

/// Helper so admins can varedit the state easily.
/obj/structure/prop/vv_edit_var(var_name, var_value)
	if(var_name == "state")
		change_state(var_value)


//Misc stuff that fits no category

// ship memorial from TGMC
/obj/structure/prop/memorial
	name = "engraved wall"
	desc = "A finely engraved list on dark stone."
	icon = 'icons/obj/props/decor64x64.dmi'
	icon_state = "ship_memorial"
	bound_width = 64

/**
 *
 Notes on change_state
 *
 * tl;dr "You can varedit 'state' on these to the things in the comments below to get cool animations"
 *
 * These items have some logic to handle some fun animations on them. Mappers can call the 'change_state(state)' proc
 * while referring to the comments here for what states they can use. You'll notice some crazy overlay handling,
 * and that's because I don't want to add any vars to these mappers think they can fiddle with, which requires
 * more logic than I'm willing to do at the moment. So we get crazy cut/add operations instead.
 *
 * There's also a VV helper so if you varedit 'state' to these during the game, you can get that to work.
 *
 * Like, I don't want to add a state machine to decorative objects. You can if you want.
 *
 */

