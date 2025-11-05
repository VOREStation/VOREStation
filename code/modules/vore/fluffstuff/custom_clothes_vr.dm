/* TUTORIAL
	"icon" is the file with the HUD/ground icon for the item
	"icon_state" is the iconstate in this file for the item
	"default_worn_icon" is the file with the on-mob icons, can be the same file (Except for glasses, shoes, and masks.)
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

	icon = 'icons/vore/custom_clothes_item.dmi'
	icon_state = "myicon"

	default_worn_icon = 'icons/vore/custom_clothes_mob.dmi'

*/

//Natje: Awen Henry
/obj/item/clothing/head/fluff/wolfgirl
	name = "Wolfgirl Hat"
	desc = "An odd, small hat with two strings attached to it."

	icon_state = "wolfgirlhat"
	icon = 'icons/vore/custom_clothes_item.dmi'
	default_worn_icon = 'icons/vore/custom_clothes_mob.dmi'

//Natje: Awen Henry
/obj/item/clothing/shoes/fluff/wolfgirl
	name = "Red Sandals"
	desc = "A pair of sandals that make you want to awoo!"

	icon_state = "wolfgirlsandals"
	icon = 'icons/vore/custom_clothes_item.dmi'
	default_worn_icon = 'icons/vore/custom_clothes_mob.dmi'

//Natje: Awen Henry
/obj/item/clothing/under/fluff/wolfgirl
	name = "Wolfgirl Clothes"
	desc = "A set of clothes almost identical to those Wolf Girls always wear..."

	icon = 'icons/vore/custom_clothes_item.dmi'
	icon_state = "wolfgirluni"
	rolled_sleeves = 0
	rolled_down = 0

	default_worn_icon = 'icons/vore/custom_clothes_mob.dmi'
	body_parts_covered = CHEST|ARMS|LEGS

//SpoopyLizz: Roiz Lizden
/obj/item/clothing/suit/storage/hooded/wintercoat/roiz
	name = "dinosaur winter coat"
	desc = "A custom winter coat that looks rather like a dinosaur. It has a nametag that says, Roiz Lizden."
	icon = 'icons/vore/custom_clothes_item.dmi'
	icon_state = "coatroiz"
	has_hood_sprite = TRUE

	default_worn_icon = 'icons/vore/custom_clothes_mob.dmi'
/obj/item/clothing/suit/storage/hooded/wintercoat/roiz/digest_act(var/atom/movable/item_storage = null)
	return FALSE

//ketrai:Ketrai
/obj/item/clothing/head/fluff/ketrai
	name = "Bear Pelt"
	desc = "A luxury space bear pelt, its origins unknown."

	icon = 'icons/vore/custom_clothes_item.dmi'
	icon_state = "bearpelt"

	default_worn_icon = 'icons/vore/custom_clothes_mob.dmi'

//benemuel:Yuuko Shimmerpond
/obj/item/clothing/under/fluff/sakura_hokkaido_kimono
	name = "Sakura Kimono"
	desc = "A pale-pink, nearly white, kimono with a red and gold obi. There is a embroidered design of cherry blossom flowers covering the kimono."

	icon = 'icons/vore/custom_clothes_item.dmi'
	icon_state = "sh_kimono"
	default_worn_icon = 'icons/vore/custom_clothes_mob.dmi'

//JoanRisu:Joan Risu
/obj/item/clothing/under/suit_jacket/female/fluff/asuna
	name = "Joan's Historia Uniform"
	desc = "A red and white outfit used by Joan during her explorer days. Looks almost like a red school uniform."

	icon = 'icons/vore/custom_clothes_item.dmi'
	icon_state = "joanasuna"

	default_worn_icon = 'icons/vore/custom_clothes_mob.dmi'

//eekasqueak:Serkii Miishy
/obj/item/clothing/under/skirt/fluff/serkii
	name = "stylish blue skirt"
	desc = "A simple black shirt tops this skirt, made of a down soft blue fabric and pleated."

	icon = 'icons/vore/custom_clothes_item.dmi'
	icon_state = "serkiskirt"

	default_worn_icon = 'icons/vore/custom_clothes_mob.dmi'

//Unknown. Please check records from the forums.
/obj/item/clothing/under/suit_jacket/female/fluff/miqote
	name = "Miqo'te Seperates"
	desc = "This two-part set of clothing is very popular on the planet Hydaelyn. While made of very robust materials, its usefulness as armor is negated by the exposed midriff."

	icon = 'icons/vore/custom_clothes_item.dmi'
	icon_state = "miqote"

	default_worn_icon = 'icons/vore/custom_clothes_mob.dmi'

//JoanRisu:Joan Risu
/obj/item/clothing/under/fluff/nightgown
	name = "nightgown"
	desc = "A seethrough nightgown. For those intimate nights with your significant other."

	icon = 'icons/vore/custom_clothes_item.dmi'
	icon_state = "joannightgown"

	default_worn_icon = 'icons/vore/custom_clothes_mob.dmi'

//Vorrarkul:Lucina Dakarim
/obj/item/clothing/under/dress/fluff/lucinadress
	name = "Elegant Purple Dress"
	desc = "An expertly tailored dress, made out of fine fabrics. The interwoven necklace appears to be made out of gold, with three complicated symbols engraved in the front."

	icon = 'icons/vore/custom_clothes_item.dmi'
	icon_state = "solara_dress"

	default_worn_icon = 'icons/inventory/uniform/mob.dmi'

//For general use
/obj/item/clothing/suit/storage/vest/hoscoat/fluff/brittrenchcoat
	name = "Britania Trench Coat"
	desc = "An armored trench coat from the Brittanian Empire. It looks so British."

	icon = 'icons/vore/custom_clothes_item.dmi'
	icon_state = "brittrenchcoat"
	default_worn_icon = 'icons/vore/custom_clothes_mob.dmi'

//For general use
/obj/item/clothing/suit/storage/vest/hoscoat/ancient_greatcoat
	name = "Greatcoat"
	desc = "This coat gives off an imposing look, while offering a luxuriously plush fur liner."

	icon = 'icons/vore/custom_clothes_item.dmi'
	icon_state = "greatcoat"

	default_worn_icon = 'icons/vore/custom_clothes_mob.dmi'

//For general use
/obj/item/clothing/suit/storage/vest/hoscoat/russofurcoat
	name = "long fur coat"
	desc = "A sophisticated long coat made of fur."

	icon = 'icons/inventory/suit/mob.dmi'
	icon_state = "russofurcoat"

	default_worn_icon = 'icons/inventory/suit/mob.dmi'

	armor = list(melee = 0, bullet = 0, laser = 0, energy = 0, bomb = 0, bio = 0, rad = 0)
	allowed = list(POCKET_GENERIC, POCKET_EMERGENCY)
	flags_inv = HIDETIE|HIDEHOLSTER

//For general use
/obj/item/clothing/suit/storage/fluff/fedcoat
	name = "Federation Uniform Jacket (Red)"
	desc = "A uniform jacket from the United Federation. Starfleet still uses this uniform and there are variations of it. Set phasers to awesome."

	icon = 'icons/vore/custom_clothes_item.dmi'
	icon_state = "fedcoat"
	default_worn_icon = 'icons/vore/custom_clothes_mob.dmi'

	blood_overlay_type = "coat"
	body_parts_covered = CHEST|ARMS
	allowed = list(POCKET_GENERIC, POCKET_EMERGENCY, POCKET_SECURITY, POCKET_DETECTIVE)
	armor = list(melee = 10, bullet = 20, laser = 10, energy = 0, bomb = 0, bio = 0, rad = 0) //As much armor as the cyberpunk jacket. Also priced the same.
	var/unbuttoned = FALSE

/obj/item/clothing/suit/storage/fluff/fedcoat/verb/toggle()
	set name = "Toggle coat buttons"
	set category = "Object"
	set src in usr

	if(!usr.canmove || usr.stat || usr.restrained())
		return FALSE

	if(unbuttoned)
		icon_state = "[initial(icon_state)]"
		item_state = "[initial(item_state)]"
		unbuttoned = FALSE
		to_chat(usr, "You button up the coat.")
	else
		icon_state = "[initial(icon_state)]_open"
		item_state = "[initial(item_state)]_open"
		unbuttoned = TRUE
		to_chat(usr, "You unbutton the coat.")
	usr.update_inv_wear_suit()

	//Variants
/obj/item/clothing/suit/storage/fluff/fedcoat/fedblue
	name = "Federation Uniform Jacket (Blue)"
	desc = "A uniform jacket from the United Federation. Starfleet still uses this uniform and there are variations of it. Wearing this may make you feel all scientific."
	icon_state = "fedblue"
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 50, rad = 0) //As much armor as a normal labcoat.

/obj/item/clothing/suit/storage/fluff/fedcoat/fedeng
	name = "Federation Uniform Jacket (Yellow)"
	desc = "A uniform jacket from the United Federation. Starfleet still uses this uniform and there are variations of it.Wearing it may make you feel like checking a warp core, whatever that is."
	icon_state = "fedeng"
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 0, rad = 20) //I was going to say 'as much as a hazard vest' but then I checked and found that hazard vests either never HAD rad resistance or had it removed... Whatever. I gave the hazard vest it's rad resistance back as well.

/obj/item/clothing/suit/storage/fluff/fedcoat/fedcapt
	name = "Federation Uniform Jacket (Command)"
	desc = "A uniform jacket from the United Federation. Starfleet still uses this uniform and there are variations of it. You feel like a commanding officer of Starfleet."
	icon_state = "fedcapt"
	armor = list(melee = 10, bullet = 20, laser = 10, energy = 0, bomb = 0, bio = 0, rad = 0)

/obj/item/clothing/suit/storage/fluff/modernfedcoat
	name = "Modern Federation Uniform Jacket (Command)"
	desc = "A modern uniform jacket from the United Federation. Their Starfleet had recently started using these uniforms. Wearing this makes you feel like a competant commander."

	icon = 'icons/vore/custom_clothes_item.dmi'
	icon_state = "fedmodern"

	default_worn_icon = 'icons/vore/custom_clothes_mob.dmi'

	blood_overlay_type = "coat"
	body_parts_covered = CHEST|ARMS
	allowed = list(POCKET_GENERIC, POCKET_EMERGENCY, POCKET_SECURITY, POCKET_DETECTIVE)
	armor = list(melee = 10, bullet = 20, laser = 10, energy = 0, bomb = 0, bio = 0, rad = 0)

	//Variants
/obj/item/clothing/suit/storage/fluff/modernfedcoat/modernfedblue
	name = "Modern Federation Uniform Jacket (Blue)"
	desc = "A modern uniform jacket from the United Federation. Their Starfleet had recently started using these uniforms. Wearing this makes you feel like a scientist or a pilot."
	icon_state = "fedmodernblue"
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 50, rad = 0)

/obj/item/clothing/suit/storage/fluff/modernfedcoat/modernfedeng
	name = "Modern Federation Uniform Jacket (Yellow)"
	desc = "A modern uniform jacket from the United Federation. Their Starfleet had recently started using these uniforms. You feel like you can handle any type of technical engineering problems."
	icon_state = "fedmoderneng"
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 0, rad = 20)

/obj/item/clothing/suit/storage/fluff/modernfedcoat/modernfedsec
	name = "Modern Federation Uniform Jacket (Red)"
	desc = "A modern uniform jacket from the United Federation. Their Starfleet had recently started using these uniforms. This uniform makes you want to protect and serve as an officer."
	icon_state = "fedmodernsec"
	armor = list(melee = 10, bullet = 20, laser = 10, energy = 0, bomb = 0, bio = 0, rad = 0)

/obj/item/clothing/head/caphat/formal/fedcover
	name = "Federation Officer's Cap"
	desc = "An officer's cap that demands discipline from the one who wears it."

	icon = 'icons/vore/custom_clothes_item.dmi'
	icon_state = "fedcapofficer"

	default_worn_icon = 'icons/vore/custom_clothes_mob.dmi'

	//Variants
/obj/item/clothing/head/caphat/formal/fedcover/fedcoverblue
	name = "Federation Officer's Cap (Blue)"
	desc = "An officer's cap that demands discipline from the one who wears it."

	icon = 'icons/vore/custom_clothes_item.dmi'
	icon_state = "fedcapsci"

	default_worn_icon = 'icons/vore/custom_clothes_mob.dmi'

/obj/item/clothing/head/caphat/formal/fedcover/fedcovereng
	name = "Federation Officer's Cap (Yellow)"
	desc = "An officer's cap that demands discipline from the one who wears it."

	icon = 'icons/vore/custom_clothes_item.dmi'
	icon_state = "fedcapeng"

	default_worn_icon = 'icons/vore/custom_clothes_mob.dmi'

/obj/item/clothing/head/caphat/formal/fedcover/fedcoversec
	name = "Federation Officer's Cap (Red)"
	desc = "An officer's cap that demands discipline from the one who wears it."

	icon = 'icons/vore/custom_clothes_item.dmi'
	icon_state = "fedcapsec"

	default_worn_icon = 'icons/vore/custom_clothes_mob.dmi'

/obj/item/clothing/head/caphat/formal/fedcover/police
	name = "Police Officer's Cap"
	desc = "A Police Officer's cap that demands discipline from the one who wears it."

	icon = 'icons/vore/custom_clothes_item.dmi'
	icon_state = "policecover"

	default_worn_icon = 'icons/vore/custom_clothes_mob.dmi'

/*POLARISTODO - Needs rework in update_icons as it doesn't use item_state
//For general use
/obj/item/clothing/glasses/welding/fluff/yellow
	name = "Yellow Goggles"
	desc = "A neat looking pair of goggles"

	icon = 'icons/vore/custom_clothes_item.dmi'
	icon_state = "gogyellow"

	default_worn_icon = 'icons/vore/custom_clothes_mob.dmi'
	item_state = "gogyellow"

/obj/item/clothing/glasses/welding/fluff/blue
	name = "Blue Goggles"
	desc = "A neat looking pair of goggles"

	icon = 'icons/vore/custom_clothes_item.dmi'
	icon_state = "gogblue"

	default_worn_icon = 'icons/vore/custom_clothes_mob.dmi'
	item_state = "gogblue"
*/

//wickedtemp:chakat tempest
/obj/item/clothing/glasses/omnihud/med/fluff/wickedtemphud
	name = "Tempest's Glasses"
	desc = "A set of AR-M glasses, only these are colored purple with violet lenses in a custom frame, with a quote inscribed: \"A doctor sees the weakness in all of humanity\""

	icon = 'icons/vore/custom_items_vr.dmi'
	icon_state = "tempesthud"

//For general use
/obj/item/clothing/accessory/fluff/smilepin
	name = "Smiley Pin"
	desc = "A pin with a stupid grin on its face"

	icon = 'icons/vore/custom_clothes_item.dmi'
	icon_state = "smilepin"

	default_worn_icon = 'icons/vore/custom_clothes_mob.dmi'
	overlay_state = "" //They don't have one

//For general use
/obj/item/clothing/accessory/fluff/heartpin
	name = "Love Pin"
	desc = "A cute heart pin."

	icon = 'icons/vore/custom_clothes_item.dmi'
	icon_state = "heartpin"

	default_worn_icon = 'icons/vore/custom_clothes_mob.dmi'
	overlay_state = "" //They don't have one

//john.wayne9392:Harmony Prechtl
/obj/item/clothing/suit/armor/captain/fluff/harmsuit
	name = "Harmony's Captain Armor"
	desc = "A modified Captain Armor suit for Harmony Prechtl."

	icon = 'icons/vore/custom_clothes_item.dmi'
	icon_state = "harmarmor"
	default_worn_icon = 'icons/vore/custom_clothes_mob.dmi'

//john.wayne9392:Harmony Prechtl
/obj/item/clothing/head/helmet/space/capspace/fluff/harmhelm
	name = "Harmony's Captain Helmet"
	desc = "A modified Captain helmet for Harmony Prechtl."

	icon = 'icons/vore/custom_clothes_item.dmi'
	icon_state = "harmspace"

	default_worn_icon = 'icons/vore/custom_clothes_mob.dmi'

//john.wayne9392:Harmony Prechtl
/obj/item/clothing/under/rank/captain/fluff/harmuniform
	name = "Harmony's Captain uniform"
	desc = "A customized Captain uniform for Harmony Prechtl, given to her as a gift by Central Command for her service."

	icon = 'icons/vore/custom_clothes_item.dmi'
	icon_state = "harmcaptain"

	default_worn_icon = 'icons/vore/custom_clothes_mob.dmi'
	//Variant
/obj/item/clothing/under/rank/captain/fluff/harmuniform/centcom
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

	icon = 'icons/vore/custom_clothes_item.dmi'
	icon_state = "tasaldsuit"

	default_worn_icon = 'icons/vore/custom_clothes_mob.dmi'
	armor = list(melee = 10, bullet = 0, laser = 0, energy = 0, bomb = 0, bio = 0, rad = 0)

// bwoincognito:Tasald Corlethian
/obj/item/clothing/suit/storage/det_suit/fluff/tasald
	name = "Tasald's Vest"
	desc = "A fancy looking vest. You look like a smooth operating officer in this."

	icon = 'icons/vore/custom_clothes_item.dmi'
	icon_state = "tasvest"

	default_worn_icon = 'icons/vore/custom_clothes_mob.dmi'

	blood_overlay_type = "coat"
	body_parts_covered = CHEST|LEGS|ARMS
	armor = list(melee = 40, bullet = 30, laser = 30, energy = 10, bomb = 10, bio = 0, rad = 0)

//Event Costumes Below
/obj/item/clothing/head/helmet/fluff/freddy
	name = "Animatronic Suit Helmet"
	desc = "Votre toast, je peux vous le rendre."

	icon = 'icons/vore/custom_clothes_item.dmi'
	icon_state = "freddyhead"

	default_worn_icon = 'icons/vore/custom_clothes_mob.dmi'
	permeability_coefficient = 0.01
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 0, rad = 0)
	flags_inv = HIDEMASK|HIDEEARS
	cold_protection = HEAD
	siemens_coefficient = 0.9

	//Bonnie Head
/obj/item/clothing/head/helmet/fluff/freddy/bonnie
	desc = "Children's entertainer."
	icon_state = "bonniehead"

	//Foxy Head
/obj/item/clothing/head/helmet/fluff/freddy/foxy
	desc = "I guess he doesn't like being watched."
	icon_state = "foxyhead"

	//Chica Head
/obj/item/clothing/head/helmet/fluff/freddy/chica
	desc = span_red(span_bold("LET'S EAT!"))
	icon_state = "chicahead"

//Anamatronic Suits

/obj/item/clothing/suit/fluff
	name = DEVELOPER_WARNING_NAME

/obj/item/clothing/suit/fluff/freddy
	name = "Animatronic Suit"
	desc = "Votre toast, je peux vous le rendre."

	icon = 'icons/vore/custom_clothes_item.dmi'
	icon_state = "freddysuit"

	default_worn_icon = 'icons/vore/custom_clothes_mob.dmi'

	gas_transfer_coefficient = 0.01
	permeability_coefficient = 0.02
	body_parts_covered = CHEST|LEGS|FEET|ARMS|HANDS
	allowed = list(POCKET_GENERIC, POCKET_ALL_TANKS)
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 0, rad = 0)
	flags_inv = HIDEGLOVES|HIDESHOES|HIDEJUMPSUIT
	cold_protection = UPPER_TORSO | LOWER_TORSO | LEGS | FEET | ARMS | HANDS
	siemens_coefficient = 0.9

	//Bonnie Suit
/obj/item/clothing/suit/fluff/freddy/bonnie
	desc = "Children's entertainer."
	icon_state = "bonniesuit"

	//Foxy Suit
/obj/item/clothing/suit/fluff/freddy/foxy
	desc = "I guess he doesn't like being watched."
	icon_state = "foxysuit"


	//Chica Suit
/obj/item/clothing/suit/fluff/freddy/chica
	desc = span_red(span_bold("LET'S EAT!"))
	icon_state = "chicasuit"

//End event costumes

//scree:Scree
/obj/item/clothing/head/helmet/space/void/engineering/hazmat/fluff/screehelm
	name = "Modified Tajara Helmet"
	desc = "A special helmet designed for work in a hazardous, low-pressure environment. Has radiation shielding. This one doesn't look like it was made for humans. Its been modified to include headlights."

	icon = 'icons/vore/custom_clothes_item.dmi'
	icon_state = "scree-helm"

	default_worn_icon = 'icons/vore/custom_clothes_mob.dmi'

	item_state_slots = list(slot_r_hand_str = "engspace_helmet", slot_l_hand_str = "engspace_helmet")

	light_overlay = "helmet_light_dual"

	species_restricted = null

/obj/item/clothing/head/helmet/space/void/engineering/hazmat/fluff/screehelm/mob_can_equip(var/mob/living/carbon/human/H, slot, disable_warning = 0)
	if(..())
		if(H.ckey != "scree")
			to_chat(H, span_warning("Your face and whoever is meant for this helmet are too different."))
			return 0
		else
			return 1

//scree:Scree
/obj/item/clothing/suit/space/void/engineering/hazmat/fluff/screespess
	name = "Modified Winged Suit"
	desc = "A special suit that protects against hazardous, low pressure environments. Has radiation shielding. This one doesn't look like it was made for humans. This one was made with a special personal shielding for someone's wings."

	icon = 'icons/vore/custom_clothes_item.dmi'
	icon_state = "scree-spess"

	default_worn_icon = 'icons/vore/custom_clothes_mob.dmi'

	item_state_slots = list(slot_r_hand_str = "eng_voidsuit", slot_l_hand_str = "eng_voidsuit")

	species_restricted = null

/obj/item/clothing/suit/space/void/engineering/hazmat/fluff/screespess/mob_can_equip(var/mob/living/carbon/human/H, slot, disable_warning = 0)
	if(..())
		if(H.ckey != "scree")
			to_chat(H, span_warning("The gloves only have three fingers, not to mention the accommodation for extra limbs."))
			return 0
		else
			return 1

//scree:Avida
/obj/item/clothing/under/skirt/outfit/fluff/avida
	name = "purple dress"
	desc = "A clingy purple dress with red lacework, with a hole at the back for a tail."
	icon = 'icons/vore/custom_clothes_item.dmi'
	icon_state = "avidadress"
	item_icons = list(
		slot_l_hand_str = 'icons/vore/custom_clothes_left_hand_vr.dmi',
		slot_r_hand_str = 'icons/vore/custom_clothes_right_hand_vr.dmi',
		slot_w_uniform_str = 'icons/vore/custom_clothes_mob.dmi'
		)

//scree:Avida
/obj/item/clothing/head/fluff/avida
	name = "purple witch hat"
	desc = "A pointy purple hat with a wide brim, with a red hatband. It appears to have ear-holes in it."
	icon = 'icons/vore/custom_clothes_item.dmi'
	icon_state = "avidahat"
	item_icons = list(
		slot_l_hand_str = 'icons/vore/custom_clothes_left_hand_vr.dmi',
		slot_r_hand_str = 'icons/vore/custom_clothes_right_hand_vr.dmi',
		slot_head_str = 'icons/vore/custom_onmob_32x48_vr.dmi'
		)

/obj/item/clothing/head/fluff/avida/mob_can_equip(var/mob/living/carbon/human/H, slot, disable_warning = 0)
	if(..())
		var/static/list/allowed_ear_names = list("Bnnuy Ears", "Bnnuy Ears 2")
		//check if wearer's ear sprite is compatible with trimmed icon
		if((H.ear_style?.name in allowed_ear_names) || (H.ear_secondary_style?.name in allowed_ear_names))
			item_state = initial(src.item_state)
		else //if not, just use a generic icon
			item_state = "avidahatnoears"
		return TRUE

//natje:Pumila
/obj/item/clothing/under/fluff/aluranevines
	name = "Pumila's vines"
	desc = "A wrap of green vines and colourful flowers."

	icon = 'icons/vore/custom_clothes_item.dmi'
	icon_state = "alurane-vines"

	default_worn_icon = 'icons/vore/custom_clothes_mob.dmi'
	item_state_slots = list(slot_r_hand_str = "alurane-vines_r", slot_l_hand_str = "alurane-vines_l")

/obj/item/clothing/under/fluff/aluranevines/mob_can_equip(var/mob/living/carbon/human/H, slot, disable_warning = 0)
	if(..())
		if(H.ckey != "natje")
			to_chat(H, span_warning("Wrapping vines around yourself is a quite an... Odd idea. You decide otherwise."))
			return 0
		else
			return 1

//HOS Hardsuit
/obj/item/clothing/suit/space/void/security/fluff/hos // ToDo: Rig version.
	name = "\improper prototype voidsuit"
	desc = "A customized security voidsuit made to match the " + JOB_HEAD_OF_SECURITY + "'s obession with black. Has additional composite armor."

	icon = 'icons/vore/custom_clothes_item.dmi'
	icon_state = "rig-hos"

	default_worn_icon = 'icons/vore/custom_clothes_mob.dmi'

	species_restricted = null

//HOS Hardsuit Helmet
/obj/item/clothing/head/helmet/space/void/security/fluff/hos // ToDo: Rig version.
	name = "\improper prototype voidsuit helmet"
	desc = "A customized security voidsuit helmet customized to include the " + JOB_HEAD_OF_SECURITY + "'s signature hat. Has additional composite armor."

	icon = 'icons/vore/custom_clothes_item.dmi'
	icon_state = "rig0-hos"

	default_worn_icon = 'icons/vore/custom_clothes_mob.dmi'

	species_restricted = null

//adk09:Lethe
/obj/item/clothing/head/helmet/hos/fluff/lethe
	name = "Lethe's Hat"
	desc = " This is Lethe's Hat! A little tag attached inside reads: 'If found please return to Lethe! Or else!' It looks rather worn in. It also lacks armor."
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 0, rad = 0)

	icon = 'icons/inventory/head/item.dmi'
	icon_state = "hoscap"

	default_worn_icon = 'icons/inventory/head/mob.dmi'

/obj/item/storage/belt/utility/fluff/vulpine
	name = "vulpine belt"
	desc = "A tool-belt in Atmos colours."

	icon = 'icons/vore/custom_clothes_item.dmi'
	icon_state = "vulpine_belt"

	default_worn_icon = 'icons/vore/custom_clothes_mob.dmi'

	storage_slots = 9

/obj/item/storage/belt/utility/fluff/vulpine/Initialize(mapload)
	. = ..()
	new /obj/item/tool/screwdriver(src)
	new /obj/item/tool/wrench(src)
	new /obj/item/weldingtool(src)
	new /obj/item/tool/crowbar(src)
	new /obj/item/tool/wirecutters(src)
	new /obj/item/multitool(src)
	new /obj/item/stack/cable_coil(src, 30, "red")

// molenar:Giliana Gamish
/obj/item/clothing/suit/storage/toggle/labcoat/fluff/molenar
	name = "Gili Custom Labcoat"
	desc = " Custom made, lengthened labcoat with water resistant, durable material. And a custom set of holes inserted for Deathclaw anatomy. A tag inside has 'G.G.' monogram on it"

	icon = 'icons/vore/custom_clothes_item.dmi'
	icon_state = "molenar"

	default_worn_icon = 'icons/vore/custom_clothes_mob.dmi'
	var/item_open = "molenar_open"
	var/item_closed = "molenar"

//scree:Scree
/obj/item/clothing/head/fluff/pompom
	name = "Pom-Pom"
	desc = "A fluffy little thingus on a thin stalk, ideal for impersonating moogles and anglerfish. Kupomnomnom."

	icon = 'icons/vore/custom_clothes_item.dmi'
	icon_state = "pom"

	default_worn_icon = 'icons/vore/custom_clothes_mob.dmi'

	w_class = ITEMSIZE_SMALL
	light_range = 5
	light_overlay = null
	light_system = MOVABLE_LIGHT

	actions_types = list(/datum/action/item_action/toggle_pom_pom)

/obj/item/clothing/head/fluff/pompom/digest_act(var/atom/movable/item_storage = null)
	return FALSE

/obj/item/clothing/head/fluff/pompom/gurgle_contaminate(var/atom/movable/item_storage = null)
	return FALSE

/obj/item/clothing/head/fluff/pompom/attack_self(mob/user)
	//if(!isturf(user.loc)) -- doesn't seem to cause problems to allow this and it's silly not to
	//	to_chat(user, "You cannot turn the light on while in this [user.loc]")
	//	return

	if(light_on)
		to_chat(user, "You dim your pom-pom.")
		icon_state = "pom"
	else
		to_chat(user, "You light up your pom-pom.")
		icon_state = "pom-on"

	//update_light(user) -- old code
	update_flashlight(user)

	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(H.head == src)
			H.update_inv_head()

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

	icon = 'icons/vore/custom_clothes_item.dmi'
	icon_state = "joanhelm"

	default_worn_icon = 'icons/vore/custom_clothes_mob.dmi'

	light_overlay = "helmet_light"

/obj/item/clothing/head/helmet/space/fluff/joan/mob_can_equip(var/mob/living/carbon/human/H, slot, disable_warning = 0)
	if(..())
		if(H.ckey != "joanrisu")
			to_chat(H, span_warning("You try to fit on the helmet, but it doesn't fit."))
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
	allowed = list(POCKET_GENERIC, POCKET_ALL_TANKS, POCKET_SECURITY, POCKET_SUIT_REGULATORS)

	icon = 'icons/vore/custom_clothes_item.dmi'
	icon_state = "joansuit"

	default_worn_icon = 'icons/vore/custom_clothes_mob.dmi'

/obj/item/clothing/suit/space/fluff/joan/mob_can_equip(var/mob/living/carbon/human/H, slot, disable_warning = 0)
	if(..())
		if(H.ckey != "joanrisu")
			to_chat(H, span_warning("You try to fit into the suit, to no avail."))
			return 0
		else
			return 1


/obj/item/clothing/under/rank/internalaffairs/fluff/joan
	desc = "The plain, professional attire of a Federation Law Enforcement Detective."
	name = "Federation Dress Shirt"
	icon = 'icons/vore/custom_clothes_item.dmi'
	icon_state = "joanuniform"

	default_worn_icon = 'icons/vore/custom_clothes_mob.dmi'
	rolled_sleeves = 0
	starting_accessories = list(/obj/item/clothing/accessory/tie/black)

//Kisukegema:Kisuke `the nerd` Gema
/obj/item/clothing/glasses/omnihud/kamina
	name = "Kamina glasses"
	icon = 'icons/vore/custom_items_vr.dmi'
	icon_state = "kamina"
	desc = "ROW ROW, FIGHT THE POWER."
	flash_prot = 1 //Why not.

//Kitsuhana Uniforms
/obj/item/clothing/under/rank/khi
	name = DEVELOPER_WARNING_NAME
	desc = "Why did you spawn this one? Dork."
	sensor_mode = 3
	icon_state = "khi_uniform"

/obj/item/clothing/under/rank/khi/cmd //Command version
	name = "sleek command suit"
	desc = "A sleek, neocorporate style uniform. An extra-comfortable command one, at that."
	icon_state = "khi_uniform_cmd"
	armor = list(melee = 0, bullet = 0, laser = 0, energy = 0, bomb = 0, bio = 0, rad = 0)

/obj/item/clothing/under/rank/khi/sec //Security version
	name = "sleek security suit"
	desc = "A sleek, neocorporate style uniform. This one has angry red security stripes. Keepin' the peace in style."
	icon_state = "khi_uniform_sec"
	armor = list(melee = 10, bullet = 0, laser = 0, energy = 0, bomb = 0, bio = 0, rad = 0)

/obj/item/clothing/under/rank/khi/med //Medical version
	name = "sleek medical suit"
	desc = "A sleek, neocorporate style uniform. The medical version. Why not just get a new body, anyway?"
	icon_state = "khi_uniform_med"
	armor = list(melee = 0, bullet = 0, laser = 0, energy = 0, bomb = 0, bio = 10, rad = 0)

/obj/item/clothing/under/rank/khi/eng //Engineering version
	name = "sleek engineering suit"
	desc = "A sleek, neocorporate style uniform. One fit for an engineer, by the looks of it."
	icon_state = "khi_uniform_eng"
	armor = list(melee = 0, bullet = 0, laser = 0, energy = 0, bomb = 0, bio = 0, rad = 10)

/obj/item/clothing/under/rank/khi/sci //Science version
	name = "sleek science suit"
	desc = "A sleek, neocorporate style uniform. For performing science in, based on the color!"
	icon_state = "khi_uniform_sci"
	armor = list(melee = 0, bullet = 0, laser = 0, energy = 0, bomb = 10, bio = 0, rad = 0)

/obj/item/clothing/under/rank/khi/crg //Cargo version
	name = "sleek cargo suit"
	desc = "A sleek, neocorporate style uniform. Looks like it's in supply and cargo division colors. Heavy industry means heavy lifting, after all."
	icon_state = "khi_uniform_crg"
	armor = list(melee = 0, bullet = 0, laser = 0, energy = 0, bomb = 0, bio = 0, rad = 0)

/obj/item/clothing/under/rank/khi/civ //Science version
	name = "sleek civilian suit"
	desc = "A sleek, neocorporate style uniform. Snazzy silver trim marks this is as the general civilian branch. Smells like paperwork and bureaucracy."
	icon_state = "khi_uniform_civ"
	armor = list(melee = 0, bullet = 0, laser = 0, energy = 0, bomb = 0, bio = 0, rad = 0)

/obj/item/clothing/under/rank/khi/fluff
	name = DEVELOPER_WARNING_NAME

/obj/item/clothing/under/rank/khi/fluff/aronai //Aro fluff version
	name = "KHI meditech suit"
	desc = "Kitsuhana Heavy Industries uniform. This one has the colors of a resleeving or mnemonics engineer. It has 'Aronai' written inside the top."
	icon_state = "khi_uniform_aro"
	armor = list(melee = 0, bullet = 0, laser = 0, energy = 0, bomb = 0, bio = 10, rad = 0)

//jacobdragon:Earthen Breath
/obj/item/clothing/under/fluff/earthenbreath
	name = "Earth Swimsuit"
	desc = "The suit of Subject 688,509,403. Made of an enviromentally safe elastic. Dry-clean not required."
	icon_state = "swim_earth"

//jacobdragon:Earthen Breath
/obj/item/clothing/head/fluff/hairflowerpin
	name = "Hair Flower Pin"
	desc = "It's a flower fashioned into a hair pin. It's very nice."
	icon_state = "hairflower_pink"
	body_parts_covered = 0

//bwoincognito:Octavious Ward
/obj/item/clothing/suit/storage/trench/fluff/octaviouscoat
	name = "Thin Leather coat"
	desc = "A finely made leather coat designed for use in laboratories and doubles for parties. Has the letters O.C.W. embroidered in sliver on the right breast pocket."
	icon = 'icons/vore/custom_clothes_item.dmi'
	icon_state = "octavgentlecoat"
	default_worn_icon = 'icons/vore/custom_clothes_mob.dmi'
	blood_overlay_type = "coat"
	allowed = list(POCKET_GENERIC, POCKET_EMERGENCY, POCKET_SECURITY, POCKET_DETECTIVE)

//bwoincognito:Octavious Ward
/obj/item/clothing/under/det/fluff/octavious
	name = "Expensive Suit and vest"
	desc = "A well made suit and tie, with a thin leather vest, while not as rugged as normal lab suits, it lets the wearer look dashing as he works. The letter's O.C.W. are embroidered on the left breast."

	icon = 'icons/vore/custom_clothes_item.dmi'
	icon_state = "octavgentlesuit"

	default_worn_icon = 'icons/vore/custom_clothes_mob.dmi'

//bwoincognito:Octavious Ward
/obj/item/clothing/head/fedora/fluff/bowler
	name = "Expensive Bowler Hat"
	desc = "A well made bowler hat. Lets the wearer look dashing as he works. The letter's O.C.W. are embroidered on the inside."

	icon = 'icons/vore/custom_clothes_item.dmi'
	icon_state = "bowler"

	default_worn_icon = 'icons/vore/custom_clothes_mob.dmi'

//bwoincognito:Octavious Ward
/obj/item/clothing/mask/gas/plaguedoctor/fluff/octaviousmask
	name = "Customized Gas Mask"
	desc = "A customized gas mask to look like an old plague doctors, with a special looking lens in the left eye that turns on when in use."
	icon = 'icons/vore/custom_clothes_item.dmi'
	icon_state = "octplaguedoctor"
	item_icons = list(
		slot_wear_mask_str = 'icons/vore/custom_clothes_mob.dmi'
		)
	armor = list(melee = 0, bullet = 0, laser = 2,energy = 2, bomb = 0, bio = 90, rad = 0)
	body_parts_covered = HEAD|FACE|EYES

//bwoincognito:Octavious Ward
/obj/item/clothing/glasses/hud/health/octaviousmonicle
	name = "Gilded monocle"
	desc = "Avery expensive looking monocle inlaid with small gems around the gold frame. It has a thin leather cord running down to a clasp for attaching to ones coat. Probably not a good idea to steal this."
	icon = 'icons/vore/custom_clothes_item.dmi'
	icon_state = "clockworkgoggle_l"
	item_state_slots = null
	body_parts_covered = 0


/obj/item/clothing/shoes/black/cuffs
	name = "gilded leg wraps"
	desc = "Ankle coverings for digitigrade creatures. Gilded!"
	icon = 'icons/vore/custom_clothes_item.dmi'
	icon_state = "gildedcuffs"
	blocks_footsteps = FALSE

	default_worn_icon = 'icons/vore/custom_clothes_mob.dmi'

	body_parts_covered = 0

/obj/item/clothing/shoes/black/cuffs/red
	name = "red leg wraps"
	desc = "Ankle coverings for digitigrade creatures. Red!"
	icon_state = "redcuffs"

/obj/item/clothing/shoes/black/cuffs/blue
	name = "blue leg wraps"
	desc = "Ankle coverings for digitigrade creatures. Blue!"
	icon_state = "bluecuffs"

//bwoincognito:Octavious Ward
/obj/item/clothing/shoes/black/cuffs/octavious
	name = "silvered leg wraps"
	desc = "Dark leather leg wraps with sliver clasps on the sides. Stylish and functional."
	icon_state = "silvergildedcuffs"

//jemli:Jemli
/obj/item/clothing/head/fedora/fluff/jemli
	name = "Cavalier Hat"
	desc = "A smart, wide-brimmed hat with a rather fetching red feather in the brim. All for one, one for all."

	icon = 'icons/vore/custom_clothes_item.dmi'
	icon_state = "jemli_hat"

	default_worn_icon = 'icons/vore/custom_clothes_mob.dmi'

//virgo113:Verin Raharra
/obj/item/clothing/suit/storage/hazardvest/fluff/verin
	name = "Green Haz-coat"
	desc = "A well-worn green, long coat made with lightweight materials, it has a radioactive hazard icon on it's right sleeve. Smells faintly like sergal."
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 0, rad = 20)
	body_parts_covered = UPPER_TORSO|ARMS
	icon = 'icons/vore/custom_clothes_item.dmi'
	default_worn_icon = 'icons/vore/custom_clothes_mob.dmi'
	icon_state = "verin"

//whiskyrose:Vinjj
/obj/item/clothing/head/welding/fluff/vinjj
	name = "Vinjj's Stylish Bandana"
	desc = "A lovely blue and purple bandanna with a refined topaz hanging from its tail end, a pair of goggles are hidden underneath its fabric. Although for some strange reason, wearing this seems to inspire lewd thoughts."
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 0, rad = 0)
	icon = 'icons/vore/custom_clothes_item.dmi'
	default_worn_icon = 'icons/vore/custom_clothes_mob.dmi'
	item_icons = list(
		slot_l_hand_str = 'icons/vore/custom_clothes_mob.dmi',
		slot_r_hand_str = 'icons/vore/custom_clothes_mob.dmi',
		)
	icon_state = "vinjjdana"
	item_state_slots = list(slot_r_hand_str = "vinjjdana_r", slot_l_hand_str = "vinjjdana_l")
	flags_inv = (HIDEEYES)
	body_parts_covered = HEAD|EYES

/obj/item/clothing/head/welding/fluff/vinjj/toggle() //overriding this 'cause it only conceals the eyes - it's a hat, not a mask
	set category = "Object"
	set src in usr

	if(usr.canmove && !usr.stat && !usr.restrained())
		if(up)
			up = !up
			body_parts_covered |= (EYES)
			flags_inv |= (HIDEEYES)
			icon_state = "vinjjdana"
			to_chat(usr, "You flip the goggles down to protect your eyes.")
		else
			up = !up
			body_parts_covered &= ~(EYES)
			flags_inv &= ~(HIDEEYES)
			icon_state = "vinjjdanaup"

			to_chat(usr, "You push the goggles up out of your face.")
		update_clothing_icon()	//so our mob-overlays
		if (ismob(loc)) //should allow masks to update when it is opened/closed
			var/mob/M = loc
			M.update_inv_wear_mask()
		usr.update_mob_action_buttons()

//Vorrarkul: Theodora Lindt
/obj/item/clothing/suit/chococoat
	name = "Chococoat"
	desc = "A long coat designed to resemble Getmore Chocolate Corp's namesake chocolate bar wrapper." //A walking advertisement?
	icon = 'icons/vore/custom_clothes_item.dmi'
	default_worn_icon = 'icons/vore/custom_clothes_mob.dmi'
	item_state = "chococoat_on"
	icon_state = "chococoat"
	body_parts_covered = CHEST|ARMS
	allowed = list (/obj/item/material/knife)

//KiwiDaNinja: Chakat Taiga
/obj/item/clothing/under/fluff/taiga
	name = "Taiga's F.D Uniform"
	desc = "This uniform - consisting of only the uniform shirt, and built out of a soft fleece - dons the badge of Amistad Fire and Rescuse on both shoulders. The badges denote the wearer as a FF/" + JOB_PARAMEDIC + ", and their name is embroidered in a gold thread on their right breast; Chakat Taiga! An 'official' badge is pinned to their left breast." //A walking advertisement?
	icon = 'icons/vore/custom_clothes_item.dmi'
	default_worn_icon = 'icons/vore/custom_clothes_mob.dmi'
	item_state = "taigaff_on"
	icon_state = "taigaff" //Went ahead and made the det_corporate sprite fit.
/*
Departamental Swimsuits, for general use
*/

/obj/item/clothing/under/swimsuit/fluff
	name = DEVELOPER_WARNING_NAME
	icon = 'icons/vore/custom_clothes_item.dmi'
	default_worn_icon = 'icons/vore/custom_clothes_mob.dmi'
	siemens_coefficient = 1

/obj/item/clothing/under/swimsuit/fluff/engineering
	name = "Engineering Swimsuit"
	desc = "It's an orange high visibility swimsuit worn by engineers. It lacks radiation, or any, shielding."
	icon_state = "swimsuit_engineering"

/obj/item/clothing/under/swimsuit/fluff/science
	name = "Science Swimsuit"
	desc = "It's made of a special fiber that provides no protection whatsoever, but its hydrophobic. It has markings that denote the wearer as a scientist."
	icon_state = "swimsuit_science"

/obj/item/clothing/under/swimsuit/fluff/security
	name = "Security Swimsuit"
	desc = "It's made of a slightly sturdier material than standard swimsuits, to allow for a more robust appearance."
	icon_state = "swimsuit_security"

/obj/item/clothing/under/swimsuit/fluff/medical
	name = "Medical Swimsuit"
	desc = "It's made of a special fiber that provides no protection whatsoever, but its elastic. It has a cross on the back denoting that the wearer is trained medical personnel."
	icon_state = "swimsuit_medical"

//Xsdew:Penelope Allen
/obj/item/clothing/under/swimsuit/fluff/penelope
	name = "Penelope's Swimsuit"
	desc = "It's made of a special fiber that provides no protection whatsoever, but its elastic. This one was custom made for Penelope."
	icon_state = "swimsuit_penelope"

//Just some alt-uniforms themed around Star Trek - Pls don't sue, Mr Roddenberry ;_;
// PS. <3 Nienhaus

/obj/item/clothing/under/rank/trek
	name = "Section 31 Uniform"
	desc = "Oooh... right."

//TOS
/obj/item/clothing/under/rank/trek/command
	name = "Command Uniform"
	desc = "The uniform worn by command officers in the mid 2260s."
	icon_state = "trek_command"
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 0, rad = 0) // Considering only staff heads get to pick it

/obj/item/clothing/under/rank/trek/engsec
	name = "Operations Uniform"
	desc = "The uniform worn by operations officers of the mid 2260s. You feel strangely vulnerable just seeing this..."
	icon_state = "trek_engsec"
	armor = list(melee = 10, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 0, rad = 0) // since they're shared between jobs and kinda moot.

/obj/item/clothing/under/rank/trek/medsci
	name = "MedSci Uniform"
	desc = "The uniform worn by medsci officers in the mid 2260s."
	icon_state = "trek_medsci"
	permeability_coefficient = 0.50
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 10, rad = 0) // basically a copy of vanilla sci/med

//TNG
/obj/item/clothing/under/rank/trek/command/next
	desc = "The uniform worn by command officers. This one's from the mid 2360s."
	icon_state = "trek_next_command"

/obj/item/clothing/under/rank/trek/engsec/next
	desc = "The uniform worn by operation officers. This one's from the mid 2360s."
	icon_state = "trek_next_engsec"

/obj/item/clothing/under/rank/trek/medsci/next
	desc = "The uniform worn by medsci officers. This one's from the mid 2360s."
	icon_state = "trek_next_medsci"

//ENT
/obj/item/clothing/under/rank/trek/command/ent
	desc = "The uniform worn by command officers of the 2140s."
	icon_state = "trek_ent_command"

/obj/item/clothing/under/rank/trek/engsec/ent
	desc = "The uniform worn by operations officers of the 2140s."
	icon_state = "trek_ent_engsec"

/obj/item/clothing/under/rank/trek/medsci/ent
	desc = "The uniform worn by medsci officers of the 2140s."
	icon_state = "trek_ent_medsci"

//VOY
/obj/item/clothing/under/rank/trek/command/voy
	desc = "The uniform worn by command officers of the 2370s."
	icon_state = "trek_voy_command"

/obj/item/clothing/under/rank/trek/engsec/voy
	desc = "The uniform worn by operations officers of the 2370s."
	icon_state = "trek_voy_engsec"

/obj/item/clothing/under/rank/trek/medsci/voy
	desc = "The uniform worn by medsci officers of the 2370s."
	icon_state = "trek_voy_medsci"

//DS9
/obj/item/clothing/suit/storage/trek/ds9
	name = "Padded Overcoat"
	desc = "The overcoat worn by all officers of the 2380s."
	icon = 'icons/inventory/suit/item.dmi'
	default_worn_icon = 'icons/inventory/suit/mob.dmi'
	icon_state = "trek_ds9_coat"
	body_parts_covered = CHEST|ARMS
	permeability_coefficient = 0.50

	allowed = list(POCKET_GENERIC, POCKET_EMERGENCY, POCKET_SUIT_REGULATORS, POCKET_ENGINEERING, POCKET_MEDICAL)
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 0, rad = 0)

/obj/item/clothing/suit/storage/trek/ds9/admiral // Only for adminuz
	name = "Admiral Overcoat"
	desc = "Admirality specialty coat to keep flag officers fashionable and protected."
	icon_state = "trek_ds9_coat_adm"
	armor = list(melee = 45, bullet = 35, laser = 35, energy = 20, bomb = 0, bio = 40, rad = 55)

/obj/item/clothing/under/rank/trek/command/ds9
	desc = "The uniform worn by command officers of the 2380s."
	icon_state = "trek_command" // no unique state for this one
	item_state = "trek_ds9_command"

/obj/item/clothing/under/rank/trek/engsec/ds9
	desc = "The uniform worn by operations officers of the 2380s."
	icon_state = "trek_engsec" // no unique state for this one
	item_state = "trek_ds9_engsec"

/obj/item/clothing/under/rank/trek/medsci/ds9
	desc = "The uniform undershit worn by medsci officers of the 2380s."
	icon_state = "trek_medsci" // no unique state for this one
	item_state = "trek_ds9_medsci"

//For general use maybe
/obj/item/clothing/under/batter //I guess we're going OFF limits.
	name = "Worn baseball outfit"
	desc = span_bold("Purification in progress...")
	icon = 'icons/vore/custom_clothes_item.dmi'
	default_worn_icon = 'icons/vore/custom_clothes_mob.dmi'
	icon_state = "batter"

/obj/item/clothing/suit/storage/hooded/wintercoat/jessie
	name = "Handmade Winter Suit"
	desc = "A durable, but somewhat ragged lower portion of a snow suit fitted for a wolftaur."
	icon = 'icons/mob/taursuits_wolf.dmi'
	icon_state = "jessiecoat"

/obj/item/clothing/suit/storage/hooded/wintercoat/jessie/mob_can_equip(var/mob/living/carbon/human/H, slot, disable_warning = 0)
	if(..())
		if(istype(H) && istype(H.tail_style, /datum/sprite_accessory/tail/taur/wolf))
			return ..()
		else
			to_chat(H, span_warning("You need to have a wolf-taur half to wear this."))
			return 0

//samanthafyre:Kateryna Petrovitch
/obj/item/clothing/suit/armor/vest/wolftaur/kate
	name = "Kat's Fox Taur Armor"
	desc = "A set of security armor, light weight and easy to run in for a Taur, this item protects the \
	entire body."
	icon = 'icons/mob/taursuits_wolf.dmi'
	icon_state = "katesuit"
	item_state_slots = null

/obj/item/clothing/suit/armor/vest/wolftaur/kate/mob_can_equip(var/mob/living/carbon/human/H, slot, disable_warning = 0)
	if(..())
		if(istype(H) && istype(H.tail_style, /datum/sprite_accessory/tail/taur/wolf))
			return ..()
		else
			to_chat(H, span_warning("You need to have a wolf-taur half to wear this."))
			return 0

//samanthafyre:Kateryna Petrovitch
/obj/item/clothing/suit/space/void/engineering/kate
	name = "Kat's Navy Engineer voidsuit"
	desc = "Taur engineering voidsuit. Recolored navy blue and white. Slightly tweaked as well to \
	get close to having security voidsuit protection as possible with a slight reduction in movement \
	speed to compensate for custom padding and armor Kateryna made herself."
	icon = 'icons/mob/taursuits_wolf.dmi'
	icon_state = "lilithsuit"
	species_restricted = null
	armor = list(melee = 40, bullet = 20, laser = 20,energy = 5, bomb = 35, bio = 100, rad = 20)

//samanthafyre:Kateryna Petrovitch
/obj/item/clothing/head/helmet/space/fluff/kate
	name = "Kat's Navy Engineer Helmet"
	desc = "A customized combat space helmet made for Kateryna. It uses a navy design as the base before it\
	was customized to suit the wearer's personality."
	icon = 'icons/vore/custom_clothes_item.dmi'
	icon_state = "lilithhelmet"
	default_worn_icon = 'icons/vore/custom_clothes_mob.dmi'
	light_overlay = "helmet_light"
	species_restricted = null

/obj/item/clothing/head/helmet/space/fluff/kate/mob_can_equip(var/mob/living/carbon/human/H, slot, disable_warning = 0)
	if(..())
		if(H.ckey != "samanthafyre")
			to_chat(H, span_warning("You try to fit on the helmet, but it doesn't fit."))
			return 0
		else
			return 1

//Seiga: Alfonso Oak Telanor
/obj/item/clothing/glasses/sunglasses/fluff/alfonso
	name = "cyborg visor"
	desc = "Eyewear worn by a once famous Thunderdome competitor. Fo' shizzle."
	icon = 'icons/vore/custom_clothes_item.dmi'
	icon_state = "alfonso_visor"
	default_worn_icon = 'icons/vore/custom_clothes_mob.dmi'

//JackNoir413: Mor Xaina
/obj/item/clothing/under/fluff/morunder
	name = "grey top with shorts"
	desc = "Fashionable grey top, combined with black shorts. Fancy!"
	icon = 'icons/vore/custom_clothes_item.dmi'
	icon_state = "morunder"
	default_worn_icon = 'icons/vore/custom_clothes_mob.dmi'

//JackNoir413: Mor Xaina
/obj/item/clothing/gloves/fluff/morsleeves
	name = "fingerless sleeves"
	desc = "Cute long armwarmers. Sadly, they don't cover fingers."
	icon = 'icons/vore/custom_clothes_item.dmi'
	icon_state = "morsleeves"
	default_worn_icon = 'icons/vore/custom_clothes_mob.dmi'

//JackNoir413: Mor Xaina
/obj/item/clothing/shoes/fluff/morthighs
	name = "long grey socks"
	desc = "Striped, soft thigh-high socks with no fingers. Must be hard to wash them..."
	icon = 'icons/vore/custom_clothes_item.dmi'
	icon_state = "morthighs"
	default_worn_icon = 'icons/vore/custom_clothes_mob.dmi'

//Jackets For General Use. Sprited by Joji.
/obj/item/clothing/suit/storage/fluff/jacket //Not the toggle version since it uses custom toggle code to update the on-mob icon.
	name = "Field Jacket"
	desc = "A standard Earth military field jacket made of comfortable cotton."

	icon = 'icons/vore/custom_clothes_item.dmi'
	icon_state = "fjacket"

	default_worn_icon = 'icons/vore/custom_clothes_mob.dmi'
	var/unbuttoned = FALSE

/obj/item/clothing/suit/storage/fluff/jacket/verb/toggle()
	set name = "Toggle coat buttons"
	set category = "Object"
	set src in usr

	if(!usr.canmove || usr.stat || usr.restrained())
		return FALSE

	if(unbuttoned)
		icon_state = "[initial(icon_state)]"
		item_state = "[initial(item_state)]"
		unbuttoned = FALSE
		to_chat(usr, "You button up the coat.")
	else
		icon_state = "[initial(icon_state)]_open"
		item_state = "[initial(item_state)]_open"
		unbuttoned = TRUE
		to_chat(usr, "You unbutton the coat.")
	usr.update_inv_wear_suit()

/obj/item/clothing/suit/storage/fluff/jacket/field //Just here so it can be seen and easily recognized under /spawn.
	name = "Field Jacket"

/obj/item/clothing/suit/storage/fluff/jacket/air_cavalry
	name = "Air Cavalry Jacket"
	desc = "A jacket worn by the 1st Cavalry Division on Earth."

	icon = 'icons/vore/custom_clothes_item.dmi'
	icon_state = "acjacket"

	default_worn_icon = 'icons/vore/custom_clothes_mob.dmi'

/obj/item/clothing/suit/storage/fluff/jacket/air_force
	name = "Air Force Jacket"
	desc = "A jacket worn by the Earth Air Force."

	icon = 'icons/vore/custom_clothes_item.dmi'
	icon_state = "afjacket"

	default_worn_icon = 'icons/vore/custom_clothes_mob.dmi'

/obj/item/clothing/suit/storage/fluff/jacket/navy
	name = "Navy Jacket"
	desc = "A jacket worn by the Earth's Navy. It's adorned with reflective straps."

	icon = 'icons/vore/custom_clothes_item.dmi'
	icon_state = "navyjacket"

	default_worn_icon = 'icons/vore/custom_clothes_mob.dmi'

/obj/item/clothing/suit/storage/fluff/jacket/special_forces
	name = "Special Forces Jacket"
	desc = "A durable jacket worn by the Earth's special forces."

	icon = 'icons/vore/custom_clothes_item.dmi'
	icon_state = "sfjacket"

	default_worn_icon = 'icons/vore/custom_clothes_mob.dmi'

//General use
/obj/item/clothing/head/fluff/headbando
	name = "basic headband"
	desc = "Perfect for martial artists, sweaty rogue operators, and tunnel gangsters."

	icon = 'icons/vore/custom_items_vr.dmi'
	icon_state = "headbando"

	default_worn_icon = 'icons/vore/custom_clothes_mob.dmi'

/obj/item/clothing/suit/storage/fluff/gntop
	name = "GN crop jacket"
	desc = "A nifty little jacket. At least it keeps your shoulders warm."
	icon = 'icons/vore/custom_items_vr.dmi'
	icon_state = "gntop"
	default_worn_icon = 'icons/vore/custom_clothes_mob.dmi'

/obj/item/clothing/under/fluff/gnshorts
	name = "GN shorts"
	desc = "Stylish white shorts with pockets, stripes, and even a belt."
	icon = 'icons/vore/custom_items_vr.dmi'
	icon_state = "gnshorts"
	default_worn_icon = 'icons/vore/custom_clothes_mob.dmi'

/obj/item/clothing/under/fluff/v_nanovest
	name = "Varmacorp nanovest"
	desc = "A nifty little vest optimized for nanite contact."
	icon = 'icons/vore/custom_clothes_item.dmi'
	icon_state = "nanovest"
	default_worn_icon = 'icons/vore/custom_clothes_mob.dmi'

//General use
/obj/item/clothing/suit/storage/fluff/loincloth
	name = "Loincloth"
	desc = "A primitive piece of oak-brown clothing wrapped firmly around the waist. A few bones line the edges. Comes with a primitive outfit to boot."

	icon = 'icons/vore/custom_clothes_item.dmi'
	icon_state = "loincloth"

	default_worn_icon = 'icons/vore/custom_clothes_mob.dmi'

//BeyondMyLife: Ne'tra Ky'ram
/obj/item/clothing/suit/storage/hooded/wintercoat/kilanocoat
	name = "black and gold armoured coat."
	desc = "A black and gold coat, with white fur lining, lined with some kind of heavier material inside, seemingly giving some sort of padding to it."
	icon = 'icons/vore/custom_clothes_item.dmi'
	icon_state = "kilanocoat"
	item_state_slots = list(slot_r_hand_str = "kilanocoat", slot_l_hand_str = "kilanocoat")
	armor = list(melee = 40, bullet = 30, laser = 30, energy = 10, bomb = 10, bio = 0, rad = 0)

	default_worn_icon = 'icons/vore/custom_clothes_mob.dmi'
	//hoodtype = ??? //Needs a hoodtype to be created for it.
	has_hood_sprite = TRUE


//BeyondMyLife: Ne'tra Ky'ram
/obj/item/clothing/under/fluff/kilanosuit
	name = "black and gold armourweave dress"
	desc = "A black and gold patterned silky dress, with some kind of inlined, heavier material lining the skirt and chest area."
	icon = 'icons/vore/custom_clothes_item.dmi'
	default_worn_icon = 'icons/vore/custom_clothes_mob.dmi'
	icon_state = "kilanosuit"
	armor = list(melee = 10, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 0, rad = 0)
	siemens_coefficient = 0.9

//BeyondMyLife: Ne'tra Ky'ram
/obj/item/storage/backpack/messenger/sec/fluff/kilano
	name = "Ne'tra's security bag"
	desc = "A security Satchel containing Ne'tra Ky'rams Security gear."

//BeyondMyLife: Ne'tra Ky'ram
/obj/item/storage/belt/security/fluff/kilano
	name = "black and gold security belt"
	desc = "A Black and Gold security belt, somewhat resembling something you must've seen in a comic years ago."
	icon = 'icons/vore/custom_clothes_item.dmi'
	icon_state = "kilanobelt"
	default_worn_icon = 'icons/vore/custom_clothes_mob.dmi'

//BeyondMyLife: Ne'tra Ky'ram
/obj/item/clothing/gloves/fluff/kilano/netra
	name = "black and gold dress gloves"
	desc = "Some fancy looking black and gold patterned gloves made of a silky material."
	icon = 'icons/vore/custom_clothes_item.dmi'
	icon_state = "kilanogloves" //TODO: White sprite.
	default_worn_icon = 'icons/vore/custom_clothes_mob.dmi'
	species_restricted = null

//BeyondMyLife: Ne'tra Ky'ram
/obj/item/clothing/shoes/boots/fluff/kilano
	name = "black and gold winter boots"
	desc = "Some Fur lined black and gold heavy duty winter bots."
	icon = 'icons/vore/custom_clothes_item.dmi'
	icon_state = "kilanoboots"
	default_worn_icon = 'icons/vore/custom_clothes_mob.dmi'
	species_restricted = null
	cold_protection = FEET|LEGS
	min_cold_protection_temperature = SHOE_MIN_COLD_PROTECTION_TEMPERATURE
	heat_protection = FEET|LEGS
	max_heat_protection_temperature = SHOE_MAX_HEAT_PROTECTION_TEMPERATURE
	armor = list(melee = 30, bullet = 10, laser = 10, energy = 15, bomb = 20, bio = 0, rad = 0)

//BeyondMyLife: Ne'tra Ky'ram
/obj/item/clothing/accessory/storage/black_vest/fluff/kilano
	name = "black and gold webbing vest"
	desc = "A black and gold webbing vest, it looks like a child spilled a box of crayons all over it."
	icon = 'icons/vore/custom_clothes_item.dmi'
	icon_state = "kilanovest"
	default_worn_icon = 'icons/vore/custom_clothes_mob.dmi'

//BeyondMyLife:Kilano Soryu //Moved these for orginization purposes.
/obj/item/clothing/under/dress/fluff/kilano
	name = "Bleached Dress"
	desc = "It appears that this was once a captain's dress, it's blueish color has been turned white by bleach, only the gold markings remain to slightly signify what it once was."

	icon = 'icons/vore/custom_clothes_item.dmi'
	icon_state = "kilanodress"

	default_worn_icon = 'icons/vore/custom_clothes_mob.dmi'

	species_restricted = null
	body_parts_covered = CHEST|ARMS

//BeyondMyLife:Kilano Soryu
/obj/item/clothing/gloves/fluff/kilano
	name = "Bleached Gloves"
	desc = "Some old captain's gloves, bleached white, almost unrecognizable from the color change besides the gold trim."

	icon = 'icons/vore/custom_clothes_item.dmi'
	icon_state = "kilanogloves"

	default_worn_icon = 'icons/vore/custom_clothes_mob.dmi'
	species_restricted = null

//BeyondMyLife: Cassandra Selones
/obj/item/clothing/shoes/boots/fluff/kilano/purple
	name = "purple and silver winter boots"
	desc = "Some fur lined boots, purple and silver."
	icon_state = "winterboots_cap_p"

//BeyondMyLife: Cassandra Selones
/obj/item/clothing/gloves/fluff/kilano/purple
	name = "purple and silver gloves"
	desc = "A purple pair of gloves, replicating the usual captains gloves, with odd oriental, and foriegn patterns in it, and silver lining replacing the usual gold."
	icon_state = "kilanogloves_p"

//BeyondMyLife: Cassandra Selones
/obj/item/clothing/under/fluff/kilanosuit/purple
	name = "purple and silver dress uniform"
	desc = "A royal purple dress, replicating the usual captains dress, made of the same glossy/silky material, with odd oriental and foriegn patterns on it, silver lined too!"
	icon_state = "kilanosuit_p"

//Mewchild: Phi Vietsi
/obj/item/clothing/accessory/ring/seal/signet/fluff/phi
	name = "Phi's Bone Signet Ring"
	desc = "A signet ring belonging to Phi, carved from the bones of something long extinct, as a ward against bad luck."

	icon = 'icons/vore/custom_clothes_item.dmi'
	icon_state = "phi_ring"

/obj/item/clothing/accessory/ring/seal/signet/fluff/phi/change_name(var/signet_name = "Unknown")
	name = "[signet_name]'s Bone Signet Ring"
	desc = "A signet ring belonging to [signet_name], carved from the bones of something long extinct, as a ward against bad luck."

//KotetsuRedwood:Latex Maid Dresses, for everyone to 'enjoy'. :3c
/obj/item/clothing/under/fluff/latexmaid
	name = "latex maid dress"
	desc = "Squeak! A shiny outfit for cleaning, made by people with dirty minds."

	icon = 'icons/vore/custom_clothes_item.dmi'
	icon_state = "latexmaid"
	default_worn_icon = 'icons/vore/custom_clothes_mob.dmi'

	sprite_sheets = list(
			SPECIES_TESHARI = 'icons/vore/custom_clothes_tesh_vr.dmi'
			)
	body_parts_covered = CHEST

//Aztectornado:Tron inspired Siren outfit
/obj/item/clothing/under/fluff/siren
	name = "Siren Jumpsuit"
	desc = "An advanced jumpsuit with inlaid neon highlighting, and a port on the back."
	description_fluff = "Unlike other competitor suits, the Ward Takahashi Siren jumpsuit features a whole host of extra sensors for augmented reality use, and features a non-invasive neural sensor/stimulator for a fully immersive experience."

	icon = 'icons/vore/custom_clothes_item.dmi'
	default_worn_icon = 'icons/vore/custom_clothes_mob.dmi'
	icon_state = "tronsiren"
	rolled_sleeves = 0

/obj/item/clothing/gloves/fluff/siren
	name = "Siren Gloves"
	desc = "A set of white and neon blue gloves."
	description_fluff = "Like its jumpsuit companion, the Ward Takahashi Siren gloves feature multiple sensors for usage in augmented reality. The gloves operate fine even without a paired jumpsuit, offering optimal AR menu control and haptic feedback."

	icon = 'icons/vore/custom_clothes_item.dmi'
	default_worn_icon = 'icons/vore/custom_clothes_mob.dmi'
	icon_state = "tronsiren_gloves"

/obj/item/clothing/shoes/boots/fluff/siren
	name = "Siren Boots"
	desc = "A set of white boots with neon lighting."
	description_fluff = "Unlike the rest of the Ward Takahashi Siren lineup, the boots are simply boots. However, they go great with the rest of the outfit, and are quite comfortable."

	icon_state = "tronsiren_shoes"
	icon = 'icons/vore/custom_clothes_item.dmi'
	default_worn_icon = 'icons/vore/custom_clothes_mob.dmi'

/obj/item/clothing/head/helmet/space/void/security/hasd
	name = "HASD EVA faceplate"
	desc = "It's a faceplate that slots into the HASD EVA bodyplate assembly. Functionally useless alone."

	icon = 'icons/vore/custom_clothes_item.dmi'
	icon_state = "hasd_helm"

	default_worn_icon = 'icons/vore/custom_clothes_mob.dmi'
	species_restricted = null

/obj/item/clothing/head/helmet/space/void/security/hasd/mob_can_equip(var/mob/living/carbon/human/H, slot, disable_warning = 0)
	if(..())
		if(H.ckey != "silencedmp5a5")
			to_chat(H, span_warning("...The faceplate is clearly not made for your anatomy, thus, does not fit."))
			return 0
		else
			return 1

/obj/item/clothing/suit/space/void/security/hasd
	name = "HASD EVA bodyplates"
	armor = list(melee = 0, bullet = 0, laser = 0, energy = 0, bomb = 0, bio = 0, rad = 0)
	desc = "A series of armor plates painted black, deployed from a back-mounted module. They fit smoothly over the unit's armor plates and projects a skintight bubble shield over the unit's uncovered parts. Faceplate and coolant unit not included."
	species_restricted = null
	icon = 'icons/mob/taursuits_lizard.dmi'
	icon_state = "hasd_suit"
	pixel_x = -16

/obj/item/clothing/suit/space/void/security/hasd/mob_can_equip(var/mob/living/carbon/human/H, slot, disable_warning = 0)
	if(..() && istype(H) && H.ckey == "silencedmp5a5")
		return 1
	else
		to_chat(H, span_warning("This suit is not designed for you."))
		return 0

//Zigfe:Zaoozaoo Xrimxuqmqixzix
/obj/item/clothing/head/fluff/zao
	name = "Zao's Hat"
	desc = "A black hat that has an uncanny similarity to the HoS's hat. There's a small letter Z sewn on the inside of the brim."

	icon = 'icons/vore/custom_clothes_item.dmi'
	icon_state = "zao_cap"

	default_worn_icon = 'icons/vore/custom_clothes_mob.dmi'

//Nepox:Annie Rose
/obj/item/clothing/accessory/sweater/fluff/annie
	name = "Lazy Annie's Lazy Sweater"
	desc = "A cozy sweater that's probably far too long for it's owner.  She's too lazy to care though."

	icon = 'icons/vore/custom_clothes_item.dmi'
	icon_state = "sweater_annie"
	icon_override = 'icons/vore/custom_clothes_mob.dmi'

	slot_flags = SLOT_OCLOTHING | SLOT_TIE
	body_parts_covered = CHEST|ARMS
	w_class = ITEMSIZE_NORMAL
	slot = ACCESSORY_SLOT_OVER

//General definition for bracer items. No icons.
/obj/item/clothing/accessory/bracer
	name = DEVELOPER_WARNING_NAME // "bracer"
	desc = "A bracer."
	icon_state = null
	item_state = null
	default_worn_icon = null
	slot_flags = SLOT_GLOVES | SLOT_TIE
	w_class = ITEMSIZE_SMALL
	slot = ACCESSORY_SLOT_ARMBAND

//AegisOA:Xander Bevin
//WanderingDeviant:S'thasha Tavakdavi
/obj/item/clothing/accessory/bracer/fluff/xander_sthasha
	name = "Plasteel Bracer"
	desc = "A sturdy arm-guard of polished plasteel that sports gold trimming, silver tribal-looping etchings, and a single cut diamond set into its side. Attached to one's forearm with a small, magnetic clasp."
	icon = 'icons/vore/custom_items_vr.dmi'
	icon_state = "bracer_xander_sthasha"
	default_worn_icon = 'icons/vore/custom_clothes_mob.dmi'

/obj/item/clothing/accessory/bracer/fluff/xander_sthasha/digest_act(var/atom/movable/item_storage = null)
	return FALSE

/obj/item/clothing/accessory/bracer/fluff/xander_sthasha/gurgle_contaminate(var/atom/movable/item_storage = null)
	return FALSE

//Heroman3003:Lauren Zackson
/obj/item/clothing/accessory/collar/fluff/goldenstring
	name = "golden string"
	desc = "It appears to just be a length of gold-colored string attached to a simple plastic clasp, meant to be worn around the neck"
	icon = 'icons/vore/custom_items_vr.dmi'
	default_worn_icon = 'icons/vore/custom_clothes_mob.dmi'
	icon_state = "goldenstring"
	w_class = ITEMSIZE_TINY
	slot_flags = SLOT_TIE

//Chaoko99: Aika Hisakawa
/obj/item/clothing/suit/fluff/blue_trimmed_coat
	name = "blue-trimmed greatcoat"
	desc = "A heavy, form-obscuring coat with gilded buttons and azure trim."
	icon = 'icons/vore/custom_clothes_item.dmi'
	icon_state = "aika_coat"

	default_worn_icon = 'icons/vore/custom_clothes_mob.dmi'
	flags_inv = HIDEJUMPSUIT | HIDETIE

	item_icons = list(
		slot_l_hand_str = 'icons/vore/custom_clothes_mob.dmi',
		slot_r_hand_str = 'icons/vore/custom_clothes_mob.dmi',
		)
	item_state_slots = list(slot_r_hand_str = "aika_coat_r", slot_l_hand_str = "aika_coat_l")

//Burrito Justice: Jayda Wilson
/obj/item/clothing/under/solgov/utility/sifguard/medical/fluff
	desc = "The utility uniform of the Terran Commonwealth Explorer Corps, made from biohazard resistant material. This is an older issuing of the uniform, with integrated department markings."

	icon = 'icons/vore/custom_clothes_item.dmi'
	default_worn_icon = 'icons/vore/custom_clothes_mob.dmi'

	icon_state = "blackutility_med"
	worn_state = "blackutility_med"

	rolled_down = 0
	rolled_sleeves = 0
	starting_accessories = null

//Vorrarkul: Melanie Farmer
/obj/item/clothing/under/fluff/slime_skeleton
	name = "Melanie's Skeleton"
	desc = "The skeleton of a promethean, still covered in residual slime. Upon closer inspection, they're not even real bones!"

	icon = 'icons/vore/custom_clothes_item.dmi'
	default_worn_icon = 'icons/vore/custom_clothes_mob.dmi'

	icon_state = "melanie_skeleton"

	body_parts_covered = 0

	species_restricted = list("exclude", SPECIES_TESHARI)

/obj/item/clothing/under/fluff/slime_skeleton/mob_can_equip(M as mob, slot, disable_warning = FALSE)
	if(!..())
		return 0

	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(!(H.get_species() == SPECIES_PROMETHEAN))	//Only wearable by slimes, since species_restricted actually checks bodytype, not species
			return 0

	return 1

/obj/item/clothing/under/fluff/slime_skeleton/digest_act(var/atom/movable/item_storage = null)
	return FALSE	//Indigestible

//Bacon12366:Elly Brown
/obj/item/clothing/suit/storage/star
	name = "Star hoodie"
	desc = "It's a black long hoodie with a big blue star at the chest area. It's made of pretty soft material."
	icon = 'icons/vore/custom_clothes_item.dmi'
	icon_state = "star_hoodie"
	default_worn_icon = 'icons/vore/custom_clothes_mob.dmi'

//KillerDragn:Excess
/obj/item/clothing/accessory/collar/pink/fluff/warning
	name = "Warning Collar (AGGRESSIVE)"
	desc = "A bright red warning collar with white text - \"AGGRESSIVE\"."

//KillerDragn:Excess
/obj/item/clothing/under/fluff/excess
	name = "XS-21E Labeled Latex Clothing"
	desc = "A latex navy blue tube-top and matching compression shorts, with a bright yellow stripe down the side. \"XS-21E\" is written on the thigh. \"Warning\" is written in yellow by the stripe on the top."
	body_parts_covered = CHEST
	icon = 'icons/vore/custom_clothes_item.dmi'
	icon_state = "latex_clothes"
	default_worn_icon = 'icons/vore/custom_clothes_mob.dmi'
	color = COLOR_NAVY
	sprite_sheets = null

//SweetBlueSylveon:Pip Shyner
/obj/item/clothing/accessory/poncho/roles/cloak/hop/fluff/pip
	name = "Pip's Cloak"
	desc = "A brightly colored cloak, similar in pattern to the CRO's cloak. It's colored White, Pink, and Blue, with Gold buttons."
	icon = 'icons/vore/custom_clothes_item.dmi'
	icon_state = "pipcloak"
	item_state = "pipcloak"
	default_worn_icon = 'icons/vore/custom_clothes_mob.dmi'
	icon_override = 'icons/vore/custom_clothes_mob.dmi'

/obj/item/clothing/accessory/poncho/roles/cloak/hop/fluff/pip/equipped()
	..()
	var/mob/living/carbon/human/H = loc
	if(istype(H) && H.wear_suit == src)
		icon_override = 'icons/vore/custom_clothes_mob.dmi'
	update_clothing_icon()

/obj/item/clothing/accessory/poncho/roles/cloak/hop/fluff/pip/dropped()
	..()
	icon_override = 'icons/vore/custom_clothes_mob.dmi'

//CappyCat:Cappy Fuzzlyfeathers
/obj/item/clothing/accessory/watch/custom
	name = "silver pocket watch"
	desc = "A fancy silver-plated digital pocket watch. Looks expensive."
	icon = 'icons/obj/deadringer.dmi'
	icon_state = "deadringer"
	w_class = ITEMSIZE_SMALL
	slot = ACCESSORY_SLOT_INSIGNIA
	slot_flags = SLOT_ID | SLOT_BELT | SLOT_TIE

//Pimientopyro:Zaku Fyodorovna
/obj/item/clothing/suit/varsity/green/sweater_vest
	name = "green sweater vest"
	desc = "A green argyle sweater vest with a white undershirt, a must for long winter nights and looking like a dork."

//Azura Chitin: Azura Chitin
/obj/item/clothing/accessory/collar/azura
	name = "Azura's collar"
	desc = "A black collar with green patterns, reminiscent of tribal tattoos. Regardless of what the front of the tag says, the back of it reads \"Azura Chitin\"."
	icon = 'icons/vore/custom_items_vr.dmi'
	icon_state = "azuracollar"

	default_worn_icon = 'icons/vore/custom_clothes_mob.dmi'


//Xonkon: Zena Aviv
/obj/item/clothing/head/helmet/space/void/engineering/zena
	name = "custom shroud helmet"
	desc = "A black and orange engineering shroud helmet. Orange plated and specially crafted and augmented for a variety of activites."
	icon = 'icons/vore/custom_clothes_item.dmi'
	icon_state = "zenahelmet"

	default_worn_icon = 'icons/vore/custom_clothes_mob.dmi'

	species_restricted = null


/obj/item/clothing/suit/space/void/engineering/zena
	name = "custom shroud suit"
	desc = "A black and orange engineering shroud helmet. Skintight and specially crafted and augmented for a variety of activites."
	icon = 'icons/vore/custom_clothes_item.dmi'
	icon_state = "zenasuit"

	default_worn_icon = 'icons/vore/custom_clothes_mob.dmi'

	species_restricted = null

/obj/item/clothing/suit/storage/flintlock
	name = "green jacket"
	desc = "Flintlock's green jacket. It seems to be made of rather high quality leather."
	icon = 'icons/vore/custom_clothes_item.dmi'
	icon_state = "flintlock"
	item_state_slots = list(slot_r_hand_str = "item_greensuit", slot_l_hand_str = "item_greensuit")
	blood_overlay_type = "coat"
	body_parts_covered = UPPER_TORSO|ARMS
	flags_inv = HIDEHOLSTER

	default_worn_icon = 'icons/vore/custom_clothes_mob.dmi'

//BobOfBoblandia: Charles Gettler
/obj/item/clothing/head/that/fluff/gettler
	name = "Charles' Top-Hat"
	desc = "A special hat, removed from its owner."

//Ryumi: Nikki Yumeno
/obj/item/clothing/under/skirt/outfit/fluff/nikki
	name = "dorky outfit"
	desc = "A little witch costume that looks like it's been worn as ordinary clothes. Who in their right mind would...??"
	icon = 'icons/vore/custom_clothes_item.dmi'
	default_worn_icon = 'icons/vore/custom_clothes_mob.dmi'
	icon_state = "nikki_outfit"
	sensor_mode = 3 // I'm a dumbass and forget these all the time please understand :(

/obj/item/clothing/under/skirt/outfit/fluff/nikki/mob_can_equip(var/mob/living/carbon/human/M, slot, disable_warning = 0)
	if(..())
		if (M.ckey == "ryumi")
			return 1
		else if (M.get_active_hand() == src)
			to_chat(M, span_warning("What the heck? \The [src] doesn't fit!"))
			return 0

/obj/item/clothing/shoes/fluff/nikki
	name = "non-magical boots"
	desc = "Boots optimally built for a dork. They don't sparkle or anything, but you can imagine them doing that when you click the heels together."
	icon = 'icons/vore/custom_clothes_item.dmi'
	default_worn_icon = 'icons/vore/custom_clothes_mob.dmi'
	icon_state = "nikki_boots"

/obj/item/clothing/shoes/fluff/nikki/mob_can_equip(var/mob/living/carbon/human/M, slot, disable_warning = 0)
	if(..())
		if (M.ckey == "ryumi")
			return 1
		else if (M.get_active_hand() == src)
			to_chat(M, span_warning("What the heck? \The [src] doesn't fit!"))
			return 0

/obj/item/clothing/suit/fluff/nikki //see /obj/item/rig/nikki
	name = "cape"
	desc = "Snazzy!"
	flags = NONE
	armor = list(melee = 0, bullet = 0, laser = 0, energy = 0, bomb = 0, bio = 0, rad = 0) // It's not armor, it's a dorky frickin cape
	body_parts_covered = null // Cape ain't gonna cover a THING
	cold_protection = CHEST|ARMS // It will keep you toasty tho, it's more than big enough to help with that! Just wrap the thing around you when on the surface, idk
	icon = 'icons/vore/custom_clothes_item.dmi'
	default_worn_icon = 'icons/vore/custom_clothes_mob.dmi'
	icon_state = "nikkicape"

/obj/item/clothing/head/fluff/nikki
	// I have never tryharded so much just to accomplish something so stupid as "Vore By Hat" in my entire life, and I apologize to each and every one of you.
	name = "oversized witch hat"
	desc = "A dork-shaped hat. Its long, pointed tip reaches far more than most hats had ought to, its wide brim complementing \
	this with its tendency to droop at the ends under its own weight."
	description_fluff = "Despite what Nikki Yumeno may believe, her hat is not in fact a magical artifact of teleportation magicks. \
	It is however the result of clever utilization of bluespace technology combined with style. Like a classic magician's trick, \
	the power of this hat lies in the hidden compartment hidden on the inside, into which a personal translocation device can be \
	snapped inside. Once installed, bluespace electronics inside the hat sync with the translocator and utilize its teleportation \
	technology to create a localized bluespace portal within the hole of the hat. This tiny portal will warp anything or anyone \
	who makes physical contact with it to whatever beacon the translocator within is locked onto."
	icon = 'icons/vore/custom_clothes_item.dmi'
	icon_state = "nikki-hat"
	item_icons = list(
		slot_l_hand_str = 'icons/vore/custom_clothes_left_hand_vr.dmi',
		slot_r_hand_str = 'icons/vore/custom_clothes_right_hand_vr.dmi',
		slot_head_str = 'icons/vore/custom_onmob_32x48_vr.dmi'
		)
	flags_inv = HIDEEARS
	w_class = ITEMSIZE_LARGE // THIS HAT IS FUCKIN HUGE YO
	var/owner = "ryumi"
	var/obj/item/perfect_tele/translocator = null // The translocator installed inside, if there is one. Gotta go out and get it first!

/obj/item/clothing/head/fluff/nikki/verb/verb_translocator_unequip()
	set category = "Object"
	set name = "Nikki's Hat - Unequip Translocator"
	set src in usr
	translocator_unequip(translocator, usr)

/obj/item/clothing/head/fluff/nikki/proc/translocator_equip(var/obj/item/perfect_tele/T, var/mob/living/carbon/human/user)
	if (do_after(user, 2 SECONDS, target = T))
		user.unEquip(T)
		translocator_unequip(translocator, user)
		T.forceMove(src)
		translocator = T
		user.show_message("[icon2html(src, user.client)]*click!*")
		playsound(src, 'sound/machines/click.ogg', 30, 1)

/obj/item/clothing/head/fluff/nikki/proc/translocator_unequip(var/obj/item/perfect_tele/T, var/mob/living/carbon/human/user)
	if (translocator)
		if (user)
			user.put_in_hands(T)
			user.show_message("[icon2html(src, user.client)]*click!*")
		else
			translocator.forceMove(get_turf(src))
		translocator = null
		playsound(src, 'sound/machines/click.ogg', 30, 1)

/obj/item/clothing/head/fluff/nikki/proc/teleport_fail(mob/user, mob/target)
	if (target != user)
		user.visible_message(span_notice("[user] harmlessly bops [target] with \the [src]."), \
		span_notice("\The [src] harmlessly bops [target]. The hat seems... unwilling?"))
	else
		user.visible_message(span_bold("\The [src]") + " flops over [user]'s' head for a moment, but they seem alright.", \
		span_notice("\The [src] flops over your head for a moment, but you correct it without issue. There we go!"))

/obj/item/clothing/head/fluff/nikki/proc/hat_warp_checks(var/mob/living/target, mob/user, proximity_flag)
	if (!proximity_flag)
		return 0

	if (!translocator)
		to_chat(user, span_warning("\The [src] doesn't have a translocator inside it yet, you goof!"))
		return 0

	if (target.ckey == owner && target != user) // ur not getting me that easy sonny jim......
		to_chat(user, span_warning("You think to turn \the [src] on its creator?! <b>FOOOOOOOOL.</b>"))
		to_chat(user, span_notice("From seemingly nowhere you hear echoing, derisive laughter, accompanied by a stock laugh track and... Are those bike horns?"))
		return 0

	if (!istype(target))
		to_chat(user, span_warning("\The [src] isn't a valid target!"))
		return 0

	// Because other mobs (i.e. monkeys) apparently have dropnom prey set to 0, we check SPECIFICALLY for humans' dropnom setting.
	if (target.type == /mob/living/carbon/human && !target.can_be_drop_prey)
		teleport_fail(user, target)
		return 0

	if (!translocator.teleport_checks(target, user))
		return 0

	else return 1

/obj/item/clothing/head/fluff/nikki/attackby(obj/item/I as obj, mob/user as mob)
	if (istype(I, /obj/item/perfect_tele) && user.get_inactive_hand() == src)
		if (translocator)
			visible_message(span_notice("[user] starts to pull \a [translocator] out of \the [src] to swap it out with \the [I]..."), \
			span_notice("You start pulling \the [translocator] pops out of its compartment with a soft 'click' as you replace it with \the [I]...."))
		else
			visible_message(span_notice("[user] begins slipping \the [I] into \the [src]..."), \
			span_notice("You begin to snap \the [I] into a small, hidden compartment inside \the [src]..."))
		// This works for both adding and replacing a translocator
		translocator_equip(I, user)
		return
	else if (translocator)
		translocator.attackby(I, user)
		return
	..()

/obj/item/clothing/head/fluff/nikki/get_description_interaction()
	. = ..()
	if (translocator)
		. += "It has \a [translocator] inside of it. Alt-click while holding it on your inactive hand to remove it."
		. += "Otherwise, this hat functions exactly as the translocator it has inside while still being a sweet head accessory."
	else
		. += "A translocator can be placed inside of it! While holding the hat in your inactive hand, use a translocator on it to slip it inside."
		. += "After doing this, it will function as both a head accessory and teleportation device."


/obj/item/clothing/head/fluff/nikki/attack_hand(mob/user)
	if (translocator && (user.get_inactive_hand() == src))
		translocator.unload_ammo(user, ignore_inactive_hand_check = 1)
		return
	..()

/obj/item/clothing/head/fluff/nikki/AltClick(mob/user)
	if (translocator && (user.get_inactive_hand() == src))
		translocator_unequip(translocator, user)

/obj/item/clothing/head/fluff/nikki/attack_self(mob/user)
	..()
	if (translocator)
		translocator.attack_self(user, user)
		return
	else
		to_chat(user, span_warning("\The [src] doesn't have a translocator inside it right now."))
		return

/obj/item/clothing/head/fluff/nikki/examine(mob/user) // If it has a translocator installed, make it very obvious to viewers that something WEIRD is going on with this hat.
	. = ..()
	if (translocator)
		. += "Weird... " + span_danger("You can't see the bottom of the hole inside the hat...")

/obj/item/clothing/head/fluff/nikki/equipped(mob/living/carbon/human/user, slot)
	. = ..()
	if (slot == slot_head && translocator && user.ckey != owner) // This way we don't unnecessarily spam the chat with hat/translocator errors
		// hey, are we actually able to teleport this poor person?
		if (hat_warp_checks(user, user, proximity_flag = 1))
			// YOU FOOL! YOU HAVE ACTIVATED MY STAND, 「ＶＯＲＥ　ＢＹ　ＨＡＴ」！
			src.visible_message(span_danger("\The [src] falls over [user]'s head... and somehow falls over the rest of their body, causing them to vanish inside. Where did they go?!"), \
			span_danger("The hat falls over your head as you put it on, enveloping you in a bright green light! <b>Uh oh.</b>"))
			var/uh_oh = pick(translocator.beacons)
			user.remove_from_mob(src, get_turf(user))
			translocator.destination = translocator.beacons[uh_oh]
			translocator.afterattack(user, user, proximity = 1, ignore_fail_chance = 1)
			add_attack_logs(user, user, "Tried to put on \the [src] and was involuntarily teleported by it (via \the [translocator] within)!")
			return

/obj/item/clothing/head/fluff/nikki/afterattack(var/mob/living/target, mob/user, proximity_flag, click_parameters)
	// If the hat is willing to cooperate with the holder...
	if (hat_warp_checks(target, user, proximity_flag))
		// Silly fluffed up styles of teleporting people based on user intent.
		switch (user.a_intent)
			if (I_HELP)
				user.visible_message(span_notice("[user] guides \the [target] to the bottomless hole within \the [src]. They begin to climb inside..."))
				if (do_after(user, 5 SECONDS, target))
					translocator.afterattack(target, user, proximity_flag)
			if (I_DISARM)
				user.visible_message(span_danger("[user] plops \the [src] onto \the [target]'s head!"))
				translocator.afterattack(target, user, proximity_flag)
			if (I_GRAB)
				user.visible_message(span_danger("[user] begins stuffing [target] into \the [src]!"))
				if (do_after(user, 5 SECONDS, target))
					translocator.afterattack(target, user, proximity_flag)
			if (I_HURT)
				user.visible_message(span_danger("[user] swipes \the [src] over \the [target]!"))
				translocator.afterattack(target, user, proximity_flag)

		add_attack_logs(user, target, "Teleported [target] with via \the [src]'s [translocator]!")
	else ..()

/obj/item/clothing/suit/storage/hooded/fluff
	name = DEVELOPER_WARNING_NAME
//Vitoras: Verie
/obj/item/clothing/suit/storage/hooded/fluff/verie
	name = "distressingly cyan hoodie"
	desc = "A cute, brightly colored hoodie perfect for occasional concealment of a verie silly nerd. A little tag inside \
	the collar bears only the letters \"VW.\""
	icon = 'icons/vore/custom_clothes_item.dmi'
	icon_state = "verie_hoodie"

	default_worn_icon = 'icons/vore/custom_clothes_mob.dmi'

	hoodtype = /obj/item/clothing/head/hood/winter/fluff/verie

	var/owner = "vitoras"

/obj/item/clothing/suit/storage/hooded/fluff/verie/ToggleHood()
	// If you ain't the robutt, you probably don't have the hair style that the hooded icon states are made for. sorry!
	var/mob/living/carbon/human/H = src.loc
	if (H.ckey != owner)
		to_chat(H, "Strange... the hood doesn't go over your head no matter how you try to put it up.")
		return
	..()

/obj/item/clothing/head/hood/winter/fluff/verie
	body_parts_covered = null // This way, Verie's hair can show through the hood!
	name = "not-so-cyan hood"
	icon = 'icons/vore/custom_clothes_item.dmi'
	icon_state = "verie_hood"

	default_worn_icon = 'icons/vore/custom_clothes_mob.dmi'

/obj/item/clothing/under/fluff/verie
	name = "salaciously stylised suit"
	desc = "It's kind of difficult to identify the type of material that makes up this form-fitting suit. It is stretchy and flexible, but \
	is firm in its toughness, and clings tightly to the skin. Come to think of it, it glistens quite a bit in the light and- \
	oh god it's latex.\
	\n... A <b>Verie</b> appropriate material choice indeed." //the wordplay never ends
	icon = 'icons/vore/custom_clothes_item.dmi'
	icon_state = "veriesuit"

	default_worn_icon = 'icons/vore/custom_clothes_mob.dmi'

	body_parts_covered = CHEST|FEET|ARMS|HANDS

//PastelPrinceDan: Masumi Maki
/obj/item/clothing/accessory/poncho/roles/cloak/fluff/cloakglowing
	name = "glowing cloak"
	desc = "A fancy cloak with a RGB LED color strip along the trim, cycling through the colors of the rainbow."
	icon = 'icons/vore/custom_clothes_item.dmi'
	icon_state = "rgb"
	item_state = "rgb"
	overlay_state = "rgb"
	icon_override = 'icons/vore/custom_clothes_mob.dmi' //This one HAS to be icon_override due to accessory code in acessory.dm
	var/is_dark = FALSE
	item_icons = list(
		slot_wear_suit_str = 'icons/vore/custom_clothes_mob.dmi'
		)

/obj/item/clothing/accessory/poncho/roles/cloak/fluff/cloakglowing/equipped()
	..()
	var/mob/living/carbon/human/H = loc
	if(istype(H) && H.wear_suit == src)
		icon_override = 'icons/vore/custom_clothes_mob.dmi'
	update_clothing_icon()

/obj/item/clothing/accessory/poncho/roles/cloak/fluff/cloakglowing/dropped(mob/user)
	..()
	icon_override = 'icons/vore/custom_clothes_mob.dmi'

/obj/item/clothing/accessory/poncho/roles/cloak/fluff/cloakglowing/proc/colorswap(mob/user)
	if(user.canmove && !user.stat)
		src.is_dark = !src.is_dark
		if (src.is_dark)
			icon_state = "rgbd"
			item_state = "rgbd"
			overlay_state = "rgbd"
			to_chat(user, "The polychromic plates in your cloak activate, turning it black.")
		else
			icon_state = "rgb"
			item_state = "rgb"
			overlay_state = "rgb"
			to_chat(user, "The polychromic plates in your cloak activate, turning it white.")
		has_suit?.update_clothing_icon()
		user.update_inv_wear_suit()

/obj/item/clothing/accessory/poncho/roles/cloak/fluff/cloakglowing/verb/color_verb()
	set name = "Swap color"
	set category = "Object"
	set src in usr
	if(!isliving(usr)) return
	if(usr.stat) return

	colorswap(usr)

//Hatterhat: Harold Robinson
/obj/item/clothing/under/fluff/mechanic_overalls
	name = "mechanic overalls"
	desc = "A set of white and blue overalls, paired with a yellow shirt."
	icon = 'icons/vore/custom_clothes_item.dmi'
	icon_state = "mechaoveralls"
	default_worn_icon = 'icons/vore/custom_clothes_mob.dmi'

//Hatterhat: Harold Robinson
/obj/item/clothing/suit/storage/hooded/wintercoat/fluff/mechanic
	name = "mechanic winter coat"
	desc = "A blue and yellow winter coat, worn only by overachievers."
	icon = 'icons/vore/custom_clothes_item.dmi'
	icon_state = "mechacoat"

	default_worn_icon = 'icons/vore/custom_clothes_mob.dmi'
	hoodtype = /obj/item/clothing/head/hood/winter/fluff/mechanic
	has_hood_sprite = TRUE


/obj/item/clothing/head/hood/winter/fluff/mechanic
	name = "mechanic winter hood"
	desc = "A blue and yellow winter coat's hood."
	icon = 'icons/inventory/head/item.dmi'
	icon_state = "mechahood"

	default_worn_icon = 'icons/vore/custom_clothes_mob.dmi'

//Pandora029 : Evelyn Tareen
/obj/item/clothing/suit/storage/hooded/wintercoat/security/fluff/evelyn
	name = "warden's navy winter coat"
	desc = "A custom tailored security winter coat in navy blue colors, this one has the rank markings of a warden on it."
	icon = 'icons/vore/custom_clothes_item.dmi'
	icon_state = "evelyncoat"

	default_worn_icon = 'icons/vore/custom_clothes_mob.dmi'
	hoodtype = /obj/item/clothing/head/hood/winter/security/fluff/evelyn
	has_hood_sprite = TRUE


/obj/item/clothing/head/hood/winter/security/fluff/evelyn
	name = "warden's navy winter hood"
	desc = "A custom tailored security winter coat's hood in navy blue colors."
	icon = 'icons/vore/custom_clothes_item.dmi'
	icon_state = "evelynhood"


	default_worn_icon = 'icons/vore/custom_clothes_mob.dmi'

//Allweek:Fifi the Magnificent
/obj/item/clothing/head/fluff/fifi_hat
	name = "fifi's hat"
	desc = "It's a colorful hat for an eccentric entertaining cat."

	icon = 'icons/vore/custom_clothes_item.dmi'
	icon_state = "fifi_hat"

	default_worn_icon = 'icons/vore/custom_clothes_mob.dmi'

/obj/item/clothing/under/fluff/fifi_jumpsuit
	name = "fifi's jumpsuit"
	desc = "It's a colorful outfit for an eccentric entertaining cat."

	icon = 'icons/vore/custom_clothes_item.dmi'
	icon_state = "fifi_jumpsuit"

	default_worn_icon = 'icons/vore/custom_clothes_mob.dmi'

/obj/item/clothing/shoes/fluff/fifi_socks
	name = "fifi's socks"
	desc = "A pair of colorful socks for an eccentric entertaining cat."

	icon = 'icons/vore/custom_clothes_item.dmi'
	icon_state = "fifi_socks"

	default_worn_icon = 'icons/vore/custom_clothes_mob.dmi'



//Uncle_Fruit_VEVO - Bradley Khatibi
/obj/item/clothing/shoes/fluff/airjordans
	name = "A pair of Air Jordan 1 Mid 'Black Gym Red's"
	desc = "Appearing in a classic Jordan Brand colorway, the Air Jordan 1 Mid 'Black Gym Red' released in May 2021. Built with leather, the shoe's upper sports a white base, contrasted by black on the overlays and highlighted by Gym Red on the padded collar, 'Wings' logo and Swoosh branding. A breathable nylon tongue and perforated toe box support the fit, while underfoot, a standard rubber cupsole with Air in the heel anchors the build."
	icon_state = "airjordans"
	icon = 'icons/vore/custom_clothes_item.dmi'
	default_worn_icon = 'icons/vore/custom_clothes_mob.dmi'

//Pandora029:Shona Young
/obj/item/clothing/under/fluff/foxoflightsuit
	name = "padded flightsuit"
	desc = "A ruddy-orange combination immersion-and-flight suit, fitted with extra padding across the front of its legs. Warm, waterproof and practical, seveal patches are scattered across it alongside a hard-wearing harness."

	icon = 'icons/vore/custom_clothes_item.dmi'
	icon_state = "foxflightsuit"
	rolled_sleeves = 0
	rolled_down = 0

	default_worn_icon = 'icons/vore/custom_clothes_mob.dmi'
	body_parts_covered = CHEST|ARMS|LEGS

//Shalax: Cerise Duelliste
/obj/item/storage/belt/security/fluff/cerise
	name = "champion's belt"
	desc = "Cerise's hard-won belt from her glory days. Her skill might have waned since then, but her renown lives on."
	icon_state = "champion"

	default_worn_icon = 'icons/vore/custom_clothes_mob.dmi'

//Sudate: Shea Corbett
/obj/item/clothing/under/fluff/greek_dress
	name = "mytilenean dress"
	desc = "It's a breezy, colorful two-part dress woven from linen, with the top consisting of white linen, and the skirt of rougher, sturdy fabric. It's adorned with a yellow belt and embroidered stripes in the hem, and blue highlights at the sleeves. More notably, however, it exposes the wearer's chest entirely."

	icon = 'icons/vore/custom_clothes_item.dmi'
	icon_state = "greek_dress"
	worn_state = "greek_dress"
	rolled_sleeves = 0
	rolled_down = 0

	default_worn_icon = 'icons/vore/custom_clothes_mob.dmi'
	body_parts_covered = CHEST|ARMS|LEGS

//JadeManique: Freyr
/obj/item/clothing/mask/fluff/freyr_mask
	name = "Freyr's Mask"
	desc = "A pristine white mask with antlers. Its silky to the touch, like porcelain!"
	icon = 'icons/vore/custom_clothes_item.dmi'
	icon_state = "freyrmask"
	item_icons = list(
		slot_wear_mask_str = 'icons/vore/custom_clothes_mob.dmi'
		)
	body_parts_covered = FACE
	flags_inv = HIDEFACE
	item_flags = FLEXIBLEMATERIAL
	protean_drop_whitelist = TRUE

//codeme: Perrin Kade
/obj/item/clothing/shoes/fluff/gildedshoes_perrin
	name = "gilded shoes"
	desc = "Black shoes with gilding, revealing and comfortable for any wearer!"

	icon_state = "perrinshoes"
	icon = 'icons/vore/custom_clothes_item.dmi'
	default_worn_icon = 'icons/vore/custom_clothes_mob.dmi'

/obj/item/clothing/under/fluff/gildedrobe_perrin
	name = "gilded robe"
	desc = "Black robe with gilding, revealing and comfortable for any wearer!"

	icon = 'icons/vore/custom_clothes_item.dmi'
	icon_state = "perrinrobes"
	worn_state = "perrinrobes_s"
	rolled_sleeves = 0
	rolled_down = 0

	default_worn_icon = 'icons/vore/custom_clothes_mob.dmi'
	item_state = "perrinrobes_s"
	body_parts_covered = CHEST

//Fuackwit422: Zera Livanne
/obj/item/clothing/suit/storage/toggle/labcoat/fluff/zera
	name = "Zera's Labcloak"
	desc = "Zera's custom-designed lab-coat and cloak hybrid. Designed to perfectly align with OSHA and NT's Health and Safety regulations, while also allowing her to completely ignore all that if she really wanted."

	icon = 'icons/vore/custom_clothes_item.dmi'
	icon_state = "zera_labcloak"

	default_worn_icon = 'icons/vore/custom_clothes_mob.dmi'

/obj/item/clothing/suit/storage/toggle/labcoat/fluff/zera/toggle()
	set name = "Toggle Coat Buttons"
	set category = "Object"
	set src in usr
	if(!usr.canmove || usr.stat || usr.restrained())
		return FALSE

	if(open) //Will check whether icon state is currently set to the "open" or "closed" state and switch it around with a message to the user
		open = FALSE
		icon_state = initial(icon_state)
		item_state = initial(item_state)
		flags_inv = HIDETIE|HIDEHOLSTER
		to_chat(usr, "You button up the coat.")
	else
		open = TRUE
		icon_state = "[icon_state]_open"
		item_state = "[item_state]_open"
		flags_inv = HIDEHOLSTER
		to_chat(usr, "You unbutton the coat.")
	update_clothing_icon()	//so our overlays update

/obj/item/clothing/head/welding/fluff/zera
	name = "White Welding Mask"
	desc = "It's a white welding mask. Zera likes it because it matches her labcoat."
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 0, rad = 0)
	icon = 'icons/vore/custom_clothes_item.dmi'
	default_worn_icon = 'icons/vore/custom_clothes_mob.dmi'
	icon_state = "zera_weld"
	flags_inv = (HIDEEYES)
	body_parts_covered = HEAD|EYES

/obj/item/clothing/head/welding/fluff/zera/toggle() //overriding this 'cause it only conceals the eyes - it's a hat, not a mask
	set category = "Object"
	set src in usr

	if(usr.canmove && !usr.stat && !usr.restrained())
		if(up)
			up = !up
			body_parts_covered |= (EYES)
			flags_inv |= (HIDEEYES)
			icon_state = "zera_weld"
			to_chat(usr, "You flip the helmet down to protect your eyes.")
		else
			up = !up
			body_parts_covered &= ~(EYES)
			flags_inv &= ~(HIDEEYES)
			icon_state = "zera_weld_up"

			to_chat(usr, "You push the helmet up out of your face.")
		update_clothing_icon()	//so our mob-overlays
		if (ismob(loc)) //should allow masks to update when it is opened/closed
			var/mob/M = loc
			M.update_inv_wear_mask()
		usr.update_mob_action_buttons()

/obj/item/clothing/suit/storage/toggle/labcoat/fluff/zeracloak
	name = "Grand Purple Cloak"
	desc = "Zera's custom-designed purple cloak. Nice and spooky, and the perfect length to hold up over your face with one hand like Count von Count."

	icon = 'icons/vore/custom_clothes_item.dmi'
	icon_state = "grand_purple_cloak"

	default_worn_icon = 'icons/vore/custom_clothes_mob.dmi'

/obj/item/clothing/suit/storage/toggle/labcoat/fluff/zeracloak/toggle()
	set name = "Toggle Coat Buttons"
	set category = "Object"
	set src in usr
	if(!usr.canmove || usr.stat || usr.restrained())
		return FALSE

	if(open) //Will check whether icon state is currently set to the "open" or "closed" state and switch it around with a message to the user
		open = FALSE
		icon_state = initial(icon_state)
		item_state = initial(item_state)
		flags_inv = HIDETIE|HIDEHOLSTER
		to_chat(usr, "You button up the coat.")
	else
		open = TRUE
		icon_state = "[icon_state]_open"
		item_state = "[item_state]_open"
		flags_inv = HIDEHOLSTER
		to_chat(usr, "You unbutton the coat.")
	update_clothing_icon()	//so our overlays update

/obj/item/clothing/head/fluff/zerahat
	name = "Grand Purple Hat"
	desc = "It's a pointy purple hat. Zera likes it because it matches her ominous purple cloak."
	icon = 'icons/vore/custom_clothes_item.dmi'
	default_worn_icon = 'icons/vore/custom_clothes_mob.dmi'
	icon_state = "grand_purple_cloak_hat"

//verysoft:Dessa Ton
/obj/item/clothing/head/fluff/giantbow/dessa
	desc = "It's a huge bow! So pretty! This one is fitted specially for Dessa's rediculously large ears."
	default_worn_icon = 'icons/vore/custom_clothes_mob.dmi'
	item_state = "dessabow_mob"

/obj/item/clothing/head/fluff/giantbow/dessa/attack_hand(mob/user)

	if(user.real_name == "Dessa Ton")
		item_state = "dessabow_mob"
	else
		item_state = "giantbow_mob"
	..()

/obj/item/clothing/head/fluff/giantbow	//Public version
	name = "Giant Bow"
	desc = "It's a huge bow! So pretty!"
	slot_flags = SLOT_HEAD | SLOT_EARS

	icon = 'icons/vore/custom_clothes_item.dmi'
	icon_state = "dessabow"

	default_worn_icon = 'icons/vore/custom_clothes_mob.dmi'
	item_state = "giantbow_mob"

//Halored: Mercury

/obj/item/clothing/accessory/ring/material/void_opal/fluff/mercury
	name = "Mercury's Mate Ring"
	desc = "A band of void opal, given to Mercury by Lumen"

//satinisle: Parriz Tavakdavi

/obj/item/clothing/suit/storage/toggle/labcoat/fluff/parrizjacket
	name = "pink crop bomber"
	desc = "A pink crop bomber jacket that is just barely able to zip up at the front. It has a small Virgo Orbital Research Establishment patch on each shoulder."
	icon_state = "parriz_jacket"

//verysoft: Casey Brown
/obj/item/clothing/glasses/big_round
	name = "big round blue glasses"
	desc = "A set of glasses! They are big, round, and very reflective, catching the light and obscuring the eyes!"
	icon_state = "bigroundglasses"
	slot_flags = SLOT_EYES | SLOT_EARS
	glasses_layer_above = TRUE

//valkaerie: Valkaerie Stoze

/obj/item/clothing/ears/earring/fluff/valkhorns
	name = "valkaerie's horns"
	desc = "Curled horns that look that they shouldn't really be pulled off!"
	icon = 'icons/vore/custom_clothes_item.dmi'
	icon_state = "valkhorns"
	default_worn_icon = 'icons/vore/custom_clothes_mob.dmi'

//sixberry: Thistle

/obj/item/clothing/head/fluff/memory_crown
	name = "Memory Crown"
	desc = "A thorned crown sporting numerous amethyst inserts, all of which seem to glow faintly in the dark.  Just holding it makes you feel as though you've forgotten something unpleasant."
	icon = 'icons/vore/custom_clothes_item.dmi'
	icon_state = "memorycrown"
	default_worn_icon = 'icons/vore/custom_clothes_mob.dmi'
	slot_flags = SLOT_HEAD

//For general use
/obj/item/clothing/suit/storage/hooded/purple_robes
	name = "Purple Robes"
	desc = "A basic set of purple robes. This one has a tag that reads 'Now with eye-tracking technology!'"

	icon = 'icons/vore/fluff_clothing/eyerobes/custom_clothes_robe_item.dmi'
	icon_state = "purple_robes"
	default_worn_icon = 'icons/vore/fluff_clothing/eyerobes/custom_clothes_robe_mob.dmi'
	hoodtype = /obj/item/clothing/head/hood/purple_robes

	blood_overlay_type = "coat"
	has_hood_sprite = FALSE //No need.
	body_parts_covered = CHEST|ARMS|LEGS
	allowed = list(POCKET_GENERIC, POCKET_EMERGENCY)
	var/toggled = FALSE
	var/last_toggled = 0

/obj/item/clothing/suit/storage/hooded/purple_robes/verb/toggle()
	set name = "Toggle Eyes"
	set category = "Object"
	set src in usr
	toggle_eyes(usr)

/obj/item/clothing/suit/storage/hooded/purple_robes/proc/toggle_eyes(mob/user)

	if(!user.canmove || user.stat || user.restrained())
		return FALSE

	//Antispam.
	if((last_toggled + 6 SECONDS) > world.time) //Can only toggle it once every 6 seconds!
		to_chat(user, span_info("You can only toggle the eyes every six seconds!"))
		return


	if(!toggled)
		AddComponent(/datum/component/reactive_icon_update/clothing, \
		icon_prefix = "_corrupted", \
		directions = list(NORTH,EAST,SOUTH,WEST,SOUTHWEST,SOUTHEAST,NORTHWEST,NORTHEAST), \
		range = 3, \
		triggering_mobs = list(/mob/living))
		toggled = TRUE
		to_chat(user, span_info("The coat's eyes open."))
	else
		var/datum/component/reactive_icon_update/clothing/reactive_component = GetComponent(/datum/component/reactive_icon_update/clothing)
		if(reactive_component)
			qdel(reactive_component)
		toggled = FALSE
		icon_state = initial(icon_state)
		item_state = initial(item_state)
		to_chat(user, span_info("The coat's eyes close."))
	last_toggled = world.time
	user.update_inv_wear_suit()

/obj/item/clothing/head/hood/purple_robes
	name = "purple hood"
	icon = 'icons/vore/fluff_clothing/eyerobes/custom_clothes_robe_item.dmi'
	icon_state = "hood"
	default_worn_icon = 'icons/vore/fluff_clothing/eyerobes/custom_clothes_robe_mob.dmi'
