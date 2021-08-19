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

	response_help = "hugs"
	response_disarm = "rudely paps"
	response_harm = "punches"

	harm_intent_damage = 2
	melee_damage_lower = 2
	melee_damage_upper = 5

	has_hands = TRUE
	mob_size = MOB_MEDIUM
	friendly = list("hugs")

	catalogue_data = list(/datum/category_item/catalogue/fauna/catslug)
	ai_holder_type = /datum/ai_holder/simple_mob/melee/evasive/catslug
	player_msg = "You have escaped the foul weather, into this much more pleasant place. You are an intelligent creature capable of more than most think. You can pick up and use many things, and even carry some of them with you into the vents, which you can use to move around quickly. You're quiet and capable, you speak with your hands and your deeds! <br>- - - - -<br> <span class='notice'>Keep in mind, your goal should generally be to survive. You're expected to follow the same rules as everyone else, so don't go self antagging without permission from the staff team, but you are able and capable of defending yourself from those who would attack you for no reason.</span>"
	
	has_langs = list("Sign Language")

	var/heal_countdown = 0
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
		/obj/item/stack/material,
		/obj/item/weapon/tool,
		/obj/item/weapon/reagent_containers/food
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
	speak_chance = 0
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
	
/mob/living/simple_mob/vore/alienanimals/catslug/Life()
	. = ..()
	if(nutrition < 150)
		return
	if(health == maxHealth)
		return
	if(heal_countdown > 0)
		heal_countdown --
		return
	if(resting)
		if(bruteloss > 0)
			adjustBruteLoss(-10)
		else if(fireloss > 0)
			adjustFireLoss(-10)
		nutrition -= 50
		heal_countdown = 5
		return
	if(bruteloss > 0)
		adjustBruteLoss(-1)
	else if(fireloss > 0)
		adjustFireLoss(-1)
	nutrition -= 5
	heal_countdown = 5

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

/datum/ai_holder/simple_mob/melee/evasive/catslug/handle_wander_movement()
	if(holder.client)
		return
	if(holder.resting)
		if(prob(5))
			holder.lay_down()
		return
	if(prob(0.5))
		holder.lay_down()
		return
	return ..()

/datum/ai_holder/simple_mob/melee/evasive/catslug/on_hear_say(mob/living/speaker, message)
	if(holder.client)
		return
	if(!speaker.client)
		return
	if(findtext(message, "psps") || stance == STANCE_IDLE)
		set_follow(speaker, follow_for = 5 SECONDS)
