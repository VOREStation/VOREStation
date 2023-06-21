/////////////////////////////////////////////////////////////////
/mob/living/simple_mob/shadekin/red
	name = "red-eyed shadekin"
	eye_state = RED_EYES
	//hostile = TRUE
	//animal = TRUE
	//stop_when_pulled = FALSE
	//destroy_surroundings = TRUE
	armor = list(
			"melee" = 30,
			"bullet" = 20,
			"laser" = 20,
			"energy" = 50,
			"bomb" = 10,
			"bio" = 100,
			"rad" = 100)

	eye_desc = "red eyes"

	vore_stomach_flavor = "You slip past pointy triangle teeth and down the slick, \
	slippery gullet of the creature. It's warm, and the air is thick. You can hear \
	its body squelch and shift around you as you settle into its stomach! Thick digestive \
	enzymes cling to you within that dark space, tingling and stinging immediately! The weight of \
	the doughy walls press in around you instantly, churning you up as you begin to digest!"

	player_msg = "You hunt for energy to fuel yourself, not minding in the least \
	if you strip it off unsuspecting prey. You're stronger than other shadekin, faster, and more capable in \
	a brawl, but you barely generate any of your own energy. You can stand in a dark spot to gather scraps \
	of energy in a pinch, but otherwise need to take it, by force if necessary."

/mob/living/simple_mob/shadekin/red
	ai_holder_type = /datum/ai_holder/simple_mob/melee

/mob/living/simple_mob/shadekin/red/white
	icon_state = "white"
/mob/living/simple_mob/shadekin/red/dark
	icon_state = "dark"
/mob/living/simple_mob/shadekin/red/brown
	icon_state = "brown"

/////////////////////////////////////////////////////////////////
/mob/living/simple_mob/shadekin/blue
	name = "blue-eyed shadekin"
	eye_state = BLUE_EYES
	health = 100
	//hostile = FALSE
	//animal = FALSE
	//stop_when_pulled = TRUE
	//specific_targets = TRUE //For finding injured people
	//destroy_surroundings = FALSE
	vore_default_mode = DM_HEAL
	vore_escape_chance = 75
	vore_standing_too = 1
	vore_pounce_chance = 100
	swallowTime = 4 SECONDS //A little longer to compensate for the above
	vore_ignores_undigestable = FALSE
	attacktext = list("shoved")
	armor = list(
			"melee" = 5,
			"bullet" = 5,
			"laser" = 5,
			"energy" = 5,
			"bomb" = 0,
			"bio" = 100,
			"rad" = 100)

	eye_desc = "blue eyes"
	shy_approach = TRUE
	stalker = TRUE
	vore_stomach_flavor = "You slip past pointy triangle teeth and down the slick, \
	slippery gullet of the creature. It's warm, and the air is thick. You can hear its body \
	squelch and shift around you as you settle into its stomach! It's oddly calm, and very dark. \
	The doughy flesh rolls across your form in gentle waves. The aches and pains across your form slowly begin to \
	diminish, your body is healing much faster than normal! You're also soon soaked in harmless slime."

	player_msg = "You've chosen to generate your own energy rather than taking \
	it from others. Most of the time, anyway. You don't have a need to steal energy from others, and gather it up \
	without doing so, albeit slowly. Dark and light are irrelevant to you, they are just different places to explore and \
	discover new things and new people."

/mob/living/simple_mob/shadekin/blue/
	ai_holder_type = /datum/ai_holder/simple_mob/passive

/mob/living/simple_mob/shadekin/blue/white
	icon_state = "white"
/mob/living/simple_mob/shadekin/blue/dark
	icon_state = "dark"
/mob/living/simple_mob/shadekin/blue/brown
	icon_state = "brown"

/////////////////////////////////////////////////////////////////
/mob/living/simple_mob/shadekin/purple
	name = "purple-eyed shadekin"
	eye_state = PURPLE_EYES
	health = 150
	//hostile = FALSE
	//animal = TRUE
	//stop_when_pulled = FALSE
	//destroy_surroundings = TRUE
	vore_default_mode = DM_HOLD
	vore_digest_chance = 25
	vore_absorb_chance = 25
	armor = list(
		"melee" = 15,
		"bullet" = 15,
		"laser" = 15,
		"energy" = 15,
		"bomb" = 15,
		"bio" = 100,
		"rad" = 100)

	eye_desc = "purple eyes"
	shy_approach = TRUE
	stalker = TRUE
	vore_stomach_flavor = "You slip past pointy triangle teeth and down the slick, slippery gullet of the creature. \
	It's warm, and the air is thick. You can hear its body squelch and shift around you as you settle into its stomach! \
	It's relatively calm inside the dark organ. Wet and almost molten for how gooey your surroundings feel. \
	You can feel the doughy walls cling to you possessively... It's almost like you could sink into them. \
	There is also an ominous gurgling from somewhere nearby..."

	player_msg = "You're familiar with generating your own energy, but occasionally \
	steal it from others when it suits you. You generate energy at a moderate pace in dark areas, and staying in well-lit \
	areas is taxing on your energy. You can harvest energy from others in a fight, but since you don't need to, you may \
	just choose to simply not fight."

/mob/living/simple_mob/shadekin/purple
	ai_holder_type = /datum/ai_holder/simple_mob/retaliate

/mob/living/simple_mob/shadekin/purple/white
	icon_state = "white"
/mob/living/simple_mob/shadekin/purple/dark
	icon_state = "dark"
/mob/living/simple_mob/shadekin/purple/brown
	icon_state = "brown"

/////////////////////////////////////////////////////////////////
/mob/living/simple_mob/shadekin/yellow
	name = "yellow-eyed shadekin"
	eye_state = YELLOW_EYES
	health = 100
	//hostile = FALSE
	//animal = TRUE
	//stop_when_pulled = FALSE
	//destroy_surroundings = TRUE
	vore_default_mode = DM_DRAIN
	vore_digest_chance = 5
	vore_ignores_undigestable = FALSE
	armor = list(
		"melee" = 5,
		"bullet" = 5,
		"laser" = 5,
		"energy" = 5,
		"bomb" = 0,
		"bio" = 100,
		"rad" = 100)

	eye_desc = "yellow eyes"
	stalker = FALSE
	check_for_observer = TRUE
	vore_stomach_flavor = "You slip past pointy triangle teeth and down the slick, slippery gullet \
	of the creature. It's warm, and the air is thick. You can hear its body squelch and shift around you \
	as you settle into its stomach! The doughy walls within cling to you heavily, churning down on you, wearing \
	you out!! There doesn't appear to be any actual danger here, harmless slime clings to you, but it's getting \
	harder and harder to move as those walls press in on you insistently!"

	player_msg = "Your kind rarely ventures into realspace. Being in any well-lit \
	area is very taxing on you, but you gain energy extremely fast in any very dark area. You're weaker than other \
	shadekin, but your fast energy generation in the dark allows you to phase shift more often."

	nom_mob = TRUE

/mob/living/simple_mob/shadekin/yellow
	ai_holder_type = /datum/ai_holder/simple_mob/melee/hit_and_run

/mob/living/simple_mob/shadekin/yellow/white
	icon_state = "white"
/mob/living/simple_mob/shadekin/yellow/dark
	icon_state = "dark"
/mob/living/simple_mob/shadekin/yellow/brown
	icon_state = "brown"

/mob/living/simple_mob/shadekin/yellow/retaliate
	ai_holder_type = /datum/ai_holder/simple_mob/retaliate

/mob/living/simple_mob/shadekin/yellow/retaliate/white
	icon_state = "white"
/mob/living/simple_mob/shadekin/yellow/retaliate/dark
	icon_state = "dark"
/mob/living/simple_mob/shadekin/yellow/retaliate/brown
	icon_state = "brown"

/////////////////////////////////////////////////////////////////
/mob/living/simple_mob/shadekin/green
	name = "green-eyed shadekin"
	eye_state = GREEN_EYES
	health = 125
	//hostile = FALSE
	//animal = TRUE
	//stop_when_pulled = FALSE
	//destroy_surroundings = TRUE
	vore_default_mode = DM_DRAIN
	vore_digest_chance = 0
	vore_ignores_undigestable = FALSE
	armor = list(
		"melee" = 5,
		"bullet" = 5,
		"laser" = 5,
		"energy" = 5,
		"bomb" = 0,
		"bio" = 100,
		"rad" = 100)

	eye_desc = "green eyes"
	stalker = TRUE
	check_for_observer = TRUE
	vore_stomach_flavor = "You slip past pointy triangle teeth and down the slick, slippery gullet \
	of the creature. It's warm, and the air is thick. You can hear its body squelch and shift around you \
	as you settle into its stomach! The doughy walls within cling to you heavily, churning down on you, wearing \
	you out!! There doesn't appear to be any actual danger here, harmless slime clings to you, but it's getting \
	harder and harder to move as those walls press in on you insistently!"

	player_msg = "Your kind rarely ventures into realspace. Being in any well-lit area is very taxing on you, but you \
	have more experience than your yellow-eyed cousins. You gain energy decently fast in any very dark area. You're weaker than other \
	shadekin, but your slight energy generation constnatly, and especially in the dark allows for a good mix of uses."

/mob/living/simple_mob/shadekin/green
	ai_holder_type = /datum/ai_holder/simple_mob/passive

/mob/living/simple_mob/shadekin/green/white
	icon_state = "white"
/mob/living/simple_mob/shadekin/green/dark
	icon_state = "dark"
/mob/living/simple_mob/shadekin/green/brown
	icon_state = "brown"

/////////////////////////////////////////////////////////////////
/mob/living/simple_mob/shadekin/orange
	name = "orange-eyed shadekin"
	eye_state = ORANGE_EYES
	health = 175
	//hostile = TRUE
	//animal = TRUE
	//stop_when_pulled = FALSE
	//destroy_surroundings = TRUE
	armor = list(
			"melee" = 20,
			"bullet" = 15,
			"laser" = 15,
			"energy" = 25,
			"bomb" = 10,
			"bio" = 100,
			"rad" = 100)

	eye_desc = "orange eyes"

	vore_stomach_flavor = "You slip past pointy triangle teeth and down the slick, \
	slippery gullet of the creature. It's warm, and the air is thick. You can hear \
	its body squelch and shift around you as you settle into its stomach! Thick digestive \
	enzymes cling to you within that dark space, tingling and stinging immediately! The weight of \
	the doughy walls press in around you instantly, churning you up as you begin to digest!"

	player_msg = "You usually hunt for energy to fuel yourself, though not as often as your red-eyed cousins. \
	You're stronger than most shadekin, faster, and more capable in a brawl, but you don't generate much of your own energy. \
	You can stand in a dark spot to gather some energy, but otherwise need to take it, by force if necessary."

/mob/living/simple_mob/shadekin/orange
	ai_holder_type = /datum/ai_holder/simple_mob/melee

/mob/living/simple_mob/shadekin/orange/white
	icon_state = "white"
/mob/living/simple_mob/shadekin/orange/dark
	icon_state = "dark"
/mob/living/simple_mob/shadekin/orange/brown
	icon_state = "brown"

/////////////////////////////////////////////////////////////////
//Fluffy specific fluffer
/mob/living/simple_mob/shadekin/blue/rivyr
	name = "Rivyr"
	desc = "She appears to be a fluffer of some sort. Deep blue eyes and curious attitude."
	icon_state = "rivyr"
	ai_holder_type = /datum/ai_holder/simple_mob/passive
	eye_desc = ""
	vore_stomach_flavor = "Blue flesh gleams in the fading light as you slip down the little mar's gullet! \
	Gooey flesh and heat surrounds your form as you're tucked away into the darkness of her stomach! Thick slimes cling \
	to you, but they seem to be harmless. The organ gently churns around you, clinging to your shape and forcing \
	you to curl up a bit. You can feel her rub at you some through the layers of flesh and fluff, while aches \
	and pains begin to fade away across your body."
	player_msg = "Mar? Mar mar. Mar mar mar. Mar. Mar mar? Mar! Mar. Marrrr."
