// A blob that irradiates everything.
/datum/blob_type/radioactive_ooze
	name = "radioactive ooze"
	desc = "A goopy mess that glows with an unhealthy aura."
	ai_desc = "radical"
	effect_desc = "Irradiates the surrounding area, and inflicts toxic attacks. Weak to brute damage."
	difficulty = BLOB_DIFFICULTY_MEDIUM
	color = "#33CC33"
	complementary_color = "#99FF66"
	damage_type = TOX
	damage_lower = 20
	damage_upper = 30
	armor_check = "rad"
	brute_multiplier = 0.75
	burn_multiplier = 0.2
	spread_modifier = 0.8
	ai_aggressiveness = 50
	attack_message = "The ooze splashes you"
	attack_message_living = ", and you feel warm"
	attack_message_synth = ", and your internal systems are bombarded by ionizing radiation"
	attack_verb = "splashes"

/datum/blob_type/radioactive_ooze/on_pulse(var/obj/structure/blob/B)
	SSradiation.radiate(B, 200)

/datum/blob_type/radioactive_ooze/on_chunk_tick(obj/item/blobcore_chunk/B)
	SSradiation.radiate(B, rand(25,100))
