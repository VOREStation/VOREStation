/mob/living/simple_mob/vore/leopardmander
	name = "leopardmander"
	desc = "A huge salamander-like drake. They are best known for their rarity, their voracity, their very potent paralyzing venom, and their healing stomach. This one is white."
	catalogue_data = list(/datum/category_item/catalogue/fauna/leopardmander)
	tt_desc = "S Draconis uncia"
	icon = 'icons/mob/vore128x64.dmi'
	icon_dead = "leopardmander-dead"
	icon_living = "leopardmander"
	icon_state = "leopardmander"
	icon_rest = "leopardmander-rest"
	faction = FACTION_NEUTRAL
	meat_amount = 40 //I mean...
	meat_type = /obj/item/reagent_containers/food/snacks/meat
	old_x = -48
	old_y = 0
	vis_height = 92
	melee_damage_lower = 10
	melee_damage_upper = 25
	friendly = list("nudges", "sniffs on", "rumbles softly at", "slobberlicks")
	default_pixel_x = -48
	pixel_x = -48
	pixel_y = 0
	response_help = "pats"
	response_disarm = "shoves"
	response_harm = "bops"
	movement_cooldown = -1 // 2 on Downstream
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
	vore_bump_chance = 50
	vore_pounce_chance = 100
	vore_active = 1
	vore_icons = SA_ICON_LIVING|SA_ICON_REST
	vore_capacity = 4
	swallowTime = 100
	vore_default_mode = DM_HEAL
	vore_pounce_maxhealth = 125
	vore_bump_emote = "tries to snap up"
	max_tox = 0 // for virgo3b survivability

	nom_mob = TRUE

	can_be_drop_prey = FALSE
	species_sounds = "Canine" // Argue about whether it should have canine or feline later
	pain_emote_1p = list("yelp", "whine", "bark", "growl")
	pain_emote_3p = list("yelps", "whines", "barks", "growls")

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
	add_verb(src,/mob/living/simple_mob/proc/animal_mount)
	add_verb(src,/mob/living/proc/toggle_rider_reins)
	movement_cooldown = -1 // 2 on Downstream
	plane_holder.set_vis(VIS_CH_HEALTH_VR, 1)
	plane_holder.set_vis(VIS_CH_ID, 1)
	plane_holder.set_vis(VIS_CH_STATUS_R, 1)
	plane_holder.set_vis(VIS_CH_BACKUP, 1)

/mob/living/simple_mob/vore/leopardmander/Initialize(mapload)
	. = ..()
	src.adjust_nutrition(src.max_nutrition)

/mob/living/simple_mob/vore/leopardmander/load_default_bellies()
	var/obj/belly/B = new /obj/belly(src)
	B.affects_vore_sprites = TRUE
	B.belly_sprite_to_affect = "stomach"
	B.name = "stomach"
	B.desc = "The leopardmander tosses its head back with you firmly clasped in its jaws, and in a few swift moments it finishes swallowing you down into its hot, dark gut. Your weight makes absolutely no impact on its form, the doughy walls giving way beneath you with unnatural softness. The thick, humid air is tinged with an oddly pleasant smell, and the surrounding flesh wastes no time in clenching and massaging down over its newfound fodder, smothering you in thick hot gutflesh~"
	B.vore_sound = "Tauric Swallow"
	B.release_sound = "Pred Escape"
	B.mode_flags = DM_FLAG_NUMBING | DM_FLAG_THICKBELLY | DM_FLAG_TURBOMODE
	B.fancy_vore = 1
	B.vore_verb = "slurp"
	B.contamination_color = "grey"
	B.contamination_flavor = "Wet"
	B.belly_fullscreen_color = "#c47cb4"
	B.belly_fullscreen = "VBOanim_belly1"
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

	B = new /obj/belly(src)

	vore_selected = B
	B.name = "maw"
	B.desc = "Slrrrrrp... You get snatched up by the Exotic Leopardmander's large tongue, resulting in you getting dragged into the humid, dank interior of the large drake's cavernous mouth!"
	//Not going to change the default sounds. Personally I think the non-fancy sounds work good as enterance nom sounds and the fancy ones are better for transfer sounds. -Reo
	B.digest_mode = DM_HEAL
	B.vore_verb = "slurp"
	B.release_verb = "plehs"
	B.contaminates = FALSE
	B.belly_fullscreen_color = "#c47cb4"
	B.belly_fullscreen_color2 = "#C2B4B4"
	B.belly_fullscreen_color3 = "#FFCCFF"
	B.belly_fullscreen = "VBO_maw20"
	B.emote_time = 1 //Short emote time, since they wont spend long here!
	B.emote_lists[DM_HOLD] = list(
		"The drake's thick tongue presses against your form, smothering you with thick, gooey saliva as it pushes you around in it's maw.",
		"The exotic drake lets out a deep rumble as it idly maws over you, shifting you in a warm, slimy embrace as it passively prepares to send you into a deeper embrace."
	)
	B.autotransfer_enabled = TRUE
	B.autotransferchance = 30
	B.autotransferwait = 5
	B.autotransferlocation = "stomach"
	B.escapetime = 1 SECONDS
	B.escapechance = 75

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
	icon_rest = "leopardmander_blue-rest"

/mob/living/simple_mob/vore/leopardmander/exotic
	name = "glass-belly leopardmander"
	desc = "A huge salamander-like drake. They are best known for their rarity, their voracity, their very potent paralyzing venom, and their healing stomach. This one seems to have had a rare genetic mutation, making its entire underside somewhat translucent! A dazzling pink glow comes from within its soft, squishy underside."
	tt_desc = "Draconis Va'essa Lucent"
	icon_dead = "leopardmander_exotic-dead"
	icon_living = "leopardmander_exotic"
	icon_state = "leopardmander_exotic"
	icon_rest = "leopardmander_exotic-rest"

	glow_toggle = TRUE //Glow!
	glow_range = 2
	glow_color = "#FF006E"
	glow_intensity = 1.5

/mob/living/simple_mob/vore/leopardmander/exotic/proc/toggle_glow()
	set name = "Toggle Glow"
	set desc = "Switch between glowing and not glowing."
	set category = "Abilities.Leopardmander"

	glow_toggle = !glow_toggle

/mob/living/simple_mob/vore/leopardmander/exotic/Initialize(mapload)
	. = ..()
	add_verb(src,/mob/living/simple_mob/vore/leopardmander/exotic/proc/toggle_glow)

/mob/living/simple_mob/vore/leopardmander/exotic/load_default_bellies()
	var/obj/belly/B = new /obj/belly(src)
	B.name = "stomach"
	B.desc = "The exotic leopardmander tosses its head back with you firmly clasped in its jaws, and in a few swift moments it finishes swallowing you down into its hot, brightly glowing gut. Your weight makes absolutely no impact on its form, the doughy walls giving way beneath you, with their unnatural softness. The thick, humid air is tinged with an oddly pleasant smell, and the surrounding flesh wastes no time in clenching and massaging down over its newfound fodder, smothering you in thick hot gutflesh~ You can only really sort of see outside that thick-walled gut."
	B.vore_sound = "Tauric Swallow"
	B.release_sound = "Pred Escape"
	B.mode_flags = DM_FLAG_NUMBING | DM_FLAG_THICKBELLY | DM_FLAG_TURBOMODE
	B.fancy_vore = 1
	B.vore_verb = "slurp"
	B.contamination_color = "pink"
	B.contamination_flavor = "Wet"
	B.belly_fullscreen_color = "#df3dbc"
	B.belly_fullscreen_alpha = 240
	B.belly_fullscreen = "VBOanim_belly1"
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
	B.transferchance = 50
	B.transferlocation = "maw"

	B = new /obj/belly(src)
	vore_selected = B

	B.name = "maw"
	B.desc = "Slrrrrrp... You get snatched up by the Exotic Leopardmander's large tongue, resulting in you getting dragged into the humid, dank interior of the large drake's cavernous mouth!"
	//Not going to change the default sounds. Personally I think the non-fancy sounds work good as enterance nom sounds and the fancy ones are better for transfer sounds. -Reo
	B.vore_verb = "slurp"
	B.release_verb = "plehs"
	B.contaminates = FALSE
	B.belly_fullscreen_color = "#c47cb4"
	B.belly_fullscreen_color2 = "#C2B4B4"
	B.belly_fullscreen_color3 = "#8D60CE"
	B.belly_fullscreen_color4 = "#B593F9"
	B.belly_fullscreen = "VBO_maw20"
	B.emote_time = 1 //Short emote time, since they wont spend long here!
	B.emote_lists[DM_HOLD] = list(
		"The drake's thick tongue presses against your form, smothering you with thick, gooey saliva as it pushes you around in it's maw.",
		"The exotic drake lets out a deep rumble as it idly maws over you, shifting you in a warm, slimy embrace as it passively prepares to send you into a deeper embrace."
	)
	B.autotransferwait = 5
	B.autotransferlocation = "stomach"
	B.escapetime = 1 SECONDS
	B.escapechance = 75

/obj/random/mob/leopardmander/item_to_spawn() //Random map spawner
	return pick(prob(89);/mob/living/simple_mob/vore/leopardmander,
		prob(10);/mob/living/simple_mob/vore/leopardmander/blue,
		prob(1);/mob/living/simple_mob/vore/leopardmander/exotic)
