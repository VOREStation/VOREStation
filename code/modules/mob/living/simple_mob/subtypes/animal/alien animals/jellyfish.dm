GLOBAL_VAR_CONST(max_jellyfish, 50)
GLOBAL_VAR_INIT(jellyfish_count, 0)


/datum/category_item/catalogue/fauna/space_jellyfish
	name = "Alien Wildlife - Space Jellyfish"
	desc = "A hostile space predator. \
			This space jellyfish uses hypnotic patterns to lure in prey, which it then wraps in tentacles to leech energy from.\
			It is somewhat weak, but uses unknown means to stun prey. It uses the energy of its prey to replicate itself. \
			These creatures can quickly grow out of control if left to feed and reproduce unchecked. \
			Notable weakness to rapid cooling from ice based weaponry.\
			The flesh is typically non-toxic and quite delicious. Their cores are considered a delicacy in many regions."
	value = CATALOGUER_REWARD_EASY


/mob/living/simple_mob/vore/alienanimals/space_jellyfish
	name = "space jellyfish"
	desc = "A semi-translucent space creature, possessing of tentacles and a hypnotizing, flashing bio-luminescent display."
	tt_desc = "Semaeostomeae Stellarus"
	catalogue_data = list(/datum/category_item/catalogue/fauna/space_jellyfish)

	icon = 'icons/mob/alienanimals_x32.dmi'
	icon_state = "space_jellyfish"
	icon_living = "space_jellyfish"
	icon_dead = "space_jellyfish_dead"
	has_eye_glow = TRUE
	hovering = TRUE


	faction = "jellyfish"
	maxHealth = 100
	health = 100
	nutrition = 150
	pass_flags = PASSTABLE
	movement_cooldown = 1

	see_in_dark = 10

	response_help  = "pets"
	response_disarm = "gently pushes aside"
	response_harm   = "punches"

	harm_intent_damage = 1
	melee_damage_lower = 1
	melee_damage_upper = 2
	attack_sharp = FALSE
	attack_sound = 'sound/weapons/tap.ogg'
	attacktext = list("drained", "bludgeoned", "wraped", "tentacle whipped")

	ai_holder_type = /datum/ai_holder/simple_mob/melee/evasive/jellyfish

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

	speak_emote = list("thrumms")

	meat_amount = 0
	meat_type = /obj/item/reagent_containers/food/snacks/jellyfishcore

	say_list_type = /datum/say_list/jellyfish

	vore_active = 1
	vore_capacity = 1
	vore_bump_chance = 25
	vore_ignores_undigestable = 0
	vore_default_mode = DM_DRAIN
	vore_icons = SA_ICON_LIVING
	vore_stomach_name = "internal chamber"
	vore_default_contamination_flavor = "Wet"
	vore_default_contamination_color = "grey"
	vore_default_item_mode = IM_DIGEST

	var/reproduction_cooldown = 0

/datum/say_list/jellyfish
	emote_see = list("flickers", "flashes", "looms","pulses","sways","shimmers hypnotically")


/mob/living/simple_mob/vore/alienanimals/space_jellyfish/init_vore()
	..()
	var/obj/belly/B = vore_selected
	B.name = "internal chamber"
	B.desc = "It's smooth and translucent. You can see the world around you distort and wobble with the movement of the space jellyfish. It floats casually, while the delicate flesh seems to form to you. It's surprisingly cool, and flickers with its own light. You're on display for all to see, trapped within the confines of this strange space alien!"
	B.mode_flags = 40
	B.digest_brute = 0.5
	B.digest_burn = 0.5
	B.digestchance = 0
	B.absorbchance = 0
	B.escapechance = 15


/mob/living/simple_mob/vore/alienanimals/space_jellyfish/apply_melee_effects(var/atom/A)
	if(isliving(A))
		var/mob/living/L = A
		var/leech = rand(1,100)
		if(L.nutrition)
			L.adjust_nutrition(-leech)
			adjust_nutrition(leech)
		if(prob(25))
			L.adjustHalLoss(leech)

/mob/living/simple_mob/vore/alienanimals/space_jellyfish/New(newloc, jellyfish)
	GLOB.jellyfish_count ++
	var/mob/living/simple_mob/vore/alienanimals/space_jellyfish/parent = jellyfish
	if(parent)
		parent.faction = faction
	..()

/mob/living/simple_mob/vore/alienanimals/space_jellyfish/death()
	. = ..()
	new /obj/item/reagent_containers/food/snacks/jellyfishcore(loc, nutrition)
	GLOB.jellyfish_count --
	qdel(src)

/mob/living/simple_mob/vore/alienanimals/space_jellyfish/Life()
	. = ..()
	if(client)
		return
	reproduce()

/mob/living/simple_mob/vore/alienanimals/space_jellyfish/proc/reproduce()
	if(reproduction_cooldown > 0)
		reproduction_cooldown --
		return
	if(GLOB.jellyfish_count >= GLOB.max_jellyfish)
		return
	if(nutrition < 500)
		return
	if(prob(10))
		new /mob/living/simple_mob/vore/alienanimals/space_jellyfish(loc, src)
		adjust_nutrition(-400)
		reproduction_cooldown = 60

/mob/living/simple_mob/vore/alienanimals/space_jellyfish/Process_Spacemove(var/check_drift = 0)
	return TRUE

/datum/ai_holder/simple_mob/melee/evasive/jellyfish
	hostile = TRUE
	cooperative = FALSE
	retaliate = TRUE
	speak_chance = 2
	wander = TRUE
	unconscious_vore = TRUE

/obj/item/reagent_containers/food/snacks/jellyfishcore
	name = "jellyfish core"
	icon = 'icons/obj/food_vr.dmi'
	icon_state = "jellyfish_core"
	desc = "The pulsing core of a space jellyfish! ... It smells delicious."
	nutriment_amt = 50
	bitesize = 1000
	nutriment_desc = list("heavenly space meat" = 100)

	var/inherited_nutriment = 0

/obj/item/reagent_containers/food/snacks/jellyfishcore/New(newloc, inherit)
	inherited_nutriment	= inherit
	. = ..()

/obj/item/reagent_containers/food/snacks/jellyfishcore/Initialize()
	nutriment_amt += inherited_nutriment
	. = ..()
	reagents.add_reagent("nutriment", nutriment_amt, nutriment_desc)
