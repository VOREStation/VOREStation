//formerly meat things

/datum/category_item/catalogue/fauna/woof
	name = "Wildlife - Dog"
	desc = "It's a relatively ordinary looking canine. \
	It has an ominous aura..."
	value = CATALOGUER_REWARD_TRIVIAL

/mob/living/simple_mob/vore/alienanimals/teppi
	name = "teppi"
	desc = "Soft should write a description."
	tt_desc = "Soft should make something up"

	icon_state = "teppi"
	icon_living = "body_base"
	icon_dead = "body_dead"
	icon_rest = "body_rest"
	icon = 'icons/mob/alienanimals_x64.dmi'
	pixel_x = -16
	default_pixel_x = -16

	faction = "teppi"
	maxHealth = 600
	health = 600
	movement_cooldown = 2

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

	var/affinity = list()
	var/allergen_preference
	var/allergen_unpreference
	var/body_color
	var/marking_color
	var/horn_color
	var/eye_color
	var/skin_color
	var/marking_type
	var/static/list/overlays_cache = list()
	var/teppi_grown = FALSE


	attacktext = list("nipped", "chomped", "bonked", "stamped on")
	//attack_sound = 'sound/voice/bork.ogg' // make a better one idiot
	friendly = list("snoofs", "nuzzles", "nibbles", "smooshes on")

	ai_holder_type = /datum/ai_holder/simple_mob/teppi

	mob_size = MOB_LARGE

	has_langs = list("Teppi", "Galactic Common")
	say_list_type = /datum/say_list/teppi

/////////////////////////////////////// Vore stuff///////////////////////////////////////////

	swallowTime = 1 SECONDS
	vore_active = 1
	vore_capacity = 3
	vore_bump_chance = 5
	vore_bump_emote	= "greedily homms at"
	vore_digest_chance = 1
	vore_absorb_chance = 5
	vore_escape_chance = 10
	vore_pounce_chance = 5
	vore_ignores_undigestable = 0
	vore_default_mode = DM_HOLD
	vore_icons = SA_ICON_LIVING
	vore_stomach_name = "Stomach"
	vore_stomach_flavor = "Soft should write a tummy message."
	vore_default_contamination_flavor = "Wet"
	vore_default_contamination_color = "grey"
	vore_default_item_mode = IM_DIGEST

/mob/living/simple_mob/vore/alienanimals/teppi/init_vore()
	..()
	var/obj/belly/B = vore_selected
	B.name = "stomach"
	B.desc = "Soft should write a tummy message."
	B.mode_flags = 8
	B.belly_fullscreen = "yet_another_tumby"

/*  Do custom text for them idiot

	B.emote_lists[DM_HOLD] = list(
		"You can feel yourself shift and sway as the dog moves around. Your figure held tightly there had little room to move in that organic gloom, but every wandering step is another jostling quake that shakes through the canine frame and rocks you once again.",
		"It is hard to hear much of anything over the grumbling fleshy sounds of the stomach walls pressing to you. The wet sound of flesh gliding over you too was ever-present as the walls encroach upon your personal space. And beyond that, the steady booming of the dog's heart throbs in your ears, a relaxing drone of excited thumping. Any sounds from the outside world are muffled such that they are hard to hear, as the canine walls hold on to you greedily.",
		"You can hear the vague dragging, creaking sounds of the flesh holding you stretching and compressing with the dog's movements. Any time you press out, the walls seem to groan and flex in to smother you heavily for a few moments. ",
		"When you shift your weight to try to find a more comfortable position you can feel your weight stretch the chamber around you a little more, and it responds by collapsing in on you more tightly! Forming to you with heavily insistence, grinding against your curves. Holding you firmly for a few moments, before slowly relaxing...",
		"The heat of the dog's body soaks into your form and relaxes your muscles. It's easy to let yourself go limp, to be squeezed and carried by this soft predator. The sway of its body, the swing of its gait, all enough to lull anyone who likes such things into a deeply relaxed state, as you're rocked and supported, squeezed deep within the gut of this woof. Possessively held, kept.",
		"Thick slime soaks your form as the dog's insides churn over you. There is no part of you that is not totally soaked in it before too long as the steady gastric motions massage you from head to toe. Any pushes or squirms only get the affected flesh to cling more tightly, and to press back. It's very hard to get any personal space!",
		"Beyond the grumbling gurgles and the ever-present drumming of the dog's heart, you can actually hear, more faintly, the whooshing of the canine's breath. The slow draw in coming with a vague tightening of your surroundings, while the dog's soft, whooshing exhales make your surroundings more relaxed, easy to sink in against.")

	B.emote_lists[DM_ABSORB] = list(
		"You can feel the weight of the dog shift as it moves around. Your figure held tightly there had absolutely no room to move in that organic gloom. Every moment those pumping walls seem to squeeze over you tighter, every wandering step the dog takes is another jostling quake that seems to sink you that much deeper into the dog's flesh, the dog's body steadily collapsing in to claim you.",
		"It is hard to hear much of anything over the smothering press of stomach walls pressing to you, forming to your features. The tarry flesh you are slowly sinking into squelches here and there as it flows over your features. The sound of the dog's body absorbing you is oddly quiet. No bubbling or glooping. Just one body slowly blending into and becoming one with another. And beyond all that, the steady booming of the dog's heart throbs in your ears, moment by moment that sound seems to tug at you, coursing through you as much as the dog you are steadily becoming a part of. Any sounds from the outside world are muffled such that they are hard to hear, as you sink into the walls of this canine predator.",
		"You can hear the vague dragging, creaking sounds of the flesh holding you stretching and compressing with the dog's movements. Any time you press out, the walls seem to simply flow over you, and allow whatever pushed out to sink in that much more. The swell on the dog's tummy shrinking that much faster... ",
		"When you shift your weight to try to get some space. you can feel your weight simply sink into that flesh, the folds forming around you tightly, and the deeper you sink, the harder it gets to move. The pressure never seems to let up as the tide of flesh holding you slowly overcomes your form.",
		"As the seemingly molten heat of this dog's flesh flows over you, it's easy to let yourself go limp, to just give in and become one with this creature that so obviously wanted you, and indeed, unless something happened to stop this, you soon would be... The dog tail swaying in a knowing arc as you are added to its figure. Squeezed, tucked away, kept.",
		"The thick slimes that coat your form do nothing to keep the molten flesh of this dog's stomach from advancing across your figure and claiming you up. Soon there's not a single part of you that is not totally inundated in the deep press of a woof's  gastric massage. Any pushes or squirms only get the affected flesh to cling more tightly, and to press back, flowing over your form, deeper, deeper.",
		"Beyond the squelching, clinging tide of dog flesh working to make the two of you one, and the ever-present drumming of the dog's heart, you can actually hear, more faintly, the whooshing of the canine's breath. The slow draw in coming with a vague tightening of your surroundings, while the dog's soft, whooshing exhales make your surroundings more relaxed. And you realize suddenly that the dog's breathing seem to bring you relief even as you are totally smothered in the canine's insistent gastric affections!")

	B.emote_lists[DM_DIGEST] = list(
		"As the dog goes about its business, you can feel the shift your weight sway on its tummy. The gurgling glorping sounds that come with the squeezing, kneading, massaging motions let you know that you're held tight, churned. Dog food.",
		"It is hard to hear much of anything over the roaring gurgles of stomach walls churning over you. The wet sound of flesh grinding heavily over you too was ever-present as the walls encroach upon your personal space, lathering you in tingly, syrupy thick slimes. And beyond that, the steady booming of the dog's heart throbs in your ears, a drone of excited thumping. Any sounds from the outside world are muffled such that they are hard to hear, as the canine walls churn on to you greedily.",
		"You can hear the vague dragging, creaking sounds of the flesh holding you stretching and compressing with the dog's movements. The walls seem to constantly flex and squeeze across you, pressing in against you, massaging thick slime into your figure, steadily trying to soften up your outer layers...",
		"When you try to shift your weight to try to find a more comfortable position, you find that those heavy walls pumping over you make it hard to move at all. You can feel the weight of the dog pressing in all around you even without those muscles flexing and throbbing across your form. It forms to you with heavily insistence, grinding against your curves, churning that bubbling gloop into you. Holding you firm and heavy as that stomach does its work...",
		"The heat of the dog's body soaks into your form and relaxes your muscles. It's easy to let yourself go limp, to just completely give in to this soft predator. The sway of its body, the swing of its gait, all enough to lull anyone who likes such things into a deeply relaxed state. Churned and slathered, massaged by doughy wrinkled walls deep within the gut of this woof. Possessively held within that needy chamber.",
		"Thick slime soaks your form as the dog's insides churn over you. There is no part of you that is not totally soaked in it before too long as the steady gastric motions massage you from head to toe. Any pushes or squirms only get the affected flesh to cling more tightly, and to press back. It's very hard to get any personal space!",
		"Beyond the grumbling gurgles and the ever-present drumming of the dog's heart, you can actually hear, more faintly, the whooshing of the canine's breath. The slow draw in coming with a vague tightening of your surroundings, while the dog's soft, whooshing exhales make your surroundings more relaxed, easy to sink in against. Occasionally though everything would go all tight and cramped! And somewhere up above you can hear the dog let out a dainty little belch...")

	B.digest_brute = 0.05
	B.digest_burn = 0.05
	B.mode_flags = 8
	B.belly_fullscreen = "a_tumby"
	B.struggle_messages_inside = list(
		"Your struggling only causes %pred's doughy gut to smother you against those wrinkled walls...",
		"As you squirm, %pred's %belly flexxes over you heavily, forming you back into a small ball...",
		"You push out at those heavy wrinkled walls with all your might and they collapse back in on you! Clinging and churning over you heavily for a few minutes!!!",
		"As you struggle against the gut of this dog, you can feel a squeeze roll over you from the bottom to the top! The walls cling to you a little tighter then as the dog emits a soft little burp...",
		"You try to squirm, but you can't even move as those heavy walls throb and pulse and churn around you.",
		"You paddle against the fleshy walls of %pred's %belly, making a little space for yourself for a moment, before the wrinkled surface bounces back against you.",
		"The slick walls are doughy, smushy under your fingers, and very difficult to grip!  The flesh pulses under your grip in time with %pred's heartbeat.",
		"Your hands slip and slide over the slick slimes of %pred's %belly as you struggle to escape! The walls pulse and squeeze around you greedily.",
		"%pred lets out a happy little awoo, rocking their hips to jostle you as you squirm, while the weight of those walls closes in on you, squeezing you tightly!",
		"%pred's %belly glorgles around you as you push and struggle within! The squashy walls are always reluctant to give ground, and the moment your struggles lax, they redouble their efforts in smothering all the fight out of you!")
	B.struggle_messages_outside = list(
		"A vague shape briefly swells on %pred's %belly as something moves inside...",
		"Something shifts within %pred's %belly.",
		"%pred urps as something shifts in their %belly.")
	B.examine_messages = list(
		"Their %belly is distended.",
		"Vague shapes swell their %belly.",
		"It looks like they have something solid in their %belly")
*/

///////////////////////////////////////Other stuff///////////////////////////////////////////

/mob/living/simple_mob/vore/alienanimals/teppi/Initialize()
	. = ..()
	
	if(name == initial(name))
		name = "[name] ([rand(1, 1000)])"
		real_name = name

	icon_state = "body"
	teppi_setup()

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


	if(!teppi_grown)
		allergen_preference = pick(possibleallergens) //the good shit
		allergen_unpreference = pick(possibleallergens - allergen_preference) //I don't want that
		color = pickweight(possiblebody)
		marking_color = pickweight(possiblemarking)
		horn_color = pickweight(possiblehorns)
		eye_color = pickweight(possibleeyes)
		skin_color = pickweight(possibleskin)
	if(!marking_type)
		marking_type = "[rand(0,9)]" //the babies don't have this set up by default, but they might pick it from their parents
	
	update_icon()

/mob/living/simple_mob/vore/alienanimals/teppi/proc/teppi_icon()
	var/marking_key = "marking-[marking_color]"
	var/horn_key = "horn-[horn_color]"
	var/eye_key = "eye-[eye_color]"
	var/skin_key = "skin-[skin_color]"

	var/our_state = "base"	//For helping the images know what icon state they should be grabbing
	if(icon_state == icon_living)
		our_state = "base"
	if(icon_state == icon_rest)
		our_state = "rest"
	if(icon_state == icon_dead)
		our_state = "dead"
	var/life_stage = "adult"
	if(icon != 'icons/mob/alienanimals_x64.dmi')
		life_stage = "baby"

	var/combine_key = marking_key+our_state+marking_type+life_stage
	var/image/marking_image = overlays_cache[combine_key]
	if(!marking_image)
		marking_image = image(icon,null,"marking_[our_state][marking_type]")
		marking_image.color = marking_color
		marking_image.appearance_flags = RESET_COLOR|KEEP_APART
		overlays_cache[combine_key] = marking_image
	add_overlay(marking_image)

	var/image/horn_image = overlays_cache[horn_key+our_state+life_stage]
	if(!horn_image)
		horn_image = image(icon,null,"horn_[our_state]")
		horn_image.color = horn_color
		horn_image.appearance_flags = RESET_COLOR|KEEP_APART
		overlays_cache[horn_key+our_state+life_stage] = horn_image
	add_overlay(horn_image)

	var/image/eye_image = overlays_cache[eye_key+our_state+life_stage]
	if(!eye_image)
		eye_image = image(icon,null,"eye_[our_state]")
		eye_image.color = eye_color
		eye_image.appearance_flags = RESET_COLOR|KEEP_APART
		overlays_cache[eye_key+our_state+life_stage] = eye_image
	add_overlay(eye_image)

	var/image/skin_image = overlays_cache[skin_key+our_state+life_stage]
	if(!skin_image)
		skin_image = image(icon,null,"skin_[our_state]")
		skin_image.color = skin_color
		skin_image.appearance_flags = RESET_COLOR|KEEP_APART
		overlays_cache[skin_key+our_state+life_stage] = skin_image
	add_overlay(skin_image)

/mob/living/simple_mob/vore/alienanimals/teppi/attackby(var/obj/item/O as obj, var/mob/user as mob)
	if(istype(O, /obj/item/weapon/reagent_containers/food))
		if(nutrition < 5000)
			var/yum = O.reagents?.get_reagent_amount("nutriment") //does it have nutriment, if so how much?
			if(yum)
				yum *= 30
				for(var/datum/reagent/R as anything in O.reagents?.reagent_list)
					if(R.allergen_type & allergen_preference)
						yum *= 2
						user.visible_message("<font color='blue'>[user] feeds [O] to [name]. It nibbles [O] excitedly.</font>","<font color='blue'>You feed [O] to [name]. It nibbles [O] excitedly.</font>")
					else if(R.allergen_type & allergen_unpreference)
						yum *= 0.5
						user.visible_message("<font color='blue'>[user] feeds [O] to [name]. It nibbles [O] slowly.</font>","<font color='blue'>You feed [O] to [name]. It nibbles [O] slowly.</font>")
					else
						user.visible_message("<font color='blue'>[user] feeds [O] to [name]. It nibbles [O].</font>","<font color='blue'>You feed [O] to [name]. It nibbles [O].</font>")
				adjust_nutrition(yum) //add the nutriment!
			else
				user.visible_message("<font color='blue'>[user] feeds [O] to [name]. It nibbles [O] casually.</font>","<font color='blue'>You feed [O] to [name]. It nibbles [O] casually.</font>")
			user.drop_from_inventory()
			qdel(O)
			return
		else
			user.visible_message("<font color='blue'>[user] tries to feed [O] to [name]. It snoofs but does not eat.</font>","<font color='blue'>You try to feed [O] to [name], but it only snoofts at it.</font>")
			return
	return ..()

/mob/living/simple_mob/vore/alienanimals/teppi/update_icon()
	..()
	teppi_icon()	

/datum/say_list/teppi
	speak = list("Woof~", "Woof!", "Yip!", "Yap!", "Yip~", "Yap~", "Awoooooo~", "Awoo!", "AwooooooooooOOOOOOoOooOoooOoOOoooo!")
	emote_hear = list("barks", "woofs", "yaps", "yips","pants", "snoofs")
	emote_see = list("wags its tail", "stretches", "yawns", "swivels its ears")
	say_maybe_target = list("Whuff?")
	say_got_target = list("Grrrr YIP YAP!!!")

/datum/ai_holder/simple_mob/teppi

	hostile = FALSE
	cooperative = TRUE
	retaliate = TRUE
	speak_chance = 1
	wander = TRUE

/datum/language/teppi
	name = "Teppi"
	desc = "The language of the meat things."
	speech_verb = "barks"
	ask_verb = "woofs"
	exclaim_verb = "howls"
	key = "T"
	flags = RESTRICTED
	machine_understands = 0
	space_chance = 100
	syllables = list("bark", "woof", "bowwow", "yap", "arf")

////////////////// Da babby //////////////

/mob/living/simple_mob/vore/alienanimals/teppi/baby
	name = "teppi"
	desc = "Soft should write a description."
	tt_desc = "Soft should make something up"

	icon_state = "teppi"
	icon_living = "body_base"
	icon_dead = "body_dead"
	icon_rest = "body_rest"
	icon = 'icons/mob/alienanimals_x32.dmi'
	pixel_x = 0
	default_pixel_x = 0

	faction = "teppi"
	maxHealth = 50
	health = 50
	movement_cooldown = 4

	response_help = "pets"
	response_disarm = "rudely paps"
	response_harm = "punches"

	harm_intent_damage = 5
	melee_damage_lower = 1
	melee_damage_upper = 5

	var/amount_grown = 0


/mob/living/simple_mob/vore/alienanimals/teppi/baby/Life()
	. =..()
	if(!.)
		return
	amount_grown += rand(1,5) //how much to grow
	if(amount_grown >= 1000) //when do we grow up
		new /mob/living/simple_mob/vore/alienanimals/teppi(loc, src) //spawn the adult teppi, give it a reference to baby's location and baby
		qdel(src) // delete baby

/mob/living/simple_mob/vore/alienanimals/teppi/New(newloc, baby) //you want to spawn a new adult teppi?
	if(baby) //is there a reference from the baby?
		inherit_from_baby(baby) //okay, take the things we need from be baby before setting up the rest of the adult
	..() //set up everything else


/mob/living/simple_mob/vore/alienanimals/teppi/proc/inherit_from_baby(mob/living/simple_mob/vore/alienanimals/teppi/baby/baby)
	teppi_grown = TRUE
	dir = baby.dir
	name = baby.name
	real_name = baby.real_name
	affinity = baby.affinity
	allergen_preference = baby.allergen_preference
	allergen_unpreference = baby.allergen_unpreference
	color = baby.color
	marking_color = baby.marking_color
	horn_color = baby.horn_color
	eye_color = baby.eye_color
	skin_color = baby.skin_color
	ghostjoin = 1
	ghostjoin_icon()
	active_ghost_pods |= src
	update_icon()