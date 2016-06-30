/datum/technomancer/equipment/default_core
	name = "Manipulation Core"
	desc = "The default core that you most likely already have.  This is here in-case you change your mind after buying \
	another core, don't forget to refund the old core.  This has a capacity of 10,000 units of energy, and recharges at a \
	rate of 50 units."
	cost = 100
	obj_path = /obj/item/weapon/technomancer_core

/datum/technomancer/equipment/rapid_core
	name = "Rapid Core"
	desc = "A core optimized for passive regeneration, however at the cost of capacity.  Has a capacity of 7,000 units of energy, and \
	recharges at a rate of 70 units."
	cost = 150
	obj_path = /obj/item/weapon/technomancer_core/rapid

/datum/technomancer/equipment/bulky_core
	name = "Bulky Core"
	desc = "This core has very large capacitors, however it also has a subpar fractal reactor.  The user is recommended to \
	purchase one or more energy-generating Functions as well if using this core.  Has a capacity of 20,000 units of energy, \
	and recharges at a rate of 25 units."
	cost = 150
	obj_path = /obj/item/weapon/technomancer_core/bulky

/datum/technomancer/equipment/unstable
	name = "Unstable Core"
	desc = "This core feeds off unstable energies around the user in addition to a fractal reactor.  This means that it performs \
	better as the user has more instability, which could prove dangerous to the inexperienced or unprepared.  Has a capacity of 13,000 \
	units of energy, and recharges at a rate of 35 units at no instability, and approximately 110 units when within the \
	'yellow zone' of instability."
	cost = 150
	obj_path = /obj/item/weapon/technomancer_core/unstable

/datum/technomancer/equipment/hypo_belt
	name = "Hypo Belt"
	desc = "A medical belt designed to carry autoinjectors and other medical equipment.  Comes with one of each hypo."
	cost = 100
	obj_path = /obj/item/weapon/storage/belt/medical/technomancer

/obj/item/weapon/storage/belt/medical/technomancer
	name = "hypo belt"
	desc = "A medical belt designed to carry autoinjectors and other medical equipment."

/obj/item/weapon/storage/belt/medical/technomancer/New()
	new /obj/item/weapon/reagent_containers/hypospray/autoinjector/biginjector/brute(src)
	new /obj/item/weapon/reagent_containers/hypospray/autoinjector/biginjector/burn(src)
	new /obj/item/weapon/reagent_containers/hypospray/autoinjector/biginjector/toxin(src)
	new /obj/item/weapon/reagent_containers/hypospray/autoinjector/biginjector/oxy(src)
	new /obj/item/weapon/reagent_containers/hypospray/autoinjector/biginjector/purity(src)
	new /obj/item/weapon/reagent_containers/hypospray/autoinjector/biginjector/pain(src)
	new /obj/item/weapon/reagent_containers/hypospray/autoinjector/biginjector/organ(src)
	new /obj/item/weapon/reagent_containers/hypospray/autoinjector/biginjector/combat(src)
	..()

/datum/technomancer/equipment/thermals
	name = "Thermoncle"
	desc = "A fancy monocle with a thermal optics lens installed.  Allows you to see people across walls."
	cost = 150
	obj_path = /obj/item/clothing/glasses/thermal/plain/monocle

/datum/technomancer/equipment/med_hud
	name = "Medical HUD"
	desc = "A commonly available HUD for medical professionals, which displays how healthy an individual is.  \
	Recommended for support-based apprentices!"
	cost = 30
	obj_path = /obj/item/clothing/glasses/thermal/plain/monocle


/datum/technomancer/equipment/scepter
	name = "Scepter of Empowerment"
	desc = "A gem sometimes found in the depths of asteroids makes up the basis for this device.  Energy is channeled into it from \
	the Core and the user, causing many functions to be enhanced in various ways, so long as it is held in the off-hand.  \
	Be careful not to lose this!"
	cost = 300
	obj_path = /obj/item/weapon/scepter

/obj/item/weapon/scepter
	name = "scepter of empowerment"
	desc = "It's a purple gem, attached to a rod and a handle, along with small wires.  It looks like it would make a good club."
	icon = 'icons/obj/technomancer.dmi'
	icon_state = "scepter"
	force = 15

/obj/item/weapon/scepter/attack_self(mob/living/carbon/human/user)
	var/obj/item/item_to_test = user.get_other_hand(src)
	if(istype(item_to_test, /obj/item/weapon/spell))
		var/obj/item/weapon/spell/S = item_to_test
		S.on_scepter_use_cast(user)

/obj/item/weapon/scepter/afterattack(atom/target, mob/living/carbon/human/user, proximity_flag, click_parameters)
	if(proximity_flag)
		return ..()
	var/obj/item/item_to_test = user.get_other_hand(src)
	if(istype(item_to_test, /obj/item/weapon/spell))
		var/obj/item/weapon/spell/S = item_to_test
		S.on_scepter_ranged_cast(target, user)