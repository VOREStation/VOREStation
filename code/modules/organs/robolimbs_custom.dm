/datum/robolimb
	var/includes_tail			//Cyberlimbs dmi includes a tail sprite to wear.
	var/includes_wing			//Cyberlimbs dmi includes a wing sprite to wear.
	var/includes_ears			//Cyberlimbs dmi includes ear sprites to wear.
	var/list/whitelisted_to		//List of ckeys that are allowed to pick this in charsetup.

//////////////// For-specific-character fluff ones ///////////////// May be viable to place these into a custom_item subfolder, in order to allow CI Repo integration.

// verkister : Rahwoof Boop
/datum/robolimb/eggnerdltd
	company = "Eggnerd Prototyping Ltd."
	desc = "This limb has a slight salvaged handicraft vibe to it. The CE-marking on it is definitely not the standardized one, it looks more like a hand-written sharpie monogram."
	icon = 'icons/mob/human_races/cyberlimbs/_fluff_vr/rahboop.dmi'
	blood_color = "#5e280d"
	includes_tail = 1
	unavailable_to_build = 1

/obj/item/disk/limb/eggnerdltd
	company = "Eggnerd Prototyping Ltd."
//	icon = 'icons/obj/items_vr.dmi'
//	icon_state = "verkdisk"

//////////////// General VS-only ones /////////////////
/datum/robolimb/talon //They're buildable by default due to being extremely basic.
	company = "Talon LLC"
	desc = "This metallic limb is sleek and featuresless apart from some exposed motors"
	icon = 'icons/mob/human_races/cyberlimbs/talon/talon_main.dmi' //Sprited by: Viveret

/obj/item/disk/limb/talon
	company = "Talon LLC"

/datum/robolimb/zenghu_taj //This wasn't indented. At all. It's a miracle this didn't break literally everything.
	company = "Zeng-Hu - Tajaran"
	desc = "This limb has a rubbery fleshtone covering with visible seams."
	icon = 'icons/mob/human_races/cyberlimbs/zenghu/zenghu_taj.dmi'
	unavailable_to_build = 1
	parts = list(BP_HEAD)

/datum/robolimb/eggnerdltdred
	company = "Eggnerd Prototyping Ltd. (Red)"
	desc = "A slightly more refined limb variant from Eggnerd Prototyping. Its got red plating instead of orange."
	icon = 'icons/mob/human_races/cyberlimbs/rahboopred/rahboopred.dmi'
	blood_color = "#5e280d"
	includes_tail = 1
	unavailable_to_build = 1

/obj/item/disk/limb/eggnerdltdred
	company = "Eggnerd Prototyping Ltd. (Red)"
	icon = 'icons/obj/items_vr.dmi'	//VOREStation add. Use the right sprites
	icon_state = "verkdisk"			//VOREStation add. Use the right sprites


//Darkside Incorperated synthetic augmentation list! Many current most used fuzzy and notsofuzzy races made into synths here.
/datum/robolimb/dsi_tajaran
	company = "DSI - Tajaran"
	desc = "This limb feels soft and fluffy, realistic design and squish. By Darkside Incorperated."
	icon = 'icons/mob/human_races/cyberlimbs/DSITajaran/dsi_tajaran.dmi'
	blood_color = "#ffe2ff"
	lifelike = 1
	unavailable_to_build = 1
	includes_tail = 1
	skin_tone = 1
	suggested_species = SPECIES_TAJARAN

/*/datum/robolimb/dsi_tajaran/New()
	species_cannot_use = GLOB.all_species.Copy()
	species_cannot_use -= SPECIES_TAJARAN
VS Edit - anyone can select these. */

/obj/item/disk/limb/dsi_tajaran
	company = "DSI - Tajaran"

/datum/robolimb/dsi_lizard
	company = "DSI - Lizard"
	desc = "This limb feels smooth and scalie, realistic design and squish. By Darkside Incorperated."
	icon = 'icons/mob/human_races/cyberlimbs/DSILizard/dsi_lizard.dmi'
	blood_color = "#ffe2ff"
	lifelike = 1
	unavailable_to_build = 1
	includes_tail = 1
	skin_tone = 1
	suggested_species = SPECIES_UNATHI

/* /datum/robolimb/dsi_lizard/New() //
	species_cannot_use = GLOB.all_species.Copy()
	species_cannot_use -= SPECIES_UNATHI
VS Edit - anyone can select these. */

/obj/item/disk/limb/dsi_lizard
	company = "DSI - Lizard"

/datum/robolimb/dsi_sergal
	company = "DSI - Sergal"
	desc = "This limb feels soft and fluffy, realistic design and toned muscle. By Darkside Incorperated."
	icon = 'icons/mob/human_races/cyberlimbs/DSISergal/dsi_sergal.dmi'
	blood_color = "#ffe2ff"
	lifelike = 1
	unavailable_to_build = 1
	includes_tail = 1
	skin_tone = 1
	suggested_species = SPECIES_SERGAL

/obj/item/disk/limb/dsi_sergal
	company = "DSI - Sergal"

/datum/robolimb/dsi_nevrean
	company = "DSI - Nevrean"
	desc = "This limb feels soft and feathery, lightweight, realistic design and squish. By Darkside Incorperated."
	icon = 'icons/mob/human_races/cyberlimbs/DSINevrean/dsi_nevrean.dmi'
	blood_color = "#ffe2ff"
	lifelike = 1
	unavailable_to_build = 1
	includes_tail = 1
	skin_tone = 1
	suggested_species = SPECIES_NEVREAN

/obj/item/disk/limb/dsi_nevrean
	company = "DSI - Nevrean"

/datum/robolimb/dsi_vulpkanin
	company = "DSI - Vulpkanin"
	desc = "This limb feels soft and fluffy, realistic design and squish. Seems a little mischievous. By Darkside Incorperated."
	icon = 'icons/mob/human_races/cyberlimbs/DSIVulpkanin/dsi_vulpkanin.dmi'
	blood_color = "#ffe2ff"
	lifelike = 1
	unavailable_to_build = 1
	includes_tail = 1
	skin_tone = 1
	suggested_species = SPECIES_VULPKANIN

/obj/item/disk/limb/dsi_vulpkanin
	company = "DSI - Vulpkanin"

/datum/robolimb/dsi_akula
	company = "DSI - Akula"
	desc = "This limb feels soft and fleshy, realistic design and squish. Seems a little mischievous. By Darkside Incorperated."
	icon = 'icons/mob/human_races/cyberlimbs/DSIAkula/dsi_akula.dmi'
	blood_color = "#ffe2ff"
	lifelike = 1
	unavailable_to_build = 1
	includes_tail = 1
	skin_tone = 1
	suggested_species = SPECIES_AKULA

/obj/item/disk/limb/dsi_akula
	company = "DSI - Akula"

/datum/robolimb/dsi_spider
	company = "DSI - Vasilissan"
	desc = "This limb feels hard and chitinous, realistic design. Seems a little mischievous. By Darkside Incorperated."
	icon = 'icons/mob/human_races/cyberlimbs/DSISpider/dsi_spider.dmi'
	blood_color = "#ffe2ff"
	lifelike = 1
	unavailable_to_build = 1
	includes_tail = 1
	skin_tone = 1
	suggested_species = SPECIES_VASILISSAN

/obj/item/disk/limb/dsi_spider
	company = "DSI - Vasilissan"

/datum/robolimb/dsi_teshari
	company = "DSI - Teshari"
	desc = "This limb has a thin synthflesh casing with a few connection ports."
	icon = 'icons/mob/human_races/cyberlimbs/DSITeshari/dsi_teshari.dmi'
	lifelike = 1
	skin_tone = 1
	suggested_species = SPECIES_TESHARI

/datum/robolimb/dsi_teshari/New()
	species_cannot_use = GLOB.all_species.Copy()
	species_cannot_use -= SPECIES_TESHARI //VOREStation add - let 'em be selected.
	species_cannot_use -= SPECIES_CUSTOM //VOREStation add - let 'em be selected.
	species_cannot_use -= SPECIES_PROTEAN //VOREStation add - let 'em be selected.
	..()

/obj/item/disk/limb/dsi_teshari
	company = "DSI - Teshari"

/datum/robolimb/dsi_zorren
	company = "DSI - Zorren"
	desc = "This limb feels soft and fluffy, realistic design and squish. Seems a little mischievous. By Darkside Incorperated."
	icon = 'icons/mob/human_races/cyberlimbs/DSIZorren/dsi_zorren.dmi'
	blood_color = "#ffe2ff"
	lifelike = 1
	unavailable_to_build = 1
	includes_tail = 1
	skin_tone = 1
	suggested_species = SPECIES_ZORREN_HIGH

/obj/item/disk/limb/dsi_zorren
	company = "DSI - Zorren"

/datum/robolimb/dsi_fennec
	company = "DSI - Fennec"
	desc = "This limb feels soft and fluffy, realistic design and squish. Seems a little mischievous. By Darkside Incorperated."
	icon = 'icons/mob/human_races/cyberlimbs/DSIFennec/dsi_fennec.dmi'
	blood_color = "#ffe2ff"
	lifelike = 1
	unavailable_to_build = 1
	includes_tail = 1
	skin_tone = 1
	suggested_species = SPECIES_FENNEC

/obj/item/disk/limb/dsi_fennec
	company = "DSI - Fennec"
