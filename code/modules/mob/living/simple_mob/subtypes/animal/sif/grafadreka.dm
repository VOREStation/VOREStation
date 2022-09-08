/datum/modifier/sifsap_salve
	name = "Sifsap Salve"
	desc = "Your wounds have been salved with Sivian sap."
	mob_overlay_state = "cyan_sparkles"
	stacks = MODIFIER_STACK_FORBID
	on_created_text = "<span class = 'notice'>The glowing sap seethes and bubbles in your wounds, tingling and stinging.</span>"
	on_expired_text = "<span class = 'notice'>The last of the sap in your wounds fizzles away.</span>"

/datum/modifier/sifsap_salve/tick()

	if(holder.stat == DEAD || holder.isSynthetic())
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

/obj/item/projectile/drake_spit/weak
	stun = 0
	weaken = 0
	eyeblur = 2

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

/decl/emote/audible/drake_howl
	key = "dhowl"
	emote_message_3p = "lifts USER_THEIR head up and gives an eerie howl."
	emote_sound = 'sound/effects/drakehowl_close.ogg'
	broadcast_sound ='sound/effects/drakehowl_far.ogg'
	emote_cooldown = 20 SECONDS
	broadcast_distance = 90

/decl/emote/audible/drake_howl/broadcast_emote_to(var/send_sound, var/mob/target, var/direction)
	if((. = ..()))
		to_chat(target, SPAN_NOTICE("You hear an eerie howl from somewhere to the [dir2text(direction)]."))

/mob/living/simple_mob/animal/sif/grafadreka/get_available_emotes()
	if(!is_baby)
		return global._default_mob_emotes | /decl/emote/audible/drake_howl
	return global._default_mob_emotes

// Overriding this to handle sitting.
/mob/living/simple_mob/animal/sif/grafadreka/lay_down()
	. = ..()
	if(!resting && sitting)
		sitting = FALSE
		update_icon()

/mob/living/simple_mob/animal/sif/grafadreka/verb/sit_down()
	set name = "Sit Down"
	set category = "IC"

	if(sitting)
		resting = FALSE
		sitting = FALSE
	else
		resting = TRUE
		sitting = TRUE

	to_chat(src, SPAN_NOTICE("You are now [sitting ? "sitting" : "getting up"]."))
	update_canmove()
	update_icon()

/mob/living/simple_mob/animal/sif/grafadreka
	name = "grafadreka"
	desc = "A large, sleek snow drake with heavy claws, powerful jaws and many pale spines along its body."
	player_msg = "You are a large Sivian pack predator in symbiosis with the local bioluminescent bacteria. You can eat glowing \
	tree fruit to fuel your <b>ranged spitting attack</b> and <b>poisonous bite</b> (on <span class = 'danger'>harm intent</span>), as well as <b>healing saliva</b> \
	(on <b><font color = '#009900'>help intent</font></b>).<br>There are humans moving through your territory; whether you help them get home safely, or treat them as a snack, \
	is up to you."
	color = "#608894"
	icon = 'icons/mob/drake_adult.dmi'
	catalogue_data = list(/datum/category_item/catalogue/fauna/grafadreka)
	icon_state = "doggo"
	icon_living = "doggo"
	icon_dead = "doggo_lying"
	icon_rest = "doggo_lying"
	projectileverb = "spits"
	friendly = list("headbutts", "grooms", "play-bites", "rubs against")
	bitesize = 10 // chomp
	gender = NEUTER

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
	var/bite_melee_damage_lower = 30
	var/bite_melee_damage_upper = 40
	var/bite_attack_armor_pen = 60
	var/const/bite_attack_sound = 'sound/weapons/bite.ogg'

	// Used to avoid setting vars every single attack.
	var/attacking_with_claws = TRUE

	// Set during initialize and used to generate overlays.
	var/tmp/current_icon_state // used to track our 'actual' icon state due to overlay nonsense in update_icon
	var/tmp/fur_colour
	var/tmp/claw_colour
	var/tmp/glow_colour
	var/tmp/base_colour
	var/tmp/eye_colour

	var/offset_compiled_icon = -16
	var/is_baby = FALSE
	var/sitting = FALSE
	var/next_spit = 0
	var/spit_cooldown = 8 SECONDS
	var/next_leader_check = 0
	var/charisma = 0 // A score used to determine pack leader.
	var/stored_sap = 0
	var/max_stored_sap = 60
	var/attacked_by_neutral = FALSE

	var/list/original_armor

var/global/list/wounds_being_tended_by_drakes = list()
/mob/living/simple_mob/animal/sif/grafadreka/proc/can_tend_wounds(var/mob/living/friend)

	// We can't heal robots.
	if(friend.isSynthetic())
		return FALSE

	// Check if someone else is looking after them already.
	if(global.wounds_being_tended_by_drakes["\ref[friend]"] > world.time)
		return FALSE

	// Humans need to have a bleeding external organ to qualify.
	if(ishuman(friend))
		var/mob/living/carbon/human/H = friend
		for(var/obj/item/organ/external/E in H.bad_external_organs)
			if(E.status & ORGAN_BLEEDING)
				return TRUE
		return FALSE

	// Sif animals need to be able to regenerate past their current HP value.
	if(istype(friend, /mob/living/simple_mob/animal/sif))
		var/mob/living/simple_mob/animal/sif/critter = friend
		return critter.health < (critter.getMaxHealth() * critter.sap_heal_threshold)

	// Other animals just need to be injured.
	return (friend.health < friend.maxHealth)

/mob/living/simple_mob/animal/sif/grafadreka/Initialize()

	charisma = rand(5, 15)
	stored_sap = rand(20, 30)
	nutrition = rand(400,500)

	if(gender == NEUTER)
		gender = pick(MALE, FEMALE)
	attacktext = claw_attacktext.Copy()

	setup_colours()
	create_reagents(50)

	. = ..()

	original_armor = armor
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

/mob/living/simple_mob/animal/sif/grafadreka/get_dietary_food_modifier(var/datum/reagent/nutriment/food)
	if(food.allergen_type & ALLERGEN_MEAT)
		return ..()
	return 0.25 // Quarter nutrition from non-meat.

/mob/living/simple_mob/animal/sif/grafadreka/handle_reagent_transfer(var/datum/reagents/holder, var/amount = 1, var/chem_type = CHEM_BLOOD, var/multiplier = 1, var/copy = 0)
	return holder.trans_to_holder(reagents, amount, multiplier, copy)

/mob/living/simple_mob/animal/sif/grafadreka/Life()
	. = ..()

	if(stat == CONSCIOUS)

		// Don't make clientless drakes lose nutrition or they'll all go feral.
		if(!resting && client)
			remove_nutrition(0.3)

		// Very slowly regenerate enough sap to defend ourselves. spit is 2 sap,
		// spit cooldown is 8s, life is 2s, so this is one free spit per 12 seconds.
		if(stored_sap < 10)
			add_sap(0.35)

	// Process food and sap chems.
	if(reagents?.total_volume)
		for(var/datum/reagent/chem in reagents.reagent_list)
			var/removed = clamp(chem.ingest_met, REM, chem.volume)
			chem.affect_animal(src, removed)
			reagents.remove_reagent(chem.id, removed)

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
	var/health_slowdown_threshold = round(maxHealth * 0.65)
	if(health < health_slowdown_threshold)
		. += round(5 * (1-(health / health_slowdown_threshold)), 0.1)
	var/nut_slowdown_threshold = round(max_nutrition * 0.65)
	if(nutrition < nut_slowdown_threshold)
		. += round(5 * (1-(nutrition / nut_slowdown_threshold)), 0.1)

/mob/living/simple_mob/animal/sif/grafadreka/update_icon()

	. = ..()

	if(sitting && stat == CONSCIOUS)
		icon_state = "[initial(icon_state)]_sitting"

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

	if(stat == CONSCIOUS && !sleeping)
		I = image(icon, "[icon_state]-eye_overlay")
		I.color = eye_colour
		add_images += I

	if(stat != DEAD)
		var/glow = add_glow()
		if(glow)
			add_images += glow

	for(var/image/adding in add_images)
		adding.appearance_flags |= (RESET_COLOR|PIXEL_SCALE|KEEP_APART)
		if(offset_compiled_icon)
			adding.pixel_x = offset_compiled_icon // Offset here so that things like modifiers, runechat text, etc. are centered
		add_overlay(adding)

	// We do this last so the default mob icon_state can be used for the overlays.
	current_icon_state = icon_state
	icon_state = "blank"
	color = COLOR_WHITE // Due to KEEP_TOGETHER etc. overlays ignore RESET_COLOR.

/mob/living/simple_mob/animal/sif/grafadreka/proc/add_glow()
	var/image/I = image(icon, "[icon_state]-glow")
	I.color = glow_colour
	I.plane = PLANE_LIGHTING_ABOVE
	I.alpha = 35 + round(220 * clamp(stored_sap/max_stored_sap, 0, 1))
	return I

/mob/living/simple_mob/animal/sif/grafadreka/get_eye_color()
	return eye_colour

/mob/living/simple_mob/animal/sif/grafadreka/do_tame(var/obj/O, var/mob/user)
	. = ..()
	attacked_by_neutral = FALSE

/mob/living/simple_mob/animal/sif/grafadreka/handle_special()
	..()
	if(client || world.time >= next_leader_check)
		next_leader_check = world.time + (60 SECONDS)
		check_leader_status()

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

		var/friend_ref = "\ref[friend]"
		global.wounds_being_tended_by_drakes[friend_ref] = world.time + (8 SECONDS)
		set_AI_busy(TRUE)

		if(!do_after(src, 8 SECONDS, friend) || QDELETED(friend) || friend.has_modifier_of_type(/datum/modifier/sifsap_salve) || incapacitated() || !spend_sap(10))
			global.wounds_being_tended_by_drakes -= friend_ref
			set_AI_busy(FALSE)
			return TRUE

		global.wounds_being_tended_by_drakes -= friend_ref
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

/mob/living/simple_mob/animal/sif/grafadreka/proc/get_pack_leader()
	var/pack = FALSE
	var/mob/living/simple_mob/animal/sif/grafadreka/leader
	if(!is_baby)
		leader = src
	for(var/mob/living/simple_mob/animal/sif/grafadreka/follower in hearers(7, loc))
		if(follower == src || follower.is_baby || follower.stat == DEAD || follower.faction != faction)
			continue
		pack = TRUE
		if(!leader || follower.charisma > leader.charisma)
			leader = follower
	if(pack)
		return leader

/mob/living/simple_mob/animal/sif/grafadreka/proc/check_leader_status()
	var/mob/living/simple_mob/animal/sif/grafadreka/leader = get_pack_leader()
	if(src == leader)
		add_modifier(/datum/modifier/ace, 60 SECONDS)
	else
		remove_modifiers_of_type(/datum/modifier/ace)

/mob/living/simple_mob/animal/sif/grafadreka/Stat()
	. = ..()
	if(statpanel("Status"))
		stat("Nutrition:", "[nutrition]/[max_nutrition]")
		stat("Stored sap:", "[stored_sap]/[max_stored_sap]")

/mob/living/simple_mob/animal/sif/grafadreka/proc/can_bite(var/mob/living/M)
	return istype(M) && (M.lying || M.confused || M.incapacitated())

/mob/living/simple_mob/animal/sif/grafadreka/apply_bonus_melee_damage(atom/A, damage_amount)
	// Melee attack on incapacitated or prone enemies bites instead of slashing
	var/last_attack_was_claws = attacking_with_claws
	attacking_with_claws = !can_bite(A)

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

/mob/living/simple_mob/animal/sif/grafadreka/Login()
	. = ..()
	charisma = (client && !is_baby) ? INFINITY : 0

/mob/living/simple_mob/animal/sif/grafadreka/Logout()
	. = ..()
	if(!client)
		charisma = rand(5, 15)

/datum/say_list/grafadreka
	speak = list("Chff!","Skhh.", "Rrrss...")
	emote_see = list("scratches its ears","grooms its spines", "sways its tail", "claws at the ground")
	emote_hear = list("hisses", "rattles", "rasps", "barks")

/obj/structure/animal_den/ghost_join/grafadreka
	name = "drake den"
	critter = /mob/living/simple_mob/animal/sif/grafadreka

/obj/structure/animal_den/ghost_join/grafadreka_hatchling
	name = "drake hatchling den"
	critter = /mob/living/simple_mob/animal/sif/grafadreka/hatchling

// Subtypes!
/mob/living/simple_mob/animal/sif/grafadreka/rainbow/setup_colours()
	glow_colour = get_random_colour(TRUE)
	fur_colour =  get_random_colour(TRUE)
	claw_colour = get_random_colour(TRUE)
	base_colour = get_random_colour(TRUE)
	eye_colour =  get_random_colour(TRUE)
	..()

/mob/living/simple_mob/animal/sif/grafadreka/hatchling
	name = "grafadreka hatchling"
	icon = 'icons/mob/drake_baby.dmi'
	mob_size = MOB_SMALL
	desc = "An immature snow drake, not long out of the shell."
	is_baby = TRUE
	offset_compiled_icon = null

	melee_damage_lower = 3
	melee_damage_upper = 5
	attack_armor_pen = 2
	bite_melee_damage_lower = 5
	bite_melee_damage_upper = 10
	bite_attack_armor_pen = 16

	projectiletype = /obj/item/projectile/drake_spit/weak
	maxHealth = 60
	health = 60
