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

	//conversion costs. refunds all parts by default, but can be tweaked per-kit
	var/from_helmet_cost = 1
	var/from_suit_cost = 2
	var/to_helmet_cost = -1
	var/to_suit_cost = -2

	var/owner_ckey = null		//ckey of the kit owner as a string
	var/skip_content_check = FALSE	//can we skip the contents check? we generally shouldn't, but this is necessary for rigs/coats with hoods/etc.
	var/transfer_contents = FALSE	//should we transfer the contents across before deleting? we generally shouldn't, esp. in the case of rigs/coats with hoods/etc. note this does nothing if skip is FALSE.
	var/can_repair = FALSE		//can we be used to repair damaged voidsuits when converting them?
	var/can_revert = TRUE		//can we revert items, or is it a one-way trip?
	var/delete_on_empty = FALSE	//do we self-delete when emptied?

	//Conversion proc
/obj/item/device/modkit_conversion/afterattack(obj/O, mob/user as mob)
	var/cost
	var/to_type
	var/keycheck

	if(isturf(O)) //silently fail if you click on a turf. shouldn't work anyway because turfs aren't objects but if I don't do this it spits runtimes.
		return
	if(istype(O,/obj/item/clothing/suit/space/void/) && !can_repair) //check if we're a voidsuit and if we're allowed to repair
		var/obj/item/clothing/suit/space/void/SS = O
		if(LAZYLEN(SS.breaches))
			to_chat(user, "<span class='warning'>You should probably repair that before you start tinkering with it.</span>")
			return
	if(O.blood_DNA || O.contaminated) //check if we're bloody or gooey or whatever, so modkits can't be used to hide crimes easily.
		to_chat(user, "<span class='warning'>You should probably clean that up before you start tinkering with it.</span>")
		return
	//we have to check that it's not the original type first, because otherwise it might convert wrong based on pathing; the subtype can still count as the basetype
	if(istype(O,to_helmet) && can_revert)
		cost = to_helmet_cost
		to_type = from_helmet
	else if(istype(O,to_suit) && can_revert)
		cost = to_suit_cost
		to_type = from_suit
	else if(!can_revert && (istype(O,to_helmet) || istype (O,to_suit)))
		to_chat(user, "<span class='warning'>This kit doesn't seem to have the tools necessary to revert changes to modified items.</span>")
		return
	else if(istype(O,from_helmet))
		cost = from_helmet_cost
		to_type = to_helmet
		keycheck = TRUE
	else if(istype(O,from_suit))
		cost = from_suit_cost
		to_type = to_suit
		keycheck = TRUE
	else
		return
	if(!isturf(O.loc))
		to_chat(user, "<span class='warning'>You need to put \the [O] on the ground, a table, or other worksurface before modifying it.</span>")
		return
	if(!skip_content_check && O.contents.len) //check if we're loaded/modified, in the event of gun/suit kits, to avoid purging stuff like ammo, badges, armbands, or suit helmets
		to_chat(user, "<span class='warning'>You should probably remove any attached items or loaded ammunition before trying to modify that!</span>")
		return
	if(cost > parts)
		to_chat(user, "<span class='warning'>The kit doesn't have enough parts left to modify that.</span>")
		if(can_revert && ((to_helmet_cost || to_suit_cost) < 0))
			to_chat(user, "<span class='notice'> You can recover parts by using the kit on an already-modified item.</span>")
		return
	if(keycheck && owner_ckey) //check if we're supposed to care
		if(user.ckey != owner_ckey) //ERROR: UNAUTHORIZED USER
			to_chat(user, "<span class='warning'>You probably shouldn't mess with all these strange tools and parts...</span>") //give them a slightly fluffy explanation as to why it didn't work
			return
	playsound(src, 'sound/items/Screwdriver.ogg', 100, 1)
	var/obj/N = new to_type(O.loc)
	user.visible_message("<span class='notice'>[user] opens \the [src] and modifies \the [O] into \the [N].</span>","<span class='notice'>You open \the [src] and modify \the [O] into \the [N].</span>")

	//crude, but transfer prints and fibers to avoid forensics abuse, same as the bloody/gooey check above
	N.fingerprints = O.fingerprints
	N.fingerprintshidden = O.fingerprintshidden
	N.fingerprintslast = O.fingerprintslast
	N.suit_fibers = O.suit_fibers

	//transfer logic could technically be made more thorough and handle stuff like helmet/boots/tank vars for suits, but in those cases you should be removing the items first anyway
	if(skip_content_check && transfer_contents)
		N.contents = O.contents
		if(istype(N,/obj/item/weapon/gun/projectile/))
			var/obj/item/weapon/gun/projectile/NN = N
			var/obj/item/weapon/gun/projectile/OO = O
			NN.magazine_type = OO.magazine_type
			NN.ammo_magazine = OO.ammo_magazine
		if(istype(N,/obj/item/weapon/gun/energy/))
			var/obj/item/weapon/gun/energy/NE = N
			var/obj/item/weapon/gun/energy/OE = O
			NE.cell_type = OE.cell_type
	else
		if(istype(N,/obj/item/weapon/gun/projectile/))
			var/obj/item/weapon/gun/projectile/NM = N
			NM.contents = list()
			NM.magazine_type = null
			NM.ammo_magazine = null
		if(istype(N,/obj/item/weapon/gun/energy/))
			var/obj/item/weapon/gun/energy/NO = N
			NO.contents = list()
			NO.cell_type = null

	qdel(O)
	parts -= cost
	if(!parts && delete_on_empty)
		qdel(src)

//DEBUG ITEM
/obj/item/device/modkit_conversion/fluff/debug_gunkit
	name = "Gun Transformation Kit"
	desc = "A kit containing all the needed tools and fabric to modify one sidearm to another."
	skip_content_check = FALSE
	transfer_contents = FALSE

	icon = 'icons/vore/custom_items_vr.dmi'
	icon_state = "harmony_kit"

	from_helmet = /obj/item/weapon/gun/energy/laser
	to_helmet = /obj/item/weapon/gun/energy/retro
//DEBUG ITEM ENDS

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
	icon_override = 'icons/vore/custom_items_vr.dmi'
	item_state = "joanariamob"
	origin_tech = "materials=7"
	force = 15
	sharp = TRUE
	edge = TRUE
	hitsound = 'sound/weapons/bladeslice.ogg'


/obj/item/weapon/sword/fluff/joanaria/handle_shield(mob/user, var/damage, atom/damage_source = null, mob/attacker = null, var/def_zone = null, var/attack_text = "the attack")

	if(default_parry_check(user, attacker, damage_source) && prob(75))
		user.visible_message("<span class='danger'>\The [user] parries [attack_text] with \the [src]!</span>")
		playsound(src, 'sound/weapons/punchmiss.ogg', 50, 1)
		return 1
	return 0

//joanrisu:Katarina Eine
/obj/item/weapon/material/knife/tacknife/combatknife/fluff/katarina
	name = "tactical Knife"
	desc = "A tactical knife with a small butterly engraved on the blade."

/obj/item/weapon/material/knife/tacknife/combatknife/fluff/katarina/handle_shield(mob/user, var/damage, atom/damage_source = null, mob/attacker = null, var/def_zone = null, var/attack_text = "the attack")

	if(default_parry_check(user, attacker, damage_source) && prob(75))
		user.visible_message("<span class='danger'>\The [user] parries [attack_text] with \the [src]!</span>")
		playsound(src, 'sound/weapons/punchmiss.ogg', 50, 1)
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
/obj/item/weapon/card/id/centcom/station/fluff/joanbadge
	name = "Faded Badge"
	desc = "A faded badge, backed with leather, that reads 'NT Security Force' across the front."
	icon = 'icons/vore/custom_items_vr.dmi'
	icon_state = "joanbadge"
	registered_name = "Joan Risu"
	assignment = "Centcom Officer"


/obj/item/weapon/card/id/centcom/station/fluff/joanbadge/attack_self(mob/user as mob)
	if(isliving(user))
		user.visible_message("<span class='warning'>[user] flashes their golden security badge.\nIt reads:NT Security.</span>","<span class='warning'>You display the faded badge.\nIt reads: NT Security.</span>")

/obj/item/weapon/card/id/centcom/station/fluff/joanbadge/attack(mob/living/carbon/human/M, mob/living/user)
	if(isliving(user))
		user.visible_message("<span class='warning'>[user] invades [M]'s personal space, thrusting [src] into their face insistently.</span>","<span class='warning'>You invade [M]'s personal space, thrusting [src] into their face insistently.</span>")

//JoanRisu:Joan Risu
/obj/item/device/pda/heads/hos/joanpda
	icon = 'icons/vore/custom_items_vr.dmi'
	icon_state = "pda-joan"

//Vorrarkul:Lucina Dakarim
/obj/item/device/pda/heads/cmo/fluff/lucinapda
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

	from_helmet = /obj/item/clothing/head/helmet/space/void
	from_suit = /obj/item/clothing/suit/space/void
	to_helmet = /obj/item/clothing/head/helmet/space/void/engineering/hazmat/fluff/screehelm
	to_suit = /obj/item/clothing/suit/space/void/engineering/hazmat/fluff/screespess

//General Use
/obj/item/weapon/flag
	name = "Nanotrasen Banner"
	desc = "I pledge allegiance to the flag of a megacorporation in space."

	icon = 'icons/vore/custom_items_vr.dmi'
	icon_state = "Flag_Nanotrasen"

	icon_override = 'icons/vore/custom_items_vr.dmi'
	item_state = "Flag_Nanotrasen_mob"

/obj/item/weapon/flag/attack_self(mob/user as mob)
	if(isliving(user))
		user.visible_message("<span class='warning'>[user] waves their Banner around!</span>","<span class='warning'>You wave your Banner around.</span>")

/obj/item/weapon/flag/attack(mob/living/carbon/human/M, mob/living/user)
	if(isliving(user))
		user.visible_message("<span class='warning'>[user] invades [M]'s personal space, thrusting [src] into their face insistently.</span>","<span class='warning'>You invade [M]'s personal space, thrusting [src] into their face insistently.</span>")


/obj/item/weapon/flag/federation
	name = "Federation Banner"
	desc = "Space, The Final Frontier. Sorta. Just go with it and say the damn oath."

	icon = 'icons/vore/custom_items_vr.dmi'
	icon_state = "flag_federation"

	icon_override = 'icons/vore/custom_items_vr.dmi'
	item_state = "flag_federation_mob"

/obj/item/weapon/flag/xcom
	name = "Alien Combat Command Banner"
	desc = "A banner bearing the symbol of a task force fighting an unknown alien power."

	icon = 'icons/vore/custom_items_vr.dmi'
	icon_state = "flag_xcom"

	icon_override = 'icons/vore/custom_items_vr.dmi'
	item_state = "flag_xcom_mob"

/obj/item/weapon/flag/advent
	name = "ALIEN Coalition Banner"
	desc = "A banner belonging to traitors who work for an unknown alien power."

	icon = 'icons/vore/custom_items_vr.dmi'
	icon_state = "flag_advent"

	icon_override = 'icons/vore/custom_items_vr.dmi'
	item_state = "flag_advent_mob"


//Vorrakul: Kaitlyn Fiasco
/obj/item/toy/plushie/mouse/fluff
	name = "Mouse Plushie"
	desc = "A plushie of a delightful mouse! What was once considered a vile rodent is now your very best friend."
	slot_flags = SLOT_HEAD
	icon_state = "mouse_brown"
	item_state = "mouse_brown_head"
	icon = 'icons/vore/custom_items_vr.dmi'
	icon_override = 'icons/vore/custom_items_vr.dmi'

//zodiacshadow: Nehi Maximus
/obj/item/device/radio/headset/fluff/zodiacshadow
	name = "Nehi's 'phones"
	desc = "A pair of old-fashioned purple headphones for listening to music that also double as an NT-approved headset; they connect nicely to any standard PDA. One side is engraved with the letters NEHI, the other having an elaborate inscription of the words \"My voice is my weapon of choice\" in a fancy font. A modern polymer allows switching between modes to either allow one to hear one's surroundings or to completely block them out."

	icon = 'icons/vore/custom_items_vr.dmi'
	icon_state = "nehiphones"

	icon_override = 'icons/vore/custom_onmob_vr.dmi'
	item_state = "nehiphones"

//zodiacshadow: Nehi Maximus
/obj/item/clothing/accessory/medal/silver/fluff/zodiacshadow
	name = "Health Service Achievement medal"
	desc = "A small silver medal with the inscription \"For going above and beyond in the field.\" on it, along with the name Nehi Maximus."

	icon = 'icons/inventory/accessory/item.dmi'
	icon_state = "silver"

// OrbisA: Richard D'angelo
/obj/item/weapon/melee/fluff/holochain
	name = "Holographic Chain"
	desc = "A High Tech solution to simple perversions. It has a red leather handle and the initials R.D. on the silver base."

	icon = 'icons/vore/custom_items_vr.dmi'
	icon_state = "holochain"

	icon_override = 'icons/vore/custom_items_vr.dmi'
	item_state = "holochain_mob"

	flags = NOBLOODY
	slot_flags = SLOT_BELT
	force = 10
	throwforce = 3
	w_class = ITEMSIZE_NORMAL
	damtype = HALLOSS
	attack_verb = list("flogged", "whipped", "lashed", "disciplined", "chastised", "flayed")

//General use
/obj/item/weapon/melee/fluff/holochain/mass
	desc = "A mass produced version of the original. It has faux leather and an aluminium base, but still stings like the original."
	force = 8
	attack_verb = list("flogged", "whipped", "lashed", "flayed")


// joey4298:Emoticon
/obj/item/device/fluff/id_kit_mime
	name = "Mime ID reprinter"
	desc = "Stick your ID in one end and it'll print a new ID out the other!"
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "labeler1"

/obj/item/device/fluff/id_kit_mime/afterattack(obj/O, mob/user as mob)
	var/new_icon = "mime"
	if(istype(O,/obj/item/weapon/card/id) && O.icon_state != new_icon)
		//O.icon = icon // just in case we're using custom sprite paths with fluff items.
		O.icon_state = new_icon // Changes the icon without changing the access.
		playsound(src, 'sound/items/polaroid2.ogg', 100, 1)
		user.visible_message("<span class='warning'> [user] reprints their ID.</span>")
		qdel(src)
	else if(O.icon_state == new_icon)
		to_chat(user, "<span class='notice'>[O] already has been reprinted.</span>")
		return
	else
		to_chat(user, "<span class='warning'>This isn't even an ID card you idiot.</span>")
		return

//arokha:Aronai Sieyes - Centcom ID (Medical dept)
/obj/item/weapon/card/id/centcom/station/fluff/aronai
	registered_name = "CONFIGURE ME"
	assignment = "CC Medical"
	var/configured = 0

/obj/item/weapon/card/id/centcom/station/fluff/aronai/attack_self(mob/user as mob)
	if(configured)
		return ..()

	user.set_id_info(src)
	if(user.mind && user.mind.initial_account)
		associated_account_number = user.mind.initial_account.account_number
	configured = 1
	to_chat(user, "<span class='notice'>Card settings set.</span>")

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

//SilencedMP5A5:Serdykov Antoz
/obj/item/clothing/suit/armor/vest/wolftaur/serdy //SilencedMP5A5's specialty armor suit.
	name = "custom security cuirass"
	desc = "An armored vest that protects against some damage. It appears to be created for a wolfhound. The name 'Serdykov L. Antoz' is written on a tag inside one of the haunchplates."
	species_restricted = null //Species restricted since all it cares about is a taur half
	icon = 'icons/mob/taursuits_wolf_vr.dmi'
	icon_state = "serdy_armor"
	item_state = "serdy_armor"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS //It's a full body suit, minus hands and feet. Arms and legs should be protected, not just the torso. Retains normal security armor values still.

/obj/item/clothing/suit/armor/vest/wolftaur/serdy/mob_can_equip(var/mob/living/carbon/human/H, slot, disable_warning = 0)
	if(istype(H) && istype(H.tail_style, /datum/sprite_accessory/tail/taur/wolf))
		return ..()
	else
		to_chat(H, "<span class='warning'>You need to have a wolf-taur half to wear this.</span>")
		return 0

/obj/item/clothing/head/serdyhelmet //SilencedMP5A5's specialty helmet.
	name = "custom security helmet"
	desc = "An old production model steel-ceramic lined helmet with a white stripe and a custom orange holographic visor. It has ear holes, and smells of dog."
	icon = 'icons/vore/custom_clothes_vr.dmi'
	icon_state = "serdyhelm"
	valid_accessory_slots = (ACCESSORY_SLOT_HELM_C)
	restricted_accessory_slots = (ACCESSORY_SLOT_HELM_C)
	flags = THICKMATERIAL
	armor = list(melee = 40, bullet = 30, laser = 30, energy = 10, bomb = 10, bio = 0, rad = 0)
	icon_override = 'icons/vore/custom_clothes_vr.dmi'
	item_state = "serdyhelm_mob"
	cold_protection = HEAD
	min_cold_protection_temperature = HELMET_MIN_COLD_PROTECTION_TEMPERATURE
	heat_protection = HEAD
	max_heat_protection_temperature = HELMET_MAX_HEAT_PROTECTION_TEMPERATURE
	siemens_coefficient = 0.7
	w_class = ITEMSIZE_NORMAL
	ear_protection = 1
	drop_sound = 'sound/items/drop/helm.ogg'


//SilencedMP5A5:Serdykov Antoz
/obj/item/device/modkit_conversion/fluff/serdykit
	name = "Serdykov's armor modification kit"
	desc = "A kit containing all the needed tools and parts to modify a armor vest and helmet for a specific user. This one looks like it's fitted for a wolf-taur."

	icon = 'icons/vore/custom_items_vr.dmi'
	icon_state = "modkit"

	from_helmet = /obj/item/clothing/head/helmet
	from_suit = /obj/item/clothing/suit/armor/vest/wolftaur
	to_helmet = /obj/item/clothing/head/serdyhelmet
	to_suit = /obj/item/clothing/suit/armor/vest/wolftaur/serdy


//Cameron653: Diana Kuznetsova
/obj/item/clothing/suit/fluff/purp_robes
	name = "purple robes"
	desc = "Heavy, royal purple robes threaded with silver lining."
	icon_state = "psyamp"
	flags_inv = HIDEJUMPSUIT|HIDETIE|HIDEHOLSTER

/obj/item/clothing/head/fluff/pink_tiara
	name = "Pink Tourmaline Tiara"
	desc = "A small, steel tiara with a large, pink tourmaline gem in the center."
	icon_state = "amp"
	body_parts_covered = 0

//Lots of people are using this now.
/obj/item/clothing/accessory/collar/khcrystal
	name = "life crystal"
	desc = "A small crystal with four little dots in it. It feels slightly warm to the touch. \
	Read manual before use! Can be worn, held, or attached to uniform. NOTE: Device contains antimatter."
	w_class = ITEMSIZE_SMALL

	icon = 'icons/vore/custom_items_vr.dmi'
	icon_override = 'icons/vore/custom_items_vr.dmi'

	icon_state = "khlife"
	item_state = "khlife_overlay"
	overlay_state = "khlife_overlay"

	slot_flags = SLOT_TIE

	var/mob/owner = null
	var/client/owner_c = null //They'll be dead when we message them probably.
	var/state = 0 //0 - New, 1 - Paired, 2 - Breaking, 3 - Broken (same as iconstates)

/obj/item/clothing/accessory/collar/khcrystal/New()
	..()
	update_state(0)

/obj/item/clothing/accessory/collar/khcrystal/Destroy() //Waitwaitwait
	if(state == 1)
		process() //Nownownow
	return ..() //Okfine

/obj/item/clothing/accessory/collar/khcrystal/process()
	check_owner()
	if((state > 1) || !owner)
		STOP_PROCESSING(SSobj, src)

/obj/item/clothing/accessory/collar/khcrystal/attack_self(mob/user as mob)
	if(state > 0) //Can't re-pair, one time only, for security reasons.
		to_chat(user, "<span class='notice'>The [name] doesn't do anything.</span>")
		return 0

	owner = user	//We're paired to this guy
	owner_c = user.client	//This is his client
	update_state(1)
	to_chat(user, "<span class='notice'>The [name] glows pleasantly blue.</span>")
	START_PROCESSING(SSobj, src)

/obj/item/clothing/accessory/collar/khcrystal/proc/check_owner()
	//He's dead, jim
	if((state == 1) && owner && (owner.stat == DEAD))
		update_state(2)
		visible_message("<span class='warning'>The [name] begins flashing red.</span>")
		sleep(30)
		visible_message("<span class='warning'>The [name] shatters into dust!</span>")
		if(owner_c)
			to_chat(owner_c, "<span class='notice'>The HAVENS system is notified of your demise via \the [name].</span>")
		update_state(3)
		name = "broken [initial(name)]"
		desc = "This seems like a necklace, but the actual pendant is missing."

/obj/item/clothing/accessory/collar/khcrystal/proc/update_state(var/tostate)
	state = tostate
	icon_state = "[initial(icon_state)][tostate]"
	update_icon()

/obj/item/weapon/paper/khcrystal_manual
	name = "KH-LC91-1 manual"
	info = {"<h4>KH-LC91-1 Life Crystal</h4>
	<h5>Usage</h5>
	<ol>
		<li>Hold new crystal in hand.</li>
		<li>Make fist with that hand.</li>
		<li>Wait 1 second.</li>
	</ol>
	<br />
	<h5>Purpose</h5>
	<p>The Kitsuhana Life Crystal is a small device typically worn around the neck for the purpose of reporting your status to the HAVENS (Kitsuhana's High-AVailability ENgram Storage) system, so that appropriate measures can be taken in the case of your body's demise. The whole device is housed inside a pleasing-to-the-eye elongated diamond.</p>
	<p>Upon your body's desmise, the crystal will send a transmission to HAVENS. Depending on your membership level, the appropriate actions can be taken to ensure that you are back up and enjoying existence as soon as possible.</p>

	<p>Nanotrasen has negotiated a <i>FREE</i> Star membership for you in the HAVENS system, though an upgrade can be obtained depending on your citizenship and reputation level.</p>

	As a reminder, the membership levels in HAVENS are:
	<ul>
		<li><b>HAVENS Star:</b> Upon reciving a signal from a transmitter indicating body demise, HAVENS will attempt to contact the owner for 48 hours, before starting the process of resleeving the owner into a new body they selected when registering their HAVENS membership.</li>
		<li><b>HAVENS Nebula:</b> After the contact period from the Star service has expired, an agent will be alotted a HAVENS spacecraft, and will attempt to locate your remains, and any belongings you had, for up to one week. If possible, any more recent memory recordings or mindstates will be recovered before your resleeving. (Great for explorers! Don't miss out on anything you discovered!)</li>
		<li><b>HAVENS Galaxy:</b> Upon reciving the signal from the Star service, a HAVENS High-Threat Response Team will be alotted a HAVENS FTL-capable Interdictor-class spacecraft and dispatched to your last known position to locate and recover your remains, plus any belongings. You will be resleeved on-site to continue where you left off.</li>
	</ul>
	<br />
	<h5>Technical</h5>
	<p>The Life Crystal is a small 5cm long diamond containing four main components which are visible inside the translucent gem.</p>

	From tip to top, they are:
	<ol>
		<li><b>Qubit Bucket:</b> This small cube contains 200 bits worth of quantum-entangled bits for transmitting to HAVENS. QE transmission technologies cannot be jammed or interfered with, and are effectively instant over any distance.
		<li><b>Antimatter Bottle:</b> This tiny antimatter vessel is required to power the transmitter for the time it takes to transmit the signal to HAVENS. The inside of the crystal is thick enough to block any alpha or beta particles emitted when this antimatter contacts matter, however the crystal will be destroyed when activated.
		<li><b>Decay Reactor:</b> This long-term microreactor will last for around one month and provide sufficient power to power all but the transmitter. This power is required for containing the antimatter bottle.
		<li><b>Sensor Suite:</b> The sensor that tracks the owner's life-state, such that it can be transmitted back to HAVENS when necessary.
	</ol>
	<p>The diamond itself is coated in a layer of graphene, to give it a pleasant rainbow finish. This also serves as a conductor that, if broken, will discharge the antimatter bottle immediately as it is unsafe to do so any point after the crystal is broken via physical means.</p>
	<br />
	<h5>Special Notes</h5>
	<i>\[AM WARNING\]</i>
	<p>This device contains antimatter. Please consult all local regulations when travelling to ensure compliance with local laws.</p>"}

/obj/item/weapon/storage/box/khcrystal
	name = "life crystal case"
	icon = 'icons/vore/custom_items_vr.dmi'
	icon_state = "khlifebox"
	desc = "This case can only hold the KH-LC91-1 and a manual."
	item_state_slots = list(slot_r_hand_str = "syringe_kit", slot_l_hand_str = "syringe_kit")
	storage_slots = 2
	can_hold = list(/obj/item/weapon/paper/khcrystal_manual, /obj/item/clothing/accessory/collar/khcrystal)
	max_storage_space = ITEMSIZE_COST_SMALL * 2
	w_class = ITEMSIZE_SMALL

/obj/item/weapon/storage/box/khcrystal/New()
	..()
	new /obj/item/weapon/paper/khcrystal_manual(src)
	new /obj/item/clothing/accessory/collar/khcrystal(src)

/obj/item/weapon/cane/fluff
	name = "cane"
	desc = "A cane used by a true gentlemen. Or a clown."
	icon = 'icons/vore/custom_items_vr.dmi'
	icon_state = "browncane"
	item_icons = list (slot_r_hand_str = 'icons/vore/custom_items_vr.dmi', slot_l_hand_str = 'icons/vore/custom_items_vr.dmi')
	item_state_slots = list(slot_r_hand_str = "browncanemob_r", slot_l_hand_str = "browncanemob_l")
	force = 5.0
	throwforce = 7.0
	w_class = ITEMSIZE_SMALL
	matter = list(MAT_STEEL = 50)
	attack_verb = list("bludgeoned", "whacked", "disciplined", "thrashed")

/obj/item/weapon/cane/fluff/tasald
	name = "Ornate Walking Cane"
	desc = "An elaborately made custom walking stick with a dark wooding core, a crimson red gemstone on its head and a steel cover around the bottom. you'd probably hear someone using this down the hall."
	icon = 'icons/vore/custom_items_vr.dmi'

/obj/item/device/fluff/id_kit_ivy
	name = "Holo-ID reprinter"
	desc = "Stick your ID in one end and it'll print a new ID out the other!"
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "labeler1"

/obj/item/device/fluff/id_kit_ivy/afterattack(obj/O, mob/user as mob)
	var/new_icon_state = "ivyholoid"
	var/new_icon = 'icons/vore/custom_items_vr.dmi'
	var/new_desc = "Its a thin screen showing ID information, but it seems to be flickering."
	if(istype(O,/obj/item/weapon/card/id) && O.icon_state != new_icon)
		O.icon = new_icon
		O.icon_state = new_icon_state // Changes the icon without changing the access.
		O.desc = new_desc
		playsound(src, 'sound/items/polaroid2.ogg', 100, 1)
		user.visible_message("<span class='warning'> [user] reprints their ID.</span>")
		qdel(src)
	else if(O.icon_state == new_icon)
		to_chat(user, "<span class='notice'>[O] already has been reprinted.</span>")
		return
	else
		to_chat(user, "<span class='warning'>This isn't even an ID card you idiot.</span>")
		return

//WickedTempest: Chakat Tempest
/obj/item/weapon/reagent_containers/hypospray/vial/tempest
	name = "Tempest's Hypospray"
	desc = "A custom-made MKII hypospray belonging to Chakat Tempest. There's small print engraved on the handle: A medicine-cat has no time for doubt. Act now, act swiftly."
	icon = 'icons/vore/custom_items_vr.dmi'
	item_state = "temphypo"
	icon_state = "temphypo"

//WickedTempest: Chakat Tempest
/obj/item/weapon/storage/backpack/saddlebag/tempest
	name = "Tempest's Saddlebags"
	desc = "A custom-made set of saddlebags, tailored to Chakat Tempest's exact dimensions, and taste in color! One one side, there's small print stitched in: ...to carry the weight of any responsibility, burden or task."
	icon = 'icons/vore/custom_items_vr.dmi'
	icon_override = 'icons/vore/custom_items_vr.dmi'
	item_state = "tempestsaddlebag"
	icon_state = "tempestbag"
	max_storage_space = INVENTORY_DUFFLEBAG_SPACE //Since they play a macro character, no reason to put custom slowdown code on here.
	slowdown = 0
	taurtype = /datum/sprite_accessory/tail/taur/feline/tempest
	no_message = "These saddlebags seem to be fitted for someone else, and keep slipping off!"
	action_button_name = "Toggle Mlembulance Mode"
	var/ambulance = FALSE
	var/datum/looping_sound/ambulance/soundloop
	var/ambulance_state = FALSE
	var/ambulance_last_switch = 0

/obj/item/weapon/storage/backpack/saddlebag/tempest/Initialize()
	soundloop = new(list(src), FALSE)
	return ..()

/obj/item/weapon/storage/backpack/saddlebag/tempest/Destroy()
	QDEL_NULL(soundloop)
	return ..()

/obj/item/weapon/storage/backpack/saddlebag/tempest/ui_action_click()
	ambulance = !(ambulance)
	if(ambulance)
		START_PROCESSING(SSobj, src)
		item_state = "tempestsaddlebag-amb"
		icon_state = "tempestbag-amb"
		if (ismob(loc))
			var/mob/M = loc
			M.update_inv_back()
		ambulance_state = FALSE
		set_light(2, 1, "#FF0000")
		soundloop.start()
	else
		item_state = "tempestsaddlebag"
		icon_state = "tempestbag"
		if (ismob(loc))
			var/mob/M = loc
			M.update_inv_back()
		set_light(0)
		soundloop.stop()

/obj/item/weapon/storage/backpack/saddlebag/tempest/process()
	if(!ambulance)
		STOP_PROCESSING(SSobj, src)
		return
	if(world.time - ambulance_last_switch > 15)
		ambulance_state = !(ambulance_state)
		var/newlight = "#FF0000"
		if(ambulance_state)
			newlight = "#0000FF"
		if (ismob(loc))
			var/mob/M = loc
			M.update_inv_back()
		set_light(2, 1, newlight)
		ambulance_last_switch = world.time

/datum/looping_sound/ambulance
	mid_sounds = list('sound/items/amulanceweeoo.ogg'=1)
	mid_length = 20
	volume = 25

//PontifexMinimus: Lucius/Lucia Null
/obj/item/weapon/fluff/dragor_dot
	name = "supplemental battery"
	desc = "A tiny supplemental battery for powering something or someone synthetic."
	icon = 'icons/vore/custom_items_vr.dmi'
	icon_state = "dragor_dot"
	w_class = ITEMSIZE_SMALL

/obj/item/weapon/fluff/dragor_dot/attack_self(mob/user as mob)
	if(user.ckey == "pontifexminimus")
		user.verbs |= /mob/living/carbon/human/proc/shapeshifter_select_gender
	else
		return

//LuminescentRing: Briana Moore
/obj/item/weapon/storage/backpack/messenger/black/fluff/briana
	name = "2561 graduation bag"
	desc = "A black leather bag with names scattered around in red embroidery, it says 'Pride State Academy' on the top. "

//DeepIndigo: Amina Dae-Kouri
/obj/item/weapon/storage/bible/fluff/amina
	name = "New Space Pioneer's Bible"
	desc = "A New Space Pioneer's Bible. This one says it was printed in 2492. The name 'Eric Hayvers' is written on the inside of the cover, crossed out. \
	Under it is written 'Kouri, Amina, Marine Unit 14, Fifth Echelon. Service number NTN-5528928522372'"

//arokha:Amaya Rahl - Custom ID (Medical dept)
/obj/item/weapon/card/id/event/fluff/amaya
	registered_name = "CONFIGURE ME"
	assignment = "CONFIGURE ME"
	icon = 'icons/vore/custom_items_vr.dmi'
	base_icon = 'icons/vore/custom_items_vr.dmi'
	icon_state = "amayarahlwahID"
	desc = "A primarily blue ID with a holographic 'WAH' etched onto its back. The letters do not obscure anything important on the card. It is shiny and it feels very bumpy."
	title_strings = list("Amaya Rahl's Wah-identification card", "Amaya Rahl's Wah-ID card")

//General use, Verk felt like sharing.
/obj/item/clothing/glasses/fluff/science_proper
	name = "Aesthetic Science Goggles"
	desc = "The goggles really do nothing this time!"
	icon_state = "purple"
	item_state_slots = list(slot_r_hand_str = "glasses", slot_l_hand_str = "glasses")
	item_flags = AIRTIGHT

//General use, Verk felt like sharing.
/obj/item/clothing/glasses/fluff/spiffygogs
	name = "Orange Goggles"
	desc = "You can almost feel the raw power radiating off these strange specs."
	icon = 'icons/vore/custom_items_vr.dmi'
	icon_override = 'icons/vore/custom_clothes_vr.dmi'
	icon_state = "spiffygogs"
	slot_flags = SLOT_EYES | SLOT_EARS
	item_state_slots = list(slot_r_hand_str = "glasses", slot_l_hand_str = "glasses")
	toggleable = 1
	off_state = "spiffygogsup"

//General use
/obj/item/clothing/accessory/tronket
	name = "metal necklace"
	desc = "A shiny steel chain with a vague metallic object dangling off it."
	icon = 'icons/vore/custom_items_vr.dmi'
	icon_override = 'icons/vore/custom_clothes_vr.dmi'
	icon_state = "tronket"
	item_state = "tronket"
	overlay_state = "tronket"
	slot_flags = SLOT_TIE
	slot = ACCESSORY_SLOT_DECOR

/obj/item/clothing/accessory/flops
	name = "drop straps"
	desc = "Wearing suspenders over shoulders? That's been so out for centuries and you know better."
	icon = 'icons/vore/custom_items_vr.dmi'
	icon_override = 'icons/vore/custom_clothes_vr.dmi'
	icon_state = "flops"
	item_state = "flops"
	overlay_state = "flops"
	slot_flags = SLOT_TIE
	slot = ACCESSORY_SLOT_DECOR

//InterroLouis: Ruda Lizden
/obj/item/clothing/accessory/badge/holo/detective/ruda
	name = "Hisstective's Badge"
	desc = "This is Ruda Lizden's personal Detective's badge. The polish is dull, as if it's simply been huffed upon and wiped against a coat. Labeled 'Hisstective.'"
	icon = 'icons/vore/custom_items_vr.dmi'
	icon_state = "hisstective_badge"
	//slot_flags = SLOT_TIE | SLOT_BELT

/obj/item/clothing/accessory/badge/holo/detective/ruda/attack(mob/living/carbon/human/M, mob/living/user)
	if(isliving(user))
		user.visible_message("<span class='danger'>[user] invades [M]'s personal space, thrusting [src] into their face with an insistent huff.</span>","<span class='danger'>You invade [M]'s personal space, thrusting [src] into their face with an insistent huff.</span>")
		user.do_attack_animation(M)
		user.setClickCooldown(DEFAULT_QUICK_COOLDOWN) //to prevent spam

/obj/item/clothing/accessory/badge/holo/detective/ruda/attack_self(mob/user as mob)

	if(!stored_name)
		to_chat(user, "You huff along the front of your badge, then rub your sleeve on it to polish it up.")
		set_name(user.real_name)
		return

	if(isliving(user))
		if(stored_name)
			user.visible_message("<span class='notice'>[user] displays their [src].\nIt reads: [stored_name], [badge_string].</span>","<span class='notice'>You display your [src].\nIt reads: [stored_name], [badge_string].</span>")
		else
			user.visible_message("<span class='notice'>[user] displays their [src].\nIt reads: [badge_string].</span>","<span class='notice'>You display your [src]. It reads: [badge_string].</span>")

/obj/item/weapon/card/id/fluff/xennith
	name = "\improper Amy Lessen's Central Command ID (Xenobiology Director)"
	desc = "This ID card identifies Dr. Amelie Lessen as the founder and director of the NanoTrasen Xenobiology Research Department, circa 2553."
	icon_state = "centcom"
	registered_name = "Amy Lessen"
	assignment = "Xenobiology Director"
	access = list(access_cent_general,access_cent_thunder,access_cent_medical,access_cent_living,access_cent_storage,access_cent_teleporter,access_research,access_xenobiology,access_maint_tunnels,access_xenoarch,access_robotics,access_tox_storage,access_tox) //Yes, this looks awful. I tried calling both central and resarch access but it didn't work.
	age = 39
	blood_type = "O-"
	sex = "Female"

/obj/item/weapon/fluff/injector //Injectors. Custom item used to explain wild changes in a mob's body or chemistry.
	name = "Injector"
	desc = "Some type of injector."
	icon = 'icons/obj/items.dmi'
	icon_state = "dnainjector"

/obj/item/weapon/fluff/injector/monkey
	name = "Lesser Form Injector"
	desc = "Turn the user into their lesser, more primal form."

/obj/item/weapon/fluff/injector/monkey/attack(mob/living/M, mob/living/user)

	if(usr == M) //Is the person using it on theirself?
		if(ishuman(M)) //If so, monkify them.
			var/mob/living/carbon/human/H = user
			H.monkeyize()
			qdel(src) //One time use.
	else //If not, do nothing.
		to_chat(user, "<span class='warning'>You are unable to inject other people.</span>")

/obj/item/weapon/fluff/injector/numb_bite
	name = "Numbing Venom Injector"
	desc = "Injects the user with a high dose of some type of chemical, causing any chemical glands they have to kick into overdrive and create the production of a numbing enzyme that is injected via bites.."

/obj/item/weapon/fluff/injector/numb_bite/attack(mob/living/M, mob/living/user)

	if(usr == M) //Is the person using it on theirself?
		if(ishuman(M)) //Give them numbing bites.
			var/mob/living/carbon/human/H = user
			H.species.give_numbing_bite() //This was annoying, but this is the easiest way of performing it.
			qdel(src) //One time use.
	else //If not, do nothing.
		to_chat(user, "<span class='warning'>You are unable to inject other people.</span>")

//For 2 handed fluff weapons.
/obj/item/weapon/material/twohanded/fluff //Twohanded fluff items.
	name = "fluff."
	desc = "This object is so fluffy. Just from the sight of it, you know that either something went wrong or someone spawned the incorrect item."
	icon = 'icons/vore/custom_items_vr.dmi'
	item_icons = list(
				slot_l_hand_str = 'icons/vore/custom_items_left_hand_vr.dmi',
				slot_r_hand_str = 'icons/vore/custom_items_right_hand_vr.dmi',
				)

/obj/item/weapon/material/twohanded/fluff/New(var/newloc)
	..(newloc," ") //See materials_vr_dmi for more information as to why this is a blank space.

//jacknoir413:Areax Third
/obj/item/weapon/melee/baton/fluff/stunstaff
	name = "Electrostaff"
	desc = "Six-foot long staff from dull, rugged metal, with two thin spikes protruding from each end. Small etching near to the middle of it reads 'Children Of Nyx Facilities: Product No. 12'."
	icon = 'icons/vore/custom_items_vr.dmi'
	item_icons = list(slot_l_hand_str = 'icons/vore/custom_items_left_hand_vr.dmi', slot_r_hand_str = 'icons/vore/custom_items_right_hand_vr.dmi')
	icon_state = "stunstaff00"
	var/base_icon = "stunstaff"
	force = 5
	sharp = FALSE
	edge = FALSE
	throwforce = 7
	w_class = ITEMSIZE_HUGE
	origin_tech = list(TECH_COMBAT = 2)
	attack_verb = list("beaten")
	lightcolor = "#CC33FF"

	//Two Handed
	var/wielded = 0
	var/base_name = "stunstaff"

/obj/item/weapon/melee/baton/fluff/stunstaff/New()
	..()
	bcell = new/obj/item/weapon/cell/device/weapon(src)
	update_icon()
	return

/obj/item/weapon/melee/baton/fluff/stunstaff/update_held_icon()
	var/mob/living/M = loc
	if(istype(M) && !issmall(M) && M.item_is_in_hands(src) && !M.hands_are_full())
		wielded = 1
		force = 15
		name = "[base_name] (wielded)"
		update_icon()
	else
		wielded = 0
		force = 8
		name = "[base_name]"
	update_icon()
	..()

/obj/item/weapon/melee/baton/fluff/stunstaff/handle_shield(mob/user, var/damage, atom/damage_source = null, mob/attacker = null, var/def_zone = null, var/attack_text = "the attack")
	if(wielded && default_parry_check(user, attacker, damage_source) && prob(30))
		user.visible_message("<span class='danger'>\The [user] parries [attack_text] with \the [src]!</span>")
		playsound(src, 'sound/weapons/punchmiss.ogg', 50, 1)
		return 1
	return 0

/obj/item/weapon/melee/baton/fluff/stunstaff/update_icon()
	icon_state = "[base_icon][wielded][status]"
	item_state = icon_state
	if(status==1)
		set_light(2, 2, lightcolor)
	else
		set_light(0)

/obj/item/weapon/melee/baton/fluff/stunstaff/dropped()
	..()
	if(wielded)
		wielded = 0
		spawn(0)
			update_held_icon()

/obj/item/weapon/melee/baton/fluff/stunstaff/attack_self(mob/user)
	if(bcell && bcell.charge > hitcost)
		status = !status
		to_chat(user, "<span class='notice'>[src] is now [status ? "on" : "off"].</span>")
		if(status == 0)
			playsound(src, 'sound/weapons/saberoff.ogg', 50, 1)
		else
			playsound(src, 'sound/weapons/saberon.ogg', 50, 1)
	else
		status = 0
		to_chat(user, "<span class='warning'>[src] is out of charge.</span>")
	update_held_icon()
	add_fingerprint(user)

/obj/item/weapon/storage/backpack/fluff/stunstaff
	name = "Electrostaff sheath"
	icon = 'icons/vore/custom_items_vr.dmi'
	icon_state = "holster_stunstaff"
	desc = "A sturdy synthetic leather sheath with matching belt and rubberized interior."
	slot_flags = SLOT_BACK
	item_icons = list(slot_back_str = 'icons/vore/custom_onmob_vr.dmi', slot_l_hand_str = 'icons/vore/custom_items_left_hand_vr.dmi', slot_r_hand_str = 'icons/vore/custom_items_right_hand_vr.dmi')

	can_hold = list(/obj/item/weapon/melee/baton/fluff/stunstaff)

	w_class = ITEMSIZE_HUGE
	max_w_class = ITEMSIZE_HUGE
	max_storage_space = 16

/obj/item/weapon/storage/backpack/fluff/stunstaff/New()
	..()
	new /obj/item/weapon/melee/baton/fluff/stunstaff(src)


/*
 * Awoo Sword
 */
/obj/item/weapon/melee/fluffstuff
	var/active = 0
	var/active_force
	var/active_throwforce
	var/active_w_class
	var/active_embed_chance = 0
	sharp = FALSE
	edge = FALSE

/obj/item/weapon/melee/fluffstuff/proc/activate(mob/living/user)
	if(active)
		return
	active = 1
	embed_chance = active_embed_chance
	force = active_force
	throwforce = active_throwforce
	sharp = TRUE
	edge = TRUE
	w_class = active_w_class
	playsound(src, 'sound/weapons/sparkle.ogg', 50, 1)

/obj/item/weapon/melee/fluffstuff/proc/deactivate(mob/living/user)
	if(!active)
		return
	playsound(src, 'sound/weapons/sparkle.ogg', 50, 1)
	active = 0
	embed_chance = initial(embed_chance)
	force = initial(force)
	throwforce = initial(throwforce)
	sharp = initial(sharp)
	edge = initial(edge)
	w_class = initial(w_class)

/obj/item/weapon/melee/fluffstuff/attack_self(mob/living/user as mob)
	if (active)
		if ((CLUMSY in user.mutations) && prob(50))
			user.visible_message("<span class='danger'>\The [user] accidentally cuts \himself with \the [src].</span>",\
			"<span class='danger'>You accidentally cut yourself with \the [src].</span>")
			user.take_organ_damage(5,5)
		deactivate(user)
	else
		activate(user)

	if(istype(user,/mob/living/carbon/human))
		var/mob/living/carbon/human/H = user
		H.update_inv_l_hand()
		H.update_inv_r_hand()

	add_fingerprint(user)
	return

/obj/item/weapon/melee/fluffstuff/wolfgirlsword
	name = "Wolfgirl Sword Replica"
	desc = "A replica of a large, scimitar-like sword with a dull edge. Ceremonial... until it isn't."
	icon = 'icons/obj/weapons_vr.dmi'
	icon_state = "wolfgirlsword"
	slot_flags = SLOT_BACK | SLOT_OCLOTHING
	active_force = 15
	active_throwforce = 7
	active_w_class = ITEMSIZE_LARGE
	force = 1
	throwforce = 1
	throw_speed = 1
	throw_range = 5
	w_class = ITEMSIZE_SMALL
	origin_tech = list(TECH_MATERIAL = 2, TECH_COMBAT = 1)
	item_icons = list(slot_l_hand_str = 'icons/mob/items/lefthand_melee_vr.dmi', slot_r_hand_str = 'icons/mob/items/righthand_melee_vr.dmi', slot_back_str = 'icons/vore/custom_items_vr.dmi', slot_wear_suit_str = 'icons/vore/custom_items_vr.dmi')
	var/active_state = "wolfgirlsword"
	allowed = list(/obj/item/weapon/shield/fluff/wolfgirlshield)
	damtype = HALLOSS

/obj/item/weapon/melee/fluffstuff/wolfgirlsword/dropped(var/mob/user)
	..()
	if(!istype(loc,/mob))
		deactivate(user)

/obj/item/weapon/melee/fluffstuff/wolfgirlsword/activate(mob/living/user)
	if(!active)
		to_chat(user, "<span class='notice'>The [src] is now sharpened. It will cut!</span>")

	..()
	attack_verb = list("attacked", "slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")
	sharp = TRUE
	edge = TRUE
	icon_state = "[active_state]_sharp"
	damtype = BRUTE


/obj/item/weapon/melee/fluffstuff/wolfgirlsword/deactivate(mob/living/user)
	if(active)
		to_chat(user, "<span class='notice'>The [src] grows dull!</span>")
	..()
	attack_verb = list("bapped", "thwapped", "bonked", "whacked")
	icon_state = initial(icon_state)

//SilencedMP5A5 - Serdykov Antoz
/obj/item/device/modkit_conversion/hasd
	name = "HASD EVA modification kit"
	desc = "A kit containing all the needed tools and parts to modify a suit and helmet into something a HASD unit can use for EVA operations."
	icon = 'icons/vore/custom_items_vr.dmi'
	icon_state = "modkit"

	from_helmet = /obj/item/clothing/head/helmet/space/void/security
	from_suit = /obj/item/clothing/suit/space/void/security
	to_helmet = /obj/item/clothing/head/helmet/space/void/security/hasd
	to_suit = /obj/item/clothing/suit/space/void/security/hasd

//InterroLouis - Kai Highlands
/obj/item/borg/upgrade/modkit/chassis_mod/kai
	name = "kai chassis"
	desc = "Makes your KA green. All the fun of having a more powerful KA without actually having a more powerful KA."
	cost = 0
	denied_type = /obj/item/borg/upgrade/modkit/chassis_mod
	chassis_icon = "kineticgun_K"
	chassis_name = "Kai-netic Accelerator"
	var/chassis_desc = "A self recharging, ranged mining tool that does increased damage in low temperature. Capable of holding up to six slots worth of mod kits. It seems to have been painted an ugly green, and has a small image of a bird scratched crudely into the stock."
	var/chassis_icon_file = 'icons/vore/custom_guns_vr.dmi'

/obj/item/borg/upgrade/modkit/chassis_mod/kai/install(obj/item/weapon/gun/energy/kinetic_accelerator/KA, mob/user)
	KA.desc = chassis_desc
	KA.icon = chassis_icon_file
	..()
/obj/item/borg/upgrade/modkit/chassis_mod/kai/uninstall(obj/item/weapon/gun/energy/kinetic_accelerator/KA)
	KA.desc = initial(KA.desc)
	KA.icon = initial(KA.icon)
	..()

//ArgobargSoup:Lynn Shady
/obj/item/device/flashlight/pen/fluff/lynn
	name = "Lynn's penlight"
	desc = "A personalized penlight, a bit bulkier than the standard model.  Blue, with a medical cross on it, and the name Lynn Shady engraved in gold."

	icon = 'icons/vore/custom_items_vr.dmi'
	icon_state = "penlightlynn"

//Knightfall5:Ashley Kifer
/obj/item/clothing/accessory/medal/nobel_science/fluff/ashley
	name = "nobel sciences award"
	desc = "A bronze medal which represents significant contributions to the field of science or engineering, this one has Ashley Kifer engraved on it."

//lm40 - Kenzie Houser
/obj/item/weapon/reagent_containers/hypospray/vial/kenzie
	name = "gold-trimmed hypospray"
	desc = "A gold-trimmed MKII hypospray. The name 'Kenzie Houser' is engraved on the side."
	icon = 'icons/vore/custom_items_vr.dmi'
	icon_state = "kenziehypo"

//Semaun - Viktor Solothurn
/obj/item/weapon/reagent_containers/food/drinks/flask/vacuumflask/fluff/viktor
	name = "flask of expensive alcohol"
	desc = "A standard vacuum-flask filled with good and expensive drink."

/obj/item/weapon/reagent_containers/food/drinks/flask/vacuumflask/fluff/viktor/Initialize()
	. = ..()
	reagents.add_reagent("pwine", 60)

//RadiantAurora: Tiemli Kroto
/obj/item/clothing/glasses/welding/tiemgogs
   name = "custom-fitted welding goggles"
   desc = "A pair of thick, custom-fitted goggles with LEDs above the lenses. Ruggedly engraved below the lenses is the name 'Tiemli Kroto'."

   icon = 'icons/vore/custom_items_vr.dmi'
   icon_state = "tiemgogs"

   icon_override = 'icons/vore/custom_clothes_vr.dmi'
   icon_state = "tiemgogs"

/obj/item/clothing/glasses/welding/tiemgogs/mob_can_equip(var/mob/living/carbon/human/H, slot, disable_warning = 0)
   if(..())
      if(H.ckey != "radiantaurora")
         to_chat(H, "<span class='warning'>These don't look like they were made to fit you...</span>")
         return 0
      else
         return 1

//Ryumi - Nikki Yumeno
/obj/item/weapon/rig/nikki
	name = "weird necklace"
	desc = "A necklace with a brilliantly blue crystal encased in protective glass."
	icon = 'icons/vore/custom_clothes_vr.dmi'
	icon_override = 'icons/vore/custom_onmob_vr.dmi'
	suit_type = "probably not magical"
	icon_state = "nikki"
	w_class = ITEMSIZE_SMALL // It is after all only a necklace
	armor = list("melee" = 0, "bullet" = 0, "laser" = 0, "energy" = 0, "bomb" = 0, "bio" = 0, "rad" = 0) // this isn't armor, it's a dorky frickin cape
	siemens_coefficient = 0.9
	slowdown = 0
	offline_slowdown = 0
	offline_vision_restriction = 0
	siemens_coefficient = 0.9
	chest_type = /obj/item/clothing/suit/fluff/nikki

	req_access = list()
	req_one_access = list()

	helm_type = null
	glove_type = null
	boot_type = null

	allowed = list(
		/obj/item/device/flashlight,
		/obj/item/weapon/tank,
		/obj/item/device/suit_cooling_unit,
		/obj/item/weapon/storage,
		)

/obj/item/weapon/rig/nikki/attackby(obj/item/W, mob/living/user)
	//This thing accepts ONLY mounted sizeguns. That's IT. Nothing else!
	if(open && istype(W,/obj/item/rig_module) && !istype(W,/obj/item/rig_module/mounted/sizegun))
		to_chat(user, "<span class='danger'>\The [src] only accepts mounted size gun modules.</span>")
		return
	..()

/obj/item/weapon/rig/nikki/mob_can_equip(var/mob/living/carbon/human/M, slot, disable_warning = 0) // Feel free to (try to) put Nikki's hat on! The necklace though is a flat-out no-go.
	if(..())
		if (M.ckey == "ryumi")
			return 1
		else if (M.get_active_hand() == src)
			to_chat(M, "<span class='warning'>For some reason, the necklace seems to never quite get past your head when you try to put it on... Weird, it looked like it would fit.</span>")
			return 0

//Nickcrazy - Damon Bones Xrim
/obj/item/clothing/suit/storage/toggle/bomber/bombersec
    name = "Security Bomber Jacket"
    desc = "A black bomber jacket with the security emblem sewn onto it."
    icon = 'icons/vore/custom_items_vr.dmi'
    icon_override = 'icons/vore/custom_items_vr.dmi'
    icon_state = "bombersec"


//pimientopyro - Scylla Casmus
/obj/item/clothing/glasses/fluff/scylla
	name = "Cherry-Red Shades"
	desc = "These cheap, cherry-red cat-eye glasses seem to give you the inclination to eat chalk when you wear them."

	icon = 'icons/vore/custom_items_vr.dmi'
	icon_state = "blindshades"

	icon_override = 'icons/vore/custom_clothes_vr.dmi'
	item_state = "blindshades_mob"

//Storesund97 - Aurora
/obj/item/clothing/accessory/solgov/department/security/aurora
	name = "Old security insignia"
	desc = "Insignia denoting assignment to the security department. These fit Expeditionary Corps uniforms. This one seems to be from the 2100s..."

//Tigercat2000 - Shadow Larkens
/obj/item/modular_computer/laptop/preset/custom_loadout/advanced/shadowlarkens
	name = "Shadow's laptop computer"
	desc = "A laptop with a different color scheme than usual!"
	icon = 'icons/vore/custom_items_vr.dmi'
	overlay_icon = 'icons/obj/modular_laptop.dmi'
	icon_state_unpowered = "shadowlaptop-open"
	icon_state = "shadowlaptop-open"
	icon_state_closed = "shadowlaptop-closed"

//Rboys2 - Clara Mali
/obj/item/weapon/reagent_containers/food/drinks/glass2/fluff/claraflask
	name = "Clara's Vacuum Flask"
	desc = "A rose gold vacuum flask."
	base_name = "Clara's Vacuum Flask"
	base_icon = "claraflask"
	icon = 'icons/vore/custom_items_vr.dmi'
	center_of_mass = list("x" = 15,"y" = 4)
	filling_states = list(15, 30, 50, 60, 80, 100)
	volume = 60

/obj/item/weapon/reagent_containers/food/drinks/glass2/fluff/claraflask/Initialize()
	. = ..()
	reagents.add_reagent("tea", 40)
	reagents.add_reagent("milk", 20)

/obj/item/weapon/reagent_containers/food/drinks/glass2/fluff/claraflask/update_icon()
	..()
	name = initial(name)
	desc = initial(desc)

//Vitoras: Verie
/obj/item/weapon/fluff/verie
	name = "glowy hairbrush"
	desc = "A pulse of light periodically zips across the top of this blue brush. This... is not an ordinary hair care tool. \
	A small inscription can be seen in one side of the brush: \"THIS DEVICE IS ONLY COMPATIBLE WITH MODEL <b>RI</b> \
	POSITRONICS IN A MODEL <b>E</b> CHASSIS.\""
	icon = 'icons/vore/custom_items_vr.dmi'
	icon_state = "verie_brush"
	w_class = ITEMSIZE_TINY

	var/owner = "vitoras"

/obj/item/weapon/fluff/verie/attack_self(mob/living/carbon/human/user)
	if (istype(user))
		// It's only made for Verie's chassis silly!
		if (user.ckey != owner)
			to_chat(user, "<span class='warning'>The brush's teeth are far too rough to even comb your hair. Apparently, \
			this device was not made for people like you.</span>")
			return

		if (!user.hair_accessory_style)
			var/datum/sprite_accessory/hair_accessory/verie_hair_glow/V = new(user)
			user.hair_accessory_style = V
			user.update_hair()
			user.visible_message("[user] combs her hair. \The [src] leaves behind glowing cyan highlights as it passes through \
			her black strands.", \
			"<span class='notice'>You brush your hair. \The [src]'s teeth begin to vibrate and glow as they react to your nanites. \
			The teeth stimulate the nanites in your hair strands until your hair give off a brilliant, faintly pulsing \
			cyan glow!</span>")

		else
			user.visible_message("[user] combs her hair. \The [src] brushes away her glowing cyan highlights. Neat!", \
			"<span class='notice'>You brush your hair. \The [src]'s teeth wipe away the glowing streaks in your hair \
			like a sponge scrubbing away a stain.</span>")
			user.hair_accessory_style = null
			for(var/datum/sprite_accessory/hair_accessory/verie_hair_glow/V in user)
				to_chat(user, "<span class='warning'>found a V to delete!</span>")
				qdel(V)
			user.update_hair()


	else
		to_chat(user, "<span class='warning'>\The [src] isn't compatible with your body as it is now.</span>")

// Astra - // Astra
/obj/item/weapon/material/knife/ritual/fluff/astra
	name = "Polished Ritual Knife"
	desc = "A well kept strange ritual knife, There is a small tag with the name 'Astra Ether' on it. They are probably looking for this."
	icon = 'icons/obj/wizard.dmi'
	icon_state = "render"

//AlFalah - Charlotte Graves
/obj/item/weapon/storage/fancy/fluff/charlotte
	name = "inconspicuous cigarette case"
	desc = "A SkyTron 3000 cigarette case with no additional functions. The buttons and CRT monitor are completely for show and have no functions. Seriously. "
	icon_state = "charlotte"
	icon = 'icons/vore/custom_items_vr.dmi'
	storage_slots = 7
	can_hold = list(/obj/item/clothing/mask/smokable/cigarette, /obj/item/weapon/flame/lighter, /obj/item/trash/cigbutt)
	icon_type = "charlotte"
	//brand = "\improper Professional 120"
	w_class = ITEMSIZE_TINY
	starts_with = list(/obj/item/clothing/mask/smokable/cigarette = 7)

/obj/item/weapon/storage/fancy/fluff/charlotte/New()
	if(!open_state)
		open_state = "[initial(icon_state)]0"
	if(!closed_state)
		closed_state = "[initial(icon_state)]"
	..()

/obj/item/weapon/storage/fancy/fluff/charlotte/update_icon()
	cut_overlays()
	if(open)
		icon_state = open_state
		if(contents.len >= 1)
			add_overlay("charlottebox[contents.len]")
	else
		icon_state = closed_state

/obj/item/weapon/storage/fancy/fluff/charlotte/open(mob/user as mob)
	if(open)
		return
	open = TRUE
	update_icon()
	..()

/obj/item/weapon/storage/fancy/fluff/charlotte/close(mob/user as mob)
	open = FALSE
	update_icon()
	..()

//Ashling - Antoinette deKaultieste
/obj/item/weapon/material/knife/machete/hatchet/unathiknife/fluff/antoinette
	name = "sawtooth ritual knife"
	desc = "A mostly decorative knife made from thin ceramic and toothed with large black fangs. Printed on the flat is an eight-armed cross, like an asterisk with an extra stroke, ringed by a calligraphy-style crescent."
	attack_verb = list("mauled", "bit", "sawed", "butchered")
	dulled = 1
	default_material = "glass"


//Ashling - Antoinette deKaultieste
/obj/item/clothing/accessory/storage/ritualharness/fluff/antoinette
	name = "silk knife loops"
	desc = "A clip-on pair of pouched loops made from surprisingly sturdy silk. Made for holding knives and small vials in a pinch."
	icon_state = "unathiharness1"
	slots = 2

/obj/item/weapon/reagent_containers/glass/bottle/poppy
	name = "poppy flour bottle"
	desc = "A small bottle of finely ground poppyseed and mixed dried berries."
	icon = 'icons/obj/chemical.dmi'
	icon_state = "bottle3"
	prefill = list("bicaridine" = 30, "nutriment" = 30)

/obj/item/clothing/accessory/storage/ritualharness/fluff/antoinette/Initialize()
	. = ..()
	hold.max_storage_space = ITEMSIZE_COST_SMALL * 2
	hold.can_hold = list(/obj/item/weapon/material/knife, /obj/item/weapon/reagent_containers/glass/bottle)

	new /obj/item/weapon/material/knife/machete/hatchet/unathiknife/fluff/antoinette(hold)
	new /obj/item/weapon/reagent_containers/glass/bottle/poppy(hold)


//Hunterbirk - Amaryll
//This is a 'technical item' which basically is meant to represent rippiing things up with bare claws.
/obj/item/weapon/surgical/scalpel/amaryll_claws
	name = "Amaryll's Claws"
	desc = "This doesn't quite look like what it really is."
	icon = 'icons/vore/custom_items_vr.dmi'
	icon_state = "claws"
	drop_sound = null
	pickup_sound = null
	origin_tech = null
	matter = null

//Coolcrow420 - Jade Davis
/obj/item/weapon/stamp/fluff/jade_horror
	name = "Council of Mid Horror rubber stamp"
	icon = 'icons/vore/custom_items_vr.dmi'
	icon_state = "stamp-midhorror"
	stamptext = "This paper has been certified by The Council of Mid Horror"

//Coolcrow420 - M41l
/obj/item/weapon/implant/language/fluff/m41l
	name = "dusty hard drive"
	desc = "A hard drive containing knowledge of various languages."

/obj/item/weapon/implant/language/fluff/m41l/post_implant(mob/M)
	to_chat(M,"<span class='notice'>LANGUAGES - LOADING</span>")
	M.add_language(LANGUAGE_SKRELLIAN)
	M.add_language(LANGUAGE_UNATHI)
	M.add_language(LANGUAGE_SIIK)
	M.add_language(LANGUAGE_EAL)
	M.add_language(LANGUAGE_SCHECHI)
	M.add_language(LANGUAGE_ZADDAT)
	M.add_language(LANGUAGE_BIRDSONG)
	M.add_language(LANGUAGE_SAGARU)
	M.add_language(LANGUAGE_DAEMON)
	M.add_language(LANGUAGE_ENOCHIAN)
	M.add_language(LANGUAGE_VESPINAE)
//	M.add_language(LANGUAGE_SLAVIC)
	M.add_language(LANGUAGE_DRUDAKAR)
	M.add_language(LANGUAGE_SPACER)
	M.add_language(LANGUAGE_TAVAN)
	M.add_language(LANGUAGE_ECHOSONG)
	to_chat(M,"<span class='notice'>LANGUAGES - INITIALISED</span>")

//thedavestdave - Lucky
/obj/item/clothing/suit/armor/combat/crusader_costume/lucky
	icon = 'icons/vore/custom_clothes_vr.dmi'
	icon_state = "luck"
	icon_override = 'icons/vore/custom_clothes_vr.dmi'
	item_state = "luck"
	name = "Lucky's armor"
	desc = "A chain mail suit with a badly drawn one eared cat on the front."


//RevolverEloise - Revolver Eloise
/obj/item/weapon/sword/fluff/revolver
	name = "Catnip"
	desc = "A steel claymore with what appears to be a teppi engraved into the hilt and a finely forged metal cuboid for a pommel. The blade is honed and balanced to an unusually high degree and has clearly been meticulously cared for."
	icon = 'icons/vore/custom_items_vr.dmi'
	icon_state = "revclaymore"
	icon_override = 'icons/vore/custom_items_vr.dmi'
	item_state = "revclaymoremob"
	force = 1
	sharp = TRUE
	edge = TRUE

//PastelPrinceDan - Kiyoshi/Masumi Maki
/obj/item/toy/plushie/fluff/slimeowshi
	name = "Slime-Cat Research Director plushie"
	desc = "An adorable stuffed toy that resembles a slime. It's pink, and has little cat ears, as well as a tail! Atop its head is a small beret with a Research Director's insignia."
	icon = 'icons/vore/custom_items_vr.dmi'
	icon_state = "kimeowshi"
	attack_verb = list("blorbled", "slimed", "absorbed", "glomped")
	gender = PLURAL // this seems like a good idea but probably prone to changing. todo: ask dan
	// the only reason this thought is relevant because the base slimeplush has its gender set to female

//YeCrowbarMan - Lemon Yellow
/obj/item/toy/plushie/fluff/lemonplush
	name = "yellow slime plushie"
	desc = "A well-worn slime custom-made yellow plushie, extensively hugged and loved. It reeks of lemon."
	icon = 'icons/vore/custom_items_vr.dmi'
	icon_state = "lemonplush"
	attack_verb = list("blorbled", "slimed", "absorbed", "glomped")

//Bricker98:Nettie Stough
/obj/item/modular_computer/tablet/preset/custom_loadout/nettie
  name = "Remodeled Tablet"
  desc = "A tablet computer, looks quite high-tech and has some emblems on the back."
  icon = 'icons/obj/modular_tablet.dmi'
  icon_state = "elite"
  icon_state_unpowered = "elite"

/obj/item/modular_computer/tablet/preset/custom_loadout/nettie/install_default_hardware()
  ..()
  processor_unit = new/obj/item/weapon/computer_hardware/processor_unit/small(src)
  tesla_link = new/obj/item/weapon/computer_hardware/tesla_link(src)
  hard_drive = new/obj/item/weapon/computer_hardware/hard_drive/(src)
  network_card = new/obj/item/weapon/computer_hardware/network_card/advanced(src)
  nano_printer = new/obj/item/weapon/computer_hardware/nano_printer(src)
  battery_module = new/obj/item/weapon/computer_hardware/battery_module(src)
  battery_module.charge_to_full()


//Stobarico - Kyu Comet
/obj/item/instrument/piano_synth/fluff/kyutar
	name = "Kyu's Custom Instrument"
	desc = "A pastel pink guitar-like instrument with a body resembling a smug cat face. It seems to have a few different parts from a regular stringed instrument, including the lack of any strings, and the hand looking like a small screen, which connects to a small array of projectors."
	icon = 'icons/vore/custom_items_vr.dmi'
	item_icons = list(slot_l_hand_str = 'icons/vore/custom_items_left_hand_vr.dmi', slot_r_hand_str = 'icons/vore/custom_items_right_hand_vr.dmi')
	icon_state = "kyuholotar"

//Pandora029 - Seona Young
/obj/item/toy/plushie/fluff/seona_mofuorb
	name = "comically oversized fox-orb plushie"
	desc = "A humongous & adorable Largo© brand stuffed-toy that resembles a mix of slime and absurdly fluffy fox. It's colored white largely, with the tips of it's fox-like ears and tail transitioning to a nice pink-ish color. Comes complete with reactive expressions, according to the label."
	icon = 'icons/vore/custom_items_vr.dmi'
	icon_state = "pandorba"
	pokephrase = "Gecker!"
	attack_verb = list("fluffed", "fwomped", "fuwa'd", "squirmshed")

/obj/item/toy/plushie/fluff/seona_mofuorb/attack_self(mob/user as mob)
	if(stored_item && opened && !searching)
		searching = TRUE
		if(do_after(user, 10))
			to_chat(user, "You find \icon[stored_item] [stored_item] in [src]!")
			stored_item.forceMove(get_turf(src))
			stored_item = null
			searching = FALSE
			return
		else
			searching = FALSE

	if(world.time - last_message <= 5 SECONDS)
		return
	if(user.a_intent == I_HELP)
		user.visible_message("<span class='notice'><b>\The [user]</b> hugs [src]!</span>","<span class='notice'>You hug [src]!</span>")
		icon_state = "pandorba"
	else if (user.a_intent == I_HURT)
		user.visible_message("<span class='warning'><b>\The [user]</b> punches [src]!</span>","<span class='warning'>You punch [src]!</span>")
		icon_state = "pandorba_h"
	else if (user.a_intent == I_GRAB)
		user.visible_message("<span class='warning'><b>\The [user]</b> attempts to strangle [src]!</span>","<span class='warning'>You attempt to strangle [src]!</span>")
		icon_state = "pandorba_g"
	else
		user.visible_message("<span class='notice'><b>\The [user]</b> pokes [src].</span>","<span class='notice'>You poke [src].</span>")
		icon_state = "pandorba_d"
		playsound(src, 'sound/items/drop/plushie.ogg', 25, 0)
		visible_message("[src] says, \"[pokephrase]\"")
	last_message = world.time

//Yeehawguvnah - Cephyra

/obj/item/weapon/dice/loaded/ceph
	name = "engraved d6"
	desc = "A die with six sides. It's fairly well-made, made of an unclear black material with silver pips. If you were to touch it, your hands tingle slightly as though from static. On closer inspection, it's finely engraved with curving, fractal patterns."
	icon_state = "ceph_d66"

/obj/item/weapon/dice/loaded/ceph/rollDice(mob/user, silent)
	..()
	icon_state = "ceph_d6[result]"

/obj/item/weapon/dice/loaded/ceph/New()
	icon_state = "ceph_d6[rand(1,sides)]"
