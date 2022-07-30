/mob/living/simple_mob/animal/space/bats
	name = "space bat swarm"
	desc = "A swarm of cute little blood sucking bats that looks pretty upset."
	tt_desc = "N Bestia gregaria" //Nispean swarm bats, because of course Nisp has swarm bats
	icon = 'icons/mob/bats.dmi'
	icon_state = "bat"
	icon_living = "bat"
	icon_dead = "bat_dead"
	icon_gib = "bat_dead"

	faction = "scarybat"

	maxHealth = 20
	health = 20

	attacktext = list("bitten")
	attack_sound = 'sound/weapons/bite.ogg'

	response_help = "pets the"
	response_disarm = "gently pushes aside the"
	response_harm = "hits the"

	organ_names = /decl/mob_organ_names/smallflying

	harm_intent_damage = 10

	melee_damage_lower = 5
	melee_damage_upper = 5
	attack_sharp = TRUE

	ai_holder_type = /datum/ai_holder/simple_mob/melee/evasive

	has_langs = list("Mouse")

	meat_type = /obj/item/reagent_containers/food/snacks/meat
	meat_amount = 2

	say_list_type = /datum/say_list/mouse	// Close enough

	var/scare_chance = 15

/mob/living/simple_mob/animal/space/bats/apply_melee_effects(var/atom/A)
	if(isliving(A))
		var/mob/living/L = A
		if(prob(scare_chance))
			L.Stun(1)
			L.visible_message("<span class='danger'>\The [src] scares \the [L]!</span>")

// Spookiest of bats
/mob/living/simple_mob/animal/space/bats/cult
	faction = "cult"
	supernatural = TRUE

/mob/living/simple_mob/animal/space/bats/cult/cultify()
	return

/mob/living/simple_mob/animal/space/bats/cult/strong
	maxHealth = 60
	health = 60
	melee_damage_upper = 10
