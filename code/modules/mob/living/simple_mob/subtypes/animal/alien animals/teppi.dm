//formerly meat things
//I made these up. They aren't deliberately based on, or supposed to be anything in particular.
//They came out kind of goat-ish but that wasn't intentional. I was just going for some cute thing you could
//take care of and/or kill for meat.
//I made them to be a part of the 'low tech survival' part of the game. You can use them to obtain a relatively
//unlimited amount of meat, wool, hide, bone, and COMPANIONSHIP without the need for machines or power... hopefully.
//There's no real story behind them, they're semi-intelligent wild alien animals with a somewhat mild temperament.
//They'll beat you up if you're mean to them, they have preferences for food, affection, and the ability
//to form opinions of others. Or as close to those things as I could get with my tiny creature brain and byond.
//They're TOUGH, but pretty easy to exploit for your needs if you pay attention to them and use your head.
//They also come in a variety of colors and markings, and those factors can be kind of manipulated through controlled breeding.
//They basically do all their funny things based on nutrition, so, if you feed them and like, put them near eachother
//they do what they do when they feel like it.

//Also they eat you and all their vore related text is custom because I'm a shameless vore idiot
//And their stomach defaults to drain, so, dunking people into there will actually help them out without (immediately) killing people SO LIKE
//you know. Feed people to them or whatever, it's cool. People getting eaten has a tangible positive mechanical impact. So do it.

/////////////////TO DO (if I ever learn how/someone ever feels like it)//////////////////////////////
//>seek food nearby to eat, including players with the appropriate settings.
//>give baby teppi a holder thingy so you can pick them up and carry them around
//>give adult teppi the ability to be ridden at high affinity
//>give adult teppi the ability to be equipped with a bag or something, so they can carry things for you
//>baby teppi can ventcrawl when AI controlled (so they fade out, and then appear at a random vent on the Z level)
//>make it so that teppi size is a thing that can be influenced by breeding
//>make it so the teppi are better at following people they really like around without also disabling the other things that their AI does (like resting and speaking)
//>make it so that teppi gains affinity for feeding people to them WITHOUT ALSO introducing a way for people to game the system by spamclicking
//>make it so that when feeding people to the teppi you don't get a choice where to send them unless the teppi is controlled by the player (since they have a special interaction for choosing where to send people that they eat)

//stolen from chickens
GLOBAL_VAR_CONST(max_teppi, 50)	// How many teppi CAN we have?
GLOBAL_VAR_INIT(teppi_count, 0)	// How mant teppi DO we have?

/datum/category_item/catalogue/fauna/teppi
	name = "Alien Wildlife - Teppi"
	desc = "Teppi are large omnivorous quadrupeds with long fur.\
	Unlike many horned mammals, Teppi have developed paws with four toes rather than hooves.\
	This coupled with a thick, powerful tail makes them quite capable and balanced on many\
	kinds of terrain. A recently discovered species, their origins are something of a\
	mystery, but they have been discovered in more different regions of space with no apparent\
	connection to one another. Teppi are known to reproduce and grow rather quickly, which if\
	left unchecked can lead to serious problems for local ecology.\
	Teppi are very hardy, engaging them in combat is not recommended.\
	Teppi can be a good source of protein and materials for crafts and clothing in emergency\
	situations. They are not especially picky eaters, and have a rather mild temperament.\
	A pair of well fed Teppi can rather quickly become a small horde, so it is generally\
	advised to keep an eye on their numbers."
	value = CATALOGUER_REWARD_MEDIUM

/mob/living/simple_mob/vore/alienanimals/teppi
	name = "teppi"
	desc = "A large and furry creature, sporting two thick horns and a very sturdy tail. It has four toes on each paw."
	tt_desc = "Ipsumollis Velodigium" 	//I mashed some latin words together. This is nonsense, but it comes from 'very soft furred monster'
										//which I know is not how this kind of thing should honestly go but it's a weird future alien creature MANNNNNNN
	icon_state = "teppi"
	icon_living = "body_base"
	icon_dead = "body_dead"
	icon_rest = "body_rest"
	icon = 'icons/mob/alienanimals_x64.dmi'
	pixel_x = -16
	default_pixel_x = -16

	faction = FACTION_TEPPI
	maxHealth = 600
	health = 600
	movement_cooldown = -1
	meat_amount = 12
	meat_type = /obj/item/reagent_containers/food/snacks/meat

	response_help = "pets"
	response_disarm = "rudely paps"
	response_harm = "punches"

	harm_intent_damage = 2
	melee_damage_lower = 2
	melee_damage_upper = 10

	min_oxy = 2
	max_oxy = 0
	min_tox = 0
	max_tox = 15
	min_co2 = 0
	max_co2 = 50
	min_n2 = 0
	max_n2 = 0
	minbodytemp = 150
	maxbodytemp = 400
	unsuitable_atoms_damage = 0.5
	catalogue_data = list(/datum/category_item/catalogue/fauna/teppi)
	vis_height = 64

	var/affinity = list()
	var/allergen_preference
	var/allergen_unpreference
	var/body_color
	var/marking_color
	var/horn_color
	var/eye_color
	var/skin_color
	var/item_type
	var/item_color
	var/marking_type
	var/horn_type
	var/static/list/overlays_cache = list()
	var/inherit_allergen = FALSE
	var/inherit_colors = FALSE
	var/teppi_wool = FALSE
	var/amount_grown = 0
	var/teppi_adult = TRUE
	var/friend_zone //where friends go when we eat them
//	var/teppi_id //This is all for anti-incest business, which I might finish eventually, but am not sure if it's really deisrable right now.
//	var/mom_id
//	var/dad_id
	var/baby_countdown = 0
	var/breedable = FALSE
	var/prevent_breeding = FALSE
	var/petcount = 0
	var/wantpet = 0
	var/affection_factor = 1	//Some Teppi are more happy to be loved on than others.
	var/teppi_warned = FALSE
	var/teppi_mutate = FALSE	//Allows Teppi to get their children's colors scrambled, and possibly other things later on!

	attacktext = list("nipped", "chomped", "bonked", "stamped on")
	attack_sound = 'sound/voice/teppi/roar.ogg' // make a better one idiot
	friendly = list("snoofs", "nuzzles", "nibbles", "smooshes on")

	ai_holder_type = /datum/ai_holder/simple_mob/teppi

	mob_size = MOB_LARGE

	has_langs = list(LANGUAGE_TEPPI)
	say_list_type = /datum/say_list/teppi
	player_msg = "Teppi are large omnivorous quadrupeds. You have four toes on each paw, a long, strong tail, and are quite tough and powerful. You’re a lot more intimidating than you are actually harmful though. Your kind are ordinarily rather passive, only really rising to violence when someone does violence to you or others like you. You’re not stupid though, you can commiunicate with others of your kind, and form bonds with those who are kind to you, be they Teppi or otherwise. <br>- - - - -<br>" + span_notice("While you may have access to galactic common, this is purely meant for making it so you can understand people in an OOC manner, for facilitating roleplay. You almost certainly should not be speaking to people or roleplaying as though you understand everything everyone says perfectly, but it's not unreasonable to be able to intuit intent and such through people's tones when they speak. Teppi are kind of smart, but they are animals, and should be roleplayed as such.") + " " + span_warning("ADDITIONALLY, you have the ability to produce offspring if you're well fed enough every once in a while, and the ability to disable this from happening to you. These verbs exist for to preserve the mechanical functionality of the mob you are playing. You should be aware of your surroundings when you use this verb, and NEVER use it to prefbreak or be disruptive. If in doubt, don't use it.") + " " + span_notice("Also, to note, AI Teppi will never initiate breeding with player Teppi.")
	loot_list = list(/obj/item/bone/horn = 100)
	internal_organs = list(\
		/obj/item/organ/internal/brain,\
		/obj/item/organ/internal/heart,\
		/obj/item/organ/internal/liver,\
		/obj/item/organ/internal/stomach,\
		/obj/item/organ/internal/intestine,\
		/obj/item/organ/internal/lungs\
		)

	butchery_loot = list(\
		/obj/item/stack/animalhide = 3,\
		/obj/item/bone/horn = 1\
		)

/////////////////////////////////////// Vore stuff///////////////////////////////////////////

	swallowTime = 1 SECONDS
	vore_active = 1
	vore_capacity = 3
	vore_bump_chance = 1
	vore_bump_emote	= "greedily homms at"
	vore_ignores_undigestable = 0
	vore_default_mode = DM_DRAIN
	vore_icons = SA_ICON_LIVING
	vore_stomach_name = "Stomach"
	vore_default_contamination_flavor = "Wet"
	vore_default_contamination_color = "grey"
	vore_default_item_mode = IM_DIGEST
	vore_bump_chance = 5
	vore_pounce_chance = 35
	vore_pounce_falloff = 0
	vore_standing_too = TRUE

/mob/living/simple_mob/vore/alienanimals/teppi/init_vore()
	..()
	var/obj/belly/B = vore_selected
	B.name = "stomach"
	B.desc = "The heat of the roiling flesh around you bakes into you immediately as you’re cast into the gloom of a Teppi’s primary gastric chamber. The undulations are practically smothering, clinging to you and grinding you all over as the Teppi continues about its day. The walls are heavy against you, so it’s really difficult to move at all, while the heart of this creature pulses rhythmically somewhere nearby, and you can feel the throb of its pulse in the doughy squish pressing up against you. Your figure sinks a ways into the flesh as it presses in, wrapping limbs up between countless slick folds and kneading waves. It’s not long before you’re positively soaked in a thin layer of slime as you’re rocked and squeezed and jostled in the stomach of your captor."
	B.mode_flags = 40
	B.belly_fullscreen = "yet_another_tumby"
	B.digest_brute = 0.05
	B.digest_burn = 0.05
	B.digestchance = 5
	B.absorbchance = 1
	B.escapechance = 15

	B.emote_lists[DM_DRAIN] = list(
		"The walls press in heavily over you, holding you tightly and grinding, churning against your body powerfully!! You can feel %pred’s heartbeat through the flesh, pounding in your ears, and the groaning gurgles of the gastric chamber rolling around you, eagerly pressing in against you.",
		"The squeezing touch of the practically molten walls form to your figure, pressing in close and gliding across the shapes of your body, pressing, bending, and churning you casually! The intensity of it all is almost hard to comprehend. It is not painful, so much as just, almost completely overpowering, exhausting...",
		"The gurgling bubbling sounds of %pred’s body drown out much of everything else as you’re submerged in the rolling waves of wrinkled belly flesh. You can hear the flesh stretch and shift as %pred moves. The whooshing of %pred’s breath catches your attention now and then, and how things seem to get tighter for you when the whoosh draws in, squeezing you that much more.",
		"The creak of muscle and bone containing you sounds through the sloppy flesh pressed in against you as %pred moves. Your body is forced into a tighter curl as %belly churns over you, forming to take up any free space. This hot, humid organic gloom seems to be totally focused on you, working hard to make use of you however it can...",
		"It’s so hard to move with all the heavy flesh pressing in on you, wearing you down and making it that much harder to move as the moments pass. The squashy walls form to your figure and lets your weight sink in quite a ways before the tension builds. An idle flex of the muscles beyond shoves you back into place, and the cycle begins again.",
		"%pred’s %belly rolls over you heavily a few times, burying you briefly in an intense hold and shoving you to the back end of the chamber. There’s no free space, just powerful squeezes and slimy squelches! The wrinkly walls ripple over you powerfully as your body is slowly churned from one end to the other!",
		"What little air there is in here is so thick that you could cut it with a knife, HOT and humid and just totally oppressive. The throbbing bodily motions quake through you as you’re jostled and tossed around amid rolling waves of wrinkled flesh, oozing with a thin slime. %pred’s heart pulses in your ear and all around you as you’re contained completely within the %belly, confined to the pitch black, intimate space, hidden away amid %pred.",
		"The chaotic pressing and churning all around you makes it hard to get your bearings. The sloppy presses of hot heavy flesh shove you here and squeeze you there, never leaving you alone as they enjoy you. It’s hard to get ANY space to yourself, and to do so, you usually have to really fight for it, and sacrifice some other part of your body to the squeezing gropes of %pred’s insistent %belly.",
		"Thick rolling waves of flesh batter against and form to you as you’re smothered briefly against the doughy walls of %pred’s %belly. The hold goes on for a little too long, but just as you start to worry, it eases up a little bit and gives you an ounce of space. … For about three seconds, before the chamber collapses in on you again, grinding and squeezing and churning you around idly. The grumbling symphony of that gut working on you is impossible to tune out as the burbling sound of slick flesh and goopy insides fill your ears.",
		"The walls that separate you from the outside world are thick, and not just because of the few inches of doughy, stretchy %belly lining that’s containing you immediately. Beyond that there are other organs unseen, glooping and churning and glorgling outside of your chamber, then there are layers of muscle and bone, and finally a thick hide and ample fluff. This all means that, for your part, you’re likely a small shifting shape under that fluffy exterior, packed away deep at the core of all of those layers, so far from the outside world as that chamber grinds and smothers over you, smearing you in slime and keeping you nice and tucked deep into the rumbling darkness.")

	B.emote_lists[DM_DIGEST] = list(
		"The walls close in on you in thick, heavy waves, smearing you in a thick slime. Working hard to churn over your figure intensely. The heat of the chamber soaks into you along with the fluids you’re being lathered in. A telling tingle sets in the longer you are exposed to those fluids, while no part of you is spared from the probing churns and deep kneads of %pred’s insistent %belly. . .",
		"The doughy press of %pred’s %belly almost seems to feel over you, actively seeking you within that gloomy humid chamber. The sloppy burbling of that thick flesh gliding and smearing over you is impossible to ignore, the sound of your own body slapping and slurping amid those active pulsing folds and the bubbling slime a sign that you are indeed held deep within the organic confines of another’s hungry gut… and it’s focused on you.",
		"The sounds outside of the %belly are difficult to make out. You can hear little creaks and bumps against %pred’s hide though, the sound of the skin stretching to form to your predator’s shape, and to contain you deep within. Of course, the slurping, squishing, and GURGLING of that gut working around you is always more immediately apparent, along with the heavy throbbing of %pred’s heart.",
		"You find that as you’re rocked and ground amid the gurgling %belly, the ever present thumping drone of %pred’s heartbeat pounds in your ears, the powerful thudding of it pulses through the flesh holding you, throbbing across every wrinkle and fold, every surface presses in at you just that little bit more with each and every throb of that heartbeat. The burbling grumbles of that gut working around you too, fill your ears with a deep gastric symphony as those walls work hard to break you down.",
		"The gurgling walls press in heavily, overpowering your limbs briefly as the chamber collapses in to grind over you from head to toe!! No part of you is left out as the doughy flesh glides and grinds and jostles you around, smothering you in thick slime here and squeezing you down into a tight little ball there. The satisfied puffing coming from nearby through the flesh all you need to know that %pred is happy to have you.",
		"The slime bubbles and glorps around you as you’re smothered in those thick walls! The slick surfaces mold to your figure as the throbbing of %pred’s pulse squeezes you that little bit more with each beat of their heart. The tingling caused by that slime spreads all across your body as you’re totally soaked in it, and there’s nowhere within this chamber to get away from it!",
		"The roaring gurgles of the active gut squeezing and squelching in around you sound out for a few moments as you are smushed and squeezed intensely! This is it! %pred’s %belly is trying to claim you utterly!!!! But after a few moments the chamber eases off, leaving you sopping wet with thick, stringy slime.",
		"It’s so hot, sweltering even! The burbling sounds of this organic cacophony swell and ebb all around you as thick slimes gush around you with the motion of %pred’s %belly. It’s hard to move in this tingly embrace even though the squashy walls are absolutely slippery! You can pull your limbs out from between the heavy meaty folds with some effort, and when you do there’s a messy sucking noise in the wake of the motion. Of course, such a disturbance naturally warrants that the chamber would redouble its efforts to subdue you and smother you in those thick tingling slimes.",
		"The walls around you flex inward briefly, burbling and squelching heavily as everything rushed together, wringing you powerfully for a few moments while, somewhere far above you can hear the bassy rumble of a casual belch, much of the small amount of acrid air available rushing out with the sound. After several long moments held in the tight embrace of that pulsing flesh, things ease up a bit again and resume their insistent, tingly churnings.",
		"It’s pitch black and completely slimy in here, %pred sways their %belly a bit here and there to toss you from one end to the other, tumbling you end over end as you’re churned in that active %belly. It’s all so slick and squishy, so it is really hard to get any footing or grip on things to stabilize your position, which means that you’re left at the mercy of those gloomy gastric affections and the tingling touch of those sticky syrupy slimes that the walls lather into your body.")

	B.emote_lists[DM_HOLD] = list(
		"The burbling %belly rocks and glides over you gently as you’re held deep within %pred, the deep thumping of their heart pulses all around you as you’re caressed and pressed by heavy, doughy walls.",
		"%pred’s %belly glorgles around you idly as you’re held gently by the slick, wrinkled flesh.",
		"The ever present beating of %pred’s heart throbs through the chamber around you. As you sink into the flesh a little ways, you can feel the pressure of the pulse pump in against you that much more snug for an instant, just in time with the thump of the nearby heart.",
		"As %pred breathes you can feel the %belly you are within compact in against you a bit more, the pressure of the inflating lungs smooshing the other organs out of the way a bit, and giving you a bit more of a squeeze, before with a whoosh the breath rushes out again, and the cycle repeats.",
		"As %pred goes about their day you can feel the motions of their body jostle you a bit here and there. Bumping and bouncing you against the doughy pressure of those interior confines, the gloopy gurgles sounding off from somewhere deeper inside...",
		"The walls press in heavily on you for a few moments. Squeezing across you in a heavy, possessive churn. A smothering squeeze that leaves you breathless for a few long moments, coating you in a thin layer of slick slime. The walls seem to retreat reluctantly, leaving you in the sweltering humid air of %pred’s cramped %belly.",
		"It’s hard to stay in place with how slick and squashy the walls of %pred’s %belly are. Thick and smushy and soft, you can sink into them several inches before the tension catches you and rolls you around at the crater your body weight makes. A pool of thin slimes gathers around you some, clinging close as you’re held snugly deep within %pred.",
		"The press of slick flesh to your body and in against itself is ever present within this slimy space. The squelches and grumbles of that tummy shifting around you never really go away. The wrinkled walls would glide against themselves here and there creating an idle cacophony of squish, while the caress of that flesh in against your body makes a more prevalent slurping that’s hard to escape.",
		"Held within the pitch black gloom of this gently churning organic chamber it’s hard to get much room to yourself. The walls are always prone to rolling in and squeezing over you for long moments.",
		"Despite the constant motion of fleshy waves gliding in against you and the burbling sounds of the inner workings of all those tubes and organs, the steady beating of %pred’s heart, and the gentle whooshing of their breath were surprisingly relaxing.")

	B.emote_lists[DM_ABSORB] = list(
		"The intensity of the flesh pumping in against you makes it somewhat hard to tell how soft and tarry the surfaces pressing into you have gotten. As your extremities disappear between the folds of flesh inside there it’s so difficult to pull them back out, like squirming against  hot, gooey quicksand! %pred’s %belly seems quite insistent on sinking you deeper, and claiming you entirely.",
		"The pressure is intense, the slimy walls rolling over you again and again, really clinging to your figure, sticky and slurpy, you can feel the tug of the flesh drawing you in, and the flickers of another presence along the edges of your mind.",
		"The wrinkled flesh flows between your fingers and wraps in against your body as it presses in and clings to you. The walls are extremely soft, so much so that you can sink deep into them, where, a curious tingling begins to tickle at you the deeper you go.",
		"The pulse of %pred’s heart throbs all around you, through the flesh and up against you. A powerful pumping that rolls through every little bit of the %belly. The softening walls steadily flow over you, steadily sinking you into their surface a ways where that throbbing seems to get that much more intense, pulsing all around you as the flesh forms skin tight to you… and your heart seems to adjust too, thumping in your ears in time with %pred’s.",
		"The pressure of %pred’s body forming against you makes it hard to move at all. The walls fold in against you, wrapping you up and steadily submerging you, a texture something akin to molten marshmallow hugs you all around, filling in the creases and spaces between, but even as you’re held there so tightly, you’d find that you’re neither crushed nor suffocated… Held so deep and tight as that %belly works to make you one with it.",
		"As the flesh of %pred’s %belly forms against you and flows across your body, you can feel and hear the wet slide of its weight spreading and rubbing against you. As it forms against your ears though and really clings on to you, the sloppy wet sounds of the interior of some weird alien fade, to be replaced by a powerful thumping heartbeat. As you sink into %pred’s body, it becomes harder and harder to identify where you end and %pred begins, and that pumping heartbeat lulls your mind into something of a dull haze.",
		"As the gooey touch of %pred’s body rolls over you, you can’t help but notice just how soft it all is, despite the intensity of the pressure squeezing in against you, clinging to your figure in an insistent smothering embrace, it’s never painful. The flesh you’re being held against forms to you, molding against you, creating a space that’s perfectly sized for you. A cavity shaped exactly like you. A place where you belong.",
		"As the pumping flesh courses against you, gliding and throbbing against your touch, letting you sink in far beyond where it seems reasonable for tension to have caught you, you notice that whatever appendage has sunk that deep begins to feel a bit tingly, a bit starry, like it’s become a twinkling starlight. It’s weird, but not exactly uncomfortable. There’s a sense of otherness that brushes comfortably somewhere against the back of your mind, that gets stronger the deeper you sink...",
		"The rippling touch of %pred’s wrinkled flesh folding in against you is hard to escape. No matter where you turn, it’s all closing in on you, pressing to you. Practically molten, the pressure of it all molds to you and leaves no part of your figure untouched, and yet, even as it forms skin tight in against you, it doesn’t stop there. You seem to still sink further into the squish, the surface of it all flows over your figure and submerges you deeper, and deeper… and deeper, until there’s nothing but the heat and the throb of %pred’s heart all around you.",
		"The pressure is intense. The throbbing of %pred’s heart in your ears is impossible to ignore as the weight of your predator shifts when they move. You might notice that, as you sink deeper into the pressure of %pred, you’re more conscious of those shifts and wobbles, as if they were your own, and the appreciative flickerings of consciousness that seems to have claimed you. You can feel each shift and jiggle of the fluffy critter’s movements as you’re absorbed...")

	B.emote_lists[DM_HEAL] = list(
		"The walls glide over you tenderly, gently. Lightly kneading and massaging against your figure, smooth and pillowy soft. You can sink in a ways, but it’s not hard to extract yourself from these caressing touches. The burbling of %pred’s %belly fills your ears as you’re rocked and cradled within.",
		"As you soak within %pred’s %belly you can feel some of your strength returning, aches and pains easing some as time goes on. The walls knead over you gently, but are never rough. They’re soft and smushy, like a jiggly padding, protecting you from the outside world.",
		"The throb of %pred’s heart rocks through the surfaces of the %belly. Even as you’re sunk into a bit of a crater in the flesh there, you can feel it pulse through the squish. The sound of %pred’s heart is a constant companion, along with the wet squelches and slurps of flesh shifting against itself and you.",
		"The slow sway of %pred’s body as it moves rocks you back and forth across the %belly. With how soft and gentle it is in there, it’s not unlike relaxing in a large, dark fleshy hammock. Of course, there’s not really any airflow or even all that much space, what with the walls pressed in close and gently churning and kneading against you, so it’s not anything like a hammock, really… but you might be able to imagine it was if you put your mind to it. Either way, the gentle sway is soothing and comfortable despite how un-hammock-like this hammock is...",
		"The smooth press of flesh throbs against you as %pred’s %belly kneads and smooshes over you soothingly. The pressure shifts here and there as the muscles beyond grind over you carefully. Despite the heat and the thick, stifling air, you feel slowly more refreshed as you’re held in here. It’s comfy enough to nap in.",
		"As you’re held within the %belly you feel your eyelids get a bit heavy… the rhythmic thumping of %pred’s heart nearby, along with the gentle rocking shifts make snoozing an easy option, especially considering how SQUOOSHY and comfortable the stretchy flesh holding you is. It kneads and caresses you soothingly, and you might find that now and then your blinks seem to last several minutes as you’re kept close amid that comfortable %belly.",
		"The walls of the %belly press in close around you for a few moments, squeezing you heavily and kneading across you. You can feel your back and joints pop here and there in just the right way, there is a moment of a kind of ache, and then a deep, delightful relief, as the walls ease up and resume their gentle smooshes.",
		"With each step %pred takes, those soft, smooth wall jiggle lightly around you, quaking and swaying you this way and that. The slimy surfaces of %pred’s interior glide over your body casually, shifting and burbling here and there, holding you nice and secure.",
		"The pressure around you increases a little bit each time you hear the whooooosh of %pred taking a breath in. Expanding lungs compact things inside a little bit, making your stay just that little bit more snug. The pressure is never not gentle though. Those smooth, slick walls were also always pressing and kneading against you too, so it might not be the easiest thing to notice.",
		"The thumping, squeezing, kneading rhythm of %pred’s body was easy to get into. A gentle rocking here, a little bob there, a pulsing throb across the whole %belly as you’re churned and felt over. It’s easy to get lost in the grumbly gurgly rhythm of that body, hidden away in the pitch black. As it all works around you, you can feel your energy build, your muscles relax, and any aches and pains you might have would fade with time. It’s comfortable, and fills you with an alien sense of belonging.")

	B.struggle_messages_inside = list(
		"As you squirm and fuss, your limbs sink into the squish a fair way! Sliding over the slick, sloppy surfaces of %pred’s %belly. The walls clamp in and churn over you heavily in response.",
		"As you squirm, %pred’s %belly wobbles and smothers over you. Wrinkled walls fold against your features. The humid air hangs around you oppressively as the walls roll over you, making it hard to move.",
		"You can feel the pressure of the flesh kneading you clamp down and fold over you insistently as you squirm and push at %pred’s flesh. It’s so slippery and hard to get any proper grip or footing!",
		"When you shift your weight and press into the flesh of %pred’s %belly, you can feel things around you clamp down, and in a rush, what little air there is inside of there rushes out passed you. %pred emits a low, rumbling urp somewhere far above.",
		"Your struggles slide over the doughy flesh. The tension of it catches you and forms to your presses, before it all flexes inward again and tries to fold you into a smaller shape again.",
		"When you push and squirm against the walls of the %belly, you can hear and feel %pred give a little happy grumble, and you can feel them shift their weight, tossing you from one end of the %belly to the other, sloppy squelching sounding out as you land.",
		"Your hands slip and slide against the pulsing wrinkled squish of %pred’s %belly, sinking into the doughy texture of the smooth walls and makes it hard to go anywhere except to the lowest, deepest section of the %belly.",
		"The sound of your squirms is loud in your ears. The squelchy gurgly sound of sloppy wet flesh shifting in the pitch black, as your struggles force the tight space wider as you try to wriggle free.",
		"When you move the %belly gurgles insistently around you. The bubbling fluids within there cling to you as you push and squirm against those wrinkly walls.",
		"Your struggles are stifled by the clinging press of heavy flesh greedily pressing in on you heavily. It’s tiring to fight against those groaning guts...")

	B.struggle_messages_outside = list(
		"Vague shapes shift under %pred’s hide...",
		"Something solid squirms within %pred...",
		"%pred emits a low ‘uurp’ as something shifts within.",
		"Something bumps and thumps against the inside of %pred.",
		"Something glorps inside of %pred.",
		"%pred’s gut grumbles around something solid...",
		"%pred’s belly rumbles and sways as something moves inside.",
		"Something sloshes inside of %pred.",
		"%pred’s belly burbles noisily.",
		"%pred’s belly shifts noticeably.")
	B.examine_messages = list(
		"There is a noticable swell on their belly.",
		"Their belly seems to hang a bit low.",
		"There seems to be a solid shape distending their belly.")
	B.digest_messages_prey = list(
		"With a low grumble your body melts and falls apart within %pred. The nutrition you provide would go on to power your predator as they go on with their life. You were nutritious food, but, nothing but alien food in the end.",
		"No matter your squirms and fusses you can feel those walls collapse in on you, smothering over you as the tingling fluids rise and bubble against you. Churning hard as your body is actively softened up and melted away! Your senses fading out as you’re reduced to nothing but a hot, gooey slush, a form much better suited to continuing on as food for a hungry body.",
		"As your body weakens and your wiggles ebb down, the pressure of those churning walls builds, further overpowering and working to melt you that much more. The thick syrupy slime soaks into you and softens you up, not unlike ice cream on a hot summer day, and you’re soaked up just as easily.",
		"%pred’s %belly gushes and schlorps around you as you are broken down and absorbed. The rippling walls churn and roll the slowly thinning contents of their sloshing depths, as more and more of you is claimed completely by %pred.",
		"The gurgling sounds of your body melting slowly overtakes all the other sounds. The walls closing in and squeezing over you so heavily! Nothing you could do could help you now as you’re churned and mushed, left to steadily soften and break up into a nutritious slush. ",
		"Your body softens and glorps around within the guts of %pred. The rolling rumbles and sloshes overcome you as your senses fade, and your form fades away, bubbling away to become nothing more than a part of %pred.",
		"Things clamp down over you as %pred flexxes, smothering over you for a few long moments. Your senses fade away before they ease up though. Your body rapidly melted down and made to slosh through the deeper tubes, helpless but to fade away as you’re absorbed as the food you are.",
		"The tide of syrupy fluids rises higher and higher, flooding over you, leaving nothing to breathe. Your senses fade away as the sloppy roiling mess softens you up and passes you along for further processing, fit only to serve to plump up %pred’s figure.",
		"Over the course of several hours in the burbling organic cauldron, your body softens up little by little, soaking up the slime, the tingling spreading over you more and more as your strength fades. The walls fold over you and wrap you up, until the last thing you can sense is the throb of %pred’s heart pulsing through the very core of your being, washing you away as you become food for %pred.",
		"Your final moments are spent trying to make just a little space for yourself, the doughy squish of the flesh forming to you, pressing in tighter and tighter, invading your personal space as if to show you that, you don’t have any personal space. You’re already a part of %pred, you just don’t know it yet. And so those walls come in close to press up against you and churn you away into a messy slop, to put you in your place. That being, padding the belly and hips of %pred, right where you belong.")

// The friend zone.
	var/obj/belly/p = new /obj/belly(src)
	p.immutable = TRUE
	p.mode_flags = 40
	p.human_prey_swallow_time = 0.01 SECONDS
	p.digestchance = 0
	p.digest_brute = 0
	p.digest_burn = 0
	p.absorbchance = 0
	p.escapable = TRUE
	p.escapechance = 40
	p.digest_mode = DM_HEAL
	p.name = "propeutpericulum" 	//I'm no latin professor I just know that some organs and things are based on latin words
									//and google translate says that each of these individually
									//"close" "to" "danger" translate to "prope" "ut" "periculum".
									//Of course it doesn't translate perfectly, and it's nonsense when squashed together, but
									//I don't care that much, I just figured that the weird alien animals that store friends in
									//their tummy should have a funny name for the organ they do that with. >:I
	p.desc = "You seem to have found your way into something of a specialized chamber within the Teppi. The walls are slick and smooth and REALLY soft to the touch. While you can hear the Teppi’s heartbeat nearby, and feel it throb throughout its flesh, the motions around you are gentle and careful. You’re pressed into a small shape within the pleasant heat, with the flesh forming to your figure. You can wriggle around a bit and get comfortable here, but as soon as you get still for a bit the smooth, almost silky flesh seems to form to you once again, like a heavy blanket wrapping you up. As you lounge here the pleasant kneading sensations ease aches and pains, and leave you feeling fresher than before. For a curious fleshy sac inside of some alien monster, this place isn’t all that bad!"
	p.contaminates = 1
	p.contamination_flavor = "Wet"
	p.contamination_color = "grey"
	p.item_digest_mode = IM_HOLD
	p.belly_fullscreen = "yet_another_tumby"
	p.fancy_vore = 1
	p.vore_verb = "nyomp"
	friend_zone = p

	p.emote_lists[DM_DRAIN] = B.emote_lists[DM_DRAIN]

	p.emote_lists[DM_DIGEST] = B.emote_lists[DM_DIGEST]

	p.emote_lists[DM_HOLD] = B.emote_lists[DM_HOLD]

	p.emote_lists[DM_ABSORB] = B.emote_lists[DM_ABSORB]

	p.emote_lists[DM_HEAL] = B.emote_lists[DM_HEAL]

	p.struggle_messages_inside = B.struggle_messages_inside

	p.struggle_messages_outside = B.struggle_messages_outside

	p.examine_messages = B.examine_messages

	p.digest_messages_prey = B.digest_messages_prey

///////////////////////////////////////Other stuff///////////////////////////////////////////

/mob/living/simple_mob/vore/alienanimals/teppi/Initialize()
	. = ..()

	if(name == initial(name))
		name = "[name] ([rand(1, 1000)])"
		real_name = name
	if(!teppi_adult)
		nutrition = 0
		add_verb(src, /mob/living/proc/ventcrawl)
		add_verb(src, /mob/living/proc/hide)
	else
		add_verb(src, /mob/living/simple_mob/vore/alienanimals/teppi/proc/produce_offspring)
		add_verb(src, /mob/living/simple_mob/vore/alienanimals/teppi/proc/toggle_producing_offspring)


//	teppi_id = rand(1,100000)
//	if(!dad_id || !mom_id)
//		dad_id = rand(1,100000)
//		mom_id = rand(1,100000)
	teppi_setup()

//Picks colors and allergens for teppi that don't have them set
/mob/living/simple_mob/vore/alienanimals/teppi/proc/teppi_setup()
	var/static/list/possibleallergens = list(
		ALLERGEN_MEAT,
		ALLERGEN_FISH,
		ALLERGEN_FRUIT,
		ALLERGEN_VEGETABLE,
		ALLERGEN_GRAINS,
		ALLERGEN_BEANS,
		ALLERGEN_SEEDS,
		ALLERGEN_DAIRY,
		ALLERGEN_FUNGI,
		ALLERGEN_COFFEE,
		ALLERGEN_SUGARS,
		ALLERGEN_EGGS
		)

	var/static/list/possiblebody = list("#fff2d3" = 100, "#ffffc0" = 25, "#c69c85" = 25, "#9b7758" = 25, "#3f4a60" = 10, "#121f24" = 10, "#420824" = 1)
	var/static/list/possiblemarking = list("#fff2d3" = 100, "#ffffc0" = 50, "#c69c85" = 25, "#9b7758" = 5, "#3f4a60" = 5, "#121f24" = 5, "#6300db" = 1)
	var/static/list/possiblehorns = list("#454238" = 100, "#a3d5d7" = 10, "#763851" = 10, "#0d0c2f" = 5, "#ffc965" = 1)
	var/static/list/possibleeyes = list("#4848a7" = 100, "#f346ff" = 25, "#b20005" = 5, "#ff9a06" = 1, "#0cb600" = 50, "#32ffff" = 5, "#272523" = 50, "#ffffff" = 1)
	var/static/list/possibleskin = list("#584060" = 100, "#272523" = 50, "#ff8a8e" = 25, "#35658d" = 10, "#ffbb00" = 1)

	if(!inherit_allergen)	//For new teppi
		allergen_preference = pick(possibleallergens) //the food we like
		allergen_unpreference = pick(possibleallergens - allergen_preference) //can't dislike the thing we like, we're not THAT picky
		affection_factor = rand(1,3)
	if(!inherit_colors)
		color = pickweight(possiblebody)
		marking_color = pickweight(possiblemarking)
		horn_color = pickweight(possiblehorns)
		eye_color = pickweight(possibleeyes)
		skin_color = pickweight(possibleskin)
	if(!marking_type)
		marking_type = "[rand(0,13)]" //the babies don't have this set up by default, but they might pick it from their parents
	if(teppi_adult)
		if(!horn_type)
			horn_type = "[rand(0,1)]"
	else if(teppi_mutate)
		var/list/possiblecolorlists = list(possiblebody, possiblemarking, possiblehorns, possibleeyes, possibleskin)
		var/pick_a = rand(0,5)
		var/pick_b = pick(possiblecolorlists)
		switch(pick_a)
			if(0)
				color = pickweight(pick_b)
			if(1)
				marking_color = pickweight(pick_b)
			if(2)
				horn_color = pickweight(pick_b)
			if(3)
				eye_color = pickweight(pick_b)
			if(4)
				skin_color = pickweight(pick_b)
			if(5)
				color = pickweight(pick_b)
				marking_color = pickweight(pick_b)
				horn_color = pickweight(pick_b)
				eye_color = pickweight(pick_b)
				skin_color = pickweight(pick_b)
		teppi_mutate = FALSE

	update_icon()

//This builds, caches, and recalls parts of the teppi as it needs them, and shares them across all teppi,
//so ideally they only have to make it once as they need it since most of them will be using many of the same colored parts
/mob/living/simple_mob/vore/alienanimals/teppi/proc/teppi_icon()
	var/marking_key = "marking-[marking_color]"
	var/horn_key = "horn-[horn_color]"
	var/eye_key = "eye-[eye_color]"
	var/skin_key = "skin-[skin_color]"
	var/wool_key = "wool-[marking_color]"

	var/our_state = "base"	//For helping the images know what icon state they should be grabbing
	if(icon_state == icon_living)
		our_state = "base"
	if(icon_state == icon_rest)
		our_state = "rest"
	if(icon_state == icon_dead)
		our_state = "dead"
	var/life_stage = "adult"
	if(!teppi_adult)
		life_stage = "baby"
	/////LOWEST LAYER/////
	if(teppi_adult)		//Only adults get markings or wool. The marking color is a secret until they grow bigger!
		var/combine_key = marking_key+our_state+marking_type		//Markings first, the lowest layer, down with the base color
		var/image/marking_image = overlays_cache[combine_key]
		if(!marking_image)
			marking_image = image(icon,null,"marking_[our_state][marking_type]")
			marking_image.color = marking_color
			marking_image.appearance_flags = RESET_COLOR|KEEP_APART|PIXEL_SCALE
			overlays_cache[combine_key] = marking_image
		add_overlay(marking_image)

		if(item_type)
			var/item_key = "[item_type]-[item_color]"
			var/image/item_image = overlays_cache[item_key+our_state]	//Items! Like collar. Goes under everything but markings because I'll go crazy otherwise
			if(!item_image)
				item_image = image(icon,null,"[item_type]_[our_state]")
				item_image.color = item_color
				item_image.appearance_flags = RESET_COLOR|KEEP_APART|PIXEL_SCALE
				overlays_cache[item_key+our_state] = item_image
			add_overlay(item_image)

		if(teppi_wool)
			var/image/wool_image = overlays_cache[wool_key+our_state+life_stage]	//Wool comes next, goes over top of the markings, is the same color too
			if(!wool_image)
				wool_image = image(icon,null,"wool_[our_state]")
				wool_image.color = marking_color
				wool_image.appearance_flags = RESET_COLOR|KEEP_APART|PIXEL_SCALE
				overlays_cache[wool_key+our_state+life_stage] = wool_image
			add_overlay(wool_image)

	var/image/horn_image = overlays_cache[horn_key+our_state+life_stage+horn_type]		//Horns MUST come after marking and wool for layering purposes.
	if(!horn_image)
		if(!teppi_adult)
			horn_image = image(icon,null,"horn_[our_state]")	//Babies only have one kind of horns
		else
			horn_image = image(icon,null,"horn_[our_state][horn_type]")
		horn_image.color = horn_color
		horn_image.appearance_flags = RESET_COLOR|KEEP_APART|PIXEL_SCALE
		overlays_cache[horn_key+our_state+life_stage+horn_type] = horn_image
	add_overlay(horn_image)

	var/image/eye_image = overlays_cache[eye_key+our_state+life_stage]			//Eyes and skin should be above markings too, but their order doesn't matter
	if(!eye_image)																//they won't intersect with eachother or the horns, but might intersect with some markings.
		eye_image = image(icon,null,"eye_[our_state]")							//If we ever add horns or wool fluff that might cover them, remember to move these down as appropriate.
		eye_image.color = eye_color												//Otherwise they will just always be on top of them.
		eye_image.appearance_flags = RESET_COLOR|KEEP_APART|PIXEL_SCALE
		overlays_cache[eye_key+our_state+life_stage] = eye_image
	add_overlay(eye_image)

	var/image/skin_image = overlays_cache[skin_key+our_state+life_stage]
	if(!skin_image)
		skin_image = image(icon,null,"skin_[our_state]")
		skin_image.color = skin_color
		skin_image.appearance_flags = RESET_COLOR|KEEP_APART|PIXEL_SCALE
		overlays_cache[skin_key+our_state+life_stage] = skin_image
	add_overlay(skin_image)
	/////HIGHEST LAYER/////

/mob/living/simple_mob/vore/alienanimals/teppi/attackby(var/obj/item/O as obj, var/mob/user as mob)
	if(stat == DEAD)
		return ..()
	/////GRABS AND HOLDERS/////
	if(istype(O, /obj/item/grab))
		return ..()
	if(istype(O, /obj/item/holder))
		return ..()
	if(user.a_intent != I_HELP) //be gentle
		if(resting)
			lay_down()
		handle_affinity(user, -5)
		user.visible_message(user, span_notice("\The [user] hits \the [src] with \the [O]. \The [src] grumbles at \the [user]."),span_notice("You hits \the [src] with \the [O]. \The [src] grumbles at you."))
		playsound(src, 'sound/weapons/tap.ogg', 50, 1, -1)
		return ..()
	if(teppi_wool)
		if(teppi_shear(user, O))
			return
	/////FOOD/////
	if(istype(O, /obj/item/reagent_containers/food))
		if(resting)
			to_chat(user, span_notice("\The [src] is napping, and doesn't respond to \the [O]."))
			return
		if(nutrition >= 5000)
			user.visible_message(span_notice("\The [user] tries to feed \the [O] to \the [src]. It snoofs but does not eat."),span_notice("You try to feed \the [O] to \the [src], but it only snoofts at it."))
			return
		var/nutriment_amount = O.reagents?.get_reagent_amount(REAGENT_ID_NUTRIMENT) //does it have nutriment, if so how much?
		var/protein_amount = O.reagents?.get_reagent_amount(REAGENT_ID_PROTEIN) //does it have protein, if so how much?
		var/glucose_amount = O.reagents?.get_reagent_amount(REAGENT_ID_GLUCOSE) //does it have glucose, if so how much?
		var/yum = nutriment_amount + protein_amount + glucose_amount
		if(yum)
			if(!teppi_adult)
				yum *= 20
			else
				yum *= 10
			var/liked = FALSE
			var/disliked = FALSE
			for(var/datum/reagent/R as anything in O.reagents?.reagent_list)
				if(R.allergen_type & allergen_preference)
					liked = TRUE
				if(R.allergen_type & allergen_unpreference)
					disliked = TRUE
			if(liked && disliked) //in case a food has both the thing they like and also the thing they don't like in it
				user.visible_message(span_notice("\The [user] feeds \the [O] to \the [src]. It nibbles \the [O] and looks confused."),span_notice("You feed \the [O] to \the [src]. It nibbles \the [O] and looks confused."))
			else if(liked && !disliked)
				user.visible_message(span_notice("\The [user] feeds \the [O] to \the [src]. It nibbles \the [O] excitedly."),span_notice("You feed \the [O] to \the [src]. It nibbles \the [O] excitedly."))
				yum *= 2
				handle_affinity(user, 5)
			else if(!liked && disliked)
				user.visible_message(span_notice("\The [user] feeds \the [O] to \the [src]. It nibbles \the [O] slowly."),span_notice("You feed \the [O] to \the [src]. It nibbles \the [O] slowly."))
				yum *= 0.5
				handle_affinity(user, -5)
			else
				user.visible_message(span_notice("\The [user] feeds \the [O] to \the [src]. It nibbles \the [O]."),span_notice("You feed \the [O] to \the [src]. It nibbles \the [O]."))
				handle_affinity(user, 1)
		else
			user.visible_message(span_notice("\The [user] feeds \the [O] to \the [src]. It nibbles \the [O] casually."),span_notice("You feed \the [O] to \the [src]. It nibbles \the [O] casually."))
		adjust_nutrition(yum) //add the nutriment!
		user.drop_from_inventory(O)
		qdel(O)
		playsound(src, 'sound/items/eatfood.ogg', 75, 1)
		if(!client && lets_eat(user) && prob(1))
			visible_message(span_danger("\The [src] scromfs \the [user] along with the food!"))
			to_chat(user, span_notice("\The [src] leans in close, spreading its jaws in front of you. A hot, humid gust of breath blows over you as the weight of \the [src]'s presses you over, knocking you off of your feet as the warm gooey tough of jaws scromf over your figure, rapidly guzzling you away with the [O], leaving you to tumble down into the depths of its body..."))
			playsound(src, pick(bodyfall_sound), 75, 1)
			teppi_pounce(user)
		if(yum && nutrition >= 500)
			to_chat(user, span_notice("\The [src] seems satisfied."))
		return
	/////WEAPONS/////
	if(istype(O, /obj/item/material/knife))
		if(client)
			return ..()
		if(resting)
			user.visible_message(span_attack("\The [user] approaches \the [src]'s neck with \the [O]."),span_attack("You approach \the [src]'s neck with \the [O]."))
			if(do_after(user, 5 SECONDS, exclusive = TASK_USER_EXCLUSIVE, target = src))
				if(resting)
					death()
					return
				else
					to_chat(user, span_notice("\The [src] woke up! You think better of slaughtering it while it is awake."))
					return
		else
			return ..()
	if(istype(O, /obj/item/clothing/accessory/collar/craftable))
		var/obj/item/clothing/accessory/collar/craftable/C = O
		if(item_type == "collar")
			to_chat(user, span_notice("[src] is already wearing a collar."))
			return
		if(!C.given_name)
			to_chat(user, span_notice("You didn't put a name on the collar. You can use it in your hand to do that!"))
			return
		item_type = "collar"
		item_color = C.color
		name = C.given_name
		real_name = C.given_name
		update_icon()
		qdel(C)
		fully_replace_character_name(real_name,C.given_name)
		log_admin("[key_name_admin(user)] renamed a teppi to [name] - [COORD(src)]")
		return
	/////EVERYTHING ELSE/////
	return ..()

//Wake up the teppi if it is resting, which they like to do sometimes.
/mob/living/simple_mob/vore/alienanimals/teppi/attack_hand(mob/living/carbon/human/M as mob)
	if(stat == DEAD)
		return ..()
	if(M.a_intent == I_GRAB && item_type)
		if(affinity[M.real_name] >= 30)
			M.visible_message(span_notice("\The [M.name] removes \the [src]'s [item_type]."),span_notice("You remove \the [src]'s [item_type]."))
			item_type = null
			update_icon()
			return
	if(M.a_intent != I_HELP) //be gentle
		handle_affinity(M, -5)
		to_chat(M, span_notice("\The [src] fusses at your rough treatment!!"))
		if(resting)
			lay_down()
		return..()
	if(resting)
		M.visible_message(span_notice("\The [M.name] shakes \the [src] awake from their nap."),span_notice("You shake \the [src] awake!"))
		playsound(src, 'sound/weapons/thudswoosh.ogg', 50, 1, -1)
		lay_down()
		return
	else if(!client)
		..()
		playsound(src, 'sound/weapons/thudswoosh.ogg', 50, 1, -1)
		if(wantpet >= 100) //We want pets sometimes
			handle_affinity(M, 1)
			if(teppi_adult)
				if(prob(25))
					M.visible_message(span_notice("\The [src] rumbles happily at \the [M]"),span_notice("\The [src] rumbles happily at you!"))
					playsound(src, 'sound/voice/teppi/rumble.ogg', 75, 1)
				vore_selected.digest_mode = DM_DRAIN //People outside can help calm the tumby if you squirm too much
			else if(prob(25))
				M.visible_message(span_notice("\The [src] rumbles happily at \the [M]"),span_notice("\The [src] rumbles happily at you!"))
				playsound(src, 'sound/voice/teppi/cute_rumble.ogg', 75, 1)
			if(prob(25))
				wantpet = rand(0,25) * affection_factor //We stopped wanting pets
			to_chat(M, span_notice("\The [src] leans into your touch."))
			petcount = 0
		else if(petcount < 20)
			wantpet = 0
			petcount += 1
			if(prob(20))
				to_chat(M, span_notice("\The [src] grumbles at your touch."))
		else if(lets_eat(M) && prob(50))
			to_chat(M, span_notice("\The [src] grumbles a bit... and then bowls you over, pressing their weight into yours to knock you off of your feet! In a rush of chaotic presses and schlorps, the gooey touch of Teppi flesh grinds over you as you're guzzled away! Casually swallowed down in retaliation for all of the pettings. Pumped down deep into the grumbling depths of \the [src]."))
			visible_message(span_danger("\The [src] scromfs \the [M], before chuffing and settling down again."))
			playsound(src, pick(bodyfall_sound), 75, 1)
			teppi_pounce(M)
			wantpet = 100
	else
		return ..()

/mob/living/simple_mob/vore/alienanimals/teppi/examine()
	. = ..()
	if(item_type)
		. += span_notice("They are wearing a [item_type] with [name] written on it.")
	if(nutrition >= 1000)
		. += span_notice("They look well fed.")
	if(nutrition <= 500)
		. += span_notice("They look hungry.")
	if(health < maxHealth && health / maxHealth * 100 <= 75)
		. += span_notice("They look beat up.")


/mob/living/simple_mob/vore/alienanimals/teppi/update_icon()
	..()
	teppi_icon()
	if(ghostjoin)
		ghostjoin_icon()


/mob/living/simple_mob/vore/alienanimals/teppi/Life()
	. =..()
	if(!.)
		return
	wantpet += rand(0,2) * affection_factor
	amount_grown += rand(1,5)
	var/not_hungy = FALSE
	if(nutrition >= 500)
		not_hungy = TRUE
	if(amount_grown >= 1000)
		if(teppi_adult)
			if(not_hungy && !teppi_wool)
				nutrition -= rand(250,500)
				teppi_wool = TRUE
				breedable = TRUE
				meat_amount += rand(0,2)
				update_icon()
		else if (not_hungy)
			var/nutrition_cost = 500 + (nutrition / 2)
			adjust_nutrition(-nutrition_cost)
			new /mob/living/simple_mob/vore/alienanimals/teppi(loc, src)
			qdel(src)
		else
			visible_message("\The [src] whines pathetically...", runemessage = "whines")
			if(prob(50))
				playsound(src, 'sound/voice/teppi/whine1.ogg', 75, 1)
			else
				playsound(src, 'sound/voice/teppi/whine2.ogg', 75, 1)
			amount_grown -= rand(100,250)
	if(not_hungy)
		do_breeding()
	if(!client && prob(0.5))
		teppi_sound()

/mob/living/simple_mob/vore/alienanimals/teppi/proc/do_breeding()
	if(!breedable || prevent_breeding)
		return
	if(client)	//Player controlled teppi get a verb, so just do the countdown
		if(baby_countdown > 0)
			baby_countdown --
		return
	if(baby_countdown > 0)
		baby_countdown --
		return
	else if(GLOB.teppi_count >= GLOB.max_teppi) //if we can't make more then we shouldn't look for partners, but we can be ready in case a slot opens
		return
	if(prob(1))
		for(var/mob/living/simple_mob/vore/alienanimals/teppi/alltep in oview(1,src))
			if(!teppi_adult || !alltep.teppi_adult || alltep.prevent_breeding) //Don't have babies if you or your partner is babies
				continue
			if(alltep.client || alltep.stat == DEAD) //Don't have babies if your partner is inhabited by a player, or dead.
				continue
			if(alltep)
				new /mob/living/simple_mob/vore/alienanimals/teppi/baby(loc, src, alltep)
				baby_countdown = 200
				if(affinity[alltep.real_name])
					return
				handle_affinity(alltep, 30) //Mom and dad should like eachother when they do their business
				alltep.handle_affinity(src, 30)
				return

/mob/living/simple_mob/vore/alienanimals/teppi/proc/teppi_sound()
	if(!teppi_adult || client)
		return
	if(resting)
		return
	playsound(src, pick(teppi_sound), 75, 1)

/mob/living/simple_mob/vore/alienanimals/teppi/proc/teppi_shear(var/mob/user as mob, tool)
	var/sheartime = 3 SECONDS
	if(istype(tool, /obj/item/material/knife))
		var/obj/item/material/knife/K = tool
		if(K.default_material == MAT_PLASTIC || K.default_material == MAT_FLINT)
			sheartime *= 2
		if(K.dulled)
			sheartime *= 3
		if(!K.sharp)
			sheartime *= 2
		if(K.edge)
			sheartime *= 0.5
	else if(istype(tool, /obj/item/tool/wirecutters))
		sheartime *= 2
	else
		return FALSE
	if(do_after(user, sheartime, exclusive = TASK_USER_EXCLUSIVE, target = src))
		user.visible_message(span_notice("\The [user] shears \the [src] with \the [tool]."),span_notice("You shear \the [src] with \the [tool]."))
		amount_grown = rand(0,250)
		var/obj/item/stack/material/fur/F = new(get_turf(user), rand(10,15))
		F.color = marking_color
		teppi_wool = FALSE
		update_icon()
		handle_affinity(user, 5)
		teppi_sound()
		return TRUE

//Handles both growing up from a baby and also passing parent details to new babies.
/mob/living/simple_mob/vore/alienanimals/teppi/New(newloc, teppi1, teppi2)
	GLOB.teppi_count ++
	if(teppi1 && !teppi2)
		inherit_from_baby(teppi1)
	else if (teppi1 && teppi2)
		inherit_from_parents(teppi1, teppi2)
	..()

/mob/living/simple_mob/vore/alienanimals/teppi/Destroy()
	GLOB.teppi_count --
	friend_zone = null
	active_ghost_pods -= src
	ai_holder.leader = null
	return ..()

/mob/living/simple_mob/vore/alienanimals/teppi/lay_down()
	..()
	if(client || !teppi_adult)
		return
	if(vore_selected == friend_zone)
		return
	if(resting)
		vore_selected.digestchance = 60
		vore_selected.digest_brute = 6
		vore_selected.digest_burn = 6
	else
		vore_selected.digestchance = 5
		vore_selected.digest_brute = 0.05
		vore_selected.digest_burn = 0.05

/mob/living/simple_mob/vore/alienanimals/teppi/animal_nom(mob/living/T in living_mobs(1))
	if(client)
		return ..()
	var/current_affinity = affinity[T.real_name]
	ai_holder.set_busy(TRUE)
	T.stop_pulling()
	if(current_affinity >= 50)
		var/tumby = vore_selected
		vore_selected = friend_zone
		ai_holder.set_busy(FALSE)
		..()
		vore_selected = tumby
		return
	else if(current_affinity <= -50)
		vore_selected.digest_mode = DM_DIGEST
	else
		vore_selected.digest_mode = DM_DRAIN
	..()
	ai_holder.set_busy(FALSE)


/mob/living/simple_mob/vore/alienanimals/teppi/perform_the_nom(user, mob/living/prey, user, belly, delay)
	if(client)
		return ..()
	var/current_affinity = affinity[prey.real_name]
	ai_holder.set_busy(TRUE)
	prey.stop_pulling()
	if(current_affinity >= 50)
		belly = friend_zone
		..()
		ai_holder.set_busy(FALSE)
		return
	if(current_affinity <= -50)
		vore_selected.digest_mode = DM_DIGEST
	else
		vore_selected.digest_mode = DM_DRAIN
	..()
	ai_holder.set_busy(FALSE)

//Instead of copying this everywhere let's just make a proc
/mob/living/simple_mob/vore/alienanimals/teppi/proc/lets_eat(person)
	if(teppi_adult && will_eat(person))
		return 1
	else
		return 0

/mob/living/simple_mob/vore/alienanimals/teppi/proc/teppi_pounce(mob/living/carbon/human/M as mob)
	M.Weaken(5)
	animal_nom(M)
	M.stop_pulling()

/mob/living/simple_mob/vore/alienanimals/teppi/proc/handle_affinity(mob/living/person, amount)
	affinity[person.real_name] += amount * affection_factor
	var/current_affinity = affinity[person.real_name]
	if(!teppi_adult)	//Don't want baby getting killed by parents in case of hostile or growing up with P in their AI
		return
	if(current_affinity >= 250)	//At this point the Teppi has joined your team
		faction = person.faction
	if(current_affinity <= -500 && !client)	//You're doing this on purpose or really not paying attention and I'm going to kick your ass.
		ai_holder.target = person
		ai_holder.track_target_position()
		ai_holder.set_stance(STANCE_FIGHT)
		affinity[person.real_name] = -100	//Don't hold a grudge though.

/datum/say_list/teppi
	speak = list("Gyooh~", "Gyuuuh!", "Gyuh?", "Gyaah...", "Iuuuuhh.", "Uoounh!", "GyoooOOOOoooh!", "Gyoh~", "Gyouh~","Gyuuuuh...", "Rrrr...", "Uuah~", "Groh!")
	emote_hear = list("puffs", "huffs", "rumbles", "gyoohs","pants", "snoofs")
	emote_see = list("sways its tail", "stretches", "yawns", "turns their head")
	say_maybe_target = list("Gyuuh?", "Rrrr!")
	say_got_target = list("GYOOOHHHH!!!")

/datum/say_list/teppibaby
	speak = list("Gyooh~", "Gyuuuh!", "Gyuh?", "Gyaah...", "Iuuuuhh.", "Uoounh!", "GyoooOOOOoooh!", "Gyoh~", "Gyouh~","Gyuuuuh...", "Rrrr...", "Uuah~", "Groh!", "Yip!")
	emote_hear = list("puffs", "huffs", "rumbles", "gyoohs","pants", "snoofs", "yips")
	emote_see = list("sways its tail", "stretches", "yawns", "turns their head")
	say_maybe_target = list("Gyuuh?", "Rrrr!")
	say_got_target = list("GYOOOHHHH!!!")


/datum/ai_holder/simple_mob/teppi

	hostile = FALSE
	cooperative = TRUE
	retaliate = TRUE
	speak_chance = 0.5
	wander = TRUE

////////////////// Da babby //////////////

/mob/living/simple_mob/vore/alienanimals/teppi/baby
	name = "teppi"
	desc = "A smallish furry creature, sporting two nubby horns and a very sturdy tail. It has four toes on each paw."
	tt_desc = "Ipsumollis Velodigium"

	icon_state = "teppi"
	icon_living = "body_base"
	icon_dead = "body_dead"
	icon_rest = "body_rest"
	icon = 'icons/mob/alienanimals_x32.dmi'
	pixel_x = 0
	default_pixel_x = 0
	teppi_adult = FALSE
	maxHealth = 50
	health = 50
	movement_cooldown = 1
	harm_intent_damage = 5
	melee_damage_lower = 1
	melee_damage_upper = 5
	vore_active = FALSE		//it's a tiny baby :O
	devourable = FALSE
	digestable = FALSE
	vore_bump_chance = 0
	vore_pounce_chance = 0
	vis_height = 32
	meat_amount = 2
	loot_list = list()
	say_list_type = /datum/say_list/teppibaby


/mob/living/simple_mob/vore/alienanimals/teppi/baby/init_vore() //shouldn't need all the vore bidness if they aren't using it as babbies. They get their tummies when they grow up.
	return

//This sets all the things on adult teppi when they grow from a baby
/mob/living/simple_mob/vore/alienanimals/teppi/proc/inherit_from_baby(mob/living/simple_mob/vore/alienanimals/teppi/baby/baby)
	inherit_colors = TRUE
	inherit_allergen = TRUE
	dir = baby.dir
	name = baby.name
	real_name = baby.real_name
	faction = baby.faction
	affinity = baby.affinity
	affection_factor = baby.affection_factor
	nutrition = baby.nutrition
	allergen_preference = baby.allergen_preference
	allergen_unpreference = baby.allergen_unpreference
	color = baby.color
	marking_color = baby.marking_color
	horn_color = baby.horn_color
	eye_color = baby.eye_color
	skin_color = baby.skin_color
	ghostjoin = 1
	active_ghost_pods |= src
	update_icon()

//This sets all the things on baby teppi when they are bred from adult teppi
/mob/living/simple_mob/vore/alienanimals/teppi/proc/inherit_from_parents(mob/living/simple_mob/vore/alienanimals/teppi/mom, mob/living/simple_mob/vore/alienanimals/teppi/dad)
	inherit_colors = TRUE
//	mom_id = mom.teppi_id
//	dad_id = dad.teppi_id
	faction = mom.faction
	color = pick(list(mom.color, dad.color, BlendRGB(mom.color, dad.color, 0.5)))
	marking_color = pick(list(mom.marking_color, dad.marking_color, BlendRGB(mom.marking_color, dad.marking_color, 0.5)))
	horn_color = pick(list(mom.horn_color, dad.horn_color, BlendRGB(mom.horn_color, dad.horn_color, 0.5)))
	eye_color =  pick(list(mom.eye_color, dad.eye_color, BlendRGB(mom.eye_color, dad.eye_color, 0.5)))
	skin_color =  pick(list(mom.skin_color, dad.skin_color, BlendRGB(mom.skin_color, dad.skin_color, 0.5)))
	marking_type =  pick(list(mom.marking_type, dad.marking_type, null))
	horn_type =  pick(list(mom.horn_type, dad.horn_type, null))


	if(mom.teppi_mutate || dad.teppi_mutate)
		teppi_mutate = TRUE
	else if(prob(1))
		teppi_mutate = TRUE
	mom.nutrition -= 500
	dad.nutrition -= 250
	mom.visible_message("\The [src] is born from [mom]... It's the miracle of life!", runemessage = "grunts")
	handle_affinity(mom, 26)	//this way the babies will follow their parents around (and keep track of them)
	handle_affinity(dad, 25)

//I ran a vote with the headmins, and this option won out considering the restrictions.
//I don't think this is a GOOD idea, but in pursuit of preserving Teppi's mechanical functionality while player controlled, there is a verb!
//This gives a strongly worded warning the first time you push the button, and has similar restrictons to AI controlled Teppi for use which will prevent spamming.
//
/mob/living/simple_mob/vore/alienanimals/teppi/proc/produce_offspring()
	set name = "Produce Offspring"
	set category = "Abilities.Teppi"
	set desc = "You can have babies if the conditions are right."
	if(prevent_breeding)
		to_chat(src, span_notice("You have elected to not participate in breeding mechanics, and so cannot complete that action."))
		return
	if(!teppi_warned)
		to_chat(src, span_danger("Be aware of your surroundings when using this verb. If you use this to be disruptive or prefbreak people, you are likely to eat a ban. If whoever's tending the teppi is trying to make more babies, or you're alone, or playing with other people who you know are into it, then sure. You should not however, for example, drag another teppi to the bar (or any public place) and drop a baby in the middle of the floor. If you're not sure if it's okay to do where you are, with whoever's around, it probably isn't. This is intended to preserve the mechanical utility of the mob you are playing as, not as a scene tool."))
		teppi_warned = TRUE
		return
	if(stat != CONSCIOUS)
		to_chat(src, span_notice("I can't do that right now..."))
		return
	if(!teppi_adult)
		to_chat(src, span_notice("I'm not old enough to make babies."))
		return
	if(baby_countdown > 0)
		to_chat(src, span_notice("It is not time yet..."))
		return
	if(!breedable || nutrition < 500)
		to_chat(src, span_notice("The conditions are not right to produce offspring."))
		return
	if(GLOB.teppi_count >= GLOB.max_teppi) //if we can't make more then we shouldn't look for partners
		to_chat(src, span_notice("I cannot produce more offspring at the moment, there are too many of us!"))
		return
	. = FALSE
	for(var/mob/living/simple_mob/vore/alienanimals/teppi/alltep in oview(1,src))
		if(!alltep.teppi_adult || alltep.nutrition < 250 || alltep.prevent_breeding || alltep.stat == DEAD)
			continue
		if(alltep)
			log_admin("[key_name_admin(src)] produced a baby teppi at [get_area(src)] - [COORD(src)]") //Won't show up in the chat, but makes a log of who's having babies where, for investigative purposes.
			new /mob/living/simple_mob/vore/alienanimals/teppi/baby(loc, src, alltep)
			baby_countdown = 400 //You don't have a random chance to deal with so the cooldown is twice as long.
			if(affinity[alltep.real_name])
				return
			handle_affinity(alltep, 30) //Mom and dad should like eachother when they do their business
			alltep.handle_affinity(src, 30)
			return
	if(. == FALSE)
		to_chat(src, span_notice("There are no suitable partners nearby."))

/mob/living/simple_mob/vore/alienanimals/teppi/proc/toggle_producing_offspring()
	set name = "Toggle Producing Offspring"
	set category = "Abilities.Teppi"
	set desc = "You can toggle whether or not you can produce offspring."
	if(!prevent_breeding)
		to_chat(src, span_notice("You disable breeding."))
		prevent_breeding = TRUE
	else
		to_chat(src, span_notice("You enable breeding."))
		prevent_breeding = FALSE

///////////////////AI Things////////////////////////
//Thank you very much Aronai <3

/mob/living/simple_mob/vore/alienanimals/teppi/proc/do_I_know_you()
	// Get list of everyone who can see us (which is everyone we can see, typically)
	var/list/people_nearby = oviewers(world.view, src)
	// Use the hidden . var to avoid needing to create a new local var (saves CPU)
	. = list()
	// Add everyone nearby to the list if they're in affinity, with key of the mob and value of the affinity
	// . becomes list(jane = 1, tim = -3) etc
	for(var/mob/living/M in people_nearby)
		var/their_affinity = affinity[M.real_name]
		if(their_affinity)
			if(their_affinity >= 25 || their_affinity <= -10)
				.[M] = affinity[M.real_name]
	// Sort the list (timsort default sort comperator is numeric ascending, so highest affinity will be last in the list)
	sortTim(., associative = TRUE)

/datum/ai_holder/simple_mob/teppi/handle_wander_movement()
	var/mob/living/simple_mob/vore/alienanimals/teppi/tepholder = holder
	if(tepholder.resting)
		if(prob(5))
			tepholder.lay_down()
		return
	// Copypasta from parent handle_wander_movement
	if(isturf(holder.loc) && can_act())
		if(--wander_delay > 0)
			return
		if(!wander_when_pulled && (holder.pulledby || holder.grabbed_by.len))
			ai_log("handle_wander_movement() : Being pulled and cannot wander. Exiting.", AI_LOG_DEBUG)
			return
	// We're having our chance NOW
	wander_delay = base_wander_delay
	// Typecast the ai_holder 'holder' var as a teppi so we can call do_I_know_you()
	var/list/affinity_nearby = tepholder.do_I_know_you()
	var/turf/T // Turf we might eventually move to
	// If we found any affinity people nearby
	if(affinity_nearby.len)
		// Extract the highest affinity person from the list, by taking the last item (the item at
		// position 6 in a list that's 6 length is the last item eg)
		var/mob/living/L = affinity_nearby[affinity_nearby.len]
		// If >= 0, wander towards
		if(affinity_nearby[L] >= 0)
			T = get_step_to(holder, L, 1)
		// Else wander away
		else
			T = get_step_away(holder, L)
	// Didn't find affinity people nearby, copypasta from normal wandering.
	// We don't call ..() because it'll perform some of the same work again and want to avoid that
	if(!T)
		if(prob(5))
			tepholder.lay_down()
			return
		var/moving_to = 0 // Apparently this is required or it always picks 4, according to the previous developer for simplemob AI.
		moving_to = pick(cardinal)
		holder.set_dir(moving_to)
		T = get_step(holder,moving_to)
	// Finally do move if we actually found somewhere we'd like to go
	if(T)
		holder.IMove(T)

/datum/ai_holder/simple_mob/teppi/handle_idle_speaking()
	if(holder.resting)
		return
	..()

/datum/ai_holder/simple_mob/teppi/baby/handle_idle_speaking()
	if(holder.resting)
		return
	..()

/datum/ai_holder/simple_mob/teppi/on_hear_say(mob/living/speaker, message)
	var/mob/living/simple_mob/vore/alienanimals/teppi/T = holder
	if(holder.client)
		return
	if(!speaker.client)
		return
	if(!T.teppi_adult)
		return
	var/speaker_affinity = T.affinity[speaker.real_name]
	message = html_decode(message)
	if(findtext(message, "lets go") || findtext(message, "let's go") || findtext(message, "come teppi") || findtext(message, "come [holder.name]"))
		if(speaker == leader)
			return
		if(!leader)
			if(speaker_affinity >= 100)
				set_follow(speaker, follow_for = 10 MINUTES)
				holder.visible_message(span_notice("\The [holder] starts following \the [speaker]"),span_notice("\The [holder] starts following you."))
				return
		else
			var/mob/living/L = leader
			if(!can_see_target(L))
				lose_follow()
				if(speaker_affinity >= 100)
					set_follow(speaker, follow_for = 10 MINUTES)
					holder.visible_message(span_notice("\The [holder] starts following \the [speaker]"),span_notice("\The [holder] starts following you."))
					return
			else if(speaker_affinity > T.affinity[L.real_name])
				holder.visible_message(span_notice("\The [holder] starts following \the [speaker]"),span_notice("\The [holder] starts following you."))
				set_follow(speaker, follow_for = 10 MINUTES)
				return
			if(speaker_affinity == T.affinity[L.real_name])
				lose_follow()
				holder.visible_message(span_notice("\The [holder] gives off an anxious whine."))
	if(findtext(message, "stop teppi") || findtext(message, "stay here") || findtext(message, "stop [holder.name]"))
		if(leader == speaker)
			lose_follow()
			holder.visible_message(span_notice("\The [holder] stops following \the [speaker]"),span_notice("\The [holder] stops following you."))
			return

//This a teppi with funny colors will spawn!
/mob/living/simple_mob/vore/alienanimals/teppi/mutant/New()
	teppi_mutate = TRUE
	. = ..()

//Custom teppi colors! For funzies.

/mob/living/simple_mob/vore/alienanimals/teppi/cass/New()
	inherit_colors = TRUE
	color = "#c69c85"
	marking_color = "#eeb698"
	horn_color = "#272523"
	eye_color = "#612c08"
	skin_color = "#272523"
	marking_type = "2"
	horn_type =  "0"
	. = ..()

/mob/living/simple_mob/vore/alienanimals/teppi/baby/cass/New()
	inherit_colors = TRUE
	color = "#c69c85"
	marking_color = "#eeb698"
	horn_color = "#272523"
	eye_color = "#612c08"
	skin_color = "#272523"
	marking_type = "2"
	horn_type =  "0"
	. = ..()

/mob/living/simple_mob/vore/alienanimals/teppi/aronai/New()
	inherit_colors = TRUE
	color = "#404040"
	marking_color = "#222222"
	horn_color = "#141414"
	eye_color = "#9f522c"
	skin_color = "#e16f2d"
	marking_type = "13"
	horn_type = "1"
	. = ..()

/mob/living/simple_mob/vore/alienanimals/teppi/lira/New()
	inherit_colors = TRUE
	color = "#fdfae9"
	marking_color = "#ffffc0"
	horn_color = "#ffc965"
	eye_color = "#1d7fb7"
	skin_color = "#f09ca9"
	marking_type = "13"
	horn_type = "0"
	. = ..()
