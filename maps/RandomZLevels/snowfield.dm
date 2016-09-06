// -- Areas -- //

/area/awaymission/snowfield
	icon_state = "blank"
//	requires_power = 0
	base_turf = /turf/snow/snow2
	ambience = list('sound/ambience/ambispace.ogg','sound/music/title2.ogg','sound/music/space.ogg','sound/music/main.ogg','sound/music/traitor.ogg')
	base_turf = /turf/simulated/floor/snow/snow2

/area/awaymission/snowfield/outside
	icon_state = "green"
	requires_power = 1
	always_unpowered = 1
	lighting_use_dynamic = 1
	power_light = 0
	power_equip = 0
	power_environ = 0
	mobcountmax = 100
	floracountmax = 7000
	valid_mobs = list(/mob/living/simple_animal/hostile/samak/polar, /mob/living/simple_animal/hostile/diyaab/polar,
					/mob/living/simple_animal/hostile/shantak/polar, /mob/living/simple_animal/hostile/vore/polarbear)
	valid_flora = list(/obj/structure/flora/tree/pine, /obj/structure/flora/tree/pine, /obj/structure/flora/tree/pine,
					/obj/structure/flora/tree/dead, /obj/structure/flora/grass/brown, /obj/structure/flora/grass/green,
					/obj/structure/flora/grass/both, /obj/structure/flora/bush, /obj/structure/flora/ausbushes/grassybush,
					/obj/structure/flora/ausbushes/sunnybush, /obj/structure/flora/ausbushes/genericbush, /obj/structure/flora/ausbushes/pointybush,
					/obj/structure/flora/ausbushes/lavendergrass, /obj/structure/flora/ausbushes/sparsegrass, /obj/structure/flora/ausbushes/fullgrass)

/area/awaymission/snowfield/restricted // No mob spawns!
	icon_state = "red"
	mobcountmax = 0
	floracountmax = 500
	valid_flora = list(/obj/structure/flora/tree/pine, /obj/structure/flora/tree/pine, /obj/structure/flora/tree/pine,
					/obj/structure/flora/tree/dead, /obj/structure/flora/grass/brown, /obj/structure/flora/grass/green,
					/obj/structure/flora/grass/both, /obj/structure/flora/bush, /obj/structure/flora/ausbushes/grassybush,
					/obj/structure/flora/ausbushes/sunnybush, /obj/structure/flora/ausbushes/genericbush, /obj/structure/flora/ausbushes/pointybush,
					/obj/structure/flora/ausbushes/lavendergrass, /obj/structure/flora/ausbushes/sparsegrass, /obj/structure/flora/ausbushes/fullgrass)

/area/awaymission/snowfield/base
	icon_state = "away"
	ambience = null // Todo: Add better ambience.

// -- Mobs -- //

/mob/living/simple_animal/hostile/vore/polarbear // More aggressive than normal bears so none of that fancy life() stuff.
	name = "polar bear"
	desc = "The real question is, why are you examining it, instead of running away?"
	icon_state = "polarbear"
	icon_living = "polarbear"
	icon_dead = "polarbear-dead"
	icon_gib = "bear-gib"
	speak = list("RAWR!","Rawr!","GRR!","Growl!")
	speak_emote = list("growls", "roars")
	emote_hear = list("rawrs","grumbles","grawls")
	emote_see = list("stares ferociously", "stomps")
	speak_chance = 1
	turns_per_move = 5
	see_in_dark = 6
	meat_type = /obj/item/weapon/reagent_containers/food/snacks/bearmeat
	response_help  = "pets"
	response_disarm = "gently pushes aside"
	response_harm   = "desperately attacks"
	stop_automated_movement_when_pulled = 0
	maxHealth = 80
	health = 80 // Polar bear will fuck you up.
	melee_damage_lower = 20
	melee_damage_upper = 50 // srsly u gon get rekt
	minbodytemp = 0
	faction = "polar"

/mob/living/simple_animal/hostile/vore/polarbear/death()
	desc = "This bastard sure isn't drinking Space Cola anymore."
	..()

/mob/living/simple_animal/hostile/samak/polar
	faction = "polar"

/mob/living/simple_animal/hostile/diyaab/polar
	faction = "polar"

/mob/living/simple_animal/hostile/shantak/polar
	faction = "polar"

// -- Items -- //

// For fake solar power.
/obj/machinery/power/fractal_reactor/fluff/smes
	name = "power storage unit"
	desc = "A high-capacity superconducting magnetic energy storage (SMES) unit. The controls are locked."
	icon_state = "smes"

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