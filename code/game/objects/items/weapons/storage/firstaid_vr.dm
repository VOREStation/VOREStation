/obj/item/storage/firstaid
	icon = 'icons/obj/storage_vr.dmi'

/obj/item/storage/firstaid/fire
	starts_with = list(
		/obj/item/storage/pill_bottle/kelotane,
		/obj/item/stack/medical/ointment,
		/obj/item/stack/medical/ointment,
		/obj/item/reagent_containers/hypospray/autoinjector/burn,
		/obj/item/reagent_containers/hypospray/autoinjector/burn,
		/obj/item/reagent_containers/hypospray/autoinjector/burn,
		/obj/item/reagent_containers/hypospray/autoinjector/burn
	)

/obj/item/storage/firstaid/regular
	starts_with = list(
		/obj/item/stack/medical/bruise_pack,
		/obj/item/stack/medical/bruise_pack,
		/obj/item/stack/medical/bruise_pack,
		/obj/item/stack/medical/bruise_pack,
		/obj/item/stack/medical/ointment,
		/obj/item/stack/medical/ointment,
		/obj/item/storage/pill_bottle/paracetamol
	)

/obj/item/storage/firstaid/toxin
	starts_with = list(
		/obj/item/reagent_containers/hypospray/autoinjector/detox,
		/obj/item/reagent_containers/hypospray/autoinjector/detox,
		/obj/item/reagent_containers/hypospray/autoinjector/detox,
		/obj/item/reagent_containers/hypospray/autoinjector/detox,
		/obj/item/reagent_containers/hypospray/autoinjector/rad,
		/obj/item/reagent_containers/hypospray/autoinjector/rad,
		/obj/item/storage/pill_bottle/antitox
	)

/obj/item/storage/firstaid/o2
	starts_with = list(
		/obj/item/reagent_containers/hypospray/autoinjector/oxy,
		/obj/item/reagent_containers/hypospray/autoinjector/oxy,
		/obj/item/reagent_containers/hypospray/autoinjector/oxy,
		/obj/item/reagent_containers/hypospray/autoinjector/oxy,
		/obj/item/storage/pill_bottle/inaprovaline,
		/obj/item/storage/pill_bottle/blood_regen,
		/obj/item/storage/pill_bottle/dexalin
	)

/obj/item/storage/firstaid/adv
	starts_with = list(
		/obj/item/storage/pill_bottle/assorted,
		/obj/item/stack/medical/advanced/bruise_pack,
		/obj/item/stack/medical/advanced/bruise_pack,
		/obj/item/stack/medical/advanced/bruise_pack,
		/obj/item/stack/medical/advanced/ointment,
		/obj/item/stack/medical/advanced/ointment,
		/obj/item/stack/medical/splint
	)

/obj/item/storage/firstaid/combat
	starts_with = list(
		/obj/item/storage/pill_bottle/vermicetol,
		/obj/item/storage/pill_bottle/dermaline,
		/obj/item/storage/pill_bottle/dexalin_plus,
		/obj/item/storage/pill_bottle/carthatoline,
		/obj/item/storage/pill_bottle/tramadol,
		/obj/item/storage/pill_bottle/corophizine,
		/obj/item/storage/pill_bottle/combat,
		/obj/item/stack/medical/splint,
		/obj/item/healthanalyzer/phasic
	)

/obj/item/storage/firstaid/surgery
	can_hold = list(
		/obj/item/surgical/bone_clamp,
		/obj/item/surgical/bonesetter,
		/obj/item/surgical/cautery,
		/obj/item/surgical/circular_saw,
		/obj/item/surgical/hemostat,
		/obj/item/surgical/retractor,
		/obj/item/surgical/scalpel,
		/obj/item/surgical/surgicaldrill,
		/obj/item/surgical/bonegel,
		/obj/item/surgical/FixOVein,
		/obj/item/stack/medical/advanced/bruise_pack,
		/obj/item/stack/nanopaste,
		/obj/item/healthanalyzer,
		/obj/item/autopsy_scanner,
		/obj/item/surgical/bioregen
		)

	starts_with = list(
		/obj/item/surgical/bonesetter,
		/obj/item/surgical/cautery,
		/obj/item/surgical/circular_saw,
		/obj/item/surgical/hemostat,
		/obj/item/surgical/retractor,
		/obj/item/surgical/scalpel,
		/obj/item/surgical/surgicaldrill,
		/obj/item/surgical/bonegel,
		/obj/item/surgical/FixOVein,
		/obj/item/stack/medical/advanced/bruise_pack,
		/obj/item/healthanalyzer,
		/obj/item/autopsy_scanner,
		/obj/item/surgical/bioregen
		)


/obj/item/storage/firstaid/clotting
	icon_state = "clottingkit"

/obj/item/storage/firstaid/bonemed
	icon_state = "pinky"

/obj/item/storage/pill_bottle/antitox
	starts_with = list(/obj/item/reagent_containers/pill/antitox = 14)

/obj/item/storage/pill_bottle/bicaridine
	starts_with = list(/obj/item/reagent_containers/pill/bicaridine = 14)

/obj/item/storage/pill_bottle/dexalin_plus
	starts_with = list(/obj/item/reagent_containers/pill/dexalin_plus = 14)

/obj/item/storage/pill_bottle/dermaline
	starts_with = list(/obj/item/reagent_containers/pill/dermaline = 14)

/obj/item/storage/pill_bottle/dylovene
	starts_with = list(/obj/item/reagent_containers/pill/dylovene = 14)

/obj/item/storage/pill_bottle/inaprovaline
	starts_with = list(/obj/item/reagent_containers/pill/inaprovaline = 14)

/obj/item/storage/pill_bottle/kelotane
	starts_with = list(/obj/item/reagent_containers/pill/kelotane = 14)

/obj/item/storage/pill_bottle/spaceacillin
	starts_with = list(/obj/item/reagent_containers/pill/spaceacillin = 14)

/obj/item/storage/pill_bottle/tramadol
	starts_with = list(/obj/item/reagent_containers/pill/tramadol = 14)

/obj/item/storage/pill_bottle/citalopram
	starts_with = list(/obj/item/reagent_containers/pill/citalopram = 14)

/obj/item/storage/pill_bottle/carbon
	starts_with = list(/obj/item/reagent_containers/pill/carbon = 14)

/obj/item/storage/pill_bottle/iron
	starts_with = list(/obj/item/reagent_containers/pill/iron = 14)

/obj/item/storage/pill_bottle/blood_regen
	name = "pill bottle (blood regeneration)"
	desc = "Contains iron and copper pills for treating bloodloss by employed species."
	starts_with = list(/obj/item/reagent_containers/pill/iron = 9,
	/obj/item/reagent_containers/pill/copper = 5)

/obj/item/storage/pill_bottle/adminordrazine
	name = "pill bottle (Adminordrazine)"
	desc = "It's magic. We don't have to explain it."
	starts_with = list(/obj/item/reagent_containers/pill/adminordrazine = 21)

/obj/item/storage/pill_bottle/nutriment
	name = "pill bottle (Food)"
	desc = "Contains pills used to feed people."
	starts_with = list(/obj/item/reagent_containers/pill/nutriment = 7, /obj/item/reagent_containers/pill/protein = 7)

/obj/item/storage/pill_bottle/rezadone
	name = "pill bottle (Rezadone)"
	desc = "A powder with almost magical properties, this substance can effectively treat genetic damage in humanoids, though excessive consumption has side effects."
	starts_with = list(/obj/item/reagent_containers/pill/rezadone = 14)
	wrapper_color = COLOR_GREEN_GRAY

/obj/item/storage/pill_bottle/peridaxon
	name = "pill bottle (Peridaxon)"
	desc = "Used to encourage recovery of internal organs and nervous systems. Medicate cautiously."
	starts_with = list(/obj/item/reagent_containers/pill/peridaxon = 14)
	wrapper_color = COLOR_PURPLE

/obj/item/storage/pill_bottle/carthatoline
	name = "pill bottle (Carthatoline)"
	desc = "Carthatoline is strong evacuant used to treat severe poisoning."
	starts_with = list(/obj/item/reagent_containers/pill/carthatoline = 14)
	wrapper_color = COLOR_GREEN_GRAY

/obj/item/storage/pill_bottle/alkysine
	name = "pill bottle (Alkysine)"
	desc = "Alkysine is a drug used to lessen the damage to neurological tissue after a catastrophic injury. Can heal brain tissue."
	starts_with = list(/obj/item/reagent_containers/pill/alkysine = 14)
	wrapper_color = COLOR_YELLOW

/obj/item/storage/pill_bottle/imidazoline
	name = "pill bottle (Imidazoline)"
	desc = "Heals eye damage."
	starts_with = list(/obj/item/reagent_containers/pill/imidazoline = 14)
	wrapper_color = COLOR_PURPLE_GRAY

/obj/item/storage/pill_bottle/osteodaxon
	name = "pill bottle (Osteodaxon)"
	desc = "An experimental drug used to heal bone fractures."
	starts_with = list(/obj/item/reagent_containers/pill/osteodaxon = 14)
	wrapper_color = COLOR_WHITE

/obj/item/storage/pill_bottle/myelamine
	name = "pill bottle (Myelamine)"
	desc = "Used to rapidly clot internal hemorrhages by increasing the effectiveness of platelets."
	starts_with = list(/obj/item/reagent_containers/pill/myelamine = 14)
	wrapper_color = COLOR_PALE_PURPLE_GRAY

/obj/item/storage/pill_bottle/hyronalin
	name = "pill bottle (Hyronalin)"
	desc = "Hyronalin is a medicinal drug used to counter the effect of radiation poisoning."
	starts_with = list(/obj/item/reagent_containers/pill/hyronalin = 14)
	wrapper_color = COLOR_TEAL

/obj/item/storage/pill_bottle/arithrazine
	name = "pill bottle (Arithrazine)"
	desc = "Arithrazine is an unstable medication used for the most extreme cases of radiation poisoning."
	starts_with = list(/obj/item/reagent_containers/pill/arithrazine = 14)
	wrapper_color = COLOR_TEAL

/obj/item/storage/pill_bottle/corophizine
	name = "pill bottle (Corophizine)"
	desc = "A wide-spectrum antibiotic drug. Powerful and uncomfortable in equal doses."
	starts_with = list(/obj/item/reagent_containers/pill/corophizine = 14)
	wrapper_color = COLOR_PALE_GREEN_GRAY

/obj/item/storage/pill_bottle/vermicetol
	name = "pill bottle (Vermicetol)"
	desc = "Contains pills used to stabilize the extremely injured."
	starts_with = list(/obj/item/reagent_containers/pill/vermicetol = 14)
	wrapper_color = COLOR_MAROON

/obj/item/storage/pill_bottle/healing_nanites
	name = "pill bottle (Healing nanites)"
	desc = "Miniature medical robots that swiftly restore bodily damage."
	starts_with = list(/obj/item/reagent_containers/pill/healing_nanites = 14)

/obj/item/storage/pill_bottle/sleevingcure
	name = "pill bottle (resleeving sickness cure)"
	desc = "A rare cure provided by Vey-Medical that helps counteract negative side effects of using imperfect resleeving machinery."
	starts_with = list(/obj/item/reagent_containers/pill/sleevingcure = 7)

/obj/item/storage/pill_bottle/sleevingcure/full
	starts_with = list(/obj/item/reagent_containers/pill/sleevingcure = 14)

/obj/item/storage/mrebag/pill
	name = "vacuum-sealed pill"
	desc = "A small vacuum-sealed package containing a singular pill. For emergencies only."
	icon_state = "pouch_small"
	max_w_class = ITEMSIZE_TINY
	can_hold = list(/obj/item/reagent_containers/pill)

/obj/item/storage/mrebag/pill/sleevingcure
	name = "vacuum-sealed pill (resleeving sickness cure)"
	desc = "A small vacuum-sealed package containing a singular pill. For emergencies only."
	starts_with = list(/obj/item/reagent_containers/pill/sleevingcure)

/obj/item/storage/pill_bottle/paracetamol
	name = "pill bottle (Paracetamol)"
	desc = "Contains over the counter medicine to treat pain."
	starts_with = list(/obj/item/reagent_containers/pill/paracetamol = 14)
	wrapper_color = COLOR_GRAY

/obj/item/storage/pill_bottle/dexalin
	name = "pill bottle (Dexalin)"
	desc = "Contains pills used to treat oxygen deprivation."
	starts_with = list(/obj/item/reagent_containers/pill/dexalin = 14)
	wrapper_color = "#3366cc"

/obj/item/storage/pill_bottle/assorted
	name = "pill bottle (Assorted)"
	desc = "Commonly found on paramedics, these assorted pill bottles contain basic treatments for nonstandard injuries."
	starts_with = list(
			/obj/item/reagent_containers/pill/inaprovaline = 3,
			/obj/item/reagent_containers/pill/antitox = 3,
			/obj/item/reagent_containers/pill/iron = 1,
			/obj/item/reagent_containers/pill/copper = 1,
			/obj/item/reagent_containers/pill/tramadol = 2,
			/obj/item/reagent_containers/pill/hyronalin = 3,
			/obj/item/reagent_containers/pill/spaceacillin
		)
	wrapper_color = COLOR_BLACK

/obj/item/storage/pill_bottle/combat
	name = "pill bottle (Combat)"
	desc = "A pill bottle filled with some of the rarest medical treatmeants to exist."
	max_storage_space = ITEMSIZE_COST_TINY * 20
	starts_with = list(
			/obj/item/reagent_containers/pill/peridaxon = 5,
			/obj/item/reagent_containers/pill/rezadone = 5,
			/obj/item/reagent_containers/pill/myelamine = 3,
			/obj/item/reagent_containers/pill/osteodaxon = 3,
			/obj/item/reagent_containers/pill/arithrazine = 2,
			/obj/item/reagent_containers/pill/alkysine = 1,
			/obj/item/reagent_containers/pill/imidazoline = 1
		)
	wrapper_color = COLOR_BLACK
