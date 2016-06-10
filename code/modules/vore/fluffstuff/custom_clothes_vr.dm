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

//Vorrarkul:Lucina Dakarim
/obj/item/clothing/under/dress/fluff/lucinadress
	name = "Elegant Purple Dress"
	desc = "An expertly tailored dress, made out of fine fabrics. The interwoven necklace appears to be made out of gold, with three complicated symbols engraved in the front."

	icon = 'icons/vore/custom_clothes_vr.dmi'
	icon_state = "solara_dress"

	icon_override = 'icons/mob/uniform.dmi'
	item_state = "solara_dress"

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

//wickedtemp:chakat tempest
/obj/item/clothing/glasses/hud/health/fluff/wickedtemphud
	name = "Purple MedHUD"
	desc = "A standard Medical HUD, only this one is colored purple with a violet lens."

	icon = 'icons/vore/custom_clothes_vr.dmi'
	icon_state = "healthhud"

	icon_override = 'icons/vore/custom_clothes_vr.dmi'
	item_state = "healthhud"

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
/obj/item/clothing/head/helmet/space/void/engineering/fluff/screehelm
	name = "Modified Tajara Helmet"
	desc = "A special helmet designed for work in a hazardous, low-pressure environment. Has radiation shielding. This one doesn't look like it was made for humans. Its been modified to include headlights."

	icon = 'icons/vore/custom_clothes_vr.dmi'
	icon_state = "scree-helm"

	icon_override = 'icons/vore/custom_clothes_vr.dmi'
	item_state = "scree-helm_mob"

	light_overlay = "helmet_light_dual"

	species_restricted = null

	mob_can_equip(var/mob/living/carbon/human/H, slot, disable_warning = 0)
		..()
		if(H.ckey != "scree")
			H << "<span class='warning'>Your face and whoever is meant for this helmet are too different.</span>"
			return 0
		else
			return 1

//scree:Scree
/obj/item/clothing/suit/space/void/engineering/fluff/screespess
	name = "Modified Winged Suit"
	desc = "A special suit that protects against hazardous, low pressure environments. Has radiation shielding. This one doesn't look like it was made for humans. This one was made with a special personal shielding for someone's wings."

	icon = 'icons/vore/custom_clothes_vr.dmi'
	icon_state = "scree-spess"

	icon_override = 'icons/vore/custom_clothes_vr.dmi'
	item_state = "scree-spess_mob"

	species_restricted = null

	mob_can_equip(var/mob/living/carbon/human/H, slot, disable_warning = 0)
		..()
		if(H.ckey != "scree")
			H << "<span class='warning'>The gloves only have three fingers, not to mention the accomidation for extra limbs.</span>"
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
		..()
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
		new /obj/item/stack/cable_coil(src, 30, "green")

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

//scree:Scree
/obj/item/clothing/head/fluff/pompom
	name = "Pom-Pom"
	desc = "A fluffy little thingus on a thin stalk, ideal for impersonating moogles and anglerfish. Kupomnomnom."

	icon = 'icons/vore/custom_clothes_vr.dmi'
	icon_state = "pom"

	icon_override = 'icons/vore/custom_clothes_vr.dmi'
	item_state = "pom_mob"

	w_class = 2.0
	on = 0
	brightness_on = 5
	light_overlay = null

	attack_self(mob/user)
		if(!isturf(user.loc))
			user << "You cannot turn the light on while in this [user.loc]"
			return

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

		update_light(user)

		if(ishuman(user))
			var/mob/living/carbon/human/H = user
			if(H.head == src)
				H.update_inv_head()

// arokha : Aronai Kadigan
/obj/item/clothing/head/helmet/space/fluff/aronai
	name = "Aronai's Helmet"
	desc = "This spacesuit helmet appears to be custom-made for someone with pointed ears and a muzzle. \
		It is form-fitting enough that it's unlikely to fit anyone but the person it was intended for. \
		'Aronai' is printed on the back of the helmet."

	icon = 'icons/vore/custom_clothes_vr.dmi'
	icon_state = "arohelm"

	icon_override = 'icons/vore/custom_clothes_vr.dmi'
	item_state = "arohelm_mob"

	light_overlay = "helmet_light_dual"
	camera_networks = list(NETWORK_MEDICAL)

	mob_can_equip(var/mob/living/carbon/human/H, slot, disable_warning = 0)
		..()
		if(H.ckey != "arokha")
			H << "<span class='warning'>You try to wear the helmet, but it doesn't fit.</span>"
			return 0
		else
			return 1

/obj/item/clothing/suit/space/fluff/aronai
	name = "Aronai's Spacesuit"
	desc = "This spacesuit appears to be custom-made for someone with digitigrade legs and a tail. \
		It is form-fitting enough that it's unlikely to fit anyone but the person it was intended for. \
		'Aronai' is printed just above the spine on the back of the neckpiece. It has no space for an O2 tank. \
		In fact, it's practically paper-thin. It doesn't seem to retain body heat at all."

	icon = 'icons/vore/custom_clothes_vr.dmi'
	icon_state = "arosuit"

	icon_override = 'icons/vore/custom_clothes_vr.dmi'
	item_state = "arosuit_mob"
	w_class = 4 //Oh but I can.
	allowed = list(/obj/item/device/suit_cooling_unit) //Can't fit O2 tanks

	mob_can_equip(var/mob/living/carbon/human/H, slot, disable_warning = 0)
		..()
		if(H.ckey != "arokha")
			H << "<span class='warning'>You try to fit into the suit, to no avail.</span>"
			return 0
		else
			return 1

//Viveret:Keturah
/obj/item/clothing/under/dress/maid/
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


//JoanRisu:Joan Risu
/obj/item/clothing/suit/space/fluff/joan
	name = "Joan's Combat Spacesuit"
	desc = "A customized combat spacesuit made for a certain squirrely Commissioned Officer, tail slot included. \
	On the right shoulder, the United Federation's Emblem sits proudly. On the left, there are faded indications \
	that there were different ranks painted on and off. On the collar where the suit is softer is a rectangular \
	name-tag with the name 'Joan' on it. There are indications that the suit has seen combat."

	icon = 'icons/vore/custom_clothes_vr.dmi'
	icon_state = "joansuit"

	icon_override = 'icons/vore/custom_clothes_vr.dmi'
	item_state = "joansuit_mob"

/obj/item/clothing/under/rank/internalaffairs/fluff/joan
	desc = "The plain, professional attire of a Federation Law Enforcement Detective. The collar is <i>immaculately</i> starched."
	name = "Federation Dress Shirt"
	icon_state = "internalaffairs"
	item_state = "ba_suit"
	worn_state = "internalaffairs"
	rolled_sleeves = 0
	starting_accessories = list(/obj/item/clothing/accessory/black)
