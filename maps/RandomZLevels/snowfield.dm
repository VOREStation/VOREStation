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

/obj/effect/landmark/away
	name = "awaystart"

/obj/effect/floor_decal/derelict/d1
	name = "derelict1"
	icon_state = "derelict1"

/obj/effect/floor_decal/derelict/d2
	name = "derelict2"
	icon_state = "derelict2"

/obj/effect/floor_decal/derelict/d3
	name = "derelict3"
	icon_state = "derelict3"

/obj/effect/floor_decal/derelict/d4
	name = "derelict4"
	icon_state = "derelict4"

/obj/effect/floor_decal/derelict/d5
	name = "derelict5"
	icon_state = "derelict5"

/obj/effect/floor_decal/derelict/d6
	name = "derelict6"
	icon_state = "derelict6"

/obj/effect/floor_decal/derelict/d7
	name = "derelict7"
	icon_state = "derelict7"

/obj/effect/floor_decal/derelict/d8
	name = "derelict8"
	icon_state = "derelict8"

/obj/effect/floor_decal/derelict/d9
	name = "derelict9"
	icon_state = "derelict9"

/obj/effect/floor_decal/derelict/d10
	name = "derelict10"
	icon_state = "derelict10"

/obj/effect/floor_decal/derelict/d11
	name = "derelict11"
	icon_state = "derelict11"

/obj/effect/floor_decal/derelict/d12
	name = "derelict12"
	icon_state = "derelict12"

/obj/effect/floor_decal/derelict/d13
	name = "derelict13"
	icon_state = "derelict13"

/obj/effect/floor_decal/derelict/d14
	name = "derelict14"
	icon_state = "derelict14"

/obj/effect/floor_decal/derelict/d15
	name = "derelict15"
	icon_state = "derelict15"

/obj/effect/floor_decal/derelict/d16
	name = "derelict16"
	icon_state = "derelict16"

/obj/effect/spawner/snowfield // Hacky as all hell and causes slow round loads BUT IT FUCKING WORKS NOW, DOESN'T IT? -Spades
	icon = 'icons/obj/flora/snowflora.dmi'
	icon_state = "snowbush1"

	New()
		switch(rand(1,100)) // It's written fucky so it's more efficient, trying the most likely options first to cause less lag hopefully.
			if(31 to 99)
				qdel(src)
			if(11 to 30)
				new /obj/structure/flora/bush(get_turf(src))
			if(1 to 10)
				new /obj/structure/flora/tree/pine(get_turf(src))
			if(100)
				var/junk = pick(/mob/living/simple_animal/hostile/samak, /mob/living/simple_animal/hostile/diyaab, /mob/living/simple_animal/hostile/shantak,
							/mob/living/simple_animal/hostile/vore/bear/polar, /obj/effect/landmark/away)
				new junk(get_turf(src))
		qdel(src)

/obj/effect/spawner/snowfield_nospawn
	icon = 'icons/mob/screen1.dmi'
	icon_state = "x"

	New()
		switch(rand(1,100)) // It's written fucky so it's more efficient, trying the most likely options first to cause less lag hopefully.
			if(31 to 100)
				qdel(src)
			if(11 to 30)
				new /obj/structure/flora/bush(get_turf(src))
			if(1 to 10)
				new /obj/structure/flora/tree/pine(get_turf(src))
		qdel(src)

/mob/living/simple_animal/hostile/vore/bear/polar
	name = "space bear"
	desc = "RawrRawr!!"
	icon_state = "polarbear"
	icon_living = "polarbear"
	icon_dead = "polarbear-dead"
	icon_gib = "bear-gib"
	faction = "alien"