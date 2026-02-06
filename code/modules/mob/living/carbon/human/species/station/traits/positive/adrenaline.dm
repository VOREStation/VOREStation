/datum/trait/adrenaline_rush
	name = "Adrenaline Rush"
	desc = "When you get critically damaged, you'll have an adrenaline rush before going down, giving you another chance to finish the fight, or get to safety."
	cost = 6
	special_env = TRUE
	can_take = ORGANICS
	var/last_adrenaline_rush
	category = TRAIT_TYPE_POSITIVE

/datum/trait/adrenaline_rush/handle_environment_special(var/mob/living/carbon/human/H)
	if(!(H.health<0))
		return
	if(last_adrenaline_rush && last_adrenaline_rush + (30 MINUTES) > world.time)
		return
	last_adrenaline_rush = world.time
	log_and_message_admins("[H]'s adrenaline rush trait just activated!", H)
	H.add_modifier(/datum/modifier/adrenaline, 30 SECONDS)

/datum/modifier/adrenaline
	name = "Adrenaline Rush"
	desc = "A rush of adrenaline, usually caused by near death in situations."
	on_created_text = span_danger("You suddenly feel adrenaline pumping through your veins as your body refuses to give up! You feel stronger, and faster, and the pain fades away quickly.")
	on_expired_text = span_danger("You feel your body finally give in once more as the adrenaline subsides. The pain returns in full blast, along with your strength fading once more.")

	disable_duration_percent = 0		//Immune to being disabled.
	pain_immunity = TRUE				//Immune to pain
	max_health_flat = 25				//Temporary health boost.
	incoming_damage_percent = 0.8		//Slight damage immunity
	incoming_oxy_damage_percent = 0.1	//Temporary oxyloss slowdown

	outgoing_melee_damage_percent = 2	//Muscles are in overdrive
	attack_speed_percent = 0.5			//Muscles are in overdrive
	slowdown = -11						//Muscles are in overdrive
	evasion = 20						//Increased focus
	accuracy = 25						//Increased focus
	accuracy_dispersion = -25			//Increased focus
	pulse_modifier = 2					//Heart is in overdrive
	bleeding_rate_percent = 1.25		//Bleed more with higher blood pressure.
	metabolism_percent = 2.5			//Metabolism in overdrive

	var/original_length
	var/list/original_values

/datum/modifier/adrenaline/on_applied()
	original_length = expire_at - world.time
	original_values = list("stun" = holder.halloss*1.5, "weaken" = holder.weakened*1.5, "paralyze" = holder.paralysis*1.5, "stutter" = holder.stuttering*1.5, "eye_blur" = holder.eye_blurry*1.5, "drowsy" = holder.drowsyness*1.5, "agony" = holder.halloss*1.5, "confuse" = holder.confused*1.5)

/datum/modifier/adrenaline/tick()
	holder.halloss = 0
	holder.weakened = 0
	holder.paralysis = 0
	holder.stuttering = 0
	holder.eye_blurry = 0
	holder.drowsyness = 0
	holder.halloss = 0
	holder.confused = 0
	holder.stunned = 0

/datum/modifier/adrenaline/on_expire()	//Your time is up, time to suffer the consequences.
	holder.apply_effects(original_values["stun"] + 30,original_values["weaken"] + 20,original_values["paralyze"] + 15,0,original_values["stutter"] + 40,original_values["eye_blur"] + 20,original_values["drowsy"] + 75,original_values["agony"])
	holder.Confuse(original_values["confused"])
	holder.add_modifier(/datum/modifier/adrenaline_recovery,original_length*17.5)

/datum/modifier/adrenaline_recovery
	name = "Adrenaline detox"
	desc = "After an adrenaline rush, one will find themselves suffering from adrenaline detox, which is their body recovering from an intense adrenaline rush."
	on_created_text = span_danger("Your body aches and groans, forcing you into a period of rest as it recovers from the intense adrenaline rush.")
	on_expired_text = span_notice("You finally recover from your adrenaline rush, your body returning to its normal state.")

	disable_duration_percent = 1.35
	outgoing_melee_damage_percent = 0.75
	attack_speed_percent = 2
	slowdown = 2
	evasion = -20
	bleeding_rate_percent = 0.8
	pulse_modifier = 0.5
	metabolism_percent = 0.5
	accuracy = -25
	accuracy_dispersion = 25
	incoming_hal_damage_percent = 1.75
	incoming_oxy_damage_percent = 1.25
