/datum/category_item/catalogue/fauna/skeleton
	name = "Alien Wildlife - Space Skeleton"
	desc = "Classification: Sentientis osseous\
	<br><br>\
	No one, not scientist or wildlife expert can properly explain these spacial skeletons with any solid \
	certanty. They are not human, despite the clear simularites to a human's skeleton, nor are they made of \
	calcium like normal bones. Samples taken from the corpses of these strange creatures have yeiled little \
	in the form of answers and have only raised more questions with regards to their general existence. \
	Scientist are still studying these beings, a difficult task as they are difficult to come by in the \
	vaccum of space. The only information that scientist are able to gather about these so-called 'Space \
	Skeletons' as people have come to call them is that their structure is comprised of a strange cell \
	structure that is similar to plants - likely because these creatures are known to feed of the UV \
	rays of nearby stars."
	value = CATALOGUER_REWARD_MEDIUM

/mob/living/simple_mob/vore/alienanimals/skeleton
	name = "skeleton"
	desc = "An arrangement of what appears to be bones, given life and mobility. It looks REALLY spooky."
	catalogue_data = list(/datum/category_item/catalogue/fauna/skeleton)

	icon = 'icons/mob/alienanimals_x32.dmi'
	icon_state = "skeleton"
	icon_living = "skeleton"
	icon_dead = "skeleton_dead"

	faction = "space skeleton"
	maxHealth = 100
	health = 100
	movement_cooldown = 1
	movement_sound = 'sound/effects/skeleton_walk.ogg' //VERY IMPORTANT

	see_in_dark = 10

	response_help  = "rattles"
	response_disarm = "shoves aside"
	response_harm   = "smashes"

	melee_damage_lower = 1
	melee_damage_upper = 10
	attack_sharp = FALSE
	attacktext = list("spooked", "startled", "jumpscared", "rattled at")

	ai_holder_type = /datum/ai_holder/simple_mob/melee/evasive/skeleton

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

	loot_list = list(
		/obj/item/weapon/bone = 25,
		/obj/item/weapon/bone/skull = 25,
		/obj/item/weapon/bone/ribs = 25,
		/obj/item/weapon/bone/arm = 25,
		/obj/item/weapon/bone/leg = 25
		)

	speak_emote = list("rattles")

	say_list_type = /datum/say_list/skeleton

	vore_active = 1
	vore_capacity = 1
	vore_bump_chance = 5
	vore_ignores_undigestable = 0
	vore_default_mode = DM_DRAIN
	vore_icons = SA_ICON_LIVING
	vore_stomach_name = "stomach"
	vore_default_contamination_flavor = "Wet"
	vore_default_contamination_color = "grey"
	vore_default_item_mode = IM_DIGEST

/datum/say_list/skeleton
	speak = list("Nyeh heh heeeh","NYAAAAHHHH", "Books are the real treasures of the world!", "Why are skeletons so calm? Because nothing gets under their skin.","When does a skeleton laugh? When someone tickels their funny bone!","What is a skeleton’s favorite mode of transport? A scare-plane.", "What did the skeleton say to the vampire? 'You suck.'","What is a skeleton’s favorite thing to do with their cell phone? Take skelfies.", "How did the skeleton know the other skeleton was lying? He could see right through him.","What’s a skeleton’s least favorite room in the house? The living room.", "How much does an elephant skeleton weigh? Skele-tons.", "Why do skeletons drink so much milk? It’s good for the bones!", "Where do bad jokes about skeletons belong? In the skelebin.","What does a skeleton use to cut through objects? A shoulder blade.", "What kind of jokes do skeletons tell? Humerus ones.")
	emote_see = list("spins its head around", "shuffles","shambles","practices on the xylophone","drinks some milk","looks at you. Its hollow, bottomless sockets gaze into you greedily.")
	emote_hear = list("rattles","makes a spooky sound","cackles madly","plinks","clacks")

/mob/living/simple_mob/vore/alienanimals/skeleton/init_vore()
	..()
	var/obj/belly/B = vore_selected
	B.name = "stomach"
	B.desc = "You're not sure quite how, but you've found your way inside of the skeleton's stomach! It's cramped and cold and sounds heavily of xylophones!"
	B.mode_flags = 40
	B.digest_brute = 0.5
	B.digest_burn = 0.5
	B.digestchance = 10
	B.absorbchance = 0
	B.escapechance = 25

/mob/living/simple_mob/vore/alienanimals/skeleton/death(gibbed, deathmessage = "falls down and stops moving...")
	. = ..()

/datum/ai_holder/simple_mob/melee/evasive/skeleton
	hostile = TRUE
	retaliate = TRUE
	destructive = TRUE
	violent_breakthrough = TRUE
