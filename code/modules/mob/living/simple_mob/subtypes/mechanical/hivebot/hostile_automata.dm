
//////////////////////Catalogue Entries//////////////////////

/datum/category_item/catalogue/technology/drone/automaton
	name = "Drone - Surplus Robot"
	desc = "Classification: MX11 Automaton\
	<br><br>\
	This ancient model of robot was used widely at the very beginning of the Interstellar Expansion era. \
	These surplus robot was widely used by stations, colonies, and bases for dumb-labor such as janitorial, \
	logistical, and even simple area security. These older models would later be phased out for more favorable \
	modernized technology as the year went by but abandoned establishments and the older stations may still \
	use these models for basic labor.\
	<br>\
	These robots were made cheap and from cheap material and thus aren't too much of a threat in small numbers - \
	however, travellers are cautioned against engaging larger groups as even the most simple of units in \
	large numbers can overwhelm even the most prepared people. \
	<br>\
	Depending on what sort of work or tasks the automaton may be assigned these bots, their Intelligence level can \
	vary between Epsilon to Gamma - however there is rare instances of Beta and Alpha level Intelligence appearing \
	in various older models - however due to the age of the technology these drones usually fry their internal data \
	structures within a short period and 'die off' as a result."
	value = CATALOGUER_REWARD_TRIVIAL

/datum/category_item/catalogue/technology/drone/automaton/syndi
	name = "Drone - Syndicate Securibot"
	desc = "Classification: R04 V9 Securibot\
	<br><br>\
	This is an old, unused line of security automatons whose designs were stolen from NanoTrasen in the early 2280s. \
	The design was meant to replace living security with a cheap and effective unit that could serve to protect \
	establishments and stations around known space. The Syndicate stole the designs and adapted the Gamma Level framework \
	to meet their need for automated security in their own bases as well as frontline soldiers that could be \
	deployed against corporate security.\
	<br>\
	These have various models ranging from tanky super drones to cheap infantry and guard units. Each model is a threat \
	in its own right and together as a team they are a formidable force to face. Travellers are asked that if they spot \
	any Securibots that they avoid them at all costs."
	value = CATALOGUER_REWARD_HARD

//////////////////////Robot Ranged Weapons//////////////////////

/obj/item/projectile/beam/automaton/basic
	damage = 10

/obj/item/projectile/beam/automaton/advanced
	damage = 20
	armor_penetration = 5

/obj/item/projectile/beam/automaton/tank
	damage = 50
	armor_penetration = 15
	icon_state = "heavylaser"
	fire_sound = 'sound/weapons/lasercannonfire.ogg'
	light_range = 3
	light_power = 1
	light_color = "#FF0D00"

	muzzle_type = /obj/effect/projectile/muzzle/laser_heavy
	tracer_type = /obj/effect/projectile/tracer/laser_heavy
	impact_type = /obj/effect/projectile/impact/laser_heavy

//////////////////////Automatons//////////////////////

/mob/living/simple_mob/mechanical/automaton
	name = "Surplus Robot"
	desc = "An ancient model of mass produced robotic unit. Can't get anymore basic than this."
	catalogue_data = list(/datum/category_item/catalogue/technology/drone/automaton)

	icon = 'icons/mob/hostile_automata.dmi'
	icon_state = "basic_bot"
	icon_living = "basic_bot"
	has_eye_glow = TRUE

	faction = "automaton"

	maxHealth = 30
	health = 30
	water_resist = 0.5
	movement_sound = 'sound/effects/servostep.ogg'

	melee_damage_lower = 8
	melee_damage_upper = 8
	attacktext = list("bashed", "smacked", "hit")
	projectilesound = 'sound/weapons/Laser.ogg'

	response_help = "pokes"
	response_disarm = "gently pushes aside"
	response_harm = "hits"

	ai_holder_type = /datum/ai_holder/simple_mob/automaton
	say_list_type = /datum/say_list/automaton


/mob/living/simple_mob/mechanical/automaton/death()
	..()
	visible_message(span("warning","\The [src] blows apart!"))
	new /obj/effect/decal/cleanable/blood/gibs/robot(src.loc)
	var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
	s.set_up(3, 1, src)
	s.start()
	qdel(src)

/mob/living/simple_mob/mechanical/automaton/ranged
	name = "Laser Robot"
	desc = "A mass produced robotic unit with a photonic weapon integrated into its system."
	projectiletype = /obj/item/projectile/beam/automaton/basic
	projectile_dispersion = 6
	projectile_accuracy = -10

	icon_state = "ranged_bot"
	icon_living = "ranged_bot"


//////////////////////Commie Bots//////////////////////

/mob/living/simple_mob/mechanical/automaton/commie
	name = "Communist Robot"
	desc = "A mass produced robotic unit dressed in communist garb."

	icon_state = "commie_bot"
	icon_living = "commie_bot"

/mob/living/simple_mob/mechanical/automaton/comofficer
	name = "Communist Officer Robot"
	desc = "A mass produced robotic unit dressed in communist garb. This one appears to be more armored and has an advanced integrated laser."
	projectiletype = /obj/item/projectile/beam/automaton/advanced
	projectile_dispersion = 6
	projectile_accuracy = -10

	icon_state = "officer_commie_bot"
	icon_living = "officer_commie_bot"

	maxHealth = 50
	health = 50

//////////////////////Misc Bots//////////////////////

/mob/living/simple_mob/mechanical/automaton/drone
	name = "Drone"
	desc = "A general use drone unit that seems to have malfunctioned."

	icon_state = "lost_drone_1"
	icon_living = "lost_drone_1"

	hovering = TRUE
	maxHealth = 15
	health = 15

//////////////////////Bot AI Types//////////////////////

/datum/ai_holder/simple_mob/automaton
	pointblank = TRUE
	conserve_ammo = TRUE
	firing_lanes = TRUE
	can_flee = FALSE // Fearless dumb machines.

/datum/ai_holder/simple_mob/mechanical/automaton/syndi
	threaten = TRUE
	returns_home = TRUE		// Stay close to the base...
	wander = FALSE			// ...And don't go wandering off.
	intelligence_level = AI_SMART // Also knows not to walk while confused if it risks death.
	threaten_delay = 30 SECONDS // Will give you 30 seconds to leave or get shot.

/datum/ai_holder/simple_mob/mechanical/automaton/syndi/sentry
	threaten = TRUE
	returns_home = TRUE		// Stay close to the base...
	wander = TRUE			// ... but "patrol" a little.
	intelligence_level = AI_SMART // Also knows not to walk while confused if it risks death.
	threaten_delay = 30 SECONDS // Will give you 30 seconds to leave or get shot.

//////////////////////Syndicate Bots//////////////////////

/mob/living/simple_mob/mechanical/automaton/syndi
	name = "Syndicate Securibot Sentry"
	desc = "A mass produced robotic unit that's been programmed to protect a given area."
	catalogue_data = list(/datum/category_item/catalogue/technology/drone/automaton/syndi)

	icon_state = "syndicate_sentry"
	icon_living = "syndicate_sentry"
	icon_dead = "dead_syndicate"

	faction = "syndicate"
	ai_holder_type = /datum/ai_holder/simple_mob/mechanical/automaton/syndi/sentry

	maxHealth = 100
	health = 100
	movement_cooldown = 5
	melee_damage_lower = 10
	melee_damage_upper = 10
	attacktext = list("bashed", "whacked", "hit", "beaten")

/mob/living/simple_mob/mechanical/automaton/syndi/ranged
	name = "Syndicate Securibot Guard"
	desc = "A mass produced robotic unit that's been programmed to protect a given area. It has an integrated photonic weapon system."
	catalogue_data = list(/datum/category_item/catalogue/technology/drone/automaton/syndi)

	projectiletype = /obj/item/projectile/beam/automaton/advanced
	projectile_dispersion = 6
	projectile_accuracy = -10

	icon_state = "syndicate_guard"
	icon_living = "syndicate_guard"
	icon_dead = "dead_syndicate"

	faction = "syndicate"
	ai_holder_type = /datum/ai_holder/simple_mob/mechanical/automaton/syndi

	maxHealth = 100
	health = 100
	movement_cooldown = 8

/mob/living/simple_mob/mechanical/automaton/syndi/tank
	name = "Syndicate Securibot Tank"
	desc = "A cyborg shell with no higher level AI installed, instead it's been programmed to protect a given area. It has a heavy photonic weapon system built in to the body."
	catalogue_data = list(/datum/category_item/catalogue/technology/drone/automaton/syndi)
	base_attack_cooldown = 30
	projectiletype = /obj/item/projectile/beam/automaton/tank
	projectile_dispersion = 8
	projectile_accuracy = -15

	icon_state = "syndicate_tank"
	icon_living = "syndicate_tank"
	icon_dead = "dead_synditank"
	icon_scale_x = 1.5
	icon_scale_y = 1.5

	faction = "syndicate"
	ai_holder_type = /datum/ai_holder/simple_mob/mechanical/automaton/syndi

	maxHealth = 150
	health = 150
	movement_cooldown = 12
