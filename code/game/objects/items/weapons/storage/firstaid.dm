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
	icon = 'icons/obj/storage.dmi'
	icon_state = "firstaid"
	throw_speed = 2
	throw_range = 8
	max_storage_space = ITEMSIZE_COST_SMALL * 7 // 14
	var/list/icon_variety
	drop_sound = 'sound/items/drop/cardboardbox.ogg'
	pickup_sound = 'sound/items/pickup/cardboardbox.ogg'

/obj/item/weapon/storage/firstaid/Initialize()
	. = ..()
	if(icon_variety)
		icon_state = pick(icon_variety)
		icon_variety = null

/obj/item/weapon/storage/firstaid/fire
	name = "fire first aid kit"
	desc = "It's an emergency medical kit for when the toxins lab <i>spontaneously</i> burns down."
	icon_state = "ointment"
	item_state_slots = list(slot_r_hand_str = "firstaid-ointment", slot_l_hand_str = "firstaid-ointment")
	//icon_variety = list("ointment","firefirstaid") //VOREStation Removal
	starts_with = list(
		/obj/item/device/healthanalyzer,
		/obj/item/weapon/reagent_containers/hypospray/autoinjector,
		/obj/item/stack/medical/ointment,
		/obj/item/stack/medical/ointment,
		/obj/item/weapon/reagent_containers/pill/kelotane,
		/obj/item/weapon/reagent_containers/pill/kelotane,
		/obj/item/weapon/reagent_containers/pill/kelotane
	)

/obj/item/weapon/storage/firstaid/regular
	icon_state = "firstaid"
	starts_with = list(
		/obj/item/stack/medical/bruise_pack,
		/obj/item/stack/medical/bruise_pack,
		/obj/item/stack/medical/bruise_pack,
		/obj/item/stack/medical/ointment,
		/obj/item/stack/medical/ointment,
		/obj/item/device/healthanalyzer,
		/obj/item/weapon/reagent_containers/hypospray/autoinjector
	)

/obj/item/weapon/storage/firstaid/toxin
	name = "poison first aid kit" //IRL the term used would be poison first aid kit.
	desc = "Used to treat when one has a high amount of toxins in their body."
	icon_state = "antitoxin"
	item_state_slots = list(slot_r_hand_str = "firstaid-toxin", slot_l_hand_str = "firstaid-toxin")
	//icon_variety = list("antitoxin","antitoxfirstaid","antitoxfirstaid2","antitoxfirstaid3") //VOREStation Removal
	starts_with = list(
		/obj/item/weapon/reagent_containers/syringe/antitoxin,
		/obj/item/weapon/reagent_containers/syringe/antitoxin,
		/obj/item/weapon/reagent_containers/syringe/antitoxin,
		/obj/item/weapon/reagent_containers/pill/antitox,
		/obj/item/weapon/reagent_containers/pill/antitox,
		/obj/item/weapon/reagent_containers/pill/antitox,
		/obj/item/device/healthanalyzer
	)

/obj/item/weapon/storage/firstaid/o2
	name = "oxygen deprivation first aid kit"
	desc = "A box full of oxygen goodies."
	icon_state = "o2"
	item_state_slots = list(slot_r_hand_str = "firstaid-o2", slot_l_hand_str = "firstaid-o2") 
	starts_with = list(
		/obj/item/weapon/reagent_containers/pill/dexalin,
		/obj/item/weapon/reagent_containers/pill/dexalin,
		/obj/item/weapon/reagent_containers/pill/dexalin,
		/obj/item/weapon/reagent_containers/pill/dexalin,
		/obj/item/weapon/reagent_containers/hypospray/autoinjector,
		/obj/item/weapon/reagent_containers/syringe/inaprovaline,
		/obj/item/device/healthanalyzer
	)

/obj/item/weapon/storage/firstaid/adv
	name = "advanced first aid kit"
	desc = "Contains advanced medical treatments, for <b>serious</b> boo-boos."
	icon_state = "advfirstaid"
	item_state_slots = list(slot_r_hand_str = "firstaid-advanced", slot_l_hand_str = "firstaid-advanced")
	starts_with = list(
		/obj/item/weapon/reagent_containers/hypospray/autoinjector,
		/obj/item/stack/medical/advanced/bruise_pack,
		/obj/item/stack/medical/advanced/bruise_pack,
		/obj/item/stack/medical/advanced/bruise_pack,
		/obj/item/stack/medical/advanced/ointment,
		/obj/item/stack/medical/advanced/ointment,
		/obj/item/stack/medical/splint
	)

/obj/item/weapon/storage/firstaid/combat
	name = "combat medical kit"
	desc = "Contains advanced medical treatments."
	icon_state = "bezerk"
	item_state_slots = list(slot_r_hand_str = "firstaid-advanced", slot_l_hand_str = "firstaid-advanced")
	starts_with = list(
		/obj/item/weapon/storage/pill_bottle/bicaridine,
		/obj/item/weapon/storage/pill_bottle/dermaline,
		/obj/item/weapon/storage/pill_bottle/dexalin_plus,
		/obj/item/weapon/storage/pill_bottle/dylovene,
		/obj/item/weapon/storage/pill_bottle/tramadol,
		/obj/item/weapon/storage/pill_bottle/spaceacillin,
		/obj/item/weapon/reagent_containers/hypospray/autoinjector/biginjector/clotting,
		/obj/item/stack/medical/splint,
		/obj/item/device/healthanalyzer/advanced
	)

/obj/item/weapon/storage/firstaid/surgery
	name = "surgery kit"
	desc = "Contains tools for surgery. Has precise foam fitting for safe transport and automatically sterilizes the content between uses."
	icon = 'icons/obj/storage.dmi' // VOREStation edit
	icon_state = "surgerykit"
	item_state = "firstaid-surgery"
	max_w_class = ITEMSIZE_NORMAL

	can_hold = list(
		/obj/item/weapon/surgical/bonesetter,
		/obj/item/weapon/surgical/cautery,
		/obj/item/weapon/surgical/circular_saw,
		/obj/item/weapon/surgical/hemostat,
		/obj/item/weapon/surgical/retractor,
		/obj/item/weapon/surgical/scalpel,
		/obj/item/weapon/surgical/surgicaldrill,
		/obj/item/weapon/surgical/bonegel,
		/obj/item/weapon/surgical/FixOVein,
		/obj/item/stack/medical/advanced/bruise_pack,
		/obj/item/stack/nanopaste,
		/obj/item/device/healthanalyzer/advanced,
		/obj/item/weapon/autopsy_scanner
		)

	starts_with = list(
		/obj/item/weapon/surgical/bonesetter,
		/obj/item/weapon/surgical/cautery,
		/obj/item/weapon/surgical/circular_saw,
		/obj/item/weapon/surgical/hemostat,
		/obj/item/weapon/surgical/retractor,
		/obj/item/weapon/surgical/scalpel,
		/obj/item/weapon/surgical/surgicaldrill,
		/obj/item/weapon/surgical/bonegel,
		/obj/item/weapon/surgical/FixOVein,
		/obj/item/stack/medical/advanced/bruise_pack,
		/obj/item/device/healthanalyzer/advanced,
		/obj/item/weapon/autopsy_scanner
		)

/obj/item/weapon/storage/firstaid/clotting
	name = "clotting kit"
	desc = "Contains chemicals to stop bleeding."
	max_storage_space = ITEMSIZE_COST_SMALL * 7
	starts_with = list(/obj/item/weapon/reagent_containers/hypospray/autoinjector/biginjector/clotting = 8)

/obj/item/weapon/storage/firstaid/bonemed
	name = "bone repair kit"
	desc = "Contains chemicals to mend broken bones."
	max_storage_space = ITEMSIZE_COST_SMALL * 7
	starts_with = list(/obj/item/weapon/reagent_containers/hypospray/autoinjector/bonemed = 8)

/*
 * Pill Bottles
 */
/obj/item/weapon/storage/pill_bottle
	name = "pill bottle"
	desc = "It's an airtight container for storing medication."
	icon_state = "pill_canister"
	icon = 'icons/obj/chemical.dmi'
	drop_sound = 'sound/items/drop/pillbottle.ogg'
	pickup_sound = 'sound/items/pickup/pillbottle.ogg'
	item_state_slots = list(slot_r_hand_str = "contsolid", slot_l_hand_str = "contsolid")
	w_class = ITEMSIZE_SMALL
	can_hold = list(/obj/item/weapon/reagent_containers/pill,/obj/item/weapon/dice,/obj/item/weapon/paper)
	allow_quick_gather = 1
	allow_quick_empty = 1
	use_to_pickup = TRUE
	use_sound = 'sound/items/storage/pillbottle.ogg'
	max_storage_space = ITEMSIZE_COST_TINY * 14
	max_w_class = ITEMSIZE_TINY
	var/wrapper_color
	var/label

	var/label_text = ""
	var/base_name = " "
	var/base_desc = " "

/obj/item/weapon/storage/pill_bottle/Initialize()
	. = ..()
	base_name = name
	base_desc = desc
	update_icon()

/obj/item/weapon/storage/pill_bottle/update_icon()
	cut_overlays()
	if(wrapper_color)
		var/image/I = image(icon, "pillbottle_wrap")
		I.color = wrapper_color
		add_overlay(I)

<<<<<<< HEAD
/obj/item/weapon/storage/pill_bottle/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(istype(W, /obj/item/weapon/pen) || istype(W, /obj/item/device/flashlight/pen))
		var/tmp_label = sanitizeSafe(tgui_input_text(user, "Enter a label for [name]", "Label", label_text, MAX_NAME_LEN), MAX_NAME_LEN)
=======
/obj/item/storage/pill_bottle/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/pen) || istype(W, /obj/item/flashlight/pen))
		var/tmp_label = sanitizeSafe(input(user, "Enter a label for [name]", "Label", label_text), MAX_NAME_LEN)
>>>>>>> 4219662fdaf... Merge pull request #8836 from MistakeNot4892/storagefix
		if(length(tmp_label) > 50)
			to_chat(user, "<span class='notice'>The label can be at most 50 characters long.</span>")
		else if(length(tmp_label) > 10)
			to_chat(user, "<span class='notice'>You set the label.</span>")
			label_text = tmp_label
			update_name_label()
		else
			to_chat(user, "<span class='notice'>You set the label to \"[tmp_label]\".</span>")
			label_text = tmp_label
			update_name_label()
		return TRUE
	return ..()

/obj/item/weapon/storage/pill_bottle/proc/update_name_label()
	if(!label_text)
		name = base_name
		desc = base_desc
		return
	else if(length(label_text) > 10)
		var/short_label_text = copytext(label_text, 1, 11)
		name = "[base_name] ([short_label_text]...)"
	else
		name = "[base_name] ([label_text])"
	desc = "[base_desc] It is labeled \"[label_text]\"."

/obj/item/weapon/storage/pill_bottle/antitox
	name = "pill bottle (Dylovene)"
	desc = "Contains pills used to counter toxins."
	starts_with = list(/obj/item/weapon/reagent_containers/pill/antitox = 7)
	wrapper_color = COLOR_GREEN

/obj/item/weapon/storage/pill_bottle/bicaridine
	name = "pill bottle (Bicaridine)"
	desc = "Contains pills used to stabilize the severely injured."
	starts_with = list(/obj/item/weapon/reagent_containers/pill/bicaridine = 7)
	wrapper_color = COLOR_MAROON

/obj/item/weapon/storage/pill_bottle/dexalin_plus
	name = "pill bottle (Dexalin Plus)"
	desc = "Contains pills used to treat extreme cases of oxygen deprivation."
	starts_with = list(/obj/item/weapon/reagent_containers/pill/dexalin_plus = 7)
	wrapper_color = "#3366cc"

/obj/item/weapon/storage/pill_bottle/dermaline
	name = "pill bottle (Dermaline)"
	desc = "Contains pills used to treat burn wounds."
	starts_with = list(/obj/item/weapon/reagent_containers/pill/dermaline = 7)
	wrapper_color = "#e8d131"

/obj/item/weapon/storage/pill_bottle/dylovene
	name = "pill bottle (Dylovene)"
	desc = "Contains pills used to treat toxic substances in the blood."
	starts_with = list(/obj/item/weapon/reagent_containers/pill/dylovene = 7)
	wrapper_color = COLOR_GREEN

/obj/item/weapon/storage/pill_bottle/inaprovaline
	name = "pill bottle (Inaprovaline)"
	desc = "Contains pills used to stabilize patients."
	starts_with = list(/obj/item/weapon/reagent_containers/pill/inaprovaline = 7)
	wrapper_color = COLOR_PALE_BLUE_GRAY

/obj/item/weapon/storage/pill_bottle/kelotane
	name = "pill bottle (Kelotane)"
	desc = "Contains pills used to treat burns."
	starts_with = list(/obj/item/weapon/reagent_containers/pill/kelotane = 7)
	wrapper_color = "#ec8b2f"

/obj/item/weapon/storage/pill_bottle/spaceacillin
	name = "pill bottle (Spaceacillin)"
	desc = "A theta-lactam antibiotic. Effective against many diseases likely to be encountered in space."
	starts_with = list(/obj/item/weapon/reagent_containers/pill/spaceacillin = 7)
	wrapper_color = COLOR_PALE_GREEN_GRAY

/obj/item/weapon/storage/pill_bottle/tramadol
	name = "pill bottle (Tramadol)"
	desc = "Contains pills used to relieve pain."
	starts_with = list(/obj/item/weapon/reagent_containers/pill/tramadol = 7)
	wrapper_color = COLOR_PURPLE_GRAY

/obj/item/weapon/storage/pill_bottle/citalopram
	name = "pill bottle (Citalopram)"
	desc = "Contains pills used to stabilize a patient's mood."
	starts_with = list(/obj/item/weapon/reagent_containers/pill/citalopram = 7)
	wrapper_color = COLOR_GRAY

/obj/item/weapon/storage/pill_bottle/carbon
	name = "pill bottle (Carbon)"
	desc = "Contains pills used to neutralise chemicals in the stomach."
	starts_with = list(/obj/item/weapon/reagent_containers/pill/carbon = 7)

/obj/item/weapon/storage/pill_bottle/iron
	name = "pill bottle (Iron)"
	desc = "Contains pills used to aid in blood regeneration."
	starts_with = list(/obj/item/weapon/reagent_containers/pill/iron = 7)
