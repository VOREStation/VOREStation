//No relation to slugcat :)

/datum/category_item/catalogue/fauna/catslug
	name = "Alien Wildlife - Catslug"
	desc = "The Catslug is an omnivorous terrestrial creature.\
	Exhibiting properties of both a cat and a slug (hence its name)\
	it moves somewhat awkwardly. However, the unique qualities of\
	its body make it exceedingly flexible and smooth, allowing it to\
	wiggle into and move effectively in even extremely tight spaces.\
	Additionally, it has surprisingly capable hands, and moves quite\
	well on two legs or four. Caution is advised when interacting\
	with these creatures, they are quite intelligent, and proficient\
	tool users."
	value = CATALOGUER_REWARD_MEDIUM

/mob/living/simple_mob/vore/alienanimals/catslug
	name = "catslug"
	desc = "A noodley bodied creature with thin arms and legs, and gloomy dark eyes."
	tt_desc = "Mollusca Feline" 	
	icon_state = "catslug"
	icon_living = "catslug"
	icon_dead = "catslug_dead"
	icon_rest = "catslug_rest"
	icon = 'icons/mob/alienanimals_x32.dmi'

	faction = "catslug"
	maxHealth = 50
	health = 50
	movement_cooldown = 2
	meat_amount = 2
	meat_type = /obj/item/weapon/reagent_containers/food/snacks/meat
	holder_type = /obj/item/weapon/holder/catslug

	response_help = "hugs"
	response_disarm = "rudely paps"
	response_harm = "punches"

	harm_intent_damage = 2
	melee_damage_lower = 2
	melee_damage_upper = 5

	has_hands = TRUE
	mob_size = MOB_SMALL
	friendly = list("hugs")
	see_in_dark = 8

	catalogue_data = list(/datum/category_item/catalogue/fauna/catslug)
	ai_holder_type = /datum/ai_holder/simple_mob/melee/evasive/catslug
	say_list_type = /datum/say_list/catslug
	player_msg = "You have escaped the foul weather, into this much more pleasant place. You are an intelligent creature capable of more than most think. You can pick up and use many things, and even carry some of them with you into the vents, which you can use to move around quickly. You're quiet and capable, you speak with your hands and your deeds! <br>- - - - -<br> <span class='notice'>Keep in mind, your goal should generally be to survive. You're expected to follow the same rules as everyone else, so don't go self antagging without permission from the staff team, but you are able and capable of defending yourself from those who would attack you for no reason.</span>"
	
	has_langs = list("Sign Language")

	var/picked_color = FALSE

	can_enter_vent_with = list(
		/obj/item/weapon/implant,
		/obj/item/device/radio/borg,
		/obj/item/weapon/holder,
		/obj/machinery/camera,
		/obj/belly,
		/obj/screen,
		/atom/movable/emissive_blocker,
		/obj/item/weapon/material,
		/obj/item/weapon/melee,
		/obj/item/stack/,
		/obj/item/weapon/tool,
		/obj/item/weapon/reagent_containers/food,
		/obj/item/weapon/coin,
		/obj/item/weapon/aliencoin,
		/obj/item/weapon/ore,
		/obj/item/weapon/disk/nuclear,
		/obj/item/toy,
		/obj/item/weapon/card,
		/obj/item/device/radio,
		/obj/item/device/perfect_tele_beacon,
		/obj/item/weapon/clipboard,
		/obj/item/weapon/paper,
		/obj/item/weapon/pen,
		/obj/item/canvas,
		/obj/item/paint_palette,
		/obj/item/paint_brush,
		/obj/item/device/camera,
		/obj/item/weapon/photo,
		/obj/item/device/camera_film,
		/obj/item/device/taperecorder,
		/obj/item/device/tape
		)

	vore_active = 1
	vore_capacity = 1
	vore_bump_chance = 1
	vore_ignores_undigestable = 0
	vore_default_mode = DM_DIGEST
	vore_icons = SA_ICON_LIVING
	vore_stomach_name = "Stomach"
	vore_default_contamination_flavor = "Wet"
	vore_default_contamination_color = "grey"
	vore_default_item_mode = IM_DIGEST

/datum/say_list/catslug	//Quiet quiet, no noise! We speak in sign so only people with sign will understand our questions.
	speak = list("Have any porl?", "What is that?", "Where is this?", "What are you doing?", "How did you get here?", "Don't go into the rain.")
	emote_hear = list()
	emote_see = list("turns their head.", "looks at you.", "watches something unseen.", "sways its tail.", "flicks its ears.", "stares at you.", "gestures an unintelligible message.", "points into the distance!")
	say_maybe_target = list()
	say_got_target = list()

/mob/living/simple_mob/vore/alienanimals/catslug/init_vore()
	..()
	var/obj/belly/B = vore_selected
	B.name = "stomach"
	B.desc = "The hot slick gut of a catslug!! Copious slime smears over you as you’re packed away into the gloom and oppressive humidity of this churning gastric sac. The pressure around you is intense, the squashy flesh bends and forms to your figure, clinging to you insistently! There’s basically no free space at all as your ears are filled with the slick slide of flesh against flesh and the burbling of gastric juices glooping all around you. The thumping of a heart booms from somewhere nearby, making everything pulse in against you in time with it! This is it! You’ve been devoured by a catslug!!!"
	B.mode_flags = 40
	B.belly_fullscreen = "yet_another_tumby"
	B.digest_brute = 0.5
	B.digest_burn = 0.5
	B.digestchance = 10
	B.absorbchance = 1
	B.escapechance = 15

/datum/ai_holder/simple_mob/melee/evasive/catslug
	hostile = FALSE
	cooperative = FALSE
	retaliate = TRUE
	speak_chance = 0.5
	wander = TRUE

/mob/living/simple_mob/vore/alienanimals/catslug/Initialize()
	. = ..()
	verbs += /mob/living/proc/ventcrawl
	verbs += /mob/living/proc/hide
	verbs += /mob/living/simple_mob/vore/alienanimals/catslug/proc/catslug_color

/mob/living/simple_mob/vore/alienanimals/catslug/attackby(var/obj/item/weapon/reagent_containers/food/snacks/O as obj, var/mob/user as mob)
	if(!istype(O, /obj/item/weapon/reagent_containers/food/snacks))
		return ..()
	if(resting)
		to_chat(user, "<span class='notice'>\The [src] is napping, and doesn't respond to \the [O].</span>")
		return
	if(nutrition >= max_nutrition)
		if(user == src)
			to_chat(src, "<span class='notice'>You're too full to eat another bite.</span>")
			return
		to_chat(user, "<span class='notice'>\The [src] seems too full to eat.</span>")
		return
	var/nutriment_amount = O.reagents?.get_reagent_amount("nutriment") //does it have nutriment, if so how much?
	var/protein_amount = O.reagents?.get_reagent_amount("protein") //does it have protein, if so how much?
	var/glucose_amount = O.reagents?.get_reagent_amount("glucose") //does it have glucose, if so how much?
	var/yum = nutriment_amount + protein_amount + glucose_amount
	if(yum)
		yum = (yum * 20) / 3
		adjust_nutrition(yum) //add the nutriment!
	O.bitecount ++
	if(O.bitecount >= 3)
		user.drop_from_inventory(O)
		qdel(O)
		visible_message("<span class='notice'>\The [src] eats \the [O].</span>")
	else
		to_chat(user, "<span class='notice'>\The [src] takes a bite of \the [O].</span>")
		if(user != src)
			to_chat(user, "<span class='notice'>\The [user] feeds \the [O] to you.</span>")
	playsound(src, 'sound/items/eatfood.ogg', 75, 1)
	
/mob/living/simple_mob/vore/alienanimals/catslug/attack_hand(mob/living/carbon/human/M as mob)
	
	if(stat == DEAD)
		return ..()
	if(M.a_intent != I_HELP)
		return ..()
	playsound(src, 'sound/weapons/thudswoosh.ogg', 50, 1, -1)
	if(resting)
		M.visible_message("<span class='notice'>\The [M.name] shakes \the [src] awake from their nap.</span>","<span class='notice'>You shake \the [src] awake!</span>")
		lay_down()
		ai_holder.go_wake()
		return
	if(M.zone_sel.selecting == BP_HEAD)
		M.visible_message( \
			"<span class='notice'>[M] pats \the [src] on the head.</span>", \
			"<span class='notice'>You pat \the [src] on the head.</span>", )
		if(client)
			return
		if(prob(10))
			visible_message("<span class='notice'>\The [src] purrs and leans into [M]'s hand.</span>")
	else if(M.zone_sel.selecting == BP_R_HAND || M.zone_sel.selecting == BP_L_HAND)
		M.visible_message( \
			"<span class='notice'>[M] shakes \the [src]'s hand.</span>", \
			"<span class='notice'>You shake \the [src]'s hand.</span>", )
		if(client)
			return
		if(prob(10))
			visible_message("<span class='notice'>\The [src]'s looks a little confused nibbles at [M]'s hand experimentally.</span>")
	else if(M.zone_sel.selecting == "mouth")
		M.visible_message( \
			"<span class='notice'>[M] boops \the [src]'s nose.</span>", \
			"<span class='notice'>You boop \the [src] on the nose.</span>", )
		if(client)
			return
		if(prob(10))
			visible_message("<span class='notice'>\The [src]'s eyes widen as they stare at [M]. After a moment they rub their prodded snoot.</span>")
	else if(M.zone_sel.selecting == BP_GROIN)
		M.visible_message( \
			"<span class='notice'>[M] rubs \the [src]'s tummy...</span>", \
			"<span class='notice'>You rub \the [src]'s tummy... You feel the danger.</span>", )
		if(client)
			return
		visible_message("<span class='notice'>\The [src] pushes [M]'s hand away from their tummy and furrows their brow!</span>")
		if(prob(5))
			ai_holder.target = M
			ai_holder.track_target_position()
			ai_holder.set_stance(STANCE_FIGHT)
	else
		return ..()

/mob/living/simple_mob/vore/alienanimals/catslug/Login()	//If someone plays as us let's just be a passive mob in case accidents happen if the player D/Cs	
	. = ..()
	ai_holder.hostile = FALSE
	ai_holder.wander = FALSE

/mob/living/simple_mob/vore/alienanimals/catslug/proc/catslug_color()
	set name = "Pick Color"
	set category = "Abilities"
	set desc = "You can set your color!"
	if(picked_color)
		to_chat(src, "<span class='notice'>You have already picked a color! If you picked the wrong color, ask an admin to change your picked_color variable to 0.</span>")
		return
	var/newcolor = input(usr, "Choose a color.", "", color) as color|null
	if(newcolor)
		color = newcolor
	picked_color = TRUE

/datum/ai_holder/simple_mob/melee/evasive/catslug/proc/consider_awakening()
	if(holder.resting)
		holder.lay_down()
		go_wake()

/datum/ai_holder/simple_mob/melee/evasive/catslug/handle_wander_movement()
	if(holder.client || holder.resting)
		return
	else if(prob(0.5))
		holder.lay_down()
		go_sleep()
		addtimer(CALLBACK(src, .proc/consider_awakening), rand(1 MINUTE, 5 MINUTES), TIMER_UNIQUE|TIMER_OVERRIDE|TIMER_STOPPABLE)
	else 
		return ..()


/datum/ai_holder/simple_mob/melee/evasive/catslug/on_hear_say(mob/living/speaker, message)
	if(holder.client || !speaker.client)
		return
	if(findtext(message, "psps") && stance == STANCE_IDLE)
		set_follow(speaker, follow_for = 5 SECONDS)

	if(holder.stat || !holder.say_list || !message || speaker == holder)	//Copied from parrots
		return
	var/datum/say_list/S = holder.say_list
	S.speak |= message


/mob/living/simple_mob/vore/alienanimals/catslug/horrible
	ai_holder_type = /datum/ai_holder/simple_mob/melee/evasive/catslug/horrible

/datum/ai_holder/simple_mob/melee/evasive/catslug/horrible/on_hear_say(mob/living/speaker, message)	//this was an accident originally but it was very funny so here you go
	if(holder.client || !speaker.client)
		return
	if(findtext(message, "psps") || stance == STANCE_IDLE)
		set_follow(speaker, follow_for = 5 SECONDS)

	if(holder.stat || !holder.say_list || !message || speaker == holder)	//Copied from parrots
		return
	var/datum/say_list/S = holder.say_list
	S.speak |= message

/obj/item/weapon/holder/catslug
	origin_tech = list(TECH_BIO = 2)
	icon = 'icons/mob/alienanimals_x32.dmi'
	item_state = "catslug"

/obj/item/weapon/holder/catslug/Initialize(mapload, mob/held)
	. = ..()
	color = held.color

/datum/category_item/catalogue/fauna/catslug/spaceslug
	name = "Alien Wildlife - Catslug - Miros"
	desc = "This catslug serves as the Fuel Depots resident attendant,\
	despite the facility being fully automated and self-serve. - \
	The Catslug is an omnivorous terrestrial creature.\
	Exhibiting properties of both a cat and a slug (hence its name)\
	it moves somewhat awkwardly. However, the unique qualities of\
	its body make it exceedingly flexible and smooth, allowing it to\
	wiggle into and move effectively in even extremely tight spaces.\
	Additionally, it has surprisingly capable hands, and moves quite\
	well on two legs or four. Caution is advised when interacting\
	with these creatures, they are quite intelligent, and proficient\
	tool users."
	value = CATALOGUER_REWARD_MEDIUM	//Should offer a measure of incentive for people to visit the depot more often.

/mob/living/simple_mob/vore/alienanimals/catslug/spaceslug
	name = "Miros"
	desc = "Looks like catslugs can into space after all! This little chap seems to have gotten their mitts on a tiny spacesuit, there's a nametag on it that reads \"Miros\" alongside the Aether Atmospherics logo."
	tt_desc = "Mollusca Felis Stellaris"
	icon_state = "spaceslug"
	icon_living = "spaceslug"
	icon_rest = "spaceslug_rest"
	icon_dead = "spaceslug_dead"
	digestable = 0
	catalogue_data = list(/datum/category_item/catalogue/fauna/catslug/spaceslug)
	holder_type = /obj/item/weapon/holder/catslug/spaceslug
	makes_dirt = 0
	say_list_type = /datum/say_list/catslug/spaceslug
	
	minbodytemp = 0				// Shamelessly stolen temp & atmos tolerances from the space cat.
	maxbodytemp = 900			
	heat_damage_per_tick = 3	
	cold_damage_per_tick = 2
	
	min_oxy = 0
	max_oxy = 0
	min_tox = 0
	max_tox = 0
	min_co2 = 0
	max_co2 = 0
	min_n2 = 0
	max_n2 = 0
	
	player_msg = "You are an intelligent creature capable of more than most think, clad in a spacesuit that protects you from the ravages of vacuum and hostile atmospheres alike. You can pick up and use many things, and even carry some of them with you into the vents, which you can use to move around quickly. You're quiet and capable, you speak with your hands and your deeds! <br>- - - - -<br> <span class='notice'>Keep in mind, your goal should generally be to survive. You're expected to follow the same rules as everyone else, so don't go self antagging without permission from the staff team, but you are able and capable of defending yourself from those who would attack you for no reason.</span>"
	
	has_langs = list("Sign Language")

/datum/say_list/catslug/spaceslug
	speak = list("Have any porl?", "What is that?", "What kind of ship is that?", "What are you doing?", "How did you get here?", "Don't take off your helmet.", "SPAAAAAACE!", "WAOW!", "Nice weather we're having, isn't it?")

/mob/living/simple_mob/vore/alienanimals/catslug/spaceslug/Initialize()
	. = ..()
	verbs += /mob/living/proc/ventcrawl
	verbs += /mob/living/proc/hide		
	verbs -= /mob/living/simple_mob/vore/alienanimals/catslug/proc/catslug_color	//I don't even want to imagine what the colour change proc would do to their sprite, not to mention ghosts would need to be forced into the catslug so this is more just a safety net than anything

/mob/living/simple_mob/vore/alienanimals/catslug/spaceslug/attack_hand(mob/living/carbon/human/M as mob)
	
	if(stat == DEAD)
		return ..()
	if(M.a_intent != I_HELP)
		return ..()
	playsound(src, 'sound/weapons/thudswoosh.ogg', 50, 1, -1)
	if(resting)
		M.visible_message("<span class='notice'>\The [M.name] shakes \the [src] awake from their nap.</span>","<span class='notice'>You shake \the [src] awake!</span>")
		lay_down()
		ai_holder.go_wake()
		return
	if(M.zone_sel.selecting == BP_HEAD)
		M.visible_message( \
			"<span class='notice'>[M] pats \the [src] on their helmet.</span>", \
			"<span class='notice'>You pat \the [src] on their helmet.</span>", )
		if(client)
			return
		if(prob(10))
			visible_message("<span class='notice'>\The [src] purrs and leans into [M]'s hand.</span>")
	else if(M.zone_sel.selecting == BP_R_HAND || M.zone_sel.selecting == BP_L_HAND)
		M.visible_message( \
			"<span class='notice'>[M] shakes \the [src]'s hand.</span>", \
			"<span class='notice'>You shake \the [src]'s hand.</span>", )
		if(client)
			return
		if(prob(10))
			visible_message("<span class='notice'>\The [src]'s looks a little confused and bonks their helmet's faceplate against [M]'s hand experimentally, attempting to nibble at it.</span>")
	else if(M.zone_sel.selecting == "mouth")
		M.visible_message( \
			"<span class='notice'>[M] attempts to boop \the [src]'s nose, defeated only by the helmet they wear.</span>", \
			"<span class='notice'>You attempt to boop \the [src] on the nose, stopped only by that helmet they wear.</span>", )
		if(client)
			return
		if(prob(10))
			visible_message("<span class='notice'>\The [src]'s eyes widen as they stare at [M]. After a moment they rub at the faint mark [M]'s digit left upon the surface of their helmet's faceplate.</span>")
	else if(M.zone_sel.selecting == BP_GROIN)
		M.visible_message( \
			"<span class='notice'>[M] rubs \the [src]'s tummy...</span>", \
			"<span class='notice'>You rub \the [src]'s tummy, accidently pressing a few of the buttons on their chestpiece in the process... You feel the danger.</span>", )
		if(client)
			return
		visible_message("<span class='notice'>\The [src] pushes [M]'s hand away from their tummy and furrows their brow, frantically pressing at the buttons [M] so carelessly pushed!</span>")
		if(prob(5))
			ai_holder.target = M
			ai_holder.track_target_position()
			ai_holder.set_stance(STANCE_FIGHT)
	else
		return ..()

/obj/item/weapon/holder/catslug/spaceslug
	item_state = "spaceslug"
	
