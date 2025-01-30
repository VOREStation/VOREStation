/datum/artifact_find
	var/artifact_id
	var/artifact_find_type

/// These are the LARGE artifacts that can spawn (Have density, have to be pulled, etc etc.) Not the HANDHELD or MUNDANE artifacts. For those, see find_spawning.dm.
/datum/artifact_find/New()

	artifact_id = "[pick("kappa","sigma","antaeres","beta","omicron","iota","epsilon","omega","gamma","delta","tau","alpha")]-[rand(100,999)]"

	artifact_find_type = pick(
	300;/obj/machinery/artifact,
	50;/obj/machinery/syndicate_beacon/virgo,	// VOREStation Edit: use virgo-specific subtype that doesn't create 'real' antags,
	50;/obj/machinery/auto_cloner,
	50;/obj/machinery/replicator/vore,
	25;/obj/structure/constructshell,
	25;/obj/machinery/giga_drill,
	25;/obj/machinery/replicator/clothing, 	//VOREStation Edit: use virgo-specific subtype that allows TF into items. 		//VOREStation Edit: use virgo-specific subtype that allows TF into mobs.
	25;/obj/structure/crystal,
	5;/obj/machinery/power/supermatter/shard,
	5;/obj/machinery/power/supermatter,)

	// Calculations:
	// Our total is 560 (As of the time of writing. If ANY of the weights are adjusted above, you have to recalculate. Formula: (thingy_wt/total_wt)*100 = % chance of drop)
	// Artifact: 53%
	// 50 wt: 8.9%
	// 25 wt: 4.4%
	// 5 wt: 0.89%
