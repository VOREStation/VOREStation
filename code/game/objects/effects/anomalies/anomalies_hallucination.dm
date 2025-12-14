/obj/effect/anomaly/hallucination
	name = "hallucination anomaly"
	icon_state = "hallucination"
	anomaly_core = /obj/item/assembly/signaler/anomaly/hallucination
	/// Time passed since the last effect, increased by seconds_per_tick of the SSobj
	var/ticks = 0
	/// How many seconds between each small hallucination pulses
	var/release_delay = 5
	/// Messages sent to people feeling the pulses
	var/static/list/messages = list(
		span_warning("You feel your conscious mind fall apart!"),
		span_warning("Reality warps around you!"),
		span_warning("Something's whispering around you!"),
		span_warning("You are going insane!"),
	)
	///Do we spawn misleading decoys?
	var/spawn_decoys = TRUE

/obj/effect/anomaly/hallucination/Initialize(mapload, new_lifespan)
	. = ..()
	apply_wibbly_filters(src)
	generate_decoys()

/obj/effect/anomaly/hallucination/anomalyEffect(seconds_per_tick)
	. = ..()
	ticks += seconds_per_tick
	if(ticks < release_delay)
		return
	ticks -= release_delay
	if(!isturf(loc))
		return

	for(var/mob/living/carbon/human/hallucinator in viewers(5, src))
		var/susceptibility = GetAnomalySusceptibility(hallucinator)
		if(prob(susceptibility * 100))
			hallucinator.hallucination += 10
			if(prob(20))
				to_chat(hallucinator, pick(messages))
			if(prob(10))
				to_chat(hallucinator, span_danger("Your nose bleeds!"))
				hallucinator.drip(1)

/obj/effect/anomaly/hallucination/detonate()
	if(isturf(loc))
		return

	for(var/mob/living/carbon/human/hallucinator in viewers(10, src))
		to_chat(hallucinator, pick(messages))
		hallucinator.hallucination += 25
		to_chat(hallucinator, span_danger("Your nose bleeds!"))
		hallucinator.drip(1)

/obj/effect/anomaly/hallucination/proc/generate_decoys()
	if(!spawn_decoys)
		return

	for(var/turf/floor in orange(1, src))
		if(prob(35))
			new /obj/effect/anomaly/hallucination/decoy(floor)

/obj/effect/anomaly/hallucination/decoy
	anomaly_core = null
	var/report_text

/obj/effect/anomaly/hallucination/decoy/Initialize(mapload, new_lifespan)
	. = ..()
	report_text = pick(
		"[src]'s unstable field is fluctuating along frequency 9999999.99999, code 9999999.99999. No, no, that can't be right?",
		"It doesn't detect anything. It awaits an input, as if you're pointing it towards nothing at all. What?",
		"The interface displays [pick("a bad memory from your past", "the frequency numbers in a language you cannot read", "the first 15 digits of Pi", "yourself, from behind, angled at a 3/4ths isometric perspective")]. What the hell?",
		"Nothing happens?",
		"It reports that you are a [pick("moron", "idiot", "cretin", "lowlife", "worthless denthead", "gump")]. Huh?",
		"It tells you to try again, because you're doing it all wrong. What?",
		"It occurs to you that the anomaly you're scanning isn't actually there.",
		"It's not working. You activate %TOOL% again. Still broken. You activate %TOOL%. You activate %TOOL%. Why isn't this working??",
		"Something happens. You can't tell what. The interface on %TOOL% remains blank.",
		"What are you even trying to accomplish here? Did you really think that was going to work?",
		"Someone behind you whispers the frequency code to you, but you can't quite hear them. The interface on %TOOL% remains blank.",
		"For a brief moment, you see yourself traversing a frozen forest, before snapping back to reality. The interface on %TOOL% remains blank.",
		"Nothing interesting happens. Are you sure you're actually using it on anything?",
		"For a moment you can feel your skin falling off, then blink as the sensation vanishes. What the hell did that mean?",
		"The interface reports that you are a complete failure, and have screwed everything up again. Great work.",
		"You realize that the formatting of this message is completely wrong, and get confused. Now why would that be?",
		"%TOOL% stares back at you. It looks dissapointed, its screen practically saying 'You missed the anomaly, you dolt. There's nothing there!'",
		"Nothing. Weird, maybe %TOOL% must be broken or something?",
		"You activate %TOOL%. You activate %TOOL%. You activate %TOOL%. You activate %TOOL%. You activate %TOOL%. You activate %TOOL%. You activate %TOOL%. Why isn't it working??",
	)

/obj/effect/anomaly/hallucination/decoy/anomalyEffect(seconds_per_tick)
	if(SPT_PROB(move_chance, seconds_per_tick))
		move_anomaly()

/obj/effect/anomaly/hallucination/decoy/attackby(obj/item/tool, mob/user, params)
	if(istype(tool, /obj/item/analyzer))
		to_chat(user, span_notice("You activate \the [tool]. [replacetext(report_text, "%TOOL%", "[tool]")]"))
	return ..()

/obj/effect/anomaly/hallucination/decoy/detonate()
	var/datum/effect/effect/system/spark_spread/sparks = new /datum/effect/effect/system/spark_spread
	sparks.set_up(3, 1, src)
	sparks.start()
	return

/obj/effect/anomaly/hallucination/decoy/generate_decoys()
	return

///Subtype for the SM that doesn't spawn decoys, because otherwise the whole area gets flooded with dummies.
/obj/effect/anomaly/hallucination/supermatter
	spawn_decoys = FALSE
