/obj/effect/decal/remains
	name = "remains"
	gender = PLURAL
	icon = 'icons/effects/blood.dmi'
	icon_state = "remains"
	anchored = FALSE

/obj/effect/decal/remains/human
	desc = "They look like human remains. They have a strange aura about them."

/obj/effect/decal/remains/xeno
	desc = "They look like the remains of something... alien. They have a strange aura about them."
	icon_state = "remainsxeno"

/obj/effect/decal/remains/robot
	desc = "They look like the remains of something mechanical. They have a strange aura about them."
	icon = 'icons/mob/robots.dmi'
	icon_state = "remainsrobot"

/obj/effect/decal/remains/mouse
	desc = "They look like the remains of a small rodent."
	icon_state = "mouse"

/obj/effect/decal/remains/lizard
	desc = "They look like the remains of a small lizard."
	icon_state = "lizard"

/obj/effect/decal/remains/unathi
	desc = "They look like Unathi remains. Pointy."
	icon_state = "remainsunathi"

/obj/effect/decal/remains/tajaran
	desc = "They look like Tajaran remains. They're surprisingly small."
	icon_state = "remainstajaran"

/obj/effect/decal/remains/ribcage
	desc = "They look like animal remains of some sort... You hope."
	icon_state = "remainsribcage"

/obj/effect/decal/remains/deer
	desc = "They look like the remains of a large herbivore, picked clean."
	icon_state = "remainsdeer"

/obj/effect/decal/remains/posi
	desc = "This looks like part of an old FBP. Hopefully it was empty."
	icon_state = "remainsposi"

/obj/effect/decal/remains/mummy1
	name = "mummified remains"
	desc = "They look like human remains. They've been here a long time."
	icon_state = "mummified1"

/obj/effect/decal/remains/mummy2
	name = "mummified remains"
	desc = "They look like human remains. They've been here a long time."
	icon_state = "mummified2"

/obj/effect/decal/remains/attack_hand(mob/user as mob)
	to_chat(user, "<span class='notice'>[src] sinks together into a pile of ash.</span>")
	var/turf/simulated/floor/F = get_turf(src)
	if (istype(F))
		new /obj/effect/decal/cleanable/ash(F)
	qdel(src)

/obj/effect/decal/remains/robot/attack_hand(mob/user as mob)
	return
