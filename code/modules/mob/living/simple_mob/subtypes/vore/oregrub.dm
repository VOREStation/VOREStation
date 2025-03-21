/datum/category_item/catalogue/fauna/oregrub
	name = "Oregrub"
	desc = "Some form of mutated space larva, they seem to feed on minerals. This makes them the natural enemy of miners. \
	To make matters worse, these creatures will flee when threatened. More than a few foolhardy miners have met their end chasing down oregrubs after some other hostile creature attacked them. \
	Their guts tend to contain undigested minerals, so miners who are quick (and not afraid to get their hands dirty) can reap some rewards from these leathery lithovores."
	value = CATALOGUER_REWARD_EASY

/datum/category_item/catalogue/fauna/lavagrub
	name = "Lavagrub"
	desc = "Some form of mutated space larva, they seem to feed on minerals. This makes them the natural enemy of miners. \
	To make matters worse, these creatures will flee when threatened. More than a few foolhardy miners have met their end chasing down oregrubs after some other hostile creature attacked them. \
	This particular variant seems to be even tougher and faster than its common brown kin, and its hide is laced with silicates that make it more durable. \
	On the plus side, it's sure to contain even more valuable minerals within its bowels, if you can catch up with it to crack it open..."
	value = CATALOGUER_REWARD_MEDIUM

/datum/ai_holder/simple_mob/oregrub
	hostile = FALSE			//docile, unless you hit them
	retaliate = TRUE		//they *may* bite you...
	can_flee = TRUE			//but they'd rather run away
	dying_threshold = 1		//and ideally, we flee as soon as possible
	flee_when_outmatched = TRUE	//especially when outmatched
	outmatched_threshold = 25	//and we're outmatched by... basically everything!

/datum/ai_holder/simple_mob/oregrub/lava
	outmatched_threshold = 15

/mob/living/simple_mob/vore/oregrub
	name = "juvenile oregrub"
	desc = "A young, leathery oregrub."
	catalogue_data = list(/datum/category_item/catalogue/fauna/oregrub)
	icon = 'icons/mob/vore.dmi' //all of these are placeholders
	icon_state = "oregrub"
	icon_living = "oregrub"
	icon_dead = "oregrub-dead"

	faction = FACTION_GRUBS
	maxHealth = 50 //oregrubs are quite hardy
	health = 50

	melee_damage_lower = 1
	melee_damage_upper = 3	//low damage, they prefer to flee

	movement_cooldown = 3.5

	meat_type = /obj/item/ore/coal

	response_help = "pokes"
	response_disarm = "pushes"
	response_harm = "roughly pushes"

	ai_holder_type = /datum/ai_holder/simple_mob/oregrub
	say_list_type = /datum/say_list/oregrub

	var/poison_per_bite = 2.5
	var/poison_type = REAGENT_ID_THERMITEV //burn baby burn
	var/poison_chance = 50

	var/min_ore = 4
	var/max_ore = 7

	vore_bump_chance = 60
	vore_bump_emote = "applies minimal effort to try and slurp up"
	vore_active = 1
	vore_capacity = 1
	vore_pounce_chance = 50 // Might seem unforgiving, but these guys run away from enemies, making them more of an environmental hazard than a real threat. You have to bump them.
	vore_default_mode = DM_DIGEST

	min_oxy = 0
	max_oxy = 0
	min_tox = 0
	max_tox = 0
	min_co2 = 0
	max_co2 = 0
	min_n2 = 0
	max_n2 = 0
	minbodytemp = 0
	maxbodytemp = 1000
	poison_resist = 1.0

	//these things are resilient, on account of being infused with all the minerals they eat
	armor = list(
				"melee"		= 25,
				"bullet"	= 15,
				"laser"		= 15,
				"energy"	= 0,
				"bomb"		= 25,
				"bio"		= 100,
				"rad"		= 100
				)

	glow_override = TRUE

/mob/living/simple_mob/vore/oregrub/lava
	name = "mature lavagrub"
	desc = "A mature, rocky lavagrub"
	catalogue_data = list(/datum/category_item/catalogue/fauna/lavagrub)
	icon_state = "lavagrub"
	icon_living = "lavagrub"
	icon_dead = "lavagrub-dead"

	movement_cooldown = 2
	maxHealth = 75 //lavagrubs are really hardy
	health = 75
	vore_pounce_chance = 80 // Full-grown grubs should pounce. More homf opportunities if you're dumb enough to poke it.
	vore_pounce_maxhealth = 100 // They won't pounce by default, as they're passive. This is just so the nom check succeeds (and allows it to try and eat you) once you poke the damn thing. :u
	ai_holder_type = /datum/ai_holder/simple_mob/oregrub/lava
	//lavagrubs have even more armor than oregrubs
	armor = list(
				"melee"		= 50,
				"bullet"	= 25,
				"laser"		= 25,
				"energy"	= 0,
				"bomb"		= 50,
				"bio"		= 100,
				"rad"		= 100
				)

	var/lava_min_ore = 6
	var/lava_max_ore = 10

	poison_per_bite = 5
	poison_chance = 66

/datum/say_list/oregrub
	emote_see = list("burbles", "chitters", "snuffles around for fresh ore")

/mob/living/simple_mob/vore/oregrub/apply_melee_effects(var/atom/A)
	if(isliving(A))
		var/mob/living/L = A
		var/target_zone = pick(BP_TORSO,BP_TORSO,BP_TORSO,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_HEAD)
		if(L.can_inject(src, null, target_zone))
			inject_poison(L, target_zone)

/mob/living/simple_mob/vore/oregrub/death()
	visible_message(span_warning("\The [src] shudders and collapses, expelling the ores it had devoured!"))
	var/i = rand(min_ore,max_ore)
	while(i>1)
		var/ore = pick(/obj/item/ore/glass,/obj/item/ore/coal,/obj/item/ore/iron,/obj/item/ore/lead,/obj/item/ore/marble,/obj/item/ore/phoron,/obj/item/ore/silver,/obj/item/ore/gold)
		new ore(src.loc)
		i--
	..()

/mob/living/simple_mob/vore/oregrub/lava/handle_light()
	. = ..()
	if(. == 0 && !is_dead())
		set_light(2.5, 1, COLOR_ORANGE)
		return 1
	else if(is_dead())
		glow_override = FALSE

/mob/living/simple_mob/vore/oregrub/lava/death()
	set_light(0)
	var/p = rand(lava_min_ore,lava_max_ore)
	while(p>1)
		var/ore = pick(/obj/item/ore/osmium,/obj/item/ore/uranium,/obj/item/ore/hydrogen,/obj/item/ore/diamond,/obj/item/ore/verdantium)
		new ore(src.loc)
		p--
	..()

// Does actual poison injection, after all checks passed.
/mob/living/simple_mob/vore/oregrub/proc/inject_poison(mob/living/L, target_zone)
	if(prob(poison_chance))
		to_chat(L, span_warning("You feel fire running through your veins!"))
		L.reagents.add_reagent(poison_type, poison_per_bite)

/mob/living/simple_mob/vore/oregrub/init_vore()
	if(!voremob_loaded)
		return
	if(LAZYLEN(vore_organs))
		return
	. = ..()
	var/obj/belly/B = vore_selected
	B.name = "stomach"
	B.desc = "Through either grave error, overwhelming willingness, or some other factor, you find yourself lodged halfway past the grub's mandibles. While it had initially hissed and chittered in glee at the prospect of a new meal, it is clearly more versed in crunching ores to feed off of; inch by inch, bit by bit, it undulates forth to slowly, noisily gulp you down its short esophagus... and right into its extra-cramped, surprisingly hot stomach. As the rest of you spills out into the plush-walled chamber, the grub's soft body bulges outwards here and there with your compressed figure. Before long, a thick slime oozes out from the surrounding stomach walls; only time will tell how effective it is on something fleshy like you, although given it's usual diet..."
	B.vore_sound = "Tauric Swallow"
	B.release_sound = "Pred Escape"
	B.fancy_vore = 1
	B.belly_fullscreen_color = "#1b4ba3"
	B.belly_fullscreen = "VBOanim_belly1"
	B.colorization_enabled = TRUE

	// Yes, these are copied + modified from the solargrub list. These are better placeholders than ~nothing~, and will give us more voremobs to work with.
	B.emote_lists[DM_HOLD] = list(
		"The air trapped within the grub is hot, humid, and tinged with soot, but otherwise mercifully harmless to you aside from being heavy on the lungs.",
		"Your doughy, squishy surroundings heavily pulse around your body as the grub attempts to wriggle elsewhere, its solid prey weighing it down quite a bit.",
		"A mineral cracks underneath the pressure of the grub's gut, briefly illuminating the interior of the thing's gut with a reddish glow!",
		"The grub's inner muscles are in a constant state of clenching all over you, adding an extra element to your full-body massage.",
		"For a moment, the grub's stomach walls clench down even more firmly than before, working into your muscles, steadily relaxing them down.",
		"The incredible heat trapped within the grub helps daze and disorient you, ensuring that its new filling wouldn't interfere in its mineral-hunting.")

	B.emote_lists[DM_DIGEST] = list(
		"Every breath taken inside the grub is swelteringly hot, painfully thick, and more than subtly caustic, worsening with every passing moment spent inside!",
		"As the grub wriggles off somewhere quiet to digest its meal, the resulting undulations help crush you down into a more compact, easier to handle morsel!",
		"From time to time, minerals crush inwards against your body, helping ensure that the grub's food was thoroughly worked over into a softer, rougher state!",
		"The grub's inner muscles are in a constant state of clenching all over you, adding an additional layer of processing to its stomach's slow, steady churning, helping break you down faster!",
		"The grub chitters in irritation at your continued solidity, followed by a string of crushingly tight stomach clenches that grind its caustic stomach ooze into your body!",
		"The deceptively severe heat trapped within the grub works in tandem with its inner muscles and your tingling, prickling stomach juice bath to weaken you!")

/mob/living/simple_mob/vore/oregrub/lava/init_vore() // Should inherit everything from parent, and then change our belly fullscreen color.
	if(!voremob_loaded)
		return
	if(LAZYLEN(vore_organs))
		return
	.=..()
	var/obj/belly/B = vore_selected
	B.belly_fullscreen_color = "#cf741e"
