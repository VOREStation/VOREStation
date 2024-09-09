// A blob with area of effect attacks.
/datum/blob_type/explosive_lattice
	name = "explosive lattice"
	desc = "A very unstable lattice that looks quite explosive."
	ai_desc = "aggressive"
	effect_desc = "When attacking an entity, it will cause a small explosion, hitting things near the target. It is somewhat resilient, but weaker to brute damage."
	difficulty = BLOB_DIFFICULTY_MEDIUM
	color = "#8B2500"
	complementary_color = "#00668B"
	damage_type = BURN
	damage_lower = 25
	damage_upper = 35
	armor_check = "bomb"
	armor_pen = 5 // This is so blob hits still hurt just slightly when wearing a bomb suit (100 bomb resist).
	brute_multiplier = 0.75
	burn_multiplier = 0.5
	spread_modifier = 0.4
	ai_aggressiveness = 75
	attack_message = "The lattice blasts you"
	attack_message_living = ", and your flesh burns from the blast wave"
	attack_message_synth = ", and your plating burns from the blast wave"
	attack_verb = "blasts"
	var/exploding = FALSE

/datum/blob_type/explosive_lattice/on_attack(obj/structure/blob/B, mob/living/victim, def_zone) // This doesn't use actual bombs since they're too strong and it would hurt the blob.
	if(exploding) // We're busy, don't infinite loop us.
		return

	exploding = TRUE
	for(var/mob/living/L in range(get_turf(victim), 1)) // We don't use orange(), in case there is more than one mob on the target tile.
		if(L == victim) // Already hit.
			continue
		if(L.faction == faction) // No friendly fire
			continue
		L.blob_act()

	// Visual effect.
	var/datum/effect/system/explosion/E = new/datum/effect/system/explosion/smokeless()
	var/turf/T = get_turf(victim)
	E.set_up(T)
	E.start()

	// Now for sounds.
	playsound(T, "explosion", 75, 1) // Local sound.

	for(var/mob/M in player_list) // For everyone else.
		if(M.z == T.z && get_dist(M, T) > world.view && !M.ear_deaf && !istype(M.loc,/turf/space))
			M << 'sound/effects/explosionfar.ogg'

	exploding = FALSE

/datum/blob_type/explosive_lattice/on_chunk_tick(obj/item/blobcore_chunk/B)
	var/turf/T = get_turf(B)
	if(!T)
		return

	for(var/mob/living/L in view(1, T))
		L.add_modifier(/datum/modifier/blastshield, 30 SECONDS)