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
/obj/item/device/pda/heads/hos/joanpda
	icon = 'icons/vore/custom_items_vr.dmi'
	icon_state = "pda-joan"

//Vorrarkul:Lucina Dakarim
/obj/item/device/pda/heads/cmo/lucinapda
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
		item_state = "flag_federation_mob"

	xcom
		name = "Alien Combat Command Banner"
		desc = "A banner bearing the symbol of a task force fighting an unknown alien power."

		icon = 'icons/vore/custom_items_vr.dmi'
		icon_state = "flag_xcom"

		icon_override = 'icons/vore/custom_items_vr.dmi'
		item_state = "flag_xcom_mob"

	advent
		name = "ALIEN Coalition Banner"
		desc = "A banner belonging to traitors who work for an unknown alien power."

		icon = 'icons/vore/custom_items_vr.dmi'
		icon_state = "flag_advent"

		icon_override = 'icons/vore/custom_items_vr.dmi'
		item_state = "flag_advent_mob"


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
	w_class = ITEMSIZE_NORMAL
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

//arokha:Aronai Kadigan - Centcom ID (Medical dept)
/obj/item/weapon/card/id/centcom/fluff/aronai
	registered_name = "CONFIGURE ME"
	assignment = "CC Medical"
	var/configured = 0

	attack_self(mob/user as mob)
		if(configured == 1) return ..()

		user.set_id_info(src)
		configured = 1
		user << "<span class='notice'>Card settings set.</span>"

//arokha:Aronai Kadigan - Bloo glasses
/obj/item/clothing/glasses/omnihud/med/fluff/aronai
	name = "AR-K glasses"
	desc = "The KHI-63-K AR glasses are KHI's normal AR shades for people who don't want implanted AR. \
	These seem pretty fully featured in terms of medical software."
	mode = "med"
	flash_prot = 2

	icon = 'icons/vore/custom_items_vr.dmi'
	icon_override = 'icons/vore/custom_clothes_vr.dmi'
	icon_state = "omniglasses"

//arokha:Aronai Kadigan - Fluff hypospray
/obj/item/weapon/reagent_containers/hypospray/vr/fluff/aronai
	name = "worn hypospray"
	desc = "This hypospray seems a bit well-used. The blue band indicates it's from the CentCom medical division. There's an 'A' scratched into the bottom."
	icon = 'icons/vore/custom_items_vr.dmi'
	icon_state = "aro_hypo"

	New()
		..()
		loaded_vial.name = "[initial(loaded_vial.name)] (tricord)"
		loaded_vial.desc = "30 Tricordrazine"
		reagents.add_reagent("tricordrazine", 30)

//arokha:Aronai Kadigan - Vials to go with mk2 hypo
/obj/item/weapon/reagent_containers/glass/beaker/vial/vr/fluff
	aro_st
		name = "vial (stabilize)"
		desc = "10 Tricordrazine, 10 Dexalin Plus, 5 Tramadol, 5 Inaprovaline"
		comes_with = list("tricordrazine"=10,"dexalinp"=10,"tramadol"=5,"inaprovaline"=5)
	aro_bt
		name = "vial (brute)"
		desc = "25 Bicaridine, 5 Tricordrazine"
		comes_with = list("bicaridine"=25,"tricordrazine"=5)
	aro_bu
		name = "vial (burn)"
		desc = "10 Kelotane, 15 Dermaline, 5 Tricordrazine"
		comes_with = list("kelotane"=10,"dermaline"=15,"tricordrazine"=5)
	aro_tx
		name = "vial (toxins)"
		desc = "25 Dylovene, 2 Hyronalin, 3 Tricordrazine"
		comes_with = list("anti_toxin"=25,"hyronalin"=2,"tricordrazine"=3)

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
	name = "Modified wolf-taur armor vest"
	desc = "An armored vest that protects against some damage. It appears to be created for a wolf-taur, and seems modified."
	species_restricted = null //Species restricted since all it cares about is a taur half
	icon_override = 'icons/mob/taursuits_vr.dmi' //Needs to be this since it's 64*32
	icon_state = "serdy_armor"
	mob_can_equip(var/mob/living/carbon/human/H, slot, disable_warning = 0)
		if(istype(H) && istype(H.tail_style, /datum/sprite_accessory/tail/taur/wolf))
			icon_override = 'icons/mob/taursuits_vr.dmi' //Just in case
			icon_state = "serdy_armor" //Just in case
			pixel_x = -16
			return ..()
		else
			H << "<span class='warning'>You need to have a wolf-taur half to wear this.</span>"
			return 0

/obj/item/clothing/head/helmet/serdy //SilencedMP5A5's specialty helmet. Uncomment if/when they make their custom item app and are accepted.
	name = "Modified helmet"
	desc = "Standard Security gear. Protects the head from impacts. This one appears to be modified."
	icon = 'icons/vore/custom_clothes_vr.dmi'
	icon_state = "serdyhelm"

	icon_override = 'icons/vore/custom_clothes_vr.dmi'
	item_state = "serdyhelm_mob"

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

	New()
		..()
		update_state(0)

	Destroy() //Waitwaitwait
		if(state == 1)
			process() //Nownownow
		..() //Okfine

	process()
		check_owner()
		if((state > 1) || !owner)
			processing_objects.Remove(src)

	attack_self(mob/user as mob)
		if(state > 0) //Can't re-pair, one time only, for security reasons.
			user << "<span class='notice'>The [name] doesn't do anything.</span>"
			return 0

		owner = user	//We're paired to this guy
		owner_c = user.client	//This is his client
		update_state(1)
		user << "<span class='notice'>The [name] glows pleasantly blue.</span>"
		processing_objects.Add(src)

	proc/check_owner()
		//He's dead, jim
		if((state == 1) && owner && (owner.stat == DEAD))
			update_state(2)
			audible_message("<span class='warning'>The [name] begins flashing red.</span>")
			sleep(30)
			visible_message("<span class='warning'>The [name] shatters into dust!</span>")
			if(owner_c)
				owner_c << "<span class='notice'>The HAVENS system is notified of your demise via \the [name].</span>"
			update_state(3)
			name = "broken [initial(name)]"
			desc = "This seems like a necklace, but the actual pendant is missing."

	proc/update_state(var/tostate)
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
	item_state = "browncanemob"
	flags = CONDUCT
	force = 5.0
	throwforce = 7.0
	w_class = ITEMSIZE_SMALL
	matter = list(DEFAULT_WALL_MATERIAL = 50)
	attack_verb = list("bludgeoned", "whacked", "disciplined", "thrashed")

/obj/item/weapon/card/id/fluff/ivyholoid
	name = "Holo-ID"
	registered_name = "Unconfigured"
	desc = "A thin screen that seems to show an ID card's information. It keeps flickering between the ID and being blank."
	icon = 'icons/vore/custom_items_vr.dmi'
	icon_state = "ivyholoid"
	var/configured = 0

	attack_self(mob/user as mob)
		if(configured == 1) return ..()

		assignment = user.job
		user.set_id_info(src)
		configured = 1
		user << "<span class='notice'>Card settings set.</span>"

//WickedTempest: Chakat Tempest
/obj/item/weapon/reagent_containers/hypospray/vr/tempest
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

//The perfect adminboos device?
/obj/item/device/perfect_tele
	name = "personal translocator"
	desc = "Seems absurd, doesn't it? Yet, here we are. Generally considered dangerous contraband unless the user has permission from Central Command."
	icon = 'icons/obj/device_alt.dmi'
	icon_state = "hand_tele"
	w_class = ITEMSIZE_SMALL
	origin_tech = list(TECH_MAGNET = 5, TECH_BLUESPACE = 5, TECH_ILLEGAL = 7)


	var/list/beacons = list()
	var/ready = 1
	var/beacons_left = 3
	var/obj/item/device/perfect_tele_beacon/destination
	var/datum/effect/effect/system/spark_spread/spk
	var/list/warned_users = list()
	var/list/logged_events = list()

/obj/item/device/perfect_tele/New()
	..()
	flags |= NOBLUDGEON
	spk = new(src)
	spk.set_up(5, 0, src)
	spk.attach(src)

/obj/item/device/perfect_tele/Destroy()
	beacons.Cut()
	qdel(spk)
	..()

/obj/item/device/perfect_tele/update_icon()
	if(ready)
		icon_state = "[initial(icon_state)]"
	else
		icon_state = "[initial(icon_state)]_w"

	..()

/obj/item/device/perfect_tele/attack_self(mob/user)
	if(!(user.ckey in warned_users))
		warned_users |= user.ckey
		alert(user,"This device can be easily used to break ERP preferences due to the nature of teleporting \
		and tele-vore. Make sure you carefully examine someone's OOC prefs before teleporting them if you are \
		going to use this device for ERP purposes. This device records all warnings given and teleport events for \
		admin review in case of pref-breaking, so just don't do it.","OOC WARNING")

	var/choice = alert(user,"What do you want to do?","[src]","Create Beacon","Cancel","Target Beacon")
	switch(choice)
		if("Create Beacon")
			if(beacons_left <= 0)
				user << "<span class='warning'>\The [src] can't support any more beacons!</span>"
				return

			var/new_name = html_encode(input(user,"New beacon's name (2-20 char):","[src]") as text|null)

			if(length(new_name) > 20 || length(new_name) < 2)
				alert("Entered name length invalid (must be longer than 2, no more than than 20).","Error")
				return
			if(new_name in beacons)
				alert("No duplicate names, please. '[new_name]' exists already.","Error")
				return

			var/obj/item/device/perfect_tele_beacon/nb = new(get_turf(src))
			nb.tele_name = new_name
			nb.tele_hand = src
			nb.creator = user.ckey
			beacons[new_name] = nb
			beacons_left--
			if(isliving(user))
				var/mob/living/L = user
				L.put_in_any_hand_if_possible(nb)

		if("Target Beacon")
			if(!beacons.len)
				user << "<span class='warning'>\The [src] doesn't have any beacons!</span>"
			else
				var/target = input("Which beacon do you target?","[src]") in beacons|null
				if(target && (target in beacons))
					destination = beacons[target]
					user << "<span class='notice'>Destination set to '[target]'.</span>"
		else
			return

/obj/item/device/perfect_tele/attackby(obj/W, mob/user)
	if(istype(W,/obj/item/device/perfect_tele_beacon))
		var/obj/item/device/perfect_tele_beacon/tb = W
		if(tb.tele_name in beacons)
			user << "<span class='notice'>You re-insert \the [tb] into \the [src].</span>"
			beacons -= tb.tele_name
			user.unEquip(tb)
			qdel(tb)
			beacons_left++
		else
			user << "<span class='notice'>\The [tb] doesn't belong to \the [src].</span>"
			return
	else
		..()

/obj/item/device/perfect_tele/afterattack(mob/living/target, mob/living/user, proximity)
	//No, you can't teleport people from over there.
	if(!proximity)
		return

	//Only mob/living need apply.
	if(!istype(user) || !istype(target))
		return

	//No, you can't teleport buckled people.
	if(target.buckled)
		user << "<span class='warning'>The target appears to be attached to something...</span>"
		return

	//No, you can't teleport if it's not ready yet.
	if(!ready)
		user << "<span class='warning'>\The [src] is still recharging!</span>"
		return

	//No, you can't teleport if there's no destination.
	if(!destination)
		user << "<span class='warning'>\The [src] doesn't have a current valid destination set!</span>"
		return

	//No, you can't port to or from away missions. Stupidly complicated check.
	var/turf/uT = get_turf(user)
	var/turf/dT = get_turf(destination)
	if(!uT || !dT)
		return

	if( (uT.z != dT.z) && ( (uT.z > max_default_z_level() ) || (dT.z > max_default_z_level()) ) )
		user << "<span class='warning'>\The [src] can't teleport you that far!</span>"
		return

	//Bzzt.
	ready = 0

	//Destination beacon vore checking
	var/datum/belly/target_belly
	var/atom/real_dest = get_turf(destination)

	//Destination beacon is held/eaten
	if(isliving(destination.loc) && (target != destination.loc)) //We should definitely get televored unless we're teleporting ourselves into ourselves
		var/mob/living/L = destination.loc

		//Is the beacon IN a belly?
		target_belly = check_belly(destination)

		//No? Well do they have vore organs at all?
		if(!target_belly && L.vore_organs.len)

			//If they do, use their picked one.
			if(L.vore_selected)
				target_belly = L.vore_organs[L.vore_selected]
			else
				//Else just use the first one.
				var/I = L.vore_organs[1] //We're just going to use 1
				target_belly = L.vore_organs[I]

	//Televore fluff stuff
	if(target_belly)
		real_dest = destination.loc
		target_belly.internal_contents |= target
		playsound(target_belly.owner, target_belly.vore_sound, 100, 1)
		target << "<span class='warning'>\The [src] teleports you right into [target_belly.owner]'s [target_belly.name]!</span>"
		target_belly.owner << "<span class='warning'>Your [target_belly.name] suddenly has a new occupant!</span>"

	//Phase-out effect
	phase_out(target,get_turf(target))

	//Move them
	target.forceMove(real_dest)

	//Phase-in effect
	phase_in(target,get_turf(target))

	//And any friends!
	for(var/obj/item/weapon/grab/G in target.contents)
		if(G.affecting && (G.state >= GRAB_AGGRESSIVE))

			//Phase-out effect for grabbed person
			phase_out(G.affecting,get_turf(G.affecting))

			//Move them, and televore if necessary
			G.affecting.forceMove(real_dest)
			if(target_belly)
				target_belly.internal_contents |= G.affecting
				G.affecting << "<span class='warning'>\The [src] teleports you right into [target_belly.owner]'s [target_belly.name]!</span>"

			//Phase-in effect for grabbed person
			phase_in(G.affecting,get_turf(G.affecting))

	update_icon()
	spawn(30 SECONDS)
		if(src) //If we still exist, anyway.
			ready = 1
			update_icon()

	logged_events["[world.time]"] = "[user] teleported [target] to [real_dest] [target_belly ? "(Belly: [target_belly.name])" : null]"

/obj/item/device/perfect_tele/proc/phase_out(var/mob/M,var/turf/T)

	if(!M || !T)
		return

	spk.set_up(5, 0, M)
	spk.attach(M)
	playsound(T, "sparks", 50, 1)
	anim(T,M,'icons/mob/mob.dmi',,"phaseout",,M.dir)

/obj/item/device/perfect_tele/proc/phase_in(var/mob/M,var/turf/T)

	if(!M || !T)
		return

	spk.start()
	playsound(T, 'sound/effects/phasein.ogg', 25, 1)
	playsound(T, 'sound/effects/sparks2.ogg', 50, 1)
	anim(T,M,'icons/mob/mob.dmi',,"phasein",,M.dir)
	spk.set_up(5, 0, src)
	spk.attach(src)

/obj/item/device/perfect_tele_beacon
	name = "translocator beacon"
	desc = "That's unusual."
	icon = 'icons/obj/device_alt.dmi'
	icon_state = "motion2"
	w_class = ITEMSIZE_TINY

	var/tele_name
	var/obj/item/device/perfect_tele/tele_hand
	var/creator
	var/warned_users = list()

/obj/item/device/perfect_tele_beacon/New()
	..()
	flags |= NOBLUDGEON

/obj/item/device/perfect_tele_beacon/Destroy()
	tele_name = null
	tele_hand = null
	..()

/obj/item/device/perfect_tele_beacon/attack_hand(mob/user)
	if((user.ckey != creator) && !(user.ckey in warned_users))
		warned_users |= user.ckey
		var/choice = alert(user,"This device is a translocator beacon. Having it on your person may mean that anyone \
		who teleports to this beacon gets teleported into your selected vore-belly. If you are prey-only \
		or don't wish to potentially have a random person teleported into you, it's suggested that you \
		not carry this around.","OOC WARNING","Take It","Leave It")
		if(choice == "Leave It")
			return

	..()

/obj/item/device/perfect_tele_beacon/attack_self(mob/user)
	if(!isliving(user))
		return
	var/mob/living/L = user
	var/confirm = alert(user, "You COULD eat the beacon...", "Eat beacon?", "Eat it!", "No, thanks.")
	if(confirm == "Eat it!")
		var/bellychoice = input("Which belly?","Select A Belly") in L.vore_organs|null
		if(bellychoice)
			var/datum/belly/B = L.vore_organs[bellychoice]
			user.visible_message("<span class='warning'>[user] is trying to stuff \the [src] into [user.gender == MALE ? "his" : user.gender == FEMALE ? "her" : "their"] [bellychoice]!</span>","<span class='notice'>You begin putting \the [src] into your [bellychoice]!</span>")
			if(do_after(user,5 SECONDS,src))
				user.unEquip(src)
				src.forceMove(user)
				B.internal_contents |= src
				user.visible_message("<span class='warning'>[user] eats a telebeacon!</span>","You eat the the beacon!")
				playsound(user, B.vore_sound, 70, 1)

//Universal translator
/obj/item/device/universal_trans
	name = "handheld translator"
	desc = "This handy device appears to translate the languages it hears into onscreen text for a user."
	icon = 'icons/obj/device_alt.dmi'
	icon_state = "atmos"
	w_class = ITEMSIZE_SMALL
	origin_tech = list(TECH_DATA = 3, TECH_ENGINEERING = 3)
	var/listening = 0
	var/datum/language/langset

/obj/item/device/universal_trans/attack_self(mob/user)
	if(!listening) //Turning ON
		langset = input(user,"Translate to which of your languages?","Language Selection") as anything|null in user.languages
		if(langset)
			listening = 1
			listening_objects |= src
			icon_state = "[initial(icon_state)]1"
			user << "<span class='notice'>You enable \the [src], translating into [langset.name].</span>"
	else //Turning OFF
		listening = 0
		listening_objects -= src
		langset = null
		icon_state = "[initial(icon_state)]"
		user << "<span class='notice'>You disable \the [src].</span>"


/obj/item/device/universal_trans/hear_talk(var/mob/speaker,var/message,var/vrb,var/datum/language/language)
	if(!listening || !istype(speaker))
		return

	//Show the "I heard something" animation.
	flick("[initial(icon_state)]2",src)

	//Handheld or pocket only.
	if(!isliving(loc))
		return

	var/mob/living/L = loc

	if (language && (language.flags & NONVERBAL))
		return //Not gonna translate sign language

	//Only translate if they can't understand, otherwise pointlessly spammy
	//I'll just assume they don't look at the screen in that case

	//They don't understand the spoken language we're translating FROM
	if(!L.say_understands(speaker,language))

		//They understand the PRINTED language
		if(L.say_understands(null,langset))
			L << "<i><b>[src]</b> displays, </i>\"<span class='[langset.colour]'>[message]</span>\""

		//They don't understand the PRINTED language
		else
			L << "<i><b>[src]</b> displays, </i>\"<span class='[langset.colour]'>[langset.scramble(message)]</span>\""
