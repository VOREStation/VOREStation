// Eyes
/datum/gear/eyes
	display_name = "eyepatch"
	path = /obj/item/clothing/glasses/eyepatch
	slot = slot_glasses
	sort_category = "Glasses and Eyewear"

/datum/gear/eyes/eyepatchwhite
	display_name = "eyepatch (recolorable)"
	path = /obj/item/clothing/glasses/eyepatchwhite
	slot = slot_glasses
	sort_category = "Glasses and Eyewear"

/datum/gear/eyes/eyepatchwhite/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/eyes/blindfold
	display_name = "blindfold"
	path = /obj/item/clothing/glasses/sunglasses/blindfold

/datum/gear/eyes/whiteblindfold //I may have lost my sight, but at least these folks can see my RAINBOW BLINDFOLD
	display_name = "blindfold, white (recolorable)"
	path = /obj/item/clothing/glasses/sunglasses/blindfold/whiteblindfold

/datum/gear/eyes/whiteblindfold/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/eyes/thinblindfold
	display_name = "blindfold, thin white (recolorable)"
	path = /obj/item/clothing/glasses/sunglasses/thinblindfold

/datum/gear/eyes/thinblindfold/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/eyes/glasses
	display_name = "Glasses, prescription"
	path = /obj/item/clothing/glasses/regular

/datum/gear/eyes/glasses/green
	display_name = "Glasses, green"
	path = /obj/item/clothing/glasses/gglasses

/datum/gear/eyes/glasses/prescriptionhipster
	display_name = "Glasses, hipster"
	path = /obj/item/clothing/glasses/regular/hipster

/datum/gear/eyes/glasses/threedglasses
	display_name = "Glasses, 3D"
	path = /obj/item/clothing/glasses/threedglasses

/datum/gear/eyes/glasses/monocle
	display_name = "monocle"
	path = /obj/item/clothing/glasses/monocle

/datum/gear/eyes/goggles
	display_name = "plain goggles"
	path = /obj/item/clothing/glasses/goggles

/datum/gear/eyes/goggles/scanning
	display_name = "scanning goggles"
	path = /obj/item/clothing/glasses/regular/scanners

/datum/gear/eyes/goggles/science
	display_name = "Science Goggles"
	path = /obj/item/clothing/glasses/science

/datum/gear/eyes/security
	display_name = "Security HUD selector"
	description = "Select from a range of Security HUD eyepieces that can display the ID status and security records of people in line of sight."
	path = /obj/item/clothing/glasses/hud/security
	allowed_roles = list(JOB_SECURITY_OFFICER,JOB_HEAD_OF_SECURITY,JOB_WARDEN, JOB_DETECTIVE)

/datum/gear/eyes/security/New()
	..()
	var/list/selector_uniforms = list(
		"standard security HUD"=/obj/item/clothing/glasses/hud/security,
		"prescription security HUD"=/obj/item/clothing/glasses/hud/security/prescription,
		"security HUD sunglasses"=/obj/item/clothing/glasses/sunglasses/sechud,
		"security HUD aviators"=/obj/item/clothing/glasses/sunglasses/sechud/aviator,
		"security HUD aviators (prescription)"=/obj/item/clothing/glasses/sunglasses/sechud/aviator/prescription,
		"security HUD eyepatch, mark I"=/obj/item/clothing/glasses/hud/security/eyepatch,
		"security HUD eyepatch, mark II"=/obj/item/clothing/glasses/hud/security/eyepatch2,
		"tactical security visor"=/obj/item/clothing/glasses/sunglasses/sechud/tactical_sec_vis
	)
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(selector_uniforms))

/datum/gear/eyes/medical
	display_name = "Medical HUD selector"
	description = "Select from a range of Medical HUD eyepieces that can display the health status of people in line of sight."
	path = /obj/item/clothing/glasses/hud/health
	allowed_roles = list("Medical Doctor","Chief Medical Officer","Chemist","Paramedic","Geneticist", "Psychiatrist")

/datum/gear/eyes/medical/New()
	..()
	var/list/selector_uniforms = list(
		"standard medical HUD"=/obj/item/clothing/glasses/hud/health,
		"prescription medical HUD"=/obj/item/clothing/glasses/hud/health/prescription,
		"medical HUD aviators"=/obj/item/clothing/glasses/hud/health/aviator,
		"medical HUD aviators (prescription)"=/obj/item/clothing/glasses/hud/health/aviator/prescription,
		"medical HUD eyepatch"=/obj/item/clothing/glasses/hud/health/eyepatch
	)
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(selector_uniforms))

/datum/gear/eyes/janitor
	display_name = "Contaminant HUD"
	path = /obj/item/clothing/glasses/hud/janitor
	allowed_roles = list("Janitor")

/datum/gear/eyes/janitor/prescriptionjan
	display_name = "Contaminant HUD, prescription"
	path = /obj/item/clothing/glasses/hud/janitor/prescription

/datum/gear/eyes/meson
	display_name = "Optical Meson Scanners selection"
	description = "Select from a range of meson-projection eyewear. Note: not all of these items are atmospherically sealed."
	path = /obj/item/clothing/glasses/meson
	allowed_roles = list("Engineer","Chief Engineer","Atmospheric Technician", "Scientist", "Research Director")

/datum/gear/eyes/meson/New()
	..()
	var/list/selector_uniforms = list(
		"standard meson goggles"=/obj/item/clothing/glasses/meson,
		"prescription meson goggles"=/obj/item/clothing/glasses/meson/prescription,
		"meson retinal projector"=/obj/item/clothing/glasses/omnihud/eng/meson,
		"meson aviator glasses"=/obj/item/clothing/glasses/meson/aviator,
		"meson aviator glasses (prescription)"=/obj/item/clothing/glasses/meson/aviator/prescription
	)
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(selector_uniforms))

/datum/gear/eyes/material
	display_name = "Optical Material Scanners"
	path = /obj/item/clothing/glasses/material
	allowed_roles = list(JOB_SHAFT_MINER,"Quartermaster")

/datum/gear/eyes/glasses/fakesun
	display_name = "Sunglasses, stylish"
	path = /obj/item/clothing/glasses/fakesunglasses

/datum/gear/eyes/glasses/fakeaviator
	display_name = "Sunglasses, stylish aviators"
	path = /obj/item/clothing/glasses/fakesunglasses/aviator

/datum/gear/eyes/sun
	display_name = "functional sunglasses selector"
	description = "Select from a range of polarized sunglasses that can block flashes whilst still looking classy."
	path = /obj/item/clothing/glasses/sunglasses
	allowed_roles = list(JOB_SECURITY_OFFICER,JOB_HEAD_OF_SECURITY,JOB_WARDEN,JOB_SITE_MANAGER,JOB_HEAD_OF_PERSONNEL,"Quartermaster","Internal Affairs Agent",JOB_DETECTIVE)

/datum/gear/eyes/sun/New()
	..()
	var/list/selector_uniforms = list(
		"sunglasses"=/obj/item/clothing/glasses/sunglasses,
		"extra large sunglasses"=/obj/item/clothing/glasses/sunglasses/big,
		"aviators"=/obj/item/clothing/glasses/sunglasses/aviator,
		"prescription sunglasses"=/obj/item/clothing/glasses/sunglasses/prescription
	)
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(selector_uniforms))

/datum/gear/eyes/circuitry
	display_name = "goggles, circuitry (empty)"
	path = /obj/item/clothing/glasses/circuitry

/datum/gear/eyes/glasses/rimless
	display_name = "glasses, rimless"
	path = /obj/item/clothing/glasses/rimless

/datum/gear/eyes/glasses/prescriptionrimless
	display_name = "glasses, prescription rimless"
	path = /obj/item/clothing/glasses/regular/rimless

/datum/gear/eyes/glasses/thin
	display_name = "glasses, thin frame"
	path = /obj/item/clothing/glasses/thin

/datum/gear/eyes/glasses/prescriptionthin
	display_name = "glasses, prescription thin frame"
	path = /obj/item/clothing/glasses/regular/thin
