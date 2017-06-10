/* TUTORIAL
	"icon" is the file with the HUD/ground icon for the item
	"icon_state" is the iconstate in this file for the item
	"icon_override" is the file with the on-mob icons, can be the same file (Except for glasses, shoes, and masks.)
	"item_state" is the iconstate for the on-mob icons:
		item_state_s is used for worn uniforms on mobs
		item_state_r and item_state_l are for being held in each hand

	"item_state_slots" can replace "item_state", it is a list:
		item_state_slots["slotname1"] = "item state for that slot"
		item_state_slots["slotname2"] = "item state for that slot"
*/
/* TEMPLATE
//ckey:Character Name
/obj/item/clothing/type/fluff/charactername
	name = ""
	desc = ""

	icon = 'icons/vore/custom_clothes_vr.dmi'
	icon_state = "myicon"

	icon_override = 'icons/vore/custom_clothes_vr.dmi'
	item_state = "myicon"

*/

//benemuel:Yuuko Shimmerpond
/obj/item/clothing/under/fluff/sakura_hokkaido_kimono
	name = "Sakura Kimono"
	desc = "A pale-pink, nearly white, kimono with a red and gold obi. There is a embroidered design of cherry blossom flowers covering the kimono."

	icon = 'icons/vore/custom_clothes_vr.dmi'
	icon_state = "sh_kimono"

	icon_override = 'icons/vore/custom_clothes_vr.dmi'
	item_state = "sh_kimono_mob"

//BeyondMyLife:Kilano Soryu
/obj/item/clothing/under/dress/fluff/kilano
	name = "Bleached Dress"
	desc = "It appears that this was once a captain's dress, it's blueish color has been turned white by bleach, only the gold markings remain to slightly signify what it once was."

	icon = 'icons/vore/custom_clothes_vr.dmi'
	icon_state = "kilanodress"

	icon_override = 'icons/vore/custom_clothes_vr.dmi'
	item_state = "kilanodress_mob"

	species_restricted = null
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS

//BeyondMyLife:Kilano Soryu
/obj/item/clothing/gloves/fluff/kilano
	name = "Bleached Gloves"
	desc = "Some old captain's gloves, bleached white, almost unrecognizable from the color change besides the gold trim."

	icon = 'icons/vore/custom_clothes_vr.dmi'
	icon_state = "kilanogloves"

	icon_override = 'icons/vore/custom_clothes_vr.dmi'
	item_state = "kilanogloves_mob"
	species_restricted = null

//JoanRisu:Joan Risu
/obj/item/clothing/under/suit_jacket/female/fluff/asuna
	name = "Joan's Historia Uniform"
	desc = "A red and white outfit used by Joan during her explorer days. Looks almost like a red school uniform."

	icon = 'icons/vore/custom_clothes_vr.dmi'
	icon_state = "joanasuna"

	icon_override = 'icons/vore/custom_clothes_vr.dmi'
	item_state = "joanasuna"

//eekasqueak:Serkii Miishy
/obj/item/clothing/under/skirt/fluff/serkii
	name = "stylish blue skirt"
	desc = "A simple black shirt tops this skirt, made of a down soft blue fabric and pleated."

	icon = 'icons/vore/custom_clothes_vr.dmi'
	icon_state = "serkiskirt"

	icon_override = 'icons/vore/custom_clothes_vr.dmi'
	item_state = "serkiskirt"

//Unknown. Please check records from the forums.
/obj/item/clothing/under/suit_jacket/female/fluff/miqote
	name = "Miqo'te Seperates"
	desc = "This two-part set of clothing is very popular on the planet Hydaelyn. While made of very robust materials, its usefulness as armor is negated by the exposed midriff."

	icon = 'icons/vore/custom_clothes_vr.dmi'
	icon_state = "miqote"

	icon_override = 'icons/vore/custom_clothes_vr.dmi'
	item_state = "miqote"

//JoanRisu:Joan Risu
/obj/item/clothing/under/fluff/nightgown
	name = "nightgown"
	desc = "A seethrough nightgown. For those intimate nights with your significant other."

	icon = 'icons/vore/custom_clothes_vr.dmi'
	icon_state = "joannightgown"

	icon_override = 'icons/vore/custom_clothes_vr.dmi'
	item_state = "joannightgown"

//Vorrarkul:Lucina Dakarim
/obj/item/clothing/under/dress/fluff/lucinadress
	name = "Elegant Purple Dress"
	desc = "An expertly tailored dress, made out of fine fabrics. The interwoven necklace appears to be made out of gold, with three complicated symbols engraved in the front."

	icon = 'icons/vore/custom_clothes_vr.dmi'
	icon_state = "solara_dress"

	icon_override = 'icons/mob/uniform.dmi'
	item_state = "solara_dress"

//For general use
/obj/item/clothing/suit/storage/vest/hoscoat/fluff/brittrenchcoat
	name = "Britania Trench Coat"
	desc = "An armored trench coat from the Brittanian Empire. It looks so British."

	icon = 'icons/vore/custom_clothes_vr.dmi'
	icon_state = "brittrenchcoat"

	icon_override = 'icons/vore/custom_clothes_vr.dmi'
	item_state = "brittrenchcoat"

//For general use
/obj/item/clothing/suit/storage/vest/hoscoat/nazi_greatcoat
	name = "Greatcoat"
	desc = "Perfect attire for kicking down the doors of suspected dissidents; this coat gives off an imposing look, while offering a luxuriously plush fur liner."

	icon = 'icons/vore/custom_clothes_vr.dmi'
	icon_state = "greatcoat"

	icon_override = 'icons/vore/custom_clothes_vr.dmi'
	item_state = "greatcoat_mob"

//For general use
/obj/item/clothing/suit/storage/fluff/fedcoat
	name = "Federation Uniform Jacket (Red)"
	desc = "A uniform jacket from the United Federation. Starfleet still uses this uniform and there are variations of it. Set phasers to awesome."

	icon = 'icons/vore/custom_clothes_vr.dmi'
	icon_state = "fedcoat"

	icon_override = 'icons/vore/custom_clothes_vr.dmi'
	item_state = "fedcoat"

	blood_overlay_type = "coat"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS
	allowed = list(
				/obj/item/weapon/tank/emergency/oxygen,
				/obj/item/device/flashlight,
				/obj/item/weapon/gun/energy,
				/obj/item/weapon/gun/projectile,
				/obj/item/ammo_magazine,
				/obj/item/ammo_casing,
//				/obj/item/weapon/storage/fancy/shotgun_ammo,
				/obj/item/weapon/melee/baton,
				/obj/item/weapon/handcuffs,
//				/obj/item/device/detective_scanner,
				/obj/item/device/taperecorder)
	armor = list(melee = 50, bullet = 15, laser = 25, energy = 10, bomb = 0, bio = 0, rad = 0)
	var/unbuttoned = 0

	verb/toggle()
		set name = "Toggle coat buttons"
		set category = "Object"
		set src in usr

		if(!usr.canmove || usr.stat || usr.restrained())
			return 0

		switch(unbuttoned)
			if(0)
				icon_state = "[initial(icon_state)]_open"
				item_state = "[initial(item_state)]_open"
				unbuttoned = 1
				usr << "You unbutton the coat."
			if(1)
				icon_state = "[initial(icon_state)]"
				item_state = "[initial(item_state)]"
				unbuttoned = 0
				usr << "You button up the coat."
		usr.update_inv_wear_suit()

	//Variants
	fedblue
		name = "Federation Uniform Jacket (Blue)"
		desc = "A uniform jacket from the United Federation. Starfleet still uses this uniform and there are variations of it. Wearing this may make you feel all scientific."
		icon_state = "fedblue"
		item_state = "fedblue"
		armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 50, rad = 0)

	fedeng
		name = "Federation Uniform Jacket (Yellow)"
		desc = "A uniform jacket from the United Federation. Starfleet still uses this uniform and there are variations of it.Wearing it may make you feel like checking a warp core, whatever that is."
		icon_state = "fedeng"
		item_state = "fedeng"
		armor = list(melee = 0, bullet = 0, laser = 0,energy = 10, bomb = 0, bio = 30, rad = 35)

	fedcapt
		name = "Federation Uniform Jacket (Command)"
		desc = "A uniform jacket from the United Federation. Starfleet still uses this uniform and there are variations of it. You feel like a commanding officer of Starfleet."
		icon_state = "fedcapt"
		item_state = "fedcapt"
		armor = list(melee = 50, bullet = 5, laser = 15,energy = 10, bomb = 0, bio = 0, rad = 0)

/obj/item/clothing/suit/storage/fluff/modernfedcoat
	name = "Modern Federation Uniform Jacket (Command)"
	desc = "A modern uniform jacket from the United Federation. Their Starfleet had recently started using these uniforms. Wearing this makes you feel like a competant commander."

	icon = 'icons/vore/custom_clothes_vr.dmi'
	icon_state = "fedmodern"

	icon_override = 'icons/vore/custom_clothes_vr.dmi'
	item_state = "fedmodern"

	blood_overlay_type = "coat"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS
	allowed = list(
				/obj/item/weapon/tank/emergency/oxygen,
				/obj/item/device/flashlight,
				/obj/item/weapon/gun/energy,
				/obj/item/weapon/gun/projectile,
				/obj/item/ammo_magazine,
				/obj/item/ammo_casing,
//				/obj/item/weapon/storage/fancy/shotgun_ammo,
				/obj/item/weapon/melee/baton,
				/obj/item/weapon/handcuffs,
//				/obj/item/device/detective_scanner,
				/obj/item/device/taperecorder)
	armor = list(melee = 50, bullet = 15, laser = 25, energy = 10, bomb = 0, bio = 0, rad = 0)

	//Variants
	modernfedblue
		name = "Modern Federation Uniform Jacket (Blue)"
		desc = "A modern uniform jacket from the United Federation. Their Starfleet had recently started using these uniforms. Wearing this makes you feel like a scientist or a pilot."
		icon_state = "fedmodernblue"
		item_state = "fedmodernblue"
		armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 50, rad = 0)

	modernfedeng
		name = "Modern Federation Uniform Jacket (Yellow)"
		desc = "A modern uniform jacket from the United Federation. Their Starfleet had recently started using these uniforms. You feel like you can handle any type of technical engineering problems."
		icon_state = "fedmoderneng"
		item_state = "fedmoderneng"
		armor = list(melee = 0, bullet = 0, laser = 0,energy = 10, bomb = 0, bio = 30, rad = 35)

	modernfedsec
		name = "Modern Federation Uniform Jacket (Red)"
		desc = "A modern uniform jacket from the United Federation. Their Starfleet had recently started using these uniforms. This uniform makes you want to protect and serve as an officer."
		icon_state = "fedmodernsec"
		item_state = "fedmodernsec"
		armor = list(melee = 50, bullet = 5, laser = 15,energy = 10, bomb = 0, bio = 0, rad = 0)

/obj/item/clothing/head/caphat/formal/fedcover
	name = "Federation Officer's Cap"
	desc = "An officer's cap that demands discipline from the one who wears it."

	icon = 'icons/vore/custom_clothes_vr.dmi'
	icon_state = "fedcapofficer"

	icon_override = 'icons/vore/custom_clothes_vr.dmi'
	item_state = "fedcapofficer_mob"

	//Variants
	fedcoverblue
		name = "Federation Officer's Cap (Blue)"
		desc = "An officer's cap that demands discipline from the one who wears it."

		icon = 'icons/vore/custom_clothes_vr.dmi'
		icon_state = "fedcapsci"

		icon_override = 'icons/vore/custom_clothes_vr.dmi'
		item_state = "fedcapsci_mob"

	fedcovereng
		name = "Federation Officer's Cap (Yellow)"
		desc = "An officer's cap that demands discipline from the one who wears it."

		icon = 'icons/vore/custom_clothes_vr.dmi'
		icon_state = "fedcapeng"

		icon_override = 'icons/vore/custom_clothes_vr.dmi'
		item_state = "fedcapeng_mob"

	fedcoversec
		name = "Federation Officer's Cap (Red)"
		desc = "An officer's cap that demands discipline from the one who wears it."

		icon = 'icons/vore/custom_clothes_vr.dmi'
		icon_state = "fedcapsec"

		icon_override = 'icons/vore/custom_clothes_vr.dmi'
		item_state = "fedcapsec_mob"

	police
		name = "Police Officer's Cap"
		desc = "A Police Officer's cap that demands discipline from the one who wears it."

		icon = 'icons/vore/custom_clothes_vr.dmi'
		icon_state = "policecover"

		icon_override = 'icons/vore/custom_clothes_vr.dmi'
		item_state = "policecover_mob"

/*POLARISTODO - Needs rework in update_icons as it doesn't use item_state
//For general use
/obj/item/clothing/glasses/welding/fluff/yellow
	name = "Yellow Goggles"
	desc = "A neat looking pair of goggles"

	icon = 'icons/vore/custom_clothes_vr.dmi'
	icon_state = "gogyellow"

	icon_override = 'icons/vore/custom_clothes_vr.dmi'
	item_state = "gogyellow"

/obj/item/clothing/glasses/welding/fluff/blue
	name = "Blue Goggles"
	desc = "A neat looking pair of goggles"

	icon = 'icons/vore/custom_clothes_vr.dmi'
	icon_state = "gogblue"

	icon_override = 'icons/vore/custom_clothes_vr.dmi'
	item_state = "gogblue"
*/

//wickedtemp:chakat tempest
/obj/item/clothing/glasses/omnihud/med/fluff/wickedtemphud
	name = "Tempest's Glasses"
	desc = "A set of AR-M glasses, only these are colored purple with violet lenses in a custom frame, with a quote inscribed: \"A doctor sees the weakness in all of humanity\""

	icon = 'icons/vore/custom_items_vr.dmi'
	icon_state = "tempesthud"

	icon_override = 'icons/vore/custom_clothes_vr.dmi'
	item_state = "tempesthud"

//For general use
/obj/item/clothing/accessory/fluff/smilepin
	name = "Smiley Pin"
	desc = "A pin with a stupid grin on its face"

	icon = 'icons/vore/custom_clothes_vr.dmi'
	icon_state = "smilepin"

	icon_override = 'icons/vore/custom_clothes_vr.dmi'
	overlay_state = "" //They don't have one

//For general use
/obj/item/clothing/accessory/fluff/heartpin
	name = "Love Pin"
	desc = "A cute heart pin."

	icon = 'icons/vore/custom_clothes_vr.dmi'
	icon_state = "heartpin"

	icon_override = 'icons/vore/custom_clothes_vr.dmi'
	overlay_state = "" //They don't have one

//john.wayne9392:Harmony Prechtl
/obj/item/clothing/suit/armor/captain/fluff/harmsuit
	name = "Harmony's Captain Armor"
	desc = "A modified Captain Armor suit for Harmony Prechtl."

	icon = 'icons/vore/custom_clothes_vr.dmi'
	icon_state = "harmarmor"

	icon_override = 'icons/vore/custom_clothes_vr.dmi'
	item_state = "harmarmor"

//john.wayne9392:Harmony Prechtl
/obj/item/clothing/head/helmet/space/capspace/fluff/harmhelm
	name = "Harmony's Captain Helmet"
	desc = "A modified Captain helmet for Harmony Prechtl."

	icon = 'icons/vore/custom_clothes_vr.dmi'
	icon_state = "harmspace"

	icon_override = 'icons/vore/custom_clothes_vr.dmi'
	item_state = "harmspace_mob"

//john.wayne9392:Harmony Prechtl
/obj/item/clothing/under/rank/captain/fluff/harmuniform
	name = "Harmony's Captain uniform"
	desc = "A customized Captain uniform for Harmony Prechtl, given to her as a gift by Central Command for her service."

	icon = 'icons/vore/custom_clothes_vr.dmi'
	icon_state = "harmcaptain"

	icon_override = 'icons/vore/custom_clothes_vr.dmi'
	item_state = "harmcaptain"
	//Variant
	centcom
		name = "\improper CentCom administrator's uniform"
		desc = "It's a green jumpsuit with some gold markings denoting the rank of \"Administrator\"."

//john.wayne9392:Harmony Prechtl
/obj/item/clothing/head/centhat/fluff/harmhat
	name = "Harmony's CentCom hat"
	desc = "It's good to be queen."

// bwoincognito:Tasald Corlethian
/obj/item/clothing/under/det/fluff/tasald
	name = "Tasald's outfit"
	desc = "Tasald's outfit. Very green."

	icon = 'icons/vore/custom_clothes_vr.dmi'
	icon_state = "tasaldsuit"

	icon_override = 'icons/vore/custom_clothes_vr.dmi'
	item_state = "tasaldsuit"
	armor = list(melee = 10, bullet = 0, laser = 0, energy = 0, bomb = 0, bio = 0, rad = 0)

// bwoincognito:Tasald Corlethian
/obj/item/clothing/suit/storage/det_suit/fluff/tasald
	name = "Tasald's Vest"
	desc = "A fancy looking vest. You look like a smooth operating officer in this."

	icon = 'icons/vore/custom_clothes_vr.dmi'
	icon_state = "tasvest"

	icon_override = 'icons/vore/custom_clothes_vr.dmi'
	item_state = "tasvest"

	blood_overlay_type = "coat"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS
	armor = list(melee = 40, bullet = 30, laser = 30, energy = 10, bomb = 10, bio = 0, rad = 0)

// bwoincognito:Tasald Corlethian
/obj/item/clothing/suit/storage/det_suit/fluff/tas_coat
	name = "Armored Colony coat"
	desc = "Dark green and grey colored sleeveless long coat with two thick metal shoulder pads. has seen some wear and tear, with noticeable patches in the fabric, scratches on the shoulder pads, but with a clean patch on the left upper chest. It has a red NT marked on the right shoulder pad and red Security on the left. "

	icon = 'icons/vore/custom_clothes_vr.dmi'
	icon_state = "tasaldcoat"

	icon_override = 'icons/vore/custom_clothes_vr.dmi'
	item_state = "tasaldcoat_mob"

	blood_overlay_type = "coat"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS
	armor = list(melee = 60, bullet = 60, laser = 60, energy = 40, bomb = 40, bio = 0, rad = 0)

//Event Costumes Below
/obj/item/clothing/head/helmet/fluff/freddy
	name = "Animatronic Suit Helmet"
	desc = "Votre toast, je peux vous le rendre."

	icon = 'icons/vore/custom_clothes_vr.dmi'
	icon_state = "freddyhead"

	icon_override = 'icons/vore/custom_clothes_vr.dmi'
	item_state = "freddyhead_mob"
	permeability_coefficient = 0.01
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 0, rad = 0)
	flags_inv = HIDEMASK|HIDEEARS
	cold_protection = HEAD
	siemens_coefficient = 0.9

	//Bonnie Head
	bonnie
		desc = "Children's entertainer."
		icon_state = "bonniehead"
		item_state = "bonniehead_mob"

	//Foxy Head
	foxy
		desc = "I guess he doesn't like being watched."
		icon_state = "foxyhead"
		item_state = "foxyhead_mob"

	//Chica Head
	chica
		desc = "<b><font color=red>LET'S EAT!</font></b>"
		icon_state = "chicahead"
		item_state = "chicahead_mob"

//Anamatronic Suits
/obj/item/clothing/suit/fluff/freddy
	name = "Animatronic Suit"
	desc = "Votre toast, je peux vous le rendre."

	icon = 'icons/vore/custom_clothes_vr.dmi'
	icon_state = "freddysuit"

	icon_override = 'icons/vore/custom_clothes_vr.dmi'
	item_state = "freddysuit_mob"

	gas_transfer_coefficient = 0.01
	permeability_coefficient = 0.02
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|FEET|ARMS|HANDS
	allowed = list(/obj/item/device/flashlight,/obj/item/weapon/tank)
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 0, rad = 0)
	flags_inv = HIDEGLOVES|HIDESHOES|HIDEJUMPSUIT
	cold_protection = UPPER_TORSO | LOWER_TORSO | LEGS | FEET | ARMS | HANDS
	siemens_coefficient = 0.9

	//Bonnie Suit
	bonnie
		desc = "Children's entertainer."
		icon_state = "bonniesuit"
		item_state = "bonniesuit_mob"

	//Foxy Suit
	foxy
		desc = "I guess he doesn't like being watched."
		icon_state = "foxysuit"
		item_state = "foxysuit_mob"


	//Chica Suit
	chica
		desc = "<b><font color=red>LET'S EAT!</font></b>"
		icon_state = "chicasuit"
		item_state = "chicasuit_mob"

//End event costumes

//scree:Scree
/obj/item/clothing/head/helmet/space/void/engineering/hazmat/fluff/screehelm
	name = "Modified Tajara Helmet"
	desc = "A special helmet designed for work in a hazardous, low-pressure environment. Has radiation shielding. This one doesn't look like it was made for humans. Its been modified to include headlights."

	icon = 'icons/vore/custom_clothes_vr.dmi'
	icon_state = "scree-helm"

	icon_override = 'icons/vore/custom_clothes_vr.dmi'
	item_state = "scree-helm_mob"

	item_state_slots = list(slot_r_hand_str = "engspace_helmet", slot_l_hand_str = "engspace_helmet")

	light_overlay = "helmet_light_dual"

	species_restricted = null

	mob_can_equip(var/mob/living/carbon/human/H, slot, disable_warning = 0)
		if(..())
			if(H.ckey != "scree")
				H << "<span class='warning'>Your face and whoever is meant for this helmet are too different.</span>"
				return 0
			else
				return 1

//scree:Scree
/obj/item/clothing/suit/space/void/engineering/hazmat/fluff/screespess
	name = "Modified Winged Suit"
	desc = "A special suit that protects against hazardous, low pressure environments. Has radiation shielding. This one doesn't look like it was made for humans. This one was made with a special personal shielding for someone's wings."

	icon = 'icons/vore/custom_clothes_vr.dmi'
	icon_state = "scree-spess"

	icon_override = 'icons/vore/custom_clothes_vr.dmi'
	item_state = "scree-spess_mob"

	item_state_slots = list(slot_r_hand_str = "eng_voidsuit", slot_l_hand_str = "eng_voidsuit")

	species_restricted = null

	mob_can_equip(var/mob/living/carbon/human/H, slot, disable_warning = 0)
		if(..())
			if(H.ckey != "scree")
				H << "<span class='warning'>The gloves only have three fingers, not to mention the accommodation for extra limbs.</span>"
				return 0
			else
				return 1

//scree:Scree
/obj/item/clothing/under/fluff/screesuit
	name = "Scree's feathers"
	desc = "A mop of fluffy blue feathers, the honkmother only knows what kind of bird they originally came from."

	icon = 'icons/vore/custom_clothes_vr.dmi'
	icon_state = "screesuit"

	icon_override = 'icons/vore/custom_clothes_vr.dmi'
	item_state = "screesuit"

	mob_can_equip(var/mob/living/carbon/human/H, slot, disable_warning = 0)
		if(..())
			if(H.ckey != "scree")
				H << "<span class='warning'>Are you just going to tape them on or what? This isn't gonna work.</span>"
				return 0
			else
				return 1

//HOS Hardsuit
/obj/item/clothing/suit/space/void/security/fluff/hos // ToDo: Rig version.
	name = "\improper prototype voidsuit"
	desc = "A customized security voidsuit made to match the Head of Security's obession with black. Has additional composite armor."

	icon = 'icons/vore/custom_clothes_vr.dmi'
	icon_state = "rig-hos"

	icon_override = 'icons/vore/custom_clothes_vr.dmi'
	item_state = "rig-hos_mob"

//HOS Hardsuit Helmet
/obj/item/clothing/head/helmet/space/void/security/fluff/hos // ToDo: Rig version.
	name = "\improper prototype voidsuit helmet"
	desc = "A customized security voidsuit helmet customized to include the Head of Security's signature hat. Has additional composite armor."

	icon = 'icons/vore/custom_clothes_vr.dmi'
	icon_state = "rig0-hos"

	icon_override = 'icons/vore/custom_clothes_vr.dmi'
	item_state = "rig0-hos_mob"

//adk09:Lethe
/obj/item/clothing/head/helmet/hos/fluff/lethe
	name = "Lethe's Hat"
	desc = " This is Lethe's Hat! A little tag attached inside reads: 'If found please return to Lethe! Or else!' It looks rather worn in. It also lacks armor."
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 0, rad = 0)

	icon = 'icons/obj/clothing/hats.dmi'
	icon_state = "hoscap"

	icon_override = 'icons/mob/head.dmi'
	item_state = "hoscap"

/obj/item/weapon/storage/belt/utility/fluff/vulpine
	name = "vulpine belt"
	desc = "A tool-belt in Atmos colours."

	icon = 'icons/vore/custom_clothes_vr.dmi'
	icon_state = "vulpine_belt"

	icon_override = 'icons/vore/custom_clothes_vr.dmi'
	item_state = "vulpine_belt_mob"

	storage_slots = 9
	New()
		..()
		new /obj/item/weapon/screwdriver(src)
		new /obj/item/weapon/wrench(src)
		new /obj/item/weapon/weldingtool(src)
		new /obj/item/weapon/crowbar(src)
		new /obj/item/weapon/wirecutters(src)
		new /obj/item/device/multitool(src)
		new /obj/item/stack/cable_coil(src, 30, "red")

// molenar:Giliana Gamish
/obj/item/clothing/suit/storage/toggle/labcoat/fluff/molenar
	name = "Gili Custom Labcoat"
	desc = " Custom made, lengthened labcoat with water resistant, durable material. And a custom set of holes inserted for Deathclaw anatomy. A tag inside has 'G.G.' monogram on it"

	icon = 'icons/vore/custom_clothes_vr.dmi'
	icon_state = "molenar"

	icon_override = 'icons/vore/custom_clothes_vr.dmi'
	item_state = "molenar"
	var/item_open = "molenar_open"
	var/item_closed = "molenar"

//scree:Scree
/obj/item/clothing/head/fluff/pompom
	name = "Pom-Pom"
	desc = "A fluffy little thingus on a thin stalk, ideal for impersonating moogles and anglerfish. Kupomnomnom."

	icon = 'icons/vore/custom_clothes_vr.dmi'
	icon_state = "pom"

	icon_override = 'icons/vore/custom_clothes_vr.dmi'
	item_state = "pom_mob"

	w_class = ITEMSIZE_SMALL
	on = 0
	brightness_on = 5
	light_overlay = null

	attack_self(mob/user)
		//if(!isturf(user.loc)) -- doesn't seem to cause problems to allow this and it's silly not to
		//	user << "You cannot turn the light on while in this [user.loc]"
		//	return

		switch(on)
			if(0)
				on = 1
				user << "You light up your pom-pom."
				icon_state = "pom-on"
				item_state = "pom-on_mob"

			if(1)
				on = 0
				user << "You dim your pom-pom."
				icon_state = "pom"
				item_state = "pom_mob"

		//update_light(user) -- old code
		update_flashlight(user)

		if(ishuman(user))
			var/mob/living/carbon/human/H = user
			if(H.head == src)
				H.update_inv_head()

	action_button_name = "Toggle pom-pom"

/obj/item/weapon/rig/light/hacker/fluff/aronai
	name = "KHI-99-AAR suit module"
	suit_type = "nano"
	desc = "A thin collapsable spacesuit for synths from Kitsuhana Heavy Industries."
	airtight = 1 //Not because it should be airtight but because suit coolers don't work w/o it.
	armor = list(melee = 25, bullet = 15, laser = 15, energy = 60, bomb = 30, bio = 70, rad = 100)
	air_type = null //No O2 tank, why would it have one?

	cell_type =  /obj/item/weapon/cell/hyper
	req_access = list(access_medical)

	initial_modules = list(
		/obj/item/rig_module/maneuvering_jets,
		/obj/item/rig_module/teleporter
		)

//Viveret:Keturah
/obj/item/clothing/under/dress/maid
	name = "Maid Outfit"
	desc = "A french maid outfit made ironically in Gaia's version of the far east."

//JoanRisu:Joan Risu
/obj/item/clothing/head/helmet/space/fluff/joan
	name = "Joan's Combat Space Helmet"
	desc = "A customized combat space helmet made for a certain squirrely Commissioned Officer. \
	The top has the signature ears that are held up with a harder back covering. 'Joan' is engraved on the back.\
	There are some indications that the helmet has seen combat."

	icon = 'icons/vore/custom_clothes_vr.dmi'
	icon_state = "joanhelm"

	icon_override = 'icons/vore/custom_clothes_vr.dmi'
	item_state = "joanhelm_mob"

	light_overlay = "helmet_light"

	mob_can_equip(var/mob/living/carbon/human/H, slot, disable_warning = 0)
		if(..())
			if(H.ckey != "joanrisu")
				H << "<span class='warning'>You try to fit on the helmet, but it doesn't fit.</span>"
				return 0
			else
				return 1

//JoanRisu:Joan Risu
/obj/item/clothing/suit/space/fluff/joan
	name = "Joan's Combat Spacesuit"
	desc = "A customized combat spacesuit made for a certain squirrely Commissioned Officer, tail slot included. \
	On the right shoulder, the United Federation's Emblem sits proudly with a Rose weaving through it. \
	On the left, there are faded indications that there were different ranks painted on and off. On the collar \
	where the suit is softer is a rectangular name-tag with the name 'Joan' on it. There are indications that the \
	suit has seen combat."

	armor = list(melee = 50, bullet = 40, laser = 45, energy = 25, bomb = 50, bio = 100, rad = 50) //These values were taken from the combat rigs and adjusted to be weaker than said rigs.
	slowdown = 0
	allowed = list(/obj/item/weapon/gun,/obj/item/device/flashlight,/obj/item/weapon/tank,/obj/item/device/suit_cooling_unit,/obj/item/weapon/melee/baton)
	w_class = ITEMSIZE_NORMAL

	icon = 'icons/vore/custom_clothes_vr.dmi'
	icon_state = "joansuit"

	icon_override = 'icons/vore/custom_clothes_vr.dmi'
	item_state = "joansuit_mob"

	mob_can_equip(var/mob/living/carbon/human/H, slot, disable_warning = 0)
		if(..())
			if(H.ckey != "joanrisu")
				H << "<span class='warning'>You try to fit into the suit, to no avail.</span>"
				return 0
			else
				return 1


/obj/item/clothing/under/rank/internalaffairs/fluff/joan
	desc = "The plain, professional attire of a Federation Law Enforcement Detective."
	name = "Federation Dress Shirt"
	icon = 'icons/vore/custom_clothes_vr.dmi'
	icon_state = "joanuniform"

	icon_override = 'icons/vore/custom_clothes_vr.dmi'
	item_state = "joanuniform_mob"
	worn_state = "joanuniform_mob"
	rolled_sleeves = 0
	starting_accessories = list(/obj/item/clothing/accessory/black)

//Kisukegema:Kisuke `the nerd` Gema
/obj/item/clothing/glasses/omnihud/kamina
	name = "Kamina glasses"
	icon = 'icons/vore/custom_items_vr.dmi'
	icon_override = 'icons/vore/custom_clothes_vr.dmi'
	icon_state = "kamina"
	desc = "ROW ROW, FIGHT THE POWER."
	flash_prot = 1 //Why not.

//Kitsuhana Uniforms
/obj/item/clothing/under/rank/khi
	name = "Delete Me"
	desc = "Why did you spawn this one? Dork."
	sensor_mode = 3

	icon = 'icons/vore/custom_clothes_vr.dmi'
	icon_state = "khi_uniform_i"

	icon_override = 'icons/vore/custom_clothes_vr.dmi'
	item_state = ""

	cmd //Command version
		name = "KHI command suit"
		desc = "Kitsuhana Heavy Industries uniform. An extra-comfortable command one, at that. I guess if you DON'T want anarchy for some reason."
		icon_state = "khi_uniform_cmd_i"
		item_state = "khi_uniform_cmd"
		worn_state = "khi_uniform_cmd"
		armor = list(melee = 5, bullet = 10, laser = 10, energy = 0, bomb = 0, bio = 0, rad = 0)

	sec //Security version
		name = "KHI security suit"
		desc = "Kitsuhana Heavy Industries uniform. This one has angry red security stripes. Keepin' the peace in style."
		icon_state = "khi_uniform_sec_i"
		item_state = "khi_uniform_sec"
		worn_state = "khi_uniform_sec"
		armor = list(melee = 10, bullet = 0, laser = 0, energy = 0, bomb = 0, bio = 0, rad = 0)

	med //Medical version
		name = "KHI medical suit"
		desc = "Kitsuhana Heavy Industries uniform. The medical version. Why not just get a new body, anyway?"
		icon_state = "khi_uniform_med_i"
		item_state = "khi_uniform_med"
		worn_state = "khi_uniform_med"
		armor = list(melee = 0, bullet = 0, laser = 0, energy = 0, bomb = 0, bio = 50, rad = 5)

	eng //Engineering version
		name = "KHI engineering suit"
		desc = "Kitsuhana Heavy Industries uniform. One fit for an engineer, by the looks of it. Building the future, one disaster at a time."
		icon_state = "khi_uniform_eng_i"
		item_state = "khi_uniform_eng"
		worn_state = "khi_uniform_eng"
		armor = list(melee = 0, bullet = 0, laser = 0, energy = 0, bomb = 0, bio = 0, rad = 10)

	sci //Science version
		name = "KHI science suit"
		desc = "Kitsuhana Heavy Industries uniform. For performing science in, based on the color! Only SCIENCE can save us now."
		icon_state = "khi_uniform_sci_i"
		item_state = "khi_uniform_sci"
		worn_state = "khi_uniform_sci"
		armor = list(melee = 0, bullet = 0, laser = 0, energy = 0, bomb = 5, bio = 0, rad = 5)

	fluff/aronai //Aro fluff version
		name = "KHI meditech suit"
		desc = "Kitsuhana Heavy Industries uniform. This one has the colors of a resleeving or mnemonics engineer. It has 'Aronai' written inside the top."
		icon_state = "khi_uniform_aro_i"
		item_state = "khi_uniform_aro"
		worn_state = "khi_uniform_aro"
		armor = list(melee = 5, bullet = 5, laser = 5, energy = 0, bomb = 0, bio = 0, rad = 0)

//jacobdragon:Earthen Breath
/obj/item/clothing/under/fluff/earthenbreath
	name = "Earth Swimsuit"
	desc = "The suit of Subject 688,509,403. Made of an enviromentally safe elastic. Dry-clean not required."
	icon_state = "fluffearthenbreath"
	item_state = "fluffearthenbreath"

//jacobdragon:Earthen Breath
/obj/item/clothing/head/fluff/hairflowerpin
	name = "Hair Flower Pin"
	desc = "It's a flower fashioned into a hair pin. It's very nice."
	icon_state = "hairflowerpin"
	item_state = "hairflowerpin_mob"
	body_parts_covered = 0

//bwoincognito:Octavious Ward
/obj/item/clothing/suit/storage/trench/fluff/octaviouscoat
	name = "Thin Leather coat"
	desc = "A finely made leather coat designed for use in laboratories and doubles for parties. Has the letters O.C.W. embroidered in sliver on the right breast pocket."
	icon = 'icons/vore/custom_clothes_vr.dmi'
	icon_state = "octavgentlecoat"
	icon_override = 'icons/vore/custom_clothes_vr.dmi'
	item_state = "octavgentlecoat_mob"
	blood_overlay_type = "coat"
	allowed = list(/obj/item/weapon/tank/emergency/oxygen, /obj/item/device/flashlight,/obj/item/weapon/gun/energy,/obj/item/weapon/gun/projectile,/obj/item/ammo_magazine,/obj/item/ammo_casing,/obj/item/weapon/melee/baton,/obj/item/weapon/handcuffs,/obj/item/weapon/storage/fancy/cigarettes,/obj/item/weapon/flame/lighter,/obj/item/device/taperecorder,/obj/item/device/uv_light)

//bwoincognito:Octavious Ward
/obj/item/clothing/under/det/fluff/octavious
	name = "Expensive Suit and vest"
	desc = "A well made suit and tie, with a thin leather vest, while not as rugged as normal lab suits, it lets the wearer look dashing as he works. The letter's O.C.W. are embroidered on the left breast."

	icon = 'icons/vore/custom_clothes_vr.dmi'
	icon_state = "octavgentlesuit"

	icon_override = 'icons/vore/custom_clothes_vr.dmi'
	item_state = "octavgentlesuit_mob" //don't forget to rename the sprite.

//bwoincognito:Octavious Ward
/obj/item/clothing/head/fedora/fluff/bowler
	name = "Expensive Bowler Hat"
	desc = "A well made bowler hat. Lets the wearer look dashing as he works. The letter's O.C.W. are embroidered on the inside."

	icon = 'icons/vore/custom_clothes_vr.dmi'
	icon_state = "bowler"

	icon_override = 'icons/vore/custom_clothes_vr.dmi'
	item_state = "bowler_mob"

//bwoincognito:Octavious Ward
/obj/item/clothing/mask/gas/plaguedoctor/fluff/octaviousmask
	name = "Customized Gas Mask"
	desc = "A customized gas mask to look like an old plague doctors, with a special looking lens in the left eye that turns on when in use."
	icon = 'icons/vore/custom_clothes_vr.dmi'
	icon_state = "octplaguedoctor"
	icon_override = 'icons/vore/custom_onmob_vr.dmi'
	item_state = "octplaguedoctor_mob"
	item_state_slots = null
	armor = list(melee = 0, bullet = 0, laser = 2,energy = 2, bomb = 0, bio = 90, rad = 0)
	body_parts_covered = HEAD|FACE|EYES

//bwoincognito:Octavious Ward
/obj/item/clothing/glasses/hud/health/octaviousmonicle
	name = "Gilded monocle"
	desc = "Avery expensive looking monocle inlaid with small gems around the gold frame. It has a thin leather cord running down to a clasp for attaching to ones coat. Probably not a good idea to steal this."
	icon = 'icons/vore/custom_clothes_vr.dmi'
	icon_state = "clockworkgoggle_l"
	icon_override = 'icons/vore/custom_onmob_vr.dmi'
	item_state = "clockworkgoggle_l_mob"
	item_state_slots = null
	body_parts_covered = 0


/obj/item/clothing/shoes/black/cuffs
	name = "Gilded cuffs"
	desc = "Ankle coverings for digitigrade creatures. Gilded!"
	icon = 'icons/vore/custom_clothes_vr.dmi'
	icon_state = "gildedcuffs"

	icon_override = 'icons/vore/custom_onmob_vr.dmi'
	item_state = "gildedcuffs_mob"
	item_icons = null

	body_parts_covered = 0
	species_restricted = null

	red
		name = "Red Cuffs"
		desc = "Ankle coverings for digitigrade creatures. Red!"
		icon_state = "redcuffs"
		item_state = "redcuffs_mob"

	blue
		name = "Blue Cuffs"
		desc = "Ankle coverings for digitigrade creatures. Blue!"
		icon_state = "bluecuffs"
		item_state = "bluecuffs_mob"


//bwoincognito:Octavious Ward
	octavious
		name = "silvered leg wraps"
		desc = "Dark leather leg wraps with sliver clasps on the sides. Stylish and functional."
		icon_state = "silvergildedcuffs"
		item_state = "silvergildedcuffs_mob"


//jemli:Jemli
/obj/item/clothing/head/fedora/fluff/jemli
	name = "Cavalier Hat"
	desc = "A smart, wide-brimmed hat with a rather fetching red feather in the brim. All for one, one for all."

	icon = 'icons/vore/custom_clothes_vr.dmi'
	icon_state = "jemli_hat"

	icon_override = 'icons/vore/custom_clothes_vr.dmi'
	item_state = "jemli_hat_mob"

//virgo113:Verin Raharra
/obj/item/clothing/suit/storage/hazardvest/fluff/verin
	name = "Green Haz-coat"
	desc = "A well-worn green, long coat made with lightweight materials, it has a radioactive hazard icon on it's right sleeve. Smells faintly like sergal."
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 0, rad = 20)
	body_parts_covered = UPPER_TORSO|ARMS
	icon = 'icons/vore/custom_clothes_vr.dmi'
	icon_override = 'icons/vore/custom_clothes_vr.dmi'
	icon_state = "verin"
	item_state = "verin_mob"

//whiskyrose:Vinjj
/obj/item/clothing/head/welding/fluff/vinjj
	name = "Vinjj's Stylish Bandana"
	desc = "A lovely blue and purple bandanna with a refined topaz hanging from its tail end, a pair of goggles are hidden underneath its fabric. Although for some strange reason, wearing this seems to inspire lewd thoughts."
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 0, rad = 0)
	icon = 'icons/vore/custom_clothes_vr.dmi'
	icon_override = 'icons/vore/custom_clothes_vr.dmi'
	item_icons = list(
		slot_l_hand_str = 'icons/vore/custom_clothes_vr.dmi',
		slot_r_hand_str = 'icons/vore/custom_clothes_vr.dmi',
		)
	icon_state = "vinjjdana"
	item_state = "vinjjdana_mob"
	item_state_slots = list(slot_r_hand_str = "vinjjdana_mob_r", slot_l_hand_str = "vinjjdana_mob_l")
	flags_inv = (HIDEEYES)
	body_parts_covered = HEAD|EYES

/obj/item/clothing/head/welding/fluff/vinjj/toggle() //overriding this 'cause it only conceals the eyes - it's a hat, not a mask
	set category = "Object"
	set src in usr

	if(usr.canmove && !usr.stat && !usr.restrained())
		if(src.up)
			src.up = !src.up
			body_parts_covered |= (EYES)
			flags_inv |= (HIDEEYES)
			icon_state = "vinjjdana"
			item_state = "vinjjdana_mob"
			usr << "You flip the goggles down to protect your eyes."
		else
			src.up = !src.up
			body_parts_covered &= ~(EYES)
			flags_inv &= ~(HIDEEYES)
			icon_state = "vinjjdanaup"
			item_state = "vinjjdanaup_mob"

			usr << "You push the goggles up out of your face."
		update_clothing_icon()	//so our mob-overlays
		if (ismob(src.loc)) //should allow masks to update when it is opened/closed
			var/mob/M = src.loc
			M.update_inv_wear_mask()
		usr.update_action_buttons()

//Vorrarkul: Theodora Lindt
/obj/item/clothing/suit/chococoat
	name = "Chococoat"
	desc = "A long coat designed to resemble Getmore Chocolate Corp's namesake chocolate bar wrapper." //A walking advertisement?
	icon = 'icons/vore/custom_clothes_vr.dmi'
	icon_override = 'icons/vore/custom_clothes_vr.dmi'
	item_state = "chococoat_on"
	icon_state = "chococoat"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS
	allowed = list (/obj/item/weapon/material/knife)

//KiwiDaNinja: Chakat Taiga
/obj/item/clothing/under/fluff/taiga
	name = "Taiga's F.D Uniform"
	desc = "This uniform - consisting of only the uniform shirt, and built out of a soft fleece - dons the badge of Amistad Fire and Rescuse on both shoulders. The badges denote the wearer as a FF/Paramedic, and their name is embroidered in a gold thread on their right breast; Chakat Taiga! An 'official' badge is pinned to their left breast." //A walking advertisement?
	icon = 'icons/vore/custom_clothes_vr.dmi'
	icon_override = 'icons/vore/custom_clothes_vr.dmi'
	item_state = "taigaff_on"
	icon_state = "taigaff" //Went ahead and made the det_corporate sprite fit.
/*
Departamental Swimsuits, for general use
*/

/obj/item/clothing/under/swimsuit/fluff/
	icon = 'icons/vore/custom_clothes_vr.dmi'
	icon_override = 'icons/vore/custom_clothes_vr.dmi'
	siemens_coefficient = 1

/obj/item/clothing/under/swimsuit/fluff/engineering
	name = "Engineering Swimsuit"
	desc = "It's an orange high visibility swimsuit worn by engineers. It lacks radiation, or any, shielding."
	icon_state = "swimsuit_engineering"
	item_state = "swimsuit_engineering_mob"

/obj/item/clothing/under/swimsuit/fluff/science
	name = "Science Swimsuit"
	desc = "It's made of a special fiber that provides no protection whatsoever, but its hydrophobic. It has markings that denote the wearer as a scientist."
	icon_state = "swimsuit_science"
	item_state = "swimsuit_science_mob"

/obj/item/clothing/under/swimsuit/fluff/security
	name = "Security Swimsuit"
	desc = "It's made of a slightly sturdier material than standard swimsuits, to allow for a more robust appearance."
	icon_state = "swimsuit_security"
	item_state = "swimsuit_security_mob"

/obj/item/clothing/under/swimsuit/fluff/medical
	name = "Medical Swimsuit"
	desc = "It's made of a special fiber that provides no protection whatsoever, but its elastic. It has a cross on the back denoting that the wearer is trained medical personnel."
	icon_state = "swimsuit_medical"
	item_state = "swimsuit_medical_mob"

//Xsdew:Penelope Allen
/obj/item/clothing/under/swimsuit/fluff/penelope
	name = "Penelope's Swimsuit"
	desc = "It's made of a special fiber that provides no protection whatsoever, but its elastic. This one was custom made for Penelope."
	icon_state = "swimsuit_penelope"
	item_state = "swimsuit_penelope_mob"

//Just some alt-uniforms themed around Star Trek - Pls don't sue, Mr Roddenberry ;_;
// PS. <3 Nienhaus


/obj/item/clothing/under/rank/trek
	name = "Section 31 Uniform"
	desc = "Oooh... right."
	icon = 'icons/vore/custom_clothes_vr.dmi'
	icon_override = 'icons/vore/custom_clothes_vr.dmi'
	item_state = ""

//TOS
/obj/item/clothing/under/rank/trek/command
	name = "Command Uniform"
	desc = "The uniform worn by command officers in the mid 2260s."
	icon_state = "trek_command"
	item_state = "trek_command"
	armor = list(melee = 10, bullet = 10, laser = 10,energy = 0, bomb = 0, bio = 10, rad = 10, fire = 0, acid = 0) // Considering only staff heads get to pick it

/obj/item/clothing/under/rank/trek/engsec
	name = "Operations Uniform"
	desc = "The uniform worn by operations officers of the mid 2260s. You feel strangely vulnerable just seeing this..."
	icon_state = "trek_engsec"
	item_state = "trek_engsec"
	armor = list(melee = 10, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 0, rad = 10, fire = 0, acid = 0) // since they're shared between jobs and kinda moot.

/obj/item/clothing/under/rank/trek/medsci
	name = "MedSci Uniform"
	desc = "The uniform worn by medsci officers in the mid 2260s."
	icon_state = "trek_medsci"
	item_state = "trek_medsci"
	permeability_coefficient = 0.50
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 10, rad = 0, fire = 0, acid = 0) // basically a copy of vanilla sci/med

//TNG
/obj/item/clothing/under/rank/trek/command/next
	desc = "The uniform worn by command officers. This one's from the mid 2360s."
	icon_state = "trek_next_command"
	item_state = "trek_next_command"

/obj/item/clothing/under/rank/trek/engsec/next
	desc = "The uniform worn by operation officers. This one's from the mid 2360s."
	icon_state = "trek_next_engsec"
	item_state = "trek_next_engsec"

/obj/item/clothing/under/rank/trek/medsci/next
	desc = "The uniform worn by medsci officers. This one's from the mid 2360s."
	icon_state = "trek_next_medsci"
	item_state = "trek_next_medsci"

//ENT
/obj/item/clothing/under/rank/trek/command/ent
	desc = "The uniform worn by command officers of the 2140s."
	icon_state = "trek_ent_command"
	item_state = "trek_ent_command"

/obj/item/clothing/under/rank/trek/engsec/ent
	desc = "The uniform worn by operations officers of the 2140s."
	icon_state = "trek_ent_engsec"
	item_state = "trek_ent_engsec"

/obj/item/clothing/under/rank/trek/medsci/ent
	desc = "The uniform worn by medsci officers of the 2140s."
	icon_state = "trek_ent_medsci"
	item_state = "trek_ent_medsci"

//VOY
/obj/item/clothing/under/rank/trek/command/voy
	desc = "The uniform worn by command officers of the 2370s."
	icon_state = "trek_voy_command"
	item_state = "trek_voy_command"

/obj/item/clothing/under/rank/trek/engsec/voy
	desc = "The uniform worn by operations officers of the 2370s."
	icon_state = "trek_voy_engsec"
	item_state = "trek_voy_engsec"

/obj/item/clothing/under/rank/trek/medsci/voy
	desc = "The uniform worn by medsci officers of the 2370s."
	icon_state = "trek_voy_medsci"
	item_state = "trek_voy_medsci"

//DS9

/obj/item/clothing/suit/storage/trek/ds9
	name = "Padded Overcoat"
	desc = "The overcoat worn by all officers of the 2380s."
	icon_state = "trek_ds9_coat"
	icon = 'icons/vore/custom_clothes_vr.dmi'
	item_state = "trek_ds9_coat_mob"
	icon_override = 'icons/vore/custom_clothes_vr.dmi'
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS
	permeability_coefficient = 0.50
	allowed = list(
		/obj/item/device/flashlight, /obj/item/device/analyzer,
		/obj/item/device/radio, /obj/item/weapon/tank/emergency/oxygen,
		/obj/item/weapon/reagent_containers/hypospray, /obj/item/device/healthanalyzer,
		/obj/item/weapon/reagent_containers/dropper,/obj/item/weapon/reagent_containers/syringe,
		/obj/item/weapon/reagent_containers/glass/bottle,/obj/item/weapon/reagent_containers/glass/beaker,
		/obj/item/weapon/reagent_containers/pill,/obj/item/weapon/storage/pill_bottle
		)
	armor = list(melee = 20, bullet = 0, laser = 0, energy = 0, bomb = 0, bio = 20, rad = 25)

/obj/item/clothing/suit/storage/trek/ds9/admiral // Only for adminuz
	name = "Admiral Overcoat"
	desc = "Admirality specialty coat to keep flag officers fashionable and protected."
	icon_state = "trek_ds9_coat_adm"
	item_state = "trek_ds9_coat_adm_mob"
	armor = list(melee = 45, bullet = 35, laser = 35, energy = 20, bomb = 0, bio = 40, rad = 55)


/obj/item/clothing/under/rank/trek/command/ds9
	desc = "The uniform worn by command officers of the 2380s."
	icon_state = "trek_command"
	item_state = "trek_ds9_command"

/obj/item/clothing/under/rank/trek/engsec/ds9
	desc = "The uniform worn by operations officers of the 2380s."
	icon_state = "trek_engsec"
	item_state = "trek_ds9_engsec"

/obj/item/clothing/under/rank/trek/medsci/ds9
	desc = "The uniform undershit worn by medsci officers of the 2380s."
	icon_state = "trek_medsci"
	item_state = "trek_ds9_medsci"

//For general use maybe
/obj/item/clothing/under/batter //I guess we're going OFF limits.
	name = "Worn baseball outfit"
	desc = "<b>Purification in progress...</b>"
	icon = 'icons/vore/custom_clothes_vr.dmi'
	icon_override = 'icons/vore/custom_clothes_vr.dmi'
	icon_state = "batter"
	item_state = "batter_mob"

/obj/item/clothing/suit/storage/hooded/wintercoat/jessie
	name = "Handmade Winter Suit"
	desc = "A durable, but somewhat ragged lower portion of a snow suit fitted for a wolftaur."
	icon = 'icons/mob/taursuits_vr.dmi'
	icon_override = 'icons/mob/taursuits_vr.dmi'
	icon_state = "jessiecoat"

/obj/item/clothing/suit/storage/hooded/wintercoat/jessie/mob_can_equip(var/mob/living/carbon/human/H, slot, disable_warning = 0)
	if(..())
		if(istype(H) && istype(H.tail_style, /datum/sprite_accessory/tail/taur/wolf))
			if(icon_state == "jessiecoat")
				return ..()
			icon_override = 'icons/mob/taursuits_vr.dmi'
			icon_state = "jessiecoat"
			pixel_x = -16
			return ..()
		else
			to_chat(H, "<span class='warning'>You need to have a wolf-taur half to wear this.</span>")
			return 0

//samanthafyre:Kateryna Petrovitch
/obj/item/clothing/suit/armor/vest/wolftaur/kate
	name = "Kat's Fox Taur Armor"
	desc = "A set of security armor, light weight and easy to run in for a Taur, this item protects the \
	entire body."
	icon = 'icons/mob/taursuits_vr.dmi'
	icon_override = 'icons/mob/taursuits_vr.dmi'
	icon_state = "katesuit"
	item_state_slots = null

	mob_can_equip(var/mob/living/carbon/human/H, slot, disable_warning = 0)
		if(..())
			if(istype(H) && istype(H.tail_style, /datum/sprite_accessory/tail/taur/wolf))
				if(icon_state == "katesuit")
					return ..()
				icon_override = 'icons/mob/taursuits_vr.dmi'
				icon_state = "katesuit"
				pixel_x = -16
				return ..()
			else
				H << "<span class='warning'>You need to have a wolf-taur half to wear this.</span>"
				return 0

//samanthafyre:Kateryna Petrovitch
/obj/item/clothing/suit/space/void/engineering/kate
	name = "Kat's Navy Engineer voidsuit"
	desc = "Taur engineering voidsuit. Recolored navy blue and white. Slightly tweaked as well to \
	get close to having security voidsuit protection as possible with a slight reduction in movement \
	speed to compensate for custom padding and armor Kateryna made herself."
	icon = 'icons/mob/taursuits_vr.dmi'
	icon_override = 'icons/mob/taursuits_vr.dmi'
	icon_state = "lilithsuit"
	species_restricted = null
	armor = list(melee = 40, bullet = 20, laser = 20,energy = 5, bomb = 35, bio = 100, rad = 20)

	mob_can_equip(var/mob/living/carbon/human/H, slot, disable_warning = 0)
		if(..())
			if(istype(H) && istype(H.tail_style, /datum/sprite_accessory/tail/taur/wolf))
				if(icon_state == "lilithsuit")
					return ..()
				icon_override = 'icons/mob/taursuits_vr.dmi'
				icon_state = "lilithsuit"
				pixel_x = -16
				return ..()
			else
				H << "<span class='warning'>You need to have a wolf-taur half to wear this.</span>"
				return 0

//samanthafyre:Kateryna Petrovitch
/obj/item/clothing/head/helmet/space/fluff/kate
	name = "Kat's Navy Engineer Helmet"
	desc = "A customized combat space helmet made for Kateryna. It uses a navy design as the base before it\
	was customized to suit the wearer's personality."
	icon = 'icons/vore/custom_clothes_vr.dmi'
	icon_state = "lilithhelmet"
	icon_override = 'icons/vore/custom_clothes_vr.dmi'
	item_state = "lilithhelmet"
	light_overlay = "helmet_light"
	species_restricted = null

	mob_can_equip(var/mob/living/carbon/human/H, slot, disable_warning = 0)
		if(..())
			if(H.ckey != "samanthafyre")
				H << "<span class='warning'>You try to fit on the helmet, but it doesn't fit.</span>"
				return 0
			else
				return 1

//Seiga: Alfonso Oak Telanor
/obj/item/clothing/glasses/sunglasses/fluff/alfonso
	name = "cyborg visor"
	desc = "Eyewear worn by a once famous Thunderdome competitor. Fo' shizzle."
	icon = 'icons/vore/custom_clothes_vr.dmi'
	icon_state = "alfonso_visor"
	icon_override = 'icons/vore/custom_onmob_vr.dmi'
