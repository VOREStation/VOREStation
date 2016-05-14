/* TUTORIAL
	"icon" is the file with the HUD/ground icon for the item
	"icon_state" is the iconstate in this file for the item
	"icon_override" is the file with the on-mob icons, can be the same file
	"item_state" is the iconstate for the on-mob icons:
		item_state_s is used for worn uniforms on mobs
		item_state_r and item_state_l are for being held in each hand
		some do not have a suffix, like gloves. plan accordingly, maybe add _mob?
	"overlay_state" is the iconstate for ties/accessories, for some reason they don't
		just use the item_state variable

	If you don't have a special HUD/ground sprite, don't worry about it.
	Just set both the icon_state and item_state to the same thing,
	and it will use the top direction sprite (facing the viewer)
	for your HUD/item sprite. This usually looks fine!

	Advanced:
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

//For general use
/obj/item/clothing/suit/armor/hos/fluff/brittrenchcoat
	name = "Britania Trench Coat"
	desc = "An armored trench coat from the Brittanian Empire. It looks so British."

	icon = 'icons/vore/custom_clothes_vr.dmi'
	icon_state = "brittrenchcoat"

	icon_override = 'icons/vore/custom_clothes_vr.dmi'
	item_state = "brittrenchcoat"

//For general use
/obj/item/clothing/suit/armor/hos/nazi_greatcoat
	name = "Greatcoat"
	desc = "Perfect attire for kicking down the doors of suspected dissidents; this coat gives off an imposing look, while offering a luxuriously plush fur liner."

	icon = 'icons/vore/custom_clothes_vr.dmi'
	icon_state = "greatcoat"

	icon_override = 'icons/vore/custom_clothes_vr.dmi'
	item_state = "greatcoat_mob"

//For general use
/obj/item/clothing/suit/storage/fluff/fedcoat
	name = "Federation Uniform Jacket"
	desc = "A uniform jacket from the United Federation. Starfleet still uses this uniform and there are variations of it. Set phasers to awesome."

	icon = 'icons/vore/custom_clothes_vr.dmi'
	icon_state = "fedcoat"

	icon_override = 'icons/vore/custom_clothes_vr.dmi'
	item_state = "fedcoat"

	blood_overlay_type = "coat"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS
	allowed = list(
				/obj/item/weapon/tank/emergency_oxygen,
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
		name = "Federation Uniform Jacket"
		desc = "A uniform jacket from the United Federation. Starfleet still uses this uniform and there are variations of it. Wearing this may make you feel all scientific."
		icon_state = "fedblue"
		item_state = "fedblue"
		armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 50, rad = 0)

	fedeng
		name = "Federation Uniform Jacket"
		desc = "A uniform jacket from the United Federation. Starfleet still uses this uniform and there are variations of it.Wearing it may make you feel like checking a warp core, whatever that is."
		icon_state = "fedeng"
		item_state = "fedeng"
		armor = list(melee = 0, bullet = 0, laser = 0,energy = 10, bomb = 0, bio = 30, rad = 35)

	fedcapt
		name = "Federation Uniform Jacket"
		desc = "A uniform jacket from the United Federation. Starfleet still uses this uniform and there are variations of it. You feel like a commanding officer of Starfleet."
		icon_state = "fedcapt"
		item_state = "fedcapt"
		armor = list(melee = 50, bullet = 5, laser = 15,energy = 10, bomb = 0, bio = 0, rad = 0)

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

//These inherit freddy stats
/obj/item/clothing/head/helmet/fluff/freddy/bonnie
	desc = "Children's entertainer."
	icon_override = 'icons/vore/custom_clothes_vr.dmi'
	icon_state = "bonniehead"
	item_state = "bonniehead_mob"

/obj/item/clothing/suit/fluff/freddy/bonnie
	desc = "Children's entertainer."
	icon_override = 'icons/vore/custom_clothes_vr.dmi'
	icon_state = "bonniesuit"
	item_state = "bonniesuit_mob"

/obj/item/clothing/head/helmet/fluff/freddy/foxy
	desc = "I guess he doesn't like being watched."
	icon_override = 'icons/vore/custom_clothes_vr.dmi'
	icon_state = "foxyhead"
	item_state = "foxyhead_mob"

/obj/item/clothing/suit/fluff/freddy/foxy
	desc = "I guess he doesn't like being watched."
	icon_override = 'icons/vore/custom_clothes_vr.dmi'
	icon_state = "foxysuit"
	item_state = "foxysuit_mob"

/obj/item/clothing/head/helmet/fluff/freddy/chica
	desc = "<b><font color=red>LET'S EAT!</font></b>"
	icon_override = 'icons/vore/custom_clothes_vr.dmi'
	icon_state = "chicahead"
	item_state = "chicahead_mob"

/obj/item/clothing/suit/fluff/freddy/chica
	desc = "<b><font color=red>LET'S EAT!</font></b>"
	icon_override = 'icons/vore/custom_clothes_vr.dmi'
	icon_state = "chicasuit"
	item_state = "chicasuit_mob"

//End event costumes

//scree:Scree
/obj/item/clothing/head/helmet/space/void/engineering/fluff/screehelm
	name = "Modified Tajara Helmet"
	desc = "A special helmet designed for work in a hazardous, low-pressure environment. Has radiation shielding. This one doesn't look like it was made for humans. Its been modified to include headlights."

	icon = 'icons/vore/custom_clothes_vr.dmi'
	icon_state = "rig0-scree"

	icon_override = 'icons/vore/custom_clothes_vr.dmi'
	item_state = "rig0-scree_mob"

//scree:Scree
/obj/item/clothing/suit/space/void/engineering/fluff/screespess
	name = "Modified Winged Suit"
	desc = "A special suit that protects against hazardous, low pressure environments. Has radiation shielding. This one doesn't look like it was made for humans. This one was made with a special personal shielding for someone's wings."

	icon = 'icons/vore/custom_clothes_vr.dmi'
	icon_state = "wingedsuit"

	icon_override = 'icons/vore/custom_clothes_vr.dmi'
	item_state = "wingedsuit"

//scree:Scree
/obj/item/clothing/under/fluff/screesuit
	name = "Scree's feathers"
	desc = "A mop of fluffy blue feathers, the honkmother only knows what kind of bird they originally came from."

	icon = 'icons/vore/custom_clothes_vr.dmi'
	icon_state = "screesuit"

	icon_override = 'icons/vore/custom_clothes_vr.dmi'
	item_state = "screesuit_s"

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


// molenar:Giliana Gamish
/obj/item/clothing/suit/storage/toggle/labcoat/fluff/molenar
	name = "Gili Custom Labcoat"
	desc = " Custom made, lengthened labcoat with water resistant, durable material. And a custom set of holes inserted for Deathclaw anatomy. A tag inside has 'G.G.' monogram on it"

	icon = 'icons/vore/custom_clothes_vr.dmi'
	icon_state = "molenar"
	icon_open = "molenar_open"
	icon_closed = "molenar"

	icon_override = 'icons/vore/custom_clothes_vr.dmi'
	item_state = "molenar"
