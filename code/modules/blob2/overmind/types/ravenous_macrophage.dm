// A blob that produces noxious smoke-clouds and recycles its dying parts.
/datum/blob_type/ravenous_macrophage
	name = "ravenous macrophage"
	desc = "A disgusting gel that reeks of death."
	ai_desc = "resourceful"
	effect_desc = "Produces noxious fumes, and melts prey with acidic attacks. Weak to brute damage."
	difficulty = BLOB_DIFFICULTY_MEDIUM
	color = "#639b3f"
	complementary_color = "#d1ec3c"
	damage_type = BIOACID
	damage_lower = 20
	damage_upper = 30
	armor_check = "bio"
	armor_pen = 50
	brute_multiplier = 0.8
	burn_multiplier = 0.3
	spread_modifier = 0.8
	ai_aggressiveness = 70
	attack_message = "The macrophage splashes you"
	attack_message_living = ", and you feel a horrible burning"
	attack_message_synth = ", and your body begins to corrode"
	attack_verb = "splashes"

/datum/blob_type/ravenous_macrophage/on_pulse(var/obj/structure/blob/B)
	var/mob/living/L = locate() in range(world.view, B)
	if(L && prob(1) && L.mind && !L.stat)	// There's some active living thing nearby, produce offgas.
		var/turf/T = get_turf(B)
		var/datum/effect/effect/system/smoke_spread/noxious/BS = new /datum/effect/effect/system/smoke_spread/noxious
		BS.attach(T)
		BS.set_up(3, 0, T)
		playsound(T, 'sound/effects/smoke.ogg', 50, 1, -3)
		BS.start()

/datum/blob_type/ravenous_macrophage/on_death(obj/structure/blob/B)
	var/obj/structure/blob/other = locate() in oview(2, B)
	if(other)
		B.visible_message("<span class='danger'>The dying mass is rapidly consumed by the nearby [other]!</span>")
		if(other.overmind)
			other.overmind.add_points(rand(1,4))

/datum/blob_type/ravenous_macrophage/on_chunk_tick(obj/item/blobcore_chunk/B)
	var/mob/living/L = locate() in range(world.view, B)
	if(prob(5) && !L.stat)	// There's some active living thing nearby, produce offgas.
		B.visible_message("<span class='alien'>[icon2html(B,viewers(B))] \The [B] disgorches a cloud of noxious gas!</span>")
		var/turf/T = get_turf(B)
		var/datum/effect/effect/system/smoke_spread/noxious/BS = new /datum/effect/effect/system/smoke_spread/noxious
		BS.attach(T)
		BS.set_up(3, 0, T)
		playsound(T, 'sound/effects/smoke.ogg', 50, 1, -3)
		BS.start()
