/mob/living/simple_mob/vore/horse/unicorn
	name = "unicorn"
	icon_state = "unicorn"
	icon_living = "unicorn"
	icon_dead = "unicorn-dead"
	icon = 'icons/mob/vore64x64.dmi'
	desc = "A bright white horse-like creature with a golden horn protruding from its forehead. It's mane and hooves is a similarly golden."
	tt_desc = "Equus unicornis"

	vore_capacity = 2
	maxHealth = 250
	health = 250
	meat_amount = 10

	old_x = -16
	old_y = 0
	default_pixel_x = -16
	pixel_x = -16
	pixel_y = 0
	mount_offset_y = 22
	say_list_type = /datum/say_list/horse/unicorn
	ai_holder_type = /datum/ai_holder/simple_mob/vore
	minbodytemp = 0
	movement_cooldown = 1

	vore_bump_chance = 75
	vore_pounce_chance = 75
	vore_pounce_maxhealth = 200
	vore_bump_emote	= "chomps down on"

	faction = FACTION_GLAMOUR

	projectiletype = /obj/item/projectile/beam/rainbow
	projectilesound = 'sound/weapons/sparkle.ogg'
	projectile_dispersion = 7
	projectile_accuracy = -20

/mob/living/simple_mob/vore/horse/unicorn/init_vore()
	if(!voremob_loaded)
		return
	if(LAZYLEN(vore_organs))
		return
	. = ..()
	var/obj/belly/B = vore_selected
	B.name = "stomach"
	B.desc = "With a final few gulps, the unicorn finishes swallowing you down into its hot, humid gut... and with a slosh, your weight makes the equine's belly hang down slightly like some sort of organic hammock. The thick, damp air is tinged with the smell of... candyfloss(?), and the surrounding flesh wastes no time in clenching and massaging down over its newfound fodder."
	B.digest_brute = 3
	B.digest_burn = 3
	B.digestchance = 40
	B.absorbchance = 1
	B.escapechance = 7
	B.escape_stun = 5

	B.emote_lists[DM_HOLD] = list(
		"The unicorn's idle trotting helps its stomach gently churn around you, slimily squelching against your figure.",
		"The equine predator takes a moment to intentionally clench its gut around you, encapsulating you in a strange, fleshy hug.",
		"Some hot, viscous slime oozes down over your form, helping slicken you up during your stay.",
		"During a moment of relative silence, you can hear the beast's soft, relaxed breathing as it casually goes about its day.",
		"The thick, humid atmosphere within the unicorn's hanging belly works in tandem with its steady, metronome-like heartbeat to soothe you.",
		"Your surroundings sway from side to side as the unicorn trots about, as if it is showing off its newest catch.")

	B.emote_lists[DM_DIGEST] = list(
		"The unicorn huffs in annoyance before clenching those wrinkled walls tight against your form, grinding away at you!",
		"As the beast trots about, you're forced to slip and slide around amidst a pool of thick digestive goop!",
		"You can barely hear the unicorn let out a pleased nicker as its stomach eagerly gurgles around its newfound meal!",
		"As the thinning air begins to make you feel dizzy, menacing bworps and grumbles fill that dark, constantly shifting organ!",
		"The constant, rhythmic kneading and massaging starts to take its toll along with the muggy heat, making you feel weaker and weaker!",
		"The unicorn happily trots around while digesting its meal, almost like it is trying to show off the hanging gut you've given it.")

/datum/say_list/horse/unicorn
	speak = list("...","?")
	emote_hear = list("makes some sort of sparkling sound","whinnies with the most beautiful sounds")
	emote_see = list("twinkles prettily", "shakes its mane", "looks so very regal")

/mob/living/simple_mob/vore/horse/unicorn/hostile
	ai_holder_type = /datum/ai_holder/simple_mob/ranged/aggressive/unicorn

/datum/ai_holder/simple_mob/ranged/aggressive/unicorn
	pointblank = FALSE
