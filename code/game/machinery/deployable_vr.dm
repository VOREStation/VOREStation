/obj/structure/barricade/cutout
	name = "stand-up figure"
	desc = "Some sort of wooden stand-up figure..."
	icon = 'icons/obj/cardboard_cutout.dmi'
	icon_state = "cutout_basic"

	maxhealth = 15 //Weaker than normal barricade
	anchored = FALSE

	var/fake_name = "unknown"
	var/fake_desc = "You have to be closer to examine this creature."
	var/construct_name = "basic cutout"

	var/toppled = FALSE
	var/human_name = TRUE

	var/static/list/cutout_types
	var/static/list/painters = list(/obj/item/reagent_containers/glass/paint, /obj/item/floor_painter)//, /obj/item/closet_painter)

/obj/structure/barricade/cutout/Initialize(mapload)
	. = ..()
	color = null
	if(human_name)
		fake_name = random_name(pick(list(MALE, FEMALE)))
	name = fake_name
	desc = fake_desc
	if(!cutout_types)
		cutout_types = list()
		var/list/types = typesof(/obj/structure/barricade/cutout)
		for(var/cutout_type in types)
			var/obj/structure/barricade/cutout/pathed_type = cutout_type
			cutout_types[initial(pathed_type.construct_name)] = cutout_type

/obj/structure/barricade/cutout/proc/topple()
	if(toppled)
		return
	toppled = TRUE
	icon_state = "cutout_pushed_over"
	density = FALSE
	name = initial(name)
	desc = initial(desc)
	visible_message(span_warning("[src] topples over!"))

/obj/structure/barricade/cutout/proc/untopple()
	if(!toppled)
		return
	toppled = FALSE
	icon_state = initial(icon_state)
	density = TRUE
	name = fake_name
	desc = fake_desc
	visible_message(span_warning("[src] is uprighted to their proper position."))

/obj/structure/barricade/cutout/CheckHealth()
	if(!toppled && (health < (maxhealth/2)))
		topple()
	..()

/obj/structure/barricade/cutout/attack_hand(var/mob/user)
	if((. = ..()))
		return

	if(toppled)
		untopple()

/obj/structure/barricade/cutout/examine(var/mob/user)
	. = ..()

	if(Adjacent(user))
		. += span_notice("... from this distance, they seem to be made of [material.name] ...")

/obj/structure/barricade/cutout/attackby(var/obj/I, var/mob/user)
	if(is_type_in_list(I, painters))
		var/choice = tgui_input_list(user, "What would you like to paint the cutout as?", "Cutout Painting", cutout_types)
		if(!choice || !Adjacent(user) || I != user.get_active_hand())
			return TRUE
		if(do_after(user, 10 SECONDS, src))
			var/picked_type = cutout_types[choice]
			new picked_type(loc)
			qdel(src) //Laaaazy. Technically heals it too. Must be held together with all that paint.
		return TRUE

	else
		return ..()

//Variants
/obj/structure/barricade/cutout/greytide
	icon_state = "cutout_greytide"
	construct_name = "greytide"
/obj/structure/barricade/cutout/clown
	icon_state = "cutout_clown"
	construct_name = "clown"
/obj/structure/barricade/cutout/mime
	icon_state = "cutout_mime"
	construct_name = "mime"
/obj/structure/barricade/cutout/traitor
	icon_state = "cutout_traitor"
	construct_name = "criminal employee"
/obj/structure/barricade/cutout/fluke
	icon_state = "cutout_fluke"
	construct_name = "nuclear operative"
/obj/structure/barricade/cutout/cultist
	icon_state = "cutout_cultist"
	construct_name = "presumed cultist"
/obj/structure/barricade/cutout/servant
	icon_state = "cutout_servant"
	construct_name = "druid"
/obj/structure/barricade/cutout/new_servant
	icon_state = "cutout_new_servant"
	construct_name = "other druid"
/obj/structure/barricade/cutout/viva
	icon_state = "cutout_viva"
	human_name = FALSE
	fake_name = "Unknown"
	construct_name = "advanced greytide"
/obj/structure/barricade/cutout/wizard
	icon_state = "cutout_wizard"
	construct_name = "wizard"
/obj/structure/barricade/cutout/shadowling
	icon_state = "cutout_shadowling"
	human_name = FALSE
	fake_name = "Unknown"
	construct_name = "dark creature"
/obj/structure/barricade/cutout/fukken_xeno
	icon_state = "cutout_fukken_xeno"
	human_name = FALSE
	fake_name = "xenomorph"
	construct_name = "alien"
/obj/structure/barricade/cutout/swarmer
	icon_state = "cutout_swarmer"
	human_name = FALSE
	fake_name = "swarmer"
	construct_name = "robot"
/obj/structure/barricade/cutout/free_antag
	icon_state = "cutout_free_antag"
	construct_name = "hot lizard"
/obj/structure/barricade/cutout/deathsquad
	icon_state = "cutout_deathsquad"
	construct_name = "unknown"
/obj/structure/barricade/cutout/ian
	icon_state = "cutout_ian"
	human_name = FALSE
	fake_name = "corgi"
	construct_name = "dog"
/obj/structure/barricade/cutout/ntsec
	icon_state = "cutout_ntsec"
	construct_name = "nt security"
/obj/structure/barricade/cutout/lusty
	icon_state = "cutout_lusty"
	human_name = FALSE
	fake_name = "xenomorph"
	construct_name = "hot alien"
/obj/structure/barricade/cutout/gondola
	icon_state = "cutout_gondola"
	construct_name = "creature"
/obj/structure/barricade/cutout/monky
	icon_state = "cutout_monky"
	human_name = FALSE
	fake_name = "monkey"
	construct_name = "monkey"
/obj/structure/barricade/cutout/law
	icon_state = "cutout_law"
	human_name = FALSE
	fake_name = "Beepsky"
	construct_name = "lawful robot"

/obj/random/cutout //Random wooden standup figure
	name = "random wooden figure"
	desc = "This is a random wooden figure."
	icon = 'icons/obj/cardboard_cutout.dmi'
	icon_state = "cutout_random"
	spawn_nothing_percentage = 80 //Only spawns 20% of the time to avoid being predictable

/obj/random/cutout/item_to_spawn()
	var/list/cutout_types = subtypesof(/obj/structure/barricade/cutout)
	return pick(cutout_types)
