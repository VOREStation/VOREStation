//CitRP Port
var/const/cyberbeast_monitor_styles = "blank=cyber_blank;\
	default=cyber_default;\
	eyes=eyes;\
	static=cyber_static;\
	alert=cyber_alert;\
	happy=cyber_happ;\
	unhappy=cyber_unhapp;\
	flat=cyber_flat;\
	sad=cyber_sad;\
	heart=cyber_heart;\
	cross=cyber_cross;\
	wave=cyber_wave;\
	uwu=cyber_uwu;\
	question=cyber_question;\
	lowpower=cyber_lowpower;\
	idle=cyber_idle;\
	nwn=cyber_nwn"

//////////////// For-specific-character fluff ones /////////////////
// arokha : Aronai Sieyes
/datum/robolimb/kitsuhana
	company = "Kitsuhana"
	desc = "This limb seems rather vulpine and fuzzy, with realistic-feeling flesh."
	icon = 'icons/mob/human_races/cyberlimbs/_fluff_vr/aronai.dmi'
	blood_color = "#5dd4fc"
	includes_tail = 1
	lifelike = 1
	unavailable_to_build = 1
	suggested_species = "Tajara"
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
	includes_tail = 1
	whitelisted_to = list("silencedmp5a5")

/obj/item/weapon/disk/limb/white_kryten
	company = "White Kryten Cybernetics"

// verkister : Rahwoof Boop
/datum/robolimb/eggnerdltd
	company = "Uesseka Prototyping Ltd."
	desc = "This limb seems meticulously hand-crafted, and distinctly Unathi in design."
	icon = 'icons/mob/human_races/cyberlimbs/_fluff_vr/rahboop.dmi'
	species_cannot_use = list(SPECIES_TESHARI, SPECIES_PROMETHEAN, SPECIES_DIONA, SPECIES_HUMAN, SPECIES_VOX, SPECIES_HUMAN_VATBORN, SPECIES_TAJ, SPECIES_SKRELL, SPECIES_ZADDAT)
	species_alternates = list(SPECIES_HUMAN = "NanoTrasen")
	suggested_species = SPECIES_UNATHI
	blood_color = "#5e280d"
	includes_tail = 1
	unavailable_to_build = 1

<<<<<<< HEAD:code/modules/organs/robolimbs_vr.dm
/obj/item/weapon/disk/limb/eggnerdltd
	company = "Eggnerd Prototyping Ltd."
	icon = 'icons/obj/items_vr.dmi'
	icon_state = "verkdisk"

// tucker0666 : Frost
/datum/robolimb/zenghu_frost
    company = "Zeng-Hu (Custom)"
    desc = "This limb has realistic synthetic flesh covering with 'blue accents'."
    icon = 'icons/mob/human_races/cyberlimbs/_fluff_vr/Frosty.dmi'
    blood_color = "#45ccff"
    lifelike = 1
    skin_tone = 1
    unavailable_to_build = 1
    whitelisted_to = list("tucker0666")


/obj/item/weapon/disk/limb/zenghu_frost
    company = "Zeng-Hu (Modified)"
    catalogue_data = list(/datum/category_item/catalogue/information/organization/zeng_hu)
=======
/obj/item/weapon/disk/limb/uesseka
	company = "Uesseka Prototyping Ltd."
>>>>>>> ee968a2... Merge pull request #7907 from Cerebulon/virgoprosfix:code/modules/organs/robolimbs_custom.dm

/datum/robolimb/nanotrasen_metro
	company = "NanoTrasen - Metro"
	desc = "This metallic limb is sleek and featuresless apart from some exposed motors around the joints."
	icon = 'icons/mob/human_races/cyberlimbs/talon/talon_main.dmi' //Sprited by: Viveret

/obj/item/weapon/disk/limb/nanotrasen_metro
	company = "NanoTrasen - Metro"
	catalogue_data = list(/datum/category_item/catalogue/information/organization/nanotrasen)


/datum/robolimb/zenghu_taj
	company = "Zeng-Hu - Tajaran"
	desc = "This limb has a rubbery covering with basic faux fur and visible seams."
	icon = 'icons/mob/human_races/cyberlimbs/zenghu/zenghu_taj.dmi'
	species_cannot_use = list(SPECIES_TESHARI, SPECIES_PROMETHEAN, SPECIES_DIONA, SPECIES_HUMAN, SPECIES_VOX, SPECIES_HUMAN_VATBORN, SPECIES_UNATHI, SPECIES_SKRELL, SPECIES_ZADDAT)
	suggested_species = SPECIES_TAJ
	unavailable_to_build = 1
	parts = list(BP_HEAD)

/datum/robolimb/uessekared
	company = "Uesseka Prototyping Ltd. - Red"
	desc = "This limb seems meticulously hand-crafted, and distinctly Unathi in design. This one's red!"
	icon = 'icons/mob/human_races/cyberlimbs/rahboopred/rahboopred.dmi'
	species_cannot_use = list(SPECIES_TESHARI, SPECIES_PROMETHEAN, SPECIES_DIONA, SPECIES_HUMAN, SPECIES_VOX, SPECIES_HUMAN_VATBORN, SPECIES_TAJ, SPECIES_SKRELL, SPECIES_ZADDAT)
	species_alternates = list(SPECIES_HUMAN = "NanoTrasen")
	suggested_species = SPECIES_UNATHI
	blood_color = "#5e280d"
	includes_tail = 1
	unavailable_to_build = 1

<<<<<<< HEAD:code/modules/organs/robolimbs_vr.dm
/obj/item/weapon/disk/limb/eggnerdltdred
	company = "Eggnerd Prototyping Ltd. (Red)"
	icon = 'icons/obj/items_vr.dmi'
	icon_state = "verkdisk"

=======
/obj/item/weapon/disk/limb/uessekared
	company = "Uesseka Prototyping Ltd. (Red)"
>>>>>>> ee968a2... Merge pull request #7907 from Cerebulon/virgoprosfix:code/modules/organs/robolimbs_custom.dm

//Downstream realistic-fluffies for adminbus:

/datum/robolimb/dsi_tajaran
	company = "DSI - Tajaran"
	desc = "This limb feels soft and fluffy, realistic design and squish. By Darkside Incorperated."
	icon = 'icons/mob/human_races/cyberlimbs/DSITajaran/dsi_tajaran.dmi'
	blood_color = "#ffe2ff"
	lifelike = 1
	unavailable_to_build = 1
	includes_tail = 1
	skin_tone = 1
	suggested_species = "Tajara"

/obj/item/weapon/disk/limb/dsi_tajaran
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
	suggested_species = "Unathi"

/obj/item/weapon/disk/limb/dsi_lizard
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
	suggested_species = "Sergal"

/obj/item/weapon/disk/limb/dsi_sergal
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
	suggested_species = "Nevrean"

/obj/item/weapon/disk/limb/dsi_nevrean
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
	suggested_species = "Vulpkanin"

/obj/item/weapon/disk/limb/dsi_vulpkanin
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
	suggested_species = "Akula"

/obj/item/weapon/disk/limb/dsi_akula
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
	suggested_species = "Vasilissan"

/obj/item/weapon/disk/limb/dsi_spider
	company = "DSI - Vasilissan"

/datum/robolimb/dsi_teshari
	company = "DSI - Teshari"
	desc = "This limb has a thin synthflesh casing with a few connection ports."
	icon = 'icons/mob/human_races/cyberlimbs/DSITeshari/dsi_teshari.dmi'
	lifelike = 1
	skin_tone = 1
	suggested_species = "Teshari"

/datum/robolimb/dsi_teshari/New()
	species_cannot_use = GLOB.all_species.Copy()
	species_cannot_use -= SPECIES_TESHARI
	species_cannot_use -= SPECIES_CUSTOM
	..()

/obj/item/weapon/disk/limb/dsi_teshari
	company = "DSI - Teshari"

//Ported from CitRP
/datum/robolimb/cyber_beast
	company = "Cyber Tech"
	desc = "Adjusted for deep space, the material is durable and heavy."
	icon = 'icons/mob/human_races/cyberlimbs/c-tech/c_beast.dmi'
	unavailable_to_build = 1
	parts = list(BP_HEAD)
	monitor_icon = 'icons/mob/monitor_icons_vr.dmi'
	monitor_styles = cyberbeast_monitor_styles

/obj/item/weapon/disk/limb/cyber_beast
	company = "Cyber Tech"
