/obj/structure/musician
	name = "Not A Piano"
	desc = "Something broke, contact coderbus."
	/// IF FALSE music stops when the piano is unanchored.
	var/can_play_unanchored = FALSE
	/// Our allowed list of instrument ids. This is nulled on initialize.
	var/list/allowed_instrument_ids = list("r3grand","r3harpsi","crharpsi","crgrand1","crbright1", "crichugan", "crihamgan","piano")
	/// Our song datum.
	var/datum/song/stationary/song

/obj/structure/musician/Initialize(mapload)
	. = ..()
	song = new(src, allowed_instrument_ids)
	allowed_instrument_ids = null

/obj/structure/musician/Destroy()
	QDEL_NULL(song)
	return ..()

/obj/structure/musician/proc/can_play(atom/music_player)
	if(!anchored && !can_play_unanchored)
		return FALSE
	if(!ismob(music_player))
		return FALSE
	var/mob/user = music_player
	if(!user.IsAdvancedToolUser())
		return FALSE
	if(user.incapacitated())
		return FALSE
	if(!Adjacent(user))
		return FALSE
	return TRUE

/obj/structure/musician/attack_hand(mob/M)
	if(!M.IsAdvancedToolUser())
		return

	tgui_interact(M)

/obj/structure/musician/tgui_interact(mob/user)
	return song.tgui_interact(user)

/* FIXME
/obj/structure/musician/wrench_act(mob/living/user, obj/item/tool)
	. = ..()
	default_unfasten_wrench(user, tool, time = 4 SECONDS)
	return ITEM_INTERACT_SUCCESS
*/

/obj/structure/musician/piano
	name = "space piano"
	desc = "This is a space piano, like a regular piano, but always in tune! Even if the musician isn't."
	icon = 'icons/obj/musician.dmi'
	icon_state = "minimoog"
	anchored = TRUE
	density = TRUE
	var/broken_icon_state = "pianobroken"

/obj/structure/musician/piano/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/climbable)

/** FIXME: We do not have atom_break implemented yet
/obj/structure/musician/piano/atom_break(damage_flag)
	. = ..()
	if(!broken)
		broken = TRUE
		icon_state = broken_icon_state
*/

/obj/structure/musician/piano/unanchored
	anchored = FALSE

/obj/structure/musician/piano/minimoog
	name = "space minimoog"
	desc = "This is a minimoog, like a space piano, but more spacey!"
	icon_state = "minimoog"
	broken_icon_state = "minimoogbroken"
