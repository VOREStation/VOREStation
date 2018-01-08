/obj/item/weapon/reagent_containers/hypospray/autoinjector/biginjector
	name = "empty hypo"
	desc = "A refined version of the standard autoinjector, allowing greater capacity."
	icon_state = "autoinjector"
	amount_per_transfer_from_this = 15
	volume = 15
	origin_tech = list(TECH_BIO = 4)
	filled_reagents = list("inaprovaline" = 15)

/obj/item/weapon/reagent_containers/hypospray/autoinjector/biginjector/New()
	..()


/datum/technomancer/consumable/hypo_brute
	name = "Trauma Hypo"
	desc = "A extended capacity hypo which can treat blunt trauma."
	cost = 25
	obj_path = /obj/item/weapon/reagent_containers/hypospray/autoinjector/biginjector/brute

/datum/technomancer/consumable/hypo_burn
	name = "Burn Hypo"
	desc = "A extended capacity hypo which can treat severe burns."
	cost = 25
	obj_path = /obj/item/weapon/reagent_containers/hypospray/autoinjector/biginjector/burn

/datum/technomancer/consumable/hypo_tox
	name = "Toxin Hypo"
	desc = "A extended capacity hypo which can treat various toxins."
	cost = 25
	obj_path = /obj/item/weapon/reagent_containers/hypospray/autoinjector/biginjector/toxin

/datum/technomancer/consumable/hypo_oxy
	name = "Oxy Hypo"
	desc = "A extended capacity hypo which can treat oxygen deprivation."
	cost = 25
	obj_path = /obj/item/weapon/reagent_containers/hypospray/autoinjector/biginjector/oxy

/datum/technomancer/consumable/hypo_purity
	name = "Purity Hypo"
	desc = "A extended capacity hypo which can remove various inpurities in the system such as viruses, infections, \
	radiation, and genetic problems."
	cost = 25
	obj_path = /obj/item/weapon/reagent_containers/hypospray/autoinjector/biginjector/purity

/datum/technomancer/consumable/hypo_pain
	name = "Pain Hypo"
	desc = "A extended capacity hypo which contains potent painkillers."
	cost = 25
	obj_path = /obj/item/weapon/reagent_containers/hypospray/autoinjector/biginjector/pain

/datum/technomancer/consumable/hypo_organ
	name = "Organ Hypo"
	desc = "A extended capacity hypo which is designed to fix internal organ problems."
	cost = 50
	obj_path = /obj/item/weapon/reagent_containers/hypospray/autoinjector/biginjector/organ

/datum/technomancer/consumable/hypo_combat
	name = "Combat Hypo"
	desc = "A extended capacity hypo containing a dangerous cocktail of various combat stims."
	cost = 75
	obj_path = /obj/item/weapon/reagent_containers/hypospray/autoinjector/biginjector/combat


/obj/item/weapon/reagent_containers/hypospray/autoinjector/biginjector/brute
	name = "trauma hypo"
	desc = "A refined version of the standard autoinjector, allowing greater capacity.  This one is made to be used on victims of \
	moderate blunt trauma."
	filled_reagents = list("bicaridine" = 15)

/obj/item/weapon/reagent_containers/hypospray/autoinjector/biginjector/burn
	name = "burn hypo"
	desc = "A refined version of the standard autoinjector, allowing greater capacity.  This one is made to be used on burn victims, \
	featuring an optimized chemical mixture to allow for rapid healing."
	filled_reagents = list("kelotane" = 7.5, "dermaline" = 7.5)

/obj/item/weapon/reagent_containers/hypospray/autoinjector/biginjector/toxin
	name = "toxin hypo"
	desc = "A refined version of the standard autoinjector, allowing greater capacity.  This one is made to counteract toxins."
	filled_reagents = list("anti_toxin" = 15)

/obj/item/weapon/reagent_containers/hypospray/autoinjector/biginjector/oxy
	name = "oxy hypo"
	desc = "A refined version of the standard autoinjector, allowing greater capacity.  This one is made to counteract oxygen \
	deprivation."
	filled_reagents = list("dexalinp" = 10, "tricordrazine" = 5)

/obj/item/weapon/reagent_containers/hypospray/autoinjector/biginjector/purity
	name = "purity hypo"
	desc = "A refined version of the standard autoinjector, allowing greater capacity.  This variant excels at \
	resolving viruses, infections, radiation, and genetic maladies."
	filled_reagents = list("spaceacillin" = 9, "arithrazine" = 5, "ryetalyn" = 1)

/obj/item/weapon/reagent_containers/hypospray/autoinjector/biginjector/pain
	name = "pain hypo"
	desc = "A refined version of the standard autoinjector, allowing greater capacity.  This one contains potent painkillers."
	filled_reagents = list("tramadol" = 15)

/obj/item/weapon/reagent_containers/hypospray/autoinjector/biginjector/organ
	name = "organ hypo"
	desc = "A refined version of the standard autoinjector, allowing greater capacity.  Organ damage is resolved by this variant."
	filled_reagents = list("alkysine" = 1, "imidazoline" = 1, "peridaxon" = 13)

/obj/item/weapon/reagent_containers/hypospray/autoinjector/biginjector/combat
	name = "combat hypo"
	desc = "A refined version of the standard autoinjector, allowing greater capacity.  This is a more dangerous and potentially \
	addictive hypo compared to others, as it contains a potent cocktail of various chemicals to optimize the recipient's combat \
	ability."
	filled_reagents = list("bicaridine" = 3, "kelotane" = 1.5, "dermaline" = 1.5, "oxycodone" = 3, "hyperzine" = 3, "tricordrazine" = 3)
