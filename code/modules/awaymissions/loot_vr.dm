// Legacy version. Need to investigate what the hell the one above does later. -Ace
/obj/effect/landmark/loot_spawn
	name = "loot spawner"
	icon_state = "grabbed1"
	var/live_cargo = 1 // So you can turn off aliens.
	var/low_probability = 0
	var/spawned_faction = "hostile" // Spawned mobs can have their faction changed.

	// TODO Stuff

/obj/effect/landmark/loot_spawn/low
	name = "low prob loot spawner"
	icon_state = "grabbed"
	low_probability = 1
