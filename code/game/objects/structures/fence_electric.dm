#define NAME_ELECFENCE "electric fence"
#define DESC_ELECFENCE "A chain link fence attached to a nearby area power controller. Zap zap!"
#define ICON_ELECFENCE 'icons/obj/fence_electric.dmi'

// Required to be in an area with a powered APC to electrocute! Intended for POIs.
/obj/structure/fence/electric
	name = NAME_ELECFENCE
	desc = DESC_ELECFENCE
	icon = ICON_ELECFENCE
	electric = TRUE

/obj/structure/fence/electric_sign
	name = NAME_ELECFENCE
	desc = DESC_ELECFENCE
	icon = ICON_ELECFENCE
	electric = TRUE
	icon_state = "straight_sign"

/obj/structure/fence/door/electric
	name = NAME_ELECFENCE
	desc = DESC_ELECFENCE
	icon = ICON_ELECFENCE
	electric = TRUE

/obj/structure/fence/end/electric
	name = NAME_ELECFENCE
	desc = DESC_ELECFENCE
	icon = ICON_ELECFENCE
	electric = TRUE

/obj/structure/fence/corner/electric
	name = NAME_ELECFENCE
	desc = DESC_ELECFENCE
	icon = ICON_ELECFENCE
	electric = TRUE

/obj/structure/fence/post/electric
	name = NAME_ELECFENCE
	desc = DESC_ELECFENCE
	icon = ICON_ELECFENCE
	electric = TRUE

/obj/structure/fence/cut/medium/electric
	name = NAME_ELECFENCE
	desc = DESC_ELECFENCE
	icon = ICON_ELECFENCE
	electric = TRUE

/obj/structure/fence/cut/large/electric
	name = NAME_ELECFENCE
	desc = DESC_ELECFENCE
	icon = ICON_ELECFENCE
	electric = TRUE

/obj/structure/fence/proc/electrocute(mob/living/M)
	if(electrocute_mob(M, get_area(src), src, 0.7))
		visible_message("\The [src] zaps [M]!")
		var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
		s.set_up(5, 1, src)
		s.start()
		return TRUE
	return FALSE

#undef NAME_ELECFENCE
#undef DESC_ELECFENCE
#undef ICON_ELECFENCE
