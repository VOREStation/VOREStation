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
	vore_active = TRUE
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
	vore_active = TRUE

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
	vore_active = TRUE

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
	vore_active = TRUE

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
	vore_active = TRUE

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
	vore_active = TRUE

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

//Special event mob. "Hunger." - Rakshasa
/mob/living/simple_mob/shadekin/red/rakshasa
	name ="Rakshasa"
	desc = "A scary, black shadekin? Their body oozes like goop."
	icon_state = "rakshasa"
	vore_stomach_flavor = "You're floating in a warm, viscous goop, too dark to see. \
	Your efforts to find light have failed. Darkness consumes you. \
	Rakshasa's gelatenous body squeezes over your form, leaving no inch unmolested. \
	The hot goop you float in makes it hard to breathe; all consuming of space and light.  \
	Your body feels hot, growing weaker, more tired. Draining. Darkness coming. \
	You struggle to stay awake while floating helplessly in the goo."
	player_msg = "You are Rakshasa. You are not to directly harm crew, only consume. You never speak a language. You have special emotes: 'evillaugh', 'evilno', 'evilbreath', 'evilbreath2', and 'goodripsound'"
	maxHealth = 1000000000000
	health = 1000000000000
	eye_state = "BLUE EYES"
	eye_icon_state = "e_rakshasa"
	comp = /datum/component/shadekin/full/rakshasa

/mob/living/simple_mob/shadekin/red/rakshasa/Initialize(mapload)
	. = ..()
	if(comp)
		comp.dark_energy_infinite = TRUE

/mob/living/simple_mob/shadekin/red/rakshasa/get_available_emotes()
	. = GLOB.simple_mob_default_emotes.Copy()
	. += /decl/emote/audible/evil_laugh
	. += /decl/emote/audible/evil_no
	. += /decl/emote/audible/evil_breathing
	. += /decl/emote/audible/evil_breathing_2
	. += /decl/emote/audible/goodripsound

/mob/living/simple_mob/shadekin/blue/luna
	name = "Luna"
	desc = "She appears to be a fuzzy critter of some sort. Her eyes shimmer a dark blue, glancing around curiously."
	icon_state = "luna"
	eye_desc = "blue eyes"
	vore_stomach_flavor = "Dark blue flesh fills your vision as you slip past the Shadekin's tongue and into the darkness \
	of her gullet. The flesh around you seems squishy and pliable and malleable to say the least, warmth rolling up \
	your body as the humid air rises across the deeper you slide into the darkness of her stomach. As you splash \
	inside, you curl up comfortably inside the walls that churn and squeeze around you, any fidgeting quickly \
	subdued by the strength of the walls, and any movement of your predator seems to coax a light sway from \
	your current prison. The slime inside stuck fairly well, though harmless - your aches and pains slowly soothing \
	up and fading away."
	player_msg = "You are a shadekin that goes by the name of Luna. Curious, you have tasked yourself and yourself alone \
	with studying this foreign world. Learn their language. Learn their culture. Adapt. Everything is wonderful and new, \
	and your mind is set on retaining knowledge of these odd planescape."

//"All your chickens are belong to me!" - Zylas
/mob/living/simple_mob/shadekin/purple/zylas
	name ="Zylas"
	desc = "He's a chubby looking creature, black and grey fur accompanied by purple eyes and a large hoody."
	icon_state = "zylashoody"
	eye_desc = "purple eyes"
	vore_stomach_flavor = "You are trapped in a cramped tight space. The color purple seems to dominate your vision. \
	His walls rolled over your form as you lay trapped in his depths. There wasnt a drop of fluid in sight inside that	\
	stomach. Instead, you could feel your energy slowly draining away over time, like... he was leeching off you."
	player_msg = "You are Zylas. You enjoy scaring the local population and eating every chicken you find."

//"Two scarves. No more, No Less." -Muninn
/mob/living/simple_mob/shadekin/blue/muninn
	name ="Muninn"
	desc = "A gray furred shadekin, a little on the hefty side. Rocks two scarves, one on the neck, one on the tail. \
	He seems eager to take in the various sights and sounds of the station"
	icon_state = "muninn"
	eye_desc = "blue eyes"
	vore_stomach_flavor = "You're stuck in a warm, tight stomach. \
	A blue glow, as soft as the walls surrounding you, illuminates the cramped chamber. \
	Muninn's walls gently squeeze over your form, like a tight, yet comfortable hug. \
	The gut itself was relatively dry, only slightly damp. \
	As Muninn ambles along, you'd gently sway within. It's quite the nice place to stay for a while."
	player_msg = "You are Muninn. Today you feel... Curious."

//"Here's a little lesson in the trickeries" -Muninn
/mob/living/simple_mob/shadekin/purple/muninn
	name ="Muninn"
	desc = "A gray furred shadekin, a little on the hefty side. Rocks two scarves, one on the neck, one on the tail.\
	He seems a little mischevious... better keep an eye on him."
	icon_state = "muninn"
	eye_desc = "purple eyes"
	vore_stomach_flavor = "You're stuck in a warm, tight stomach. \
	A purple glow, as soft as the walls surrounding you, illuminates the cramped chamber. \
	Muninn's walls gently squeeze over your form, like a tight hug. \
	The gut itself was relatively dry, only slightly damp.  \
	It didn't seem that Muninn was digesting you. More like... sapping your energy and making you feel tired. \
	A nap in this comfortable chamber wouldn't be the worst thing, would it?"
	player_msg = "You are Muninn. Today you feel... Mischevious."

//Whealty's shadekin anno!
/mob/living/simple_mob/shadekin/purple/anno
	name ="Anno"
	desc = "A white furred shadekin with a chubby form. His ears seem to be close to even in length and his snout seems longer than the usual.\
	He seems energetic and playful."
	icon_state = "anno"
	eye_desc = "purple eyes"
	vore_stomach_flavor = "You're stuck in a warm, tight stomach. \
	A purple glow, as soft as the walls surrounding you, illuminates the cramped chamber. \
	Anno's stomach walls squeeze and hug over your form somewhat tightly. \
	The gut itself was wetish and slightly slick.  \
	The gut seemed somewhat inviting with the warmth and softness, yet there was an ominous feeling to it with all the noises it made.\
	You'll probably be safe in here. Probably."
	player_msg = "You are Anno, you are energetic and playful"

/mob/living/simple_mob/shadekin/blue/roti
	name ="Roti"
	desc = "Roti is a shadekin with blue eyes, is chubby since he has eaten others before hand. He enjoys chocolate, the taste of it, the smell of it, he just wants anything sweet and chocolately to be in his belly. So be careful around him this is also a way to summon him by laying around chocolate and calling him out."
	icon_state = "roti"
	eye_desc = "blue eyes"
	vore_stomach_flavor = "You stare into Roti's maw as he moves it towards your head, putting it in and tasting your sweet delicious chocolately flavor. \
	Wet saliva covers your head as he pushes you inward, gulping down your head and shoulders into his pulsating throat. It pulses and eases you downward towards your destination \
	cramming your torso into his maw and taking wet SCHLURP, GLUK, to get it down and up to your waist. Roti continues to taste you all over wanting that succulent flavor \
	to himself. Another loud wet swallow and down goes your waist into his hungry maw, lifting up the legs high into the sky while allowing gravity and his gulps \
	to send you packing away into his chubby gut that now expands to fit you inside of the wet chamber. At least you were safe for now that is."
	player_msg = "You are Roti, a curious shadekin that wishes to learn from the station and eventually speak with them."

//kcin2001's soft shadekin
/mob/living/simple_mob/shadekin/green/soft
	name = "Softpatch"
	desc = "A green eyed brown shadekin, looks fluffy and a bit chubby around the middle underneath his well worn cloak \
	He seems curious but ready to flee"
	icon_state = "soft"
	eye_desc = "soft green eyes"
//	vore_stomach_flavor = ""
	player_msg = "You are Softpatch, you like things that are soft and are curious about the beings in realspace"

//"Marr marr marr-marr maaarr marr?~ (Ever had your ass eaten by a shadekin before?~)" - Yrmir (Shadowfire117)
/mob/living/simple_mob/shadekin/orange/yrmir
	name = "Green and black shadekin" //Name is Yrmir and known only to other shadekins he talks to, he doesn't speak common to any degree so far
	desc = "An orange eyed shadekin, this one has a very dark coat with several spots with faintly glowing green patches of fur. \
	Said fur looks quite soft and warm with it filling out a bit, a closer look tells its a slim upper body while rump, hips and thighs are nice and filled out well. \
	While he may have a more padded out soft build below, the masculine part of them is quite visible as a large fat furred sack and sheath rests comfortably between his thighs. \
	From the way he looks at you, you get the feeling he is possibly scheming something fun, at least for himself."
	icon_state = "yrmir"
	eye_desc = "glimmering orange eyes"
	player_msg = "You are Yrmir, an orange shadekin with interest in revelry, trickery and pleasures. Mostly for you but to a degree to the willing and unwilling that interest you."
