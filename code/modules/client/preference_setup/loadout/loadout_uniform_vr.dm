/datum/gear/uniform/suit/permit
	display_name = "nudity permit"
	path = /obj/item/clothing/under/permit

/datum/gear/uniform/suit/natureist_talisman
	display_name = "naturist talisman"
	path = /obj/item/clothing/under/permit/natureist_talisman

//Polaris overrides
/datum/gear/uniform/solgov/pt/sifguard
	display_name = "pt uniform, planetside sec"
	path = /obj/item/clothing/under/solgov/pt/sifguard

/datum/gear/uniform/job_skirt/sci
	allowed_roles = list("Research Director","Scientist", "Xenobiologist", "Xenobotanist")

/datum/gear/uniform/job_turtle/science
	allowed_roles = list("Research Director", "Scientist", "Roboticist", "Xenobiologist", "Xenobotanist")

/datum/gear/uniform/job_turtle/medical
	display_name = "turtleneck, medical"
	path = /obj/item/clothing/under/rank/medical/turtleneck
	allowed_roles = list("Chief Medical Officer", "Paramedic", "Medical Doctor", "Psychiatrist", "Field Medic", "Chemist")

//KHI Uniforms
/datum/gear/uniform/job_khi/cmd
	display_name = "khi uniform, cmd"
	path = /obj/item/clothing/under/rank/khi/cmd
	allowed_roles = list("Head of Security","Site Manager","Head of Personnel","Chief Engineer","Research Director","Chief Medical Officer")

/datum/gear/uniform/job_khi/sec
	display_name = "khi uniform, sec"
	path = /obj/item/clothing/under/rank/khi/sec
	allowed_roles = list("Head of Security", "Warden", "Detective", "Security Officer")

/datum/gear/uniform/job_khi/med
	display_name = "khi uniform, med"
	path = /obj/item/clothing/under/rank/khi/med
	allowed_roles = list("Chief Medical Officer","Medical Doctor","Chemist","Paramedic","Geneticist","Field Medic","Psychiatrist")

/datum/gear/uniform/job_khi/eng
	display_name = "khi uniform, eng"
	path = /obj/item/clothing/under/rank/khi/eng
	allowed_roles = list("Chief Engineer","Atmospheric Technician","Engineer")

/datum/gear/uniform/job_khi/sci
	display_name = "khi uniform, sci"
	path = /obj/item/clothing/under/rank/khi/sci
	allowed_roles = list("Research Director", "Scientist", "Roboticist", "Xenobiologist", "Xenobotanist")

/datum/gear/uniform/job_khi/crg
	display_name = "khi uniform, cargo"
	path = /obj/item/clothing/under/rank/khi/crg
	allowed_roles = list("Quartermaster", "Cargo Technician", "Shaft Miner")

/datum/gear/uniform/job_khi/civ
	display_name = "khi uniform, civ"
	path = /obj/item/clothing/under/rank/khi/civ

//Federation jackets
/datum/gear/suit/job_fed/sec
	display_name = "fed uniform, sec"
	path = /obj/item/clothing/suit/storage/fluff/fedcoat
	allowed_roles = list("Head of Security", "Warden", "Detective", "Security Officer")

/datum/gear/suit/job_fed/medsci
	display_name = "fed uniform, med/sci"
	path = /obj/item/clothing/suit/storage/fluff/fedcoat/fedblue
	allowed_roles = list("Chief Medical Officer","Medical Doctor","Chemist","Paramedic","Geneticist","Research Director","Scientist", "Roboticist", "Xenobiologist","Xenobotanist","Field Medic")

/datum/gear/suit/job_fed/eng
	display_name = "fed uniform, eng"
	path = /obj/item/clothing/suit/storage/fluff/fedcoat/fedeng
	allowed_roles = list("Chief Engineer","Atmospheric Technician","Engineer")

// Trekie things
//TOS
/datum/gear/uniform/job_trek/cmd/tos
	display_name = "TOS uniform, cmd"
	path = /obj/item/clothing/under/rank/trek/command
	allowed_roles = list("Head of Security","Site Manager","Head of Personnel","Chief Engineer","Research Director","Chief Medical Officer")

/datum/gear/uniform/job_trek/medsci/tos
	display_name = "TOS uniform, med/sci"
	path = /obj/item/clothing/under/rank/trek/medsci
	allowed_roles = list("Chief Medical Officer","Medical Doctor","Chemist","Paramedic","Geneticist","Research Director","Scientist", "Roboticist", "Xenobiologist", "Xenobotanist", "Field Medic")

/datum/gear/uniform/job_trek/eng/tos
	display_name = "TOS uniform, eng/sec"
	path = /obj/item/clothing/under/rank/trek/engsec
	allowed_roles = list("Chief Engineer","Atmospheric Technician","Engineer","Warden","Detective","Security Officer","Head of Security")

//TNG
/datum/gear/uniform/job_trek/cmd/tng
	display_name = "TNG uniform, cmd"
	path = /obj/item/clothing/under/rank/trek/command/next
	allowed_roles = list("Head of Security","Site Manager","Head of Personnel","Chief Engineer","Research Director","Chief Medical Officer")

/datum/gear/uniform/job_trek/medsci/tng
	display_name = "TNG uniform, med/sci"
	path = /obj/item/clothing/under/rank/trek/medsci/next
	allowed_roles = list("Chief Medical Officer","Medical Doctor","Chemist","Paramedic","Geneticist","Research Director","Scientist", "Roboticist", "Xenobiologist", "Xenobotanist", "Field Medic")

/datum/gear/uniform/job_trek/eng/tng
	display_name = "TNG uniform, eng/sec"
	path = /obj/item/clothing/under/rank/trek/engsec/next
	allowed_roles = list("Chief Engineer","Atmospheric Technician","Engineer","Warden","Detective","Security Officer","Head of Security")

//VOY
/datum/gear/uniform/job_trek/cmd/voy
	display_name = "VOY uniform, cmd"
	path = /obj/item/clothing/under/rank/trek/command/voy
	allowed_roles = list("Head of Security","Site Manager","Head of Personnel","Chief Engineer","Research Director","Chief Medical Officer")

/datum/gear/uniform/job_trek/medsci/voy
	display_name = "VOY uniform, med/sci"
	path = /obj/item/clothing/under/rank/trek/medsci/voy
	allowed_roles = list("Chief Medical Officer","Medical Doctor","Chemist","Paramedic","Geneticist","Research Director","Scientist", "Roboticist", "Xenobiologist", "Xenobotanist", "Field Medic")

/datum/gear/uniform/job_trek/eng/voy
	display_name = "VOY uniform, eng/sec"
	path = /obj/item/clothing/under/rank/trek/engsec/voy
	allowed_roles = list("Chief Engineer","Atmospheric Technician","Engineer","Warden","Detective","Security Officer","Head of Security")

//DS9

/datum/gear/suit/job_trek/ds9_coat
	display_name = "DS9 Overcoat (use uniform)"
	path = /obj/item/clothing/suit/storage/trek/ds9
	allowed_roles = list("Head of Security","Site Manager","Head of Personnel","Chief Engineer","Research Director",
						"Chief Medical Officer","Medical Doctor","Chemist","Paramedic","Geneticist",
						"Scientist","Roboticist","Xenobiologist","Xenobotanist","Atmospheric Technician",
						"Engineer","Warden","Detective","Security Officer", "Pathfinder", "Explorer", "Field Medic")


/datum/gear/uniform/job_trek/cmd/ds9
	display_name = "DS9 uniform, cmd"
	path = /obj/item/clothing/under/rank/trek/command/ds9
	allowed_roles = list("Head of Security","Site Manager","Head of Personnel","Chief Engineer","Research Director","Chief Medical Officer")

/datum/gear/uniform/job_trek/medsci/ds9
	display_name = "DS9 uniform, med/sci"
	path = /obj/item/clothing/under/rank/trek/medsci/ds9
	allowed_roles = list("Chief Medical Officer","Medical Doctor","Chemist","Paramedic","Geneticist","Research Director","Scientist", "Roboticist", "Xenobiologist", "Xenobotanist", "Field Medic")

/datum/gear/uniform/job_trek/eng/ds9
	display_name = "DS9 uniform, eng/sec"
	path = /obj/item/clothing/under/rank/trek/engsec/ds9
	allowed_roles = list("Chief Engineer","Atmospheric Technician","Engineer","Warden","Detective","Security Officer","Head of Security")


//ENT
/datum/gear/uniform/job_trek/cmd/ent
	display_name = "ENT uniform, cmd"
	path = /obj/item/clothing/under/rank/trek/command/ent
	allowed_roles = list("Head of Security","Site Manager","Head of Personnel","Chief Engineer","Research Director","Chief Medical Officer")

/datum/gear/uniform/job_trek/medsci/ent
	display_name = "ENT uniform, med/sci"
	path = /obj/item/clothing/under/rank/trek/medsci/ent
	allowed_roles = list("Chief Medical Officer","Medical Doctor","Chemist","Paramedic","Geneticist","Research Director","Scientist", "Roboticist", "Xenobiologist", "Xenobotanist", "Field Medic")

/datum/gear/uniform/job_trek/eng/ent
	display_name = "ENT uniform, eng/sec"
	path = /obj/item/clothing/under/rank/trek/engsec/ent
	allowed_roles = list("Chief Engineer","Atmospheric Technician","Engineer","Warden","Detective","Security Officer","Head of Security")
/*
Swimsuits
*/

/datum/gear/uniform/swimsuits
	display_name = "swimsuits selection"
	path = /obj/item/weapon/storage/box/fluff/swimsuit

/datum/gear/uniform/swimsuits/New()
	..()
	var/list/swimsuits = list()
	for(var/obj/item/weapon/storage/box/fluff/swimsuit/swimsuit_type as anything in typesof(/obj/item/weapon/storage/box/fluff/swimsuit))
		swimsuits[initial(swimsuit_type.name)] = swimsuit_type
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(swimsuits))

/datum/gear/uniform/suit/gnshorts
	display_name = "GN shorts"
	path = /obj/item/clothing/under/fluff/gnshorts

//Latex maid dress
/datum/gear/uniform/latexmaid
	display_name = "latex maid dress"
	path = /obj/item/clothing/under/fluff/latexmaid

//Tron Siren outfit
/datum/gear/uniform/siren
	display_name = "jumpsuit, Siren"
	path = /obj/item/clothing/under/fluff/siren

/datum/gear/uniform/suit/v_nanovest
	display_name = "Varmacorp nanovest"
	path = /obj/item/clothing/under/fluff/v_nanovest

/*
Qipao
*/
/datum/gear/uniform/qipao_black
	display_name = "qipao, black"
	path = /obj/item/clothing/under/qipao

/datum/gear/uniform/qipao_red
	display_name = "qipao, red"
	path = /obj/item/clothing/under/qipao/red

/datum/gear/uniform/qipao_white
	display_name = "qipao, white"
	path = /obj/item/clothing/under/qipao/white

/*
Bluespace jumpsuit
*/
/datum/gear/uniform/hfjumpsuit
	display_name = "HYPER jumpsuit"
	path = /obj/item/clothing/under/hyperfiber
	cost = 2

/*
Talon jumpsuit
*/
/datum/gear/uniform/talonbasic
	display_name = "Talon Jumpsuit"
	description = "A jumpsuit that is usually issued to ITV Talon contractors, however others can purchase it to show their support towards the ship."
	path = /obj/item/clothing/under/rank/talon/basic

// Summer dresses
/datum/gear/uniform/summerdress
	display_name = "summer dress selection"
	path = /obj/item/clothing/under/summerdress

/datum/gear/uniform/summerdress/New()
	..()
	var/list/dresses = list(
		"black and white" = /obj/item/clothing/under/summerdress,
		"blue and white" = /obj/item/clothing/under/summerdress/blue,
		"red and white" = /obj/item/clothing/under/summerdress/red
	)
	gear_tweaks += new/datum/gear_tweak/path(dresses)

// undersuits
/datum/gear/uniform/undersuit
	display_name = "undersuit selection"
	path = /obj/item/clothing/under/undersuit/

/datum/gear/uniform/undersuit/New()
	..()
	var/list/suits = list()
	var/list/blacklisted_types = list(/obj/item/clothing/under/undersuit/sec,
									  /obj/item/clothing/under/undersuit/sec/hos,
									  /obj/item/clothing/under/undersuit/hazard,
									  /obj/item/clothing/under/undersuit/command,
									  /obj/item/clothing/under/undersuit/centcom)
	for(var/obj/item/clothing/under/undersuit/undersuit_type as anything in typesof(/obj/item/clothing/under/undersuit))
		if(undersuit_type in blacklisted_types)
			continue
		suits[initial(undersuit_type.name)] = undersuit_type
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(suits))

/datum/gear/uniform/undersuit_haz
	display_name = "undersuit, hazard (Engineering)"
	allowed_roles = list("Chief Engineer", "Atmospheric Technician", "Engineer")
	path = /obj/item/clothing/under/undersuit/hazard

/datum/gear/uniform/undersuit_sec
	display_name = "undersuit, security (Security)"
	allowed_roles = list("Head of Security", "Warden", "Detective", "Security Officer")
	path = /obj/item/clothing/under/undersuit/sec

/datum/gear/uniform/undersuit_hos
	display_name = "undersuit, security command (HoS)"
	allowed_roles = list("Head of Security")
	path = /obj/item/clothing/under/undersuit/sec/hos

/datum/gear/uniform/undersuit_com
	display_name = "undersuit, command (SM/HoP)"
	allowed_roles = list("Site Manager", "Head of Personnel")
	path = /obj/item/clothing/under/undersuit/command

//Altevian Uniforms
/datum/gear/uniform/altevian
	description = "An extremely comfortable set of clothing that's made to help people handle their day to day work around the fleets with little to no discomfort."
	display_name = "altevian uniform selection"

/datum/gear/uniform/altevian/New()
	..()
	var/list/pants = list()
	for(var/obj/item/clothing/under/pants/altevian/pants_type as anything in typesof(/obj/item/clothing/under/pants/altevian))
		pants[initial(pants_type.name)] = pants_type
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(pants))


//Feminine Colored Jumpsuits.
/datum/gear/suit/f_jumpsuit_alt
	display_name = "Colored Feminine Jumpsuit"
	path = /obj/item/clothing/under/color/fjumpsuit

/datum/gear/uniform/f_jumpsuit_alt/New()
	..()
	var/list/jumpsuits = list()
	for(var/jumpsuit_style in typesof(/obj/item/clothing/under/color/fjumpsuit))
		var/obj/item/clothing/under/color/fjumpsuit/jumpsuit = jumpsuit_style
		jumpsuits[initial(jumpsuit.name)] = jumpsuit
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(jumpsuits)
