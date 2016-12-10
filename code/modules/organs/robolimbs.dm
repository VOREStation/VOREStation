var/list/all_robolimbs = list()
var/list/robolimb_data = list()
var/list/chargen_robolimbs = list()
var/datum/robolimb/basic_robolimb
var/const/standard_monitor_styles = "blank=ipc_blank;\
	pink=ipc_pink;\
	green=ipc_green,\
	red=ipc_red;\
	blue=ipc_blue;\
	shower=ipc_shower;\
	orange=ipc_orange;\
	nature=ipc_nature;\
	eight=ipc_eight;\
	goggles=ipc_goggles;\
	heart=ipc_heart;\
	monoeye=ipc_monoeye;\
	breakout=ipc_breakout;\
	yellow=ipc_yellow;\
	static=ipc_static;\
	purple=ipc_purple;\
	scroll=ipc_scroll;\
	console=ipc_console;\
	glider=ipc_gol_glider;\
	rainbow=ipc_rainbow"

/proc/populate_robolimb_list()
	basic_robolimb = new()
	for(var/limb_type in typesof(/datum/robolimb))
		var/datum/robolimb/R = new limb_type()
		all_robolimbs[R.company] = R
		if(!R.unavailable_at_chargen)
			chargen_robolimbs[R.company] = R //List only main brands and solo parts.

/datum/robolimb
	var/company = "Unbranded"                            // Shown when selecting the limb.
	var/desc = "A generic unbranded robotic prosthesis." // Seen when examining a limb.
	var/icon = 'icons/mob/human_races/robotic.dmi'       // Icon base to draw from.
	var/unavailable_at_chargen                           // If set, not available at chargen.
	var/unavailable_to_build							 // If set, can't be constructed.
	var/lifelike										 // If set, appears organic.
	var/blood_color = "#030303"
	var/list/species_cannot_use = list("Teshari")
	var/list/monitor_styles			 		 			 //If empty, the model of limbs offers a head compatible with monitors.
	var/parts = BP_ALL						 			 //Defines what parts said brand can replace on a body.
	var/health_hud_intensity = 1						 // Intensity modifier for the health GUI indicator.

/datum/robolimb/nanotrasen
	company = "NanoTrasen"
	desc = "A simple but efficient robotic limb, created by NanoTrasen."
	icon = 'icons/mob/human_races/cyberlimbs/nanotrasen/nanotrasen_main.dmi'

/datum/robolimb/bishop
	company = "Bishop"
	desc = "This limb has a white polymer casing with blue holo-displays."
	icon = 'icons/mob/human_races/cyberlimbs/bishop/bishop_main.dmi'
	unavailable_to_build = 1

/datum/robolimb/bishop_alt1
	company = "Bishop - Glyph"
	desc = "This limb has a white polymer casing with blue holo-displays."
	icon = 'icons/mob/human_races/cyberlimbs/bishop/bishop_alt1.dmi'
	unavailable_to_build = 1
	parts = list(BP_HEAD)

/datum/robolimb/bishop_monitor
	company = "Bishop Monitor"
	desc = "Bishop Cybernetics' unique spin on a popular prosthetic head model. The themes conflict in an intriguing way."
	icon = 'icons/mob/human_races/cyberlimbs/bishop/bishop_monitor.dmi'
	unavailable_to_build = 1
	parts = list(BP_HEAD)
	monitor_styles = standard_monitor_styles

/datum/robolimb/hesphiastos
	company = "Hesphiastos"
	desc = "This limb has a militaristic black and green casing with gold stripes."
	icon = 'icons/mob/human_races/cyberlimbs/hesphiastos/hesphiastos_main.dmi'
	unavailable_to_build = 1

/datum/robolimb/hesphiastos_alt1
	company = "Hesphiastos - Frontier"
	desc = "A rugged prosthetic head featuring the standard Hesphiastos theme, a visor and an external display."
	icon = 'icons/mob/human_races/cyberlimbs/hesphiastos/hesphiastos_alt1.dmi'
	unavailable_to_build = 1
	parts = list(BP_HEAD)
	monitor_styles = "blank=hesphiastos_alt_off;\
		pink=hesphiastos_alt_pink;\
		orange=hesphiastos_alt_orange;\
		goggles=hesphiastos_alt_goggles;\
		scroll=hesphiastos_alt_scroll;\
		rgb=hesphiastos_alt_rgb;\
		rainbow=hesphiastos_alt_rainbow"

/datum/robolimb/hesphiastos_monitor
	company = "Hesphiastos Monitor"
	desc = "Hesphiastos' unique spin on a popular prosthetic head model. It looks rugged and sturdy."
	icon = 'icons/mob/human_races/cyberlimbs/hesphiastos/hesphiastos_monitor.dmi'
	unavailable_to_build = 1
	parts = list(BP_HEAD)
	monitor_styles = standard_monitor_styles

/datum/robolimb/morpheus
	company = "Morpheus"
	desc = "This limb is simple and functional; no effort has been made to make it look human."
	icon = 'icons/mob/human_races/cyberlimbs/morpheus/morpheus_main.dmi'
	unavailable_to_build = 1
	monitor_styles = standard_monitor_styles

/datum/robolimb/morpheus_alt1
	company = "Morpheus - Zenith"
	desc = "This limb is simple and functional; no effort has been made to make it look human."
	icon = 'icons/mob/human_races/cyberlimbs/morpheus/morpheus_alt1.dmi'
	unavailable_to_build = 1
	parts = list(BP_HEAD)

/datum/robolimb/veymed
	company = "Vey-Med"
	desc = "This high quality limb is nearly indistinguishable from an organic one."
	icon = 'icons/mob/human_races/cyberlimbs/veymed/veymed_main.dmi'
	unavailable_to_build = 1
	lifelike = 1
	blood_color = "#CCCCCC"

/datum/robolimb/wardtakahashi
	company = "Ward-Takahashi"
	desc = "This limb features sleek black and white polymers."
	icon = 'icons/mob/human_races/cyberlimbs/wardtakahashi/wardtakahashi_main.dmi'
	unavailable_to_build = 1

/datum/robolimb/wardtakahashi_alt1
	company = "Ward-Takahashi - Shroud"
	desc = "This limb features sleek black and white polymers. This one looks more like a helmet of some sort."
	icon = 'icons/mob/human_races/cyberlimbs/wardtakahashi/wardtakahashi_alt1.dmi'
	unavailable_to_build = 1
	parts = list(BP_HEAD)

/datum/robolimb/wardtakahashi_monitor
	company = "Ward-Takahashi Monitor"
	desc = "Ward-Takahashi's unique spin on a popular prosthetic head model. It looks sleek and modern."
	icon = 'icons/mob/human_races/cyberlimbs/wardtakahashi/wardtakahashi_monitor.dmi'
	unavailable_to_build = 1
	parts = list(BP_HEAD)
	monitor_styles = standard_monitor_styles

/datum/robolimb/xion
	company = "Xion"
	desc = "This limb has a minimalist black and red casing."
	icon = 'icons/mob/human_races/cyberlimbs/xion/xion_main.dmi'
	unavailable_to_build = 1

/datum/robolimb/xion_alt1
	company = "Xion Mfg. - Breach"
	desc = "This limb has a minimalist black and red casing. Looks a bit menacing."
	icon = 'icons/mob/human_races/cyberlimbs/xion/xion_alt1.dmi'
	unavailable_to_build = 1
	parts = list(BP_HEAD)

/datum/robolimb/xion_monitor
	company = "Xion Mfg. Monitor"
	desc = "Xion Mfg.'s unique spin on a popular prosthetic head model. It looks and minimalist and utilitarian."
	icon = 'icons/mob/human_races/cyberlimbs/xion/xion_monitor.dmi'
	unavailable_to_build = 1
	parts = list(BP_HEAD)
	monitor_styles = standard_monitor_styles

/datum/robolimb/zenghu
	company = "Zeng-Hu"
	desc = "This limb has a rubbery fleshtone covering with visible seams."
	icon = 'icons/mob/human_races/cyberlimbs/zenghu/zenghu_main.dmi'
	unavailable_to_build = 1

/obj/item/weapon/disk/limb
	name = "Limb Blueprints"
	desc = "A disk containing the blueprints for prosthetics."
	icon = 'icons/obj/cloning.dmi'
	icon_state = "datadisk2"
	var/company = ""

/obj/item/weapon/disk/limb/New(var/newloc)
	..()
	if(company)
		name = "[company] [initial(name)]"

/obj/item/weapon/disk/limb/bishop
	company = "Bishop"

/obj/item/weapon/disk/limb/hesphiastos
	company = "Hesphiastos"

/obj/item/weapon/disk/limb/morpheus
	company = "Morpheus"

/obj/item/weapon/disk/limb/veymed
	company = "Vey-Med"

/obj/item/weapon/disk/limb/wardtakahashi
	company = "Ward-Takahashi"

/obj/item/weapon/disk/limb/xion
	company = "Xion"

/obj/item/weapon/disk/limb/zenghu
	company = "Zeng-Hu"

/obj/item/weapon/disk/limb/nanotrasen
	company = "NanoTrasen"
