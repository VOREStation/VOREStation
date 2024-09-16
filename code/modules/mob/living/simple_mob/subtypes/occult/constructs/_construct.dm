////////////////////////////
//		Base Construct
////////////////////////////

/mob/living/simple_mob/construct
	name = "Construct"
	real_name = "Construct"
	desc = ""
	tt_desc = "Error"

	icon_living = "shade"
	icon_dead = "shade_dead"

	mob_class = MOB_CLASS_DEMONIC

	ui_icons = 'icons/mob/screen1_construct.dmi'
	has_hands = 1
	hand_form = "stone manipulators"

	response_help  = "thinks better of touching"
	response_disarm = "flailed at"
	response_harm   = "punched"

	hovering = TRUE
	softfall = TRUE //Beings made of Hellmarble and powered by the tears of the damned are not concerned with mortal things such as 'gravity'.
	parachuting = TRUE

	has_langs = list(LANGUAGE_GALCOM, LANGUAGE_CULT)

	has_eye_glow = TRUE

	taser_kill = FALSE

	min_oxy = 0
	max_oxy = 0
	min_tox = 0
	max_tox = 0
	min_co2 = 0
	max_co2 = 0
	min_n2 = 0
	max_n2 = 0
	minbodytemp = 0

	shock_resist = 0.1 //Electricity isn't very effective on stone, especially that from hell.
	poison_resist = 1.0

	armor = list(
				"melee" = 10,
				"bullet" = 10,
				"laser" = 10,
				"energy" = 10,
				"bomb" = 10,
				"bio" = 100,
				"rad" = 100)

	can_be_antagged = TRUE
	faction = FACTION_CULT

	supernatural = TRUE

	var/construct_type = "shade"
	var/list/construct_spells = list()
//	var/do_glow = TRUE

/mob/living/simple_mob/construct/place_spell_in_hand(var/path)
	if(!path || !ispath(path))
		return 0

	//var/obj/item/weapon/spell/S = new path(src)
	var/obj/item/weapon/spell/construct/S = new path(src)

	//No hands needed for innate casts.
	if(S.cast_methods & CAST_INNATE)
		if(S.run_checks())
			S.on_innate_cast(src)

	if(l_hand && r_hand) //Make sure our hands aren't full.
		if(istype(r_hand, /obj/item/weapon/spell)) //If they are full, perhaps we can still be useful.
			var/obj/item/weapon/spell/r_spell = r_hand
			if(r_spell.aspect == ASPECT_CHROMATIC) //Check if we can combine the new spell with one in our hands.
				r_spell.on_combine_cast(S, src)
		else if(istype(l_hand, /obj/item/weapon/spell))
			var/obj/item/weapon/spell/l_spell = l_hand
			if(l_spell.aspect == ASPECT_CHROMATIC) //Check the other hand too.
				l_spell.on_combine_cast(S, src)
		else //Welp
			to_chat(src, "<span class='warning'>You require a free manipulator to use this power.</span>")
			return 0

	if(S.run_checks())
		put_in_hands(S)
		return 1
	else
		qdel(S)
		return 0

/mob/living/simple_mob/construct/cultify()
	return

/mob/living/simple_mob/construct/New()
	..()
	name = text("[initial(name)] ([rand(1, 1000)])")
	real_name = name
	for(var/spell in construct_spells)
		src.add_spell(new spell, "const_spell_ready")
	update_icon()

/*
/mob/living/simple_mob/construct/update_icon()
	..()
	if(do_glow)
		add_glow()
*/

/mob/living/simple_mob/construct/death()
	new /obj/item/weapon/ectoplasm (src.loc)
	..(null,"collapses in a shattered heap.")
	ghostize()
	qdel(src)

/mob/living/simple_mob/construct/attack_generic(var/mob/user)
	if(istype(user, /mob/living/simple_mob/construct/artificer))
		var/mob/living/simple_mob/construct/artificer/A = user
		if(health < getMaxHealth())
			var/repair_lower_bound = A.melee_damage_lower * -1
			var/repair_upper_bound = A.melee_damage_upper * -1
			adjustBruteLoss(rand(repair_lower_bound, repair_upper_bound))
			adjustFireLoss(rand(repair_lower_bound, repair_upper_bound))
			user.visible_message("<b>\The [user]</b> mends some of \the [src]'s wounds.")
		else
			to_chat(user, "<span class='notice'>\The [src] is undamaged.</span>")
		return
	return ..()

/mob/living/simple_mob/construct/examine(mob/user)
	. = ..(user)
	var/max = getMaxHealth()
	if (health < max)
		if (health >= max/2)
			. += "<span class='warning'>It looks slightly dented.</span>"
		else
			. += "<span class='warning'><B>It looks severely dented!</B></span>"

//Constructs levitate, can fall from a shuttle with no harm, and are piloted by either damned spirits or some otherworldly entity. Let 'em float in space.
/mob/living/simple_mob/construct/Process_Spacemove()
	return 1

/*
// Glowing Procs
/mob/living/simple_mob/construct/proc/add_glow()
	var/image/eye_glow = image(icon,"glow-[icon_state]")
	eye_glow.plane = PLANE_LIGHTING_ABOVE
	add_overlay(eye_glow)
	set_light(2, -2, l_color = "#FFFFFF")

/mob/living/simple_mob/construct/proc/remove_glow()
	cut_overlays()
*/
