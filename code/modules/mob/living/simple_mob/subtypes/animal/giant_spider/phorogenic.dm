// Phorogenic spiders explode when they die.
// You really shouldn't melee them.

/datum/category_item/catalogue/fauna/giant_spider/phorogenic_spider
	name = "Giant Spider - Phorogenic"
	desc = "This specific spider has been catalogued as 'Phorogenic', \
	and it belongs to the 'Guard' caste. \
	The spider has a purple, crystalline appearance, with their eyes also purple.\
	<br><br>\
	These spiders are very dangerous, and unusual. They have obviously been influenced by the mysterious \
	material known as phoron, however it is not known if this is the result of arachnids merely being \
	exposed to naturally-occuring phoron on some alien world, being genetically altered to produce phoron by an unknown party, \
	or some other unknown cause. \
	<br><br>\
	Compared to the other types of spiders in their caste, and even to those outside, this one is the \
	peak of physical strength. It is very strong, often capable of killing its prey in one or two bites, \
	with unyielding endurance to match. It also injects trace amounts of liquid phoron into its victim, \
	which is very toxic to most organic life known. \
	<br><br>\
	Phorongenic spiders are also highly explosive, due to their infusion with phoron. \
	Should one die, it will create a large explosion. This appears to be an automatic response \
	caused from internal rupturing, as opposed to an intentional act of revenge by the spider, however \
	the result is the same, oftening ending a fight with both sides dead."
	value = CATALOGUER_REWARD_MEDIUM

/mob/living/simple_mob/animal/giant_spider/phorogenic
	desc = "Crystalline and purple, it makes you shudder to look at it. This one has haunting purple eyes."
	catalogue_data = list(/datum/category_item/catalogue/fauna/giant_spider/phorogenic_spider)

	icon_state = "phoron"
	icon_living = "phoron"
	icon_dead = "phoron_dead"

	maxHealth = 225
	health = 225
	taser_kill = FALSE //You will need more than a peashooter to kill the juggernaut.

	melee_damage_lower = 25
	melee_damage_upper = 40
	attack_armor_pen = 15

	movement_cooldown = 4

	poison_chance = 30
	poison_per_bite = 0.5
	poison_type = "phoron"

	tame_items = list(
	/obj/item/weapon/tank/phoron = 20,
	/obj/item/stack/material/phoron = 30
	)

	var/exploded = FALSE
	var/explosion_dev_range		= 1
	var/explosion_heavy_range	= 2
	var/explosion_light_range	= 4
	var/explosion_flash_range	= 6 // This doesn't do anything iirc.

	var/explosion_delay_lower	= 1 SECOND	// Lower bound for explosion delay.
	var/explosion_delay_upper	= 2 SECONDS	// Upper bound.

/mob/living/simple_mob/animal/giant_spider/phorogenic/Initialize()
	adjust_scale(1.25)
	return ..()

/mob/living/simple_mob/animal/giant_spider/phorogenic/death()
	visible_message(span("critical", "\The [src]'s body begins to rupture!"))
	var/delay = rand(explosion_delay_lower, explosion_delay_upper)
	spawn(0)
		// Flash black and red as a warning.
		for(var/i = 1 to delay)
			if(i % 2 == 0)
				color = "#000000"
			else
				color = "#FF0000"
			sleep(1)

	spawn(delay)
		// The actual boom.
		if(src && !exploded)
			visible_message(span("danger", "\The [src]'s body detonates!"))
			exploded = TRUE
			explosion(src.loc, explosion_dev_range, explosion_heavy_range, explosion_light_range, explosion_flash_range)
	return ..()
