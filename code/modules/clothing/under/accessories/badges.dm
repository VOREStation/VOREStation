/*
	Badges are worn on the belt or neck, and can be used to show that the holder is an authorized
	Security agent - the user details can be imprinted on holobadges with a Security-access ID card,
	or they can be emagged to accept any ID for use in disguises.
*/

/obj/item/clothing/accessory/badge
	name = "detective's badge"
	desc = "Security Department detective's badge, made from gold."
	icon_state = "badge"
	slot_flags = SLOT_BELT | SLOT_TIE
	slot = ACCESSORY_SLOT_MEDAL

	var/stored_name
	var/badge_string = "Corporate Security"

/obj/item/clothing/accessory/badge/old
	name = "faded badge"
	desc = "A faded badge, backed with leather. It bears the emblem of the Forensic division."
	icon_state = "badge_round"

/obj/item/clothing/accessory/badge/proc/set_name(var/new_name)
	stored_name = new_name
	name = "[initial(name)] ([stored_name])"

/obj/item/clothing/accessory/badge/proc/set_desc(var/mob/living/carbon/human/H)

/obj/item/clothing/accessory/badge/attack_self(mob/user as mob)

	if(!stored_name)
		to_chat(user, "You polish your old badge fondly, shining up the surface.")
		set_name(user.real_name)
		return

	if(isliving(user))
		if(stored_name)
			user.visible_message("<span class='notice'>[user] displays their [src.name].\nIt reads: [stored_name], [badge_string].</span>","<span class='notice'>You display your [src.name].\nIt reads: [stored_name], [badge_string].</span>")
		else
			user.visible_message("<span class='notice'>[user] displays their [src.name].\nIt reads: [badge_string].</span>","<span class='notice'>You display your [src.name]. It reads: [badge_string].</span>")

/obj/item/clothing/accessory/badge/attack(mob/living/carbon/human/M, mob/living/user)
	if(isliving(user))
		user.visible_message("<span class='danger'>[user] invades [M]'s personal space, thrusting [src] into their face insistently.</span>","<span class='danger'>You invade [M]'s personal space, thrusting [src] into their face insistently.</span>")
		user.do_attack_animation(M)
		user.setClickCooldown(DEFAULT_QUICK_COOLDOWN) //to prevent spam

// Sheriff Badge (toy)
/obj/item/clothing/accessory/badge/sheriff
	name = "sheriff badge"
	desc = "This town ain't big enough for the two of us, pardner."
	icon_state = "sheriff"
	item_state = "goldbadge"

/obj/item/clothing/accessory/badge/sheriff/attack_self(mob/user as mob)
	user.visible_message("[user] shows their sheriff badge. There's a new sheriff in town!",\
		"You flash the sheriff badge to everyone around you!")

/obj/item/clothing/accessory/badge/sheriff/attack(mob/living/carbon/human/M, mob/living/user)
	if(isliving(user))
		user.visible_message("<span class='danger'>[user] invades [M]'s personal space, the sheriff badge into their face!.</span>","<span class='danger'>You invade [M]'s personal space, thrusting the sheriff badge into their face insistently.</span>")
		user.do_attack_animation(M)
		user.setClickCooldown(DEFAULT_QUICK_COOLDOWN) //to prevent spam

//.Holobadges.
/obj/item/clothing/accessory/badge/holo
	name = "holobadge"
	desc = "This glowing blue badge marks the holder as THE LAW."
	icon_state = "holobadge"
	var/emagged //Emagging removes Sec check.

/obj/item/clothing/accessory/badge/holo/cord
	icon_state = "holobadge-cord"
	slot_flags = SLOT_MASK | SLOT_TIE | SLOT_BELT

/obj/item/clothing/accessory/badge/holo/attack_self(mob/user as mob)
	if(!stored_name)
		to_chat(user, "Waving around a holobadge before swiping an ID would be pretty pointless.")
		return
	return ..()

/obj/item/clothing/accessory/badge/holo/emag_act(var/remaining_charges, var/mob/user)
	if (emagged)
		to_chat(user, "<span class='danger'>\The [src] is already cracked.</span>")
		return
	else
		emagged = 1
		to_chat(user, "<span class='danger'>You crack the holobadge security checks.</span>")
		return 1

/obj/item/clothing/accessory/badge/holo/attackby(var/obj/item/O as obj, var/mob/user as mob)
	if(istype(O, /obj/item/weapon/card/id) || istype(O, /obj/item/device/pda))

		var/obj/item/weapon/card/id/id_card = null

		if(istype(O, /obj/item/weapon/card/id))
			id_card = O
		else
			var/obj/item/device/pda/pda = O
			id_card = pda.id

		if(access_security in id_card.access || emagged)
			to_chat(user, "You imprint your ID details onto the badge.")
			set_name(user.real_name)
		else
			to_chat(user, "[src] rejects your insufficient access rights.")
		return
	..()

/obj/item/weapon/storage/box/holobadge
	name = "holobadge box"
	desc = "A box claiming to contain holobadges."
	New()
		new /obj/item/clothing/accessory/badge/holo(src)
		new /obj/item/clothing/accessory/badge/holo(src)
		new /obj/item/clothing/accessory/badge/holo(src)
		new /obj/item/clothing/accessory/badge/holo(src)
		new /obj/item/clothing/accessory/badge/holo/cord(src)
		new /obj/item/clothing/accessory/badge/holo/cord(src)
		..()
		return

/obj/item/clothing/accessory/badge/holo/warden
	name = "warden's holobadge"
	desc = "A silver corporate security badge. Stamped with the words 'Warden.'"
	icon_state = "silverbadge"
	slot_flags = SLOT_TIE | SLOT_BELT

/obj/item/clothing/accessory/badge/holo/hos
	name = "head of security's holobadge"
	desc = "An immaculately polished gold security badge. Labeled 'Head of Security.'"
	icon_state = "goldbadge"
	slot_flags = SLOT_TIE | SLOT_BELT

/obj/item/clothing/accessory/badge/holo/detective
	name = "detective's holobadge"
	desc = "An immaculately polished gold security badge on leather. Labeled 'Detective.'"
	icon_state = "marshalbadge"
	slot_flags = SLOT_TIE | SLOT_BELT

/obj/item/weapon/storage/box/holobadge/hos
	name = "holobadge box"
	desc = "A box claiming to contain holobadges."
	New()
		new /obj/item/clothing/accessory/badge/holo(src)
		new /obj/item/clothing/accessory/badge/holo(src)
		new /obj/item/clothing/accessory/badge/holo/warden(src)
		new /obj/item/clothing/accessory/badge/holo/detective(src)
		new /obj/item/clothing/accessory/badge/holo/detective(src)
		new /obj/item/clothing/accessory/badge/holo/hos(src)
		new /obj/item/clothing/accessory/badge/holo/cord(src)
		..()
		return

// Synthmorph bag / Corporation badges. Primarily used on the robobag, but can be worn. Default is NT.

/obj/item/clothing/accessory/badge/corporate_tag
	name = "NanoTrasen Badge"
	desc = "A plain metallic plate that might denote the wearer as a member of NanoTrasen."
	icon_state = "tag_nt"
	item_state = "badge"
	badge_string = "NanoTrasen"

/obj/item/clothing/accessory/badge/corporate_tag/morpheus
	name = "Morpheus Badge"
	desc = "A plain metallic plate that might denote the wearer as a member of Morpheus Cyberkinetics."
	icon_state = "tag_blank"
	badge_string = "Morpheus"

/obj/item/clothing/accessory/badge/corporate_tag/wardtaka
	name = "Ward-Takahashi Badge"
	desc = "A plain metallic plate that might denote the wearer as a member of Ward-Takahashi."
	icon_state = "tag_ward"
	badge_string = "Ward-Takahashi"

/obj/item/clothing/accessory/badge/corporate_tag/zenghu
	name = "Zeng-Hu Badge"
	desc = "A plain metallic plate that might denote the wearer as a member of Zeng-Hu."
	icon_state = "tag_zeng"
	badge_string = "Zeng-Hu"

/obj/item/clothing/accessory/badge/corporate_tag/gilthari
	name = "Gilthari Badge"
	desc = "An opulent metallic plate that might denote the wearer as a member of Gilthari."
	icon_state = "tag_gil"
	badge_string = "Gilthari"

/obj/item/clothing/accessory/badge/corporate_tag/veymed
	name = "Vey-Medical Badge"
	desc = "A plain metallic plate that might denote the wearer as a member of Vey-Medical."
	icon_state = "tag_vey"
	badge_string = "Vey-Medical"

/obj/item/clothing/accessory/badge/corporate_tag/hephaestus
	name = "Hephaestus Badge"
	desc = "A rugged metallic plate that might denote the wearer as a member of Hephaestus."
	icon_state = "tag_heph"
	badge_string = "Hephaestus"

/obj/item/clothing/accessory/badge/corporate_tag/grayson
	name = "Grayson Badge"
	desc = "A rugged metallic plate that might denote the wearer as a member of Grayson."
	icon_state = "tag_grayson"
	badge_string = "Grayson"

/obj/item/clothing/accessory/badge/corporate_tag/xion
	name = "Xion Badge"
	desc = "A rugged metallic plate that might denote the wearer as a member of Xion."
	icon_state = "tag_xion"
	badge_string = "Xion"

/obj/item/clothing/accessory/badge/corporate_tag/bishop
	name = "Bishop Badge"
	desc = "A sleek metallic plate that might denote the wearer as a member of Bishop."
	icon_state = "tag_bishop"
	badge_string = "Bishop"
