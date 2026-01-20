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
		anomaly.stabilize()

		if(!releaser.infinite)
			releaser.icon_state = releaser.used_icon_state
			releaser.used = TRUE
			releaser.name = "used " + name
			qdel(src)
	return ..()

/obj/item/assembly/signaler/anomaly/flux
	name = "\improper flux anomaly core"
	desc = "The neutralized core of a flux anomaly. Touching it makes your skin tingle. It'd probably be valuable for research."
	icon_state = "flux_core"
	anomaly_type = /obj/effect/anomaly/flux

/obj/item/assembly/signaler/anomaly/bluespace
	name = "\improper bluespace anomaly core"
	desc = "The neutralized core of a bluespace anomaly. It keeps phasing in and out of view. It'd probably be valuable for research."
	icon_state = "anomaly_core"
	anomaly_type = /obj/effect/anomaly/bluespace

/obj/item/assembly/signaler/anomaly/grav
	name = "\improper gravitational anomaly core"
	desc = "The neutralized core of a gravitational anomaly. It feels much heavier than it looks. It'd probably be valuable for research."
	icon_state = "grav_core"
	anomaly_type = /obj/effect/anomaly/grav

/obj/item/assembly/signaler/anomaly/dimensional
	name = "\improper dimensional anomaly core"
	desc = "The neutralized core of a dimensional anomaly. Objects reflected on its surface don't look quite right. It'd probably be valuable for research."
	icon_state = "dimensional_core"
	anomaly_type = /obj/effect/anomaly/dimensional

/obj/item/assembly/signaler/anomaly/bioscrambler
	name = "\improper bioscrambler anomaly core"
	desc = "The neutralized core of a bioscrambler anomaly. It's squirming, as if moving. It'd probably be valuable for research."
	icon_state = "bioscrambler_core"
	anomaly_type = /obj/effect/anomaly/bioscrambler

/obj/item/assembly/signaler/anomaly/hallucination
	name = "\improper hallucination anomaly core"
	desc = "The neutralized core of a hallucination anomaly. It seems to be moving, but it's probably your imagination. It'd probably be valuable for research."
	icon_state = "hallucination_core"
	anomaly_type = /obj/effect/anomaly/hallucination

/obj/item/assembly/signaler/anomaly/pyro
	name = "\improper pyroclastic anomaly core"
	desc = "The neutralized core of a pyroclastic anomaly. It feels warm to the touch. It'd probably be valuable for research."
	icon_state = "pyro_core"
	anomaly_type = /obj/effect/anomaly/pyro

/obj/item/assembly/signaler/anomaly/weather
	name = "\improper weather anomaly core"
	desc = "The neutralized core of a weather anomaly. The sound of thunder can be heard in the distance. It'd probably be valuable for research."
	icon_state = "weather_core"
	anomaly_type = /obj/effect/anomaly/weather
