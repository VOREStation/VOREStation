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

	//Conversion proc
/obj/item/device/modkit_conversion/afterattack(obj/O, mob/user as mob)
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
		to_chat(user, "<span class='warning'>This kit has no parts for this modification left.</span>")
		return
	if(istype(O,to_type))
		to_chat(user, "<span class='notice'>[O] is already modified.</span>")
		return
	if(!isturf(O.loc))
		to_chat(user, "<span class='warning'>[O] must be safely placed on the ground for modification.</span>")
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
	icon_override = 'icons/vore/custom_items_vr.dmi'
	item_state = "joanariamob"
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
/obj/item/weapon/material/knife/tacknife/combatknife/fluff/katarina
	name = "tactical Knife"
	desc = "A tactical knife with a small butterly engraved on the blade."

/obj/item/weapon/material/knife/tacknife/combatknife/fluff/katarina/handle_shield(mob/user, var/damage, atom/damage_source = null, mob/attacker = null, var/def_zone = null, var/attack_text = "the attack")

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
	icon_state = "mouse_brown"	//TFF 12/11/19 - Change sprite to not look dead. Heck you for that choice! >:C
	item_state = "mouse_brown_head"
	icon = 'icons/vore/custom_items_vr.dmi'
	icon_override = 'icons/vore/custom_items_vr.dmi'

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
		playsound(user.loc, 'sound/items/polaroid2.ogg', 100, 1)
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
	name = "KSS-8 security armor"
	desc = "A set of armor made from pieces of many other armors. There are two orange holobadges on it, one on the chestplate, one on the steel flank plates. The holobadges appear to be russian in origin. 'Kosmicheskaya Stantsiya-8' is printed in faded white letters on one side, along the spine. It smells strongly of dog."
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

/obj/item/clothing/head/helmet/serdy //SilencedMP5A5's specialty helmet. Uncomment if/when they make their custom item app and are accepted.
	name = "KSS-8 security helmet"
	desc = "desc = An old production model steel-ceramic lined helmet with a white stripe and a custom orange holographic visor. It has ear holes, and smells of dog. It's been heavily modified, and fitted with a metal mask to protect the jaw."
	icon = 'icons/vore/custom_clothes_vr.dmi'
	icon_state = "serdyhelm"

	icon_override = 'icons/vore/custom_clothes_vr.dmi'
	item_state = "serdyhelm_mob"

/*
//SilencedMP5A5:Serdykov Antoz
/obj/item/device/modkit_conversion/fluff/serdykit
	name = "Serdykov's armor modification kit"
	desc = "A kit containing all the needed tools and parts to modify a armor vest and helmet for a specific user. This one looks like it's fitted for a wolf-taur."

	icon = 'icons/vore/custom_items_vr.dmi'
	icon_state = "modkit"

	from_helmet = /obj/item/clothing/head/helmet
	from_suit = /obj/item/clothing/suit/armor/vest/wolftaur
	to_helmet = /obj/item/clothing/head/helmet/serdy
	to_suit = /obj/item/clothing/suit/armor/vest/wolftaur/serdy
*/

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
		audible_message("<span class='warning'>The [name] begins flashing red.</span>")
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
	matter = list(DEFAULT_WALL_MATERIAL = 50)
	attack_verb = list("bludgeoned", "whacked", "disciplined", "thrashed")

/obj/item/weapon/cane/fluff/tasald
	name = "Ornate Walking Cane"
	desc = "An elaborately made custom walking stick with a dark wooding core, a crimson red gemstone on its head and a steel cover around the bottom. you'd probably hear someone using this down the hall."
	icon = 'icons/vore/custom_items_vr.dmi'

//Stobarico - Alexis Bloise
/obj/item/weapon/cane/wand
    name = "Ancient wand"
    desc = "A really old looking wand with floating parts and cyan crystals, wich seem to radiate a cyan glow. The wand has a golden plaque on the side that would say Corncobble, but it is covered by a sticker saying Bloise."
    icon = 'icons/vore/custom_items_vr.dmi'
    icon_state = "alexiswand"
    item_icons = list (slot_r_hand_str = 'icons/vore/custom_items_vr.dmi', slot_l_hand_str = 'icons/vore/custom_items_vr.dmi')
    item_state_slots = list(slot_r_hand_str = "alexiswandmob_r", slot_l_hand_str = "alexiswandmob_l")
    force = 1.0
    throwforce = 2.0
    w_class = ITEMSIZE_SMALL
    matter = list(DEFAULT_WALL_MATERIAL = 50)
    attack_verb = list("sparkled", "whacked", "twinkled", "radiated", "dazzled", "zapped")
    hitsound = 'sound/weapons/sparkle.ogg'
    var/last_use = 0
    var/cooldown = 30

/obj/item/weapon/cane/wand/attack_self(mob/user)
    if(last_use + cooldown >= world.time)
        return
    playsound(loc, 'sound/weapons/sparkle.ogg', 50, 1)
    user.visible_message("<span class='warning'> [user] swings their wand.</span>")
    var/datum/effect/effect/system/spark_spread/s = new
    s.set_up(3, 1, src)
    s.start()
    last_use = world.time
    qdel ()

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
		playsound(user.loc, 'sound/items/polaroid2.ogg', 100, 1)
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

//WickedTempest: Chakat Tempest
/obj/item/weapon/implant/reagent_generator/tempest
	generated_reagents = list("milk" = 2)
	reagent_name = "milk"
	usable_volume = 1000

	empty_message = list("Your breasts are almost completely drained!")
	full_message = list("Your teats feel heavy and swollen!")
	emote_descriptor = list("squeezes milk", "tugs on Tempest's breasts, milking them")
	self_emote_descriptor = list("squeeze")
	random_emote = list("moos quietly")
	verb_name = "Milk"
	verb_desc = "Grab Tempest's nipples and milk them into a container! May cause blushing and groaning."

/obj/item/weapon/implanter/reagent_generator/tempest
	implant_type = /obj/item/weapon/implant/reagent_generator/tempest


//Hottokeeki: Belle Day
/obj/item/weapon/implant/reagent_generator/belle
	generated_reagents = list("milk" = 2)
	reagent_name = "milk"
	usable_volume = 5000

	empty_message = list("Your breasts and or udder feel almost completely drained!", "You're feeling a liittle on the empty side...")
	full_message = list("You're due for a milking; your breasts and or udder feel heavy and swollen!", "Looks like you've got some full tanks!")
	emote_descriptor = list("squeezes milk", "tugs on Belle's breasts/udders, milking them", "extracts milk")
	self_emote_descriptor = list("squeeze", "extract")
	random_emote = list("moos", "mrours", "groans softly")
	verb_name = "Milk"
	verb_desc = "Obtain Belle's milk and put it into a container! May cause blushing and groaning, or arousal."

/obj/item/weapon/implanter/reagent_generator/belle
	implant_type = /obj/item/weapon/implant/reagent_generator/belle

//Gowst: Eldi Moljir
//Eldi iz coolest elf-dorf.
/obj/item/weapon/implant/reagent_generator/eldi
	name = "lactation implant"
	desc = "This is an implant that allows the user to lactate."
	generated_reagents = list("milk" = 2)
	reagent_name = "milk"
	usable_volume = 1000

	empty_message = list("Your breasts feel unusually empty.", "Your chest feels lighter - your milk supply is empty!", "Your milk reserves have run dry.", "Your grateful nipples ache as the last of your milk leaves them.")
	full_message = list("Your breasts ache badly - they are swollen and feel fit to burst!", "You need to be milked! Your breasts feel bloated, eager for release.", "Your milky breasts are starting to leak...")
	emote_descriptor = list("squeezes Eldi's nipples, milking them", "milks Eldi's breasts", "extracts milk")
	self_emote_descriptor = list("squeeze out", "extract")
	random_emote = list("surpresses a moan", "gasps sharply", "bites her lower lip")
	verb_name = "Milk"
	verb_desc = "Grab Eldi's breasts and milk her, storing her fresh, warm milk in a container. This will undoubtedly turn her on."

/obj/item/weapon/implanter/reagent_generator/eldi
	implant_type = /obj/item/weapon/implant/reagent_generator/eldi

//Vorrarkul: Theodora Lindt
/obj/item/weapon/implant/reagent_generator/vorrarkul
	generated_reagents = list("chocolate_milk" = 2)
	reagent_name = "chocalate milk"
	usable_volume = 1000

	empty_message = list("Your nipples are sore from being milked!")
	full_message = list("Your breasts are full, their sweet scent emanating from your chest!")
	emote_descriptor = list("squeezes chocolate milk from Theodora", "tugs on Theodora's nipples, milking them", "kneads Theodora's breasts, milking them")
	self_emote_descriptor = list("squeeze", "knead")
	random_emote = list("moans softly", "gives an involuntary squeal")
	verb_name = "Milk"
	verb_desc = "Grab Theodora's breasts and extract delicious chocolate milk from them!"

/obj/item/weapon/implanter/reagent_generator/vorrarkul
	implant_type = /obj/item/weapon/implant/reagent_generator/vorrarkul

//Lycanthorph: Savannah Dixon
/obj/item/weapon/implant/reagent_generator/savannah
	generated_reagents = list("milk" = 2)
	reagent_name = "milk"
	usable_volume = 1000

	empty_message = list("Your nipples are sore from being milked!", "Your breasts feel drained, milk is no longer leaking from your nipples!")
	full_message = list("Your breasts are full, their sweet scent emanating from your chest!", "Your breasts feel full, milk is starting to leak from your nipples, filling the air with it's sweet scent!")
	emote_descriptor = list("squeezes sweet milk from Savannah", "tugs on Savannah's nipples, milking them", "kneads Savannah's breasts, milking them")
	self_emote_descriptor = list("squeeze", "knead")
	random_emote = list("lets out a soft moan", "gives an involuntary squeal")
	verb_name = "Milk"
	verb_desc = "Grab Savannah's breasts and extract sweet milk from them!"

/obj/item/weapon/implanter/reagent_generator/savannah
	implant_type = /obj/item/weapon/implant/reagent_generator/savannah

//SpoopyLizz: Roiz Lizden
//I made this! Woo!
//implant
//--------------------
/obj/item/weapon/implant/reagent_generator/roiz
	name = "egg laying implant"
	desc = "This is an implant that allows the user to lay eggs."
	generated_reagents = list("egg" = 2)
	usable_volume = 500
	transfer_amount = 50

	empty_message = list("Your lower belly feels smooth and empty. Sorry, we're out of eggs!", "The reduced pressure in your lower belly tells you there are no more eggs.")
	full_message = list("Your lower belly looks swollen with irregular bumps, and it feels heavy.", "Your lower abdomen feels really heavy, making it a bit hard to walk.")
	emote_descriptor = list("an egg right out of Roiz's lower belly!", "into Roiz' belly firmly, forcing him to lay an egg!", "Roiz really tight, who promptly lays an egg!")
	var/verb_descriptor = list("squeezes", "pushes", "hugs")
	var/self_verb_descriptor = list("squeeze", "push", "hug")
	var/short_emote_descriptor = list("lays", "forces out", "pushes out")
	self_emote_descriptor = list("lay", "force out", "push out")
	random_emote = list("hisses softly with a blush on his face", "yelps in embarrassment", "grunts a little")
	assigned_proc = /mob/living/carbon/human/proc/use_reagent_implant_roiz

/obj/item/weapon/implant/reagent_generator/roiz/post_implant(mob/living/carbon/source)
	START_PROCESSING(SSobj, src)
	to_chat(source, "<span class='notice'>You implant [source] with \the [src].</span>")
	source.verbs |= assigned_proc
	return 1

/obj/item/weapon/implanter/reagent_generator/roiz
	implant_type = /obj/item/weapon/implant/reagent_generator/roiz

/mob/living/carbon/human/proc/use_reagent_implant_roiz()
	set name = "Lay Egg"
	set desc = "Force Roiz to lay an egg by squeezing into his lower body! This makes the lizard extremely embarrassed, and it looks funny."
	set category = "Object"
	set src in view(1)

	//do_reagent_implant(usr)
	if(!isliving(usr) || !usr.canClick())
		return

	if(usr.incapacitated() || usr.stat > CONSCIOUS)
		return

	var/obj/item/weapon/implant/reagent_generator/roiz/rimplant
	for(var/obj/item/organ/external/E in organs)
		for(var/obj/item/weapon/implant/I in E.implants)
			if(istype(I, /obj/item/weapon/implant/reagent_generator))
				rimplant = I
				break
	if (rimplant)
		if(rimplant.reagents.total_volume <= rimplant.transfer_amount)
			to_chat(src, "<span class='notice'>[pick(rimplant.empty_message)]</span>")
			return

		new /obj/item/weapon/reagent_containers/food/snacks/egg/roiz(get_turf(src))

		var/index = rand(0,3)

		if (usr != src)
			var/emote = rimplant.emote_descriptor[index]
			var/verb_desc = rimplant.verb_descriptor[index]
			var/self_verb_desc = rimplant.self_verb_descriptor[index]
			usr.visible_message("<span class='notice'>[usr] [verb_desc] [emote]</span>",
							"<span class='notice'>You [self_verb_desc] [emote]</span>")
		else
			visible_message("<span class='notice'>[src] [pick(rimplant.short_emote_descriptor)] an egg.</span>",
								"<span class='notice'>You [pick(rimplant.self_emote_descriptor)] an egg.</span>")
		if(prob(15))
			visible_message("<span class='notice'>[src] [pick(rimplant.random_emote)].</span>") // M-mlem.

		rimplant.reagents.remove_any(rimplant.transfer_amount)

//Cameron653: Jasmine Lizden
/obj/item/weapon/implant/reagent_generator/jasmine
	name = "egg laying implant"
	desc = "This is an implant that allows the user to lay eggs."
	generated_reagents = list("egg" = 2)
	usable_volume = 500
	transfer_amount = 50

	empty_message = list("Your lower belly feels flat, empty, and somewhat rough!", "Your lower belly feels completely empty, no more bulges visible... At least, for the moment!")
	full_message = list("Your lower belly is stretched out, smooth,and heavy, small bulges visible from within!", "It takes considerably more effort to move yourself, the large bulges within your gut most likely the cause!")
	emote_descriptor = list("an egg from Jasmine's tauric belly!", "into Jasmine's gut, forcing her to lay a considerably large egg!", "Jasmine with a considerable amount of force, causing an egg to slip right out of her!")
	var/verb_descriptor = list("squeezes", "pushes", "hugs")
	var/self_verb_descriptor = list("squeeze", "push", "hug")
	var/short_emote_descriptor = list("lays", "forces out", "pushes out")
	self_emote_descriptor = list("lay", "force out", "push out")
	random_emote = list("hisses softly with a blush on her face", "bites down on her lower lip", "lets out a light huff")
	assigned_proc = /mob/living/carbon/human/proc/use_reagent_implant_jasmine

/obj/item/weapon/implant/reagent_generator/jasmine/post_implant(mob/living/carbon/source)
	START_PROCESSING(SSobj, src)
	to_chat(source, "<span class='notice'>You implant [source] with \the [src].</span>")
	source.verbs |= assigned_proc
	return 1

/obj/item/weapon/implanter/reagent_generator/jasmine
	implant_type = /obj/item/weapon/implant/reagent_generator/jasmine

/mob/living/carbon/human/proc/use_reagent_implant_jasmine()
	set name = "Lay Egg"
	set desc = "Cause Jasmine to lay an egg by squeezing her tauric belly!"
	set category = "Object"
	set src in view(1)

	//do_reagent_implant(usr)
	if(!isliving(usr) || !usr.canClick())
		return

	if(usr.incapacitated() || usr.stat > CONSCIOUS)
		return

	var/obj/item/weapon/implant/reagent_generator/jasmine/rimplant
	for(var/obj/item/organ/external/E in organs)
		for(var/obj/item/weapon/implant/I in E.implants)
			if(istype(I, /obj/item/weapon/implant/reagent_generator))
				rimplant = I
				break
	if (rimplant)
		if(rimplant.reagents.total_volume <= rimplant.transfer_amount)
			to_chat(src, "<span class='notice'>[pick(rimplant.empty_message)]</span>")
			return

		new /obj/item/weapon/reagent_containers/food/snacks/egg/roiz(get_turf(src))

		var/index = rand(0,3)

		if (usr != src)
			var/emote = rimplant.emote_descriptor[index]
			var/verb_desc = rimplant.verb_descriptor[index]
			var/self_verb_desc = rimplant.self_verb_descriptor[index]
			usr.visible_message("<span class='notice'>[usr] [verb_desc] [emote]</span>",
							"<span class='notice'>You [self_verb_desc] [emote]</span>")
		else
			visible_message("<span class='notice'>[src] [pick(rimplant.short_emote_descriptor)] an egg.</span>",
								"<span class='notice'>You [pick(rimplant.self_emote_descriptor)] an egg.</span>")
		if(prob(15))
			visible_message("<span class='notice'>[src] [pick(rimplant.random_emote)].</span>")

		rimplant.reagents.remove_any(rimplant.transfer_amount)

//Draycu: Schae Yonra
/obj/item/weapon/implant/reagent_generator/yonra
	name = "egg laying implant"
	desc = "This is an implant that allows the user to lay eggs."
	generated_reagents = list("egg" = 2)
	usable_volume = 500
	transfer_amount = 50

	empty_message = list("Your feathery lower belly feels smooth and empty. For now...", "The lack of clacking eggs in your abdomen lets you know you're free to continue your day as normal.",  "The reduced pressure in your lower belly tells you there are no more eggs.", "With a soft sigh, you can feel your lower body is empty.  You know it will only be a matter of time before another batch fills you up again, however.")
	full_message = list("Your feathery lower belly looks swollen with irregular bumps, and feels very heavy.", "Your feathery covered lower abdomen feels really heavy, making it a bit hard to walk.", "The added weight from your collection of eggs constantly reminds you that you'll have to lay soon!", "The sounds of eggs clacking as you walk reminds you that you will have to lay soon!")
	emote_descriptor = list("an egg right out of Yonra's feathery crotch!", "into Yonra's belly firmly, forcing her to lay an egg!", ", making Yonra gasp and softly moan while an egg slides out.")
	var/verb_descriptor = list("squeezes", "pushes", "hugs")
	var/self_verb_descriptor = list("squeeze", "push", "hug")
	var/short_emote_descriptor = list("lays", "forces out", "pushes out")
	self_emote_descriptor = list("lay", "force out", "push out")
	random_emote = list("hisses softly with a blush on her face", "yelps in embarrassment", "grunts a little")
	assigned_proc = /mob/living/carbon/human/proc/use_reagent_implant_yonra

/obj/item/weapon/implant/reagent_generator/yonra/post_implant(mob/living/carbon/source)
	START_PROCESSING(SSobj, src)
	to_chat(source, "<span class='notice'>You implant [source] with \the [src].</span>")
	source.verbs |= assigned_proc
	return 1

/obj/item/weapon/implanter/reagent_generator/yonra
	implant_type = /obj/item/weapon/implant/reagent_generator/yonra

/mob/living/carbon/human/proc/use_reagent_implant_yonra()
	set name = "Lay Egg"
	set desc = "Force Yonra to lay an egg by squeezing into her lower body! This makes the Teshari stop whatever she is doing at the time, greatly embarassing her."
	set category = "Object"
	set src in view(1)

	//do_reagent_implant(usr)
	if(!isliving(usr) || !usr.canClick())
		return

	if(usr.incapacitated() || usr.stat > CONSCIOUS)
		return

	var/obj/item/weapon/implant/reagent_generator/yonra/rimplant
	for(var/obj/item/organ/external/E in organs)
		for(var/obj/item/weapon/implant/I in E.implants)
			if(istype(I, /obj/item/weapon/implant/reagent_generator))
				rimplant = I
				break
	if (rimplant)
		if(rimplant.reagents.total_volume <= rimplant.transfer_amount)
			to_chat(src, "<span class='notice'>[pick(rimplant.empty_message)]</span>")
			return

		new /obj/item/weapon/reagent_containers/food/snacks/egg/teshari(get_turf(src))

		var/index = rand(0,3)

		if (usr != src)
			var/emote = rimplant.emote_descriptor[index]
			var/verb_desc = rimplant.verb_descriptor[index]
			var/self_verb_desc = rimplant.self_verb_descriptor[index]
			usr.visible_message("<span class='notice'>[usr] [verb_desc] [emote]</span>",
							"<span class='notice'>You [self_verb_desc] [emote]</span>")
		else
			visible_message("<span class='notice'>[src] [pick(rimplant.short_emote_descriptor)] an egg.</span>",
								"<span class='notice'>You [pick(rimplant.self_emote_descriptor)] an egg.</span>")
		if(prob(15))
			visible_message("<span class='notice'>[src] [pick(rimplant.random_emote)].</span>")

		rimplant.reagents.remove_any(rimplant.transfer_amount)

/obj/item/weapon/reagent_containers/food/snacks/egg/teshari
	name = "teshari egg"
	desc = "It's a large teshari egg."
	icon = 'icons/vore/custom_items_vr.dmi'
	icon_state = "tesh_egg"
	filling_color = "#FDFFD1"
	volume = 12

/obj/item/weapon/reagent_containers/food/snacks/egg/teshari/New()
	..()
	reagents.add_reagent("egg", 10)
	bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/egg/teshari/tesh2
	icon_state = "tesh_egg_2"

//Konabird: Rischi
/obj/item/weapon/implant/reagent_generator/rischi
	name = "egg laying implant"
	desc = "This is an implant that allows the user to lay eggs."
	generated_reagents = list("egg" = 2)
	usable_volume = 3000 //They requested 1 egg every ~30 minutes.
	transfer_amount = 3000

	empty_message = list("Your abdomen feels normal and taught, like usual.", "The lack of eggs in your abdomen leaves your belly flat and smooth.",  "The reduced pressure in your belly tells you there are no more eggs.", "With a soft sigh, you can feel your body is empty of eggs.  You know it will only be a matter of time before an egg forms once again, however.")
	full_message = list("Your lower abdomen feels a bit swollen", "You feel a pressure within your abdomen, and a broody mood slowly creeps over you.", "You can feel the egg inside of you shift as you move, the needy feeling to lay slowly growing stronger!", "You can feel the egg inside of you, swelling out your normally taught abdomen considerably. You'll definitely need to lay soon!")
	emote_descriptor = list("Rischi, causing the small female to squeak and wriggle, an egg falling from between her legs!", "Rischi's midsection, forcing her to lay an egg!", "Rischi, the Teshari huffing and grunting as an egg is squeezed from her body!")
	var/verb_descriptor = list("squeezes", "squashes", "hugs")
	var/self_verb_descriptor = list("squeeze", "push", "hug")
	var/short_emote_descriptor = list("lays", "forces out", "pushes out")
	self_emote_descriptor = list("lay", "force out", "push out")
	random_emote = list("trembles and huffs, panting from the exertion.", "sees what has happened and covers her face with both hands!", "whimpers softly, her legs shivering, knees pointed inward from the feeling.")
	assigned_proc = /mob/living/carbon/human/proc/use_reagent_implant_rischi

/obj/item/weapon/implant/reagent_generator/rischi/post_implant(mob/living/carbon/source)
	START_PROCESSING(SSobj, src)
	to_chat(source, "<span class='notice'>You implant [source] with \the [src].</span>")
	source.verbs |= assigned_proc
	return 1

/obj/item/weapon/implanter/reagent_generator/rischi
	implant_type = /obj/item/weapon/implant/reagent_generator/rischi

/mob/living/carbon/human/proc/use_reagent_implant_rischi()
	set name = "Lay Egg"
	set desc = "Force Rischi to lay an egg by squeezing her! What a terribly rude thing to do!"
	set category = "Object"
	set src in view(1)

	//do_reagent_implant(usr)
	if(!isliving(usr) || !usr.canClick())
		return

	if(usr.incapacitated() || usr.stat > CONSCIOUS)
		return

	var/obj/item/weapon/implant/reagent_generator/rischi/rimplant
	for(var/obj/item/organ/external/E in organs)
		for(var/obj/item/weapon/implant/I in E.implants)
			if(istype(I, /obj/item/weapon/implant/reagent_generator))
				rimplant = I
				break
	if (rimplant)
		if(rimplant.reagents.total_volume <= rimplant.transfer_amount)
			to_chat(src, "<span class='notice'>[pick(rimplant.empty_message)]</span>")
			return

		new /obj/item/weapon/reagent_containers/food/snacks/egg/teshari/tesh2(get_turf(src))

		var/index = rand(0,3)

		if (usr != src)
			var/emote = rimplant.emote_descriptor[index]
			var/verb_desc = rimplant.verb_descriptor[index]
			var/self_verb_desc = rimplant.self_verb_descriptor[index]
			usr.visible_message("<span class='notice'>[usr] [verb_desc] [emote]</span>",
							"<span class='notice'>You [self_verb_desc] [emote]</span>")
		else
			visible_message("<span class='notice'>[src] falls to her knees as the urge to lay overwhelms her, letting out a whimper as she [pick(rimplant.short_emote_descriptor)] an egg from between her legs.</span>",
								"<span class='notice'>You fall to your knees as the urge to lay overwhelms you, letting out a whimper as you [pick(rimplant.self_emote_descriptor)] an egg from between your legs.</span>")
		if(prob(15))
			visible_message("<span class='notice'>[src] [pick(rimplant.random_emote)].</span>")

		rimplant.reagents.remove_any(rimplant.transfer_amount)

/*
/obj/item/weapon/implant/reagent_generator/pumila_nectar //Bugged. Two implants at once messes things up.
	generated_reagents = list("honey" = 2)
	reagent_name = "honey"
	usable_volume = 5000

	empty_message = list("You appear to be all out of nectar", "You feel as though you are lacking a majority of your nectar.")
	full_message = list("You appear to be full of nectar.", "You feel as though you are full of nectar!")
	emote_descriptor = list("squeezes nectar", "extracts nectar")
	self_emote_descriptor = list("squeeze", "extract")
	verb_name = "Extract Honey"
	verb_desc = "Obtain pumila's nectar and put it into a container!"

/obj/item/weapon/implanter/reagent_generator/pumila_nectar
	implant_type = /obj/item/weapon/implant/reagent_generator/pumila_nectar
*/
//Egg item
//-------------
/obj/item/weapon/reagent_containers/food/snacks/egg/roiz
	name = "lizard egg"
	desc = "It's a large lizard egg."
	icon = 'icons/vore/custom_items_vr.dmi'
	icon_state = "egg_roiz"
	filling_color = "#FDFFD1"
	volume = 12

/obj/item/weapon/reagent_containers/food/snacks/egg/roiz/New()
	..()
	reagents.add_reagent("egg", 9)
	bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/egg/roiz/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(istype( W, /obj/item/weapon/pen/crayon ))
		var/obj/item/weapon/pen/crayon/C = W
		var/clr = C.colourName

		if(!(clr in list("blue","green","mime","orange","purple","rainbow","red","yellow")))
			to_chat(user, "<span class='warning'>The egg refuses to take on this color!</span>")
			return

		to_chat(user, "<span class='notice'>You color \the [src] [clr]</span>")
		icon_state = "egg_roiz_[clr]"
		desc = "It's a large lizard egg. It has been colored [clr]!"
		if (clr == "rainbow")
			var/number = rand(1,4)
			icon_state = icon_state + num2text(number, 0)
	else
		..()

/obj/item/weapon/reagent_containers/food/snacks/friedegg/roiz
	name = "fried lizard egg"
	desc = "A large, fried lizard egg, with a touch of salt and pepper. It looks rather chewy."
	icon = 'icons/vore/custom_items_vr.dmi'
	icon_state = "friedegg"
	volume = 12

/obj/item/weapon/reagent_containers/food/snacks/friedegg/roiz/New()
	..()
	reagents.add_reagent("protein", 9)
	bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/boiledegg/roiz
	name = "boiled lizard egg"
	desc = "A hard boiled lizard egg. Be careful, a lizard detective may hatch!"
	icon = 'icons/vore/custom_items_vr.dmi'
	icon_state = "egg_roiz"
	volume = 12

/obj/item/weapon/reagent_containers/food/snacks/boiledegg/roiz/New()
	..()
	reagents.add_reagent("protein", 6)
	bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/chocolateegg/roiz
	name = "chocolate lizard egg"
	desc = "Such huge, sweet, fattening food. You feel gluttonous just looking at it."
	icon = 'icons/vore/custom_items_vr.dmi'
	icon_state = "chocolateegg_roiz"
	filling_color = "#7D5F46"
	nutriment_amt = 3
	nutriment_desc = list("chocolate" = 5)
	volume = 18

/obj/item/weapon/reagent_containers/food/snacks/chocolateegg/roiz/New()
	..()
	reagents.add_reagent("sugar", 6)
	reagents.add_reagent("coco", 6)
	reagents.add_reagent("milk", 2)
	bitesize = 2

//PontifexMinimus: Lucius/Lucia Null
/obj/item/weapon/fluff/dragor_dot
	name = "supplemental battery"
	desc = "A tiny supplemental battery for powering something or someone synthetic."
	icon = 'icons/vore/custom_items_vr.dmi'
	icon_state = "dragor_dot"
	w_class = ITEMSIZE_SMALL

	attack_self(mob/user as mob)
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
/obj/item/weapon/card/id/fluff/amaya
	registered_name = "CONFIGURE ME"
	assignment = "CONFIGURE ME"
	var/configured = 0
	var/accessset = 0
	icon = 'icons/vore/custom_items_vr.dmi'
	icon_state = "amayarahlwahID"
	desc = "A primarily blue ID with a holographic 'WAH' etched onto its back. The letters do not obscure anything important on the card. It is shiny and it feels very bumpy."
	var/title_strings = list("Amaya Rahl's Wah-identification card", "Amaya Rahl's Wah-ID card")

/obj/item/weapon/card/id/fluff/amaya/attack_self(mob/user as mob)
	if(configured == 1)
		return ..()

	var/title
	if(user.client.prefs.player_alt_titles[user.job])
		title = user.client.prefs.player_alt_titles[user.job]
	else
		title = user.job
	assignment = title
	user.set_id_info(src)
	if(user.mind && user.mind.initial_account)
		associated_account_number = user.mind.initial_account.account_number
	var/tempname = pick(title_strings)
	name = tempname + " ([title])"
	configured = 1
	to_chat(user, "<span class='notice'>Card settings set.</span>")

/obj/item/weapon/card/id/fluff/amaya/attackby(obj/item/I as obj, mob/user as mob)
	if(istype(I, /obj/item/weapon/card/id) && !accessset)
		var/obj/item/weapon/card/id/O = I
		access |= O.access
		to_chat(user, "<span class='notice'>You copy the access from \the [I] to \the [src].</span>")
		user.drop_from_inventory(I)
		qdel(I)
		accessset = 1
	..()

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

//General use.
/obj/item/weapon/material/twohanded/fluff/riding_crop
	name = "riding crop"
	desc = "A steel rod, a little over a foot long with a widened grip and a thick, leather patch at the end. Made to smack naughty submissives."
	//force_wielded = 0.05 //Stings, but does jack shit for damage, provided you don't hit someone 100 times. 1 damage with hardness of 60.
	force_divisor = 0.05 //Required in order for the X attacks Y message to pop up.
	unwielded_force_divisor = 1 // One here, too.
	applies_material_colour = 0
	unbreakable = 1
	base_icon = "riding_crop"
	icon_state = "riding_crop0"
	attack_verb = list("cropped","spanked","swatted","smacked","peppered")
//1R1S: Malady Blanche
/obj/item/weapon/material/twohanded/fluff/riding_crop/malady
	name = "Malady's riding crop"
	desc = "An infernum made riding crop with Malady Blanche engraved in the shaft. It's a little worn from how many butts it has spanked."


//SilverTalisman: Evian
/obj/item/weapon/implant/reagent_generator/evian
	emote_descriptor = list("an egg right out of Evian's lower belly!", "into Evian' belly firmly, forcing him to lay an egg!", "Evian really tight, who promptly lays an egg!")
	var/verb_descriptor = list("squeezes", "pushes", "hugs")
	var/self_verb_descriptor = list("squeeze", "push", "hug")
	var/short_emote_descriptor = list("lays", "forces out", "pushes out")
	self_emote_descriptor = list("lay", "force out", "push out")
	random_emote = list("hisses softly with a blush on his face", "yelps in embarrassment", "grunts a little")
	assigned_proc = /mob/living/carbon/human/proc/use_reagent_implant_evian

/obj/item/weapon/implant/reagent_generator/evian/post_implant(mob/living/carbon/source)
	START_PROCESSING(SSobj, src)
	to_chat(source, "<span class='notice'>You implant [source] with \the [src].</span>")
	source.verbs |= assigned_proc
	return 1

/obj/item/weapon/implanter/reagent_generator/evian
	implant_type = /obj/item/weapon/implant/reagent_generator/evian

/mob/living/carbon/human/proc/use_reagent_implant_evian()
	set name = "Lay Egg"
	set desc = "Force Evian to lay an egg by squeezing into his lower body! This makes the lizard extremely embarrassed, and it looks funny."
	set category = "Object"
	set src in view(1)

	//do_reagent_implant(usr)
	if(!isliving(usr) || !usr.canClick())
		return

	if(usr.incapacitated() || usr.stat > CONSCIOUS)
		return

	var/obj/item/weapon/implant/reagent_generator/evian/rimplant
	for(var/obj/item/organ/external/E in organs)
		for(var/obj/item/weapon/implant/I in E.implants)
			if(istype(I, /obj/item/weapon/implant/reagent_generator))
				rimplant = I
				break
	if (rimplant)
		if(rimplant.reagents.total_volume <= rimplant.transfer_amount)
			to_chat(src, "<span class='notice'>[pick(rimplant.empty_message)]</span>")
			return

		new /obj/item/weapon/reagent_containers/food/snacks/egg/roiz/evian(get_turf(src)) //Roiz/evian so it gets all the functionality

		var/index = rand(0,3)

		if (usr != src)
			var/emote = rimplant.emote_descriptor[index]
			var/verb_desc = rimplant.verb_descriptor[index]
			var/self_verb_desc = rimplant.self_verb_descriptor[index]
			usr.visible_message("<span class='notice'>[usr] [verb_desc] [emote]</span>",
							"<span class='notice'>You [self_verb_desc] [emote]</span>")
		else
			visible_message("<span class='notice'>[src] [pick(rimplant.short_emote_descriptor)] an egg.</span>",
								"<span class='notice'>You [pick(rimplant.self_emote_descriptor)] an egg.</span>")
		if(prob(15))
			visible_message("<span class='notice'>[src] [pick(rimplant.random_emote)].</span>") // M-mlem.

		rimplant.reagents.remove_any(rimplant.transfer_amount)

/obj/item/weapon/reagent_containers/food/snacks/egg/roiz/evian
	name = "dragon egg"
	desc = "A quite large dragon egg!"
	icon_state = "egg_roiz_yellow"


/obj/item/weapon/reagent_containers/food/snacks/egg/roiz/evian/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(istype( W, /obj/item/weapon/pen/crayon)) //No coloring these ones!
		return
	else
		..()

//jacknoir413:Areax Third
/obj/item/weapon/melee/baton/fluff/stunstaff
	name = "Electrostaff"
	desc = "Six-foot long staff from dull, rugged metal, with two thin spikes protruding from each end. Small etching near to the middle of it reads 'Children Of Nyx Facilities: Product No. 12'."
	icon = 'icons/vore/custom_items_vr.dmi'
	item_icons = list(slot_l_hand_str = 'icons/vore/custom_items_left_hand_vr.dmi', slot_r_hand_str = 'icons/vore/custom_items_right_hand_vr.dmi')
	icon_state = "stunstaff00"
	var/base_icon = "stunstaff"
	force = 5
	sharp = 0
	edge = 0
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
		playsound(user.loc, 'sound/weapons/punchmiss.ogg', 50, 1)
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
			playsound(user, 'sound/weapons/saberoff.ogg', 50, 1)
		else
			playsound(user, 'sound/weapons/saberon.ogg', 50, 1)
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
	sharp = 0
	edge = 0

/obj/item/weapon/melee/fluffstuff/proc/activate(mob/living/user)
	if(active)
		return
	active = 1
	embed_chance = active_embed_chance
	force = active_force
	throwforce = active_throwforce
	sharp = 1
	edge = 1
	w_class = active_w_class
	playsound(user, 'sound/weapons/sparkle.ogg', 50, 1)

/obj/item/weapon/melee/fluffstuff/proc/deactivate(mob/living/user)
	if(!active)
		return
	playsound(user, 'sound/weapons/sparkle.ogg', 50, 1)
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

/obj/item/weapon/melee/fluffstuff/suicide_act(mob/user)
	var/tempgender = "[user.gender == MALE ? "he's" : user.gender == FEMALE ? "she's" : "they are"]"
	if(active)
		user.visible_message(pick("<span class='danger'>\The [user] is slitting \his stomach open with \the [src]! It looks like [tempgender] trying to commit seppuku.</span>",\
			"<span class='danger'>\The [user] is falling on \the [src]! It looks like [tempgender] trying to commit suicide.</span>"))
		return (BRUTELOSS|FIRELOSS)

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
	sharp = 1
	edge = 1
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
	..()
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
