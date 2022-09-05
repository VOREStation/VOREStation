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
	display_name = "glasses, prescription"
	path = /obj/item/clothing/glasses/regular

/datum/gear/eyes/glasses/green
	display_name = "glasses, green"
	path = /obj/item/clothing/glasses/gglasses

/datum/gear/eyes/glasses/prescriptionhipster
	display_name = "glasses, hipster"
	path = /obj/item/clothing/glasses/regular/hipster

/datum/gear/eyes/glasses/threedglasses
	display_name = "Glasses, 3D"
	path = /obj/item/clothing/glasses/threedglasses

/datum/gear/eyes/glasses/monocle
	display_name = "monocle"
	path = /obj/item/clothing/glasses/monocle

/datum/gear/eyes/goggles
	display_name = "goggles, plain"
	path = /obj/item/clothing/glasses/goggles

/datum/gear/eyes/goggles/scanning
	display_name = "goggles, scanning"
	path = /obj/item/clothing/glasses/regular/scanners

/datum/gear/eyes/goggles/science
	display_name = "goggles, science"
	path = /obj/item/clothing/glasses/science

/datum/gear/eyes/security
	display_name = "security HUD (Security)"
	path = /obj/item/clothing/glasses/hud/security
	allowed_roles = list("Security Officer","Head of Security","Warden", "Detective")

/datum/gear/eyes/security/prescriptionsec
	display_name = "security HUD, prescription (Security)"
	path = /obj/item/clothing/glasses/hud/security/prescription

/datum/gear/eyes/security/sunglasshud
	display_name = "security HUD, sunglasses (Security)"
	path = /obj/item/clothing/glasses/sunglasses/sechud

/datum/gear/eyes/security/aviator
	display_name = "security HUD Aviators (Security)"
	path = /obj/item/clothing/glasses/sunglasses/sechud/aviator

/datum/gear/eyes/security/aviator/prescription
	display_name = "security HUD Aviators, prescription (Security)"
	path = /obj/item/clothing/glasses/sunglasses/sechud/aviator/prescription

/datum/gear/eyes/medical
	display_name = "medical HUD (Medical)"
	path = /obj/item/clothing/glasses/hud/health
	allowed_roles = list("Medical Doctor","Chief Medical Officer","Chemist","Paramedic","Geneticist", "Psychiatrist", "Search and Rescue")

/datum/gear/eyes/medical/prescriptionmed
	display_name = "medical HUD, prescription (Medical)"
	path = /obj/item/clothing/glasses/hud/health/prescription

/datum/gear/eyes/medical/aviator
	display_name = "medical HUD Aviators (Medical)"
	path = /obj/item/clothing/glasses/hud/health/aviator

/datum/gear/eyes/medical/aviator/prescription
	display_name = "medical HUD Aviators, prescription (Medical)"
	path = /obj/item/clothing/glasses/hud/health/aviator/prescription

/datum/gear/eyes/meson
	display_name = "optical meson scanners (Engineering, Science, Mining)"
	path = /obj/item/clothing/glasses/meson
	allowed_roles = list("Engineer","Chief Engineer","Atmospheric Technician", "Scientist", "Research Director", "Shaft Miner")

/datum/gear/eyes/meson/prescription
	display_name = "optical meson scanners, prescription (Engineering, Science, Mining)"
	path = /obj/item/clothing/glasses/meson/prescription

/datum/gear/eyes/material
	display_name = "optical material scanners (Mining)"
	path = /obj/item/clothing/glasses/material
	allowed_roles = list("Shaft Miner","Quartermaster")

/datum/gear/eyes/material/prescription
	display_name = "optical material scanners, prescription (Mining)"
	path = /obj/item/clothing/glasses/material/prescription

/datum/gear/eyes/meson/aviator
	display_name = "optical meson aviators (Engineering, Science, Mining)"
	path = /obj/item/clothing/glasses/meson/aviator

/datum/gear/eyes/meson/aviator/prescription
	display_name = "optical meson aviators, prescription (Engineering, Science, Mining)"
	path = /obj/item/clothing/glasses/meson/aviator/prescription

/datum/gear/eyes/glasses/fakesun
	display_name = "sunglasses, stylish"
	path = /obj/item/clothing/glasses/fakesunglasses

/datum/gear/eyes/glasses/fakeaviator
	display_name = "sunglasses, stylish aviators"
	path = /obj/item/clothing/glasses/fakesunglasses/aviator

/datum/gear/eyes/sun
	display_name = "sunglasses (Security/Command)"
	path = /obj/item/clothing/glasses/sunglasses
	allowed_roles = list("Security Officer","Head of Security","Warden","Site Manager","Head of Personnel","Quartermaster","Internal Affairs Agent","Detective")

/datum/gear/eyes/sun/shades
	display_name = "sunglasses, fat (Security/Command)"
	path = /obj/item/clothing/glasses/sunglasses/big

/datum/gear/eyes/sun/aviators
	display_name = "sunglasses, aviators (Security/Command)"
	path = /obj/item/clothing/glasses/sunglasses/aviator

/datum/gear/eyes/sun/prescriptionsun
	display_name = "sunglasses, presciption (Security/Command)"
	path = /obj/item/clothing/glasses/sunglasses/prescription

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
<<<<<<< HEAD
	display_name = "Glasses, prescription thin frame"
=======
	display_name = "glasses, prescription thin frame"
>>>>>>> db9d6679502... Merge pull request #8695 from Frenjo/loadout-tweaks
	path = /obj/item/clothing/glasses/regular/thin
