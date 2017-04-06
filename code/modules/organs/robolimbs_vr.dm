/datum/robolimb
	var/includes_tail			//Cyberlimbs dmi includes a tail sprite to wear.
	var/list/whitelisted_to		//List of ckeys that are allowed to pick this in charsetup.

//////////////// For-specific-character fluff ones /////////////////
// arokha : Aronai Kadigan
/datum/robolimb/kitsuhana
	company = "Kitsuhana"
	desc = "This limb seems rather vulpine and fuzzy, with realistic-feeling flesh."
	icon = 'icons/mob/human_races/cyberlimbs/_fluff_vr/aronai.dmi'
	blood_color = "#5dd4fc"
	includes_tail = 1
	lifelike = 1
	unavailable_to_build = 1
	whitelisted_to = list("arokha")

/obj/item/weapon/disk/limb/kitsuhana
	company = "Kitsuhana"

// silencedmp5a5 : Serdykov Antoz
/datum/robolimb/white_kryten
	company = "White Kryten Cybernetics"
	desc = "This limb feels realistic to the touch, with soft fur. Were it not for the bright orange lights embedded in it, you might have trouble telling it from a non synthetic limb!"
	icon = 'icons/mob/human_races/cyberlimbs/_fluff_vr/serdykov.dmi'
	blood_color = "#ff6a00"
	unavailable_to_build = 1
	whitelisted_to = list("silencedmp5a5")

/obj/item/weapon/disk/limb/white_kryten
	company = "White Kryten Cybernetics"

//////////////// General VS-only ones /////////////////
/datum/robolimb/talon //They're buildable by default due to being extremely basic.
	company = "Talon LLC"
	desc = "This metallic limb is sleek and featuresless apart from some exposed motors"
	icon = 'icons/mob/human_races/cyberlimbs/talon/talon_main.dmi' //Sprited by: Viveret

/obj/item/weapon/disk/limb/talon
	company = "Talon LLC"

/datum/robolimb/zenghu_taj
    company = "Zeng-Hu - Tajaran"
    desc = "This limb has a rubbery fleshtone covering with visible seams."
    icon = 'icons/mob/human_races/cyberlimbs/zenghu/zenghu_taj.dmi'
    unavailable_to_build = 1
    parts = list(BP_HEAD)

//Darkside Incorperated synthetic augmentation list! Many current most used fuzzy and notsofuzzy races made into synths here.

/datum/robolimb/dsi_tajaran
	company = "DSI - Tajaran"
	desc = "This limb feels soft and fluffy, realistic design and squish. By Darkside Incorperated."
	icon = 'icons/mob/human_races/cyberlimbs/DSITajaran/dsi_tajaran.dmi'
	blood_color = "#5dd4fc"
	lifelike = 1
	unavailable_to_build = 1

/obj/item/weapon/disk/limb/dsi_tajaran
	company = "DSI - Tajaran"

/datum/robolimb/dsi_lizard
	company = "DSI - Lizard"
	desc = "This limb feels smooth and scalie, realistic design and squish. By Darkside Incorperated."
	icon = 'icons/mob/human_races/cyberlimbs/DSILizard/dsi_lizard.dmi'
	blood_color = "#5dd4fc"
	lifelike = 1
	unavailable_to_build = 1

/obj/item/weapon/disk/limb/dsi_lizard
	company = "DSI - Lizard"

/datum/robolimb/dsi_sergal
	company = "DSI - Sergal"
	desc = "This limb feels soft and fluffy, realistic design and toned muscle. By Darkside Incorperated."
	icon = 'icons/mob/human_races/cyberlimbs/DSISergal/dsi_sergal.dmi'
	blood_color = "#5dd4fc"
	lifelike = 1
	unavailable_to_build = 1

/obj/item/weapon/disk/limb/dsi_sergal
	company = "DSI - Sergal"

/datum/robolimb/dsi_nevrean
	company = "DSI - Nevrean"
	desc = "This limb feels soft and feathery, lightweight, realistic design and squish. By Darkside Incorperated."
	icon = 'icons/mob/human_races/cyberlimbs/DSINevrean/dsi_nevrean.dmi'
	blood_color = "#5dd4fc"
	lifelike = 1
	unavailable_to_build = 1

/obj/item/weapon/disk/limb/dsi_nevrean
	company = "DSI - Nevrean"

/datum/robolimb/dsi_vulpkanin
	company = "DSI - Vulpkanin"
	desc = "This limb feels soft and fluffy, realistic design and squish. Seems a little mischievous. By Darkside Incorperated."
	icon = 'icons/mob/human_races/cyberlimbs/DSIVulpkanin/dsi_vulpkanin.dmi'
	blood_color = "#5dd4fc"
	lifelike = 1
	unavailable_to_build = 1

/obj/item/weapon/disk/limb/dsi_vulpkanin
	company = "DSI - Vulpkanin"

