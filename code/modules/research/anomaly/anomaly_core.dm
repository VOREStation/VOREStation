/obj/item/assembly/signaler/anomaly
	name = "anomaly core"
	desc = "The neutralized core of an anomaly. It'd probably be valuable for research."
	icon_state = "anomaly_core"

	var/anomaly_type = /obj/effect/anomaly
	var/worth = 250 // Pricey... Should be hard-ish to obtain.
	special_handling = TRUE

/obj/item/assembly/signaler/anomaly/Initialize(mapload)
	. = ..()
	if(worth)
		AddElement(/datum/element/sellable)

/obj/item/assembly/signaler/anomaly/receive_signal(datum/signal/signal)
	if(!signal)
		return FALSE
	if(signal.encryption != code)
		return FALSE
	for(var/obj/effect/anomaly/anomaly in get_turf(src))
		anomaly.anomalyNeutralize()
	return TRUE

/obj/item/assembly/signaler/anomaly/attack_self(mob/user)
	. = ..(user)
	if(.)
		return TRUE
	return

/obj/item/assembly/signaler/anomaly/attackby(obj/item/W, mob/user, params)
	if(istype(W, /obj/item/analyzer))
		to_chat(user, span_notice("Analyzing... [src]'s stabilized field is fluctuating along frequency [format_frequency(frequency)], code [code]."))
		return TRUE

	if(istype(W, /obj/item/anomaly_scanner))
		to_chat(user, span_notice("Sealed anomalous energies detected. Use of a releaser will unleash these energies."))
		return TRUE

	if(istype(W, /obj/item/anomaly_releaser))
		var/obj/item/anomaly_releaser/releaser = W
		if(releaser.used)
			return FALSE
		if(!do_after(user, 3 SECONDS, src))
			return FALSE

		var/obj/item/assembly/signaler/anomaly/core = src
		if(!core.anomaly_type)
			return FALSE

		var/obj/effect/anomaly/anomaly = new core.anomaly_type(get_turf(core))
		anomaly.stabilize(releaser.will_anchor, releaser.has_core, releaser.gives_stats)

		if(!releaser.infinite)
			releaser.icon_state = releaser.used_icon_state
			releaser.used = TRUE
			releaser.name = "used " + releaser.name
			qdel(src)
	return ..()

/obj/item/assembly/signaler/anomaly/flux
	name = "\improper flux anomaly core"
	desc = "The neutralized core of a flux anomaly. Touching it makes your skin tingle. It'd probably be valuable for research."
	icon_state = "flux_core"
	anomaly_type = /obj/effect/anomaly/flux

/obj/item/assembly/signaler/anomaly/flux/receive_signal()
	tesla_zap(src, 2, 1000, FALSE, FALSE, 1)

/obj/item/assembly/signaler/anomaly/bluespace
	name = "\improper bluespace anomaly core"
	desc = "The neutralized core of a bluespace anomaly. It keeps phasing in and out of view. It'd probably be valuable for research."
	icon_state = "anomaly_core"
	anomaly_type = /obj/effect/anomaly/bluespace
	activation_cooldown = 15 SECONDS

/obj/item/assembly/signaler/anomaly/bluespace/receive_signal()
	var/atom/movable/to_teleport = get_teleportable_container(src, container_flags = TELEPORT_CONTAINER_INCLUDE_SEALED_RIGSUIT)
	if(!to_teleport)
		return
	var/turf/teleportable_turf = get_turf(to_teleport)
	playsound(teleportable_turf, 'sound/effects/phasein.ogg', 100, TRUE)
	do_teleport(to_teleport, teleportable_turf, 4, channel = TELEPORT_CHANNEL_BLUESPACE)

/obj/item/assembly/signaler/anomaly/grav
	name = "\improper gravitational anomaly core"
	desc = "The neutralized core of a gravitational anomaly. It feels much heavier than it looks. It'd probably be valuable for research."
	icon_state = "grav_core"
	anomaly_type = /obj/effect/anomaly/grav

/obj/item/assembly/signaler/anomaly/grav/receive_signal()
	for(var/obj/object in orange(2, get_turf(src)))
		if(!object.anchored)
			step_towards(object, src)
	for(var/mob/living/living in orange(2, get_turf(src)))
		if(!living.can_overcome_gravity())
			step_towards(living, src)

/obj/item/assembly/signaler/anomaly/dimensional
	name = "\improper dimensional anomaly core"
	desc = "The neutralized core of a dimensional anomaly. Objects reflected on its surface don't look quite right. It'd probably be valuable for research."
	icon_state = "dimensional_core"
	anomaly_type = /obj/effect/anomaly/dimensional
	activation_cooldown = 15 SECONDS

/obj/item/assembly/signaler/anomaly/dimensional/receive_signal()
	var/turf/our_turf = get_turf(src)
	if(!our_turf)
		return
	var/theme_path = pick(subtypesof(/datum/dimension_theme))
	var/datum/dimension_theme/theme = new theme_path

	for(var/turf/turf as anything in RANGE_TURFS(1, our_turf))
		theme.apply_theme(turf, show_effect = TRUE)

/obj/item/assembly/signaler/anomaly/bioscrambler
	name = "\improper bioscrambler anomaly core"
	desc = "The neutralized core of a bioscrambler anomaly. It's squirming, as if moving. It'd probably be valuable for research."
	icon_state = "bioscrambler_core"
	anomaly_type = /obj/effect/anomaly/bioscrambler
	activation_cooldown = 10 SECONDS

/obj/item/assembly/signaler/anomaly/bioscrambler/receive_signal()
	new /obj/effect/temp_visual/circle_wave/bioscrambler(get_turf(src))
	for(var/mob/living/carbon/nearby in hearers(1, get_turf(src)))
		randmutb(nearby)
		domutcheck(nearby, null)

/obj/item/assembly/signaler/anomaly/hallucination
	name = "\improper hallucination anomaly core"
	desc = "The neutralized core of a hallucination anomaly. It seems to be moving, but it's probably your imagination. It'd probably be valuable for research."
	icon_state = "hallucination_core"
	anomaly_type = /obj/effect/anomaly/hallucination
	activation_cooldown = 10 SECONDS

/obj/item/assembly/signaler/anomaly/hallucination/receive_signal()
	for(var/mob/living/nearby_living in view(get_turf(src), 2))
		if(HAS_TRAIT(nearby_living, TRAIT_MADNESS_IMMUNE))
			continue

		if(nearby_living.is_blind())
			continue

		nearby_living.hallucination += 25

/obj/item/assembly/signaler/anomaly/pyro
	name = "\improper pyroclastic anomaly core"
	desc = "The neutralized core of a pyroclastic anomaly. It feels warm to the touch. It'd probably be valuable for research."
	icon_state = "pyro_core"
	anomaly_type = /obj/effect/anomaly/pyro

/obj/item/assembly/signaler/anomaly/pyro/receive_signal()
	var/turf/our_turf = get_turf(src)
	if(!our_turf)
		return
	playsound(our_turf, 'sound/magic/fireball.ogg', 100, TRUE)
	for(var/turf/turf as anything in RANGE_TURFS(1, our_turf))
		our_turf.assume_gas(GAS_PHORON, 10, T20C)
		our_turf.hotspot_expose(700, 400)

/obj/item/assembly/signaler/anomaly/weather
	name = "\improper weather anomaly core"
	desc = "The neutralized core of a weather anomaly. The sound of thunder can be heard in the distance. It'd probably be valuable for research."
	icon_state = "weather_core"
	anomaly_type = /obj/effect/anomaly/weather

/obj/item/assembly/signaler/anomaly/weather/receive_signal()
	var/turf/our_turf = get_turf(src)
	if(!our_turf)
		return
	var/list/possible_targets = list()
	for(var/turf/turf as anything in RANGE_TURFS(2, our_turf))
		possible_targets += turf
	if(!length(possible_targets))
		return
	var/turf/target = pick(possible_targets)
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(lightning_strike), target), 1 SECONDS)

/obj/item/assembly/signaler/anomaly/dust
	name = "\improper dust anomaly core"
	desc = "The neutralized core of a dust anomaly. It seems to leave some dirt on touch. It'd probably be valuable for research."
	icon_state = "dust_core"
	anomaly_type = /obj/effect/anomaly/dust

/obj/item/assembly/signaler/anomaly/dust/receive_signal()
	new /obj/effect/temp_visual/circle_wave/dirt(get_turf(src))
	for(var/mob/living/carbon/human/person in view(get_turf(src), 2))
		person.germ_level += rand(5, 10)
		if(person.isSynthetic())
			continue
		if(person.is_mouth_covered())
			continue
		if(!person.has_lungs())
			continue
		person.emote(prob(50) ? "cough" : "sneeze")
		person.Weaken(2)
		person.adjustOxyLoss(10)
		if(prob(15))
			person.Stun(2)
			to_chat(person, span_danger(pick("You have a coughing fit!", "You can't stop coughing!")))
			addtimer(CALLBACK(person, TYPE_PROC_REF(/mob, emote), "cough"), 1 SECONDS)
			addtimer(CALLBACK(person, TYPE_PROC_REF(/mob, emote), "cough"), 3 SECONDS)
			addtimer(CALLBACK(person, TYPE_PROC_REF(/mob, emote), "cough"), 6 SECONDS)
