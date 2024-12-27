//turkey - sprites and writing done by VerySoft
/mob/living/simple_mob/vore/turkeygirl
	name = "turkeygirl"
	desc = "A feathered woman! She looks like some kind of plump turkey!"
	tt_desc = "Meleagris gallopian"
	icon = 'icons/mob/turkey.dmi'
	icon_state = "turkeygirl"
	icon_living = "turkeygirl"
	icon_dead = "turkeygirl-dead"

	health = 100
	maxHealth = 100

	has_hands = TRUE

	faction = "turkey"

	response_help  = "hugs"
	response_disarm = "pushes"
	response_harm   = "punches"
	attacktext = list("pecked")

	has_langs = list(LANGUAGE_GALCOM , LANGUAGE_ANIMAL)

	meat_amount = 100
	meat_type = /obj/item/reagent_containers/food/snacks/meat/chicken

	ai_holder_type = /datum/ai_holder/simple_mob/passive

	say_list_type = /datum/say_list/turkey

	vore_active = 1
	vore_capacity = 2
	vore_bump_chance = 10
	vore_pounce_chance = 10
	vore_pounce_maxhealth = 999
	vore_ignores_undigestable = 0
	vore_default_mode = DM_SELECT
	vore_icons = SA_ICON_LIVING
	vore_stomach_name = "Stomach"
	vore_default_contamination_flavor = "Wet"
	vore_default_contamination_color = "grey"
	vore_default_item_mode = IM_DIGEST
	vore_standing_too = TRUE

/mob/living/simple_mob/vore/turkeygirl/init_vore()
	if(!voremob_loaded)
		return
	. = ..()
	var/obj/belly/B = vore_selected
	B.name = "stomach"
	B.desc = "The hot churning stomach of a turkey girl! The doughy flesh presses inward to form to your figure, thick slime coating everything, and very shortly that includes you as well! There isn't any escaping that constant full body motion, as her body works to ball yours up into a tight little package. Gurgling and glubbing with every shifting movement, while her pulse throbs through the flesh all around you with every beat of her heart. All in all, one thing is for certain! You've become turkey stuffing! Oh no..."
	B.mode_flags = DM_FLAG_THICKBELLY | DM_FLAG_NUMBING
	B.belly_fullscreen = "anibelly"
	B.digest_brute = 1
	B.digest_burn = 6
	B.digestchance = 0
	B.absorbchance = 0
	B.escapechance = 15
	B.colorization_enabled = TRUE
	B.belly_fullscreen_color = "#521717"

/datum/say_list/turkey
	speak = list("Gobble!", "Gobble gobble!", "Gobble gobble gobble!", "Give me something to be thankful for~", "Could use something to gobble~", "Why don't you make a pilgrimage over here and give me something good to eat?", "I want a treat... I could bite you too if you like~", "What's your favorite time of year?", "Autumn is the best time of year~", "You just gonna let a girl go hungry?")

/mob/living/simple_mob/vore/turkeygirl/update_icon()
	. = ..()
	if(stat == DEAD)
		return
	if(vore_fullness == 2 || nutrition >= 5000)
		icon_state = "[icon_living]-2"

	else if(vore_fullness == 1 || nutrition >= 2500)
		icon_state = "[icon_living]-1"
	if(resting)
		icon_state = "[icon_state]-resting"

/mob/living/simple_mob/vore/turkeygirl/attackby(var/obj/item/reagent_containers/food/snacks/O as obj, var/mob/user as mob)
	if(stat)
		return ..()

	if(!istype(O, /obj/item/reagent_containers/food/snacks))
		return ..()

	if(nutrition >= max_nutrition)
		if(user == src)
			to_chat(src, span_notice("You're too full to eat another bite."))
			return
		to_chat(user, span_notice("\The [src] seems too full to eat."))
		return

	user.setClickCooldown(user.get_attack_speed(O))
	if(O.reagents)
		O.reagents.trans_to_mob(src, O.bitesize, CHEM_INGEST)
		adjust_nutrition(O.bitesize * 20)
	O.bitecount ++
	O.On_Consume(src)
	if(O)
		to_chat(user, span_notice("\The [src] takes a bite of \the [O]."))
		if(user != src)
			to_chat(src, span_notice("\The [user] feeds \the [O] to you."))
	playsound(src, 'sound/items/eatfood.ogg', 75, 1)
	update_icon()
