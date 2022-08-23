/datum/modifier/sifsap_salve
	name = "Sifsap Salve"
	desc = "Your wounds have been salved with Sivian sap."
	mob_overlay_state = "cyan_sparkles"
	stacks = MODIFIER_STACK_FORBID
	on_created_text = "<span class = 'notice'>The glowing sap seethes and bubbles in your wounds, tingling and stinging.</span>"
	on_expired_text = "<span class = 'notice'>The last of the sap in your wounds fizzles away.</span>"

/datum/modifier/sifsap_salve/tick()

	if(holder.stat == DEAD)
		expire()

	if(istype(holder, /mob/living/simple_mob/animal/sif))

		var/mob/living/simple_mob/animal/sif/critter = holder
		if(critter.health >= (critter.getMaxHealth() * critter.sap_heal_threshold))
			return

		if(holder.resting)
			if(istype(holder.loc, /obj/structure/animal_den))
				holder.adjustBruteLoss(-3)
				holder.adjustFireLoss(-3)
				holder.adjustToxLoss(-2)
			else
				holder.adjustBruteLoss(-2)
				holder.adjustFireLoss(-2)
				holder.adjustToxLoss(-1)
		else
			holder.adjustBruteLoss(-1)
			holder.adjustFireLoss(-1)

/obj/item/projectile/drake_spit
	name = "drake spit"
	icon_state = "ice_1"
	damage = 0
	embed_chance = 0
	damage_type = BRUTE
	muzzle_type = null
	hud_state = "monkey"
	combustion = FALSE
	stun = 3
	weaken = 3
	eyeblur = 5
	fire_sound = 'sound/effects/splat.ogg'

/datum/category_item/catalogue/fauna/grafadreka
	name = "Sivian Fauna - Grafadreka"
	desc = {"Classification: S tesca pabulator
<br><br>
The reclusive grafadreka (Icelandic, lit. 'digging dragon'), also known as the snow drake, is a large reptillian pack predator similar in size and morphology to old Earth hyenas. They commonly dig shallow dens in dirt, snow or foliage, sometimes using them for concealment prior to an ambush. Biological cousins to the elusive kururak, they have heavy, low-slung bodies and powerful jaws suited to hunting land prey rather than fishing. Colonization and subsequent expansion have displaced many populations from their tundral territories into colder areas; as a result, their diet of Sivian prey animals has pivoted to a diet of giant spider meat.
<br><br>
Grafadrekas are capable of exerting bite pressures in excess of 900 PSI, which allows them to crack bones or carapace when scavenging for food. While they share the hypercarnivorous metabolism of their cousins, they have developed a symbiotic relationship with the bacteria responsible for the bioluminescence of Sivian trees. This assists with digesting plant matter, and gives their pelts a distinctive and eerie glow.
<br><br>
They have been observed to occasionally attack and kill colonists, generally when conditions are too poor to hunt their usual prey. Despite this, and despite their disposition being generally skittish and avoidant of colonists, some Sivian communities hold that they have been observed to guide or protect lost travellers.
<br><br>
Field studies suggest analytical abilities on par with some species of cepholapods, but their symbiotic physiology rapidly fails in captivity, making laboratory testing difficult. Their inability to make use of tools or form wider social groups beyond a handful of individuals has been hypothesised to prevent the expression of more complex social behaviors."}
	value = CATALOGUER_REWARD_HARD

/decl/mob_organ_names/grafadreka
	hit_zones = list(
		"head",
		"chest",
		"left foreleg",
		"right foreleg",
		"left hind leg",
		"right hind leg",
		"face spines",
		"body spines",
		"tail spines",
		"tail"
	)

var/global/list/last_drake_howl = list()
/decl/emote/audible/drake_howl
	key = "dhowl"
	emote_message_3p = "lifts USER_THEIR head up and gives an eerie howl."
	emote_sound = 'sound/effects/drakehowl_close.ogg'
	var/cooldown = 20 SECONDS

/decl/emote/audible/drake_howl/do_emote(var/atom/user, var/extra_params)
	if(world.time < last_drake_howl["\ref[user]"])
		to_chat(user, SPAN_WARNING("You cannot howl again so soon."))
		return FALSE
	. = ..()
	if(.)
		last_drake_howl["\ref[user]"] = world.time + cooldown

/decl/emote/audible/drake_howl/do_sound(var/atom/user)
	..()
	var/turf/user_turf = get_turf(user)
	if(!istype(user_turf))
		return
	var/list/affected_levels = GetConnectedZlevels(user_turf.z)
	var/list/close_listeners = hearers(world.view * 3, user_turf)
	for(var/mob/M in player_list)
		var/turf/T = get_turf(M)
		if(!istype(T) || istype(T,/turf/space) || M.ear_deaf > 0 || (M in close_listeners) || !(T.z in affected_levels))
			continue
		var/turf/reference_point = locate(T.x, T.y, user_turf.z)
		if(reference_point)
			var/direction = get_dir(reference_point, user_turf)
			if(direction)
				to_chat(M, SPAN_NOTICE("You hear an eerie howl from somewhere to the [dir2text(direction)]"))
		M << 'sound/effects/drakehowl_far.ogg'

/mob/living/simple_mob/animal/sif/grafadreka/get_available_emotes()
	return global._default_mob_emotes | /decl/emote/audible/drake_howl

/mob/living/simple_mob/animal/sif/grafadreka
	name = "grafadreka"
	desc = "A large, sleek snow drake with heavy claws, powerful jaws and many pale spines along its body."
	player_msg = "You are a large Sivian pack predator in symbiosis with the local bioluminescent bacteria. You can eat glowing \
	tree fruit to fuel your <b>ranged spitting attack</b> and <b>poisonous bite</b> (on <span class = 'danger'>harm intent</span>), as well as <b>healing saliva</b> \
	(on <b><font color = '#009900'>help intent</font></b>).<br>There are humans moving through your territory; whether you help them get home safely, or treat them as a snack, \
	is up to you."
	color = "#608894"
	icon = 'icons/mob/64x32.dmi'
	catalogue_data = list(/datum/category_item/catalogue/fauna/grafadreka)
	icon_state = "doggo"
	icon_living = "doggo"
	icon_dead = "doggo_lying"
	icon_rest = "doggo_lying"
	projectileverb = "spits"
	friendly = list("headbutts", "grooms", "play-bites", "rubs against")
	bitesize = 10 // chomp
	has_langs = list("Drake")

	see_in_dark = 8 // on par with Taj

	tt_desc = "S tesca pabulator"
	faction = "grafadreka"

	mob_size = MOB_LARGE
	mob_bump_flag = SIMPLE_ANIMAL
	mob_swap_flags = SIMPLE_ANIMAL
	mob_push_flags = SIMPLE_ANIMAL

	maxHealth = 150
	health = 150
	movement_cooldown = 2
	base_attack_cooldown = 1 SECOND

	organ_names = /decl/mob_organ_names/grafadreka
	say_list_type = /datum/say_list/grafadreka
	ai_holder_type = /datum/ai_holder/simple_mob/intentional/grafadreka

	scavenger = TRUE
	burrower = TRUE

	projectilesound = 'sound/effects/splat.ogg'
	projectiletype = /obj/item/projectile/drake_spit

	// Claw attacks.
	attack_sharp = TRUE
	melee_damage_lower = 8
	melee_damage_upper = 18
	attack_armor_pen = 15
	attack_sound = 'sound/weapons/slice.ogg'

	tame_items = list(
		/obj/item/reagent_containers/food/snacks/siffruit = 20,
		/obj/item/reagent_containers/food/snacks/grown/sif/sifpod = 10,
		/obj/item/reagent_containers/food/snacks/xenomeat/spidermeat = 20,
		/obj/item/reagent_containers/food/snacks/meat = 10
	)

	// Attack strings for swapping.
	attacktext = null
	var/static/list/claw_attacktext = list("slashed", "clawed", "swiped", "gouged")
	var/static/list/bite_attacktext = list("savaged", "bitten", "mauled")

	// Bite attacks.
	var/const/bite_melee_damage_lower = 30
	var/const/bite_melee_damage_upper = 40
	var/const/bite_attack_armor_pen = 60
	var/const/bite_attack_sound = 'sound/weapons/bite.ogg'

	// Used to avoid setting vars every single attack.
	var/attacking_with_claws = TRUE

	// Set during initialize and used to generate overlays.
	var/tmp/fur_colour
	var/tmp/claw_colour
	var/tmp/glow_colour
	var/tmp/base_colour
	var/tmp/eye_colour

	var/next_spit = 0
	var/spit_cooldown = 8 SECONDS
	var/next_alpha_check = 0
	var/dominance = 0 // A score used to determine pack leader.
	var/stored_sap = 0
	var/max_stored_sap = 60
	var/attacked_by_human = FALSE

/mob/living/simple_mob/animal/sif/grafadreka/proc/can_tend_wounds(var/mob/living/friend)
	if(ishuman(friend))
		var/mob/living/carbon/human/H = friend
		for(var/obj/item/organ/external/E in H.bad_external_organs)
			if(E.status & ORGAN_BLEEDING)
				return TRUE
		return FALSE
	if(istype(friend, /mob/living/simple_mob/animal/sif))
		var/mob/living/simple_mob/animal/sif/critter = friend
		return critter.health < (critter.getMaxHealth() * critter.sap_heal_threshold)
	return (friend.health < friend.maxHealth)

/mob/living/simple_mob/animal/sif/grafadreka/Initialize()
	gender = pick(MALE, FEMALE)
	attacktext = claw_attacktext.Copy()
	setup_colours()
	create_reagents(50)
	. = ..()
	update_icon()

/mob/living/simple_mob/animal/sif/grafadreka/examine(var/mob/living/user)
	. = ..()
	if(istype(user, /mob/living/simple_mob/animal/sif/grafadreka) || isobserver(user))
		var/datum/gender/G = gender_datums[get_visible_gender()]
		if(stored_sap >= 20)
			. += SPAN_NOTICE("[G.His] sap reserves are high.")
		else if(stored_sap >= 10)
			. += SPAN_WARNING("[G.His] sap reserves are running low.")
		else
			. += SPAN_DANGER("[G.His] sap reserves are depleted.")

/mob/living/simple_mob/animal/sif/grafadreka/can_projectile_attack(var/atom/A)
	if(a_intent != I_HURT || world.time < next_spit)
		return FALSE
	if(!has_sap(2))
		to_chat(src, SPAN_WARNING("You have no sap to spit!"))
		return FALSE
	return ..()

// Checking this in the proc itself as AI doesn't seem to care about ranged attack cooldowns.
/mob/living/simple_mob/animal/sif/grafadreka/shoot_target(atom/A)
	if(world.time < next_spit || !has_sap(2))
		return FALSE
	. = ..()
	if(.)
		next_spit = world.time + spit_cooldown
		setMoveCooldown(1 SECOND)
		spend_sap(2)

/mob/living/simple_mob/animal/sif/grafadreka/Life()
	. = ..()

	// Process food and sap chems.
	if(stat == CONSCIOUS) // Hibernating drakes don't get hungy.
		// by default we lose nutrition. Hungry hungry drakes.
		var/food_val = resting ? 0 : -0.3

		// Very basic metabolism.
		if(reagents?.total_volume)
			for(var/datum/reagent/chem in reagents.reagent_list)
				var/removing = min(REM, chem.volume)
				if(istype(chem, /datum/reagent/nutriment))
					var/datum/reagent/nutriment/food = chem
					food_val += (food.nutriment_factor * removing) * ((food.allergen_type & ALLERGEN_MEAT) ? 0.3 : 0.1)
				else if(istype(chem, /datum/reagent/toxin/sifslurry))
					add_sap(removing * 3)
				reagents.remove_reagent(chem.id, removing)

		if(food_val != 0)
			nutrition = clamp(nutrition + food_val, 0, max_nutrition)

/mob/living/simple_mob/animal/sif/grafadreka/proc/has_sap(var/amt)
	return stored_sap >= amt

/mob/living/simple_mob/animal/sif/grafadreka/proc/add_sap(var/amt)
	stored_sap = clamp(round(stored_sap + amt, 0.01), 0, max_stored_sap)
	update_icon()
	return TRUE

/mob/living/simple_mob/animal/sif/grafadreka/proc/spend_sap(var/amt)
	if(has_sap(amt))
		stored_sap = clamp(round(stored_sap - amt, 0.01), 0, max_stored_sap)
		update_icon()
		return TRUE
	return FALSE

/mob/living/simple_mob/animal/sif/grafadreka/proc/setup_colours()

	var/static/list/fur_colours =  list(COLOR_SILVER, COLOR_WHITE, COLOR_GREEN_GRAY, COLOR_PALE_RED_GRAY, COLOR_BLUE_GRAY)
	var/static/list/claw_colours = list(COLOR_GRAY, COLOR_SILVER, COLOR_WHITE, COLOR_GRAY15, COLOR_GRAY20, COLOR_GRAY40, COLOR_GRAY80)
	var/static/list/glow_colours = list(COLOR_BLUE_LIGHT, COLOR_LIGHT_CYAN, COLOR_CYAN, COLOR_CYAN_BLUE)
	var/static/list/base_colours = list("#608894", "#436974", "#7fa3ae")
	var/static/list/eye_colours =  list(COLOR_WHITE, COLOR_SILVER)

	if(!glow_colour)
		glow_colour = pick(glow_colours)
	if(!fur_colour)
		fur_colour =  pick(fur_colours)
	if(!claw_colour)
		claw_colour = pick(claw_colours)
	if(!base_colour)
		base_colour = pick(base_colours)
	if(!eye_colour)
		eye_colour =  pick(eye_colours)

/mob/living/simple_mob/animal/sif/grafadreka/movement_delay(oldloc, direct)
	. = ..()
	if(istype(loc, /turf/space))
		return
	var/health_deficiency = 1-(health / maxHealth)
	if(health_deficiency >= 0.4)
		. += round(4 * health_deficiency, 0.1)
	var/hungry = 1-(nutrition / max_nutrition)
	if (hungry >= 0.3)
		. += round(6 * hungry, 0.1)

/mob/living/simple_mob/animal/sif/grafadreka/update_icon()

	. = ..()

	var/list/add_images = list()
	var/image/I = image(icon, "[icon_state]")
	I.color = base_colour
	add_images += I

	I = image(icon, "[icon_state]-fur")
	I.color = fur_colour
	add_images += I

	I = image(icon, "[icon_state]-claws")
	I.color = claw_colour
	add_images += I

	if(stat == CONSCIOUS)
		I = image(icon, "[icon_state]-eye_overlay")
		I.color = eye_colour
		add_images += I

	if(stat != DEAD)
		I = image(icon, "[icon_state]-glow")
		I.color = glow_colour
		I.plane = PLANE_LIGHTING_ABOVE
		I.alpha = 35 + round(220 * clamp(stored_sap/max_stored_sap, 0, 1))
		add_images += I

	for(var/image/adding in add_images)
		adding.appearance_flags |= (RESET_COLOR|PIXEL_SCALE|KEEP_APART)
		adding.pixel_x = -16 // Offset here so that things like modifiers, runechat text, etc. are centered
		add_overlay(adding)

	// We do this last so the default mob icon_state can be used for the overlays.
	icon_state = "blank"
	color = COLOR_WHITE // Due to KEEP_TOGETHER etc. overlays ignore RESET_COLOR.

/mob/living/simple_mob/animal/sif/grafadreka/get_eye_color()
	return eye_colour

/mob/living/simple_mob/animal/sif/grafadreka/do_tame(var/obj/O, var/mob/user)
	. = ..()
	if(attacked_by_human && ishuman(user) && ((user in tamers) || (user in friends)))
		attacked_by_human = FALSE

/mob/living/simple_mob/animal/sif/grafadreka/handle_special()
	..()
	if(client || world.time >= next_alpha_check)
		next_alpha_check = world.time + (60 SECONDS)
		check_alpha_status()

/mob/living/simple_mob/animal/sif/grafadreka/do_help_interaction(atom/A)

	if(isliving(A))

		var/mob/living/friend = A
		if(friend.stat == DEAD)
			if(friend == src)
				to_chat(src, SPAN_WARNING("\The [friend] is dead; tending their wounds is pointless."))
			else
				return ..()
			return TRUE

		if(!can_tend_wounds(friend))
			if(friend == src)
				if(health == maxHealth)
					to_chat(src, SPAN_WARNING("You are unwounded."))
				else
					to_chat(src, SPAN_WARNING("You cannot tend any of your wounds."))
			else
				if(friend.health == friend.maxHealth)
					return ..()
				to_chat(src, SPAN_WARNING("You cannot tend any of \the [friend]'s wounds."))
			return TRUE

		if(friend.has_modifier_of_type(/datum/modifier/sifsap_salve))
			if(friend == src)
				to_chat(src, SPAN_WARNING("You have already cleaned your wounds."))
			else
				return ..()
			return TRUE

		if(!has_sap(10))
			if(friend == src)
				to_chat(src, SPAN_WARNING("You don't have enough sap to clean your wounds."))
			else
				return ..()
			return TRUE

		if(friend == src)
			visible_message(SPAN_NOTICE("\The [src] begins to drool a blue-glowing liquid, which they start slathering over their wounds."))
		else
			visible_message(SPAN_NOTICE("\The [src] begins to drool a blue-glowing liquid, which they start slathering over \the [friend]'s wounds."))
		playsound(src, 'sound/effects/ointment.ogg', 25)

		set_AI_busy(TRUE)
		if(!do_after(src, 8 SECONDS, friend) || QDELETED(friend) || friend.has_modifier_of_type(/datum/modifier/sifsap_salve) || incapacitated() || !spend_sap(10))
			set_AI_busy(FALSE)
			return TRUE
		set_AI_busy(FALSE)

		if(friend == src)
			visible_message(SPAN_NOTICE("\The [src] finishes licking at their wounds."))
		else
			visible_message(SPAN_NOTICE("\The [src] finishes licking at \the [friend]'s wounds."))
		playsound(src, 'sound/effects/ointment.ogg', 25)

		// Sivian animals get a heal buff from the modifier, others just
		// get it to stop friendly drakes constantly licking their wounds.
		friend.add_modifier(/datum/modifier/sifsap_salve, 60 SECONDS)
		// Human wounds are closed, but they get sifsap via open wounds.
		if(ishuman(friend))
			var/mob/living/carbon/human/H = friend
			for(var/obj/item/organ/external/E in H.organs)
				if(E.status & ORGAN_BLEEDING)
					E.organ_clamp()
					H.bloodstr.add_reagent("sifsap", rand(1,2))
				for(var/datum/wound/W in E.wounds)
					W.salve()
					W.disinfect()

		// Everyone else is just poisoned.
		else if(!istype(friend, /mob/living/simple_mob/animal/sif))
			friend.adjustToxLoss(rand(10,20))
		return TRUE

	return ..()

/mob/living/simple_mob/animal/sif/grafadreka/proc/get_local_alpha()
	var/pack = FALSE
	var/mob/living/simple_mob/animal/sif/grafadreka/alpha = src
	for(var/mob/living/simple_mob/animal/sif/grafadreka/beta in hearers(7, loc))
		if(beta != src && beta.stat != DEAD)
			pack = TRUE
			if(beta.dominance > alpha.dominance)
				alpha = beta
	if(pack)
		return alpha

/mob/living/simple_mob/animal/sif/grafadreka/proc/check_alpha_status()
	var/mob/living/simple_mob/animal/sif/grafadreka/alpha = get_local_alpha()
	if(src == alpha)
		add_modifier(/datum/modifier/ace, 60 SECONDS)
	else
		remove_modifiers_of_type(/datum/modifier/ace)

/mob/living/simple_mob/animal/sif/grafadreka/Stat()
	. = ..()
	if(statpanel("Status"))
		stat("Nutrition:", "[nutrition]/[max_nutrition]")
		stat("Stored sap:", "[stored_sap]/[max_stored_sap]")

/mob/living/simple_mob/animal/sif/grafadreka/apply_bonus_melee_damage(atom/A, damage_amount)
	// Melee attack on incapacitated or prone enemies bites instead of slashing
	var/last_attack_was_claws = attacking_with_claws
	attacking_with_claws = TRUE
	if(isliving(A))
		var/mob/living/M = A
		if(M.lying || M.incapacitated())
			attacking_with_claws = FALSE

	if(last_attack_was_claws != attacking_with_claws)
		if(attacking_with_claws) // Use claws.
			attack_armor_pen =   initial(attack_armor_pen)
			attack_sound =       initial(attack_sound)
			attacktext =         claw_attacktext.Copy()
		else // Use ur teef
			damage_amount = max(damage_amount, rand(bite_melee_damage_lower, bite_melee_damage_upper))
			attack_armor_pen =   bite_attack_armor_pen
			attack_sound =       bite_attack_sound
			attacktext =         bite_attacktext.Copy()
	. = ..()

// Eating sifsap makes bites toxic and changes our glow intensity.
/mob/living/simple_mob/animal/sif/grafadreka/apply_attack(atom/A, damage_to_do)
	var/tox_damage = 0
	if(!attacking_with_claws && isliving(A) && has_sap(5))
		tox_damage = rand(5,15)
	. = ..()
	if(. && tox_damage && spend_sap(5))
		var/mob/living/M = A
		M.adjustToxLoss(tox_damage)

/mob/living/simple_mob/animal/sif/grafadreka/verb/rally_pack()
	set name = "Rally Pack"
	set desc = "Tries to command your fellow pack members to follow you."
	set category = "Abilities"

	if(!has_modifier_of_type(/datum/modifier/ace))
		to_chat(src, SPAN_WARNING("You aren't the pack leader! Sit down!"))
		return

	audible_message("<b>\The [src]</b> barks loudly and rattles its neck spines.")
	for(var/mob/living/simple_mob/animal/sif/grafadreka/drake in hearers(world.view * 3, src))
		if(drake == src || drake.faction != faction)
			continue
		if(drake.client)
			to_chat(drake, SPAN_NOTICE("<b>The pack leader wishes for you to follow them.</b>"))
		else if(drake.ai_holder)
			drake.ai_holder.set_follow(src)

/mob/living/simple_mob/animal/sif/grafadreka/has_appetite()
	return reagents && abs(reagents.total_volume - reagents.maximum_volume) >= 10

/datum/say_list/grafadreka
	speak = list("Chff!","Skhh.", "Rrrss...")
	emote_see = list("scratches its ears","grooms its spines", "sways its tail", "claws at the ground")
	emote_hear = list("hisses", "rattles", "rasps", "barks")

/obj/structure/animal_den/ghost_join/grafadreka
	name = "grafadreka den"
	critter = /mob/living/simple_mob/animal/sif/grafadreka/wild/hibernate

// Subtypes!
/mob/living/simple_mob/animal/sif/grafadreka/rainbow/setup_colours()
	glow_colour = get_random_colour(TRUE)
	fur_colour =  get_random_colour(TRUE)
	claw_colour = get_random_colour(TRUE)
	base_colour = get_random_colour(TRUE)
	eye_colour =  get_random_colour(TRUE)
	..()

/mob/living/simple_mob/animal/sif/grafadreka/wild/Initialize()
	dominance = rand(5, 15)
	stored_sap = rand(20, 30)
	. = ..()

/mob/living/simple_mob/animal/sif/grafadreka/wild/Login()
	. = ..()
	if(client)
		dominance = INFINITY // Let players lead by default.

/mob/living/simple_mob/animal/sif/grafadreka/wild/Logout()
	. = ..()
	if(!client)
		dominance = rand(5, 15)

/mob/living/simple_mob/animal/sif/grafadreka/wild/hibernate/Initialize()
	. = ..()
	dominance = 0
	lay_down()
