var/list/all_robolimbs = list()
var/list/robolimb_data = list()
var/list/chargen_robolimbs = list()
var/datum/robolimb/basic_robolimb
var/const/standard_monitor_styles = "blank=ipc_blank;\
	pink=ipc_pink;\
	green=ipc_green;\
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
	rainbow=ipc_rainbow;\
	smiley=ipc_smiley;\
	database=ipc_database"

/proc/populate_robolimb_list()
	basic_robolimb = new()
	for(var/limb_type in typesof(/datum/robolimb))
		var/datum/robolimb/R = new limb_type()
		all_robolimbs[R.company] = R
		if(!R.unavailable_at_chargen)
			chargen_robolimbs[R.company] = R //List only main brands and solo parts.

	for(var/company in all_robolimbs)
		var/datum/robolimb/R = all_robolimbs[company]
		if(R.species_alternates)
			for(var/species in R.species_alternates)
				var/species_company = R.species_alternates[species]
				if(species_company in all_robolimbs)
					R.species_alternates[species] = all_robolimbs[species_company]

/datum/robolimb
	var/company = "Unbranded"                            // Shown when selecting the limb.
	var/desc = "A generic unbranded robotic prosthesis." // Seen when examining a limb.
	var/icon = 'icons/mob/human_races/robotic.dmi'       // Icon base to draw from.
	var/monitor_icon = 'icons/mob/monitor_icons.dmi'     // Where it draws the monitor icon from.
	var/unavailable_at_chargen                           // If set, not available at chargen.
	var/unavailable_to_build                             // If set, can't be constructed.
	var/lifelike                                         // If set, appears organic.
	var/skin_tone                                        // If set, applies skin tone rather than part color Overrides color.
	var/skin_color                                       // If set, applies skin color rather than part color.
	var/blood_color = SYNTH_BLOOD_COLOUR                 // Colour for blood splatters.
	var/blood_name = "oil"                               // Descriptor for blood splatters.
	var/list/monitor_styles                              // If empty, the model of limbs offers a head compatible with monitors.
	var/parts = BP_ALL                                   // Defines what parts said brand can replace on a body.
	var/health_hud_intensity = 1                         // Intensity modifier for the health GUI indicator.
	var/suggested_species = "Human"                      // If it should make the torso a species
	var/speech_bubble_appearance = "synthetic"           // What icon_state to use for speech bubbles when talking.  Check talk.dmi for all the icons.
	var/modular_bodyparts = MODULAR_BODYPART_PROSTHETIC  // Whether or not this limb allows attaching/detaching, and whether or not it checks its parent as well.		//VOREStation Edit; Let's just do full detachment/reattachment by default.
	var/robo_brute_mod = 1                               // Multiplier for incoming brute damage.
	var/robo_burn_mod = 1                                // As above for burn.
	// Species in this list cannot take these prosthetics.
	var/list/species_cannot_use = list(SPECIES_TESHARI, SPECIES_PROMETHEAN, SPECIES_DIONA, SPECIES_XENOCHIMERA)  //VOREStation Edit
	// "Species Name" = "Robolimb Company", List, when initialized, will become "Species Name" = RobolimbDatum, used for alternate species sprites.
	var/list/species_alternates = list(SPECIES_TAJ = "Unbranded - Tajaran", SPECIES_UNATHI = "Unbranded - Unathi")

/datum/robolimb/unbranded_monitor
	company = "Unbranded Monitor"
	desc = "A generic unbranded interpretation of a popular prosthetic head model. It looks rudimentary and cheaply constructed."
	icon = 'icons/mob/human_races/cyberlimbs/unbranded/unbranded_monitor.dmi'
	parts = list(BP_HEAD)
	monitor_styles = standard_monitor_styles
	unavailable_to_build = 1

/datum/robolimb/unbranded_alt1
	company = "Unbranded - Protez"
	desc = "A simple robotic limb with retro design. Seems rather stiff."
	icon = 'icons/mob/human_races/cyberlimbs/unbranded/unbranded_alt1.dmi'
	unavailable_to_build = 1
	modular_bodyparts = MODULAR_BODYPART_PROSTHETIC			//VOREStation Edit - remove the restrictions

/datum/robolimb/unbranded_alt2
	company = "Unbranded - Mantis Prosis"
	desc = "This limb has a casing of sleek black metal and repulsive insectile design."
	icon = 'icons/mob/human_races/cyberlimbs/unbranded/unbranded_alt2.dmi'
	unavailable_to_build = 1
	modular_bodyparts = MODULAR_BODYPART_PROSTHETIC			//VOREStation Edit - remove the restrictions

/datum/robolimb/unbranded_tajaran
	company = "Unbranded - Tajaran"
	species_cannot_use = list(SPECIES_TESHARI, SPECIES_PROMETHEAN, SPECIES_DIONA, SPECIES_HUMAN, SPECIES_VOX, SPECIES_HUMAN_VATBORN, SPECIES_UNATHI, SPECIES_SKRELL, SPECIES_ZADDAT)
	suggested_species = SPECIES_TAJ
	desc = "A simple robotic limb with feline design. Seems rather stiff."
	icon = 'icons/mob/human_races/cyberlimbs/unbranded/unbranded_tajaran.dmi'
	unavailable_to_build = 1
	modular_bodyparts = MODULAR_BODYPART_PROSTHETIC			//VOREStation Edit - remove the restrictions

/datum/robolimb/unbranded_unathi
	company = "Unbranded - Unathi"
	species_cannot_use = list(SPECIES_TESHARI, SPECIES_PROMETHEAN, SPECIES_DIONA, SPECIES_HUMAN, SPECIES_VOX, SPECIES_HUMAN_VATBORN, SPECIES_TAJ, SPECIES_SKRELL, SPECIES_ZADDAT)
	suggested_species = SPECIES_UNATHI
	desc = "A simple robotic limb with reptilian design. Seems rather stiff."
	icon = 'icons/mob/human_races/cyberlimbs/unbranded/unbranded_unathi.dmi'
	unavailable_to_build = 1
	modular_bodyparts = MODULAR_BODYPART_PROSTHETIC			//VOREStation Edit - remove the restrictions

/datum/robolimb/unbranded_teshari
	company = "Unbranded - Teshari"
	species_cannot_use = list(SPECIES_UNATHI, SPECIES_PROMETHEAN, SPECIES_DIONA, SPECIES_HUMAN, SPECIES_VOX, SPECIES_HUMAN_VATBORN, SPECIES_TAJ, SPECIES_SKRELL, SPECIES_ZADDAT)
	suggested_species = SPECIES_TESHARI
	desc = "A simple robotic limb with a small, raptor-like design. Seems rather stiff."
	icon = 'icons/mob/human_races/cyberlimbs/unbranded/unbranded_teshari.dmi'
	unavailable_to_build = 0
	modular_bodyparts = MODULAR_BODYPART_PROSTHETIC			//VOREStation Edit - remove the restrictions
	parts = list(BP_HEAD, BP_TORSO, BP_GROIN)

/datum/robolimb/unbranded_teshari/limbs
	company = "Unbranded - Teshari (Limbs)"
	parts = list(BP_L_ARM, BP_R_ARM, BP_L_HAND, BP_R_HAND, BP_L_LEG, BP_R_LEG, BP_L_FOOT, BP_R_FOOT)
	modular_bodyparts = MODULAR_BODYPART_PROSTHETIC

/datum/robolimb/nanotrasen
	company = "NanoTrasen"
	desc = "A simple but efficient robotic limb, created by NanoTrasen."
	icon = 'icons/mob/human_races/cyberlimbs/nanotrasen/nanotrasen_main.dmi'
	species_alternates = list(SPECIES_TAJ = "NanoTrasen - Tajaran", SPECIES_UNATHI = "NanoTrasen - Unathi")
	modular_bodyparts = MODULAR_BODYPART_PROSTHETIC			//VOREStation Edit - remove the restrictions

/datum/robolimb/nanotrasen_tajaran
	company = "NanoTrasen - Tajaran"
	species_cannot_use = list(SPECIES_TESHARI, SPECIES_PROMETHEAN, SPECIES_DIONA, SPECIES_HUMAN, SPECIES_VOX, SPECIES_HUMAN_VATBORN, SPECIES_UNATHI, SPECIES_SKRELL, SPECIES_ZADDAT)
	species_alternates = list(SPECIES_HUMAN = "NanoTrasen")
	suggested_species = SPECIES_TAJ
	desc = "A simple but efficient robotic limb, created by NanoTrasen."
	icon = 'icons/mob/human_races/cyberlimbs/nanotrasen/nanotrasen_tajaran.dmi'
	unavailable_to_build = 1
	modular_bodyparts = MODULAR_BODYPART_PROSTHETIC			//VOREStation Edit - remove the restrictions

/datum/robolimb/nanotrasen_unathi
	company = "NanoTrasen - Unathi"
	species_cannot_use = list(SPECIES_TESHARI, SPECIES_PROMETHEAN, SPECIES_DIONA, SPECIES_HUMAN, SPECIES_VOX, SPECIES_HUMAN_VATBORN, SPECIES_TAJ, SPECIES_SKRELL, SPECIES_ZADDAT)
	species_alternates = list(SPECIES_HUMAN = "NanoTrasen")
	suggested_species = SPECIES_UNATHI
	desc = "A simple but efficient robotic limb, created by NanoTrasen."
	icon = 'icons/mob/human_races/cyberlimbs/nanotrasen/nanotrasen_unathi.dmi'
	unavailable_to_build = 1
	modular_bodyparts = MODULAR_BODYPART_PROSTHETIC			//VOREStation Edit - remove the restrictions

/datum/robolimb/cenilimicybernetics_teshari
	company = "Cenilimi Cybernetics"
	species_cannot_use = list(SPECIES_UNATHI, SPECIES_PROMETHEAN, SPECIES_DIONA, SPECIES_HUMAN, SPECIES_VOX, SPECIES_HUMAN_VATBORN, SPECIES_TAJ, SPECIES_SKRELL, SPECIES_ZADDAT)
	species_alternates = list(SPECIES_HUMAN = "NanoTrasen")
	suggested_species = SPECIES_TESHARI
	desc = "Made by a Teshari-owned company, for Teshari."
	icon = 'icons/mob/human_races/cyberlimbs/cenilimicybernetics/cenilimicybernetics_teshari.dmi'
	unavailable_to_build = 1
	modular_bodyparts = MODULAR_BODYPART_PROSTHETIC			//VOREStation Edit - remove the restrictions

/datum/robolimb/bishop
	company = "Bishop"
	desc = "This limb has a white polymer casing with blue holo-displays."
	icon = 'icons/mob/human_races/cyberlimbs/bishop/bishop_main.dmi'
	unavailable_to_build = 1
	modular_bodyparts = MODULAR_BODYPART_PROSTHETIC			//VOREStation Edit - remove the restrictions

/datum/robolimb/bishop_alt1
	company = "Bishop - Glyph"
	desc = "This limb has a white polymer casing with blue holo-displays."
	icon = 'icons/mob/human_races/cyberlimbs/bishop/bishop_alt1.dmi'
	unavailable_to_build = 1
	parts = list(BP_HEAD)
	modular_bodyparts = MODULAR_BODYPART_PROSTHETIC			//VOREStation Edit - remove the restrictions

/datum/robolimb/bishop_alt2
	company = "Bishop - Rook"
	desc = "This limb has a solid plastic casing with blue lights along it."
	icon = 'icons/mob/human_races/cyberlimbs/bishop/bishop_alt2.dmi'
	unavailable_to_build = 1
	modular_bodyparts = MODULAR_BODYPART_PROSTHETIC			//VOREStation Edit - remove the restrictions

/datum/robolimb/bishop_monitor
	company = "Bishop Monitor"
	desc = "Bishop Cybernetics' unique spin on a popular prosthetic head model. The themes conflict in an intriguing way."
	icon = 'icons/mob/human_races/cyberlimbs/bishop/bishop_monitor.dmi'
	unavailable_to_build = 1
	parts = list(BP_HEAD)
	monitor_styles = standard_monitor_styles
	modular_bodyparts = MODULAR_BODYPART_PROSTHETIC			//VOREStation Edit - remove the restrictions

/datum/robolimb/gestaltframe
	company = "Skrellian Exoskeleton"
	desc = "This limb looks to be more like a strange.. puppet, than a prosthetic."
	icon = 'icons/mob/human_races/cyberlimbs/veymed/dionaea/skrellian.dmi'
	blood_color = "#63b521"
	blood_name = "synthetic ichor"
	speech_bubble_appearance = "machine"
	unavailable_to_build = 1
	species_cannot_use = list(SPECIES_TESHARI, SPECIES_PROMETHEAN, SPECIES_TAJ, SPECIES_HUMAN, SPECIES_VOX, SPECIES_HUMAN_VATBORN, SPECIES_UNATHI, SPECIES_SKRELL, SPECIES_ZADDAT)
	suggested_species = SPECIES_DIONA
	// Dionaea are naturally very tanky, so the robotic limbs are actually far weaker than their normal bodies.
	robo_brute_mod = 1.3
	robo_burn_mod = 1.3
	modular_bodyparts = MODULAR_BODYPART_PROSTHETIC			//VOREStation Edit - remove the restrictions

/datum/robolimb/cybersolutions
	company = "Cyber Solutions"
	desc = "This limb is grey and rough, with little in the way of aesthetic."
	icon = 'icons/mob/human_races/cyberlimbs/cybersolutions/cybersolutions_main.dmi'
	unavailable_to_build = 1
	modular_bodyparts = MODULAR_BODYPART_PROSTHETIC			//VOREStation Edit - remove the restrictions

/datum/robolimb/cybersolutions_alt2
	company = "Cyber Solutions - Outdated"
	desc = "This limb is of severely outdated design; there's no way it's comfortable or very functional to use."
	icon = 'icons/mob/human_races/cyberlimbs/cybersolutions/cybersolutions_alt2.dmi'
	unavailable_to_build = 1
	modular_bodyparts = MODULAR_BODYPART_PROSTHETIC			//VOREStation Edit - remove the restrictions

/datum/robolimb/cybersolutions_alt1
	company = "Cyber Solutions - Wight"
	desc = "This limb has cheap plastic panels mounted on grey metal."
	icon = 'icons/mob/human_races/cyberlimbs/cybersolutions/cybersolutions_alt1.dmi'
	unavailable_to_build = 1
	modular_bodyparts = MODULAR_BODYPART_PROSTHETIC			//VOREStation Edit - remove the restrictions

/datum/robolimb/cybersolutions_alt3
	company = "Cyber Solutions - Array"
	desc = "This limb is simple and functional; array of sensors on a featureless case."
	icon = 'icons/mob/human_races/cyberlimbs/cybersolutions/cybersolutions_alt3.dmi'
	unavailable_to_build = 1
	parts = list(BP_HEAD)
	modular_bodyparts = MODULAR_BODYPART_PROSTHETIC			//VOREStation Edit - remove the restrictions

/datum/robolimb/einstein
	company = "Einstein Engines"
	desc = "This limb is lightweight with a sleek design."
	icon = 'icons/mob/human_races/cyberlimbs/einstein/einstein_main.dmi'
	unavailable_to_build = 1
	modular_bodyparts = MODULAR_BODYPART_PROSTHETIC			//VOREStation Edit - remove the restrictions

/datum/robolimb/grayson
	company = "Grayson"
	desc = "This limb has a sturdy and heavy build to it."
	icon = 'icons/mob/human_races/cyberlimbs/grayson/grayson_main.dmi'
	unavailable_to_build = 1
	monitor_styles = "blank=grayson_off;\
		red=grayson_red;\
		green=grayson_green;\
		blue=grayson_blue;\
		rgb=grayson_rgb"
	modular_bodyparts = MODULAR_BODYPART_PROSTHETIC			//VOREStation Edit - remove the restrictions

/datum/robolimb/grayson_alt1
	company = "Grayson - Reinforced"
	desc = "This limb has a sturdy and heavy build to it."
	icon = 'icons/mob/human_races/cyberlimbs/grayson/grayson_alt1.dmi'
	unavailable_to_build = 1
	parts = list(BP_HEAD)
	monitor_styles = "blank=grayson_alt_off;\
		green=grayson_alt_green;\
		scroll=grayson_alt_scroll;\
		rgb=grayson_alt_rgb;\
		rainbow=grayson_alt_rainbow"
	modular_bodyparts = MODULAR_BODYPART_PROSTHETIC			//VOREStation Edit - remove the restrictions

/datum/robolimb/grayson_monitor
	company = "Grayson Monitor"
	desc = "This limb has a sturdy and heavy build to it, and uses plastics in the place of glass for the monitor."
	icon = 'icons/mob/human_races/cyberlimbs/grayson/grayson_monitor.dmi'
	unavailable_to_build = 1
	parts = list(BP_HEAD)
	monitor_styles = standard_monitor_styles
	modular_bodyparts = MODULAR_BODYPART_PROSTHETIC			//VOREStation Edit - remove the restrictions

/datum/robolimb/hephaestus
	company = "Hephaestus"
	desc = "This limb has a militaristic black and green casing with gold stripes."
	icon = 'icons/mob/human_races/cyberlimbs/hephaestus/hephaestus_main.dmi'
	unavailable_to_build = 1
	modular_bodyparts = MODULAR_BODYPART_PROSTHETIC			//VOREStation Edit - remove the restrictions

/datum/robolimb/hephaestus_alt1
	company = "Hephaestus - Frontier"
	desc = "A rugged prosthetic head featuring the standard Hephaestus theme, a visor and an external display."
	icon = 'icons/mob/human_races/cyberlimbs/hephaestus/hephaestus_alt1.dmi'
	unavailable_to_build = 1
	parts = list(BP_HEAD)
	monitor_styles = "blank=hephaestus_alt_off;\
		pink=hephaestus_alt_pink;\
		orange=hephaestus_alt_orange;\
		goggles=hephaestus_alt_goggles;\
		scroll=hephaestus_alt_scroll;\
		rgb=hephaestus_alt_rgb;\
		rainbow=hephaestus_alt_rainbow"
	modular_bodyparts = MODULAR_BODYPART_PROSTHETIC			//VOREStation Edit - remove the restrictions

/datum/robolimb/hephaestus_alt2
	company = "Hephaestus - Athena"
	desc = "This rather thick limb has a militaristic green plating."
	icon = 'icons/mob/human_races/cyberlimbs/hephaestus/hephaestus_alt2.dmi'
	unavailable_to_build = 1
	monitor_styles = "red=athena_red;\
		blank=athena_off"
	modular_bodyparts = MODULAR_BODYPART_PROSTHETIC			//VOREStation Edit - remove the restrictions

/datum/robolimb/hephaestus_monitor
	company = "Hephaestus Monitor"
	desc = "Hephaestus' unique spin on a popular prosthetic head model. It looks rugged and sturdy."
	icon = 'icons/mob/human_races/cyberlimbs/hephaestus/hephaestus_monitor.dmi'
	unavailable_to_build = 1
	parts = list(BP_HEAD)
	monitor_styles = standard_monitor_styles
	modular_bodyparts = MODULAR_BODYPART_PROSTHETIC			//VOREStation Edit - remove the restrictions

/datum/robolimb/morpheus
	company = "Morpheus"
	desc = "This limb is simple and functional; no effort has been made to make it look human."
	icon = 'icons/mob/human_races/cyberlimbs/morpheus/morpheus_main.dmi'
	unavailable_to_build = 1
	monitor_styles = standard_monitor_styles
	modular_bodyparts = MODULAR_BODYPART_PROSTHETIC			//VOREStation Edit - remove the restrictions

/datum/robolimb/morpheus_alt1
	company = "Morpheus - Zenith"
	desc = "This limb is simple and functional; no effort has been made to make it look human."
	icon = 'icons/mob/human_races/cyberlimbs/morpheus/morpheus_alt1.dmi'
	unavailable_to_build = 1
	parts = list(BP_HEAD)
	modular_bodyparts = MODULAR_BODYPART_PROSTHETIC			//VOREStation Edit - remove the restrictions

/datum/robolimb/morpheus_alt2
	company = "Morpheus - Skeleton Crew"
	desc = "This limb is simple and functional; it's basically just a case for a brain."
	icon = 'icons/mob/human_races/cyberlimbs/morpheus/morpheus_alt2.dmi'
	unavailable_to_build = 1
	parts = list(BP_HEAD)
	modular_bodyparts = MODULAR_BODYPART_PROSTHETIC			//VOREStation Edit - remove the restrictions

/datum/robolimb/veymed
	company = "Vey-Med"
	desc = "This high quality limb is nearly indistinguishable from an organic one."
	icon = 'icons/mob/human_races/cyberlimbs/veymed/veymed_main_vr.dmi' //Vorestation edit, fixing the color application
	unavailable_to_build = 1
	lifelike = 1
	skin_tone = 1
	species_alternates = list(SPECIES_SKRELL = "Vey-Med - Skrell")
	blood_color = "#CCCCCC"
	blood_name = "coolant"
	speech_bubble_appearance = "normal"
	//robo_brute_mod = 1.1 //VOREStation Edit
	//robo_burn_mod = 1.1 //VOREStation Edit
	modular_bodyparts = MODULAR_BODYPART_PROSTHETIC			//VOREStation Edit - remove the restrictions

/datum/robolimb/veymed_skrell
	company = "Vey-Med - Skrell"
	desc = "This high quality limb is nearly indistinguishable from an organic one."
	icon = 'icons/mob/human_races/cyberlimbs/veymed/veymed_skrell.dmi'
	unavailable_to_build = 1
	lifelike = 1
	skin_color = TRUE
	species_cannot_use = list(SPECIES_TESHARI, SPECIES_PROMETHEAN, SPECIES_TAJ, SPECIES_HUMAN, SPECIES_VOX, SPECIES_HUMAN_VATBORN, SPECIES_UNATHI, SPECIES_DIONA, SPECIES_ZADDAT)
	blood_color = "#4451cf"
	blood_name = "coolant"
	speech_bubble_appearance = "normal"
	//robo_brute_mod = 1.05	//VOREStation Edit
	//robo_burn_mod = 1.05	//VOREStation Edit
	modular_bodyparts = MODULAR_BODYPART_PROSTHETIC			//VOREStation Edit - remove the restrictions

/datum/robolimb/wardtakahashi
	company = "Ward-Takahashi"
	desc = "This limb features sleek black and white polymers."
	icon = 'icons/mob/human_races/cyberlimbs/wardtakahashi/wardtakahashi_main.dmi'
	unavailable_to_build = 1
	modular_bodyparts = MODULAR_BODYPART_PROSTHETIC			//VOREStation Edit - remove the restrictions

/datum/robolimb/wardtakahashi_alt1
	company = "Ward-Takahashi - Shroud"
	desc = "This limb features sleek black and white polymers. This one looks more like a helmet of some sort."
	icon = 'icons/mob/human_races/cyberlimbs/wardtakahashi/wardtakahashi_alt1.dmi'
	unavailable_to_build = 1
	parts = list(BP_HEAD)
	modular_bodyparts = MODULAR_BODYPART_PROSTHETIC			//VOREStation Edit - remove the restrictions

/datum/robolimb/wardtakahashi_alt2
	company = "Ward-Takahashi - Spirit"
	desc = "This limb has white and purple features, with a heavier casing."
	icon = 'icons/mob/human_races/cyberlimbs/wardtakahashi/wardtakahashi_alt2.dmi'
	unavailable_to_build = 1
	modular_bodyparts = MODULAR_BODYPART_PROSTHETIC			//VOREStation Edit - remove the restrictions

/datum/robolimb/wardtakahashi_monitor
	company = "Ward-Takahashi Monitor"
	desc = "Ward-Takahashi's unique spin on a popular prosthetic head model. It looks sleek and modern."
	icon = 'icons/mob/human_races/cyberlimbs/wardtakahashi/wardtakahashi_monitor.dmi'
	unavailable_to_build = 1
	parts = list(BP_HEAD)
	monitor_styles = standard_monitor_styles
	modular_bodyparts = MODULAR_BODYPART_PROSTHETIC			//VOREStation Edit - remove the restrictions

/datum/robolimb/xion
	company = "Xion"
	desc = "This limb has a minimalist black and red casing."
	icon = 'icons/mob/human_races/cyberlimbs/xion/xion_main.dmi'
	unavailable_to_build = 1
	modular_bodyparts = MODULAR_BODYPART_PROSTHETIC			//VOREStation Edit - remove the restrictions

/datum/robolimb/xion_alt1
	company = "Xion - Breach"
	desc = "This limb has a minimalist black and red casing. Looks a bit menacing."
	icon = 'icons/mob/human_races/cyberlimbs/xion/xion_alt1.dmi'
	unavailable_to_build = 1
	parts = list(BP_HEAD)
	modular_bodyparts = MODULAR_BODYPART_PROSTHETIC			//VOREStation Edit - remove the restrictions

/datum/robolimb/xion_alt2
	company = "Xion - Hull"
	desc = "This limb has a thick orange casing with steel plating."
	icon = 'icons/mob/human_races/cyberlimbs/xion/xion_alt2.dmi'
	unavailable_to_build = 1
	monitor_styles = "blank=xion_off;\
		red=xion_red;\
		green=xion_green;\
		blue=xion_blue;\
		rgb=xion_rgb"
	modular_bodyparts = MODULAR_BODYPART_PROSTHETIC			//VOREStation Edit - remove the restrictions

/datum/robolimb/xion_alt3
	company = "Xion - Whiteout"
	desc = "This limb has a minimalist black and white casing."
	icon = 'icons/mob/human_races/cyberlimbs/xion/xion_alt3.dmi'
	unavailable_to_build = 1
	modular_bodyparts = MODULAR_BODYPART_PROSTHETIC			//VOREStation Edit - remove the restrictions

/datum/robolimb/xion_alt4
	company = "Xion - Breach - Whiteout"
	desc = "This limb has a minimalist black and white casing. Looks a bit menacing."
	icon = 'icons/mob/human_races/cyberlimbs/xion/xion_alt4.dmi'
	unavailable_to_build = 1
	parts = list(BP_HEAD)
	modular_bodyparts = MODULAR_BODYPART_PROSTHETIC			//VOREStation Edit - remove the restrictions


/datum/robolimb/xion_monitor
	company = "Xion Monitor"
	desc = "Xion Mfg.'s unique spin on a popular prosthetic head model. It looks and minimalist and utilitarian."
	icon = 'icons/mob/human_races/cyberlimbs/xion/xion_monitor.dmi'
	unavailable_to_build = 1
	parts = list(BP_HEAD)
	monitor_styles = standard_monitor_styles
	modular_bodyparts = MODULAR_BODYPART_PROSTHETIC			//VOREStation Edit - remove the restrictions

/datum/robolimb/zenghu
	company = "Zeng-Hu"
	desc = "This limb has a rubbery fleshtone covering with visible seams."
	icon = 'icons/mob/human_races/cyberlimbs/zenghu/zenghu_main.dmi'
	species_alternates = list(SPECIES_TAJ = "Zeng-Hu - Tajaran")
	unavailable_to_build = 1
	skin_tone = 1
	modular_bodyparts = MODULAR_BODYPART_PROSTHETIC			//VOREStation Edit - remove the restrictions

/datum/robolimb/wooden
	company = "Morgan Trading Co"
	desc = "A simplistic, metal-banded, wood-panelled prosthetic."
	icon = 'icons/mob/human_races/cyberlimbs/prosthesis/wooden.dmi'
	modular_bodyparts = MODULAR_BODYPART_PROSTHETIC
	parts = list(BP_L_ARM, BP_R_ARM, BP_L_HAND, BP_R_HAND, BP_L_LEG, BP_R_LEG, BP_L_FOOT, BP_R_FOOT)
	modular_bodyparts = MODULAR_BODYPART_PROSTHETIC

/obj/item/weapon/disk/limb
	name = "Limb Blueprints"
	desc = "A disk containing the blueprints for prosthetics."
	icon = 'icons/obj/discs_vr.dmi' //VOREStation Edit
	icon_state = "data-white" //VOREStation Edit
	var/company = ""

/obj/item/weapon/disk/limb/Initialize()
	. = ..()
	if(company)
		name = "[company] [initial(name)]"

/obj/item/weapon/disk/limb/bishop
	company = "Bishop"
	catalogue_data = list(/datum/category_item/catalogue/information/organization/bishop)

/obj/item/weapon/disk/limb/cybersolutions
	company = "Cyber Solutions"

/obj/item/weapon/disk/limb/grayson
	company = "Grayson"

/obj/item/weapon/disk/limb/hephaestus
	company = "Hephaestus"
	catalogue_data = list(/datum/category_item/catalogue/information/organization/hephaestus)

/obj/item/weapon/disk/limb/morpheus
	company = "Morpheus"
	catalogue_data = list(/datum/category_item/catalogue/information/organization/morpheus)

/obj/item/weapon/disk/limb/veymed
	company = "Vey-Med"
	catalogue_data = list(/datum/category_item/catalogue/information/organization/vey_med)

// Bus disk for Diona mech parts.
/obj/item/weapon/disk/limb/veymed/diona
	company = "Skrellian Exoskeleton"

/obj/item/weapon/disk/limb/wardtakahashi
	company = "Ward-Takahashi"
	catalogue_data = list(/datum/category_item/catalogue/information/organization/ward_takahashi)

/obj/item/weapon/disk/limb/xion
	company = "Xion"
	catalogue_data = list(/datum/category_item/catalogue/information/organization/xion)

/obj/item/weapon/disk/limb/zenghu
	company = "Zeng-Hu"
	catalogue_data = list(/datum/category_item/catalogue/information/organization/zeng_hu)

/obj/item/weapon/disk/limb/nanotrasen
	company = "NanoTrasen"
	catalogue_data = list(/datum/category_item/catalogue/information/organization/nanotrasen)

/obj/item/weapon/disk/species
	name = "Species Bioprints"
	desc = "A disk containing the blueprints for species-specific prosthetics."
	icon = 'icons/obj/cloning.dmi'
	icon_state = "datadisk2"
	var/species = SPECIES_HUMAN

/obj/item/weapon/disk/species/Initialize()
	. = ..()
	if(species)
		name = "[species] [initial(name)]"

/obj/item/weapon/disk/species/skrell
	species = SPECIES_SKRELL

/obj/item/weapon/disk/species/unathi
	species = SPECIES_UNATHI

/obj/item/weapon/disk/species/tajaran
	species = SPECIES_TAJ

/obj/item/weapon/disk/species/teshari
	species = SPECIES_TESHARI

// In case of bus, presently.
/obj/item/weapon/disk/species/diona
	species = SPECIES_DIONA

/obj/item/weapon/disk/species/zaddat
	species = SPECIES_ZADDAT

/obj/item/weapon/disk/limb/cenilimicybernetics
	company = "Cenilimi Cybernetics"
