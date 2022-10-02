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
<<<<<<< HEAD
	display_name = "Glasses, prescription"
=======
	display_name = "glasses, prescription selection"
>>>>>>> 3748572e9e7... Consolidates Loadout Lists (#8714)
	path = /obj/item/clothing/glasses/regular
	cost = 1

<<<<<<< HEAD
/datum/gear/eyes/glasses/green
	display_name = "Glasses, green"
=======
/datum/gear/eyes/glasses/New()
	..()
	var/glassestype = list()
	glassestype["prescription glasses, standard"] = /obj/item/clothing/glasses/regular
	glassestype["prescription glasses, hipster"] = /obj/item/clothing/glasses/regular/hipster
	glassestype["prescription glasses, rimless"] = /obj/item/clothing/glasses/regular/rimless
	glassestype["prescription glasses, thin frame"] = /obj/item/clothing/glasses/regular/thin
	gear_tweaks += new/datum/gear_tweak/path(glassestype)

/datum/gear/eyes/glassesfake
	display_name = "glasses, non-prescription selection"
>>>>>>> 3748572e9e7... Consolidates Loadout Lists (#8714)
	path = /obj/item/clothing/glasses/gglasses
	cost = 1

<<<<<<< HEAD
/datum/gear/eyes/glasses/prescriptionhipster
	display_name = "Glasses, hipster"
	path = /obj/item/clothing/glasses/regular/hipster
=======
/datum/gear/eyes/glassesfake/New()
	..()
	var/glassestype = list()
	glassestype["glasses, green"] = /obj/item/clothing/glasses/gglasses
	glassestype["glasses, rimless"] = /obj/item/clothing/glasses/rimless
	glassestype["glasses, thin frame"] = /obj/item/clothing/glasses/thin
	gear_tweaks += new/datum/gear_tweak/path(glassestype)
>>>>>>> 3748572e9e7... Consolidates Loadout Lists (#8714)

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
<<<<<<< HEAD
	display_name = "Security HUD (Security)"
	path = /obj/item/clothing/glasses/hud/security
	allowed_roles = list("Security Officer","Head of Security","Warden", "Detective")

/datum/gear/eyes/security/prescriptionsec
	display_name = "Security HUD, prescription (Security)"
	path = /obj/item/clothing/glasses/hud/security/prescription

/datum/gear/eyes/security/sunglasshud
	display_name = "Security HUD, sunglasses (Security)"
	path = /obj/item/clothing/glasses/sunglasses/sechud

/datum/gear/eyes/security/aviator
	display_name = "Security HUD Aviators (Security)"
	path = /obj/item/clothing/glasses/sunglasses/sechud/aviator

/datum/gear/eyes/security/aviator/prescription
	display_name = "Security HUD Aviators, prescription (Security)"
	path = /obj/item/clothing/glasses/sunglasses/sechud/aviator/prescription

/datum/gear/eyes/medical
	display_name = "Medical HUD (Medical)"
	path = /obj/item/clothing/glasses/hud/health
	allowed_roles = list("Medical Doctor","Chief Medical Officer","Chemist","Paramedic","Geneticist", "Psychiatrist", "Search and Rescue")

/datum/gear/eyes/medical/prescriptionmed
	display_name = "Medical HUD, prescription (Medical)"
	path = /obj/item/clothing/glasses/hud/health/prescription

/datum/gear/eyes/medical/aviator
	display_name = "Medical HUD Aviators (Medical)"
	path = /obj/item/clothing/glasses/hud/health/aviator

/datum/gear/eyes/medical/aviator/prescription
	display_name = "Medical HUD Aviators, prescription (Medical)"
	path = /obj/item/clothing/glasses/hud/health/aviator/prescription

/datum/gear/eyes/meson
	display_name = "Optical Meson Scanners (Engineering, Science, Mining)"
=======
	display_name = "security HUD selection (Security)"
	path = /obj/item/clothing/glasses/hud/security
	allowed_roles = list("Security Officer","Head of Security","Warden", "Detective")

/datum/gear/eyes/security/New()
	..()
	var/hudtype = list()
	hudtype["security hud, standard"] = /obj/item/clothing/glasses/hud/security
	hudtype["security hud, standard prescription"] = /obj/item/clothing/glasses/hud/security/prescription
	hudtype["security hud, sunglasses"] = /obj/item/clothing/glasses/sunglasses/sechud
	hudtype["security hud, sunglasses prescription"] = /obj/item/clothing/glasses/sunglasses/sechud/prescription
	hudtype["security hud, aviators"] = /obj/item/clothing/glasses/sunglasses/sechud/aviator
	hudtype["security hud, aviators prescription"] = /obj/item/clothing/glasses/sunglasses/sechud/aviator/prescription

	gear_tweaks += new/datum/gear_tweak/path(hudtype)

/datum/gear/eyes/medical
	display_name = "medical HUD selection (Medical)"
	path = /obj/item/clothing/glasses/hud/health
	allowed_roles = list("Medical Doctor","Chief Medical Officer","Chemist","Paramedic","Geneticist", "Psychiatrist", "Search and Rescue")

/datum/gear/eyes/medical/New()
	..()
	var/list/huds = list()
	for(var/hud in typesof(/obj/item/clothing/glasses/hud/health))
		var/obj/item/clothing/glasses/hud/hud_type = hud
		huds[initial(hud_type.name)] = hud_type
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(huds))

/datum/gear/eyes/meson
	display_name = "optical meson scanners selection (Engineering, Science, Mining)"
>>>>>>> 3748572e9e7... Consolidates Loadout Lists (#8714)
	path = /obj/item/clothing/glasses/meson
	allowed_roles = list("Engineer","Chief Engineer","Atmospheric Technician", "Scientist", "Research Director", "Shaft Miner")

<<<<<<< HEAD
/datum/gear/eyes/meson/prescription
	display_name = "Optical Meson Scanners, prescription (Engineering, Science, Mining)"
	path = /obj/item/clothing/glasses/meson/prescription
=======
/datum/gear/eyes/meson/New()
	..()
	var/list/mesons = list()
	for(var/meson in typesof(/obj/item/clothing/glasses/meson))
		var/obj/item/clothing/glasses/meson_type = meson
		mesons[initial(meson_type.name)] = meson_type
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(mesons))
>>>>>>> 3748572e9e7... Consolidates Loadout Lists (#8714)

/datum/gear/eyes/material
	display_name = "Optical Material Scanners (Mining)"
	path = /obj/item/clothing/glasses/material
	allowed_roles = list("Shaft Miner","Quartermaster")

/datum/gear/eyes/material/prescription
	display_name = "Prescription Optical Material Scanners (Mining)"
	path = /obj/item/clothing/glasses/material/prescription

<<<<<<< HEAD
/datum/gear/eyes/meson/aviator
	display_name = "Optical Meson Aviators, (Engineering, Science, Mining)"
	path = /obj/item/clothing/glasses/meson/aviator

/datum/gear/eyes/meson/aviator/prescription
	display_name = "Optical Meson Aviators, prescription (Engineering, Science, Mining)"
	path = /obj/item/clothing/glasses/meson/aviator/prescription
=======
>>>>>>> 3748572e9e7... Consolidates Loadout Lists (#8714)

/datum/gear/eyes/glasses/fakesun
	display_name = "Sunglasses, stylish"
	path = /obj/item/clothing/glasses/fakesunglasses

/datum/gear/eyes/glasses/fakeaviator
	display_name = "Sunglasses, stylish aviators"
	path = /obj/item/clothing/glasses/fakesunglasses/aviator

/datum/gear/eyes/sun
<<<<<<< HEAD
	display_name = "Sunglasses (Security/Command)"
	path = /obj/item/clothing/glasses/sunglasses
	allowed_roles = list("Security Officer","Head of Security","Warden","Site Manager","Head of Personnel","Quartermaster","Internal Affairs Agent","Detective")

/datum/gear/eyes/sun/shades
	display_name = "Sunglasses, fat (Security/Command)"
	path = /obj/item/clothing/glasses/sunglasses/big

/datum/gear/eyes/sun/aviators
	display_name = "Sunglasses, aviators (Security/Command)"
	path = /obj/item/clothing/glasses/sunglasses/aviator
=======
	display_name = "sunglasses, protective selection (Security/Command)"
	path = /obj/item/clothing/glasses/sunglasses
	allowed_roles = list("Security Officer","Head of Security","Warden","Site Manager","Head of Personnel","Quartermaster","Internal Affairs Agent","Detective")

/datum/gear/eyes/sun/New()
	..()
	var/hudtype = list()
	hudtype["sunglasses, standard"] = /obj/item/clothing/glasses/sunglasses
	hudtype["sunglasses, big"] = /obj/item/clothing/glasses/sunglasses/big
	hudtype["sunglasses, aviators"] = /obj/item/clothing/glasses/sunglasses/aviator
	hudtype["sunglasses, prescription"] = /obj/item/clothing/glasses/sunglasses/prescription
>>>>>>> 3748572e9e7... Consolidates Loadout Lists (#8714)

	gear_tweaks += new/datum/gear_tweak/path(hudtype)

/datum/gear/eyes/circuitry
	display_name = "goggles, circuitry (empty)"
	path = /obj/item/clothing/glasses/circuitry
<<<<<<< HEAD

/datum/gear/eyes/glasses/rimless
	display_name = "Glasses, rimless"
	path = /obj/item/clothing/glasses/rimless

/datum/gear/eyes/glasses/prescriptionrimless
	display_name = "Glasses, prescription rimless"
	path = /obj/item/clothing/glasses/regular/rimless

/datum/gear/eyes/glasses/thin
	display_name = "Glasses, thin frame"
	path = /obj/item/clothing/glasses/thin

/datum/gear/eyes/glasses/prescriptionthin
	display_name = "Glasses, prescription thin frame"
	path = /obj/item/clothing/glasses/regular/thin
=======
>>>>>>> 3748572e9e7... Consolidates Loadout Lists (#8714)
