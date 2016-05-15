/* TUTORIAL
	"icon" is the file with the HUD/ground icon for the item
	"icon_state" is the iconstate in this file for the item
	"icon_override" is the file with the on-mob icons, can be the same file
	"item_state" is the iconstate for the on-mob icons:
		item_state_s is used for worn uniforms on mobs
		item_state_r and item_state_l are for being held in each hand

	"item_state_slots" can replace "item_state", it is a list:
		item_state_slots["slotname1"] = "item state for that slot"
		item_state_slots["slotname2"] = "item state for that slot"
*/

/* TEMPLATE
//ckey:Character Name
/obj/item/weapon/fluff/charactername
	name = ""
	desc = ""

	icon = 'icons/vore/custom_items_vr.dmi'
	icon_state = "myicon"

	icon_override = 'icons/vore/custom_items_vr.dmi'
	item_state = "myicon"

*/

//For general use
/obj/item/device/modkit_conversion
	name = "modification kit"
	desc = "A kit containing all the needed tools and parts to modify a suit and helmet."
	icon = 'icons/vore/custom_items_vr.dmi'
	icon_state = "modkit"
	var/parts = 3
	var/from_helmet = /obj/item/clothing/head/helmet/space/void
	var/from_suit = /obj/item/clothing/suit/space/void
	var/to_helmet = /obj/item/clothing/head/cardborg
	var/to_suit = /obj/item/clothing/suit/cardborg

	//Conversion proc
	afterattack(obj/O, mob/user as mob)
		var/flag
		var/to_type
		if(istype(O,from_helmet))
			flag = 1
			to_type = to_helmet
		else if(istype(O,from_suit))
			flag = 2
			to_type = to_suit
		else
			return
		if(!(parts & flag))
			user << "<span class='warning'>This kit has no parts for this modification left.</span>"
			return
		if(istype(O,to_type))
			user << "<span class='notice'>[O] is already modified.</span>"
			return
		if(!isturf(O.loc))
			user << "<span class='warning'>[O] must be safely placed on the ground for modification.</span>"
			return
		playsound(user.loc, 'sound/items/Screwdriver.ogg', 100, 1)
		var/N = new to_type(O.loc)
		user.visible_message("<span class='warning'>[user] opens \the [src] and modifies \the [O] into \the [N].</span>","<span class='warning'>You open \the [src] and modify \the [O] into \the [N].</span>")
		qdel(O)
		parts &= ~flag
		if(!parts)
			qdel(src)

//JoanRisu:Joan Risu
/obj/item/weapon/flame/lighter/zippo/fluff/joan
	name = "Federation Zippo Lighter"
	desc = "A red zippo lighter with the United Federation Logo on it."
	icon = 'icons/vore/custom_items_vr.dmi'
	icon_state = "joanzip"

//JoanRisu:Joan Risu
/obj/item/weapon/claymore/fluff/joanaria
	name = "Aria"
	desc = "A beautifully crafted rapier owned by Joan Risu. It has a thin blade and is used for quick attacks."
	icon = 'icons/vore/custom_items_vr.dmi'
	icon_state = "joanaria"
	origin_tech = "materials=7"

//john.wayne9392:Harmony Prechtl
/obj/item/weapon/twohanded/fireaxe/fluff/mjollnir
	name = "Mjollnir"
	desc = "Large hammer that looks like it can do a great deal of damage if properly used."
	icon = 'icons/vore/custom_items_vr.dmi'
	icon_state = "harmonymjollnir"
	origin_tech = "materials=7"
	attack_verb = list("attacked", "hammered", "smashed", "slammed", "crushed")

//JoanRisu:Joan Risu
/obj/item/weapon/card/id/gold/fluff/joanbadge
	name = "Faded Badge"
	desc = "A faded badge, backed with leather, that reads 'NT Security Force' across the front."
	icon = 'icons/vore/custom_items_vr.dmi'
	icon_state = "joanbadge"

	attack_self(mob/user as mob)
		if(isliving(user))
			user.visible_message("<span class='warning'>[user] flashes their golden security badge.\nIt reads:NT Security.</span>","<span class='warning'>You display the faded badge.\nIt reads: NT Security.</span>")

	attack(mob/living/carbon/human/M, mob/living/user)
		if(isliving(user))
			user.visible_message("<span class='warning'>[user] invades [M]'s personal space, thrusting [src] into their face insistently.</span>","<span class='warning'>You invade [M]'s personal space, thrusting [src] into their face insistently.</span>")

//JoanRisu:Joan Risu
/obj/item/device/pda/heads/hos/fluff/joanpda
	icon = 'icons/vore/custom_items_vr.dmi'
	icon_state = "pda-joan"

//john.wayne9392:Harmony Prechtl
/obj/item/device/modkit_conversion/fluff/harmonyspace
	name = "Harmony's captain space suit modkit"
	desc = "A kit containing all the needed tools and parts to modify a Captain's hardsuit. It has green and yellow parts inside."

	icon = 'icons/vore/custom_items_vr.dmi'
	icon_state = "harmony_kit"

	from_helmet = /obj/item/clothing/head/helmet/space/capspace
	from_suit = /obj/item/clothing/suit/armor/captain
	to_helmet = /obj/item/clothing/head/helmet/space/capspace/fluff/harmhelm
	to_suit = /obj/item/clothing/suit/armor/captain/fluff/harmsuit

//john.wayne9392:Harmony Prechtl
/obj/item/device/modkit_conversion/fluff/harmonysuit
	name = "Harmony's captain suit modkit"
	desc = "A sewing kit containing all the needed tools and fabric to modify a Captain's suit and hat. It has green and yellow fabrics inside."

	icon = 'icons/vore/custom_items_vr.dmi'
	icon_state = "harmony_kit"

	from_helmet = /obj/item/clothing/head/caphat
	from_suit = /obj/item/clothing/under/rank/captain
	to_helmet = /obj/item/clothing/head/centhat/fluff/harmhat
	to_suit = /obj/item/clothing/under/rank/captain/fluff/harmuniform