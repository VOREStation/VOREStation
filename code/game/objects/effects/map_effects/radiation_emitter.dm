<<<<<<< HEAD
// Constantly emites radiation from the tile it's placed on.
/obj/effect/map_effect/radiation_emitter
	name = "radiation emitter"
	icon_state = "radiation_emitter"
	var/radiation_power = 30 // Bigger numbers means more radiation.

/obj/effect/map_effect/radiation_emitter/Initialize()
	START_PROCESSING(SSobj, src)
	return ..()

/obj/effect/map_effect/radiation_emitter/Destroy()
	STOP_PROCESSING(SSobj, src)
	return ..()

/obj/effect/map_effect/radiation_emitter/process()
	radiation_repository.radiate(src, radiation_power)

/obj/effect/map_effect/radiation_emitter/strong
=======
// Constantly emites radiation from the tile it's placed on.
/obj/effect/map_effect/radiation_emitter
	name = "radiation emitter"
	icon_state = "radiation_emitter"
	var/radiation_power = 30 // Bigger numbers means more radiation.

/obj/effect/map_effect/radiation_emitter/Initialize()
	START_PROCESSING(SSobj, src)
	return ..()

/obj/effect/map_effect/radiation_emitter/Destroy()
	STOP_PROCESSING(SSobj, src)
	return ..()

/obj/effect/map_effect/radiation_emitter/process()
	SSradiation.radiate(src, radiation_power)

/obj/effect/map_effect/radiation_emitter/strong
>>>>>>> b193761... Merge pull request #6471 from Novacat/nova-runtimes
	radiation_power = 100