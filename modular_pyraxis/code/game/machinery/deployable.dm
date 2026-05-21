/obj/structure/barricade/cutout/cursed
	maxhealth = 50

/obj/structure/barricade/cutout/cursed/proc/spook(mob/mob)
	mob.overlay_fullscreen("spooks", /atom/movable/screen/fullscreen/noise)
	step_towards(src, mob)
	mob.Blind(5)

/obj/structure/barricade/cutout/cursed/examine(mob/user)
	. = ..()
	if(prob(33))
		spook(user)
