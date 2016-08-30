/area/awaymission/snowfield
	icon_state = "blank"
//	requires_power = 0

/area/awaymission/snowfield/arrival
	icon_state = "away"
//	requires_power = 0

/area/awaymission/snowfield/base
	icon_state = "away"
	ambience = null // Todo: Add better ambience.

/area/awaymission/snowfield/base/entry
	icon_state = "blue"
//	ambience = list('sound/music/TheClownChild.ogg')

// These extra areas must break up the large area, or the game crashes when machinery (like an airlock) makes sparks.
// I have no idea why. It's a nasty bug.
/area/awaymission/snowfield/base/south_east
	icon_state = "red"

/area/awaymission/snowfield/base/south_west
	icon_state = "bluenew"

/area/awaymission/snowfield/base/south
	icon_state = "green"

/area/awaymission/snowfield/base/west
	icon_state = "purple"

/area/awaymission/snowfield/base/center
	icon_state = "yellow"

/area/awaymission/snowfield/base/east
	icon_state = "blue"

/area/awaymission/snowfield/base/north_east
	icon_state = "exit"

/area/awaymission/snowfield/base/north_west
	icon_state = "orange"

/area/awaymission/snowfield/base/north
	icon_state = "blue"

/area/awaymission/snowfield/boss
	icon_state = "red"

/obj/effect/landmark
	name = "awaystart"

/obj/effect/spawner/snowfield // Hacky as all hell and causes slow round loads BUT IT FUCKING WORKS NOW, DOESN'T IT? -Ace
	icon = 'icons/obj/flora/snowflora.dmi'
	icon_state = "snowbush1"

	New()
		var/clutter_chance = rand(1,100)
		if(clutter_chance >= 1 && clutter_chance <= 10)
			new /obj/structure/flora/tree/pine(get_turf(src))
		if(clutter_chance >= 11 && clutter_chance <= 20)
			new /obj/structure/flora/bush(get_turf(src))
		if(clutter_chance >= 21 && clutter_chance <= 30)
			new /obj/structure/flora/bush(get_turf(src))
		if(clutter_chance == 100)
			var/junk = pick(/mob/living/simple_animal/hostile/samak, /mob/living/simple_animal/hostile/diyaab, /mob/living/simple_animal/hostile/shantak,
							/mob/living/simple_animal/hostile/vore/bear/polar, /obj/effect/landmark)
			new junk(get_turf(src))
		qdel(src)

/obj/effect/spawner/snowfield_nospawn
	icon = 'icons/mob/screen1.dmi'
	icon_state = "x"
	New()
		var/clutter_chance = rand(1,100)
		if(clutter_chance >= 1 && clutter_chance <= 10)
			new /obj/structure/flora/tree/pine(get_turf(src))
		if(clutter_chance >= 11 && clutter_chance <= 20)
			new /obj/structure/flora/bush(get_turf(src))
		if(clutter_chance >= 21 && clutter_chance <= 30)
			new /obj/structure/flora/bush(get_turf(src))
		qdel(src)

/mob/living/simple_animal/hostile/vore/bear/polar
	name = "space bear"
	desc = "RawrRawr!!"
	icon_state = "polarbear"
	icon_living = "polarbear"
	icon_dead = "polarbear-dead"
	icon_gib = "bear-gib"
	faction = "alien"


/obj/item/seeds // Remove before final release
	icon_state = ""