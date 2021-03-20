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
