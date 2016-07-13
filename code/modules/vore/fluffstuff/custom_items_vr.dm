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
/obj/item/weapon/sword/fluff/joanaria
	name = "Aria"
	desc = "A beautifully crafted rapier owned by Joan Risu. It has a thin blade and is used for quick attacks."
	icon = 'icons/vore/custom_items_vr.dmi'
	icon_state = "joanaria"
	origin_tech = "materials=7"
	force = 15
	sharp = 1
	edge = 1
	hitsound = 'sound/weapons/bladeslice.ogg'


/obj/item/weapon/sword/fluff/joanaria/handle_shield(mob/user, var/damage, atom/damage_source = null, mob/attacker = null, var/def_zone = null, var/attack_text = "the attack")

	if(default_parry_check(user, attacker, damage_source) && prob(75))
		user.visible_message("<span class='danger'>\The [user] parries [attack_text] with \the [src]!</span>")
		playsound(user.loc, 'sound/weapons/punchmiss.ogg', 50, 1)
		return 1
	return 0

//joanrisu:Katarina Eine
/obj/item/weapon/material/hatchet/tacknife/combatknife/fluff/katarina
	name = "tactical Knife"
	desc = "A tactical knife with a small butterly engraved on the blade."

obj/item/weapon/material/hatchet/tacknife/combatknife/fluff/katarina/handle_shield(mob/user, var/damage, atom/damage_source = null, mob/attacker = null, var/def_zone = null, var/attack_text = "the attack")

	if(default_parry_check(user, attacker, damage_source) && prob(75))
		user.visible_message("<span class='danger'>\The [user] parries [attack_text] with \the [src]!</span>")
		playsound(user.loc, 'sound/weapons/punchmiss.ogg', 50, 1)
		return 1
	return 0

//For General use
/obj/item/weapon/sword/fluff/joanaria/scisword
	name = "Scissor Blade"
	desc = "A sword that can not only cut down your enemies, it can also cut fabric really neatly"
	icon = 'icons/vore/custom_items_vr.dmi'
	icon_state = "scisword"
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
/obj/item/weapon/card/id/centcom/fluff/joanbadge
	name = "Faded Badge"
	desc = "A faded badge, backed with leather, that reads 'NT Security Force' across the front."
	icon = 'icons/vore/custom_items_vr.dmi'
	icon_state = "joanbadge"
	registered_name = "Joan Risu"
	assignment = "Centcom Officer"


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

//Vorrarkul:Lucina Dakarim
/obj/item/device/pda/heads/hos/fluff/lucinapda
	icon = 'icons/vore/custom_items_vr.dmi'
	icon_state = "pda-lucina"

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

//scree:Scree
/obj/item/device/modkit_conversion/fluff/screekit
	name = "Scree's hardsuit modification kit"
	desc = "A kit containing all the needed tools and parts to modify a hardsuit for a specific user. This one looks like it's fitted for a winged creature."

	icon = 'icons/vore/custom_items_vr.dmi'
	icon_state = "modkit"

	from_helmet = /obj/item/clothing/head/helmet/space/void/engineering
	from_suit = /obj/item/clothing/suit/space/void/engineering
	to_helmet = /obj/item/clothing/head/helmet/space/void/engineering/fluff/screehelm
	to_suit = /obj/item/clothing/suit/space/void/engineering/fluff/screespess

//General Use
/obj/item/weapon/flag
	name = "Nanotrasen Banner"
	desc = "I pledge allegiance to the flag of a megacorporation in space."

	icon = 'icons/vore/custom_items_vr.dmi'
	icon_state = "Flag_Nanotrasen"

	icon_override = 'icons/vore/custom_items_vr.dmi'
	item_state = "Flag_Nanotrasen"

	attack_self(mob/user as mob)
		if(isliving(user))
			user.visible_message("<span class='warning'>[user] waves their Banner around!</span>","<span class='warning'>You wave your Banner around.</span>")

	attack(mob/living/carbon/human/M, mob/living/user)
		if(isliving(user))
			user.visible_message("<span class='warning'>[user] invades [M]'s personal space, thrusting [src] into their face insistently.</span>","<span class='warning'>You invade [M]'s personal space, thrusting [src] into their face insistently.</span>")


	federation
		name = "Federation Banner"
		desc = "Space, The Final Frontier. Sorta. Just go with it and say the damn oath."

		icon = 'icons/vore/custom_items_vr.dmi'
		icon_state = "flag_federation"

		icon_override = 'icons/vore/custom_items_vr.dmi'
		item_state = "flag_federation"

//zodiacshadow: ?
/obj/item/device/radio/headset/fluff/zodiacshadow
	name = "Nehi's 'phones"
	desc = "A pair of old-fashioned purple headphones for listening to music that also double as an NT-approved headset; they connect nicely to any standard PDA. One side is engraved with the letters NEHI, the other having an elaborate inscription of the words \"My voice is my weapon of choice\" in a fancy font. A modern polymer allows switching between modes to either allow one to hear one's surroundings or to completely block them out."

	icon = 'icons/vore/custom_items_vr.dmi'
	icon_state = "headphones"

	icon_override = 'icons/vore/custom_items_vr.dmi'
	item_state = "headphones_mob"


// OrbisA: Richard D'angelo
/obj/item/weapon/melee/fluff/holochain
	name = "Holographic Chain"
	desc = "A High Tech solution to simple perversions. It has a red leather handle and the initials R.D. on the silver base."

	icon = 'icons/vore/custom_items_vr.dmi'
	icon_state = "holochain"

	icon_override = 'icons/vore/custom_items_vr.dmi'
	item_state = "holochain_mob"

	flags = CONDUCT | NOBLOODY
	no_attack_log = 1 //if you want to turn on the attack log for this, comment/delete this line. Orbis.
	slot_flags = SLOT_BELT
	force = 10
	throwforce = 3
	w_class = 3
	damtype = HALLOSS
	attack_verb = list("flogged", "whipped", "lashed", "disciplined", "chastised", "flayed")

// joey4298:Emoticon
/obj/item/device/fluff/id_kit_mime
	name = "Mime ID reprinter"
	desc = "Stick your ID in one end and it'll print a new ID out the other!"
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "labeler1"

	afterattack(obj/O, mob/user as mob)
		var/new_icon = "mime"
		if(istype(O,/obj/item/weapon/card/id) && O.icon_state != new_icon)
			//O.icon = src.icon // just in case we're using custom sprite paths with fluff items.
			O.icon_state = new_icon // Changes the icon without changing the access.
			playsound(user.loc, 'sound/items/polaroid2.ogg', 100, 1)
			user.visible_message("<span class='warning'> [user] reprints their ID.</span>")
			del(src)
		else if(O.icon_state == new_icon)
			user << "<span class='notice'>[O] already has been reprinted.</span>"
			return
		else
			user << "<span class='warning'>This isn't even an ID card you idiot.</span>"
			return

//arokha:Aronai Kadigan
/obj/item/weapon/card/id/centcom/fluff/aro
	registered_name = "CONFIGURE ME"
	assignment = "CC Medical"
	var/configured = 0

	attack_self(mob/user as mob)
		if(configured == 1) return ..()

		user.set_id_info(src)
		configured = 1
		user << "<span class='notice'>Card settings set.</span>"

//arokha:Aronai Kadigan
/obj/item/weapon/reagent_containers/hypospray/fluff/aronai
	name = "worn hypospray"
	desc = "This hypospray seems a bit well-used. The blue band indicates it's from the CentCom medical division. There's an 'A' scratched into the bottom."
	icon = 'icons/vore/custom_items_vr.dmi'
	icon_state = "aro_hypo"

	New()
		..()
		reagents.add_reagent("inaprovaline", 5)
		reagents.add_reagent("tricordrazine", 25)

//Swat43:Fortune Bloise
/obj/item/weapon/storage/backpack/satchel/fluff/swat43bag
	name = "Coloured Satchel"
	desc = "That's a coloured satchel with red stripes, with a heart and ripley logo on each side."
	icon = 'icons/vore/custom_items_vr.dmi'
	icon_state = "swat43-bag"

	icon_override = 'icons/vore/custom_items_vr.dmi'
	item_state = "swat43-bag_mob"


//Dhaeleena:Dhaeleena M'iar
/obj/item/clothing/accessory/medal/silver/security/fluff/dhael
	desc = "An award for distinguished combat and sacrifice in defence of corporate commercial interests. Often awarded to security staff. It's engraved with the letters S.W.A.T."

//Vorrarkul:Lucina Dakarim
/obj/item/clothing/accessory/medal/gold/fluff/lucina
	name = "Medal of Medical Excellence"
	desc = "A medal awarded to Lucina Darkarim for excellence in medical service."
