/obj/effect/decal/cleanable/generic
	name = "clutter"
	desc = "Someone should clean that up."
	gender = PLURAL
	density = FALSE
	anchored = TRUE
	icon = 'icons/obj/objects.dmi'
	icon_state = "shards"

/obj/effect/decal/cleanable/ash
	name = "ashes"
	desc = "Ashes to ashes, dust to dust, and into space."
	gender = PLURAL
	icon = 'icons/obj/objects.dmi'
	icon_state = "ash"
	anchored = TRUE

/obj/effect/decal/cleanable/ash/attack_hand(mob/user as mob)
	to_chat(user, span_notice("[src] sifts through your fingers."))
	var/turf/simulated/floor/F = get_turf(src)
	if (istype(F))
		F.dirt += 4
	qdel(src)

/obj/effect/decal/cleanable/greenglow

/obj/effect/decal/cleanable/greenglow/Initialize(mapload, _age)
	. = ..()
	QDEL_IN(src, 2 MINUTES)

/obj/effect/decal/cleanable/dirt
	name = "dirt"
	desc = "Someone should clean that up."
	gender = PLURAL
	density = FALSE
	anchored = TRUE
	icon = 'icons/effects/effects.dmi'
	icon_state = "dirt"
	mouse_opacity = 0
	var/delete_me = FALSE

/obj/effect/decal/cleanable/dirt/Initialize(mapload, var/_age, var/dirt)
	.=..()
	if(delete_me)
		return INITIALIZE_HINT_QDEL
	var/turf/simulated/our_turf = src.loc
	if(our_turf && istype(our_turf) && our_turf.can_dirty)
		our_turf.dirt = clamp(max(age ? (dirt ? dirt : 101) : our_turf.dirt, our_turf.dirt), 0, 101)
		if(mapload && !our_turf.dirt)
			our_turf.dirt = rand(51, 100)
		var/calcalpha = our_turf.dirt > 50 ? min((our_turf.dirt - 50) * 5, 255) : 0
		var/alreadyfound = FALSE
		for (var/obj/effect/decal/cleanable/dirt/alreadythere in our_turf) //in case of multiple
			if (alreadythere == src)
				continue
			else if (alreadyfound)
				if(!(alreadythere.flags & ATOM_INITIALIZED))
					delete_me = TRUE
				else
					qdel(alreadythere)
				continue
			alreadyfound = TRUE
			alreadythere.alpha = calcalpha //don't need to constantly recalc for all of them in it because it'll just max if a non-persistent dirt overlay gets added, and then the new dirt overlay will be deleted
		if (alreadyfound)
			return INITIALIZE_HINT_QDEL
		alpha = calcalpha

/obj/effect/decal/cleanable/flour
	name = "flour"
	desc = "It's still good. Four second rule!"
	gender = PLURAL
	density = FALSE
	anchored = TRUE
	icon = 'icons/effects/effects.dmi'
	icon_state = "flour"

/obj/effect/decal/cleanable/greenglow
	name = "glowing goo"
	desc = "Jeez. I hope that's not for lunch."
	gender = PLURAL
	density = FALSE
	anchored = TRUE
	light_range = 1
	icon = 'icons/effects/effects.dmi'
	icon_state = "greenglow"

/obj/effect/decal/cleanable/cobweb
	name = "cobweb"
	desc = "Somebody should remove that."
	density = FALSE
	anchored = TRUE
	plane = OBJ_PLANE
	icon = 'icons/effects/effects.dmi'
	icon_state = "cobweb1"

/obj/effect/decal/cleanable/molten_item
	name = "gooey grey mass"
	desc = "It looks like a melted... something."
	density = FALSE
	anchored = TRUE
	plane = OBJ_PLANE
	icon = 'icons/obj/chemical.dmi'
	icon_state = "molten"

/obj/effect/decal/cleanable/cobweb2
	name = "cobweb"
	desc = "Somebody should remove that."
	density = FALSE
	anchored = TRUE
	plane = OBJ_PLANE
	icon = 'icons/effects/effects.dmi'
	icon_state = "cobweb2"

//Vomit (sorry)
/obj/effect/decal/cleanable/vomit
	name = "vomit"
	desc = "Gosh, how unpleasant."
	gender = PLURAL
	density = FALSE
	anchored = TRUE
	icon = 'icons/effects/blood.dmi'
	icon_state = "vomit_1"
	random_icon_states = list("vomit_1", "vomit_2", "vomit_3", "vomit_4")
	var/list/datum/disease/viruses = list()

/obj/effect/decal/cleanable/vomit/old
	name = "crusty dried vomit"
	desc = "You try not to look at the chunks, and fail."

/obj/effect/decal/cleanable/vomit/old/Initialize(mapload, list/datum/disease/diseases)
	. = ..()
	icon_state += "-old"
	if(length(diseases))
		viruses += diseases
	if(prob(65))
		var/datum/disease/advance/new_disease = new /datum/disease/advance/random(rand(2, 4), rand(7, 9), 4)
		src.viruses += new_disease

/obj/effect/decal/cleanable/vomit/old/Crossed(mob/living/carbon/human/perp)
	return // Don't spread our viruses

/obj/effect/decal/cleanable/blood/old
	dryname = "nasty dried blood"
	drydesc = "Why hasn't anyone cleaned this up yet?"

/obj/effect/decal/cleanable/blood/old/Initialize(mapload, list/datum/disease/diseases)
	. = ..()
	basecolor = get_random_colour(rand(0, 1))
	update_icon()
	if(length(diseases))
		viruses += diseases
	if(prob(75))
		var/datum/disease/advance/new_disease = new /datum/disease/advance/random(rand(2, 4), rand(7, 9), 4)
		src.viruses += new_disease
	dry()

/obj/effect/decal/cleanable/blood/old/Crossed(mob/living/carbon/human/perp)
	return

/obj/effect/decal/cleanable/tomato_smudge
	name = "tomato smudge"
	desc = "It's red."
	density = FALSE
	anchored = TRUE
	icon = 'icons/effects/tomatodecal.dmi'
	icon_state = "tomato_floor1"
	random_icon_states = list("tomato_floor1", "tomato_floor2", "tomato_floor3")

/obj/effect/decal/cleanable/egg_smudge
	name = "smashed egg"
	desc = "Seems like this one won't hatch."
	density = FALSE
	anchored = TRUE
	icon = 'icons/effects/tomatodecal.dmi'
	icon_state = "smashed_egg1"
	random_icon_states = list("smashed_egg1", "smashed_egg2", "smashed_egg3")

/obj/effect/decal/cleanable/pie_smudge //honk
	name = "smashed pie"
	desc = "It's pie cream from a cream pie."
	density = FALSE
	anchored = TRUE
	icon = 'icons/effects/tomatodecal.dmi'
	icon_state = "smashed_pie"
	random_icon_states = list("smashed_pie")

/obj/effect/decal/cleanable/fruit_smudge
	name = "smudge"
	desc = "Some kind of fruit smear."
	density = FALSE
	anchored = TRUE
	icon = 'icons/effects/blood.dmi'
	icon_state = "mfloor1"
	random_icon_states = list("mfloor1", "mfloor2", "mfloor3", "mfloor4", "mfloor5", "mfloor6", "mfloor7")

/obj/effect/decal/cleanable/confetti
	name = "confetti"
	desc = "Tiny bits of colored paper thrown about for the janitor to enjoy!"
	gender = PLURAL
	density = FALSE
	anchored = TRUE
	icon = 'icons/effects/effects.dmi'
	icon_state = "confetti"

/obj/effect/decal/cleanable/confetti/attack_hand(mob/user)
	to_chat(user, span_notice("You start to meticulously pick up the confetti."))
	if(do_after(user, 60))
		qdel(src)
