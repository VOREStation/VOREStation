/*
*	Here is where any supply packs
*	related to medical tasks live.
*/


/datum/supply_pack/med
	group = "Medical"

/datum/supply_pack/med/medical
	name = "Basic Medical Supplies"
	desc = "A selection of basic medical supplies, used for treating most simple maladies."
	contains = list(
			/obj/item/storage/firstaid/regular,
			/obj/item/storage/firstaid/fire,
			/obj/item/storage/firstaid/toxin,
			/obj/item/storage/firstaid/o2,
			/obj/item/storage/firstaid/adv,
			/obj/item/reagent_containers/glass/bottle/antitoxin,
			/obj/item/reagent_containers/glass/bottle/inaprovaline,
			/obj/item/reagent_containers/glass/bottle/stoxin,
			/obj/item/storage/box/syringes,
			/obj/item/storage/box/autoinjectors
			)
	cost = 15
	containertype = /obj/structure/closet/crate/zenghu
	containername = "Medical crate"

/datum/supply_pack/med/bloodpack
	name = "BloodPack crate"
	desc = "Three boxes of bloodbags."
	contains = list(/obj/item/storage/box/bloodpacks = 3)
	cost = 10
	containertype = /obj/structure/closet/crate/medical/blood
	containername = "BloodPack crate"

/datum/supply_pack/med/synthplas
	name = "BloodPack (Synthplas) crate"
	desc = "Six containers of synthetic blood replacement."
	contains = list(/obj/item/reagent_containers/blood/synthplas = 6)
	cost = 80
	containertype = /obj/structure/closet/crate/nanomed
	containername = "SynthPlas crate"

/datum/supply_pack/med/bodybag
	name = "Body bag crate"
	desc = "Five boxes of body bags."
	contains = list(/obj/item/storage/box/bodybags = 3)
	cost = 10
	containertype = /obj/structure/closet/crate/nanomed
	containername = "Body bag crate"

/datum/supply_pack/med/cryobag
	name = "Stasis bag crate"
	desc = "Three stasis bags."
	contains = list(/obj/item/bodybag/cryobag = 3)
	cost = 40
	containertype = /obj/structure/closet/crate/nanomed
	containername = "Stasis bag crate"

/datum/supply_pack/med/surgery
	name = "Surgery crate"
	desc = "A set of replacement surgical equipment. Requires Medical access."
	contains = list(
			/obj/item/surgical/cautery,
			/obj/item/surgical/surgicaldrill,
			/obj/item/clothing/mask/breath/medical,
			/obj/item/tank/anesthetic,
			/obj/item/surgical/FixOVein,
			/obj/item/surgical/hemostat,
			/obj/item/surgical/scalpel,
			/obj/item/surgical/bonegel,
			/obj/item/surgical/retractor,
			/obj/item/surgical/bonesetter,
			/obj/item/surgical/circular_saw
			)
	cost = 25
	containertype = /obj/structure/closet/crate/secure/veymed
	containername = "Surgery crate"
	access = access_medical

/datum/supply_pack/med/deathalarm
	name = "Death Alarm crate"
	desc = "Death alarms, a now somewhat-antiquated means of tracking the status of vital personnel. Requires Medical access."
	contains = list(
			/obj/item/storage/box/cdeathalarm_kit,
			/obj/item/storage/box/cdeathalarm_kit
			)
	cost = 40
	containertype = /obj/structure/closet/crate/secure/ward
	containername = "Death Alarm crate"
	access = access_medical

/datum/supply_pack/med/clotting
	name = "Clotting Medicine crate"
	desc = "Zeng Hu-branded \'clotting\' nanomedicine, used to treat internal bleeding without resorting to invasive surgeries. Requires Medical access."
	contains = list(
			/obj/item/storage/firstaid/clotting
			)
	cost = 100
	containertype = /obj/structure/closet/crate/secure/zenghu
	containername = "Clotting Medicine crate"
	access = access_medical

/datum/supply_pack/med/sterile
	name = "Sterile equipment crate"
	desc = "A pack of standard sterile equipment and medical scrubs."
	contains = list(
			/obj/item/clothing/under/rank/medical/scrubs/green = 2,
			/obj/item/clothing/head/surgery/green = 2,
			/obj/item/storage/box/masks,
			/obj/item/storage/box/gloves,
			/obj/item/storage/belt/medical = 3
			)
	cost = 10
	containertype = /obj/structure/closet/crate/veymed
	containername = "Sterile equipment crate"

/datum/supply_pack/med/extragear
	name = "Medical surplus equipment"
	desc = "Assorted surplus medical equipment. Requires Medical access."
	contains = list(
			/obj/item/storage/belt/medical = 3,
			/obj/item/clothing/glasses/hud/health = 3,
			/obj/item/radio/headset/alt/headset_med = 3,
			/obj/item/clothing/suit/storage/hooded/wintercoat/medical = 3
			)
	cost = 10
	containertype = /obj/structure/closet/crate/secure/nanomed
	containername = "Medical surplus equipment"
	access = access_medical

/datum/supply_pack/med/cmogear
	name = "Chief Medical Officer equipment"
	desc = "Standard equipment for the Chief Medical Officer. Requires CMO access."
	contains = list(
			/obj/item/storage/belt/medical,
			/obj/item/radio/headset/heads/cmo,
			/obj/item/clothing/under/rank/chief_medical_officer,
			/obj/item/reagent_containers/hypospray/vial,
			/obj/item/clothing/accessory/stethoscope,
			/obj/item/clothing/glasses/hud/health,
			/obj/item/clothing/suit/storage/toggle/labcoat/cmo,
			/obj/item/clothing/suit/storage/toggle/labcoat/cmoalt,
			/obj/item/clothing/mask/surgical,
			/obj/item/clothing/shoes/white,
			/obj/item/cartridge/cmo,
			/obj/item/clothing/gloves/sterile/latex,
			/obj/item/healthanalyzer,
			/obj/item/flashlight/pen,
			/obj/item/reagent_containers/syringe
			)
	cost = 50
	containertype = /obj/structure/closet/crate/secure/nanomed
	containername = "Chief medical officer equipment"
	access = access_cmo

/datum/supply_pack/med/doctorgear
	name = JOB_MEDICAL_DOCTOR + " equipment"
	desc = "Standard equipment for basic Medical personnel. Requires Medical access."
	contains = list(
			/obj/item/storage/belt/medical,
			/obj/item/radio/headset/headset_med,
			/obj/item/clothing/under/rank/medical,
			/obj/item/clothing/accessory/stethoscope,
			/obj/item/clothing/glasses/hud/health,
			/obj/item/clothing/suit/storage/toggle/labcoat,
			/obj/item/clothing/mask/surgical,
			/obj/item/storage/firstaid/adv,
			/obj/item/clothing/shoes/white,
			/obj/item/cartridge/medical,
			/obj/item/clothing/gloves/sterile/latex,
			/obj/item/healthanalyzer,
			/obj/item/flashlight/pen,
			/obj/item/reagent_containers/syringe
			)
	cost = 20
	containertype = /obj/structure/closet/crate/secure/nanomed
	containername = JOB_MEDICAL_DOCTOR + " equipment"
	access = access_medical_equip

/datum/supply_pack/med/chemistgear
	name = JOB_CHEMIST + " equipment"
	desc = "Standard equipment for Chemists. Requires Chemistry access."
	contains = list(
			/obj/item/storage/box/beakers,
			/obj/item/radio/headset/headset_med,
			/obj/item/storage/box/autoinjectors,
			/obj/item/clothing/under/rank/chemist,
			/obj/item/clothing/glasses/science,
			/obj/item/clothing/suit/storage/toggle/labcoat/chemist,
			/obj/item/clothing/mask/surgical,
			/obj/item/clothing/shoes/white,
			/obj/item/cartridge/chemistry,
			/obj/item/clothing/gloves/sterile/latex,
			/obj/item/reagent_containers/dropper,
			/obj/item/healthanalyzer,
			/obj/item/storage/box/pillbottles,
			/obj/item/reagent_containers/syringe
			)
	cost = 20
	containertype = /obj/structure/closet/crate/secure/nanomed
	containername = JOB_CHEMIST + " equipment"
	access = access_chemistry

/datum/supply_pack/med/paramedicgear
	name = JOB_PARAMEDIC + " equipment"
	desc = "Standard equipment for Paramedics and EMTs. Requires Medical Equipment access."
	contains = list(
			/obj/item/storage/belt/medical/emt,
			/obj/item/radio/headset/headset_med,
			/obj/item/clothing/under/rank/medical/scrubs/black,
			/obj/item/clothing/accessory/armband/medblue,
			/obj/item/clothing/glasses/hud/health,
			/obj/item/clothing/suit/storage/toggle/labcoat/emt,
			/obj/item/clothing/under/rank/medical/paramedic,
			/obj/item/clothing/suit/storage/toggle/fr_jacket,
			/obj/item/clothing/mask/gas,
			/obj/item/clothing/under/rank/medical/paramedic_alt,
			/obj/item/clothing/accessory/stethoscope,
			/obj/item/storage/firstaid/adv,
			/obj/item/clothing/shoes/boots/jackboots,
			/obj/item/clothing/gloves/sterile/latex,
			/obj/item/healthanalyzer,
			/obj/item/cartridge/medical,
			/obj/item/flashlight/pen,
			/obj/item/reagent_containers/syringe,
			/obj/item/clothing/accessory/storage/white_vest
			)
	cost = 20
	containertype = /obj/structure/closet/crate/secure/nanomed
	containername = JOB_PARAMEDIC + " equipment"
	access = access_medical_equip

/datum/supply_pack/med/psychiatristgear
	name = JOB_PSYCHIATRIST + " equipment"
	desc = "Standard equipment for Psychiatrists. Requires Psychiatry access."
	contains = list(
			/obj/item/clothing/under/rank/psych,
			/obj/item/radio/headset/headset_med,
			/obj/item/clothing/under/rank/psych/turtleneck,
			/obj/item/clothing/shoes/laceup,
			/obj/item/clothing/suit/storage/toggle/labcoat,
			/obj/item/clothing/shoes/white,
			/obj/item/clipboard,
			/obj/item/folder/white,
			/obj/item/pen,
			/obj/item/cartridge/medical
			)
	cost = 20
	containertype = /obj/structure/closet/crate/secure/nanomed
	containername = JOB_PSYCHIATRIST + " equipment"
	access = access_psychiatrist

/datum/supply_pack/med/medicalscrubs
	name = "Medical scrubs"
	desc = "Plenty of extra surgical scrubs. Requires Medical Equipment access."
	contains = list(
			/obj/item/clothing/shoes/white = 3,
			/obj/item/clothing/under/rank/medical/scrubs = 3,
			/obj/item/clothing/under/rank/medical/scrubs/green = 3,
			/obj/item/clothing/under/rank/medical/scrubs/purple = 3,
			/obj/item/clothing/under/rank/medical/scrubs/black = 3,
			/obj/item/clothing/head/surgery = 3,
			/obj/item/clothing/head/surgery/purple = 3,
			/obj/item/clothing/head/surgery/blue = 3,
			/obj/item/clothing/head/surgery/green = 3,
			/obj/item/clothing/head/surgery/black = 3,
			/obj/item/storage/box/masks,
			/obj/item/storage/box/gloves
			)
	cost = 10
	containertype = /obj/structure/closet/crate/secure/nanomed
	containername = "Medical scrubs crate"
	access = access_medical_equip

/datum/supply_pack/med/autopsy
	name = "Autopsy equipment"
	desc = "Supplies for conducting thorough autopsies. Requires Morgue access."
	contains = list(
			/obj/item/folder/white,
			/obj/item/camera,
			/obj/item/camera_film = 2,
			/obj/item/autopsy_scanner,
			/obj/item/surgical/scalpel,
			/obj/item/storage/box/masks,
			/obj/item/storage/box/gloves,
			/obj/item/pen
			)
	cost = 20
	containertype = /obj/structure/closet/crate/secure/veymed
	containername = "Autopsy equipment crate"
	access = access_morgue

/datum/supply_pack/med/medicaluniforms
	name = "Medical uniforms"
	desc = "A set of standard Medical uniforms. Requires Medical Equipment access."
	contains = list(
			/obj/item/clothing/shoes/white = 3,
			/obj/item/clothing/under/rank/chief_medical_officer,
			/obj/item/clothing/under/rank/geneticist,
			/obj/item/clothing/under/rank/virologist,
			/obj/item/clothing/under/rank/nursesuit,
			/obj/item/clothing/under/rank/nurse,
			/obj/item/clothing/under/rank/orderly,
			/obj/item/clothing/under/rank/medical = 3,
			/obj/item/clothing/under/rank/medical/paramedic = 3,
			/obj/item/clothing/suit/storage/toggle/labcoat = 3,
			/obj/item/clothing/suit/storage/toggle/labcoat/cmo,
			/obj/item/clothing/suit/storage/toggle/labcoat/emt,
			/obj/item/clothing/suit/storage/toggle/labcoat/cmoalt,
			/obj/item/clothing/suit/storage/toggle/labcoat/genetics,
			/obj/item/clothing/suit/storage/toggle/labcoat/virologist,
			/obj/item/clothing/suit/storage/toggle/labcoat/chemist,
			/obj/item/storage/box/masks,
			/obj/item/storage/box/gloves
			)
	cost = 10
	containertype = /obj/structure/closet/crate/secure/nanomed
	containername = "Medical uniform crate"
	access = access_medical_equip

/datum/supply_pack/med/medicalbiosuits
	name = "Medical biohazard gear"
	desc = "Several sets of Medical Biohazard suits. Requires Medical Equipment access."
	contains = list(
			/obj/item/clothing/head/bio_hood/scientist = 3,
			/obj/item/clothing/suit/bio_suit/scientist = 3,
			/obj/item/clothing/suit/bio_suit/cmo,
			/obj/item/clothing/head/bio_hood/cmo,
			/obj/item/clothing/shoes/white = 4,
			/obj/item/clothing/mask/gas = 4,
			/obj/item/tank/oxygen = 4,
			/obj/item/storage/box/masks,
			/obj/item/storage/box/gloves
			)
	cost = 50
	containertype = /obj/structure/closet/crate/secure/nanomed
	containername = "Medical biohazard equipment"
	access = access_medical_equip

/datum/supply_pack/med/portablefreezers
	name = "Portable freezers crate"
	desc = "Several portable freezers, for safely transporting organs and other temperature-sensitive objects. Requires Medical Equipment access."
	contains = list(/obj/item/storage/box/freezer = 7)
	cost = 25
	containertype = /obj/structure/closet/crate/secure/veymed
	containername = "Portable freezers"
	access = access_medical_equip

/datum/supply_pack/med/virus
	name = "Virus culture crate"
	desc = "Glass bottles with viral cultures. HANDLE WITH CARE. Requires Chief Medical Officer access."
	contains = list(/obj/item/reagent_containers/glass/beaker/vial/culture/cold = 1, /obj/item/reagent_containers/glass/beaker/vial/culture/flu = 1)
	cost = 25
	containertype = /obj/structure/closet/crate/secure/zenghu
	containername = "Virus culture crate"
	access = access_cmo

/datum/supply_pack/med/defib
	name = "Defibrillator crate"
	desc = "A pair of defibrillators."
	contains = list(/obj/item/defib_kit = 2)
	cost = 30
	containertype = /obj/structure/closet/crate/veymed
	containername = "Defibrillator crate"

/datum/supply_pack/med/distillery
	name = "Chemical distiller crate"
	desc = "A portable reagent distillery, for advanced chemistry. Standalone model."
	contains = list(/obj/machinery/portable_atmospherics/powered/reagent_distillery = 1)
	cost = 50
	containertype = /obj/structure/closet/crate/large/nanotrasen
	containername = "Chemical distiller crate"

/datum/supply_pack/med/advdistillery
	name = "Industrial Chemical distiller crate"
	desc = "A portable industrial reagent distillery, for advanced chemistry. Requires atmospherics experience and equipment to set up."
	contains = list(/obj/machinery/portable_atmospherics/powered/reagent_distillery/industrial = 1)
	cost = 150
	containertype = /obj/structure/closet/crate/large/xion
	containername = "Industrial Chemical distiller crate"

/datum/supply_pack/med/oxypump
	name = "Oxygen pump crate"
	desc = "A mobile oxygen pump."
	contains = list(/obj/machinery/oxygen_pump/mobile = 1)
	cost = 125
	containertype = /obj/structure/closet/crate/large/xion
	containername = "Oxygen pump crate"

/datum/supply_pack/med/anestheticpump
	name = "Anesthetic pump crate"
	desc = "A mobile anaesthetic pump."
	contains = list(/obj/machinery/oxygen_pump/mobile/anesthetic = 1)
	cost = 130
	containertype = /obj/structure/closet/crate/large/nanotrasen
	containername = "Anesthetic pump crate"

/datum/supply_pack/med/stablepump
	name = "Portable stabilizer crate"
	desc = "A portable stabilizer, for conducting sensitive operations such as heart transplants."
	contains = list(/obj/machinery/oxygen_pump/mobile/stabilizer = 1)
	cost = 175
	containertype = /obj/structure/closet/crate/large/nanotrasen
	containername = "Portable stabilizer crate"

/datum/supply_pack/med/virologybiosuits
	name = "Virology biohazard gear"
	desc = "Three virology biohazard suits plus associated equipment. Requires Medical Equipment access."
	contains = list(
			/obj/item/clothing/suit/bio_suit/virology = 3,
			/obj/item/clothing/head/bio_hood/virology = 3,
			/obj/item/clothing/mask/gas = 3,
			/obj/item/tank/oxygen = 3,
			/obj/item/storage/box/masks,
			/obj/item/storage/box/gloves
			)
	cost = 40
	containertype = /obj/structure/closet/crate/secure
	containername = "Virology biohazard equipment"
	access = access_medical_equip

/datum/supply_pack/med/disease
	name = "Experimental Disease crate"
	desc = "An experimental disease. Contains a multitude of symptoms."
	contains = list(
		/obj/item/reagent_containers/glass/beaker/vial/culture/random_virus = 1
	)
	cost = 60
	containertype = /obj/structure/closet/crate/freezer
	access = access_medical_equip

/datum/supply_pack/med/disease_minor
	name = "Minor Experimental Disease crate"
	desc = "An experimental disease. Contains a weakened, untested viral culture."
	contains = list(
		/obj/item/reagent_containers/glass/beaker/vial/culture/random_virus/minor = 1
	)
	cost = 40
	containertype = /obj/structure/closet/crate/freezer
	access = access_medical_equip

/datum/supply_pack/med/compactdefib
	name = "Compact Defibrillator crate"
	desc = "A compact defibrillator. Requires Medical Equipment access."
	contains = list(/obj/item/defib_kit/compact = 1)
	cost = 90
	containertype = /obj/structure/closet/crate/secure
	containername = "Compact Defibrillator crate"
	access = access_medical_equip
