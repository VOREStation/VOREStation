
/datum/category_item/catalogue/technology/drone/infectionbot
	name = "Drone - Injection Drone"
	desc = "A strange and aged drone, this model appears to be made for gathering of genetic samples,\
	sacrificing both power and durability for storage space and advanced scanners.\
	The drone has clear dents and scratches all over it's casing bulging inwards in multiple areas,\
	some even penetrated showing the advanced and headache inducing parts inside.\
	<br><br>\
	This model in particular has a collection of hostile and spinetingeling parts on the underside,\
	small advanced anti-gravity generators located between giant syringes made for injecting and extracting all manners of fluids\
	and samples of soil or other biological matter.\
	Most interesting is the syringe it uses after taking a sample of any creature, the dry, flakey substance\
	it injects is rotten and expired toxins, seemingly once intended to heal damage from samples taken.\
	The container housing the substance as well as the fabricator showing great blunt trauma as well as environmental damage,\
	neither part salvageable but still operational, outputting near 0% efficiency making it near impossible to refill the housing unit this century.\
	<br><br>\
	The drone's frame extremily light weight but robust, unbendable by hand, is barren of any markings or ID,\
	no traces of paint visible and any 'writing' visible is uncomprehendable, short term scan unable to translate."
	value = CATALOGUER_REWARD_MEDIUM

/mob/living/simple_mob/mechanical/infectionbot
	name = "Strange robot"
	desc = "You get the feeling you should run."
	icon = 'icons/mob/vore.dmi'
	icon_state = "vagrant"
	icon_living = "vagrant"
	icon_dead = "vagrant"
	icon_gib = "vagrant"

	maxHealth = 65
	health = 40
	movement_cooldown = 1

	response_help = "pets the"
	response_disarm = "gently pushes aside the"
	response_harm = "hits the"
	faction = FACTION_VAGRANT
	harm_intent_damage = 3
	melee_damage_lower = 6
	melee_damage_upper = 9
	light_color = "#8a0707"
	attacktext = "drugged"
	attack_sound = 'sound/weapons/bite.ogg'

	ai_holder_type = /datum/ai_holder/simple_mob/melee
	say_list_type = /datum/say_list/disbot

	var/poison_chance = 100
	var/poison_per_bite = 10
	var/poison_type = REAGENT_ID_EXPIREDMEDICINE

/datum/say_list/disbot
	speak = list("ATTEMPTING TO CONTACT A.R.K, ATTEMPT 1e26+3","DIRT SAMPLE COLLECTED, DIRT QUOTA 124871/155 CONFIRMED.")
	emote_see = list("scans the dirt around it","beeps as it scans a rock nearby")
	say_maybe_target = list("BIOLOGICAL TRACES FOUND, ATTEMTPTING TO LOCATE SOURCE.","TRACE SOURCES FOUND, POWERING SCANNERS.",)
	say_got_target = list("LIFEFORM LOCATED, ATTEMPTING TO COLLECT SAMPLE","CREATURE SPOTTED, PHEROMONE GENERATORS DAMAGED, ATTEMPTING TO COLLECT GENETIC SAMPLE.")

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
		to_chat(L, span_warning("You feel a tiny prick."))
		L.reagents.add_reagent(poison_type, poison_per_bite)
