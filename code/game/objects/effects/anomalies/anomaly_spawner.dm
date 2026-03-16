/obj/effect/spawner/lootdrop/environmentally_safe_anomaly
	name = "safe anomaly spawner"
	icon_state = "instability"
	loot = list(
		/obj/effect/anomaly/flux,
		/obj/effect/anomaly/bluespace,
		/obj/effect/anomaly/hallucination,
		/obj/effect/anomaly/bioscrambler/docile
	)

	var/anchor_anomaly = FALSE

/obj/effect/spawner/lootdrop/environmentally_safe_anomaly/Initialize(mapload)
	. = ..()

	var/obj/effect/anomaly/anomaly = .
	anomaly.stabilize(anchor = anchor_anomaly)
