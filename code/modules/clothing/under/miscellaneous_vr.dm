/obj/item/clothing/under/customs
	desc = "A standard SolCom customs uniform. Complete with epaulettes."

/obj/item/clothing/var/hides_bulges = FALSE // OwO wats this?

/obj/item/clothing/under/permit
	name = "public nudity permit"
	desc = "This permit entitles the bearer to conduct their duties without a uniform. Normally issued to furred crewmembers or those with nothing to hide."
	icon = 'icons/obj/card_new.dmi'
	icon_state = "permit-nude"
	body_parts_covered = 0
	equip_sound = null

	sprite_sheets = null

	item_state = "golem"  //This is dumb and hacky but was here when I got here.
	worn_state = "golem"  //It's basically just a coincidentally black iconstate in the file.

/obj/item/clothing/under/hyperfiber
	name = "HYPER jumpsuit"
	icon = 'icons/inventory/uniform/item_vr.dmi'
	icon_override = 'icons/inventory/uniform/mob_vr.dmi'
	icon_state = "hyper"
	item_icons = list(
			slot_l_hand_str = 'icons/mob/items/lefthand_uniforms.dmi',
			slot_r_hand_str = 'icons/mob/items/righthand_uniforms.dmi',
			)
	item_state = "hyper"
	worn_state = "hyper"
	desc = "Got a lot to hide on your body? Well, this Heavy Yield Protrusion Erasing and Retracting suit seems perfect for you. \
			Hides any bulges on your body, as well as conceals your true weight."
	hides_bulges = TRUE

/obj/item/clothing/under/hyperfiber/verb/toggle_fibers()
		set category = "Object"
		set name = "Adjust Bluespace Fibers"
		set desc = "Adjust your suit's HYPER fibers. Activating it hides your stomach(s) and your general body-build. Good if you have a lot to hide."
		set src in usr

		adjust_fibers(usr)

/obj/item/clothing/under/hyperfiber/proc/adjust_fibers(mob/user)
	if(hides_bulges == FALSE)
		hides_bulges = TRUE
		to_chat(user, "You tense the suit fibers, hiding your stomach(s) and weight.")
	else
		hides_bulges = FALSE
		to_chat(user, "You relax the suit fibers, revealing your stomach(s) and weight.")

/obj/item/clothing/under/hyperfiber/bluespace
	name = "bluespace jumpsuit"
	icon_state = "bluespace"
	item_state = "bluespace"
	worn_state = "bluespace"
	desc = "Do you feel like warping spacetime today? Because it seems like that's on the agenda, now. \
			Allows one to resize themselves at will, and conceals their true weight as well as any bulges or protrusions on their body."
	var/original_size

/obj/item/clothing/under/hyperfiber/bluespace/verb/resize()
	set name = "Adjust Bluespace Fibers"
	set desc = "Adjust your suit's bluespace fibers. Activating it allows you to expand your own body or reduce it in size! Effect is limited to when you have the suit on."
	set category = "Object"
	set src in usr
	bluespace_size(usr)

/obj/item/clothing/under/hyperfiber/bluespace/proc/bluespace_size(mob/usr as mob)
	if (!ishuman(usr))
		return

	var/mob/living/carbon/human/H = usr

	if (H.stat || H.restrained())
		return

	if (src != H.w_uniform)
		to_chat(H,"<span class='warning'>You must be WEARING the uniform to change your size.</span>")
		return

	var/new_size = tgui_input_number(usr, "Put the desired size (25-200%), or (1-600%) in dormitory areas.", "Set Size", 200, 600, 1)
	if(!new_size)
		return //cancelled

	//Check AGAIN because we accepted user input which is blocking.
	if (src != H.w_uniform)
		to_chat(H,"<span class='warning'>You must be WEARING the uniform to change your size.</span>")
		return

	if (H.stat || H.restrained())
		return

	if (isnull(H.size_multiplier)) // Why would this ever be the case?
		to_chat(H,"<span class='warning'>The uniform panics and corrects your apparently microscopic size.</span>")
		H.resize(RESIZE_NORMAL, ignore_prefs = TRUE)
		H.update_icons() //Just want the matrix transform
		return

	if (!H.size_range_check(new_size))
		to_chat(H,"<span class='notice'>The safety features of the uniform prevent you from choosing this size.</span>")
		return

	else if(new_size)
		if(new_size != H.size_multiplier)
			if(!original_size)
				original_size = H.size_multiplier
			H.resize(new_size/100, uncapped = H.has_large_resize_bounds(), ignore_prefs = TRUE) // Ignores prefs because you can only resize yourself
			H.visible_message("<span class='warning'>The space around [H] distorts as they change size!</span>","<span class='notice'>The space around you distorts as you change size!</span>")
		else //They chose their current size.
			return

/obj/item/clothing/under/hyperfiber/bluespace/mob_can_unequip(mob/M, slot, disable_warning = 0)
	. = ..()
	if(. && ishuman(M) && original_size && !disable_warning)
		var/mob/living/carbon/human/H = M
		H.resize(original_size, ignore_prefs = TRUE)
		original_size = null
		H.visible_message("<span class='warning'>The space around [H] distorts as they return to their original size!</span>","<span class='notice'>The space around you distorts as you return to your original size!</span>")

/obj/item/clothing/gloves/bluespace
	name = "size standardization bracelet"
	desc = "A somewhat bulky metal bracelet featuring a crystal, glowing blue. The outer side of the bracelet has an elongated case that one might imagine contains electronic components. This bracelet is used to standardize the size of crewmembers who may need a non-permanent size assist."
	icon = 'icons/inventory/accessory/item_vr.dmi'
	icon_state = "bs_bracelet"
	w_class = ITEMSIZE_TINY
	glove_level = 1
	var/original_size
	var/last_activated
	var/emagged = FALSE
	var/target_size = 1

/obj/item/proc/equip_special()
	return

/obj/item/clothing/gloves/bluespace/equip_special()
	var/mob/M = src.loc
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(!H.resizable)
			return
		if(H.size_multiplier != target_size)
			if(!(world.time - last_activated > 10 SECONDS))
				to_chat(M, "<span class ='warning'>\The [src] flickers. It seems to be recharging.</span>")
				return
			last_activated = world.time
			original_size = H.size_multiplier
			H.resize(target_size, uncapped = emagged, ignore_prefs = FALSE)		//In case someone else tries to put it on you.
			H.visible_message("<span class='warning'>The space around [H] distorts as they change size!</span>","<span class='notice'>The space around you distorts as you change size!</span>")
			log_admin("Admin [key_name(M)]'s size was altered by a bluespace bracelet.")

/obj/item/clothing/gloves/bluespace/mob_can_equip(mob/M, gloves, disable_warning = 0)
	. = ..()
	if(. && ishuman(M) && !disable_warning)
		var/mob/living/carbon/human/H = M
		if(!H.resizable)
			return
		if(H.size_multiplier != target_size)
			if(!(world.time - last_activated > 10 SECONDS))
				to_chat(M, "<span class ='warning'>\The [src] flickers. It seems to be recharging.</span>")
				return
			last_activated = world.time
			original_size = H.size_multiplier
			H.resize(target_size, uncapped = emagged, ignore_prefs = FALSE)		//In case someone else tries to put it on you.
			H.visible_message("<span class='warning'>The space around [H] distorts as they change size!</span>","<span class='notice'>The space around you distorts as you change size!</span>")
			log_admin("Admin [key_name(M)]'s size was altered by a bluespace bracelet.")

/obj/item/clothing/gloves/bluespace/mob_can_unequip(mob/M, gloves, disable_warning = 0)
	. = ..()
	if(. && ishuman(M) && original_size && !disable_warning)
		var/mob/living/carbon/human/H = M
		if(!H.resizable)
			return
		last_activated = world.time
		H.resize(original_size, uncapped = emagged, ignore_prefs = FALSE)
		original_size = null
		H.visible_message("<span class='warning'>The space around [H] distorts as they return to their original size!</span>","<span class='notice'>The space around you distorts as you return to your original size!</span>")
		log_admin("Admin [key_name(M)]'s size was altered by a bluespace bracelet.")
		to_chat(M, "<span class ='warning'>\The [src] flickers. It is now recharging and will be ready again in thirty seconds.</span>")

/obj/item/clothing/gloves/bluespace/examine(var/mob/user)
	. = ..()
	var/cooldowntime = round((10 SECONDS - (world.time - last_activated)) * 0.1)
	if(Adjacent(user))
		if(cooldowntime >= 0)
			. += "<span class='notice'>It appears to be recharging.</span>"
		if(emagged)
			. += "<span class='warning'>The crystal is flickering.</span>"

/obj/item/clothing/gloves/bluespace/emag_act(R_charges, var/mob/user, emag_source)
	. = ..()
	if(!emagged)
		emagged = TRUE
		target_size = (rand(1,300)) /100
		if(target_size < 0.1)
			target_size = 0.1
		user.visible_message("<span class='notice'>\The [user] swipes the [emag_source] over the \the [src].</span>","<span class='notice'>You swipes the [emag_source] over the \the [src].</span>")
		return 1

//Same as Nanotrasen Security Uniforms
/obj/item/clothing/under/ert
	armor = list(melee = 5, bullet = 10, laser = 10, energy = 5, bomb = 5, bio = 0, rad = 0)

/obj/item/clothing/under/qipao
	name = "black qipao"
	desc = "A type of feminine body-hugging dress with distinctive Chinese features of Manchu origin."
	icon = 'icons/inventory/uniform/item_vr.dmi'
	icon_override = 'icons/inventory/uniform/mob_vr.dmi'
	icon_state = "qipao"
	item_state = "qipao"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO

/obj/item/clothing/under/qipao/white
	name = "white qipao"
	icon_state = "qipao_white"
	item_state = "qipao_white"

/obj/item/clothing/under/qipao/red
	name = "red qipao"
	icon_state = "qipao_red"
	item_state = "qipao_red"

/obj/item/clothing/under/pizzaguy
	name = "pizza delivery uniform"
	desc = "A dedicated outfit for pizza delivery people, one of most dangerous occupations around these parts. Can be rolled up for extra show of skin."
	icon = 'icons/inventory/uniform/item_vr.dmi'
	icon_override = 'icons/inventory/uniform/mob_vr.dmi'
	rolled_down_icon = 'icons/inventory/uniform/mob_vr_rolled_down.dmi'
	rolled_down_icon_override = FALSE
	icon_state = "pizzadelivery"
	item_state = "pizzadelivery"
	rolled_down = 0

//////////////////////TALON JUMPSUITS//////////////////////

/obj/item/clothing/under/rank/talon/basic
	name = "Talon jumpsuit"
	desc = "A basic jumpsuit that bares the ITV Talon logo on the breast."
	icon = 'icons/inventory/uniform/item_vr.dmi'
	rolled_down_icon = 'icons/inventory/uniform/mob_vr_rolled_down.dmi'
	icon_override = 'icons/inventory/uniform/mob_vr.dmi'
	icon_state = "talon_basic"
	item_state = "talon_basic"
	rolled_sleeves = 0
	rolled_down_icon_override = FALSE
	rolled_sleeves_icon_override = FALSE

/obj/item/clothing/under/rank/talon/proper
	name = "Talon proper jumpsuit"
	desc = "A neat and proper uniform for a proper private ship."
	icon = 'icons/inventory/uniform/item_vr.dmi'
	rolled_down_icon = 'icons/inventory/uniform/mob_vr_rolled_down.dmi'
	icon_override = 'icons/inventory/uniform/mob_vr.dmi'
	icon_state = "talon_jumpsuit"
	item_state = "talon_jumpsuit"
	rolled_sleeves = 0
	rolled_down_icon_override = FALSE
	rolled_sleeves_icon_override = FALSE

/obj/item/clothing/under/rank/talon/security
	name = "Talon security jumpsuit"
	desc = "A sleek, streamlined version of ITV Talon's standard jumpsuit that bares security markings."
	icon = 'icons/inventory/uniform/item_vr.dmi'
	rolled_down_icon = 'icons/inventory/uniform/mob_vr_rolled_down.dmi'
	icon_override = 'icons/inventory/uniform/mob_vr.dmi'
	icon_state = "talon_security"
	item_state = "talon_security"
	rolled_sleeves = 0
	rolled_down_icon_override = FALSE
	rolled_sleeves_icon_override = FALSE

/obj/item/clothing/under/rank/talon/pilot
	name = "Talon pilot jumpsuit"
	desc = "A sleek, streamlined version of ITV Talon's standard jumpsuit. Made from cushioned fabric to handle intense flight."
	icon = 'icons/inventory/uniform/item_vr.dmi'
	rolled_down_icon = 'icons/inventory/uniform/mob_vr_rolled_down.dmi'
	icon_override = 'icons/inventory/uniform/mob_vr.dmi'
	icon_state = "talon_pilot"
	item_state = "talon_pilot"
	rolled_sleeves = 0
	rolled_down_icon_override = FALSE
	rolled_sleeves_icon_override = FALSE

/obj/item/clothing/under/rank/talon/command
	name = "Talon command jumpsuit"
	desc = "A commanding jumpsuit fit for a commanding officer."
	icon = 'icons/inventory/uniform/item_vr.dmi'
	rolled_down_icon = 'icons/inventory/uniform/mob_vr_rolled_down.dmi'
	icon_override = 'icons/inventory/uniform/mob_vr.dmi'
	icon_state = "talon_captain"
	item_state = "talon_captain"
	rolled_sleeves = 0
	rolled_down_icon_override = FALSE
	rolled_sleeves_icon_override = FALSE

// Excelsior uniforms
/obj/item/clothing/under/excelsior
	name = "\improper Excelsior uniform"
	desc = "A uniform from a particular spaceship: Excelsior."

	icon = 'icons/inventory/uniform/item_vr.dmi'
	default_worn_icon = 'icons/inventory/uniform/mob_vr.dmi'
	icon_state = "excelsior_white"

/obj/item/clothing/under/excelsior/mixed
	icon_state = "excelsior_mixed"
/obj/item/clothing/under/excelsior/orange
	icon_state = "excelsior_orange"

// Summer dresses
/obj/item/clothing/under/summerdress
	name = "summer dress"
	desc = "A nice summer dress."

	icon = 'icons/inventory/uniform/item_vr.dmi'
	default_worn_icon = 'icons/inventory/uniform/mob_vr.dmi'
	icon_state = "summerdress"

/obj/item/clothing/under/summerdress/red
	icon_state = "summerdress3"
/obj/item/clothing/under/summerdress/blue
	icon_state = "summerdress2"

/obj/item/clothing/under/dress/dress_cap/femformal // formal in the loosest sense. because it's going to be taken off. or something. funnier in my head i swear
	name = "site manager's feminine formalwear"
	desc = "Essentially a skimpy...dress? Leotard? Whatever it is, it has the coloration and markings suitable for a site manager or rough equivalent."
	icon = 'icons/inventory/uniform/item_vr.dmi'
	default_worn_icon = 'icons/inventory/uniform/mob_vr.dmi'
	icon_state = "lewdcap"
	item_state = "lewdcap"
	rolled_sleeves = -1
	rolled_down = -1
	body_parts_covered = UPPER_TORSO // frankly this thing's a fucking embarassment

/obj/item/clothing/under/undersuit // undersuits! intended for wearing under hardsuits or for being too lazy to not wear anything other than it
	name = "undersuit"
	desc = "A nondescript undersuit, intended for wearing under a voidsuit or other EVA equipment. Breathable, yet sleek."
	icon = 'icons/inventory/uniform/item_vr.dmi'
	default_worn_icon = 'icons/inventory/uniform/mob_vr.dmi'
	rolled_down_icon = 'icons/inventory/uniform/mob_vr_rolled_down.dmi'
	icon_state = "bodysuit"
	item_state = "bodysuit"
	rolled_sleeves = -1
	rolled_down_icon_override = FALSE

/obj/item/clothing/under/undersuit/eva
	name = "EVA undersuit"
	desc = "A nondescript undersuit, intended for wearing under a voidsuit or other EVA equipment. This one is specifically made for EVA usage, but differs little from the standard."
	icon_state = "bodysuit_eva"
	item_state = "bodysuit_eva"

/obj/item/clothing/under/undersuit/command
	name = "command undersuit"
	desc = "A fancy undersuit, intended for wearing under a voidsuit or other EVA equipment. This one is specifically made for those in Command, and comes with a swanky gold trim and navy blue inlay."
	icon_state = "bodysuit_com"
	item_state = "bodysuit_com"

/obj/item/clothing/under/undersuit/sec
	name = "security undersuit"
	desc = "A reinforced undersuit, intended for wearing under a voidsuit or other EVA equipment. This one is specifically made for those in Security, and has slight protective capabilities against simple melee attacks."
	armor = list(melee = 10, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 0, rad = 0)
	siemens_coefficient = 0.9
	icon_state = "bodysuit_sec"
	item_state = "bodysuit_sec"

/obj/item/clothing/under/undersuit/sec/hos
	name = "security command undersuit"
	desc = "A reinforced undersuit, intended for wearing under a voidsuit or other EVA equipment. This one is specifically made for the Head of Security or equivalent, and has slight protective capabilities against simple melee attacks."
	icon_state = "bodysuit_seccom"
	item_state = "bodysuit_seccom"

/obj/item/clothing/under/undersuit/hazard
	name = "hazard undersuit"
	desc = "An undersuit, intended for wearing under a voidsuit or other EVA equipment. This one is specifically made for Engineering crew, and comes with slight radiation absorption capabilities. Not a lot, but it's there."
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 0, rad = 10)
	icon_state = "bodysuit_haz"
	item_state = "bodysuit_haz"

/obj/item/clothing/under/undersuit/mining
	name = "mining undersuit"
	desc = "An undersuit, intended for wearing under a voidsuit or other EVA equipment. This one is specifically made for Mining crew, and comes with an interestingly colored trim."
	icon_state = "bodysuit_min"
	item_state = "bodysuit_min"

/obj/item/clothing/under/undersuit/emt
	name = "medical technician undersuit"
	desc = "An undersuit, intended for wearing under a voidsuit or other EVA equipment. This one is specifically made for Medical response crew, and comes with a distinctive coloring scheme."
	icon_state = "bodysuit_emt"
	item_state = "bodysuit_emt"

/obj/item/clothing/under/undersuit/explo
	name = "exploration undersuit"
	desc = "An undersuit, intended for wearing under a voidsuit or other EVA equipment. This one is specifically made for Exploration crew, for hazardous environments."
	icon_state = "bodysuit_exp"
	item_state = "bodysuit_exp"

/obj/item/clothing/under/undersuit/centcom
	name = "Central Command undersuit"
	desc = "A very descript undersuit, intended for wearing under a voidsuit or other EVA equipment. This one is specifically made for NanoTrasen Central Command officers, and comes with a swanky gold trim and other fancy markings."
	icon_state = "bodysuit_cent"
	item_state = "bodysuit_cent"


//FEMININE JUMPSUITS.
/obj/item/clothing/under/color/fjumpsuit //They won't see this so we can make it whatever we want.
	name = "blue feminine jumpsuit"
	desc = "It's very smart and in a ladies size!"
	icon = 'icons/inventory/uniform/item.dmi'
	default_worn_icon = 'icons/inventory/uniform/mob_vr.dmi'
	icon_state = "blue"	// In hand
	worn_state = "bluef"	// On mob

/obj/item/clothing/under/color/fjumpsuit/bluef
	name = "blue feminine jumpsuit"
	icon_state = "blue"
	worn_state = "bluef"
/obj/item/clothing/under/color/fjumpsuit/aquaf
	name = "aqua feminine jumpsuit"
	icon_state = "aqua"
	worn_state = "aquaf"
/obj/item/clothing/under/color/fjumpsuit/brownf
	name = "brown feminine jumpsuit"
	icon_state = "brown"
	worn_state = "brownf"
/obj/item/clothing/under/color/fjumpsuit/darkbluef
	name = "dark blue feminine jumpsuit"
	icon_state = "darkblue"
	worn_state = "darkbluef"
/obj/item/clothing/under/color/fjumpsuit/darkredf
	name = "dark red feminine jumpsuit"
	icon_state = "darkred"
	worn_state = "darkredf"
/obj/item/clothing/under/color/fjumpsuit/greenf
	name = "green feminine jumpsuit"
	icon_state = "green"
	worn_state = "greenf"
/obj/item/clothing/under/color/fjumpsuit/lightbluef
	name = "light blue feminine jumpsuit"
	icon_state = "lightblue"
	worn_state = "lightbluef"
/obj/item/clothing/under/color/fjumpsuit/lightbrownf
	name = "light brown feminine jumpsuit"
	icon_state = "lightbrown"
	worn_state = "lightbrownf"
/obj/item/clothing/under/color/fjumpsuit/lightgreenf
	name = "light green feminine jumpsuit"
	icon_state = "lightgreen"
	worn_state = "lightgreenf"
/obj/item/clothing/under/color/fjumpsuit/lightpurplef
	name = "light purple feminine jumpsuit"
	icon_state = "lightpurple"
	worn_state = "lightpurplef"
/obj/item/clothing/under/color/fjumpsuit/lightredf
	name = "light red feminine jumpsuit"
	icon_state = "lightred"
	worn_state = "lightredf"
/obj/item/clothing/under/color/fjumpsuit/maroonf
	name = "maroon feminine jumpsuit"
	icon_state = "maroon"
	worn_state = "maroonf"
/obj/item/clothing/under/color/fjumpsuit/pinkf
	name = "pink feminine jumpsuit"
	icon_state = "pink"
	worn_state = "pinkf"
/obj/item/clothing/under/color/fjumpsuit/purplef
	name = "purple feminine jumpsuit"
	icon_state = "purple"
	worn_state = "purplef"
/obj/item/clothing/under/color/fjumpsuit/redf
	name = "red feminine jumpsuit"
	icon_state = "red"
	worn_state = "redf"
/obj/item/clothing/under/color/fjumpsuit/yellowf
	name = "yellow feminine jumpsuit"
	icon_state = "yellow"
	worn_state = "yellowf"
/obj/item/clothing/under/color/fjumpsuit/yellowgreenf
	name = "yellow-green feminine jumpsuit"
	icon_state = "yellowgreen"
	worn_state = "yellowgreenf"
