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

//Federation jackets
/datum/gear/suit/job_fed/sec
	display_name = "fed uniform, sec"
	path = /obj/item/clothing/suit/storage/fluff/fedcoat
	allowed_roles = list(JOB_HEAD_OF_SECURITY, JOB_WARDEN, JOB_DETECTIVE, JOB_SECURITY_OFFICER)

/datum/gear/suit/job_fed/medsci
	display_name = "fed uniform, med/sci"
	path = /obj/item/clothing/suit/storage/fluff/fedcoat/fedblue
	allowed_roles = list("Chief Medical Officer","Medical Doctor","Chemist","Paramedic","Geneticist","Research Director","Scientist", "Roboticist", "Xenobiologist","Xenobotanist")

/datum/gear/suit/job_fed/eng
	display_name = "fed uniform, eng"
	path = /obj/item/clothing/suit/storage/fluff/fedcoat/fedeng
	allowed_roles = list("Chief Engineer","Atmospheric Technician","Engineer")
//DS9

/datum/gear/suit/job_trek/ds9_coat
	display_name = "DS9 Overcoat (use uniform)"
	path = /obj/item/clothing/suit/storage/trek/ds9
	allowed_roles = list(JOB_HEAD_OF_SECURITY,JOB_SITE_MANAGER,JOB_HEAD_OF_PERSONNEL,"Chief Engineer","Research Director",
						"Chief Medical Officer","Medical Doctor","Chemist","Paramedic","Geneticist",
						"Scientist","Roboticist","Xenobiologist","Xenobotanist","Atmospheric Technician",
						"Engineer",JOB_WARDEN,JOB_DETECTIVE,JOB_SECURITY_OFFICER)

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

/datum/gear/uniform/qipao_colorable_alt
	display_name = "qipao, colorable alt"
	path = /obj/item/clothing/under/qipao/white/colorable

/datum/gear/uniform/qipao_colorable_alt/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice

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

//Altevian Uniforms
/datum/gear/uniform/altevian
	description = "A comfortable set of clothing for people to handle their day to day work around the fleets with little to no discomfort."
	display_name = "altevian uniform selection"

/datum/gear/uniform/altevian/New()
	..()
	var/list/pants = list()
	for(var/obj/item/clothing/under/pants/altevian/pants_type as anything in typesof(/obj/item/clothing/under/pants/altevian))
		pants[initial(pants_type.name)] = pants_type
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(pants))


//Feminine Colored Jumpsuits.
/datum/gear/uniform/f_jumpsuit_alt
	display_name = "Colored Feminine Jumpsuit"
	path = /obj/item/clothing/under/color/fjumpsuit

/datum/gear/uniform/f_jumpsuit_alt/New()
	..()
	var/list/jumpsuits = list()
	for(var/jumpsuit_style in typesof(/obj/item/clothing/under/color/fjumpsuit))
		var/obj/item/clothing/under/color/fjumpsuit/jumpsuit = jumpsuit_style
		jumpsuits[initial(jumpsuit.name)] = jumpsuit
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(jumpsuits))

/datum/gear/uniform/singer_blue
	display_name = "blue singer dress"
	path = /obj/item/clothing/under/dress/singer

/datum/gear/uniform/singer_yellow
	display_name = "yellow singer dress"
	path = /obj/item/clothing/under/dress/singer/yellow

//Antediluvian corsets from CitRP
/datum/gear/uniform/antediluvian
	display_name = "corset, antediluvian"
	path = /obj/item/clothing/under/dress/antediluvian

/datum/gear/uniform/antediluvianalt
	display_name = "corset, antediluvian alt"
	path = /obj/item/clothing/under/dress/antediluvian/sheerless

//Colorable skirts
/datum/gear/uniform/coloredskirts
	display_name = "skirt selection, colorable"
	path = /obj/item/clothing/under/skirt/colorable

/datum/gear/uniform/coloredskirts/New()
	..()
	var/list/skirts = list(
	"casual skirt"=/obj/item/clothing/under/skirt/colorable,
	"puffy skirt"=/obj/item/clothing/under/skirt/colorable/puffy,
	"skater skirt"=/obj/item/clothing/under/skirt/colorable/skater,
	"pleated skirt"=/obj/item/clothing/under/skirt/colorable/pleated,
	"pleated skirt, alt"=/obj/item/clothing/under/skirt/colorable/pleated/alt,
	"pencil skirt"=/obj/item/clothing/under/skirt/colorable/pencil,
	"plaid skirt"=/obj/item/clothing/under/skirt/colorable/plaid,
	"tube skirt"=/obj/item/clothing/under/skirt/colorable/tube,
	"long skirt"=/obj/item/clothing/under/skirt/colorable/long,
	"high skirt"=/obj/item/clothing/under/skirt/colorable/high,
	"swept skirt"=/obj/item/clothing/under/skirt/colorable/swept,
	"jumper skirt"=/obj/item/clothing/under/skirt/colorable/jumper,
	"jumper dress"=/obj/item/clothing/under/skirt/colorable/jumperdress
	)
	gear_tweaks += list(new/datum/gear_tweak/path(skirts), gear_tweak_free_color_choice)

// gwen beedells clown clothes

/datum/gear/uniform/stripeddungarees
	display_name = "striped dungarees"
	path = /obj/item/clothing/under/stripeddungarees

// recolorable flame dress

/datum/gear/uniform/cdress_fire
	display_name = "flame dress, colorable"
	path = /obj/item/clothing/under/dress/cdress_fire

/datum/gear/uniform/cdress_fire/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice


// recolorable yellow dress
/datum/gear/uniform/cbridesmaid
	display_name = "fancy dress, colorable"
	path = /obj/item/clothing/under/dress/cbridesmaid

/datum/gear/uniform/cbridesmaid/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice

// recolorable orange swoop dress
/datum/gear/uniform/cswoopdress
	display_name = "swoop dress, recolorable"
	path = /obj/item/clothing/under/dress/cswoopdress

/datum/gear/uniform/cswoopdress/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice
