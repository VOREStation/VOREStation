// Webslingers do what their name implies, shoot web at enemies to slow them down.

/datum/category_item/catalogue/fauna/giant_spider/webslinger_spider
	name = "Giant Spider - Webslinger"
	desc = "This specific spider has been catalogued as 'Webslinger', \
	and it belongs to the 'Nurse' caste. \
	The spider is green, with a 'cloak' of webs attached to it. It's eyes are also green. \
	<br><br>\
	Webslingers are more aggressive than some of the other spiders in their caste, spinning web to use \
	as an offensive weapon, however they still serve a 'support' role to the other spiders. \
	They sling balls of web at prey in order to slow them down, making it easier for other spiders to catch them. \
	This makes them more dangerous when paired with others, as fleeing may stop being an option once webbed. \
	<br><br>\
	Their venom is known to make bitten prey hallucinate, greatly compromising their combat ability."
	value = CATALOGUER_REWARD_MEDIUM

/mob/living/simple_mob/animal/giant_spider/webslinger
	desc = "Furry and green, it makes you shudder to look at it. This one has brilliant green eyes, and a cloak of web."
	tt_desc = "X Brachypelma phorus balisticus"
	catalogue_data = list(/datum/category_item/catalogue/fauna/giant_spider/webslinger_spider)

	icon_state = "webslinger"
	icon_living = "webslinger"
	icon_dead = "webslinger_dead"
	maxHealth = 90
	health = 90

	projectile_dispersion = 12
	projectile_accuracy = -25

	projectilesound = 'sound/weapons/thudswoosh.ogg'
	projectiletype = /obj/item/projectile/webball
	base_attack_cooldown = 10
	melee_damage_lower = 8
	melee_damage_upper = 15
	poison_per_bite = 2
	poison_type = "psilocybin"
	player_msg = "You can fire a ranged attack by clicking on an enemy or tile at a distance."
	ai_holder_type = /datum/ai_holder/simple_mob/ranged

// Check if we should bola, or just shoot the pain ball
/mob/living/simple_mob/animal/giant_spider/webslinger/should_special_attack(atom/A)
	if(ismob(A))
		if(ishuman(A))
			var/mob/living/human/H = A
			if(!H.legcuffed)
				return TRUE
	return FALSE

// Now we've got a running human in sight, time to throw the bola
/mob/living/simple_mob/animal/giant_spider/webslinger/do_special_attack(atom/A)
	set waitfor = FALSE
	set_AI_busy(TRUE)
	var/obj/item/projectile/bola/B = new /obj/item/projectile/bola(src.loc)
	playsound(src, 'sound/weapons/thudswoosh.ogg', 100, 1)
	if(!B)
		return
	B.old_style_target(A, src)
	B.fire()
	set_AI_busy(FALSE)