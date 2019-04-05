/*
	Combat drones have a rapid ranged attack, and have a projectile shield.
	They are rather slow, but attempt to 'kite' its target.
	A solid hit with an EMP grenade will kill the shield instantly.
*/

/datum/category_item/catalogue/technology/drone/combat_drone
	name = "Drone - Combat Drone"
	desc = "Deadly to anyone it perceives as an enemy, this drone model tries to capture the ideal balance \
	between effectiveness, versatility, and expendability. It possesses sophisticated technology that allows it \
	to both be dangerous, and be less costly to build compared to alternatives such as exosuits. It was designed \
	for combat in space, however they are also able to function inside a gravity well, due to a favorable \
	thrust-to-weight ratio.\
	<br><br>\
	One notable feature of this model is its ability to rapidly fire lasers at the target. This is accomplished \
	with its array of lasers installed on the left and right side of the drone, with each side housing three \
	laser emitters. The drone cycles between the six different emitters each time it fires a laser, in order to avoid \
	overheating before the integrated heatsinks are able to remove the heat, \
	thus allowing for a higher than average rate of fire. This ability allows for the drone to act in a suppressive \
	manner against personnel, or to provide a general 'shock and awe' factor when swarms of drones are firing at once.\
	<br><br>\
	The drone's frame is lightweight, as required due to the type of thrusters integrated into the frame. \
	Unfortunately, this comes at the cost of being less sturdy. To counteract this vulnerability, the \
	drone has an integrated shield projector, which is tuned to allow the shield to intercept projectiles, \
	while allowing its own lasers to pass through unaffected.\
	<br><br>\
	Despite these qualities, one significant flaw this model has, is that its source of energy is considerably \
	less powerful than what is standard, which cuts into the amount of energy that can go into both the lasers and the shields. \
	Generally, the solution to this flaw is to add more drones until it doesn't matter anymore."
	value = CATALOGUER_REWARD_MEDIUM

/mob/living/simple_mob/mechanical/combat_drone
	name = "combat drone"
	desc = "An automated combat drone armed with state of the art weaponry and shielding."
	catalogue_data = list(/datum/category_item/catalogue/technology/drone/combat_drone)

	icon_state = "drone"
	icon_living = "drone"
	icon_dead = "drone_dead"
	has_eye_glow = TRUE

	faction = "malf_drone"

	maxHealth = 50 // Shield has 150 for total of 200.
	health = 50
	movement_cooldown = 5
	hovering = TRUE

	base_attack_cooldown = 5
	projectiletype = /obj/item/projectile/beam/drone
	projectilesound = 'sound/weapons/laser3.ogg'

	response_help = "pokes"
	response_disarm = "gently pushes aside"
	response_harm = "hits"

	ai_holder_type = /datum/ai_holder/simple_mob/ranged/kiting/threatening
	say_list_type = /datum/say_list/malf_drone

	var/datum/effect/effect/system/ion_trail_follow/ion_trail = null
	var/obj/item/shield_projector/shields = null

/mob/living/simple_mob/mechanical/combat_drone/Initialize()
	ion_trail = new
	ion_trail.set_up(src)
	ion_trail.start()

	shields = new /obj/item/shield_projector/rectangle/automatic/drone(src)
	return ..()

/mob/living/simple_mob/mechanical/combat_drone/Destroy()
	QDEL_NULL(ion_trail)
	QDEL_NULL(shields)
	return ..()

/mob/living/simple_mob/mechanical/combat_drone/death()
	..(null,"suddenly breaks apart.")
	qdel(src)

/mob/living/simple_mob/mechanical/combat_drone/Process_Spacemove(var/check_drift = 0)
	return TRUE

/obj/item/projectile/beam/drone
	damage = 10

/obj/item/shield_projector/rectangle/automatic/drone
	shield_health = 150
	max_shield_health = 150
	shield_regen_delay = 10 SECONDS
	shield_regen_amount = 10
	size_x = 1
	size_y = 1

// A slightly easier drone, for POIs.
// Difference is that it should not be faster than you.
/mob/living/simple_mob/mechanical/combat_drone/lesser
	desc = "An automated combat drone with an aged apperance."
	movement_cooldown = 10


// This one is the type spawned by the random event.
// It won't wander away from its spawn point
/mob/living/simple_mob/mechanical/combat_drone/event
	ai_holder_type = /datum/ai_holder/simple_mob/ranged/kiting/threatening/event
