/datum/gear/ball
	display_name = "tennis ball selection"
	description = "Choose from a num- BALL!"
	path = /obj/item/toy/tennis

/datum/gear/ball/New()
	..()
	var/list/balls = list()
	for(var/ball in typesof(/obj/item/toy/tennis/))
		var/obj/item/toy/tennis/ball_type = ball
		balls[initial(ball_type.name)] = ball_type
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(balls))

/datum/gear/plushie/New()
	..()
	gear_tweaks += gear_tweak_free_name
	gear_tweaks += gear_tweak_free_desc