/datum/category_item/catalogue/fauna/fennec
	name = "Wildlife - Fennec"
	desc = "Classification: Vulpes zerda maxima\
	<br><br>\
	The Fennec fox is a small crepuscular fox native to Earth in Sol that nearly went extinct in the 2030s.\
	Through conservation efforts and the rise of space colonies, the Fennec was brought back from the brink \
	and is now labeled as 'Least Concern'. During the great Sol Expansion Period, Fennec were brought with \
	colonist as a means of companionship and as a ecosystem balance for desert worlds such as Virgo 4. \
	Their presence on Virgo 4 is largely due to convergent evolution. While their genetics are closely \
	related to their Sol counterparts, they are in fact a totally different species of fennec that have followed. \
	a separate evolutional path. Virgo Fennec are upwards of five times larger than their Sol cousins and consequently \
	have a larger appetite. Their diet mainly consists of whatever small creatures that they manage to scrounge from \
	the sands of Virgo 4, however they have been known to hunt larger prey in desperate times.\
	<br>\
	Fennec foxes reach sexual maturity at around nine months and mate between January and April \
	They usually breed only once per year. After mating, the male becomes very aggressive and protects \
	the female, provides her with food during pregnancy and lactation.\
	<br>\
	Virgo Fennecs have been observed to be passive and do not actively hunt large prey as their bodies have \
	grown accustomed to less available food sources. However, travellers are still cautioned on approaching \
	them as Virgo Fennec have been known to swallow prey whole depending on the prey's size."
	value = CATALOGUER_REWARD_TRIVIAL

/mob/living/simple_mob/vore/fennec
	name = "fennec" //why isn't this in the fox file, fennecs are foxes silly.
	desc = "It's a dusty big-eared sandfox! Adorable!"
	tt_desc = "Vulpes zerda maxima"
	catalogue_data = list(/datum/category_item/catalogue/fauna/fennec)

	icon_state = "fennec"
	icon_living = "fennec"
	icon_dead = "fennec_dead"
	icon_rest = "fennec_rest"
	icon = 'icons/mob/vore.dmi'

	faction = "fennec"
	maxHealth = 30
	health = 30

	response_help = "pats"
	response_disarm = "gently pushes aside"
	response_harm = "hits"

	meat_amount = 2
	meat_type = /obj/item/weapon/reagent_containers/food/snacks/meat/fox

	harm_intent_damage = 5
	melee_damage_lower = 1
	melee_damage_upper = 3
	attacktext = list("bapped")

	say_list_type = /datum/say_list/fennec
	ai_holder_type = /datum/ai_holder/simple_mob/passive

// Activate Noms!
/mob/living/simple_mob/vore/fennec
	vore_active = 1
	vore_bump_chance = 10
	vore_bump_emote	= "playfully lunges at"
	vore_pounce_chance = 40
	vore_default_mode = DM_HOLD
	vore_icons = SA_ICON_LIVING

/datum/say_list/fennec
	speak = list("SKREEEE!","Chrp?","Ararrrararr.")
	emote_hear = list("screEEEEeeches!","chirps.")
	emote_see = list("earflicks","sniffs at the ground")

// LORG FEN
/datum/category_item/catalogue/fauna/fennec_huge
	name = "Wildlife - Fennec??"
	desc = "Classification: Vulpes zerda megaxia\
	<br><br>This is an unreasonably large fennec..."
	value = CATALOGUER_REWARD_HARD

/mob/living/simple_mob/vore/fennec/huge
	icon = 'icons/mob/vore100x100.dmi'
	icon_rest = null

	// LORG
	maxHealth = 500
	health = 500
	harm_intent_damage = 40
	melee_damage_lower = 20
	melee_damage_upper = 60
	mob_bump_flag = HEAVY
	grab_resist = 100
	mob_class = MOB_CLASS_HUMANOID
	movement_cooldown = -1
	melee_miss_chance = 10

	old_x = -32
	pixel_x = -32
	default_pixel_x = -32

	// If you're immune to digestion, they can't digest you anyway!
	vore_ignores_undigestable = TRUE
	vore_default_mode = DM_DIGEST
	devourable = FALSE // until KO'd
	vore_icons = 0

	// Handled in apply_attack
	vore_pounce_successrate = 100
	vore_pounce_chance = 0
	vore_capacity = 5
	vore_bump_emote	= "quickly snatches up"

	attacktext = list("stomped","kicked")
	friendly = list("pet pats", "pats the head of")

	response_help = "pats the paw of"
	response_disarm = "somehow shoves aside"

	ai_holder_type = /datum/ai_holder/simple_mob/retaliate/cooperative
	var/image/bigshadow
	var/autodoom = TRUE

/mob/living/simple_mob/vore/fennec/huge/Initialize()
	. = ..()
	bigshadow = image(icon, icon_state = "shadow")
	bigshadow.plane = MOB_PLANE
	bigshadow.layer = BELOW_MOB_LAYER
	bigshadow.appearance_flags = RESET_COLOR|RESET_TRANSFORM
	add_overlay(bigshadow)

/mob/living/simple_mob/vore/fennec/huge/update_icon()
	. = ..()
	add_overlay(bigshadow)

/mob/living/simple_mob/vore/fennec/huge/init_vore()
	..()
	var/obj/belly/B = vore_selected
	B.name = "Stomach"
	B.desc = "The slimy wet insides of a rather large fennec! Not quite as clean as the fen on the outside."
	B.human_prey_swallow_time = 5
	B.nonhuman_prey_swallow_time = 5

	/* todo
	B.emote_lists[DM_HOLD] = list()
	B.emote_lists[DM_DIGEST] = list()
	B.digest_messages_prey = list()
	*/

/mob/living/simple_mob/vore/fennec/huge/death()
	devourable = TRUE
	return ..()

/mob/living/simple_mob/vore/fennec/huge/apply_attack(atom/A, damage_to_do)
	// We may stomp or instanom in combat
	if(autodoom && isliving(A) && (damage_to_do >= (melee_damage_upper*0.9)))
		var/mob/living/L = A
		if(will_eat(L))
			var/obj/belly/B = vore_organs[1]
			custom_emote(message = "snatches and devours [L]!")
			B.nom_mob(L)
			ai_holder.find_target()
			return
		else if(L.size_multiplier <= 0.5 && L.step_mechanics_pref)
			custom_emote(message = "stomps [L] into oblivion!")
			L.gib()
			return
		else
			return ..()
	return ..()
