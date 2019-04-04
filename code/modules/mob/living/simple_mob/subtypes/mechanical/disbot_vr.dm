/mob/living/simple_mob/mechanical/infectionbot
	name = "Strange robot"
	desc = "You get the feeling you should run."
	icon = 'icons/mob/vagrant_vr.dmi'
	icon_state = "vagrant"
	icon_living = "vagrant"
	icon_dead = "vagrant"
	icon_gib = "vagrant"

	maxHealth = 65
	health = 40
	movement_cooldown = 4

	response_help = "pets the"
	response_disarm = "gently pushes aside the"
	response_harm = "hits the"
	faction = "vagrant"
	harm_intent_damage = 3
	melee_damage_lower = 6
	melee_damage_upper = 9
	light_color = "#8a0707"
	attacktext = "mauled"
	attack_sound = 'sound/weapons/bite.ogg'

	ai_holder_type = /datum/ai_holder/simple_mob/melee
	say_list_type = /datum/say_list/disbot

	var/poison_chance = 100
	var/poison_per_bite = 5
	var/poison_type = "zombiepowder"

/datum/say_list/disbot
	speak = list("ATTEMPTING TO CONTACT A.R.K, ATTEMPT 1e26+3","DIRT SAMPLE COLLECTED, DIRT QUOTA 124871/155 CONFIRMED.")
	emote_see = list("Scans the dirt around it","Beeps as it scans a rock nearby")
	say_maybe_target = list("BIOLOGICAL TRACES FOUND, ATTEMTPTING TO LOCATE SOURCE.","TRACE SOURCES FOUND, POWERING SCANNERS.",)
	say_got_target = list("LIFEFORM LOCATED, ATTEMPTING TO COLLECT SAMPLE","CREATURE SPOTTED, PHERMONE GENERATORS DAMAGED, ATTEMPTING TO COLLECT GENETIC SAMPLE.")

/mob/living/simple_mob/mechanical/infectionbot/apply_melee_effects(var/atom/A)
	if(isliving(A))
		var/mob/living/L = A
		if(L.reagents)
			var/target_zone = pick(BP_TORSO,BP_TORSO,BP_TORSO,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_HEAD)
			if(L.can_inject(src, null, target_zone))
				inject_poison(L, target_zone)

// Does actual poison injection, after all checks passed.
/mob/living/simple_mob/mechanical/infectionbot/proc/inject_poison(mob/living/L, target_zone)
	if(prob(poison_chance))
		to_chat(L, "<span class='warning'>You feel a tiny prick.</span>")
		L.reagents.add_reagent(poison_type, poison_per_bite)
