// Carriers are not too dangerous on their own, but they create more spiders when dying.

/mob/living/simple_mob/animal/giant_spider/carrier
	desc = "Furry, beige, and red, it makes you shudder to look at it. This one has luminous green eyes."
	icon_state = "carrier"
	icon_living = "carrier"
	icon_dead = "carrier_dead"

	maxHealth = 100
	health = 100

	melee_damage_lower = 8
	melee_damage_upper = 25

	poison_per_bite = 3
	poison_type = "chloralhydrate"

	movement_cooldown = 5

	player_msg = "Upon dying, you will release a swarm of spiderlings or young hunter spiders.<br>\
	If a spider emerges, you will be placed in control of it."

	var/spiderling_count = 0
	var/spiderling_type = /obj/effect/spider/spiderling
	var/swarmling_type = /mob/living/simple_mob/animal/giant_spider/hunter
	var/swarmling_faction = "spiders"
	var/swarmling_prob = 10 // Odds that a spiderling will be a swarmling instead.

/mob/living/simple_mob/animal/giant_spider/carrier/initialize()
	spiderling_count = rand(5, 10)
	adjust_scale(1.2)
	return ..()

/mob/living/simple_mob/animal/giant_spider/carrier/death()
	visible_message(span("warning", "\The [src]'s abdomen splits as it rolls over, spiderlings crawling from the wound.") )
	spawn(1)
		var/list/new_spiders = list()
		for(var/i = 1 to spiderling_count)
			if(prob(swarmling_prob) && src)
				var/mob/living/simple_mob/animal/giant_spider/swarmling = new swarmling_type(src.loc)
				var/swarm_health = Floor(swarmling.maxHealth * 0.4)
				var/swarm_dam_lower = Floor(melee_damage_lower * 0.4)
				var/swarm_dam_upper = Floor(melee_damage_upper * 0.4)
				swarmling.name = "spiderling"
				swarmling.maxHealth = swarm_health
				swarmling.health = swarm_health
				swarmling.melee_damage_lower = swarm_dam_lower
				swarmling.melee_damage_upper = swarm_dam_upper
				swarmling.faction = swarmling_faction
				swarmling.adjust_scale(0.75)
				new_spiders += swarmling
			else if(src)
				var/obj/effect/spider/spiderling/child = new spiderling_type(src.loc)
				child.skitter()
			else // We might've gibbed or got deleted.
				break
		// Transfer our player to their new body, if RNG provided one.
		if(new_spiders.len && client)
			var/mob/living/simple_mob/animal/giant_spider/new_body = pick(new_spiders)
			new_body.key = src.key
	return ..()

/mob/living/simple_mob/animal/giant_spider/carrier/recursive
	desc = "Furry, beige, and red, it makes you shudder to look at it. This one has luminous green eyes. \
	You have a distinctly <font face='comic sans ms'>bad</font> feeling about this."

	swarmling_type = /mob/living/simple_mob/animal/giant_spider/carrier/recursive