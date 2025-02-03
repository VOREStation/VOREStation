/datum/artifact_find
	var/artifact_id
	var/artifact_find_type

/// These are the LARGE artifacts that can spawn (Have density, have to be pulled, etc etc.) Not the HANDHELD or MUNDANE artifacts. For those, see find_spawning.dm.
/datum/artifact_find/New()

	artifact_id = "[pick("kappa","sigma","antaeres","beta","omicron","iota","epsilon","omega","gamma","delta","tau","alpha")]-[rand(100,999)]"

	artifact_find_type = pick(
	300;/obj/machinery/artifact,
	25;/obj/machinery/auto_cloner,
	25;/obj/machinery/replicator/vore,
	25;/obj/structure/constructshell,
	25;/obj/machinery/replicator/clothing,
	25;/obj/structure/crystal,
	15;/obj/machinery/giga_drill,
	5;/obj/machinery/syndicate_beacon/virgo,
	2;/obj/machinery/power/supermatter/shard,
	1;/obj/machinery/power/supermatter)

	// Calculations:
	// TO do the math calculation:
	// OBJECT_WEIGHT = The weight of the object. (Ex: supermatter is 1)
	// TOTAL_WEIGHT = The weight of ALL the objects added together
	// To calculate the chance of an artifact spawning, do: ((OBJECT_WEIGHT  / TOTAL_WEIGHT) * 100) and that is your %
