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

//arokha:Aronai Kadigan - Fluff hypospray
/obj/item/weapon/reagent_containers/hypospray/vr/fluff/aronai
	name = "worn hypospray"
	desc = "This hypospray seems a bit well-used. The blue band indicates it's from the CentCom medical division. There's an 'A' scratched into the bottom."
	icon = 'icons/vore/custom_items_vr.dmi'
	icon_state = "aro_hypo"

	New()
		..()
		reagents.add_reagent("inaprovaline", 5)
		reagents.add_reagent("tricordrazine", 25)

//arokha:Aronai Kadigan - Vials to go with mk2 hypo
/obj/item/weapon/reagent_containers/glass/beaker/vial/vr
	stabilize
		name = "vial (stabilize)"
		desc = "10 Tricordrazine, 10 Dexalin Plus, 5 Tramadol, 5 Inaprovaline"
		New()
			..()
			reagents.add_reagent("tricordrazine", 10)
			reagents.add_reagent("dexalinp", 10)
			reagents.add_reagent("tramadol", 5)
			reagents.add_reagent("inaprovaline", 5)
	bashed
		name = "vial (brute)"
		desc = "25 Bicaridine, 5 Tricordrazine"
		New()
			..()
			reagents.add_reagent("bicaridine", 25)
			reagents.add_reagent("tricordrazine", 5)
	toasted
		name = "vial (burn)"
		desc = "10 Kelotane, 15 Dermaline, 5 Tricordrazine"
		New()
			..()
			reagents.add_reagent("kelotane", 10)
			reagents.add_reagent("dermaline", 15)
			reagents.add_reagent("tricordrazine", 5)
	poisoned
		name = "vial (toxins)"
		desc = "25 Dylovene, 2 Hyronalin, 3 Tricordrazine"
		New()
			..()
			reagents.add_reagent("anti_toxin", 25)
			reagents.add_reagent("hyronalin", 2)
			reagents.add_reagent("tricordrazine", 3)

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
