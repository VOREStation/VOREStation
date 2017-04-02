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