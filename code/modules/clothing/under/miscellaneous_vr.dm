/obj/item/clothing/under/customs
	desc = "A standard SolCom customs uniform. Complete with epaulettes."

/obj/item/clothing/var/hides_bulges = FALSE // OwO wats this?

/obj/item/clothing/under/permit
	name = "public nudity permit"
	desc = "This permit entitles the bearer to conduct their duties without a uniform. Normally issued to furred crewmembers or those with nothing to hide."
	icon = 'icons/obj/card.dmi'
	icon_state = "guest"
	body_parts_covered = 0
	equip_sound = null

	sprite_sheets = list()

	item_state = "golem"  //This is dumb and hacky but was here when I got here.
	worn_state = "golem"  //It's basically just a coincidentally black iconstate in the file.

/obj/item/clothing/under/hyperfiber
	name = "HYPER jumpsuit"
	icon = 'icons/obj/clothing/uniforms_vr.dmi'
	icon_override = 'icons/mob/uniform_vr.dmi'
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
		..()

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
	..()

/obj/item/clothing/under/hyperfiber/bluespace/proc/bluespace_size(mob/usr as mob)
	if (!ishuman(usr))
		return

	var/mob/living/carbon/human/H = usr

	if (H.stat || H.restrained())
		return

	if (src != H.w_uniform)
		to_chat(H,"<span class='warning'>You must be WEARING the uniform to change your size.</span>")
		return

	var/new_size = input("Put the desired size (25-200%), or (1-600%) in dormitory areas.", "Set Size", 200) as num|null
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
			H.resize(new_size/100, ignore_prefs = TRUE) // Ignores prefs because you can only resize yourself
			H.visible_message("<span class='warning'>The space around [H] distorts as they change size!</span>","<span class='notice'>The space around you distorts as you change size!</span>")
		else //They chose their current size.
			return

/obj/item/clothing/under/hyperfiber/bluespace/mob_can_unequip(mob/M, slot, disable_warning = 0)
	. = ..()
	if(. && ishuman(M) && original_size)
		var/mob/living/carbon/human/H = M
		H.resize(original_size, ignore_prefs = TRUE)
		original_size = null
		H.visible_message("<span class='warning'>The space around [H] distorts as they return to their original size!</span>","<span class='notice'>The space around you distorts as you return to your original size!</span>")

//Same as Nanotrasen Security Uniforms
/obj/item/clothing/under/ert
	armor = list(melee = 5, bullet = 10, laser = 10, energy = 5, bomb = 5, bio = 0, rad = 0)

/obj/item/clothing/under/dress/qipao
	name = "qipao"
	desc = "A type of feminine body-hugging dress with distinctive Chinese features of Manchu origin."
	icon = 'icons/obj/clothing/uniforms_vr.dmi'
	icon_override = 'icons/mob/uniform_vr.dmi'
	icon_state = "qipao"
	item_state = "qipao"

/obj/item/clothing/under/dress/qipao/white
	name = "white qipao"
	icon_state = "qipao_white"
	item_state = "qipao_white"

/obj/item/clothing/under/dress/qipao/red
	name = "red qipao"
	icon_state = "qipao_red"
	item_state = "qipao_red"
