/datum/category_item/catalogue/fauna/woof
	name = "Wildlife - Dog"
	desc = "It's a relatively ordinary looking canine. \
	It has an ominous aura..."
	value = CATALOGUER_REWARD_EASY

/mob/living/simple_mob/vore/woof
	name = "dog"
	desc = "It is a relatively ordinary looking canine mutt! It radiates mischief!"
	tt_desc = "E Canis lupus softus"

	icon_state = "woof"
	icon_living = "woof"
	icon_dead = "woof_dead"
	icon_rest = "woof_rest"
	icon = 'icons/mob/vore.dmi'

	faction = "dog"
	maxHealth = 600
	health = 600
	movement_cooldown = 1

	response_help = "pets"
	response_disarm = "rudely paps"
	response_harm = "punches"

	harm_intent_damage = 5
	melee_damage_lower = 5
	melee_damage_upper = 1
	catalogue_data = list(/datum/category_item/catalogue/fauna/woof)

	var/knockdown_chance = 20

	min_oxy = 0
	max_oxy = 0
	min_tox = 0
	max_tox = 0
	min_co2 = 0
	max_co2 = 0
	min_n2 = 0
	max_n2 = 0
	minbodytemp = 0
	maxbodytemp = 900

	attacktext = list("nipped", "chomped", "bullied", "gnaws on")
	attack_sound = 'sound/voice/bork.ogg'
	friendly = list("snoofs", "nuzzles", "ruffs happily at", "smooshes on")

	ai_holder_type = /datum/ai_holder/simple_mob/woof

	mob_size = MOB_SMALL

	has_langs = list("Dog", "Canilunzt", "Galactic Common")
	say_list_type = /datum/say_list/softdog
	swallowTime = 0.1 SECONDS

/mob/living/simple_mob/vore/woof/New()
	..()

	verbs += /mob/living/proc/ventcrawl
	verbs += /mob/living/proc/hide

/datum/say_list/softdog
	speak = list("Woof~", "Woof!", "Yip!", "Yap!", "Yip~", "Yap~", "Awoooooo~", "Awoo!", "AwooooooooooOOOOOOoOooOoooOoOOoooo!")
	emote_hear = list("barks", "woofs", "yaps", "yips","pants", "snoofs")
	emote_see = list("wags its tail", "stretches", "yawns", "swivels its ears")
	say_maybe_target = list("Whuff?")
	say_got_target = list("Grrrr YIP YAP!!!")

/datum/ai_holder/simple_mob/woof
	hostile = FALSE
	cooperative = TRUE
	retaliate = TRUE
	speak_chance = 1
	wander = TRUE

// Activate Noms!
/mob/living/simple_mob/vore/woof
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
	vore_stomach_flavor = "You have found yourself pumping on down, down, down into this extremely soft dog. The slick touches of pulsing walls roll over you in greedy fashion as you're swallowed away, the flesh forms to your figure as in an instant the world is replaced by the hot squeeze of canine gullet. And in another moment a heavy GLLRMMPTCH seals you away, the dog tossing its head eagerly, the way forward stretching to accommodate your shape as you are greedily guzzled down. The wrinkled, doughy walls pulse against you in time to the creature's steady heartbeat. The sounds of the outside world muffled into obscure tones as the wet, grumbling rolls of this soft creature's gut hold you, churning you tightly such that no part of you is spared from these gastric affections."
	vore_default_contamination_flavor = "Wet"
	vore_default_contamination_color = "grey"
	vore_default_item_mode = IM_DIGEST


/mob/living/simple_mob/vore/woof/init_vore()
	..()
	var/obj/belly/B = vore_selected
	B.name = "stomach"
	B.desc = "You have found yourself pumping on down, down, down into this extremely soft dog. The slick touches of pulsing walls roll over you in greedy fashion as you're swallowed away, the flesh forms to your figure as in an instant the world is replaced by the hot squeeze of canine gullet. And in another moment a heavy GLLRMMPTCH seals you away, the dog tossing its head eagerly, the way forward stretching to accommodate your shape as you are greedily guzzled down. The wrinkled, doughy walls pulse against you in time to the creature's steady heartbeat. The sounds of the outside world muffled into obscure tones as the wet, grumbling rolls of this soft creature's gut hold you, churning you tightly such that no part of you is spared from these gastric affections."

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

/obj/item/projectile/awoo_missile
	name = "awoo missile"
	icon_state = "force_missile"
	fire_sound = 'sound/voice/long_awoo.ogg'
	damage = 1
	damage_type = BRUTE
	check_armour = "melee"

	impact_effect_type = /obj/effect/temp_visual/impact_effect/blue_laser
	hitsound_wall = 'sound/voice/bork.ogg'

/mob/living/simple_mob/vore/woof/cass
	name = "Cass"
	desc = "Well trained, comfy company. They have a pretty red bow tied into their fur. They look very soft."

	icon_state = "cass"
	icon_living = "cass"
	icon_dead = "cass_dead"
	icon_rest = "cass_rest"
	ic_revivable = 0

	faction = "theatre"
	gender = PLURAL
	ai_holder_type = /datum/ai_holder/simple_mob/woof/cass

/mob/living/simple_mob/vore/woof/cass
	vore_digest_chance = 0
	vore_escape_chance = 25
	digestable = 0

/datum/ai_holder/simple_mob/woof/cass
	retaliate = 0
	violent_breakthrough = 0

/datum/ai_holder/simple_mob/ranged/kiting/threatening/woof
	hostile = 1
	retaliate = 1
	cooperative = TRUE
	speak_chance = 1
	lose_target_timeout = 0 // Easily distracted

/datum/ai_holder/simple_mob/woof/hostile
	hostile = 1
	retaliate = 1

/mob/living/simple_mob/vore/woof/apply_melee_effects(var/atom/A)
	if(isliving(A))
		var/mob/living/L = A
		if(prob(knockdown_chance))
			L.Weaken(3)
			L.visible_message(span("danger", "\The [src] pounces on \the [L]!"))

/mob/living/simple_mob/vore/woof/hostile/melee

	movement_cooldown = 0

	ai_holder_type = /datum/ai_holder/simple_mob/woof/hostile

/mob/living/simple_mob/vore/woof/hostile/ranged

	ai_holder_type = /datum/ai_holder/simple_mob/ranged/kiting/threatening/woof

	projectiletype = /obj/item/projectile/awoo_missile
	projectilesound = 'sound/voice/long_awoo.ogg'

/mob/living/simple_mob/vore/woof/hostile/horrible

	ai_holder_type = /datum/ai_holder/simple_mob/ranged/kiting/threatening/woof
	armor = list(
			"melee" = 75,
			"bullet" = 75,
			"laser" = 75,
			"energy" = 75,
			"bomb" = 75,
			"bio" = 75,
			"rad" = 75)

	projectiletype = /obj/item/projectile/awoo_missile/heavy
	projectilesound = 'sound/voice/long_awoo.ogg'

/obj/item/projectile/awoo_missile/heavy
	damage = 50

/obj/item/projectile/forcebolt/harmless/awoobolt
	icon_state = "force_missile"
	fire_sound = 'sound/voice/long_awoo.ogg'
	damage = 0
	impact_effect_type = /obj/effect/temp_visual/impact_effect/blue_laser
	hitsound_wall = 'sound/voice/bork.ogg'

/mob/living/simple_mob/vore/woof/hostile/terrible

	ai_holder_type = /datum/ai_holder/simple_mob/ranged/kiting/threatening/woof

	projectiletype = /obj/item/projectile/forcebolt/harmless/awoobolt
	projectilesound = 'sound/voice/long_awoo.ogg'

/mob/living/simple_mob/vore/woof/cass/attack_hand(mob/living/carbon/human/M as mob)
	if(stat != DEAD)
		return ..()
	if(M.a_intent == I_HELP)
		M.visible_message("[M] pets [src].", runemessage = "pets [src]")
		if(do_after(M, 30 SECONDS, exclusive = TASK_USER_EXCLUSIVE, target = src))
			faction = M.faction
			revive()
			sight = initial(sight)
			see_in_dark = initial(see_in_dark)
			see_invisible = initial(see_invisible)
			update_icon()
			visible_message("[src] stops playing dead.", runemessage = "[src] stops playing dead")
		else
			M.visible_message("The petting was interrupted!!!", runemessage = "The petting was interrupted")
	return

/mob/living/simple_mob/vore/woof/hostile/aweful
	maxHealth = 100
	health = 100
	var/killswitch = FALSE


/mob/living/simple_mob/vore/woof/hostile/aweful/Initialize()
	. = ..()
	var/thismany = (rand(25,500)) / 100
	resize(thismany, animate = FALSE, uncapped = TRUE, ignore_prefs = TRUE)

/mob/living/simple_mob/vore/woof/hostile/aweful/death()
	. = ..()
	if(killswitch)
		visible_message("<span class='notice'>\The [src] evaporates into nothing...</span>")
		qdel(src)
		return
	var/thismany = rand(0,3)
	var/list/possiblewoofs = list(/mob/living/simple_mob/vore/woof/hostile/aweful/melee, /mob/living/simple_mob/vore/woof/hostile/aweful/ranged)
	if(thismany == 0)
		visible_message("<span class='notice'>\The [src] evaporates into nothing...</span>")
	if(thismany >= 1)
		var/thiswoof = pick(possiblewoofs)
		new thiswoof(loc, src)
		visible_message("<span class='warning'>Another [src] appears!</span>")
	if(thismany >= 2)
		var/thiswoof = pick(possiblewoofs)
		new thiswoof(loc, src)
		visible_message("<span class='warning'>Another [src] appears!</span>")
	if(thismany >= 3)
		var/thiswoof = pick(possiblewoofs)
		new thiswoof(loc, src)
		visible_message("<span class='warning'>Another [src] appears!</span>")
	qdel(src)

/mob/living/simple_mob/vore/woof/hostile/aweful/melee

	movement_cooldown = 0

	ai_holder_type = /datum/ai_holder/simple_mob/woof/hostile

/mob/living/simple_mob/vore/woof/hostile/aweful/ranged
	movement_cooldown = 0

	ai_holder_type = /datum/ai_holder/simple_mob/ranged/kiting/threatening/woof

	projectiletype = /obj/item/projectile/awoo_missile
	projectilesound = 'sound/voice/long_awoo.ogg'
