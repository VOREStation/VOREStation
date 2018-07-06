/*
	Spiders come in various types, and are a fairly common enemy both inside and outside the station.
	Their attacks can inject reagents, which can cause harm long after the spider is killed.
	Thick material will prevent injections, similar to other means of injections.
*/

// The base spider, in the 'walking tank' family.
/mob/living/simple_mob/animal/giant_spider
	name = "giant spider"
	desc = "Furry and brown, it makes you shudder to look at it. This one has deep red eyes."
	tt_desc = "Atrax robustus gigantus"
	icon_state = "guard"
	icon_living = "guard"
	icon_dead = "guard_dead"
	has_eye_glow = TRUE

	faction = "spiders"
	maxHealth = 200
	health = 200
	pass_flags = PASSTABLE
	movement_cooldown = 10

	see_in_dark = 10

	response_help  = "pets"
	response_disarm = "gently pushes aside"
	response_harm   = "punches"

	melee_damage_lower = 18
	melee_damage_upper = 30
	attack_sharp = 1
	attack_edge = 1
	attack_sound = 'sound/weapons/bite.ogg'

	heat_damage_per_tick = 20
	cold_damage_per_tick = 20
	minbodytemp = 175 // So they can all survive Sif without having to be classed under /sif subtype.

	speak_emote = list("chitters")

	meat_amount = 1
	meat_type = /obj/item/weapon/reagent_containers/food/snacks/xenomeat/spidermeat

	say_list_type = /datum/say_list/spider
	ai_holder_type = /datum/ai_holder/simple_mob/melee

	var/poison_type = "spidertoxin"	// The reagent that gets injected when it attacks.
	var/poison_chance = 10			// Chance for injection to occur.
	var/poison_per_bite = 5			// Amount added per injection.

/mob/living/simple_mob/animal/giant_spider/apply_melee_effects(var/atom/A)
	if(isliving(A))
		var/mob/living/L = A
		if(L.reagents)
			var/target_zone = pick(BP_TORSO,BP_TORSO,BP_TORSO,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_HEAD)
			if(L.can_inject(src, null, target_zone))
				inject_poison(L, target_zone)

// Does actual poison injection, after all checks passed.
/mob/living/simple_mob/animal/giant_spider/proc/inject_poison(mob/living/L, target_zone)
	if(prob(poison_chance))
		to_chat(L, "<span class='warning'>You feel a tiny prick.</span>")
		L.reagents.add_reagent(poison_type, poison_per_bite)

