/* First aid storage
 * Contains:
 *		First Aid Kits
 * 		Pill Bottles
 */

/*
 * First Aid Kits
 */
/obj/item/weapon/storage/firstaid
	name = "first aid kit"
	desc = "It's an emergency medical kit for those serious boo-boos."
	icon_state = "firstaid"
	throw_speed = 2
	throw_range = 8
	var/empty = 0
	max_storage_space = ITEMSIZE_COST_SMALL * 7 // 14


/obj/item/weapon/storage/firstaid/fire
	name = "fire first aid kit"
	desc = "It's an emergency medical kit for when the toxins lab <i>spontaneously</i> burns down."
	icon_state = "ointment"
	item_state_slots = list(slot_r_hand_str = "firstaid-ointment", slot_l_hand_str = "firstaid-ointment")

	New()
		..()
		if (empty) return

		icon_state = pick("ointment","firefirstaid")

		new /obj/item/device/healthanalyzer( src )
		new /obj/item/weapon/reagent_containers/hypospray/autoinjector( src )
		new /obj/item/stack/medical/ointment( src )
		new /obj/item/stack/medical/ointment( src )
		new /obj/item/weapon/reagent_containers/pill/kelotane( src )
		new /obj/item/weapon/reagent_containers/pill/kelotane( src )
		new /obj/item/weapon/reagent_containers/pill/kelotane( src ) //Replaced ointment with these since they actually work --Errorage
		return


/obj/item/weapon/storage/firstaid/regular
	icon_state = "firstaid"

	New()
		..()
		if (empty) return
		new /obj/item/stack/medical/bruise_pack(src)
		new /obj/item/stack/medical/bruise_pack(src)
		new /obj/item/stack/medical/bruise_pack(src)
		new /obj/item/stack/medical/ointment(src)
		new /obj/item/stack/medical/ointment(src)
		new /obj/item/device/healthanalyzer(src)
		new /obj/item/weapon/reagent_containers/hypospray/autoinjector( src )
		return

/obj/item/weapon/storage/firstaid/toxin
	name = "poison first aid kit" //IRL the term used would be poison first aid kit.
	desc = "Used to treat when one has a high amount of toxins in their body."
	icon_state = "antitoxin"
	item_state_slots = list(slot_r_hand_str = "firstaid-toxin", slot_l_hand_str = "firstaid-toxin")

	New()
		..()
		if (empty) return

		icon_state = pick("antitoxin","antitoxfirstaid","antitoxfirstaid2","antitoxfirstaid3")

		new /obj/item/weapon/reagent_containers/syringe/antitoxin( src )
		new /obj/item/weapon/reagent_containers/syringe/antitoxin( src )
		new /obj/item/weapon/reagent_containers/syringe/antitoxin( src )
		new /obj/item/weapon/reagent_containers/pill/antitox( src )
		new /obj/item/weapon/reagent_containers/pill/antitox( src )
		new /obj/item/weapon/reagent_containers/pill/antitox( src )
		new /obj/item/device/healthanalyzer( src )
		return

/obj/item/weapon/storage/firstaid/o2
	name = "oxygen deprivation first aid kit"
	desc = "A box full of oxygen goodies."
	icon_state = "o2"
	item_state_slots = list(slot_r_hand_str = "firstaid-o2", slot_l_hand_str = "firstaid-o2")

	New()
		..()
		if (empty) return
		new /obj/item/weapon/reagent_containers/pill/dexalin( src )
		new /obj/item/weapon/reagent_containers/pill/dexalin( src )
		new /obj/item/weapon/reagent_containers/pill/dexalin( src )
		new /obj/item/weapon/reagent_containers/pill/dexalin( src )
		new /obj/item/weapon/reagent_containers/hypospray/autoinjector( src )
		new /obj/item/weapon/reagent_containers/syringe/inaprovaline( src )
		new /obj/item/device/healthanalyzer( src )
		return

/obj/item/weapon/storage/firstaid/adv
	name = "advanced first aid kit"
	desc = "Contains advanced medical treatments, for <b>serious</b> boo-boos."
	icon_state = "advfirstaid"
	item_state_slots = list(slot_r_hand_str = "firstaid-advanced", slot_l_hand_str = "firstaid-advanced")

/obj/item/weapon/storage/firstaid/adv/New()
	..()
	if (empty) return
	new /obj/item/weapon/reagent_containers/hypospray/autoinjector( src )
	new /obj/item/stack/medical/advanced/bruise_pack(src)
	new /obj/item/stack/medical/advanced/bruise_pack(src)
	new /obj/item/stack/medical/advanced/bruise_pack(src)
	new /obj/item/stack/medical/advanced/ointment(src)
	new /obj/item/stack/medical/advanced/ointment(src)
	new /obj/item/stack/medical/splint(src)
	return

/obj/item/weapon/storage/firstaid/combat
	name = "combat medical kit"
	desc = "Contains advanced medical treatments."
	icon_state = "bezerk"
	item_state_slots = list(slot_r_hand_str = "firstaid-advanced", slot_l_hand_str = "firstaid-advanced")

/obj/item/weapon/storage/firstaid/combat/New()
	..()
	if (empty) return
	new /obj/item/weapon/storage/pill_bottle/bicaridine(src)
	new /obj/item/weapon/storage/pill_bottle/dermaline(src)
	new /obj/item/weapon/storage/pill_bottle/dexalin_plus(src)
	new /obj/item/weapon/storage/pill_bottle/dylovene(src)
	new /obj/item/weapon/storage/pill_bottle/tramadol(src)
	new /obj/item/weapon/storage/pill_bottle/spaceacillin(src)
	new /obj/item/weapon/reagent_containers/hypospray/autoinjector/biginjector/clotting(src)
	new /obj/item/stack/medical/splint(src)
	return

/obj/item/weapon/storage/firstaid/surgery
	name = "surgery kit"
	desc = "Contains tools for surgery."
	max_storage_space = ITEMSIZE_COST_NORMAL * 6 // Formally 21.  Odd numbers should be avoided for a system based on exponents of 2.
	max_w_class = ITEMSIZE_NORMAL

/obj/item/weapon/storage/firstaid/surgery/New()
	..()
	if (empty) return
	new /obj/item/weapon/surgical/bonesetter(src)
	new /obj/item/weapon/surgical/cautery(src)
	new /obj/item/weapon/surgical/circular_saw(src)
	new /obj/item/weapon/surgical/hemostat(src)
	new /obj/item/weapon/surgical/retractor(src)
	new /obj/item/weapon/surgical/scalpel(src)
	new /obj/item/weapon/surgical/surgicaldrill(src)
	new /obj/item/weapon/surgical/bonegel(src)
	new /obj/item/weapon/surgical/FixOVein(src)
	new /obj/item/stack/medical/advanced/bruise_pack(src)
	new /obj/item/device/healthanalyzer/advanced(src)
	return

/obj/item/weapon/storage/firstaid/clotting
	name = "clotting kit"
	desc = "Contains chemicals to stop bleeding."
	max_storage_space = ITEMSIZE_COST_SMALL * 7

/obj/item/weapon/storage/firstaid/clotting/New()
	..()
	if (empty)
		return
	for(var/i = 1 to 8)
		new /obj/item/weapon/reagent_containers/hypospray/autoinjector/biginjector/clotting(src)
	return

/*
 * Pill Bottles
 */
/obj/item/weapon/storage/pill_bottle
	name = "pill bottle"
	desc = "It's an airtight container for storing medication."
	icon_state = "pill_canister"
	icon = 'icons/obj/chemical.dmi'
	item_state_slots = list(slot_r_hand_str = "contsolid", slot_l_hand_str = "contsolid")
	w_class = ITEMSIZE_SMALL
	can_hold = list(/obj/item/weapon/reagent_containers/pill,/obj/item/weapon/dice,/obj/item/weapon/paper)
	allow_quick_gather = 1
	allow_quick_empty = 1
	use_to_pickup = 1
	use_sound = null
	max_storage_space = ITEMSIZE_COST_TINY * 14
	max_w_class = ITEMSIZE_TINY

/obj/item/weapon/storage/pill_bottle/antitox
	name = "bottle of Dylovene pills"
	desc = "Contains pills used to counter toxins."

/obj/item/weapon/storage/pill_bottle/antitox/New() //25u each
	..()
	new /obj/item/weapon/reagent_containers/pill/antitox(src)
	new /obj/item/weapon/reagent_containers/pill/antitox(src)
	new /obj/item/weapon/reagent_containers/pill/antitox(src)
	new /obj/item/weapon/reagent_containers/pill/antitox(src)
	new /obj/item/weapon/reagent_containers/pill/antitox(src)
	new /obj/item/weapon/reagent_containers/pill/antitox(src)
	new /obj/item/weapon/reagent_containers/pill/antitox(src)

/obj/item/weapon/storage/pill_bottle/bicaridine
	name = "bottle of Bicaridine pills"
	desc = "Contains pills used to stabilize the severely injured."

/obj/item/weapon/storage/pill_bottle/bicaridine/New()
	..()
	new /obj/item/weapon/reagent_containers/pill/bicaridine(src)
	new /obj/item/weapon/reagent_containers/pill/bicaridine(src)
	new /obj/item/weapon/reagent_containers/pill/bicaridine(src)
	new /obj/item/weapon/reagent_containers/pill/bicaridine(src)
	new /obj/item/weapon/reagent_containers/pill/bicaridine(src)
	new /obj/item/weapon/reagent_containers/pill/bicaridine(src)
	new /obj/item/weapon/reagent_containers/pill/bicaridine(src)

/obj/item/weapon/storage/pill_bottle/dexalin_plus
	name = "bottle of Dexalin Plus pills"
	desc = "Contains pills used to treat extreme cases of oxygen deprivation."

/obj/item/weapon/storage/pill_bottle/dexalin_plus/New()
	..()
	new /obj/item/weapon/reagent_containers/pill/dexalin_plus(src)
	new /obj/item/weapon/reagent_containers/pill/dexalin_plus(src)
	new /obj/item/weapon/reagent_containers/pill/dexalin_plus(src)
	new /obj/item/weapon/reagent_containers/pill/dexalin_plus(src)
	new /obj/item/weapon/reagent_containers/pill/dexalin_plus(src)
	new /obj/item/weapon/reagent_containers/pill/dexalin_plus(src)
	new /obj/item/weapon/reagent_containers/pill/dexalin_plus(src)

/obj/item/weapon/storage/pill_bottle/dermaline
	name = "bottle of Dermaline pills"
	desc = "Contains pills used to treat burn wounds."

/obj/item/weapon/storage/pill_bottle/dermaline/New()
	..()
	new /obj/item/weapon/reagent_containers/pill/dermaline(src)
	new /obj/item/weapon/reagent_containers/pill/dermaline(src)
	new /obj/item/weapon/reagent_containers/pill/dermaline(src)
	new /obj/item/weapon/reagent_containers/pill/dermaline(src)
	new /obj/item/weapon/reagent_containers/pill/dermaline(src)
	new /obj/item/weapon/reagent_containers/pill/dermaline(src)
	new /obj/item/weapon/reagent_containers/pill/dermaline(src)

/obj/item/weapon/storage/pill_bottle/dylovene
	name = "bottle of Dylovene pills"
	desc = "Contains pills used to treat toxic substances in the blood."

/obj/item/weapon/storage/pill_bottle/dylovene/New() //15u each
	..()
	new /obj/item/weapon/reagent_containers/pill/dylovene(src)
	new /obj/item/weapon/reagent_containers/pill/dylovene(src)
	new /obj/item/weapon/reagent_containers/pill/dylovene(src)
	new /obj/item/weapon/reagent_containers/pill/dylovene(src)
	new /obj/item/weapon/reagent_containers/pill/dylovene(src)
	new /obj/item/weapon/reagent_containers/pill/dylovene(src)
	new /obj/item/weapon/reagent_containers/pill/dylovene(src)

/obj/item/weapon/storage/pill_bottle/inaprovaline
	name = "bottle of Inaprovaline pills"
	desc = "Contains pills used to stabilize patients."

/obj/item/weapon/storage/pill_bottle/inaprovaline/New()
	..()
	new /obj/item/weapon/reagent_containers/pill/inaprovaline(src)
	new /obj/item/weapon/reagent_containers/pill/inaprovaline(src)
	new /obj/item/weapon/reagent_containers/pill/inaprovaline(src)
	new /obj/item/weapon/reagent_containers/pill/inaprovaline(src)
	new /obj/item/weapon/reagent_containers/pill/inaprovaline(src)
	new /obj/item/weapon/reagent_containers/pill/inaprovaline(src)
	new /obj/item/weapon/reagent_containers/pill/inaprovaline(src)

/obj/item/weapon/storage/pill_bottle/kelotane
	name = "bottle of kelotane pills"
	desc = "Contains pills used to treat burns."

/obj/item/weapon/storage/pill_bottle/kelotane/New()
	..()
	new /obj/item/weapon/reagent_containers/pill/kelotane(src)
	new /obj/item/weapon/reagent_containers/pill/kelotane(src)
	new /obj/item/weapon/reagent_containers/pill/kelotane(src)
	new /obj/item/weapon/reagent_containers/pill/kelotane(src)
	new /obj/item/weapon/reagent_containers/pill/kelotane(src)
	new /obj/item/weapon/reagent_containers/pill/kelotane(src)
	new /obj/item/weapon/reagent_containers/pill/kelotane(src)

/obj/item/weapon/storage/pill_bottle/spaceacillin
	name = "bottle of Spaceacillin pills"
	desc = "A theta-lactam antibiotic. Effective against many diseases likely to be encountered in space."

/obj/item/weapon/storage/pill_bottle/spaceacillin/New()
	..()
	new /obj/item/weapon/reagent_containers/pill/spaceacillin(src)
	new /obj/item/weapon/reagent_containers/pill/spaceacillin(src)
	new /obj/item/weapon/reagent_containers/pill/spaceacillin(src)
	new /obj/item/weapon/reagent_containers/pill/spaceacillin(src)
	new /obj/item/weapon/reagent_containers/pill/spaceacillin(src)
	new /obj/item/weapon/reagent_containers/pill/spaceacillin(src)
	new /obj/item/weapon/reagent_containers/pill/spaceacillin(src)

/obj/item/weapon/storage/pill_bottle/tramadol
	name = "bottle of Tramadol pills"
	desc = "Contains pills used to relieve pain."

/obj/item/weapon/storage/pill_bottle/tramadol/New()
	..()
	new /obj/item/weapon/reagent_containers/pill/tramadol(src)
	new /obj/item/weapon/reagent_containers/pill/tramadol(src)
	new /obj/item/weapon/reagent_containers/pill/tramadol(src)
	new /obj/item/weapon/reagent_containers/pill/tramadol(src)
	new /obj/item/weapon/reagent_containers/pill/tramadol(src)
	new /obj/item/weapon/reagent_containers/pill/tramadol(src)
	new /obj/item/weapon/reagent_containers/pill/tramadol(src)

/obj/item/weapon/storage/pill_bottle/citalopram
	name = "bottle of Citalopram pills"
	desc = "Contains pills used to stabilize a patient's mood."

/obj/item/weapon/storage/pill_bottle/citalopram/New()
	..()
	new /obj/item/weapon/reagent_containers/pill/citalopram(src)
	new /obj/item/weapon/reagent_containers/pill/citalopram(src)
	new /obj/item/weapon/reagent_containers/pill/citalopram(src)
	new /obj/item/weapon/reagent_containers/pill/citalopram(src)
	new /obj/item/weapon/reagent_containers/pill/citalopram(src)
	new /obj/item/weapon/reagent_containers/pill/citalopram(src)
	new /obj/item/weapon/reagent_containers/pill/citalopram(src)

/obj/item/weapon/storage/pill_bottle/carbon
	name = "bottle of Carbon pills"
	desc = "Contains pills used to neutralise chemicals in the stomach."

/obj/item/weapon/storage/pill_bottle/carbon/New()
	..()
	new /obj/item/weapon/reagent_containers/pill/carbon(src)
	new /obj/item/weapon/reagent_containers/pill/carbon(src)
	new /obj/item/weapon/reagent_containers/pill/carbon(src)
	new /obj/item/weapon/reagent_containers/pill/carbon(src)
	new /obj/item/weapon/reagent_containers/pill/carbon(src)
	new /obj/item/weapon/reagent_containers/pill/carbon(src)
	new /obj/item/weapon/reagent_containers/pill/carbon(src)

/obj/item/weapon/storage/pill_bottle/iron
	name = "bottle of Iron pills"
	desc = "Contains pills used to aid in blood regeneration."

/obj/item/weapon/storage/pill_bottle/iron/New()
	..()
	new /obj/item/weapon/reagent_containers/pill/iron(src)
	new /obj/item/weapon/reagent_containers/pill/iron(src)
	new /obj/item/weapon/reagent_containers/pill/iron(src)
	new /obj/item/weapon/reagent_containers/pill/iron(src)
	new /obj/item/weapon/reagent_containers/pill/iron(src)
	new /obj/item/weapon/reagent_containers/pill/iron(src)
	new /obj/item/weapon/reagent_containers/pill/iron(src)