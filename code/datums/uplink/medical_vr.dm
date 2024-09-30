/**********
* Medical *
**********/
/datum/uplink_item/item/medical/pizza
	name = "Free Pizza Voucher"
	item_cost = 5
	path = /obj/item/pizzavoucher

/datum/uplink_item/item/medical/mre
	name = "Meal, Ready to eat (Random)"
	item_cost = 5
	path = /obj/item/storage/mre/random

/datum/uplink_item/item/medical/protein
	name = "Meal, Ready to eat (Protein)"
	item_cost = 5
	path = /obj/item/storage/mre/menu10

/datum/uplink_item/item/medical/emergency
	name = "Meal, Ready to eat (Emergency)"
	item_cost = 5
	path = /obj/item/storage/mre/menu11

/datum/uplink_item/item/medical/medical
	name = "Meal, Ready to eat (medical)"
	item_cost = 5
	path = /obj/item/storage/mre/menu13

/datum/uplink_item/item/medical/glucose
	name = "Glucose injector"
	item_cost = 5
	path = /obj/item/reagent_containers/hypospray/autoinjector/biginjector/glucose

/datum/uplink_item/item/medical/purity
	name = "Purity injector"
	item_cost = 5
	path = /obj/item/reagent_containers/hypospray/autoinjector/biginjector/purity

/datum/uplink_item/item/medical/pain
	name = "Pain injector"
	item_cost = 5
	path = /obj/item/reagent_containers/hypospray/autoinjector/biginjector/pain

/datum/uplink_item/item/medical/brute
	name = "Brute injector"
	item_cost = 5
	path = /obj/item/reagent_containers/hypospray/autoinjector/biginjector/brute

/datum/uplink_item/item/medical/burn
	name = "Burn injector"
	item_cost = 5
	path = /obj/item/reagent_containers/hypospray/autoinjector/biginjector/burn

/datum/uplink_item/item/medical/toxin
	name = "Toxin injector"
	item_cost = 5
	path = /obj/item/reagent_containers/hypospray/autoinjector/biginjector/toxin

/datum/uplink_item/item/medical/oxy
	name = "Oxy injector"
	item_cost = 5
	path = /obj/item/reagent_containers/hypospray/autoinjector/biginjector/oxy

/datum/uplink_item/item/medical/fire
	name = "Fire medical kit"
	item_cost = 10
	path = /obj/item/storage/firstaid/fire

/datum/uplink_item/item/medical/toxin
	name = "Toxin medical kit"
	item_cost = 10
	path = /obj/item/storage/firstaid/toxin

/datum/uplink_item/item/medical/o2
	name = "Oxygen medical kit"
	item_cost = 10
	path = /obj/item/storage/firstaid/o2

/datum/uplink_item/item/medical/adv
	name = "Advanced medical kit"
	item_cost = 10
	path = /obj/item/storage/firstaid/adv

/datum/uplink_item/item/medical/organ
	name = "Organ Repair injector"
	item_cost = 10
	path = /obj/item/reagent_containers/hypospray/autoinjector/biginjector/organ

/datum/uplink_item/item/medical/stasis
	name = "Stasis Bag"
	item_cost = 20
	path = /obj/item/bodybag/cryobag

/datum/uplink_item/item/medical/synth
	name = "Synthmorph Bag"
	item_cost = 20
	path = /obj/item/bodybag/cryobag/robobag

/datum/uplink_item/item/medical/nanites
	name = "Healing Nanite pill bottle"
	item_cost = 30
	path = /obj/item/storage/pill_bottle/healing_nanites

/datum/uplink_item/item/medical/vermicetol
	name = "Vermicetol Bottle"
	item_cost = 30
	path = /obj/item/reagent_containers/glass/bottle/vermicetol
	antag_roles = list("ert")
	blacklisted = 1

/datum/uplink_item/item/medical/dermaline
	name = "Dermaline Bottle"
	item_cost = 30
	path = /obj/item/reagent_containers/glass/bottle/dermaline
	antag_roles = list("ert")
	blacklisted = 1

/datum/uplink_item/item/medical/carthatoline
	name = "Carthatoline Bottle"
	item_cost = 30
	path = /obj/item/reagent_containers/glass/bottle/carthatoline
	antag_roles = list("ert")
	blacklisted = 1

/datum/uplink_item/item/medical/dexalinp
	name = "Dexalin Plus Bottle"
	item_cost = 30
	path = /obj/item/reagent_containers/glass/bottle/dexalinp
	antag_roles = list("ert")
	blacklisted = 1

/datum/uplink_item/item/medical/tramadol
	name = "Tramadol Bottle"
	item_cost = 30
	path = /obj/item/reagent_containers/glass/bottle/tramadol
	antag_roles = list("ert")
	blacklisted = 1

/datum/uplink_item/item/medical/arithrazine
	name = "Arithrazine Bottle"
	item_cost = 50
	path = /obj/item/reagent_containers/glass/bottle/arithrazine
	antag_roles = list("ert")
	blacklisted = 1

/datum/uplink_item/item/medical/corophizine
	name = "Corophizine Bottle"
	item_cost = 50
	path = /obj/item/reagent_containers/glass/bottle/corophizine
	antag_roles = list("ert")
	blacklisted = 1

/datum/uplink_item/item/medical/rezadone
	name = "Rezadone Bottle"
	item_cost = 50
	path = /obj/item/reagent_containers/glass/bottle/rezadone
	antag_roles = list("ert")
	blacklisted = 1

/datum/uplink_item/item/medical/defib
	name = "Combat Defibrilator"
	item_cost = 90
	path = /obj/item/defib_kit/compact/combat
	antag_roles = list("mercenary", "ert")
	blacklisted = 1
