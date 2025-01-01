GLOBAL_LIST_INIT(dsi_to_species, list(SPECIES_TAJARAN = "DSI - Tajaran", SPECIES_UNATHI = "DSI - Lizard", SPECIES_SERGAL = "DSI - Sergal", SPECIES_NEVREAN = "DSI - Nevrean", \
									SPECIES_VULPKANIN = "DSI - Vulpkanin", SPECIES_AKULA = "DSI - Akula", SPECIES_VASILISSAN = "DSI - Vasilissan", SPECIES_ZORREN = "DSI - Zorren",\
									SPECIES_TESHARI = "DSI - Teshari", SPECIES_FENNEC = "DSI - Fennec"))

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

// Placeholder for protean limbs during character spawning, before they have a properly set model
/datum/robolimb/protean
	company = "protean"
	desc = "Nano-y!"
	lifelike = 1
	unavailable_to_build = 1
	unavailable_at_chargen = 1

//////////////// For-specific-character fluff ones /////////////////
// arokha : Aronai Sieyes
/datum/robolimb/kitsuhana
	company = "Kitsuhana"
	desc = "This limb seems rather vulpine and fuzzy, with realistic-feeling flesh."
	icon = 'icons/mob/human_races/cyberlimbs/_fluff_vr/aronai.dmi'
	blood_color = "#5dd4fc"
	includes_tail = 1
	includes_ears = 1
	lifelike = 1
	unavailable_to_build = 1
	suggested_species = SPECIES_VULPKANIN
	whitelisted_to = list("arokha")

/obj/item/disk/limb/kitsuhana
	company = "Kitsuhana"

// silencedmp5a5 : Serdykov Antoz
/datum/robolimb/white_kryten
	company = "White Kryten Cybernetics"
	desc = "This limb feels realistic to the touch, with soft fur. Were it not for the bright orange lights embedded in it, you might have trouble telling it from a non synthetic limb!"
	icon = 'icons/mob/human_races/cyberlimbs/_fluff_vr/serdykov.dmi'
	blood_color = "#ff6a00"
	unavailable_to_build = 1
	includes_tail = 1
	whitelisted_to = list("silencedmp5a5", "cgr")

/obj/item/disk/limb/white_kryten
	company = "White Kryten Cybernetics"

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

/obj/item/disk/limb/zenghu_frost
    company = "Zeng-Hu (Modified)"
    catalogue_data = list(/datum/category_item/catalogue/information/organization/zeng_hu)

//Ported from CitRP
/datum/robolimb/cyber_beast
	company = "Cyber Tech"
	desc = "Adjusted for deep space, the material is durable and heavy."
	icon = 'icons/mob/human_races/cyberlimbs/c-tech/c_beast.dmi'
	unavailable_to_build = 1
	parts = list(BP_HEAD)
	monitor_icon = 'icons/mob/monitor_icons_vr.dmi'
	monitor_styles = cyberbeast_monitor_styles

/obj/item/disk/limb/cyber_beast
	company = "Cyber Tech"

/datum/robolimb/zenghu_glacier
	company = "Zeng-Hu Glacier"
	desc = "This limb has a rubbery white covering with visible seams."
	icon = 'icons/mob/human_races/cyberlimbs/zenghu/zenghu_glacier_main.dmi'
	species_alternates = list(SPECIES_TAJARAN = "Zeng-Hu - Tajaran")
	unavailable_to_build = 1
	skin_tone = 1
	modular_bodyparts = MODULAR_BODYPART_PROSTHETIC

/datum/robolimb/zenghu_taj_glacier
	company = "Zeng-Hu Glacier - Tajaran"
	desc = "This limb has a rubbery white covering with visible seams."
	icon = 'icons/mob/human_races/cyberlimbs/zenghu/zenghu_glacier_taj.dmi'
	unavailable_to_build = 1
	parts = list(BP_HEAD)
