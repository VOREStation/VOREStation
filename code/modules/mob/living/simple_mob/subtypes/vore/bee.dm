/mob/living/simple_mob/vore/bee
	name = "space bumble bee"
	desc = "Buzz buzz."

	icon_state = "bee"
	icon_living = "bee"
	icon_dead = "bee-dead"
	icon = 'icons/mob/vore.dmi'

	response_help = "pets"
	response_disarm = "gently pushes aside"
	response_harm = "hits"

	movement_cooldown = 5
//	speed = 5
	maxHealth = 25
	health = 25

	harm_intent_damage = 4
	melee_damage_lower = 2
	melee_damage_upper = 4
	attacktext = list("stung")

	say_list_type = /datum/say_list/bee
	ai_holder_type = /datum/ai_holder/simple_mob/retaliate

	meat_amount = 5
	meat_type = /obj/item/weapon/reagent_containers/food/snacks/xenomeat/spidermeat

	//Space bees aren't affected by atmos.
	min_oxy = 0
	max_oxy = 0
	min_tox = 0
	max_tox = 0
	min_co2 = 0
	max_co2 = 0
	min_n2 = 0
	max_n2 = 0
	minbodytemp = 0

	faction = "bee"

	var/poison_type = "spidertoxin"	// The reagent that gets injected when it attacks, can be changed to different toxin.
	var/poison_chance = 10			// Chance for injection to occur.
	var/poison_per_bite = 1			// Amount added per injection.

/mob/living/simple_mob/vore/bee/Process_Spacemove(var/check_drift = 0)
	return 1	//No drifting in space for space bee!

// Activate Noms!
/mob/living/simple_mob/vore/bee
	vore_active = 1
	vore_icons = SA_ICON_LIVING
	vore_default_contamination_flavor = "Slimy"
	vore_default_contamination_color = "yellow"

/mob/living/simple_mob/vore/bee/init_vore()
	. = ..()
	var/obj/belly/B = vore_selected
	B.name = "Honey pouch"
	B.desc = "You have been swallowed down by a ravenous bee, the hungry insect pressing you into a tight ball and leaving you surrounded by rippling flesh. It clings fast to your form, slathering you in a sticky substance that strangely smells sweet...It seems these bees have truely adapted to space without flowers, from the feel and smell they can turn creatures into honey, which includes you!"
	B.mode_flags = DM_FLAG_THICKBELLY | DM_FLAG_NUMBING | DM_FLAG_LEAVEREMAINS | DM_FLAG_AFFECTWORN
	B.vore_sound = "Tauric Swallow"
	B.release_sound = "Pred Escape"
	B.fancy_vore = 1
	B.digest_brute = 1
	B.digest_burn = 1
	B.digestchance = 20
	B.absorbchance = 5
	B.escapechance = 15
	B.belly_fullscreen = "bubbly"

/mob/living/simple_mob/vore/bee/apply_melee_effects(var/atom/A)
	if(isliving(A))
		var/mob/living/L = A
		if(L.reagents)
			var/target_zone = pick(BP_TORSO,BP_TORSO,BP_TORSO,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_HEAD)
			if(L.can_inject(src, null, target_zone))
				inject_poison(L, target_zone)

// Does actual poison injection, after all checks passed.
/mob/living/simple_mob/vore/bee/proc/inject_poison(mob/living/L, target_zone)
	if(prob(poison_chance))
		to_chat(L, "<span class='warning'>You feel a tiny prick.</span>")
		L.reagents.add_reagent(poison_type, poison_per_bite)

/datum/say_list/bee
	speak = list("Buzzzz")
