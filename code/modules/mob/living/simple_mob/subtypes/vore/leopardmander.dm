/mob/living/simple_mob/vore/leopardmander
	name = "leopardmander"
	desc = "A huge salamander-like drake. They are best known for their rarity, their voracity, their very potent paralyzing venom, and their healing stomach. This one is white."
	catalogue_data = list(/datum/category_item/catalogue/fauna/leopardmander)
	tt_desc = "S Draconis uncia"
	icon = 'icons/mob/vore128x64.dmi'
	icon_dead = "leopardmander-dead"
	icon_living = "leopardmander"
	icon_state = "leopardmander"
	faction = "neutral"
	meat_amount = 40 //I mean...
	meat_type = /obj/item/weapon/reagent_containers/food/snacks/meat
	old_x = -48
	old_y = 0
	melee_damage_lower = 10
	melee_damage_upper = 25
	friendly = list("nudges", "sniffs on", "rumbles softly at", "slobberlicks")
	default_pixel_x = -48
	pixel_x = -48
	pixel_y = 0
	vis_height = 92
	response_help = "pats"
	response_disarm = "shoves"
	response_harm = "bops"
	movement_cooldown = 2
	maxHealth = 1500
	attacktext = list("chomped")
	see_in_dark = 8
	minbodytemp = 0
	ai_holder_type = /datum/ai_holder/simple_mob/healbelly
	max_buckled_mobs = 1
	mount_offset_y = 32
	mount_offset_x = -16
	can_buckle = TRUE
	buckle_movable = TRUE
	buckle_lying = FALSE
	vore_icons = SA_ICON_LIVING
	vore_bump_chance = 50
	vore_digest_chance = 0
	vore_escape_chance = 50
	vore_pounce_chance = 100
	vore_active = 1
	vore_icons = 4
	vore_capacity = 4
	swallowTime = 100
	vore_default_mode = DM_HEAL
	vore_pounce_maxhealth = 125
	vore_bump_emote = "tries to snap up"
	max_tox = 0 // for virgo3b survivability

	nom_mob = TRUE

/datum/category_item/catalogue/fauna/leopardmander
	name = "Sivian Fauna - Va'aen Drake"
	desc = "Classification: S Draconis uncia\
	<br><br>\
	The Va'aen drake, or Sivian leopardmander, is a very large predator known for its unusual ability to heal people's wounds via saliva, or storing them in one of its multiple stomachs for extended periods of time. \
	The majority of the Va'aen drake's long life is spent in isolation, hunting saviks and shantaks in Sif's mountainous regions or roaming the vast tundras of Sif, \
	only seeking out other individuals during the summer mating season where they spend several months in courtship, usually only producing a single egg. \
	Though completely docile towards humans and other large sapients, the Va'aen drake posesses great strength and a very potent paralyzing venom; \
	a provoked Va'aen can be a danger to even the most hardy of explorers due to its surprising speed, crushing bite, and long lasting venom. \
	The Va'aen has been hunted to near extinction by poachers due to its secretions' unusual healing properties, and its beautiful hide; encountering one has become very rare."
	value = CATALOGUER_REWARD_HARD

/mob/living/simple_mob/vore/leopardmander/Login()
	. = ..()
	if(!riding_datum)
		riding_datum = new /datum/riding/simple_mob(src)
	verbs |= /mob/living/simple_mob/proc/animal_mount
	verbs |= /mob/living/proc/toggle_rider_reins
	movement_cooldown = 2

/mob/living/simple_mob/vore/leopardmander/Initialize()
	..()
	src.adjust_nutrition(src.max_nutrition)

/mob/living/simple_mob/vore/leopardmander/init_vore()
	. = ..()
	var/obj/belly/B = vore_selected
	B.name = "stomach"
	B.desc = "The leopardmander tosses its head back with you firmly clasped in its jaws, and in a few swift moments it finishes swallowing you down into its hot, dark gut. Your weight makes absolutely no impact on its form, the doughy walls giving way beneath you with unnatural softness. The thick, humid air is tinged with an oddly pleasant smell, and the surrounding flesh wastes no time in clenching and massaging down over its newfound fodder, smothering you in thick hot gutflesh~"
	B.vore_sound = "Tauric Swallow"
	B.release_sound = "Pred Escape"
	B.mode_flags = DM_FLAG_NUMBING
	B.fancy_vore = 1
	B.vore_verb = "slurp"
	B.contamination_color = "grey"
	B.contamination_flavor = "Wet"
	B.emote_lists[DM_HEAL] = list(
		"The drake's idle movement helps its stomach gently churn around you, slimily squelching against your figure.",
		"The draconic predator takes a moment to intentionally clench its gut around you, encapsulating you in a strange, fleshy hug.",
		"Some hot, viscous slime oozes down over your form, helping slicken you up, and heal your injuries during your stay.",
		"During a moment of relative silence, you can hear the beast's soft, relaxed breathing as it casually goes about its day.",
		"The thick, humid atmosphere within the drake's thick hanging belly works in tandem with its steady, metronome-like heartbeat to soothe you.",
		"Your surroundings sway from side to side as the drake wanders about, your form sinking bodily into the doughy, soft gutflesh.")

	B.emote_lists[DM_DIGEST] = list(
		"The drake growls in annoyance before clenching those wrinkled walls tight against your form, grinding away at you!",
		"As the beast wanders about, you're forced to slip and slide around amidst a pool of thick digestive goop, sinking briefly into the thick, heavy walls!",
		"You can barely hear the drake let out a pleased rumble as its stomach eagerly gurgles around its newfound meal!",
		"As the thinning air begins to make you feel dizzy, menacing bworps and grumbles fill that dark, constantly shifting organ!",
		"The constant, rhythmic kneading and massaging starts to take its toll along with the muggy heat, making you feel weaker and weaker!",
		"The drake happily wanders around while digesting its meal, almost like it is trying to show off the hanging gut you've given it. Not like it made much of a difference on his already borderline obese form anyway~")

/datum/say_list/leopardmander
	speak = list("Prurr.", "Rrrhf.", "Rrrrrll.", "Mrrrrph.")
	emote_hear = list("chuffs", "murrs", "churls", "hisses", "rrrrrls", "yawns that big ol' maw open.")
	emote_see = list("licks their chops", "stretches", "yawns", "whisker-twitches")
	say_maybe_target = list("Rrrrh?")
	say_got_target = list("Rurrr!", "ROAR!", "RAH!")

/mob/living/simple_mob/vore/leopardmander/blue
	name = "blue leopardmander"
	desc = "A huge, pale blue, salamander-like drake. They are best known for their rarity, their voracity, their very potent paralyzing, yet somehow very beneficial venom, and their healing stomach. This one seems to have had a rare genetic mutation, making its skin appear blue."
	tt_desc = "Draconis Va'aen"
	icon_dead = "leopardmander_blue-dead"
	icon_living = "leopardmander_blue"
	icon_state = "leopardmander_blue"

/mob/living/simple_mob/vore/leopardmander/exotic
	name = "glass-belly leopardmander"
	desc = "A huge salamander-like drake. They are best known for their rarity, their voracity, their very potent paralyzing venom, and their healing stomach. This one seems to have had a rare genetic mutation, making its entire underside somewhat translucent! A dazzling pink glow comes from within its soft, squishy underside."
	tt_desc = "Draconis Va'essa Lucent"
	icon_dead = "leopardmander_exotic-dead"
	icon_living = "leopardmander_exotic"
	icon_state = "leopardmander_exotic"

	glow_toggle = TRUE //Glow!
	glow_range = 2
	glow_color = "#FF006E"
	glow_intensity = 1.5

/mob/living/simple_mob/vore/leopardmander/exotic/proc/toggle_glow()
	set name = "Toggle Glow"
	set desc = "Switch between glowing and not glowing."
	set category = "Abilities"

	glow_toggle = !glow_toggle

/mob/living/simple_mob/vore/leopardmander/exotic/New()
	..()
	verbs |= /mob/living/simple_mob/vore/leopardmander/exotic/proc/toggle_glow

/mob/living/simple_mob/vore/leopardmander/exotic/init_vore()
	. = ..()
	var/obj/belly/B = vore_selected
	B.name = "stomach"
	B.desc = "The exotic leopardmander tosses its head back with you firmly clasped in its jaws, and in a few swift moments it finishes swallowing you down into its hot, brightly glowing gut. Your weight makes absolutely no impact on its form, the doughy walls giving way beneath you, with their unnatural softness. The thick, humid air is tinged with an oddly pleasant smell, and the surrounding flesh wastes no time in clenching and massaging down over its newfound fodder, smothering you in thick hot gutflesh~ You can only really sort of see outside that thick-walled gut."
	B.vore_sound = "Tauric Swallow"
	B.release_sound = "Pred Escape"
	B.mode_flags = DM_FLAG_NUMBING
	B.fancy_vore = 1
	B.vore_verb = "slurp"
	B.contamination_color = "pink"
	B.contamination_flavor = "Wet"
	B.emote_lists[DM_HEAL] = list(
		"The drake's idle movement helps its stomach gently churn around you, slimily squelching against your figure.",
		"The draconic predator takes a moment to intentionally clench its gut around you, encapsulating you in a strange, fleshy hug.",
		"Some hot, viscous slime oozes down over your form, helping slicken you up, and heal your injuries during your stay.",
		"During a moment of relative silence, you can hear the beast's soft, relaxed breathing as it casually goes about its day.",
		"The thick, humid atmosphere within the drake's thick hanging belly works in tandem with its steady, metronome-like heartbeat to soothe you.",
		"Your surroundings sway from side to side as the drake wanders about, your form sinking bodily into the doughy, soft gutflesh.")

	B.emote_lists[DM_DIGEST] = list(
		"The drake growls in annoyance before clenching those wrinkled walls tight against your form, grinding away at you!",
		"As the beast wanders about, you're forced to slip and slide around amidst a pool of thick digestive goop, sinking briefly into the thick, heavy walls!",
		"You can barely hear the drake let out a pleased rumble as its stomach eagerly gurgles around its newfound meal!",
		"As the thinning air begins to make you feel dizzy, menacing bworps and grumbles fill that dark, constantly shifting organ!",
		"The constant, rhythmic kneading and massaging starts to take its toll along with the muggy heat, making you feel weaker and weaker!",
		"The drake happily wanders around while digesting its meal, almost like it is trying to show off the hanging gut you've given it. Not like it made much of a difference on his already borderline obese form anyway~")

/obj/random/mob/leopardmander/item_to_spawn() //Random map spawner
	return pick(prob(89);/mob/living/simple_mob/vore/leopardmander,
		prob(10);/mob/living/simple_mob/vore/leopardmander/blue,
		prob(1);/mob/living/simple_mob/vore/leopardmander/exotic)
